// Package hosts provides management for known_hosts and authorized_keys files.
package hosts

import (
	"bufio"
	"bytes"
	"context"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"sync"

	"github.com/johnnelson/skeys-core/executor"
	"github.com/johnnelson/skeys-core/logging"
)

// KnownHost represents an entry in known_hosts
type KnownHost struct {
	ID          string
	Hostnames   []string
	KeyType     string
	Fingerprint string
	PublicKey   string
	IsHashed    bool
	IsRevoked   bool
	IsCertAuth  bool
	LineNumber  int
}

// KnownHostsManager manages the known_hosts file
type KnownHostsManager struct {
	path      string
	executor  executor.Executor
	log       *logging.Logger
	watcher   *knownHostsWatcher
	watcherMu sync.Mutex
}

// KnownHostsOption is a functional option
type KnownHostsOption func(*KnownHostsManager)

// WithKnownHostsPath sets a custom known_hosts path
func WithKnownHostsPath(path string) KnownHostsOption {
	return func(m *KnownHostsManager) {
		m.path = path
	}
}

// WithKnownHostsExecutor sets a custom executor
func WithKnownHostsExecutor(exec executor.Executor) KnownHostsOption {
	return func(m *KnownHostsManager) {
		m.executor = exec
	}
}

// WithKnownHostsLogger sets a custom logger
func WithKnownHostsLogger(log *logging.Logger) KnownHostsOption {
	return func(m *KnownHostsManager) {
		m.log = log
	}
}

// NewKnownHostsManager creates a new known_hosts manager
func NewKnownHostsManager(opts ...KnownHostsOption) (*KnownHostsManager, error) {
	homeDir, err := os.UserHomeDir()
	if err != nil {
		return nil, fmt.Errorf("failed to get home directory: %w", err)
	}

	m := &KnownHostsManager{
		path:     filepath.Join(homeDir, ".ssh", "known_hosts"),
		executor: &defaultExecutor{},
		log:      logging.Nop(),
	}

	for _, opt := range opts {
		opt(m)
	}

	m.log.InfoWithFields("known_hosts manager initialized", map[string]interface{}{
		"path": m.path,
	})

	return m, nil
}

// List returns all entries in known_hosts
func (m *KnownHostsManager) List() ([]*KnownHost, error) {
	m.log.Debug("listing known_hosts entries")

	f, err := os.Open(m.path)
	if os.IsNotExist(err) {
		m.log.Debug("known_hosts file does not exist")
		return []*KnownHost{}, nil
	}
	if err != nil {
		m.log.ErrWithFields(err, "failed to open known_hosts", map[string]interface{}{
			"path": m.path,
		})
		return nil, fmt.Errorf("failed to open known_hosts: %w", err)
	}
	defer f.Close()

	var hosts []*KnownHost
	scanner := bufio.NewScanner(f)
	lineNum := 0

	for scanner.Scan() {
		lineNum++
		line := strings.TrimSpace(scanner.Text())

		// Skip empty lines and comments
		if line == "" || strings.HasPrefix(line, "#") {
			continue
		}

		host := m.parseLine(line, lineNum)
		if host != nil {
			hosts = append(hosts, host)
		}
	}

	if err := scanner.Err(); err != nil {
		m.log.Err(err, "error scanning known_hosts")
		return nil, err
	}

	m.log.InfoWithFields("listed known_hosts entries", map[string]interface{}{
		"count": len(hosts),
	})

	return hosts, nil
}

// parseLine parses a single known_hosts line
func (m *KnownHostsManager) parseLine(line string, lineNum int) *KnownHost {
	host := &KnownHost{
		LineNumber: lineNum,
	}

	parts := strings.Fields(line)
	if len(parts) < 3 {
		return nil
	}

	idx := 0

	// Check for markers
	if parts[0] == "@revoked" {
		host.IsRevoked = true
		idx++
	} else if parts[0] == "@cert-authority" {
		host.IsCertAuth = true
		idx++
	}

	if len(parts) <= idx+2 {
		return nil
	}

	// Parse hostnames
	hostnames := parts[idx]
	host.IsHashed = strings.HasPrefix(hostnames, "|1|")
	if host.IsHashed {
		host.Hostnames = []string{"[hashed]"}
	} else {
		host.Hostnames = strings.Split(hostnames, ",")
	}

	host.KeyType = parts[idx+1]
	host.PublicKey = parts[idx+2]
	host.ID = fmt.Sprintf("%d", lineNum)

	return host
}

