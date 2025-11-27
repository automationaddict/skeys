// Package config provides SSH configuration management.
package config

import (
	"crypto/sha256"
	"encoding/hex"
	"fmt"
	"os"
	"path/filepath"
	"strconv"
	"strings"

	"github.com/johnnelson/skeys-core/logging"
	"github.com/patrikkj/sshconf"
)

// EntryType distinguishes between Host and Match blocks
type EntryType int

const (
	EntryTypeHost EntryType = iota + 1
	EntryTypeMatch
)

func (t EntryType) String() string {
	switch t {
	case EntryTypeHost:
		return "Host"
	case EntryTypeMatch:
		return "Match"
	default:
		return "Unknown"
	}
}

// SSHConfigEntry represents either a Host or Match block in SSH config
type SSHConfigEntry struct {
	ID            string            // Stable hash-based ID
	Type          EntryType         // Host or Match
	Position      int               // Order in config file (0-based)
	Patterns      []string          // For Host blocks: patterns; for Match: criteria parts
	Options       SSHOptions        // Configuration options
}

// SSHOptions contains all SSH configuration options
type SSHOptions struct {
	Hostname              string
	User                  string
	Port                  int
	IdentityFiles         []string
	ProxyJump             string
	ProxyCommand          string
	ForwardAgent          bool
	IdentitiesOnly        bool
	StrictHostKeyChecking string
	ServerAliveInterval   int
	ServerAliveCountMax   int
	Compression           bool
	ExtraOptions          map[string]string
}

// HostEntry represents a Host block in ~/.ssh/config (backward compatibility)
type HostEntry struct {
	Alias                 string
	Hostname              string
	User                  string
	Port                  int
	IdentityFiles         []string
	ProxyJump             string
	ProxyCommand          string
	ForwardAgent          bool
	IdentitiesOnly        bool
	StrictHostKeyChecking string
	ServerAliveInterval   int
	ServerAliveCountMax   int
	ExtraOptions          map[string]string
	IsPattern             bool
	LineNumber            int
}

// ClientConfig manages the SSH client configuration file
type ClientConfig struct {
	path   string
	config *sshconf.SSHConfig
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
	if _, err := os.Stat(c.path); os.IsNotExist(err) {
		c.log.Debug("config file does not exist, creating empty config")
		c.config = sshconf.ParseConfig("")
		return nil
	}

	cfg, err := sshconf.ParseConfigFile(c.path)
	if err != nil {
		c.log.ErrWithFields(err, "failed to parse config", map[string]interface{}{
			"config_path": c.path,
		})
		return fmt.Errorf("failed to parse config: %w", err)
	}

	c.config = cfg
	c.log.Debug("config loaded successfully")
	return nil
}

// ListEntries returns all SSH config entries (Host and Match blocks) in file order
func (c *ClientConfig) ListEntries() ([]*SSHConfigEntry, error) {
	c.log.Debug("listing SSH config entries")

	var entries []*SSHConfigEntry
	position := 0

	for _, line := range c.config.Lines() {
		key := strings.ToLower(line.Key)
		if key != "host" && key != "match" {
			continue
		}

		entryType := EntryTypeHost
		if key == "match" {
			entryType = EntryTypeMatch
		}

		// Parse patterns/criteria from value
		patterns := parsePatternString(line.Value)

		// Skip wildcard-only Host entries for listing (they're defaults)
		if entryType == EntryTypeHost && len(patterns) == 1 && patterns[0] == "*" {
			continue
		}

		entry := &SSHConfigEntry{
			Type:     entryType,
			Position: position,
			Patterns: patterns,
			Options:  c.extractOptions(line.Children),
		}
		entry.ID = generateEntryID(entry)

		entries = append(entries, entry)
		position++
	}

	c.log.InfoWithFields("listed SSH config entries", map[string]interface{}{
		"count": len(entries),
	})

	return entries, nil
}

// List returns all host entries (backward compatibility)
func (c *ClientConfig) List() ([]*HostEntry, error) {
	c.log.Debug("listing host entries")

	entries, err := c.ListEntries()
	if err != nil {
		return nil, err
	}

	var hostEntries []*HostEntry
	for _, e := range entries {
		if e.Type == EntryTypeHost {
			hostEntries = append(hostEntries, e.toHostEntry())
		}
	}

	c.log.InfoWithFields("listed host entries", map[string]interface{}{
		"count": len(hostEntries),
	})

	return hostEntries, nil
}

