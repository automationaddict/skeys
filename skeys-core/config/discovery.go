package config

import (
	"bufio"
	"bytes"
	"context"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
)

// DiscoveryMethod indicates how a config path was discovered.
type DiscoveryMethod int

const (
	DiscoveryMethodUnspecified DiscoveryMethod = iota
	DiscoveryMethodCommand                     // Discovered via command (ssh -G, sshd -T)
	DiscoveryMethodPackageManager              // Discovered via package manager
	DiscoveryMethodCommonPath                  // Found at common/standard path
	DiscoveryMethodUserSpecified               // User-provided path
)

// ConfigPathInfo contains information about a discovered config path.
type ConfigPathInfo struct {
	Path            string
	Exists          bool
	Readable        bool
	Writable        bool
	IncludeDir      string // Associated .d directory
	DiscoveryMethod DiscoveryMethod
}

// DiscoveredPaths contains all discovered SSH config paths.
type DiscoveredPaths struct {
	ClientSystemConfig ConfigPathInfo // System-wide client config (/etc/ssh/ssh_config)
	ClientUserConfig   ConfigPathInfo // User client config (~/.ssh/config)
	ServerConfig       ConfigPathInfo // Server config (/etc/ssh/sshd_config)
	Distribution       string         // Detected distribution
	SSHClientInstalled bool
	SSHServerInstalled bool
}

// ConfigDiscoverer handles auto-detection of SSH config paths.
type ConfigDiscoverer struct{}

// NewConfigDiscoverer creates a new config path discoverer.
func NewConfigDiscoverer() *ConfigDiscoverer {
	return &ConfigDiscoverer{}
}

// Discover auto-detects SSH config paths for the current system.
func (d *ConfigDiscoverer) Discover(ctx context.Context) (*DiscoveredPaths, error) {
	result := &DiscoveredPaths{}

	// Detect distribution
	result.Distribution = d.detectDistribution()

	// Discover client configs
	result.ClientUserConfig = d.discoverClientUserConfig()
	result.ClientSystemConfig = d.discoverClientSystemConfig(ctx)

	// Discover server config
	result.ServerConfig = d.discoverServerConfig(ctx)

	// Check if SSH client/server are installed
	result.SSHClientInstalled = d.isCommandAvailable("ssh")
	result.SSHServerInstalled = d.isCommandAvailable("sshd")

	return result, nil
}

// discoverClientUserConfig finds the user's SSH config file.
func (d *ConfigDiscoverer) discoverClientUserConfig() ConfigPathInfo {
	homeDir, err := os.UserHomeDir()
	if err != nil {
		return ConfigPathInfo{}
	}

	path := filepath.Join(homeDir, ".ssh", "config")
	info := d.checkPath(path)
	info.DiscoveryMethod = DiscoveryMethodCommonPath
	info.IncludeDir = filepath.Join(homeDir, ".ssh", "config.d")

	// Check if include dir exists
	if _, err := os.Stat(info.IncludeDir); os.IsNotExist(err) {
		info.IncludeDir = ""
	}

	return info
}

// discoverClientSystemConfig finds the system-wide SSH client config.
func (d *ConfigDiscoverer) discoverClientSystemConfig(ctx context.Context) ConfigPathInfo {
	// Try to get from ssh -G (most reliable)
	if path := d.getClientConfigFromCommand(ctx); path != "" {
		info := d.checkPath(path)
		info.DiscoveryMethod = DiscoveryMethodCommand
		info.IncludeDir = path + ".d"
		if _, err := os.Stat(info.IncludeDir); os.IsNotExist(err) {
			info.IncludeDir = ""
		}
		return info
	}

	// Try package manager
	if path := d.getClientConfigFromPackageManager(); path != "" {
		info := d.checkPath(path)
		info.DiscoveryMethod = DiscoveryMethodPackageManager
		info.IncludeDir = path + ".d"
		if _, err := os.Stat(info.IncludeDir); os.IsNotExist(err) {
			info.IncludeDir = ""
		}
		return info
	}

	// Fall back to common paths
	commonPaths := []string{
		"/etc/ssh/ssh_config",
		"/etc/ssh_config",
		"/usr/local/etc/ssh/ssh_config",
	}

	for _, path := range commonPaths {
		info := d.checkPath(path)
		if info.Exists {
			info.DiscoveryMethod = DiscoveryMethodCommonPath
			info.IncludeDir = path + ".d"
			if _, err := os.Stat(info.IncludeDir); os.IsNotExist(err) {
				info.IncludeDir = ""
			}
			return info
		}
	}

	// Return first common path even if not found
	return ConfigPathInfo{
		Path:            "/etc/ssh/ssh_config",
		DiscoveryMethod: DiscoveryMethodCommonPath,
	}
}