// Lookup finds entries for a specific host
func (m *KnownHostsManager) Lookup(ctx context.Context, hostname string) ([]*KnownHost, error) {
	m.log.DebugWithFields("looking up host in known_hosts", map[string]interface{}{
		"hostname": hostname,
	})

	args := []string{"-F", hostname, "-f", m.path}

	output, err := m.executor.Run(ctx, "ssh-keygen", args...)
	if err != nil {
		// Exit code 1 means not found
		m.log.DebugWithFields("host not found in known_hosts", map[string]interface{}{
			"hostname": hostname,
		})
		return []*KnownHost{}, nil
	}

	var hosts []*KnownHost
	lines := strings.Split(string(output), "\n")

	for _, line := range lines {
		line = strings.TrimSpace(line)
		if line == "" || strings.HasPrefix(line, "#") {
			continue
		}

		host := m.parseLine(line, 0)
		if host != nil {
			hosts = append(hosts, host)
		}
	}

	m.log.InfoWithFields("lookup completed", map[string]interface{}{
		"hostname": hostname,
		"count":    len(hosts),
	})

	return hosts, nil
}

// Remove removes a host from known_hosts
func (m *KnownHostsManager) Remove(ctx context.Context, hostname string) error {
	m.log.InfoWithFields("removing host from known_hosts", map[string]interface{}{
		"hostname": hostname,
	})

	args := []string{"-R", hostname, "-f", m.path}

	_, err := m.executor.Run(ctx, "ssh-keygen", args...)
	if err != nil {
		m.log.ErrWithFields(err, "failed to remove host", map[string]interface{}{
			"hostname": hostname,
		})
		return fmt.Errorf("failed to remove host: %w", err)
	}

	// Clean up the .old backup file created by ssh-keygen
	os.Remove(m.path + ".old")

	m.log.InfoWithFields("host removed from known_hosts", map[string]interface{}{
		"hostname": hostname,
	})

	return nil
}

// Hash hashes all hostnames in known_hosts
func (m *KnownHostsManager) Hash(ctx context.Context) error {
	m.log.Info("hashing known_hosts file")

	args := []string{"-H", "-f", m.path}

	_, err := m.executor.Run(ctx, "ssh-keygen", args...)
	if err != nil {
		m.log.Err(err, "failed to hash known_hosts")
		return fmt.Errorf("failed to hash known_hosts: %w", err)
	}

	// Clean up the .old backup file
	os.Remove(m.path + ".old")

	m.log.Info("known_hosts file hashed successfully")

	return nil
}

// ScannedKey represents a host key discovered via scanning
type ScannedKey struct {
	Hostname    string
	Port        int
	KeyType     string
	PublicKey   string
	Fingerprint string
}

// ScanHostKeys scans a host and retrieves its public keys
func (m *KnownHostsManager) ScanHostKeys(ctx context.Context, hostname string, port int, timeoutSecs int) ([]*ScannedKey, error) {
	if port <= 0 {
		port = 22
	}
	if timeoutSecs <= 0 {
		timeoutSecs = 10
	}

	m.log.InfoWithFields("scanning host keys", map[string]interface{}{
		"hostname": hostname,
		"port":     port,
		"timeout":  timeoutSecs,
	})

	// Build ssh-keyscan arguments
	args := []string{
		"-T", fmt.Sprintf("%d", timeoutSecs),
	}
	if port != 22 {
		args = append(args, "-p", fmt.Sprintf("%d", port))
	}
	args = append(args, hostname)

	output, err := m.executor.Run(ctx, "ssh-keyscan", args...)
	if err != nil {
		m.log.ErrWithFields(err, "failed to scan host keys", map[string]interface{}{
			"hostname": hostname,
			"port":     port,
		})
		return nil, fmt.Errorf("failed to scan host keys: %w", err)
	}

	var keys []*ScannedKey
	lines := strings.Split(string(output), "\n")

	for _, line := range lines {
		line = strings.TrimSpace(line)
		if line == "" || strings.HasPrefix(line, "#") {
			continue
		}

		parts := strings.Fields(line)
		if len(parts) < 3 {
			continue
		}

		key := &ScannedKey{
			Hostname:  parts[0],
			Port:      port,
			KeyType:   parts[1],
			PublicKey: parts[2],
		}

		// Calculate fingerprint using ssh-keygen
		fingerprint, fpErr := m.calculateFingerprint(ctx, line)
		if fpErr == nil {
			key.Fingerprint = fingerprint
		}

		keys = append(keys, key)
	}

	m.log.InfoWithFields("host keys scanned", map[string]interface{}{
		"hostname": hostname,
		"port":     port,
		"count":    len(keys),
	})

	return keys, nil
}