// GetEntry returns an entry by ID
func (c *ClientConfig) GetEntry(id string) (*SSHConfigEntry, error) {
	c.log.DebugWithFields("getting entry by ID", map[string]interface{}{
		"id": id,
	})

	entries, err := c.ListEntries()
	if err != nil {
		return nil, err
	}

	for _, e := range entries {
		if e.ID == id {
			return e, nil
		}
	}

	return nil, fmt.Errorf("entry not found: %s", id)
}

// Get returns the effective configuration for a host (backward compatibility)
func (c *ClientConfig) Get(alias string) (*HostEntry, error) {
	c.log.DebugWithFields("getting host entry", map[string]interface{}{
		"alias": alias,
	})

	entries, err := c.ListEntries()
	if err != nil {
		return nil, err
	}

	for _, e := range entries {
		if e.Type == EntryTypeHost && len(e.Patterns) > 0 && e.Patterns[0] == alias {
			return e.toHostEntry(), nil
		}
	}

	return nil, fmt.Errorf("host not found: %s", alias)
}

// AddEntry adds a new SSH config entry at the specified position
func (c *ClientConfig) AddEntry(entry *SSHConfigEntry, position int) error {
	c.log.InfoWithFields("adding SSH config entry", map[string]interface{}{
		"type":     entry.Type.String(),
		"patterns": entry.Patterns,
		"position": position,
	})

	// Check for duplicates
	entries, err := c.ListEntries()
	if err != nil {
		return err
	}

	if entry.Type == EntryTypeHost {
		for _, e := range entries {
			if e.Type == EntryTypeHost {
				for _, p1 := range e.Patterns {
					for _, p2 := range entry.Patterns {
						if p1 == p2 {
							return fmt.Errorf("host pattern already exists: %s", p1)
						}
					}
				}
			}
		}
	}

	// Build the config block string
	block := c.buildEntryBlock(entry)

	// Use Patch to add - it handles insertion
	c.config.Patch(c.getEntryHeader(entry), block)

	if err := c.save(); err != nil {
		return err
	}

	// Generate ID for the new entry
	entry.ID = generateEntryID(entry)

	c.log.InfoWithFields("SSH config entry added successfully", map[string]interface{}{
		"id": entry.ID,
	})
	return nil
}

// Add adds a new host entry (backward compatibility)
func (c *ClientConfig) Add(entry *HostEntry) error {
	c.log.InfoWithFields("adding host entry", map[string]interface{}{
		"alias":    entry.Alias,
		"hostname": entry.Hostname,
		"user":     entry.User,
	})

	sshEntry := hostEntryToSSHConfigEntry(entry)
	return c.AddEntry(sshEntry, -1) // -1 means append
}

// UpdateEntry updates an existing entry by ID
func (c *ClientConfig) UpdateEntry(id string, entry *SSHConfigEntry) error {
	c.log.InfoWithFields("updating SSH config entry", map[string]interface{}{
		"id": id,
	})

	// Find the existing entry to get its header
	existing, err := c.GetEntry(id)
	if err != nil {
		return err
	}

	// Delete the old entry
	oldHeader := c.getEntryHeader(existing)
	c.config.Delete(oldHeader)

	// Add the new entry
	block := c.buildEntryBlock(entry)
	c.config.Patch(c.getEntryHeader(entry), block)

	if err := c.save(); err != nil {
		return err
	}

	c.log.InfoWithFields("SSH config entry updated successfully", map[string]interface{}{
		"id": id,
	})
	return nil
}

// Update updates an existing host entry (backward compatibility)
func (c *ClientConfig) Update(alias string, entry *HostEntry) error {
	c.log.InfoWithFields("updating host entry", map[string]interface{}{
		"alias": alias,
	})

	// Find by alias
	existing, err := c.Get(alias)
	if err != nil {
		return err
	}

	// Build entry with same alias pattern
	sshEntry := hostEntryToSSHConfigEntry(entry)
	sshEntry.Patterns = []string{alias}

	// Find and update by building a temporary ID
	tempEntry := &SSHConfigEntry{
		Type:     EntryTypeHost,
		Patterns: []string{existing.Alias},
	}
	oldID := generateEntryID(tempEntry)

	return c.UpdateEntry(oldID, sshEntry)
}

// DeleteEntry removes an entry by ID
func (c *ClientConfig) DeleteEntry(id string) error {
	c.log.InfoWithFields("deleting SSH config entry", map[string]interface{}{
		"id": id,
	})

	entry, err := c.GetEntry(id)
	if err != nil {
		return err
	}

	header := c.getEntryHeader(entry)
	c.config.Delete(header)

	if err := c.save(); err != nil {
		return err
	}

	c.log.InfoWithFields("SSH config entry deleted successfully", map[string]interface{}{
		"id": id,
	})
	return nil
}

