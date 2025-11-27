// Package sshconfig manages the skeys integration with ~/.ssh/config
package sshconfig

import (
	"bufio"
	"fmt"
	"os"
	"path/filepath"
	"strings"

	"github.com/johnnelson/skeys-core/logging"
)

const (
	beginMarker = "# BEGIN skeys managed block"
	endMarker   = "# END skeys managed block"
)

// Manager handles skeys SSH config integration
type Manager struct {
	configPath  string
	agentSocket string
	log         *logging.Logger
}

// ManagerOption is a functional option for Manager
type ManagerOption func(*Manager)

// WithManagerLogger sets a custom logger
func WithManagerLogger(log *logging.Logger) ManagerOption {
	return func(m *Manager) {
		m.log = log
	}
}

// WithConfigPath sets a custom config path
func WithConfigPath(path string) ManagerOption {
	return func(m *Manager) {
		m.configPath = path
	}
}

// WithAgentSocket sets the agent socket path
func WithAgentSocket(socket string) ManagerOption {
	return func(m *Manager) {
		m.agentSocket = socket
	}
}

// NewManager creates a new SSH config manager
func NewManager(opts ...ManagerOption) (*Manager, error) {
	homeDir, err := os.UserHomeDir()
	if err != nil {
		return nil, fmt.Errorf("failed to get home directory: %w", err)
	}

	// Default agent socket path
	uid := os.Getuid()
	defaultSocket := fmt.Sprintf("/run/user/%d/skeys-agent.sock", uid)

	m := &Manager{
		configPath:  filepath.Join(homeDir, ".ssh", "config"),
		agentSocket: defaultSocket,
		log:         logging.Nop(),
	}

	for _, opt := range opts {
		opt(m)
	}

	m.log.InfoWithFields("initialized SSH config manager", map[string]interface{}{
		"config_path":  m.configPath,
		"agent_socket": m.agentSocket,
	})

	return m, nil
}

// IsEnabled checks if the skeys managed block exists in ~/.ssh/config
func (m *Manager) IsEnabled() (bool, error) {
	m.log.Debug("checking if skeys SSH config is enabled")

	content, err := m.readConfig()
	if err != nil {
		if os.IsNotExist(err) {
			return false, nil
		}
		return false, err
	}

	enabled := strings.Contains(content, beginMarker)
	m.log.DebugWithFields("skeys SSH config status", map[string]interface{}{
		"enabled": enabled,
	})

	return enabled, nil
}

// Enable adds the skeys managed block to ~/.ssh/config
func (m *Manager) Enable() error {
	m.log.Info("enabling skeys SSH config integration")

	// Check if already enabled
	enabled, err := m.IsEnabled()
	if err != nil {
		return err
	}
	if enabled {
		m.log.Info("skeys SSH config already enabled")
		return nil
	}

	// Ensure .ssh directory exists
	sshDir := filepath.Dir(m.configPath)
	if err := os.MkdirAll(sshDir, 0700); err != nil {
		m.log.ErrWithFields(err, "failed to create .ssh directory", map[string]interface{}{
			"ssh_dir": sshDir,
		})
		return fmt.Errorf("failed to create .ssh directory: %w", err)
	}

	// Read existing content
	content, err := m.readConfig()
	if err != nil && !os.IsNotExist(err) {
		return err
	}

	// Build the managed block
	block := m.buildManagedBlock()

	// Prepend the block (so it takes priority over other Host * entries)
	var newContent string
	if content == "" {
		newContent = block
	} else {
		newContent = block + "\n" + content
	}

	// Write back
	if err := m.writeConfig(newContent); err != nil {
		return err
	}

	m.log.Info("skeys SSH config integration enabled")
	return nil
}

// Disable removes the skeys managed block from ~/.ssh/config
func (m *Manager) Disable() error {
	m.log.Info("disabling skeys SSH config integration")

	content, err := m.readConfig()
	if err != nil {
		if os.IsNotExist(err) {
			return nil
		}
		return err
	}

	// Remove the managed block
	newContent, changed := m.removeManagedBlock(content)
	if !changed {
		m.log.Info("skeys SSH config was not enabled")
		return nil
	}

	// Write back
	if err := m.writeConfig(newContent); err != nil {
		return err
	}

	m.log.Info("skeys SSH config integration disabled")
	return nil
}

// GetAgentSocket returns the configured agent socket path
func (m *Manager) GetAgentSocket() string {
	return m.agentSocket
}

// buildManagedBlock creates the config block content
func (m *Manager) buildManagedBlock() string {
	return fmt.Sprintf(`%s
Host *
    IdentityAgent %s
%s`, beginMarker, m.agentSocket, endMarker)
}

// removeManagedBlock removes the managed block from content
func (m *Manager) removeManagedBlock(content string) (string, bool) {
	lines := strings.Split(content, "\n")
	var result []string
	inBlock := false
	changed := false

	for _, line := range lines {
		if strings.TrimSpace(line) == beginMarker {
			inBlock = true
			changed = true
			continue
		}
		if strings.TrimSpace(line) == endMarker {
			inBlock = false
			continue
		}
		if !inBlock {
			result = append(result, line)
		}
	}

	// Clean up leading empty lines
	for len(result) > 0 && strings.TrimSpace(result[0]) == "" {
		result = result[1:]
	}

	return strings.Join(result, "\n"), changed
}

// readConfig reads the SSH config file
func (m *Manager) readConfig() (string, error) {
	data, err := os.ReadFile(m.configPath)
	if err != nil {
		return "", err
	}
	return string(data), nil
}

// writeConfig writes the SSH config file with backup
func (m *Manager) writeConfig(content string) error {
	// Create backup if file exists
	if _, err := os.Stat(m.configPath); err == nil {
		backupPath := m.configPath + ".skeys.bak"
		m.log.DebugWithFields("creating backup", map[string]interface{}{
			"backup_path": backupPath,
		})

		data, err := os.ReadFile(m.configPath)
		if err != nil {
			return fmt.Errorf("failed to read config for backup: %w", err)
		}
		if err := os.WriteFile(backupPath, data, 0600); err != nil {
			return fmt.Errorf("failed to write backup: %w", err)
		}
	}

	// Write the new content
	if err := os.WriteFile(m.configPath, []byte(content), 0600); err != nil {
		m.log.ErrWithFields(err, "failed to write config", map[string]interface{}{
			"config_path": m.configPath,
		})
		return fmt.Errorf("failed to write config: %w", err)
	}

	return nil
}

// ValidateConfig performs basic validation of the SSH config
func (m *Manager) ValidateConfig() error {
	m.log.Debug("validating SSH config")

	content, err := m.readConfig()
	if err != nil {
		if os.IsNotExist(err) {
			return nil // No config is valid
		}
		return err
	}

	// Basic syntax check - ensure no unclosed blocks
	scanner := bufio.NewScanner(strings.NewReader(content))
	lineNum := 0
	for scanner.Scan() {
		lineNum++
		line := strings.TrimSpace(scanner.Text())

		// Skip comments and empty lines
		if line == "" || strings.HasPrefix(line, "#") {
			continue
		}

		// Check for valid key=value or key value format
		parts := strings.Fields(line)
		if len(parts) < 2 && !strings.HasPrefix(strings.ToLower(line), "host") && !strings.HasPrefix(strings.ToLower(line), "match") {
			m.log.WarnWithFields("potentially invalid config line", map[string]interface{}{
				"line_number": lineNum,
				"content":     line,
			})
		}
	}

	return scanner.Err()
}