// discoverServerConfig finds the SSH server config (sshd_config).
func (d *ConfigDiscoverer) discoverServerConfig(ctx context.Context) ConfigPathInfo {
	// Try to get from sshd -T (most reliable, but may need root)
	if path := d.getServerConfigFromCommand(ctx); path != "" {
		info := d.checkPath(path)
		info.DiscoveryMethod = DiscoveryMethodCommand
		info.IncludeDir = path + ".d"
		if _, err := os.Stat(info.IncludeDir); os.IsNotExist(err) {
			info.IncludeDir = ""
		}
		return info
	}

	// Try package manager
	if path := d.getServerConfigFromPackageManager(); path != "" {
		info := d.checkPath(path)
		info.DiscoveryMethod = DiscoveryMethodPackageManager
		info.IncludeDir = path + ".d"
		if _, err := os.Stat(info.IncludeDir); os.IsNotExist(err) {
			info.IncludeDir = ""
		}
		return info
	}

	// Fall back to common paths
	commonPaths := []string{
		"/etc/ssh/sshd_config",
		"/etc/sshd_config",
		"/usr/local/etc/ssh/sshd_config",
	}

	for _, path := range commonPaths {
		info := d.checkPath(path)
		if info.Exists {
			info.DiscoveryMethod = DiscoveryMethodCommonPath
			info.IncludeDir = path + ".d"
			if _, err := os.Stat(info.IncludeDir); os.IsNotExist(err) {
				info.IncludeDir = ""
			}
			return info
		}
	}

	// Check for default config in package share directory (Ubuntu/Debian)
	defaultPaths := []string{
		"/usr/share/openssh/sshd_config",
	}
	for _, path := range defaultPaths {
		if _, err := os.Stat(path); err == nil {
			// Default exists but not copied to /etc/ssh
			return ConfigPathInfo{
				Path:            "/etc/ssh/sshd_config",
				Exists:          false,
				DiscoveryMethod: DiscoveryMethodCommonPath,
				IncludeDir:      "/etc/ssh/sshd_config.d",
			}
		}
	}

	// Return first common path even if not found
	return ConfigPathInfo{
		Path:            "/etc/ssh/sshd_config",
		DiscoveryMethod: DiscoveryMethodCommonPath,
	}
}

// getClientConfigFromCommand tries to discover client config path using ssh -G.
func (d *ConfigDiscoverer) getClientConfigFromCommand(ctx context.Context) string {
	// ssh -G outputs the effective configuration
	// We can't directly get the config path, but we can check if ssh works
	cmd := exec.CommandContext(ctx, "ssh", "-G", "localhost")
	if err := cmd.Run(); err == nil {
		// ssh works, config is at standard location
		return "/etc/ssh/ssh_config"
	}
	return ""
}

// getServerConfigFromCommand tries to discover server config path using sshd.
func (d *ConfigDiscoverer) getServerConfigFromCommand(ctx context.Context) string {
	// Try sshd -T to dump config (requires root or specific setup)
	// The error message often contains the config path
	cmd := exec.CommandContext(ctx, "sshd", "-T")
	var stderr bytes.Buffer
	cmd.Stderr = &stderr
	cmd.Run() // Ignore error - we're looking at stderr

	// Parse stderr for config path hints
	stderrStr := stderr.String()
	if strings.Contains(stderrStr, "/etc/ssh/sshd_config") {
		return "/etc/ssh/sshd_config"
	}

	// Try to find sshd and check its default config
	if sshdPath, err := exec.LookPath("sshd"); err == nil {
		// sshd exists, assume standard path
		_ = sshdPath
		return "/etc/ssh/sshd_config"
	}

	return ""
}

