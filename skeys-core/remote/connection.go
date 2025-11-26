// Package remote provides SSH remote connection management.
package remote

import (
	"context"
	"fmt"
	"net"
	"sync"
	"time"

	"github.com/johnnelson/skeys-core/logging"
	"github.com/pkg/sftp"
	"golang.org/x/crypto/ssh"
)

// Connection represents an active SSH connection
type Connection struct {
	ID             string
	Host           string
	Port           int
	User           string
	ServerVersion  string
	ConnectedAt    time.Time
	LastActivityAt time.Time

	client     *ssh.Client
	sftpClient *sftp.Client
	mu         sync.Mutex
}

// ConnectionConfig holds configuration for a connection
type ConnectionConfig struct {
	Host           string
	Port           int
	User           string
	PrivateKey     []byte
	PrivateKeyPath string
	Passphrase     []byte
	Timeout        time.Duration
}

// ConnectionPool manages a pool of SSH connections
type ConnectionPool struct {
	connections map[string]*Connection
	mu          sync.RWMutex
	config      PoolConfig
	log         *logging.Logger
}

// PoolOption is a functional option for configuring the pool
type PoolOption func(*ConnectionPool)

// WithPoolLogger sets a custom logger
func WithPoolLogger(log *logging.Logger) PoolOption {
	return func(p *ConnectionPool) {
		p.log = log
	}
}

// PoolConfig configures the connection pool
type PoolConfig struct {
	MaxIdleTime       time.Duration
	MaxConnections    int
	KeepAliveInterval time.Duration
}

// NewConnectionPool creates a new connection pool
func NewConnectionPool(config PoolConfig, opts ...PoolOption) *ConnectionPool {
	if config.MaxIdleTime == 0 {
		config.MaxIdleTime = 10 * time.Minute
	}
	if config.MaxConnections == 0 {
		config.MaxConnections = 10
	}
	if config.KeepAliveInterval == 0 {
		config.KeepAliveInterval = 30 * time.Second
	}

	pool := &ConnectionPool{
		connections: make(map[string]*Connection),
		config:      config,
		log:         logging.Nop(),
	}

	for _, opt := range opts {
		opt(pool)
	}

	pool.log.InfoWithFields("connection pool initialized", map[string]interface{}{
		"max_connections":      config.MaxConnections,
		"max_idle_time":        config.MaxIdleTime.String(),
		"keep_alive_interval":  config.KeepAliveInterval.String(),
	})

	// Start cleanup goroutine
	go pool.cleanup()

	return pool
}

// Connect establishes a new SSH connection
func (p *ConnectionPool) Connect(ctx context.Context, cfg ConnectionConfig) (*Connection, error) {
	key := fmt.Sprintf("%s@%s:%d", cfg.User, cfg.Host, cfg.Port)

	p.mu.Lock()
	defer p.mu.Unlock()

	// Check for existing connection
	if conn, ok := p.connections[key]; ok {
		if conn.isHealthy() {
			conn.LastActivityAt = time.Now()
			return conn, nil
		}
		// Close unhealthy connection
		conn.Close()
		delete(p.connections, key)
	}

	// Check pool limit
	if len(p.connections) >= p.config.MaxConnections {
		return nil, fmt.Errorf("connection pool limit reached")
	}

	// Create new connection
	conn, err := p.dial(ctx, cfg)
	if err != nil {
		return nil, err
	}

	p.connections[key] = conn
	return conn, nil
}

// dial creates a new SSH connection
func (p *ConnectionPool) dial(ctx context.Context, cfg ConnectionConfig) (*Connection, error) {
	if cfg.Port == 0 {
		cfg.Port = 22
	}
	if cfg.Timeout == 0 {
		cfg.Timeout = 30 * time.Second
	}

	// Parse private key
	var signer ssh.Signer
	var err error

	if len(cfg.PrivateKey) > 0 {
		if len(cfg.Passphrase) > 0 {
			signer, err = ssh.ParsePrivateKeyWithPassphrase(cfg.PrivateKey, cfg.Passphrase)
		} else {
			signer, err = ssh.ParsePrivateKey(cfg.PrivateKey)
		}
		if err != nil {
			return nil, fmt.Errorf("failed to parse private key: %w", err)
		}
	}

	// Build auth methods
	var authMethods []ssh.AuthMethod
	if signer != nil {
		authMethods = append(authMethods, ssh.PublicKeys(signer))
	}

	// Build client config
	sshConfig := &ssh.ClientConfig{
		User:            cfg.User,
		Auth:            authMethods,
		HostKeyCallback: ssh.InsecureIgnoreHostKey(), // TODO: Use known_hosts
		Timeout:         cfg.Timeout,
	}

	// Dial
	addr := fmt.Sprintf("%s:%d", cfg.Host, cfg.Port)
	client, err := ssh.Dial("tcp", addr, sshConfig)
	if err != nil {
		return nil, fmt.Errorf("failed to connect: %w", err)
	}

	now := time.Now()
	conn := &Connection{
		ID:             generateID(),
		Host:           cfg.Host,
		Port:           cfg.Port,
		User:           cfg.User,
		ServerVersion:  string(client.ServerVersion()),
		ConnectedAt:    now,
		LastActivityAt: now,
		client:         client,
	}

	// Start keep-alive
	go conn.keepAlive(p.config.KeepAliveInterval)

	return conn, nil
}

