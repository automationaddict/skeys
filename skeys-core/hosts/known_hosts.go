// Package hosts provides management for known_hosts and authorized_keys files.
package hosts

import (
	"bufio"
	"context"
	"fmt"
	"os"
	"path/filepath"
	"strings"

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

// Executor interface for running commands
type Executor interface {
	Run(ctx context.Context, name string, args ...string) ([]byte, error)
}

// KnownHostsManager manages the known_hosts file
type KnownHostsManager struct {
	path     string
	executor Executor
	log      *logging.Logger
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
func WithKnownHostsExecutor(exec Executor) KnownHostsOption {
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

// defaultExecutor is the default command executor
type defaultExecutor struct{}

func (e *defaultExecutor) Run(ctx context.Context, name string, args ...string) ([]byte, error) {
	// Import from keys package or use shared executor
	// For now, duplicate the logic
	return nil, fmt.Errorf("not implemented")
}