// getClientConfigFromPackageManager tries to find config via package manager.
func (d *ConfigDiscoverer) getClientConfigFromPackageManager() string {
	// Try dpkg (Debian/Ubuntu)
	if d.isCommandAvailable("dpkg") {
		cmd := exec.Command("dpkg", "-L", "openssh-client")
		output, err := cmd.Output()
		if err == nil {
			for _, line := range strings.Split(string(output), "\n") {
				if strings.HasSuffix(line, "ssh_config") && strings.Contains(line, "/etc/") {
					return strings.TrimSpace(line)
				}
			}
		}
	}

	// Try rpm (RHEL/Fedora)
	if d.isCommandAvailable("rpm") {
		cmd := exec.Command("rpm", "-ql", "openssh-clients")
		output, err := cmd.Output()
		if err == nil {
			for _, line := range strings.Split(string(output), "\n") {
				if strings.HasSuffix(line, "ssh_config") && strings.Contains(line, "/etc/") {
					return strings.TrimSpace(line)
				}
			}
		}
	}

	// Try pacman (Arch)
	if d.isCommandAvailable("pacman") {
		cmd := exec.Command("pacman", "-Ql", "openssh")
		output, err := cmd.Output()
		if err == nil {
			for _, line := range strings.Split(string(output), "\n") {
				if strings.Contains(line, "ssh_config") && strings.Contains(line, "/etc/") && !strings.Contains(line, "sshd") {
					parts := strings.Fields(line)
					if len(parts) >= 2 {
						return parts[1]
					}
				}
			}
		}
	}

	return ""
}

// getServerConfigFromPackageManager tries to find server config via package manager.
func (d *ConfigDiscoverer) getServerConfigFromPackageManager() string {
	// Try dpkg (Debian/Ubuntu)
	if d.isCommandAvailable("dpkg") {
		cmd := exec.Command("dpkg", "-L", "openssh-server")
		output, err := cmd.Output()
		if err == nil {
			for _, line := range strings.Split(string(output), "\n") {
				if strings.HasSuffix(line, "sshd_config") && strings.Contains(line, "/etc/") {
					return strings.TrimSpace(line)
				}
			}
			// Check for default in share directory
			for _, line := range strings.Split(string(output), "\n") {
				if strings.HasSuffix(line, "sshd_config") && strings.Contains(line, "/usr/share/") {
					// Package puts default in share, actual config goes to /etc
					return "/etc/ssh/sshd_config"
				}
			}
		}
	}

	// Try rpm (RHEL/Fedora)
	if d.isCommandAvailable("rpm") {
		cmd := exec.Command("rpm", "-ql", "openssh-server")
		output, err := cmd.Output()
		if err == nil {
			for _, line := range strings.Split(string(output), "\n") {
				if strings.HasSuffix(line, "sshd_config") && strings.Contains(line, "/etc/") {
					return strings.TrimSpace(line)
				}
			}
		}
	}

	// Try pacman (Arch)
	if d.isCommandAvailable("pacman") {
		cmd := exec.Command("pacman", "-Ql", "openssh")
		output, err := cmd.Output()
		if err == nil {
			for _, line := range strings.Split(string(output), "\n") {
				if strings.Contains(line, "sshd_config") && strings.Contains(line, "/etc/") {
					parts := strings.Fields(line)
					if len(parts) >= 2 {
						return parts[1]
					}
				}
			}
		}
	}

	return ""
}

// detectDistribution detects the Linux distribution.
func (d *ConfigDiscoverer) detectDistribution() string {
	// Try /etc/os-release first (most reliable)
	if f, err := os.Open("/etc/os-release"); err == nil {
		defer f.Close()
		scanner := bufio.NewScanner(f)
		for scanner.Scan() {
			line := scanner.Text()
			if strings.HasPrefix(line, "ID=") {
				id := strings.TrimPrefix(line, "ID=")
				id = strings.Trim(id, "\"")
				return id
			}
		}
	}

	// Try /etc/lsb-release (Ubuntu/Debian)
	if f, err := os.Open("/etc/lsb-release"); err == nil {
		defer f.Close()
		scanner := bufio.NewScanner(f)
		for scanner.Scan() {
			line := scanner.Text()
			if strings.HasPrefix(line, "DISTRIB_ID=") {
				id := strings.TrimPrefix(line, "DISTRIB_ID=")
				id = strings.Trim(id, "\"")
				return strings.ToLower(id)
			}
		}
	}

	// Check for specific distro files
	distroFiles := map[string]string{
		"/etc/debian_version": "debian",
		"/etc/redhat-release": "rhel",
		"/etc/fedora-release": "fedora",
		"/etc/arch-release":   "arch",
		"/etc/gentoo-release": "gentoo",
		"/etc/SuSE-release":   "suse",
	}

	for file, distro := range distroFiles {
		if _, err := os.Stat(file); err == nil {
			return distro
		}
	}

	return "unknown"
}

