// Package agent provides SSH agent management functionality.
package agent

import (
	"context"
	"fmt"
	"net"
	"os"
	"strings"

	"github.com/johnnelson/skeys-core/logging"
	"golang.org/x/crypto/ssh"
	"golang.org/x/crypto/ssh/agent"
)

// AgentKey represents a key loaded in the SSH agent
type AgentKey struct {
	Fingerprint     string
	Comment         string
	Type            string
	Bits            int
	HasLifetime     bool
	LifetimeSeconds int
	IsConfirm       bool
}

// AgentStatus represents the status of the SSH agent
type AgentStatus struct {
	Running    bool
	SocketPath string
	IsLocked   bool
	KeyCount   int
}

// Service manages the SSH agent
type Service struct {
	socketPath string
	log        *logging.Logger
}

// ServiceOption is a functional option
type ServiceOption func(*Service)

// WithSocketPath sets a custom agent socket path
func WithSocketPath(path string) ServiceOption {
	return func(s *Service) {
		s.socketPath = path
	}
}

// WithLogger sets a custom logger
func WithLogger(log *logging.Logger) ServiceOption {
	return func(s *Service) {
		s.log = log
	}
}

// NewService creates a new agent service
func NewService(opts ...ServiceOption) *Service {
	s := &Service{
		socketPath: os.Getenv("SSH_AUTH_SOCK"),
		log:        logging.Nop(),
	}

	for _, opt := range opts {
		opt(s)
	}

	s.log.InfoWithFields("agent service initialized", map[string]interface{}{
		"socket_path": s.socketPath,
	})

	return s
}

// Status returns the agent status
func (s *Service) Status() (*AgentStatus, error) {
	s.log.Debug("checking agent status")

	status := &AgentStatus{
		SocketPath: s.socketPath,
	}

	if s.socketPath == "" {
		s.log.Warn("SSH_AUTH_SOCK not set")
		return status, nil
	}

	// Check if socket exists
	info, err := os.Stat(s.socketPath)
	if err != nil {
		s.log.DebugWithFields("socket does not exist", map[string]interface{}{
			"socket_path": s.socketPath,
			"error":       err.Error(),
		})
		return status, nil
	}

	// Verify it's a socket
	if info.Mode()&os.ModeSocket == 0 {
		s.log.Warn("path is not a socket")
		return status, nil
	}

	// Try to connect
	conn, err := net.Dial("unix", s.socketPath)
	if err != nil {
		s.log.ErrWithFields(err, "failed to connect to agent socket", map[string]interface{}{
			"socket_path": s.socketPath,
		})
		return status, nil
	}
	defer conn.Close()

	status.Running = true

	// Get key count
	agentClient := agent.NewClient(conn)
	keys, err := agentClient.List()
	if err != nil {
		// Might be locked
		if strings.Contains(err.Error(), "locked") {
			s.log.Info("agent is locked")
			status.IsLocked = true
		} else {
			s.log.Err(err, "failed to list agent keys")
		}
		return status, nil
	}

	status.KeyCount = len(keys)
	s.log.DebugWithFields("agent status retrieved", map[string]interface{}{
		"running":   status.Running,
		"locked":    status.IsLocked,
		"key_count": status.KeyCount,
	})

	return status, nil
}

// ListKeys returns all keys loaded in the agent
func (s *Service) ListKeys() ([]*AgentKey, error) {
	s.log.Debug("listing agent keys")

	conn, err := s.connect()
	if err != nil {
		return nil, err
	}
	defer conn.Close()

	agentClient := agent.NewClient(conn)
	keys, err := agentClient.List()
	if err != nil {
		s.log.Err(err, "failed to list keys from agent")
		return nil, fmt.Errorf("failed to list keys: %w", err)
	}

	var result []*AgentKey
	for _, key := range keys {
		result = append(result, &AgentKey{
			Fingerprint: ssh.FingerprintSHA256(key),
			Comment:     key.Comment,
			Type:        key.Type(),
			Bits:        getBits(key),
		})
	}

	s.log.DebugWithFields("listed agent keys", map[string]interface{}{
		"count": len(result),
	})

	return result, nil
}

// AddKey adds a key to the agent
func (s *Service) AddKey(privateKey interface{}, comment string, lifetimeSecs uint32, confirm bool) error {
	s.log.InfoWithFields("adding key to agent", map[string]interface{}{
		"comment":       comment,
		"lifetime_secs": lifetimeSecs,
		"confirm":       confirm,
	})

	conn, err := s.connect()
	if err != nil {
		return err
	}
	defer conn.Close()

	agentClient := agent.NewClient(conn)

	addedKey := agent.AddedKey{
		PrivateKey:       privateKey,
		Comment:          comment,
		LifetimeSecs:     lifetimeSecs,
		ConfirmBeforeUse: confirm,
	}

	if err := agentClient.Add(addedKey); err != nil {
		s.log.Err(err, "failed to add key to agent")
		return err
	}

	s.log.Info("key added to agent successfully")
	return nil
}