// calculateFingerprint calculates the fingerprint for a known_hosts line
func (m *KnownHostsManager) calculateFingerprint(ctx context.Context, line string) (string, error) {
	// Create a temp file with the line
	tmpFile, err := os.CreateTemp("", "skeys-fp-*")
	if err != nil {
		return "", err
	}
	defer os.Remove(tmpFile.Name())

	if _, err := tmpFile.WriteString(line + "\n"); err != nil {
		tmpFile.Close()
		return "", err
	}
	tmpFile.Close()

	// Get fingerprint using ssh-keygen
	output, err := m.executor.Run(ctx, "ssh-keygen", "-l", "-f", tmpFile.Name())
	if err != nil {
		return "", err
	}

	// Output format: "256 SHA256:xxxxx hostname (ED25519)"
	parts := strings.Fields(string(output))
	if len(parts) >= 2 {
		return parts[1], nil
	}

	return "", fmt.Errorf("failed to parse fingerprint")
}

// Add adds a new host key to known_hosts
func (m *KnownHostsManager) Add(ctx context.Context, hostname string, port int, keyType, publicKey string, hashHostname bool) (*KnownHost, error) {
	m.log.InfoWithFields("adding host key to known_hosts", map[string]interface{}{
		"hostname": hostname,
		"port":     port,
		"key_type": keyType,
		"hash":     hashHostname,
	})

	// Format the hostname (with port if non-standard)
	hostEntry := hostname
	if port != 0 && port != 22 {
		hostEntry = fmt.Sprintf("[%s]:%d", hostname, port)
	}

	// Create the line to add
	line := fmt.Sprintf("%s %s %s\n", hostEntry, keyType, publicKey)

	// If hashing is requested, create temp file and hash it
	if hashHostname {
		tmpFile, err := os.CreateTemp("", "skeys-add-*")
		if err != nil {
			return nil, fmt.Errorf("failed to create temp file: %w", err)
		}
		tmpPath := tmpFile.Name()
		defer os.Remove(tmpPath)
		defer os.Remove(tmpPath + ".old")

		if _, err := tmpFile.WriteString(line); err != nil {
			tmpFile.Close()
			return nil, fmt.Errorf("failed to write temp file: %w", err)
		}
		tmpFile.Close()

		// Hash the temp file
		_, err = m.executor.Run(ctx, "ssh-keygen", "-H", "-f", tmpPath)
		if err != nil {
			return nil, fmt.Errorf("failed to hash hostname: %w", err)
		}

		// Read the hashed line
		hashedContent, err := os.ReadFile(tmpPath)
		if err != nil {
			return nil, fmt.Errorf("failed to read hashed file: %w", err)
		}
		line = string(hashedContent)
	}

	// Ensure .ssh directory exists
	dir := filepath.Dir(m.path)
	if err := os.MkdirAll(dir, 0700); err != nil {
		return nil, fmt.Errorf("failed to create .ssh directory: %w", err)
	}

	// Append to known_hosts
	f, err := os.OpenFile(m.path, os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0600)
	if err != nil {
		m.log.ErrWithFields(err, "failed to open known_hosts for writing", map[string]interface{}{
			"path": m.path,
		})
		return nil, fmt.Errorf("failed to open known_hosts: %w", err)
	}
	defer f.Close()

	if _, err := f.WriteString(line); err != nil {
		m.log.Err(err, "failed to write to known_hosts")
		return nil, fmt.Errorf("failed to write to known_hosts: %w", err)
	}

	m.log.InfoWithFields("host key added to known_hosts", map[string]interface{}{
		"hostname": hostname,
		"key_type": keyType,
	})

	// Return the added entry
	hosts, _ := m.List()
	if len(hosts) > 0 {
		return hosts[len(hosts)-1], nil
	}

	return &KnownHost{
		Hostnames: []string{hostEntry},
		KeyType:   keyType,
		PublicKey: publicKey,
		IsHashed:  hashHostname,
	}, nil
}

// defaultExecutor is the default command executor
type defaultExecutor struct{}

// Run executes a command and returns the output
func (e *defaultExecutor) Run(ctx context.Context, name string, args ...string) ([]byte, error) {
	// Validate command is in allowlist
	allowedCommands := map[string]bool{
		"ssh-keygen":  true,
		"ssh-keyscan": true,
	}

	if !allowedCommands[name] {
		return nil, fmt.Errorf("command not allowed: %s", name)
	}

	cmd := exec.CommandContext(ctx, name, args...)

	var stdout, stderr bytes.Buffer
	cmd.Stdout = &stdout
	cmd.Stderr = &stderr

	err := cmd.Run()
	if err != nil {
		return nil, fmt.Errorf("%w: %s", err, stderr.String())
	}

	return stdout.Bytes(), nil
}
