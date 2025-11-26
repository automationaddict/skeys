// Package config provides SSH configuration management.
package config

import (
	"fmt"
	"os"
	"path/filepath"

	"github.com/johnnelson/skeys-core/logging"
	sshconfig "github.com/kevinburke/ssh_config"
)

// HostEntry represents a Host block in ~/.ssh/config
type HostEntry struct {
	Alias                  string
	Hostname               string
	User                   string
	Port                   int
	IdentityFiles          []string
	ProxyJump              string
	ProxyCommand           string
	ForwardAgent           bool
	IdentitiesOnly         bool
	StrictHostKeyChecking  string
	ServerAliveInterval    int
	ServerAliveCountMax    int
	ExtraOptions           map[string]string
	IsPattern              bool
	LineNumber             int
}

// ClientConfig manages the SSH client configuration file
type ClientConfig struct {
	path   string
	config *sshconfig.Config
	log    *logging.Logger
}

// ClientConfigOption is a functional option for ClientConfig
type ClientConfigOption func(*ClientConfig)

// WithConfigPath sets a custom config file path
func WithConfigPath(path string) ClientConfigOption {
	return func(c *ClientConfig) {
		c.path = path
	}
}

// WithClientLogger sets a custom logger
func WithClientLogger(log *logging.Logger) ClientConfigOption {
	return func(c *ClientConfig) {
		c.log = log
	}
}

// NewClientConfig creates a new SSH client config manager
func NewClientConfig(opts ...ClientConfigOption) (*ClientConfig, error) {
	homeDir, err := os.UserHomeDir()
	if err != nil {
		return nil, fmt.Errorf("failed to get home directory: %w", err)
	}

	c := &ClientConfig{
		path: filepath.Join(homeDir, ".ssh", "config"),
		log:  logging.Nop(),
	}

	for _, opt := range opts {
		opt(c)
	}

	c.log.InfoWithFields("initializing client config manager", map[string]interface{}{
		"config_path": c.path,
	})

	if err := c.load(); err != nil {
		c.log.Err(err, "failed to load config")
		return nil, err
	}

	c.log.Info("client config manager initialized")
	return c, nil
}

// load reads and parses the config file
func (c *ClientConfig) load() error {
	f, err := os.Open(c.path)
	if os.IsNotExist(err) {
		c.log.Debug("config file does not exist, creating empty config")
		c.config = &sshconfig.Config{}
		return nil
	}
	if err != nil {
		c.log.ErrWithFields(err, "failed to open config", map[string]interface{}{
			"config_path": c.path,
		})
		return fmt.Errorf("failed to open config: %w", err)
	}
	defer f.Close()

	cfg, err := sshconfig.Decode(f)
	if err != nil {
		c.log.Err(err, "failed to parse config")
		return fmt.Errorf("failed to parse config: %w", err)
	}

	c.config = cfg
	c.log.Debug("config loaded successfully")
	return nil
}

// List returns all host entries
func (c *ClientConfig) List() ([]*HostEntry, error) {
	c.log.Debug("listing host entries")

	var entries []*HostEntry

	for _, host := range c.config.Hosts {
		// Get patterns
		patterns := make([]string, 0, len(host.Patterns))
		for _, p := range host.Patterns {
			patterns = append(patterns, p.String())
		}

		// Skip wildcard-only entries for listing
		if len(patterns) == 1 && patterns[0] == "*" {
			continue
		}

		alias := patterns[0]
		entry := c.extractHostEntry(alias, host)
		entries = append(entries, entry)
	}

	c.log.InfoWithFields("listed host entries", map[string]interface{}{
		"count": len(entries),
	})

	return entries, nil
}

// Get returns the effective configuration for a host
func (c *ClientConfig) Get(alias string) (*HostEntry, error) {
	c.log.DebugWithFields("getting host entry", map[string]interface{}{
		"alias": alias,
	})

	// Use the library's Get function for effective config resolution
	return &HostEntry{
		Alias:               alias,
		Hostname:            sshconfig.Get(alias, "HostName"),
		User:                sshconfig.Get(alias, "User"),
		Port:                parsePort(sshconfig.Get(alias, "Port")),
		IdentityFiles:       sshconfig.GetAll(alias, "IdentityFile"),
		ProxyJump:           sshconfig.Get(alias, "ProxyJump"),
		ProxyCommand:        sshconfig.Get(alias, "ProxyCommand"),
		ForwardAgent:        sshconfig.Get(alias, "ForwardAgent") == "yes",
		ServerAliveInterval: parseInt(sshconfig.Get(alias, "ServerAliveInterval")),
		ServerAliveCountMax: parseInt(sshconfig.Get(alias, "ServerAliveCountMax")),
	}, nil
}

// Add adds a new host entry
func (c *ClientConfig) Add(entry *HostEntry) error {
	c.log.InfoWithFields("adding host entry", map[string]interface{}{
		"alias":    entry.Alias,
		"hostname": entry.Hostname,
		"user":     entry.User,
	})

	// Check for duplicate
	for _, h := range c.config.Hosts {
		for _, p := range h.Patterns {
			if p.String() == entry.Alias {
				c.log.WarnWithFields("host already exists", map[string]interface{}{
					"alias": entry.Alias,
				})
				return fmt.Errorf("host already exists: %s", entry.Alias)
			}
		}
	}

	pattern, err := sshconfig.NewPattern(entry.Alias)
	if err != nil {
		c.log.ErrWithFields(err, "invalid host pattern", map[string]interface{}{
			"alias": entry.Alias,
		})
		return fmt.Errorf("invalid host pattern: %w", err)
	}

	host := &sshconfig.Host{
		Patterns: []*sshconfig.Pattern{pattern},
		Nodes:    c.buildNodes(entry),
	}

	c.config.Hosts = append(c.config.Hosts, host)

	if err := c.save(); err != nil {
		return err
	}

	c.log.InfoWithFields("host entry added successfully", map[string]interface{}{
		"alias": entry.Alias,
	})
	return nil
}

