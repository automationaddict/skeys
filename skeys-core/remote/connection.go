// Copyright (c) 2025 John Nelson
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

// Package remote provides SSH remote connection management.
package remote

import (
	"context"
	"fmt"
	"net"
	"os"
	"strings"
	"sync"
	"time"

	"github.com/automationaddict/skeys-core/logging"
	"github.com/pkg/sftp"
	"golang.org/x/crypto/ssh"
	"golang.org/x/crypto/ssh/agent"
)

// Connection represents an active SSH connection
type Connection struct {
	ID             string
	RemoteID       string // ID of the stored remote server config, if any
	Host           string
	Port           int
	User           string
	ServerVersion  string
	ConnectedAt    time.Time
	LastActivityAt time.Time
	KeyFingerprint string // Fingerprint of the key used for this connection (for key presence tracking)

	client       *ssh.Client
	sftpClient   *sftp.Client
	mu           sync.Mutex
	agentSocket  string // Agent socket for key presence checks
	stopKeyCheck chan struct{}
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
	AgentSocket    string // Path to SSH agent socket for agent-based auth
	KeyFingerprint string // Fingerprint of specific key to use from agent (optional)
	TrustHostKey   bool   // If true and host is unknown, add to known_hosts before connecting
}

// ConnectionPool manages a pool of SSH connections
type ConnectionPool struct {
	connections map[string]*Connection
	mu          sync.RWMutex
	config      PoolConfig
	log         *logging.Logger
	watcher     *connectionsWatcher
	watcherMu   sync.Mutex
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
		"max_connections":     config.MaxConnections,
		"max_idle_time":       config.MaxIdleTime.String(),
		"keep_alive_interval": config.KeepAliveInterval.String(),
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

	// Build auth methods
	var authMethods []ssh.AuthMethod
	var agentConn net.Conn

	// Add direct key auth from raw bytes
	if len(cfg.PrivateKey) > 0 {
		var signer ssh.Signer
		var err error
		if len(cfg.Passphrase) > 0 {
			signer, err = ssh.ParsePrivateKeyWithPassphrase(cfg.PrivateKey, cfg.Passphrase)
		} else {
			signer, err = ssh.ParsePrivateKey(cfg.PrivateKey)
		}
		if err != nil {
			return nil, fmt.Errorf("failed to parse private key: %w", err)
		}
		authMethods = append(authMethods, ssh.PublicKeys(signer))
	}

	// Add direct key auth from file path
	if cfg.PrivateKeyPath != "" {
		keyBytes, err := os.ReadFile(cfg.PrivateKeyPath)
		if err != nil {
			return nil, fmt.Errorf("failed to read private key file: %w", err)
		}
		var signer ssh.Signer
		if len(cfg.Passphrase) > 0 {
			signer, err = ssh.ParsePrivateKeyWithPassphrase(keyBytes, cfg.Passphrase)
		} else {
			signer, err = ssh.ParsePrivateKey(keyBytes)
		}
		if err != nil {
			return nil, fmt.Errorf("failed to parse private key: %w", err)
		}
		authMethods = append(authMethods, ssh.PublicKeys(signer))
	}

	// Add SSH agent auth
	if cfg.AgentSocket != "" {
		conn, err := net.Dial("unix", cfg.AgentSocket)
		if err == nil {
			agentConn = conn
			agentClient := agent.NewClient(conn)
			// If a specific fingerprint is requested, filter to only that key
			if cfg.KeyFingerprint != "" {
				authMethods = append(authMethods, ssh.PublicKeysCallback(func() ([]ssh.Signer, error) {
					return filterSignersByFingerprint(agentClient, cfg.KeyFingerprint)
				}))
			} else {
				authMethods = append(authMethods, ssh.PublicKeysCallback(agentClient.Signers))
			}
		}
	}

	if len(authMethods) == 0 {
		if agentConn != nil {
			agentConn.Close()
		}
		return nil, fmt.Errorf("no authentication methods available - load key into agent or provide key file")
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
	if agentConn != nil {
		agentConn.Close()
	}
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
		KeyFingerprint: cfg.KeyFingerprint,
		client:         client,
		agentSocket:    cfg.AgentSocket,
		stopKeyCheck:   make(chan struct{}),
	}

	// Start keep-alive
	go conn.keepAlive(p.config.KeepAliveInterval)

	// Start key presence checker if we have a fingerprint to track
	if cfg.KeyFingerprint != "" && cfg.AgentSocket != "" {
		go p.watchKeyPresence(conn)
	}

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

// watchKeyPresence monitors if the key used for a connection is still in the agent
// and auto-disconnects when the key is removed
func (p *ConnectionPool) watchKeyPresence(conn *Connection) {
	ticker := time.NewTicker(5 * time.Second)
	defer ticker.Stop()

	for {
		select {
		case <-conn.stopKeyCheck:
			return
		case <-ticker.C:
			if !p.isKeyInAgent(conn.agentSocket, conn.KeyFingerprint) {
				p.log.InfoWithFields("key removed from agent, disconnecting", map[string]interface{}{
					"connection_id":   conn.ID,
					"key_fingerprint": conn.KeyFingerprint,
				})
				// Key is gone, disconnect
				_ = p.Disconnect(conn.ID)
				return
			}
		}
	}
}

// isKeyInAgent checks if a key with the given fingerprint is present in the agent
func (p *ConnectionPool) isKeyInAgent(agentSocket, fingerprint string) bool {
	if agentSocket == "" || fingerprint == "" {
		return true // No fingerprint tracking, assume present
	}

	conn, err := net.Dial("unix", agentSocket)
	if err != nil {
		return false // Can't connect to agent, consider key gone
	}
	defer conn.Close()

	agentClient := agent.NewClient(conn)
	keys, err := agentClient.List()
	if err != nil {
		return false
	}

	for _, key := range keys {
		fp := ssh.FingerprintSHA256(key)
		if fp == fingerprint {
			return true
		}
	}

	return false
}

// Close closes the connection
func (c *Connection) Close() error {
	c.mu.Lock()
	defer c.mu.Unlock()

	// Signal key check goroutine to stop
	if c.stopKeyCheck != nil {
		select {
		case <-c.stopKeyCheck:
			// Already closed
		default:
			close(c.stopKeyCheck)
		}
	}

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

// TestResult contains the result of a connection test
type TestResult struct {
	Success       bool
	Message       string
	ServerVersion string
	LatencyMs     int64
	HostKeyStatus HostKeyStatus
	HostKeyInfo   *HostKeyInfo
}

// TestConnection tests SSH connectivity to a host with real authentication
// and proper host key verification.
//
// The host key verification flow is:
// 1. Check if host is in known_hosts
// 2. If unknown and TrustHostKey=false, return HostKeyStatusUnknown (caller should prompt user)
// 3. If unknown and TrustHostKey=true, add to known_hosts and proceed
// 4. If mismatch (possible MITM), return HostKeyStatusMismatch and refuse to connect
// 5. If verified, proceed with connection
func TestConnection(ctx context.Context, cfg ConnectionConfig) (*TestResult, error) {
	if cfg.Port == 0 {
		cfg.Port = 22
	}
	if cfg.Timeout == 0 {
		cfg.Timeout = 10 * time.Second
	}

	// Create host key verifier
	verifier, err := NewHostKeyVerifier()
	if err != nil {
		return &TestResult{
			Success: false,
			Message: fmt.Sprintf("failed to initialize host key verifier: %v", err),
		}, nil
	}

	// Check host key status first
	hostKeyStatus, hostKeyInfo, err := verifier.CheckHostKey(ctx, cfg.Host, cfg.Port)
	if err != nil {
		return &TestResult{
			Success: false,
			Message: fmt.Sprintf("failed to check host key: %v", err),
		}, nil
	}

	// Handle host key status
	switch hostKeyStatus {
	case HostKeyStatusMismatch:
		// Host key changed - possible MITM attack, refuse to connect
		return &TestResult{
			Success:       false,
			Message:       "WARNING: Remote host identification has changed! This could indicate a man-in-the-middle attack.",
			HostKeyStatus: HostKeyStatusMismatch,
			HostKeyInfo:   hostKeyInfo,
		}, nil

	case HostKeyStatusUnknown:
		if !cfg.TrustHostKey {
			// Host is unknown and user hasn't approved - return status for UI to prompt
			return &TestResult{
				Success:       false,
				Message:       fmt.Sprintf("Host '%s' is not in known_hosts. Verify the fingerprint before connecting.", cfg.Host),
				HostKeyStatus: HostKeyStatusUnknown,
				HostKeyInfo:   hostKeyInfo,
			}, nil
		}
		// User approved - add to known_hosts
		if hostKeyInfo != nil {
			if err := verifier.AddHostKey(cfg.Host, cfg.Port, hostKeyInfo.KeyType, hostKeyInfo.PublicKey); err != nil {
				return &TestResult{
					Success: false,
					Message: fmt.Sprintf("failed to add host key to known_hosts: %v", err),
				}, nil
			}
			hostKeyStatus = HostKeyStatusAdded
		}

	case HostKeyStatusVerified:
		// Host key verified, proceed with connection
	}

	// Now proceed with actual SSH authentication
	var authMethods []ssh.AuthMethod
	var agentConn net.Conn
	var keyNeedsPassphrase bool // Track if key parsing failed due to passphrase

	// IMPORTANT: When a specific key file is provided (PrivateKey or PrivateKeyPath),
	// we try direct key auth FIRST. This ensures that when testing a connection to
	// add a key to the agent, we use the specific key being added, not whatever
	// keys happen to be in the agent already.

	// Add direct key auth FIRST if key bytes provided
	if len(cfg.PrivateKey) > 0 {
		var signer ssh.Signer
		var parseErr error
		if len(cfg.Passphrase) > 0 {
			signer, parseErr = ssh.ParsePrivateKeyWithPassphrase(cfg.PrivateKey, cfg.Passphrase)
		} else {
			signer, parseErr = ssh.ParsePrivateKey(cfg.PrivateKey)
		}
		if parseErr != nil {
			// Check if it's a passphrase error - don't fail immediately if agent auth is available
			if strings.Contains(parseErr.Error(), "this private key is passphrase protected") ||
				strings.Contains(parseErr.Error(), "decryption password") {
				keyNeedsPassphrase = true
			} else {
				return &TestResult{
					Success:       false,
					Message:       fmt.Sprintf("failed to parse private key: %v", parseErr),
					HostKeyStatus: hostKeyStatus,
					HostKeyInfo:   hostKeyInfo,
				}, nil
			}
		}
		if signer != nil {
			authMethods = append(authMethods, ssh.PublicKeys(signer))
		}
	}

	// Load key from file FIRST if path provided (priority over agent)
	if cfg.PrivateKeyPath != "" {
		keyBytes, readErr := os.ReadFile(cfg.PrivateKeyPath)
		if readErr != nil {
			return &TestResult{
				Success:       false,
				Message:       fmt.Sprintf("failed to read private key file: %v", readErr),
				HostKeyStatus: hostKeyStatus,
				HostKeyInfo:   hostKeyInfo,
			}, nil
		}
		var signer ssh.Signer
		var parseErr error
		if len(cfg.Passphrase) > 0 {
			signer, parseErr = ssh.ParsePrivateKeyWithPassphrase(keyBytes, cfg.Passphrase)
		} else {
			signer, parseErr = ssh.ParsePrivateKey(keyBytes)
		}
		if parseErr != nil {
			// Check if it's a passphrase error - don't fail immediately if agent auth is available
			if strings.Contains(parseErr.Error(), "this private key is passphrase protected") ||
				strings.Contains(parseErr.Error(), "decryption password") {
				keyNeedsPassphrase = true
			} else {
				return &TestResult{
					Success:       false,
					Message:       fmt.Sprintf("failed to parse private key: %v", parseErr),
					HostKeyStatus: hostKeyStatus,
					HostKeyInfo:   hostKeyInfo,
				}, nil
			}
		}
		if signer != nil {
			authMethods = append(authMethods, ssh.PublicKeys(signer))
		}
	}

	// Add agent auth as FALLBACK only if:
	// 1. No direct key auth succeeded (authMethods is empty or key needed passphrase)
	// 2. Agent socket is provided
	// This prevents agent keys from interfering when testing a specific key
	if cfg.AgentSocket != "" && (len(authMethods) == 0 || keyNeedsPassphrase) {
		conn, dialErr := net.Dial("unix", cfg.AgentSocket)
		if dialErr == nil {
			agentConn = conn
			agentClient := agent.NewClient(conn)
			authMethods = append(authMethods, ssh.PublicKeysCallback(agentClient.Signers))
		}
	}

	// If key needs passphrase and we have no auth methods, fail with helpful message
	if keyNeedsPassphrase && len(authMethods) == 0 {
		return &TestResult{
			Success:       false,
			Message:       "private key is passphrase protected - load key into agent or provide passphrase",
			HostKeyStatus: hostKeyStatus,
			HostKeyInfo:   hostKeyInfo,
		}, nil
	}

	if len(authMethods) == 0 {
		if agentConn != nil {
			agentConn.Close()
		}
		return &TestResult{
			Success:       false,
			Message:       "no authentication methods available - load key into agent or provide key file",
			HostKeyStatus: hostKeyStatus,
			HostKeyInfo:   hostKeyInfo,
		}, nil
	}

	// Create host key callback that properly verifies against known_hosts
	hostKeyCallback, err := verifier.CreateHostKeyCallback(false)
	if err != nil {
		if agentConn != nil {
			agentConn.Close()
		}
		return &TestResult{
			Success:       false,
			Message:       fmt.Sprintf("failed to create host key callback: %v", err),
			HostKeyStatus: hostKeyStatus,
			HostKeyInfo:   hostKeyInfo,
		}, nil
	}

	// Build SSH client config with proper host key verification
	sshConfig := &ssh.ClientConfig{
		User:            cfg.User,
		Auth:            authMethods,
		HostKeyCallback: hostKeyCallback,
		Timeout:         cfg.Timeout,
	}

	// Dial SSH connection
	addr := fmt.Sprintf("%s:%d", cfg.Host, cfg.Port)
	start := time.Now()
	client, err := ssh.Dial("tcp", addr, sshConfig)
	latency := time.Since(start).Milliseconds()

	if agentConn != nil {
		agentConn.Close()
	}

	if err != nil {
		msg := err.Error()
		// Make common errors more user-friendly
		if strings.Contains(msg, "unable to authenticate") || strings.Contains(msg, "no supported methods remain") {
			msg = "authentication failed - key may not be registered with the server"
		} else if strings.Contains(msg, "connection refused") {
			msg = "connection refused - server may be down or port may be blocked"
		} else if strings.Contains(msg, "i/o timeout") || strings.Contains(msg, "deadline exceeded") {
			msg = "connection timed out - server may be unreachable"
		}
		return &TestResult{
			Success:       false,
			Message:       msg,
			LatencyMs:     latency,
			HostKeyStatus: hostKeyStatus,
			HostKeyInfo:   hostKeyInfo,
		}, nil
	}
	defer client.Close()

	serverVersion := string(client.ServerVersion())
	message := "Authentication successful"

	// Try to get server message (GitHub/GitLab sends "Hi username!")
	session, err := client.NewSession()
	if err == nil {
		// Run empty command to get server response
		output, _ := session.CombinedOutput("")
		session.Close()
		if len(output) > 0 {
			// Parse output for service-specific messages
			outStr := strings.TrimSpace(string(output))
			// Only use the output if it looks like a friendly greeting
			// GitHub: "Hi username! You've successfully authenticated..."
			// GitLab: "Welcome to GitLab, @username!"
			// Skip error-like messages (Invalid command, etc.)
			if strings.HasPrefix(outStr, "Hi ") || strings.Contains(outStr, "Welcome") ||
				strings.Contains(outStr, "successfully authenticated") {
				// Extract just the first line for cleaner display
				if idx := strings.Index(outStr, "\n"); idx > 0 {
					message = outStr[:idx]
				} else {
					message = outStr
				}
			}
		}
	}

	return &TestResult{
		Success:       true,
		Message:       message,
		ServerVersion: serverVersion,
		LatencyMs:     latency,
		HostKeyStatus: hostKeyStatus,
		HostKeyInfo:   hostKeyInfo,
	}, nil
}

// filterSignersByFingerprint returns only signers from the agent that match the given fingerprint
func filterSignersByFingerprint(agentClient agent.ExtendedAgent, fingerprint string) ([]ssh.Signer, error) {
	signers, err := agentClient.Signers()
	if err != nil {
		return nil, err
	}

	var filtered []ssh.Signer
	for _, signer := range signers {
		// Get fingerprint of this signer's public key (SHA256)
		fp := ssh.FingerprintSHA256(signer.PublicKey())
		if fp == fingerprint {
			filtered = append(filtered, signer)
			break // Found the matching key
		}
	}

	if len(filtered) == 0 {
		return nil, fmt.Errorf("key with fingerprint %s not found in agent", fingerprint)
	}

	return filtered, nil
}