// RemoveKey removes a key from the agent
func (s *Service) RemoveKey(publicKey ssh.PublicKey) error {
	s.log.InfoWithFields("removing key from agent", map[string]interface{}{
		"fingerprint": ssh.FingerprintSHA256(publicKey),
	})

	conn, err := s.connect()
	if err != nil {
		return err
	}
	defer conn.Close()

	agentClient := agent.NewClient(conn)
	if err := agentClient.Remove(publicKey); err != nil {
		s.log.Err(err, "failed to remove key from agent")
		return err
	}

	s.log.Info("key removed from agent successfully")
	return nil
}

// RemoveAll removes all keys from the agent
func (s *Service) RemoveAll() error {
	s.log.Info("removing all keys from agent")

	conn, err := s.connect()
	if err != nil {
		return err
	}
	defer conn.Close()

	agentClient := agent.NewClient(conn)
	if err := agentClient.RemoveAll(); err != nil {
		s.log.Err(err, "failed to remove all keys from agent")
		return err
	}

	s.log.Info("all keys removed from agent")
	return nil
}

// Lock locks the agent with a passphrase
func (s *Service) Lock(passphrase []byte) error {
	s.log.Info("locking agent")

	conn, err := s.connect()
	if err != nil {
		return err
	}
	defer conn.Close()

	agentClient := agent.NewClient(conn)
	if err := agentClient.Lock(passphrase); err != nil {
		s.log.Err(err, "failed to lock agent")
		return err
	}

	s.log.Info("agent locked successfully")
	return nil
}

// Unlock unlocks the agent
func (s *Service) Unlock(passphrase []byte) error {
	s.log.Info("unlocking agent")

	conn, err := s.connect()
	if err != nil {
		return err
	}
	defer conn.Close()

	agentClient := agent.NewClient(conn)
	if err := agentClient.Unlock(passphrase); err != nil {
		s.log.Err(err, "failed to unlock agent")
		return err
	}

	s.log.Info("agent unlocked successfully")
	return nil
}

// connect establishes a connection to the agent
func (s *Service) connect() (net.Conn, error) {
	if s.socketPath == "" {
		s.log.Error("SSH_AUTH_SOCK not set")
		return nil, fmt.Errorf("SSH_AUTH_SOCK not set")
	}

	conn, err := net.Dial("unix", s.socketPath)
	if err != nil {
		s.log.ErrWithFields(err, "failed to connect to agent", map[string]interface{}{
			"socket_path": s.socketPath,
		})
		return nil, fmt.Errorf("failed to connect to agent: %w", err)
	}

	return conn, nil
}

// ListLoadedFingerprints returns fingerprints of all keys loaded in the agent.
// This method implements the keys.AgentChecker interface.
func (s *Service) ListLoadedFingerprints() ([]string, error) {
	s.log.Debug("listing loaded fingerprints")

	conn, err := s.connect()
	if err != nil {
		return nil, err
	}
	defer conn.Close()

	agentClient := agent.NewClient(conn)
	keys, err := agentClient.List()
	if err != nil {
		s.log.Err(err, "failed to list keys from agent")
		return nil, fmt.Errorf("failed to list keys: %w", err)
	}

	var fingerprints []string
	for _, key := range keys {
		fingerprints = append(fingerprints, ssh.FingerprintSHA256(key))
	}

	s.log.DebugWithFields("listed loaded fingerprints", map[string]interface{}{
		"count": len(fingerprints),
	})

	return fingerprints, nil
}

// RemoveKeyByFingerprint removes a key from the agent by its fingerprint.
// This method implements the keys.AgentChecker interface.
func (s *Service) RemoveKeyByFingerprint(fingerprint string) error {
	s.log.InfoWithFields("removing key from agent by fingerprint", map[string]interface{}{
		"fingerprint": fingerprint,
	})

	conn, err := s.connect()
	if err != nil {
		return err
	}
	defer conn.Close()

	agentClient := agent.NewClient(conn)
	keys, err := agentClient.List()
	if err != nil {
		s.log.Err(err, "failed to list keys from agent")
		return fmt.Errorf("failed to list keys: %w", err)
	}

	// Find the key with matching fingerprint
	for _, key := range keys {
		if ssh.FingerprintSHA256(key) == fingerprint {
			if err := agentClient.Remove(key); err != nil {
				s.log.ErrWithFields(err, "failed to remove key from agent", map[string]interface{}{
					"fingerprint": fingerprint,
				})
				return fmt.Errorf("failed to remove key: %w", err)
			}
			s.log.InfoWithFields("key removed from agent", map[string]interface{}{
				"fingerprint": fingerprint,
			})
			return nil
		}
	}

	// Key not found in agent - not an error, just means it wasn't loaded
	s.log.DebugWithFields("key not found in agent", map[string]interface{}{
		"fingerprint": fingerprint,
	})
	return nil
}