// Update updates an existing host entry
func (c *ClientConfig) Update(alias string, entry *HostEntry) error {
	c.log.InfoWithFields("updating host entry", map[string]interface{}{
		"alias": alias,
	})

	for i, host := range c.config.Hosts {
		for _, p := range host.Patterns {
			if p.String() == alias {
				c.config.Hosts[i].Nodes = c.buildNodes(entry)

				if err := c.save(); err != nil {
					return err
				}

				c.log.InfoWithFields("host entry updated successfully", map[string]interface{}{
					"alias": alias,
				})
				return nil
			}
		}
	}

	c.log.WarnWithFields("host not found", map[string]interface{}{
		"alias": alias,
	})
	return fmt.Errorf("host not found: %s", alias)
}

// Delete removes a host entry
func (c *ClientConfig) Delete(alias string) error {
	c.log.InfoWithFields("deleting host entry", map[string]interface{}{
		"alias": alias,
	})

	for i, host := range c.config.Hosts {
		for _, p := range host.Patterns {
			if p.String() == alias {
				c.config.Hosts = append(c.config.Hosts[:i], c.config.Hosts[i+1:]...)

				if err := c.save(); err != nil {
					return err
				}

				c.log.InfoWithFields("host entry deleted successfully", map[string]interface{}{
					"alias": alias,
				})
				return nil
			}
		}
	}

	c.log.WarnWithFields("host not found", map[string]interface{}{
		"alias": alias,
	})
	return fmt.Errorf("host not found: %s", alias)
}

// save writes the config back to disk
func (c *ClientConfig) save() error {
	c.log.Debug("saving config")

	// Create backup
	if err := c.backup(); err != nil {
		c.log.Err(err, "failed to create backup")
		return fmt.Errorf("failed to create backup: %w", err)
	}

	data, err := c.config.MarshalText()
	if err != nil {
		c.log.Err(err, "failed to marshal config")
		return fmt.Errorf("failed to marshal config: %w", err)
	}

	if err := os.WriteFile(c.path, data, 0600); err != nil {
		c.log.ErrWithFields(err, "failed to write config", map[string]interface{}{
			"config_path": c.path,
		})
		return err
	}

	c.log.Debug("config saved successfully")
	return nil
}

// backup creates a backup of the config file
func (c *ClientConfig) backup() error {
	if _, err := os.Stat(c.path); os.IsNotExist(err) {
		return nil
	}

	data, err := os.ReadFile(c.path)
	if err != nil {
		return err
	}

	backupPath := c.path + ".bak"
	c.log.DebugWithFields("creating backup", map[string]interface{}{
		"backup_path": backupPath,
	})

	return os.WriteFile(backupPath, data, 0600)
}

// extractHostEntry extracts a HostEntry from a Host block
func (c *ClientConfig) extractHostEntry(alias string, host *sshconfig.Host) *HostEntry {
	entry := &HostEntry{
		Alias:        alias,
		ExtraOptions: make(map[string]string),
	}

	for _, node := range host.Nodes {
		switch n := node.(type) {
		case *sshconfig.KV:
			switch n.Key {
			case "HostName":
				entry.Hostname = n.Value
			case "User":
				entry.User = n.Value
			case "Port":
				entry.Port = parsePort(n.Value)
			case "IdentityFile":
				entry.IdentityFiles = append(entry.IdentityFiles, n.Value)
			case "ProxyJump":
				entry.ProxyJump = n.Value
			case "ProxyCommand":
				entry.ProxyCommand = n.Value
			case "ForwardAgent":
				entry.ForwardAgent = n.Value == "yes"
			default:
				entry.ExtraOptions[n.Key] = n.Value
			}
		}
	}

	return entry
}

// buildNodes converts a HostEntry to config nodes
func (c *ClientConfig) buildNodes(entry *HostEntry) []sshconfig.Node {
	var nodes []sshconfig.Node

	if entry.Hostname != "" {
		nodes = append(nodes, &sshconfig.KV{Key: "HostName", Value: entry.Hostname})
	}
	if entry.User != "" {
		nodes = append(nodes, &sshconfig.KV{Key: "User", Value: entry.User})
	}
	if entry.Port != 0 && entry.Port != 22 {
		nodes = append(nodes, &sshconfig.KV{Key: "Port", Value: fmt.Sprintf("%d", entry.Port)})
	}
	for _, identity := range entry.IdentityFiles {
		nodes = append(nodes, &sshconfig.KV{Key: "IdentityFile", Value: identity})
	}
	if entry.ProxyJump != "" {
		nodes = append(nodes, &sshconfig.KV{Key: "ProxyJump", Value: entry.ProxyJump})
	}
	if entry.ProxyCommand != "" {
		nodes = append(nodes, &sshconfig.KV{Key: "ProxyCommand", Value: entry.ProxyCommand})
	}
	if entry.ForwardAgent {
		nodes = append(nodes, &sshconfig.KV{Key: "ForwardAgent", Value: "yes"})
	}

	return nodes
}

func parsePort(s string) int {
	if s == "" {
		return 22
	}
	var port int
	fmt.Sscanf(s, "%d", &port)
	if port == 0 {
		return 22
	}
	return port
}

func parseInt(s string) int {
	var val int
	fmt.Sscanf(s, "%d", &val)
	return val
}