// Delete removes a host entry (backward compatibility)
func (c *ClientConfig) Delete(alias string) error {
	c.log.InfoWithFields("deleting host entry", map[string]interface{}{
		"alias": alias,
	})

	c.config.Delete("Host " + alias)

	if err := c.save(); err != nil {
		return err
	}

	c.log.InfoWithFields("host entry deleted successfully", map[string]interface{}{
		"alias": alias,
	})
	return nil
}

// Reorder changes the order of entries in the config file
func (c *ClientConfig) Reorder(entryIDs []string) error {
	c.log.InfoWithFields("reordering SSH config entries", map[string]interface{}{
		"count": len(entryIDs),
	})

	// Get all current entries
	entries, err := c.ListEntries()
	if err != nil {
		return err
	}

	// Build ID -> entry map
	idMap := make(map[string]*SSHConfigEntry)
	for _, e := range entries {
		idMap[e.ID] = e
	}

	// Verify all IDs are valid
	for _, id := range entryIDs {
		if _, ok := idMap[id]; !ok {
			return fmt.Errorf("unknown entry ID: %s", id)
		}
	}

	// Rebuild config in new order
	// First, get any lines that aren't Host/Match blocks (comments, etc.)
	var preamble strings.Builder
	for _, line := range c.config.Lines() {
		key := strings.ToLower(line.Key)
		if key == "host" || key == "match" {
			break // Stop at first Host/Match block
		}
		// This is a preamble line (comment, global option, etc.)
		if line.Comment != "" {
			preamble.WriteString(line.Comment + "\n")
		}
	}

	// Build new config content
	var content strings.Builder
	content.WriteString(preamble.String())

	for _, id := range entryIDs {
		entry := idMap[id]
		content.WriteString(c.buildEntryBlock(entry))
		content.WriteString("\n")
	}

	// Parse the new content
	c.config = sshconf.ParseConfig(content.String())

	if err := c.save(); err != nil {
		return err
	}

	c.log.Info("SSH config entries reordered successfully")
	return nil
}

