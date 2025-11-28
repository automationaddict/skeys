// Package system provides system-level operations for SSH services.
package system

import (
	"bufio"
	"bytes"
	"context"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strconv"
	"strings"
	"time"
)

// ServiceState represents the state of a systemd service.
type ServiceState int

const (
	ServiceStateUnspecified ServiceState = iota
	ServiceStateRunning
	ServiceStateStopped
	ServiceStateFailed
	ServiceStateNotFound
	ServiceStateUnknown
)

func (s ServiceState) String() string {
	switch s {
	case ServiceStateRunning:
		return "running"
	case ServiceStateStopped:
		return "stopped"
	case ServiceStateFailed:
		return "failed"
	case ServiceStateNotFound:
		return "not_found"
	case ServiceStateUnknown:
		return "unknown"
	default:
		return "unspecified"
	}
}

// ServiceStatus contains the status of a systemd service.
type ServiceStatus struct {
	State       ServiceState
	Enabled     bool   // Starts on boot
	ActiveState string // Raw systemd state
	SubState    string // Raw systemd sub-state
	LoadState   string // loaded, not-found, masked
	PID         int64
	StartedAt   time.Time
	ServiceName string
}

// SSHClientStatus contains SSH client installation status.
type SSHClientStatus struct {
	Installed    bool
	Version      string
	BinaryPath   string
	SystemConfig ConfigPathInfo
	UserConfig   ConfigPathInfo
}

// SSHServerStatus contains SSH server installation and service status.
type SSHServerStatus struct {
	Installed  bool
	Version    string
	BinaryPath string
	Service    ServiceStatus
	Config     ConfigPathInfo
}

// ConfigPathInfo contains information about a config file path.
type ConfigPathInfo struct {
	Path       string
	Exists     bool
	Readable   bool
	Writable   bool
	IncludeDir string
}

// SSHStatus contains comprehensive SSH system status.
type SSHStatus struct {
	Distribution        string
	DistributionVersion string
	Client              SSHClientStatus
	Server              SSHServerStatus
}

// InstallInstructions contains installation instructions for a component.
type InstallInstructions struct {
	Distribution     string
	Component        string
	PackageName      string
	InstallCommand   string
	DocumentationURL string
	Steps            []string
}

// SystemManager provides system-level SSH operations.
type SystemManager struct {
	privilegeCmd string // Command for privilege escalation (pkexec, sudo)
}

// NewSystemManager creates a new system manager.
func NewSystemManager() *SystemManager {
	// Determine privilege escalation command
	privilegeCmd := "pkexec"
	if _, err := exec.LookPath("pkexec"); err != nil {
		privilegeCmd = "sudo"
	}

	return &SystemManager{
		privilegeCmd: privilegeCmd,
	}
}

// GetSSHStatus returns comprehensive SSH system status.
func (m *SystemManager) GetSSHStatus(ctx context.Context) (*SSHStatus, error) {
	status := &SSHStatus{}

	// Get distribution info
	status.Distribution, status.DistributionVersion = m.getDistributionInfo()

	// Get client status
	status.Client = m.getSSHClientStatus()

	// Get server status
	status.Server = m.getSSHServerStatus(ctx)

	return status, nil
}

// GetSSHServiceStatus returns the SSH server service status.
func (m *SystemManager) GetSSHServiceStatus(ctx context.Context) (*ServiceStatus, error) {
	serviceName := m.findSSHServiceName()
	if serviceName == "" {
		return &ServiceStatus{
			State:       ServiceStateNotFound,
			ServiceName: "ssh.service",
		}, nil
	}

	return m.getServiceStatus(ctx, serviceName)
}

// StartSSHService starts the SSH server service.
func (m *SystemManager) StartSSHService(ctx context.Context) (*ServiceStatus, error) {
	serviceName := m.findSSHServiceName()
	if serviceName == "" {
		return nil, fmt.Errorf("SSH service not found")
	}

	if err := m.runPrivilegedCommand(ctx, "systemctl", "start", serviceName); err != nil {
		// Try to get more details about the failure
		details := m.getServiceFailureDetails(ctx, serviceName)
		if details != "" {
			return nil, fmt.Errorf("failed to start SSH service: %s", details)
		}
		return nil, fmt.Errorf("failed to start SSH service: %w", err)
	}

	return m.getServiceStatus(ctx, serviceName)
}