// getBits returns the key size in bits
func getBits(key *agent.Key) int {
	// This is approximate based on key type
	switch key.Type() {
	case "ssh-rsa":
		return len(key.Marshal()) * 8 / 3 // Rough estimate
	case "ssh-ed25519":
		return 256
	case "ecdsa-sha2-nistp256":
		return 256
	case "ecdsa-sha2-nistp384":
		return 384
	case "ecdsa-sha2-nistp521":
		return 521
	default:
		return 0
	}
}

// CLIExecutor wraps ssh-add commands for operations that need passphrase prompts
type CLIExecutor struct {
	executor CommandExecutor
	log      *logging.Logger
}

// CommandExecutor is the interface for running commands
type CommandExecutor interface {
	Run(ctx context.Context, name string, args ...string) ([]byte, error)
}

// NewCLIExecutor creates a new CLI executor
func NewCLIExecutor(exec CommandExecutor, opts ...func(*CLIExecutor)) *CLIExecutor {
	e := &CLIExecutor{
		executor: exec,
		log:      logging.Nop(),
	}
	for _, opt := range opts {
		opt(e)
	}
	return e
}

// WithCLILogger sets a logger for the CLI executor
func WithCLILogger(log *logging.Logger) func(*CLIExecutor) {
	return func(e *CLIExecutor) {
		e.log = log
	}
}

// AddKeyFromFile adds a key from a file path (handles passphrase prompts)
func (e *CLIExecutor) AddKeyFromFile(ctx context.Context, keyPath string, lifetimeSecs int) error {
	e.log.InfoWithFields("adding key from file via ssh-add", map[string]interface{}{
		"key_path":      keyPath,
		"lifetime_secs": lifetimeSecs,
	})

	args := []string{}
	if lifetimeSecs > 0 {
		args = append(args, "-t", fmt.Sprintf("%d", lifetimeSecs))
	}
	args = append(args, keyPath)

	_, err := e.executor.Run(ctx, "ssh-add", args...)
	if err != nil {
		e.log.ErrWithFields(err, "ssh-add failed", map[string]interface{}{
			"key_path": keyPath,
		})
		return err
	}

	e.log.Info("key added via ssh-add successfully")
	return nil
}

// RemoveKeyFromFile removes a key by file path
func (e *CLIExecutor) RemoveKeyFromFile(ctx context.Context, keyPath string) error {
	e.log.InfoWithFields("removing key from file via ssh-add", map[string]interface{}{
		"key_path": keyPath,
	})

	_, err := e.executor.Run(ctx, "ssh-add", "-d", keyPath)
	if err != nil {
		e.log.ErrWithFields(err, "ssh-add -d failed", map[string]interface{}{
			"key_path": keyPath,
		})
		return err
	}

	e.log.Info("key removed via ssh-add successfully")
	return nil
}

// RemoveAllKeys removes all keys from the agent
func (e *CLIExecutor) RemoveAllKeys(ctx context.Context) error {
	e.log.Info("removing all keys via ssh-add -D")

	_, err := e.executor.Run(ctx, "ssh-add", "-D")
	if err != nil {
		e.log.Err(err, "ssh-add -D failed")
		return err
	}

	e.log.Info("all keys removed via ssh-add")
	return nil
}

// ListKeys lists all keys (returns fingerprint and comment)
func (e *CLIExecutor) ListKeys(ctx context.Context) ([]string, error) {
	e.log.Debug("listing keys via ssh-add -l")

	output, err := e.executor.Run(ctx, "ssh-add", "-l")
	if err != nil {
		// Exit code 1 means no identities
		if strings.Contains(string(output), "no identities") {
			e.log.Debug("no identities in agent")
			return []string{}, nil
		}
		e.log.Err(err, "ssh-add -l failed")
		return nil, err
	}

	var keys []string
	lines := strings.Split(string(output), "\n")
	for _, line := range lines {
		line = strings.TrimSpace(line)
		if line != "" {
			keys = append(keys, line)
		}
	}

	e.log.DebugWithFields("listed keys via ssh-add", map[string]interface{}{
		"count": len(keys),
	})

	return keys, nil
}