// checkPath checks if a path exists and its permissions.
func (d *ConfigDiscoverer) checkPath(path string) ConfigPathInfo {
	info := ConfigPathInfo{Path: path}

	fileInfo, err := os.Stat(path)
	if err != nil {
		return info
	}

	info.Exists = true

	// Check readability
	f, err := os.Open(path)
	if err == nil {
		info.Readable = true
		f.Close()
	}

	// Check writability (try to open for append without actually writing)
	f, err = os.OpenFile(path, os.O_WRONLY|os.O_APPEND, fileInfo.Mode())
	if err == nil {
		info.Writable = true
		f.Close()
	}

	return info
}

// isCommandAvailable checks if a command is available in PATH.
func (d *ConfigDiscoverer) isCommandAvailable(cmd string) bool {
	_, err := exec.LookPath(cmd)
	return err == nil
}

// GetDefaultServerConfigPath returns the default sshd_config path for the detected distribution.
func (d *ConfigDiscoverer) GetDefaultServerConfigPath() string {
	distro := d.detectDistribution()

	switch distro {
	case "freebsd":
		return "/usr/local/etc/ssh/sshd_config"
	default:
		return "/etc/ssh/sshd_config"
	}
}

// GetDefaultClientConfigPath returns the default ssh_config path for the detected distribution.
func (d *ConfigDiscoverer) GetDefaultClientConfigPath() string {
	distro := d.detectDistribution()

	switch distro {
	case "freebsd":
		return "/usr/local/etc/ssh/ssh_config"
	default:
		return "/etc/ssh/ssh_config"
	}
}

// String returns a human-readable representation of the discovery method.
func (m DiscoveryMethod) String() string {
	switch m {
	case DiscoveryMethodCommand:
		return "command"
	case DiscoveryMethodPackageManager:
		return "package_manager"
	case DiscoveryMethodCommonPath:
		return "common_path"
	case DiscoveryMethodUserSpecified:
		return "user_specified"
	default:
		return "unspecified"
	}
}

// Summary returns a human-readable summary of discovered paths.
func (p *DiscoveredPaths) Summary() string {
	var sb strings.Builder
	sb.WriteString(fmt.Sprintf("Distribution: %s\n", p.Distribution))
	sb.WriteString(fmt.Sprintf("SSH Client Installed: %v\n", p.SSHClientInstalled))
	sb.WriteString(fmt.Sprintf("SSH Server Installed: %v\n", p.SSHServerInstalled))
	sb.WriteString("\n")

	sb.WriteString("Client User Config:\n")
	sb.WriteString(fmt.Sprintf("  Path: %s\n", p.ClientUserConfig.Path))
	sb.WriteString(fmt.Sprintf("  Exists: %v, Readable: %v, Writable: %v\n",
		p.ClientUserConfig.Exists, p.ClientUserConfig.Readable, p.ClientUserConfig.Writable))
	sb.WriteString(fmt.Sprintf("  Discovery: %s\n", p.ClientUserConfig.DiscoveryMethod))

	sb.WriteString("\nClient System Config:\n")
	sb.WriteString(fmt.Sprintf("  Path: %s\n", p.ClientSystemConfig.Path))
	sb.WriteString(fmt.Sprintf("  Exists: %v, Readable: %v, Writable: %v\n",
		p.ClientSystemConfig.Exists, p.ClientSystemConfig.Readable, p.ClientSystemConfig.Writable))
	sb.WriteString(fmt.Sprintf("  Discovery: %s\n", p.ClientSystemConfig.DiscoveryMethod))
	if p.ClientSystemConfig.IncludeDir != "" {
		sb.WriteString(fmt.Sprintf("  Include Dir: %s\n", p.ClientSystemConfig.IncludeDir))
	}

	sb.WriteString("\nServer Config:\n")
	sb.WriteString(fmt.Sprintf("  Path: %s\n", p.ServerConfig.Path))
	sb.WriteString(fmt.Sprintf("  Exists: %v, Readable: %v, Writable: %v\n",
		p.ServerConfig.Exists, p.ServerConfig.Readable, p.ServerConfig.Writable))
	sb.WriteString(fmt.Sprintf("  Discovery: %s\n", p.ServerConfig.DiscoveryMethod))
	if p.ServerConfig.IncludeDir != "" {
		sb.WriteString(fmt.Sprintf("  Include Dir: %s\n", p.ServerConfig.IncludeDir))
	}

	return sb.String()
}