// StopSSHService stops the SSH server service.
func (m *SystemManager) StopSSHService(ctx context.Context) (*ServiceStatus, error) {
	serviceName := m.findSSHServiceName()
	if serviceName == "" {
		return nil, fmt.Errorf("SSH service not found")
	}

	if err := m.runPrivilegedCommand(ctx, "systemctl", "stop", serviceName); err != nil {
		return nil, fmt.Errorf("failed to stop SSH service: %w", err)
	}

	return m.getServiceStatus(ctx, serviceName)
}

// RestartSSHService restarts the SSH server service.
func (m *SystemManager) RestartSSHService(ctx context.Context) (*ServiceStatus, error) {
	serviceName := m.findSSHServiceName()
	if serviceName == "" {
		return nil, fmt.Errorf("SSH service not found")
	}

	if err := m.runPrivilegedCommand(ctx, "systemctl", "restart", serviceName); err != nil {
		return nil, fmt.Errorf("failed to restart SSH service: %w", err)
	}

	return m.getServiceStatus(ctx, serviceName)
}

// ReloadSSHService reloads the SSH server service configuration.
func (m *SystemManager) ReloadSSHService(ctx context.Context) (*ServiceStatus, error) {
	serviceName := m.findSSHServiceName()
	if serviceName == "" {
		return nil, fmt.Errorf("SSH service not found")
	}

	if err := m.runPrivilegedCommand(ctx, "systemctl", "reload", serviceName); err != nil {
		return nil, fmt.Errorf("failed to reload SSH service: %w", err)
	}

	return m.getServiceStatus(ctx, serviceName)
}

// EnableSSHService enables the SSH server service to start on boot.
func (m *SystemManager) EnableSSHService(ctx context.Context) (*ServiceStatus, error) {
	serviceName := m.findSSHServiceName()
	if serviceName == "" {
		return nil, fmt.Errorf("SSH service not found")
	}

	if err := m.runPrivilegedCommand(ctx, "systemctl", "enable", serviceName); err != nil {
		return nil, fmt.Errorf("failed to enable SSH service: %w", err)
	}

	return m.getServiceStatus(ctx, serviceName)
}

// DisableSSHService disables the SSH server service from starting on boot.
func (m *SystemManager) DisableSSHService(ctx context.Context) (*ServiceStatus, error) {
	serviceName := m.findSSHServiceName()
	if serviceName == "" {
		return nil, fmt.Errorf("SSH service not found")
	}

	if err := m.runPrivilegedCommand(ctx, "systemctl", "disable", serviceName); err != nil {
		return nil, fmt.Errorf("failed to disable SSH service: %w", err)
	}

	return m.getServiceStatus(ctx, serviceName)
}

// GetInstallInstructions returns installation instructions for a component.
func (m *SystemManager) GetInstallInstructions(component string) *InstallInstructions {
	distro, _ := m.getDistributionInfo()

	instructions := &InstallInstructions{
		Distribution: distro,
		Component:    component,
	}

	switch component {
	case "client":
		instructions.PackageName, instructions.InstallCommand, instructions.Steps, instructions.DocumentationURL = m.getClientInstallInstructions(distro)
	case "server":
		instructions.PackageName, instructions.InstallCommand, instructions.Steps, instructions.DocumentationURL = m.getServerInstallInstructions(distro)
	}

	return instructions
}

// getDistributionInfo returns the distribution name and version.
func (m *SystemManager) getDistributionInfo() (string, string) {
	distro := "unknown"
	version := ""

	// Try /etc/os-release first
	if f, err := os.Open("/etc/os-release"); err == nil {
		defer f.Close()
		scanner := bufio.NewScanner(f)
		for scanner.Scan() {
			line := scanner.Text()
			if strings.HasPrefix(line, "ID=") {
				distro = strings.Trim(strings.TrimPrefix(line, "ID="), "\"")
			} else if strings.HasPrefix(line, "VERSION_ID=") {
				version = strings.Trim(strings.TrimPrefix(line, "VERSION_ID="), "\"")
			}
		}
	}

	return distro, version
}

