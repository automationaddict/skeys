package system

import (
	"bufio"
	"bytes"
	"net"
	"os"
	"os/exec"
	"regexp"
	"strconv"
	"strings"
)

// NetworkInfo contains network information relevant to SSH.
type NetworkInfo struct {
	Hostname    string
	IPAddresses []string
	SSHPort     int
}

// FirewallType represents the type of firewall detected.
type FirewallType int

const (
	FirewallTypeUnspecified FirewallType = iota
	FirewallTypeUFW
	FirewallTypeFirewalld
	FirewallTypeIPTables
	FirewallTypeNone
)

func (f FirewallType) String() string {
	switch f {
	case FirewallTypeUFW:
		return "ufw"
	case FirewallTypeFirewalld:
		return "firewalld"
	case FirewallTypeIPTables:
		return "iptables"
	case FirewallTypeNone:
		return "none"
	default:
		return "unspecified"
	}
}

// FirewallStatus contains firewall status information.
type FirewallStatus struct {
	Type       FirewallType
	Active     bool
	SSHAllowed bool
	StatusText string
}

// GetNetworkInfo returns network information for the system.
func (m *SystemManager) GetNetworkInfo() *NetworkInfo {
	info := &NetworkInfo{
		SSHPort: 22, // Default SSH port
	}

	// Get hostname
	if hostname, err := os.Hostname(); err == nil {
		info.Hostname = hostname
	}

	// Get IP addresses (non-loopback)
	info.IPAddresses = m.getIPAddresses()

	// Get SSH port from sshd_config
	info.SSHPort = m.getSSHPort()

	return info
}

// GetFirewallStatus returns the firewall status.
func (m *SystemManager) GetFirewallStatus() *FirewallStatus {
	// Try UFW first (Ubuntu/Debian)
	if status := m.checkUFW(); status != nil {
		return status
	}

	// Try firewalld (Fedora/RHEL)
	if status := m.checkFirewalld(); status != nil {
		return status
	}

	// No known firewall manager detected
	return &FirewallStatus{
		Type:       FirewallTypeNone,
		Active:     false,
		SSHAllowed: true, // Assume allowed if no firewall
		StatusText: "no firewall detected",
	}
}

// getIPAddresses returns non-loopback IP addresses.
func (m *SystemManager) getIPAddresses() []string {
	var addresses []string

	interfaces, err := net.Interfaces()
	if err != nil {
		return addresses
	}

	for _, iface := range interfaces {
		// Skip loopback and down interfaces
		if iface.Flags&net.FlagLoopback != 0 {
			continue
		}
		if iface.Flags&net.FlagUp == 0 {
			continue
		}

		addrs, err := iface.Addrs()
		if err != nil {
			continue
		}

		for _, addr := range addrs {
			var ip net.IP
			switch v := addr.(type) {
			case *net.IPNet:
				ip = v.IP
			case *net.IPAddr:
				ip = v.IP
			}

			if ip == nil || ip.IsLoopback() {
				continue
			}

			// Include both IPv4 and IPv6
			addresses = append(addresses, ip.String())
		}
	}

	return addresses
}

// getSSHPort parses sshd_config to find the SSH listening port.
func (m *SystemManager) getSSHPort() int {
	configPaths := []string{
		"/etc/ssh/sshd_config",
	}

	// Also check sshd_config.d directory for included configs
	configDir := "/etc/ssh/sshd_config.d"
	if entries, err := os.ReadDir(configDir); err == nil {
		for _, entry := range entries {
			if !entry.IsDir() && strings.HasSuffix(entry.Name(), ".conf") {
				configPaths = append(configPaths, configDir+"/"+entry.Name())
			}
		}
	}

	portRegex := regexp.MustCompile(`(?i)^\s*Port\s+(\d+)`)

	for _, configPath := range configPaths {
		file, err := os.Open(configPath)
		if err != nil {
			continue
		}
		defer file.Close()

		scanner := bufio.NewScanner(file)
		for scanner.Scan() {
			line := scanner.Text()
			// Skip comments
			if strings.HasPrefix(strings.TrimSpace(line), "#") {
				continue
			}

			if matches := portRegex.FindStringSubmatch(line); len(matches) > 1 {
				if port, err := strconv.Atoi(matches[1]); err == nil {
					return port
				}
			}
		}
	}

	return 22 // Default port
}

// checkUFW checks UFW firewall status.
func (m *SystemManager) checkUFW() *FirewallStatus {
	// Check if ufw is installed
	if _, err := exec.LookPath("ufw"); err != nil {
		return nil
	}

	status := &FirewallStatus{
		Type: FirewallTypeUFW,
	}

	// Get UFW status
	cmd := exec.Command("ufw", "status")
	var stdout bytes.Buffer
	cmd.Stdout = &stdout
	if err := cmd.Run(); err != nil {
		status.StatusText = "ufw installed but status unknown"
		return status
	}

	output := stdout.String()
	status.StatusText = strings.TrimSpace(strings.Split(output, "\n")[0])

	if strings.Contains(output, "Status: active") {
		status.Active = true

		// Check if SSH is allowed
		// Look for lines like "22/tcp ALLOW" or "OpenSSH ALLOW"
		lines := strings.Split(output, "\n")
		for _, line := range lines {
			line = strings.ToLower(line)
			if (strings.Contains(line, "22") || strings.Contains(line, "ssh") || strings.Contains(line, "openssh")) &&
				strings.Contains(line, "allow") {
				status.SSHAllowed = true
				break
			}
		}
	} else if strings.Contains(output, "Status: inactive") {
		status.Active = false
		status.SSHAllowed = true // If inactive, all traffic allowed
	}

	return status
}

// checkFirewalld checks firewalld status.
func (m *SystemManager) checkFirewalld() *FirewallStatus {
	// Check if firewall-cmd is installed
	if _, err := exec.LookPath("firewall-cmd"); err != nil {
		return nil
	}

	status := &FirewallStatus{
		Type: FirewallTypeFirewalld,
	}

	// Check if firewalld is running
	cmd := exec.Command("firewall-cmd", "--state")
	var stdout bytes.Buffer
	cmd.Stdout = &stdout
	if err := cmd.Run(); err != nil {
		status.StatusText = "firewalld installed but not running"
		status.Active = false
		status.SSHAllowed = true // If not running, all traffic allowed
		return status
	}

	state := strings.TrimSpace(stdout.String())
	status.StatusText = state

	if state == "running" {
		status.Active = true

		// Check if SSH service is allowed
		cmd := exec.Command("firewall-cmd", "--list-services")
		var servicesOutput bytes.Buffer
		cmd.Stdout = &servicesOutput
		if err := cmd.Run(); err == nil {
			services := servicesOutput.String()
			if strings.Contains(services, "ssh") {
				status.SSHAllowed = true
			}
		}

		// Also check if port 22 is explicitly allowed
		if !status.SSHAllowed {
			cmd := exec.Command("firewall-cmd", "--list-ports")
			var portsOutput bytes.Buffer
			cmd.Stdout = &portsOutput
			if err := cmd.Run(); err == nil {
				ports := portsOutput.String()
				if strings.Contains(ports, "22/tcp") {
					status.SSHAllowed = true
				}
			}
		}
	}

	return status
}