// Disconnect closes a connection
func (p *ConnectionPool) Disconnect(id string) error {
	p.mu.Lock()
	defer p.mu.Unlock()

	for key, conn := range p.connections {
		if conn.ID == id {
			conn.Close()
			delete(p.connections, key)
			return nil
		}
	}

	return fmt.Errorf("connection not found: %s", id)
}

// Get returns a connection by ID
func (p *ConnectionPool) Get(id string) (*Connection, error) {
	p.mu.RLock()
	defer p.mu.RUnlock()

	for _, conn := range p.connections {
		if conn.ID == id {
			return conn, nil
		}
	}

	return nil, fmt.Errorf("connection not found: %s", id)
}

// List returns all active connections
func (p *ConnectionPool) List() []*Connection {
	p.mu.RLock()
	defer p.mu.RUnlock()

	var conns []*Connection
	for _, conn := range p.connections {
		conns = append(conns, conn)
	}
	return conns
}

// cleanup periodically removes idle connections
func (p *ConnectionPool) cleanup() {
	ticker := time.NewTicker(time.Minute)
	defer ticker.Stop()

	for range ticker.C {
		p.mu.Lock()
		for key, conn := range p.connections {
			if time.Since(conn.LastActivityAt) > p.config.MaxIdleTime {
				conn.Close()
				delete(p.connections, key)
			}
		}
		p.mu.Unlock()
	}
}

// Close closes the connection
func (c *Connection) Close() error {
	c.mu.Lock()
	defer c.mu.Unlock()

	if c.sftpClient != nil {
		c.sftpClient.Close()
	}
	if c.client != nil {
		return c.client.Close()
	}
	return nil
}

// isHealthy checks if the connection is still alive
func (c *Connection) isHealthy() bool {
	c.mu.Lock()
	defer c.mu.Unlock()

	if c.client == nil {
		return false
	}

	// Try to create a session as a health check
	session, err := c.client.NewSession()
	if err != nil {
		return false
	}
	session.Close()

	return true
}

// keepAlive sends periodic keep-alive messages
func (c *Connection) keepAlive(interval time.Duration) {
	ticker := time.NewTicker(interval)
	defer ticker.Stop()

	for range ticker.C {
		c.mu.Lock()
		if c.client == nil {
			c.mu.Unlock()
			return
		}

		_, _, err := c.client.SendRequest("keepalive@openssh.com", true, nil)
		if err != nil {
			c.mu.Unlock()
			return
		}
		c.mu.Unlock()
	}
}

// Execute runs a command on the remote server
func (c *Connection) Execute(ctx context.Context, command string) ([]byte, []byte, error) {
	c.mu.Lock()
	defer c.mu.Unlock()

	c.LastActivityAt = time.Now()

	session, err := c.client.NewSession()
	if err != nil {
		return nil, nil, fmt.Errorf("failed to create session: %w", err)
	}
	defer session.Close()

	var stdout, stderr []byte
	stdoutPipe, _ := session.StdoutPipe()
	stderrPipe, _ := session.StderrPipe()

	if err := session.Start(command); err != nil {
		return nil, nil, fmt.Errorf("failed to start command: %w", err)
	}

	// Read output
	done := make(chan error, 1)
	go func() {
		stdout, _ = readAll(stdoutPipe)
		stderr, _ = readAll(stderrPipe)
		done <- session.Wait()
	}()

	select {
	case <-ctx.Done():
		session.Signal(ssh.SIGTERM)
		return nil, nil, ctx.Err()
	case err := <-done:
		return stdout, stderr, err
	}
}

// SFTP returns an SFTP client for file operations
func (c *Connection) SFTP() (*sftp.Client, error) {
	c.mu.Lock()
	defer c.mu.Unlock()

	if c.sftpClient != nil {
		return c.sftpClient, nil
	}

	client, err := sftp.NewClient(c.client)
	if err != nil {
		return nil, fmt.Errorf("failed to create SFTP client: %w", err)
	}

	c.sftpClient = client
	return client, nil
}

// readAll reads all data from a reader
func readAll(r interface{ Read([]byte) (int, error) }) ([]byte, error) {
	var data []byte
	buf := make([]byte, 1024)
	for {
		n, err := r.Read(buf)
		if n > 0 {
			data = append(data, buf[:n]...)
		}
		if err != nil {
			break
		}
	}
	return data, nil
}

// generateID generates a unique connection ID
func generateID() string {
	return fmt.Sprintf("%d", time.Now().UnixNano())
}

// TestConnection tests connectivity to a host without storing the connection
func TestConnection(ctx context.Context, cfg ConnectionConfig) error {
	if cfg.Port == 0 {
		cfg.Port = 22
	}
	if cfg.Timeout == 0 {
		cfg.Timeout = 10 * time.Second
	}

	// First, test TCP connectivity
	dialer := net.Dialer{Timeout: cfg.Timeout}
	conn, err := dialer.DialContext(ctx, "tcp", fmt.Sprintf("%s:%d", cfg.Host, cfg.Port))
	if err != nil {
		return fmt.Errorf("TCP connection failed: %w", err)
	}
	conn.Close()

	return nil
}