// save writes the config back to disk
func (c *ClientConfig) save() error {
	c.log.Debug("saving config")

	// Create backup
	if err := c.backup(); err != nil {
		c.log.Err(err, "failed to create backup")
		return fmt.Errorf("failed to create backup: %w", err)
	}

	// Ensure directory exists
	dir := filepath.Dir(c.path)
	if err := os.MkdirAll(dir, 0700); err != nil {
		return fmt.Errorf("failed to create directory: %w", err)
	}

	if err := c.config.WriteFile(c.path); err != nil {
		c.log.ErrWithFields(err, "failed to write config", map[string]interface{}{
			"config_path": c.path,
		})
		return err
	}

	// Ensure correct permissions
	if err := os.Chmod(c.path, 0600); err != nil {
		c.log.Err(err, "failed to set config permissions")
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

// extractOptions extracts SSH options from child lines
func (c *ClientConfig) extractOptions(children []sshconf.LineNoChildren) SSHOptions {
	opts := SSHOptions{
		ExtraOptions: make(map[string]string),
	}

	for _, child := range children {
		key := strings.ToLower(child.Key)
		value := child.Value

		switch key {
		case "hostname":
			opts.Hostname = value
		case "user":
			opts.User = value
		case "port":
			opts.Port = parseInt(value)
		case "identityfile":
			opts.IdentityFiles = append(opts.IdentityFiles, value)
		case "proxyjump":
			opts.ProxyJump = value
		case "proxycommand":
			opts.ProxyCommand = value
		case "forwardagent":
			opts.ForwardAgent = strings.ToLower(value) == "yes"
		case "identitiesonly":
			opts.IdentitiesOnly = strings.ToLower(value) == "yes"
		case "stricthostkeychecking":
			opts.StrictHostKeyChecking = value
		case "serveraliveinterval":
			opts.ServerAliveInterval = parseInt(value)
		case "serveralivecountmax":
			opts.ServerAliveCountMax = parseInt(value)
		case "compression":
			opts.Compression = strings.ToLower(value) == "yes"
		default:
			opts.ExtraOptions[child.Key] = value
		}
	}

	return opts
}

// buildEntryBlock creates the config block string for an entry
func (c *ClientConfig) buildEntryBlock(entry *SSHConfigEntry) string {
	var sb strings.Builder

	// Header line
	sb.WriteString(c.getEntryHeader(entry))
	sb.WriteString("\n")

	// Options
	opts := entry.Options

	if opts.Hostname != "" {
		sb.WriteString("    HostName " + opts.Hostname + "\n")
	}
	if opts.User != "" {
		sb.WriteString("    User " + opts.User + "\n")
	}
	if opts.Port != 0 && opts.Port != 22 {
		sb.WriteString("    Port " + strconv.Itoa(opts.Port) + "\n")
	}
	for _, identity := range opts.IdentityFiles {
		sb.WriteString("    IdentityFile " + identity + "\n")
	}
	if opts.ProxyJump != "" {
		sb.WriteString("    ProxyJump " + opts.ProxyJump + "\n")
	}
	if opts.ProxyCommand != "" {
		sb.WriteString("    ProxyCommand " + opts.ProxyCommand + "\n")
	}
	if opts.ForwardAgent {
		sb.WriteString("    ForwardAgent yes\n")
	}
	if opts.IdentitiesOnly {
		sb.WriteString("    IdentitiesOnly yes\n")
	}
	if opts.StrictHostKeyChecking != "" {
		sb.WriteString("    StrictHostKeyChecking " + opts.StrictHostKeyChecking + "\n")
	}
	if opts.ServerAliveInterval > 0 {
		sb.WriteString("    ServerAliveInterval " + strconv.Itoa(opts.ServerAliveInterval) + "\n")
	}
	if opts.ServerAliveCountMax > 0 {
		sb.WriteString("    ServerAliveCountMax " + strconv.Itoa(opts.ServerAliveCountMax) + "\n")
	}
	if opts.Compression {
		sb.WriteString("    Compression yes\n")
	}

	// Extra options
	for key, value := range opts.ExtraOptions {
		sb.WriteString("    " + key + " " + value + "\n")
	}

	return sb.String()
}

// getEntryHeader returns the header line for an entry (e.g., "Host myserver" or "Match host *.example.com")
func (c *ClientConfig) getEntryHeader(entry *SSHConfigEntry) string {
	if entry.Type == EntryTypeMatch {
		return "Match " + strings.Join(entry.Patterns, " ")
	}
	return "Host " + strings.Join(entry.Patterns, " ")
}

// toHostEntry converts SSHConfigEntry to HostEntry for backward compatibility
func (e *SSHConfigEntry) toHostEntry() *HostEntry {
	alias := ""
	if len(e.Patterns) > 0 {
		alias = e.Patterns[0]
	}

	isPattern := false
	if alias != "" && (strings.Contains(alias, "*") || strings.Contains(alias, "?")) {
		isPattern = true
	}

	return &HostEntry{
		Alias:                 alias,
		Hostname:              e.Options.Hostname,
		User:                  e.Options.User,
		Port:                  e.Options.Port,
		IdentityFiles:         e.Options.IdentityFiles,
		ProxyJump:             e.Options.ProxyJump,
		ProxyCommand:          e.Options.ProxyCommand,
		ForwardAgent:          e.Options.ForwardAgent,
		IdentitiesOnly:        e.Options.IdentitiesOnly,
		StrictHostKeyChecking: e.Options.StrictHostKeyChecking,
		ServerAliveInterval:   e.Options.ServerAliveInterval,
		ServerAliveCountMax:   e.Options.ServerAliveCountMax,
		ExtraOptions:          e.Options.ExtraOptions,
		IsPattern:             isPattern,
		LineNumber:            e.Position,
	}
}

// hostEntryToSSHConfigEntry converts HostEntry to SSHConfigEntry
func hostEntryToSSHConfigEntry(entry *HostEntry) *SSHConfigEntry {
	return &SSHConfigEntry{
		Type:     EntryTypeHost,
		Patterns: []string{entry.Alias},
		Options: SSHOptions{
			Hostname:              entry.Hostname,
			User:                  entry.User,
			Port:                  entry.Port,
			IdentityFiles:         entry.IdentityFiles,
			ProxyJump:             entry.ProxyJump,
			ProxyCommand:          entry.ProxyCommand,
			ForwardAgent:          entry.ForwardAgent,
			IdentitiesOnly:        entry.IdentitiesOnly,
			StrictHostKeyChecking: entry.StrictHostKeyChecking,
			ServerAliveInterval:   entry.ServerAliveInterval,
			ServerAliveCountMax:   entry.ServerAliveCountMax,
			ExtraOptions:          entry.ExtraOptions,
		},
	}
}

// generateEntryID creates a stable ID for an entry based on its type and patterns
func generateEntryID(entry *SSHConfigEntry) string {
	h := sha256.New()
	h.Write([]byte(fmt.Sprintf("%d:", entry.Type)))
	for _, p := range entry.Patterns {
		h.Write([]byte(p + ":"))
	}
	return hex.EncodeToString(h.Sum(nil))[:12]
}

// parsePatternString splits a string value into individual patterns
func parsePatternString(value string) []string {
	return strings.Fields(value)
}

func parseInt(s string) int {
	val, _ := strconv.Atoi(s)
	return val
}

// GlobalDirective represents a global SSH configuration option
type GlobalDirective struct {
	Key   string
	Value string
}

// GetGlobalDirectives returns all global directives (top-level options not inside Host/Match blocks)
func (c *ClientConfig) GetGlobalDirectives() ([]*GlobalDirective, error) {
	c.log.Debug("getting global directives")

	var directives []*GlobalDirective

	for _, line := range c.config.Lines() {
		key := strings.ToLower(line.Key)

		// Skip Host/Match blocks (they have their own Children)
		if key == "host" || key == "match" {
			continue
		}

		// Skip empty lines and comments
		if line.Key == "" {
			continue
		}

		directives = append(directives, &GlobalDirective{
			Key:   line.Key,
			Value: line.Value,
		})
	}

	c.log.InfoWithFields("got global directives", map[string]interface{}{
		"count": len(directives),
	})

	return directives, nil
}

// SetGlobalDirective sets a global directive value (creates if doesn't exist)
func (c *ClientConfig) SetGlobalDirective(key, value string) error {
	c.log.InfoWithFields("setting global directive", map[string]interface{}{
		"key":   key,
		"value": value,
	})

	// Build the new config content
	var content strings.Builder
	found := false
	insertedAtStart := false

	for _, line := range c.config.Lines() {
		lineKey := strings.ToLower(line.Key)

		// Check if this is the directive we're updating (anywhere in the file, but not Host/Match)
		if strings.EqualFold(line.Key, key) && lineKey != "host" && lineKey != "match" {
			content.WriteString(key + " " + value + "\n")
			found = true
			continue
		}

		// If we haven't found the directive and hit first line, insert at start
		if !found && !insertedAtStart && (line.Key != "" || line.Comment != "") {
			// Check if this is a managed block comment
			if line.Comment != "" && strings.Contains(line.Comment, "BEGIN skeys managed block") {
				// Insert new directive before managed block
				content.WriteString(key + " " + value + "\n\n")
				insertedAtStart = true
				found = true
			}
		}

		// Preserve the line
		if line.Comment != "" {
			content.WriteString(line.Comment + "\n")
		}
		if line.Key != "" {
			if lineKey == "host" || lineKey == "match" {
				content.WriteString(line.Key + " " + line.Value + "\n")
				// Write children with indentation
				for _, child := range line.Children {
					content.WriteString("    " + child.Key + " " + child.Value + "\n")
				}
			} else {
				content.WriteString(line.Key + " " + line.Value + "\n")
			}
		}
	}

	// If we didn't find the key, append it at the end
	if !found {
		content.WriteString(key + " " + value + "\n")
	}

	// Parse the new content
	c.config = sshconf.ParseConfig(content.String())

	if err := c.save(); err != nil {
		return err
	}

	c.log.InfoWithFields("global directive set successfully", map[string]interface{}{
		"key": key,
	})
	return nil
}

// DeleteGlobalDirective removes a global directive
func (c *ClientConfig) DeleteGlobalDirective(key string) error {
	c.log.InfoWithFields("deleting global directive", map[string]interface{}{
		"key": key,
	})

	// Build the new config content
	var content strings.Builder
	found := false

	for _, line := range c.config.Lines() {
		lineKey := strings.ToLower(line.Key)

		// Check if this is the directive we're deleting
		if strings.EqualFold(line.Key, key) && lineKey != "host" && lineKey != "match" {
			found = true
			continue // Skip this line
		}

		// Preserve the line
		if line.Comment != "" {
			content.WriteString(line.Comment + "\n")
		}
		if line.Key != "" {
			if lineKey == "host" || lineKey == "match" {
				content.WriteString(line.Key + " " + line.Value + "\n")
				// Write children with indentation
				for _, child := range line.Children {
					content.WriteString("    " + child.Key + " " + child.Value + "\n")
				}
			} else {
				content.WriteString(line.Key + " " + line.Value + "\n")
			}
		}
	}

	if !found {
		return fmt.Errorf("global directive not found: %s", key)
	}

	// Parse the new content
	c.config = sshconf.ParseConfig(content.String())

	if err := c.save(); err != nil {
		return err
	}

	c.log.InfoWithFields("global directive deleted successfully", map[string]interface{}{
		"key": key,
	})
	return nil
}