// getSSHClientStatus returns SSH client installation status.
func (m *SystemManager) getSSHClientStatus() SSHClientStatus {
	status := SSHClientStatus{}

	// Check if ssh is installed
	if sshPath, err := exec.LookPath("ssh"); err == nil {
		status.Installed = true
		status.BinaryPath = sshPath
		status.Version = m.getSSHVersion(sshPath)
	}

	// Get system config path
	status.SystemConfig = m.checkConfigPath("/etc/ssh/ssh_config")

	// Get user config path
	if homeDir, err := os.UserHomeDir(); err == nil {
		userConfigPath := filepath.Join(homeDir, ".ssh", "config")
		status.UserConfig = m.checkConfigPath(userConfigPath)
	}

	return status
}

// getSSHServerStatus returns SSH server installation and service status.
func (m *SystemManager) getSSHServerStatus(ctx context.Context) SSHServerStatus {
	status := SSHServerStatus{}

	// Check if sshd is installed
	if sshdPath, err := exec.LookPath("sshd"); err == nil {
		status.Installed = true
		status.BinaryPath = sshdPath
		status.Version = m.getSSHDVersion(sshdPath)
	}

	// Get service status
	serviceStatus, _ := m.GetSSHServiceStatus(ctx)
	if serviceStatus != nil {
		status.Service = *serviceStatus
	}

	// Get config path
	status.Config = m.checkConfigPath("/etc/ssh/sshd_config")

	return status
}

// getSSHVersion returns the SSH client version.
func (m *SystemManager) getSSHVersion(sshPath string) string {
	cmd := exec.Command(sshPath, "-V")
	var stderr bytes.Buffer
	cmd.Stderr = &stderr
	cmd.Run() // ssh -V outputs to stderr

	output := stderr.String()
	// Parse "OpenSSH_9.6p1 Ubuntu-3ubuntu13.5, OpenSSL 3.0.13 30 Jan 2024"
	if idx := strings.Index(output, ","); idx > 0 {
		return strings.TrimSpace(output[:idx])
	}
	return strings.TrimSpace(output)
}

// getSSHDVersion returns the SSH server version.
func (m *SystemManager) getSSHDVersion(sshdPath string) string {
	cmd := exec.Command(sshdPath, "-V")
	var stderr bytes.Buffer
	cmd.Stderr = &stderr
	cmd.Run() // sshd -V outputs to stderr

	output := stderr.String()
	if idx := strings.Index(output, ","); idx > 0 {
		return strings.TrimSpace(output[:idx])
	}
	return strings.TrimSpace(output)
}

// checkConfigPath checks if a config path exists and its permissions.
func (m *SystemManager) checkConfigPath(path string) ConfigPathInfo {
	info := ConfigPathInfo{Path: path}

	fileInfo, err := os.Stat(path)
	if err != nil {
		return info
	}

	info.Exists = true

	// Check readability
	if f, err := os.Open(path); err == nil {
		info.Readable = true
		f.Close()
	}

	// Check writability
	if f, err := os.OpenFile(path, os.O_WRONLY|os.O_APPEND, fileInfo.Mode()); err == nil {
		info.Writable = true
		f.Close()
	}

	// Check for .d directory
	includeDir := path + ".d"
	if _, err := os.Stat(includeDir); err == nil {
		info.IncludeDir = includeDir
	}

	return info
}

// findSSHServiceName finds the correct SSH service name for the system.
func (m *SystemManager) findSSHServiceName() string {
	// Try common service names
	serviceNames := []string{"ssh.service", "sshd.service"}

	for _, name := range serviceNames {
		cmd := exec.Command("systemctl", "cat", name)
		if err := cmd.Run(); err == nil {
			return name
		}
	}

	return ""
}

