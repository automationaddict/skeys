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

package config

import (
	"bufio"
	"context"
	"fmt"
	"os"
	"regexp"
	"strconv"
	"strings"

	"github.com/automationaddict/skeys-core/logging"
)

// ServerDirective represents a directive in sshd_config
type ServerDirective struct {
	Key         string
	Value       string
	LineNumber  int
	IsCommented bool
	MatchBlock  string // Non-empty if inside a Match block
}

// ServerConfig represents the sshd_config file
type ServerConfig struct {
	Directives []ServerDirective
	RawContent string
	Path       string
}

// PrivilegeExecutor runs commands with elevated privileges
type PrivilegeExecutor interface {
	ReadFile(ctx context.Context, path string) ([]byte, error)
	WriteFile(ctx context.Context, path string, data []byte) error
	Execute(ctx context.Context, name string, args ...string) ([]byte, error)
}

// ServerConfigManager manages the SSH server configuration
type ServerConfigManager struct {
	path     string
	privExec PrivilegeExecutor
	log      *logging.Logger
}

// ServerConfigOption is a functional option
type ServerConfigOption func(*ServerConfigManager)

// WithServerConfigPath sets a custom sshd_config path
func WithServerConfigPath(path string) ServerConfigOption {
	return func(m *ServerConfigManager) {
		m.path = path
	}
}

// WithPrivilegeExecutor sets the privilege executor
func WithPrivilegeExecutor(exec PrivilegeExecutor) ServerConfigOption {
	return func(m *ServerConfigManager) {
		m.privExec = exec
	}
}

// WithServerLogger sets a custom logger
func WithServerLogger(log *logging.Logger) ServerConfigOption {
	return func(m *ServerConfigManager) {
		m.log = log
	}
}

// NewServerConfigManager creates a new sshd_config manager
func NewServerConfigManager(opts ...ServerConfigOption) (*ServerConfigManager, error) {
	m := &ServerConfigManager{
		path: "/etc/ssh/sshd_config",
		log:  logging.Nop(),
	}

	for _, opt := range opts {
		opt(m)
	}

	m.log.InfoWithFields("server config manager initialized", map[string]interface{}{
		"config_path": m.path,
	})

	return m, nil
}

// Read parses the sshd_config file
func (m *ServerConfigManager) Read(ctx context.Context) (*ServerConfig, error) {
	var content []byte
	var err error

	if m.privExec != nil {
		content, err = m.privExec.ReadFile(ctx, m.path)
	} else {
		content, err = os.ReadFile(m.path)
	}

	if err != nil {
		return nil, fmt.Errorf("failed to read sshd_config: %w", err)
	}

	return m.parse(string(content))
}

// parse parses the sshd_config content
func (m *ServerConfigManager) parse(content string) (*ServerConfig, error) {
	config := &ServerConfig{
		RawContent: content,
		Path:       m.path,
	}

	scanner := bufio.NewScanner(strings.NewReader(content))
	lineNum := 0
	currentMatch := ""

	directiveRegex := regexp.MustCompile(`^(\w+)\s+(.+)$`)
	commentedRegex := regexp.MustCompile(`^#\s*(\w+)\s+(.+)$`)

	for scanner.Scan() {
		lineNum++
		line := strings.TrimSpace(scanner.Text())

		// Skip empty lines
		if line == "" {
			continue
		}

		// Check for Match block
		if strings.HasPrefix(strings.ToLower(line), "match ") {
			currentMatch = strings.TrimPrefix(line, "Match ")
			currentMatch = strings.TrimPrefix(currentMatch, "match ")
			continue
		}

		// Check for commented directive
		if matches := commentedRegex.FindStringSubmatch(line); matches != nil {
			config.Directives = append(config.Directives, ServerDirective{
				Key:         matches[1],
				Value:       matches[2],
				LineNumber:  lineNum,
				IsCommented: true,
				MatchBlock:  currentMatch,
			})
			continue
		}

		// Skip pure comments
		if strings.HasPrefix(line, "#") {
			continue
		}

		// Parse directive
		if matches := directiveRegex.FindStringSubmatch(line); matches != nil {
			config.Directives = append(config.Directives, ServerDirective{
				Key:        matches[1],
				Value:      matches[2],
				LineNumber: lineNum,
				MatchBlock: currentMatch,
			})
		}
	}

	return config, scanner.Err()
}

// GetDirective returns the value of a specific directive
func (c *ServerConfig) GetDirective(key string) (string, bool) {
	for _, d := range c.Directives {
		if strings.EqualFold(d.Key, key) && !d.IsCommented && d.MatchBlock == "" {
			return d.Value, true
		}
	}
	return "", false
}

// GetPort returns the SSH port(s)
func (c *ServerConfig) GetPort() []int {
	var ports []int
	for _, d := range c.Directives {
		if strings.EqualFold(d.Key, "Port") && !d.IsCommented {
			port, err := strconv.Atoi(d.Value)
			if err == nil {
				ports = append(ports, port)
			}
		}
	}
	if len(ports) == 0 {
		return []int{22} // Default
	}
	return ports
}

// GetBool returns a boolean directive value
func (c *ServerConfig) GetBool(key string) *bool {
	val, ok := c.GetDirective(key)
	if !ok {
		return nil
	}
	val = strings.ToLower(val)
	result := val == "yes"
	return &result
}

// Update updates a directive value
func (m *ServerConfigManager) Update(ctx context.Context, key, value string) error {
	config, err := m.Read(ctx)
	if err != nil {
		return err
	}

	newContent := m.updateDirective(config.RawContent, key, value)

	if m.privExec != nil {
		return m.privExec.WriteFile(ctx, m.path, []byte(newContent))
	}

	return os.WriteFile(m.path, []byte(newContent), 0644)
}

// updateDirective updates a directive in the raw content
func (m *ServerConfigManager) updateDirective(content, key, value string) string {
	lines := strings.Split(content, "\n")
	keyRegex := regexp.MustCompile(fmt.Sprintf(`(?i)^#?\s*%s\s+`, regexp.QuoteMeta(key)))
	found := false

	for i, line := range lines {
		if keyRegex.MatchString(line) {
			lines[i] = fmt.Sprintf("%s %s", key, value)
			found = true
			break
		}
	}

	if !found {
		lines = append(lines, fmt.Sprintf("%s %s", key, value))
	}

	return strings.Join(lines, "\n")
}

// Validate validates the sshd_config using sshd -t
func (m *ServerConfigManager) Validate(ctx context.Context) error {
	var output []byte
	var err error

	if m.privExec != nil {
		output, err = m.privExec.Execute(ctx, "sshd", "-t", "-f", m.path)
	} else {
		return fmt.Errorf("privilege executor required for validation")
	}

	if err != nil {
		return fmt.Errorf("validation failed: %s", string(output))
	}

	return nil
}

// RestartService restarts the SSH daemon
func (m *ServerConfigManager) RestartService(ctx context.Context, reloadOnly bool) error {
	if m.privExec == nil {
		return fmt.Errorf("privilege executor required")
	}

	action := "restart"
	if reloadOnly {
		action = "reload"
	}

	_, err := m.privExec.Execute(ctx, "systemctl", action, "sshd")
	return err
}
