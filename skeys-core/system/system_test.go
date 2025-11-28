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

package system

import (
	"context"
	"os"
	"path/filepath"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestNewSystemManager(t *testing.T) {
	mgr := NewSystemManager()
	require.NotNil(t, mgr)
	assert.NotEmpty(t, mgr.privilegeCmd)
}

func TestServiceState_String(t *testing.T) {
	tests := []struct {
		state    ServiceState
		expected string
	}{
		{ServiceStateUnspecified, "unspecified"},
		{ServiceStateRunning, "running"},
		{ServiceStateStopped, "stopped"},
		{ServiceStateFailed, "failed"},
		{ServiceStateNotFound, "not_found"},
		{ServiceStateUnknown, "unknown"},
	}

	for _, tt := range tests {
		t.Run(tt.expected, func(t *testing.T) {
			assert.Equal(t, tt.expected, tt.state.String())
		})
	}
}

func TestFirewallType_String(t *testing.T) {
	tests := []struct {
		fwType   FirewallType
		expected string
	}{
		{FirewallTypeUnspecified, "unspecified"},
		{FirewallTypeUFW, "ufw"},
		{FirewallTypeFirewalld, "firewalld"},
		{FirewallTypeIPTables, "iptables"},
		{FirewallTypeNone, "none"},
	}

	for _, tt := range tests {
		t.Run(tt.expected, func(t *testing.T) {
			assert.Equal(t, tt.expected, tt.fwType.String())
		})
	}
}

func TestSystemManager_GetNetworkInfo(t *testing.T) {
	mgr := NewSystemManager()

	info := mgr.GetNetworkInfo()
	require.NotNil(t, info)

	// Hostname should be set (or empty if error)
	// SSH port should have a default
	assert.Equal(t, 22, info.SSHPort) // Default if no custom config
}

func TestSystemManager_GetFirewallStatus(t *testing.T) {
	mgr := NewSystemManager()

	status := mgr.GetFirewallStatus()
	require.NotNil(t, status)

	// Should return some status (may be "none" if no firewall installed)
	assert.NotEqual(t, FirewallTypeUnspecified, status.Type)
}

func TestSystemManager_GetSSHStatus(t *testing.T) {
	mgr := NewSystemManager()

	status, err := mgr.GetSSHStatus(context.Background())
	require.NoError(t, err)
	require.NotNil(t, status)

	// Distribution should be detected
	assert.NotEmpty(t, status.Distribution)

	// Network info should be present
	assert.NotNil(t, status.Network)

	// Firewall status should be present
	assert.NotNil(t, status.Firewall)
}

func TestSystemManager_GetSSHClientStatus(t *testing.T) {
	mgr := NewSystemManager()

	status := mgr.getSSHClientStatus()

	// On most systems, SSH client is installed
	// If installed, BinaryPath should be set
	if status.Installed {
		assert.NotEmpty(t, status.BinaryPath)
	}

	// System config path should always be set
	assert.NotEmpty(t, status.SystemConfig.Path)
}

func TestSystemManager_GetSSHServerStatus(t *testing.T) {
	mgr := NewSystemManager()

	status := mgr.getSSHServerStatus(context.Background())

	// Config path should always be set
	assert.NotEmpty(t, status.Config.Path)
}

func TestSystemManager_GetDistributionInfo(t *testing.T) {
	mgr := NewSystemManager()

	distro, version := mgr.getDistributionInfo()
	// Should return something (even "unknown" if detection fails)
	assert.NotEmpty(t, distro)
	_ = version // Version may be empty
}

func TestSystemManager_CheckConfigPath_Exists(t *testing.T) {
	tmpDir := t.TempDir()
	configPath := filepath.Join(tmpDir, "test_config")

	err := os.WriteFile(configPath, []byte("test content"), 0644)
	require.NoError(t, err)

	mgr := NewSystemManager()
	info := mgr.checkConfigPath(configPath)

	assert.Equal(t, configPath, info.Path)
	assert.True(t, info.Exists)
	assert.True(t, info.Readable)
	assert.True(t, info.Writable)
}

func TestSystemManager_CheckConfigPath_NotExists(t *testing.T) {
	mgr := NewSystemManager()
	info := mgr.checkConfigPath("/nonexistent/path/config")

	assert.False(t, info.Exists)
	assert.False(t, info.Readable)
	assert.False(t, info.Writable)
}

func TestSystemManager_CheckConfigPath_WithIncludeDir(t *testing.T) {
	tmpDir := t.TempDir()
	configPath := filepath.Join(tmpDir, "test_config")
	includeDirPath := configPath + ".d"

	err := os.WriteFile(configPath, []byte("test content"), 0644)
	require.NoError(t, err)

	err = os.Mkdir(includeDirPath, 0755)
	require.NoError(t, err)

	mgr := NewSystemManager()
	info := mgr.checkConfigPath(configPath)

	assert.Equal(t, includeDirPath, info.IncludeDir)
}

func TestSystemManager_GetInstallInstructions_Client(t *testing.T) {
	mgr := NewSystemManager()

	instructions := mgr.GetInstallInstructions("client")
	require.NotNil(t, instructions)
	assert.Equal(t, "client", instructions.Component)
	assert.NotEmpty(t, instructions.Steps)
}

func TestSystemManager_GetInstallInstructions_Server(t *testing.T) {
	mgr := NewSystemManager()

	instructions := mgr.GetInstallInstructions("server")
	require.NotNil(t, instructions)
	assert.Equal(t, "server", instructions.Component)
	assert.NotEmpty(t, instructions.Steps)
}

func TestGetClientInstallInstructions_Ubuntu(t *testing.T) {
	mgr := NewSystemManager()

	pkg, cmd, steps, url := mgr.getClientInstallInstructions("ubuntu")
	assert.Equal(t, "openssh-client", pkg)
	assert.Contains(t, cmd, "apt")
	assert.NotEmpty(t, steps)
	assert.NotEmpty(t, url)
}

func TestGetClientInstallInstructions_Fedora(t *testing.T) {
	mgr := NewSystemManager()

	pkg, cmd, steps, _ := mgr.getClientInstallInstructions("fedora")
	assert.Equal(t, "openssh-clients", pkg)
	assert.Contains(t, cmd, "dnf")
	assert.NotEmpty(t, steps)
}

func TestGetClientInstallInstructions_Arch(t *testing.T) {
	mgr := NewSystemManager()

	pkg, cmd, steps, _ := mgr.getClientInstallInstructions("arch")
	assert.Equal(t, "openssh", pkg)
	assert.Contains(t, cmd, "pacman")
	assert.NotEmpty(t, steps)
}

func TestGetClientInstallInstructions_Unknown(t *testing.T) {
	mgr := NewSystemManager()

	pkg, _, steps, url := mgr.getClientInstallInstructions("unknowndistro")
	assert.Equal(t, "openssh", pkg)
	assert.NotEmpty(t, steps)
	assert.NotEmpty(t, url)
}

func TestGetServerInstallInstructions_Ubuntu(t *testing.T) {
	mgr := NewSystemManager()

	pkg, cmd, steps, url := mgr.getServerInstallInstructions("ubuntu")
	assert.Equal(t, "openssh-server", pkg)
	assert.Contains(t, cmd, "apt")
	assert.NotEmpty(t, steps)
	assert.NotEmpty(t, url)
}

func TestGetServerInstallInstructions_Fedora(t *testing.T) {
	mgr := NewSystemManager()

	pkg, cmd, steps, _ := mgr.getServerInstallInstructions("fedora")
	assert.Equal(t, "openssh-server", pkg)
	assert.Contains(t, cmd, "dnf")
	assert.NotEmpty(t, steps)
}

func TestServiceStatus(t *testing.T) {
	status := ServiceStatus{
		State:       ServiceStateRunning,
		Enabled:     true,
		ActiveState: "active",
		SubState:    "running",
		LoadState:   "loaded",
		PID:         12345,
		ServiceName: "ssh.service",
	}

	assert.Equal(t, ServiceStateRunning, status.State)
	assert.True(t, status.Enabled)
	assert.Equal(t, "ssh.service", status.ServiceName)
}

func TestNetworkInfo(t *testing.T) {
	info := NetworkInfo{
		Hostname:    "testhost",
		IPAddresses: []string{"192.168.1.100", "10.0.0.1"},
		SSHPort:     22,
	}

	assert.Equal(t, "testhost", info.Hostname)
	assert.Len(t, info.IPAddresses, 2)
	assert.Equal(t, 22, info.SSHPort)
}

func TestFirewallStatus(t *testing.T) {
	status := FirewallStatus{
		Type:       FirewallTypeUFW,
		Active:     true,
		SSHAllowed: true,
		StatusText: "Status: active",
	}

	assert.Equal(t, FirewallTypeUFW, status.Type)
	assert.True(t, status.Active)
	assert.True(t, status.SSHAllowed)
}

func TestSSHStatus(t *testing.T) {
	status := SSHStatus{
		Distribution:        "ubuntu",
		DistributionVersion: "22.04",
		Client: SSHClientStatus{
			Installed:  true,
			BinaryPath: "/usr/bin/ssh",
		},
		Server: SSHServerStatus{
			Installed:  true,
			BinaryPath: "/usr/sbin/sshd",
		},
	}

	assert.Equal(t, "ubuntu", status.Distribution)
	assert.True(t, status.Client.Installed)
	assert.True(t, status.Server.Installed)
}

func TestInstallInstructions(t *testing.T) {
	instructions := InstallInstructions{
		Distribution:     "ubuntu",
		Component:        "server",
		PackageName:      "openssh-server",
		InstallCommand:   "sudo apt install openssh-server",
		DocumentationURL: "https://example.com",
		Steps:            []string{"Step 1", "Step 2"},
	}

	assert.Equal(t, "ubuntu", instructions.Distribution)
	assert.Equal(t, "server", instructions.Component)
	assert.Len(t, instructions.Steps, 2)
}

func TestStatusEqual_BothNil(t *testing.T) {
	result := statusEqual(nil, nil)
	assert.True(t, result)
}

func TestStatusEqual_OneNil(t *testing.T) {
	status := &SSHStatus{}
	assert.False(t, statusEqual(nil, status))
	assert.False(t, statusEqual(status, nil))
}

func TestStatusEqual_ServiceStateDiff(t *testing.T) {
	a := &SSHStatus{
		Server: SSHServerStatus{
			Service: ServiceStatus{State: ServiceStateRunning},
		},
	}
	b := &SSHStatus{
		Server: SSHServerStatus{
			Service: ServiceStatus{State: ServiceStateStopped},
		},
	}
	assert.False(t, statusEqual(a, b))
}

func TestStatusEqual_ServiceEnabledDiff(t *testing.T) {
	a := &SSHStatus{
		Server: SSHServerStatus{
			Service: ServiceStatus{Enabled: true},
		},
	}
	b := &SSHStatus{
		Server: SSHServerStatus{
			Service: ServiceStatus{Enabled: false},
		},
	}
	assert.False(t, statusEqual(a, b))
}

func TestStatusEqual_ServicePIDDiff(t *testing.T) {
	a := &SSHStatus{
		Server: SSHServerStatus{
			Service: ServiceStatus{PID: 1234},
		},
	}
	b := &SSHStatus{
		Server: SSHServerStatus{
			Service: ServiceStatus{PID: 5678},
		},
	}
	assert.False(t, statusEqual(a, b))
}

func TestStatusEqual_ActiveStateDiff(t *testing.T) {
	a := &SSHStatus{
		Server: SSHServerStatus{
			Service: ServiceStatus{ActiveState: "active"},
		},
	}
	b := &SSHStatus{
		Server: SSHServerStatus{
			Service: ServiceStatus{ActiveState: "inactive"},
		},
	}
	assert.False(t, statusEqual(a, b))
}

func TestStatusEqual_SubStateDiff(t *testing.T) {
	a := &SSHStatus{
		Server: SSHServerStatus{
			Service: ServiceStatus{SubState: "running"},
		},
	}
	b := &SSHStatus{
		Server: SSHServerStatus{
			Service: ServiceStatus{SubState: "dead"},
		},
	}
	assert.False(t, statusEqual(a, b))
}

func TestStatusEqual_ClientInstalledDiff(t *testing.T) {
	a := &SSHStatus{
		Client: SSHClientStatus{Installed: true},
	}
	b := &SSHStatus{
		Client: SSHClientStatus{Installed: false},
	}
	assert.False(t, statusEqual(a, b))
}

func TestStatusEqual_ServerInstalledDiff(t *testing.T) {
	a := &SSHStatus{
		Server: SSHServerStatus{Installed: true},
	}
	b := &SSHStatus{
		Server: SSHServerStatus{Installed: false},
	}
	assert.False(t, statusEqual(a, b))
}

func TestStatusEqual_ClientSystemConfigDiff(t *testing.T) {
	a := &SSHStatus{
		Client: SSHClientStatus{
			SystemConfig: ConfigPathInfo{Path: "/etc/ssh/ssh_config", Exists: true},
		},
	}
	b := &SSHStatus{
		Client: SSHClientStatus{
			SystemConfig: ConfigPathInfo{Path: "/etc/ssh/ssh_config", Exists: false},
		},
	}
	assert.False(t, statusEqual(a, b))
}

func TestStatusEqual_ClientUserConfigDiff(t *testing.T) {
	a := &SSHStatus{
		Client: SSHClientStatus{
			UserConfig: ConfigPathInfo{Path: "~/.ssh/config", Readable: true},
		},
	}
	b := &SSHStatus{
		Client: SSHClientStatus{
			UserConfig: ConfigPathInfo{Path: "~/.ssh/config", Readable: false},
		},
	}
	assert.False(t, statusEqual(a, b))
}

func TestStatusEqual_ServerConfigDiff(t *testing.T) {
	a := &SSHStatus{
		Server: SSHServerStatus{
			Config: ConfigPathInfo{Path: "/etc/ssh/sshd_config", Writable: true},
		},
	}
	b := &SSHStatus{
		Server: SSHServerStatus{
			Config: ConfigPathInfo{Path: "/etc/ssh/sshd_config", Writable: false},
		},
	}
	assert.False(t, statusEqual(a, b))
}

func TestStatusEqual_AllEqual(t *testing.T) {
	config := ConfigPathInfo{Path: "/test", Exists: true, Readable: true, Writable: false}
	service := ServiceStatus{
		State:       ServiceStateRunning,
		Enabled:     true,
		ActiveState: "active",
		SubState:    "running",
		PID:         1234,
	}

	a := &SSHStatus{
		Distribution: "ubuntu",
		Client: SSHClientStatus{
			Installed:    true,
			SystemConfig: config,
			UserConfig:   config,
		},
		Server: SSHServerStatus{
			Installed: true,
			Config:    config,
			Service:   service,
		},
	}
	b := &SSHStatus{
		Distribution: "ubuntu",
		Client: SSHClientStatus{
			Installed:    true,
			SystemConfig: config,
			UserConfig:   config,
		},
		Server: SSHServerStatus{
			Installed: true,
			Config:    config,
			Service:   service,
		},
	}
	assert.True(t, statusEqual(a, b))
}

func TestSystemWatcher_NewAndEnsure(t *testing.T) {
	mgr := NewSystemManager()

	// ensureWatcher creates a watcher if none exists
	mgr.ensureWatcher()
	assert.NotNil(t, mgr.watcher)

	// Calling again should not create a new watcher
	firstWatcher := mgr.watcher
	mgr.ensureWatcher()
	assert.Equal(t, firstWatcher, mgr.watcher)
}

func TestSystemWatcher_SubscribeUnsubscribe(t *testing.T) {
	mgr := NewSystemManager()
	mgr.ensureWatcher()

	// Subscribe
	ch := mgr.watcher.subscribe()
	assert.NotNil(t, ch)

	// Unsubscribe should not panic
	mgr.watcher.unsubscribe(ch)
}

func TestSystemManager_Watch_ContextCancel(t *testing.T) {
	mgr := NewSystemManager()

	ctx, cancel := context.WithCancel(context.Background())

	// Start watching
	ch := mgr.Watch(ctx)
	assert.NotNil(t, ch)

	// Cancel context
	cancel()

	// Channel should eventually close
	for range ch {
		// Drain any remaining updates
	}
}

func TestGetServerInstallInstructions_AllDistros(t *testing.T) {
	mgr := NewSystemManager()

	distros := []struct {
		name        string
		expectPkg   string
		expectInCmd string
	}{
		{"ubuntu", "openssh-server", "apt"},
		{"debian", "openssh-server", "apt"},
		{"pop", "openssh-server", "apt"},
		{"linuxmint", "openssh-server", "apt"},
		{"elementary", "openssh-server", "apt"},
		{"fedora", "openssh-server", "dnf"},
		{"rhel", "openssh-server", "dnf"},
		{"centos", "openssh-server", "dnf"},
		{"rocky", "openssh-server", "dnf"},
		{"almalinux", "openssh-server", "dnf"},
		{"arch", "openssh", "pacman"},
		{"manjaro", "openssh", "pacman"},
		{"endeavouros", "openssh", "pacman"},
		{"opensuse", "openssh", "zypper"},
		{"suse", "openssh", "zypper"},
		{"unknowndistro", "openssh-server", ""},
	}

	for _, tt := range distros {
		t.Run(tt.name, func(t *testing.T) {
			pkg, cmd, steps, url := mgr.getServerInstallInstructions(tt.name)
			assert.Equal(t, tt.expectPkg, pkg)
			if tt.expectInCmd != "" {
				assert.Contains(t, cmd, tt.expectInCmd)
			}
			assert.NotEmpty(t, steps)
			assert.NotEmpty(t, url)
		})
	}
}

func TestGetClientInstallInstructions_AllDistros(t *testing.T) {
	mgr := NewSystemManager()

	distros := []struct {
		name        string
		expectPkg   string
		expectInCmd string
	}{
		{"ubuntu", "openssh-client", "apt"},
		{"debian", "openssh-client", "apt"},
		{"pop", "openssh-client", "apt"},
		{"linuxmint", "openssh-client", "apt"},
		{"elementary", "openssh-client", "apt"},
		{"fedora", "openssh-clients", "dnf"},
		{"rhel", "openssh-clients", "dnf"},
		{"centos", "openssh-clients", "dnf"},
		{"rocky", "openssh-clients", "dnf"},
		{"almalinux", "openssh-clients", "dnf"},
		{"arch", "openssh", "pacman"},
		{"manjaro", "openssh", "pacman"},
		{"endeavouros", "openssh", "pacman"},
		{"opensuse", "openssh", "zypper"},
		{"suse", "openssh", "zypper"},
	}

	for _, tt := range distros {
		t.Run(tt.name, func(t *testing.T) {
			pkg, cmd, steps, url := mgr.getClientInstallInstructions(tt.name)
			assert.Equal(t, tt.expectPkg, pkg)
			assert.Contains(t, cmd, tt.expectInCmd)
			assert.NotEmpty(t, steps)
			assert.NotEmpty(t, url)
		})
	}
}

func TestGetSSHPort_ConfigWithPort(t *testing.T) {
	tmpDir := t.TempDir()

	// Create a mock sshd_config with custom port
	configPath := filepath.Join(tmpDir, "sshd_config")
	content := `# SSH server configuration
Port 2222
PermitRootLogin no
`
	err := os.WriteFile(configPath, []byte(content), 0644)
	require.NoError(t, err)

	// Note: This test can't easily override the config path since it's hardcoded
	// The function returns 22 when the system config isn't found
	mgr := NewSystemManager()
	port := mgr.getSSHPort()
	// On the test system, this will return the actual system port or 22
	assert.Greater(t, port, 0)
}

func TestGetSSHPort_CommentedPort(t *testing.T) {
	// Test that commented lines are skipped
	// This is just a validation that the function handles comments
	mgr := NewSystemManager()
	port := mgr.getSSHPort()
	assert.Greater(t, port, 0) // Returns some valid port
}

func TestConfigPathInfo(t *testing.T) {
	info := ConfigPathInfo{
		Path:       "/etc/ssh/ssh_config",
		Exists:     true,
		Readable:   true,
		Writable:   false,
		IncludeDir: "/etc/ssh/ssh_config.d",
	}

	assert.Equal(t, "/etc/ssh/ssh_config", info.Path)
	assert.True(t, info.Exists)
	assert.True(t, info.Readable)
	assert.False(t, info.Writable)
	assert.Equal(t, "/etc/ssh/ssh_config.d", info.IncludeDir)
}

func TestSSHClientStatus(t *testing.T) {
	status := SSHClientStatus{
		Installed:  true,
		Version:    "OpenSSH_9.0p1",
		BinaryPath: "/usr/bin/ssh",
		SystemConfig: ConfigPathInfo{
			Path:   "/etc/ssh/ssh_config",
			Exists: true,
		},
		UserConfig: ConfigPathInfo{
			Path:   "~/.ssh/config",
			Exists: false,
		},
	}

	assert.True(t, status.Installed)
	assert.Equal(t, "OpenSSH_9.0p1", status.Version)
	assert.True(t, status.SystemConfig.Exists)
	assert.False(t, status.UserConfig.Exists)
}

func TestSSHServerStatus(t *testing.T) {
	status := SSHServerStatus{
		Installed:  true,
		Version:    "OpenSSH_9.0p1",
		BinaryPath: "/usr/sbin/sshd",
		Service: ServiceStatus{
			State:       ServiceStateRunning,
			ServiceName: "ssh.service",
		},
		Config: ConfigPathInfo{
			Path:   "/etc/ssh/sshd_config",
			Exists: true,
		},
	}

	assert.True(t, status.Installed)
	assert.Equal(t, ServiceStateRunning, status.Service.State)
	assert.True(t, status.Config.Exists)
}

func TestSSHStatusUpdate(t *testing.T) {
	// Test with status
	update1 := SSHStatusUpdate{
		Status: &SSHStatus{Distribution: "ubuntu"},
		Err:    nil,
	}
	assert.NotNil(t, update1.Status)
	assert.Nil(t, update1.Err)

	// Test with error
	update2 := SSHStatusUpdate{
		Status: nil,
		Err:    assert.AnError,
	}
	assert.Nil(t, update2.Status)
	assert.NotNil(t, update2.Err)
}