// getServiceStatus returns the status of a systemd service.
func (m *SystemManager) getServiceStatus(ctx context.Context, serviceName string) (*ServiceStatus, error) {
	status := &ServiceStatus{
		ServiceName: serviceName,
		State:       ServiceStateUnknown,
	}

	// Get service properties
	cmd := exec.CommandContext(ctx, "systemctl", "show", serviceName,
		"--property=ActiveState,SubState,LoadState,MainPID,ActiveEnterTimestamp,UnitFileState")
	output, err := cmd.Output()
	if err != nil {
		// Check if service doesn't exist
		if strings.Contains(err.Error(), "not found") {
			status.State = ServiceStateNotFound
			return status, nil
		}
		return status, nil
	}

	// Parse properties
	for _, line := range strings.Split(string(output), "\n") {
		parts := strings.SplitN(line, "=", 2)
		if len(parts) != 2 {
			continue
		}
		key, value := parts[0], parts[1]

		switch key {
		case "ActiveState":
			status.ActiveState = value
			switch value {
			case "active":
				status.State = ServiceStateRunning
			case "inactive":
				status.State = ServiceStateStopped
			case "failed":
				status.State = ServiceStateFailed
			}
		case "SubState":
			status.SubState = value
		case "LoadState":
			status.LoadState = value
			if value == "not-found" {
				status.State = ServiceStateNotFound
			}
		case "MainPID":
			if pid, err := strconv.ParseInt(value, 10, 64); err == nil {
				status.PID = pid
			}
		case "ActiveEnterTimestamp":
			if value != "" && value != "n/a" {
				// Parse systemd timestamp format
				if t, err := time.Parse("Mon 2006-01-02 15:04:05 MST", value); err == nil {
					status.StartedAt = t
				}
			}
		case "UnitFileState":
			status.Enabled = value == "enabled"
		}
	}

	return status, nil
}

// runPrivilegedCommand runs a command with elevated privileges.
func (m *SystemManager) runPrivilegedCommand(ctx context.Context, name string, args ...string) error {
	fullArgs := append([]string{name}, args...)
	cmd := exec.CommandContext(ctx, m.privilegeCmd, fullArgs...)

	var stderr bytes.Buffer
	cmd.Stderr = &stderr

	if err := cmd.Run(); err != nil {
		return fmt.Errorf("%s: %s", err.Error(), stderr.String())
	}

	return nil
}

// getServiceFailureDetails gets the reason why a service failed to start.
func (m *SystemManager) getServiceFailureDetails(ctx context.Context, serviceName string) string {
	// Get the last few lines from journalctl for this service
	cmd := exec.CommandContext(ctx, "journalctl", "-u", serviceName, "-n", "5", "--no-pager", "-q")
	output, err := cmd.Output()
	if err != nil {
		return ""
	}

	lines := strings.TrimSpace(string(output))
	if lines == "" {
		return ""
	}

	// Look for common error patterns
	if strings.Contains(lines, "No such file or directory") {
		// Try to extract the missing file path
		if strings.Contains(lines, "sshd_config") {
			return "sshd_config file is missing - try: sudo apt reinstall openssh-server"
		}
		return "configuration file missing - check journalctl -u " + serviceName
	}

	if strings.Contains(lines, "Permission denied") {
		return "permission denied - check file permissions"
	}

	if strings.Contains(lines, "Address already in use") {
		return "port 22 is already in use by another process"
	}

	if strings.Contains(lines, "Bad configuration") || strings.Contains(lines, "error in") {
		return "configuration error - run 'sudo sshd -t' to check config"
	}

	// Return last meaningful line if we can find one
	linesList := strings.Split(lines, "\n")
	for i := len(linesList) - 1; i >= 0; i-- {
		line := strings.TrimSpace(linesList[i])
		if line != "" && !strings.Contains(line, "Starting") && !strings.Contains(line, "Stopped") {
			// Truncate if too long
			if len(line) > 200 {
				line = line[:200] + "..."
			}
			return line
		}
	}

	return ""
}

// getClientInstallInstructions returns installation instructions for SSH client.
func (m *SystemManager) getClientInstallInstructions(distro string) (packageName, installCmd string, steps []string, docsURL string) {
	switch distro {
	case "ubuntu", "debian", "pop", "linuxmint", "elementary":
		return "openssh-client",
			"sudo apt install openssh-client",
			[]string{
				"Open a terminal",
				"Run: sudo apt update",
				"Run: sudo apt install openssh-client",
				"Verify installation: ssh -V",
			},
			"https://help.ubuntu.com/community/SSH"

	case "fedora", "rhel", "centos", "rocky", "almalinux":
		return "openssh-clients",
			"sudo dnf install openssh-clients",
			[]string{
				"Open a terminal",
				"Run: sudo dnf install openssh-clients",
				"Verify installation: ssh -V",
			},
			"https://docs.fedoraproject.org/en-US/fedora/latest/system-administrators-guide/infrastructure-services/OpenSSH/"

	case "arch", "manjaro", "endeavouros":
		return "openssh",
			"sudo pacman -S openssh",
			[]string{
				"Open a terminal",
				"Run: sudo pacman -S openssh",
				"Verify installation: ssh -V",
			},
			"https://wiki.archlinux.org/title/OpenSSH"

	case "opensuse", "suse":
		return "openssh",
			"sudo zypper install openssh",
			[]string{
				"Open a terminal",
				"Run: sudo zypper install openssh",
				"Verify installation: ssh -V",
			},
			"https://en.opensuse.org/OpenSSH"

	default:
		return "openssh",
			"",
			[]string{
				"Check your distribution's package manager",
				"Search for 'openssh' or 'openssh-client' package",
				"Install using your package manager",
				"Verify installation: ssh -V",
			},
			"https://www.openssh.com/"
	}
}

// getServerInstallInstructions returns installation instructions for SSH server.
func (m *SystemManager) getServerInstallInstructions(distro string) (packageName, installCmd string, steps []string, docsURL string) {
	switch distro {
	case "ubuntu", "debian", "pop", "linuxmint", "elementary":
		return "openssh-server",
			"sudo apt install openssh-server",
			[]string{
				"Open a terminal",
				"Run: sudo apt update",
				"Run: sudo apt install openssh-server",
				"The SSH service will start automatically",
				"Verify: sudo systemctl status ssh",
			},
			"https://help.ubuntu.com/community/SSH"

	case "fedora", "rhel", "centos", "rocky", "almalinux":
		return "openssh-server",
			"sudo dnf install openssh-server",
			[]string{
				"Open a terminal",
				"Run: sudo dnf install openssh-server",
				"Start the service: sudo systemctl start sshd",
				"Enable on boot: sudo systemctl enable sshd",
				"Verify: sudo systemctl status sshd",
			},
			"https://docs.fedoraproject.org/en-US/fedora/latest/system-administrators-guide/infrastructure-services/OpenSSH/"

	case "arch", "manjaro", "endeavouros":
		return "openssh",
			"sudo pacman -S openssh",
			[]string{
				"Open a terminal",
				"Run: sudo pacman -S openssh",
				"Start the service: sudo systemctl start sshd",
				"Enable on boot: sudo systemctl enable sshd",
				"Verify: sudo systemctl status sshd",
			},
			"https://wiki.archlinux.org/title/OpenSSH"

	case "opensuse", "suse":
		return "openssh",
			"sudo zypper install openssh",
			[]string{
				"Open a terminal",
				"Run: sudo zypper install openssh",
				"Start the service: sudo systemctl start sshd",
				"Enable on boot: sudo systemctl enable sshd",
				"Verify: sudo systemctl status sshd",
			},
			"https://en.opensuse.org/OpenSSH"

	default:
		return "openssh-server",
			"",
			[]string{
				"Check your distribution's package manager",
				"Search for 'openssh-server' package",
				"Install using your package manager",
				"Start the SSH service (usually sshd or ssh)",
				"Enable the service to start on boot",
			},
			"https://www.openssh.com/"
	}
}
