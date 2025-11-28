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
	"context"
	"os"
	"path/filepath"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/mock"
	"github.com/stretchr/testify/require"
)

// MockPrivilegeExecutor implements PrivilegeExecutor for testing
type MockPrivilegeExecutor struct {
	mock.Mock
}

func (m *MockPrivilegeExecutor) ReadFile(ctx context.Context, path string) ([]byte, error) {
	args := m.Called(ctx, path)
	if args.Get(0) == nil {
		return nil, args.Error(1)
	}
	return args.Get(0).([]byte), args.Error(1)
}

func (m *MockPrivilegeExecutor) WriteFile(ctx context.Context, path string, data []byte) error {
	args := m.Called(ctx, path, data)
	return args.Error(0)
}

func (m *MockPrivilegeExecutor) Execute(ctx context.Context, name string, execArgs ...string) ([]byte, error) {
	args := m.Called(ctx, name, execArgs)
	if args.Get(0) == nil {
		return nil, args.Error(1)
	}
	return args.Get(0).([]byte), args.Error(1)
}

const sampleSSHDConfig = `# SSH Server Configuration
Port 22
Port 2222
AddressFamily any
ListenAddress 0.0.0.0
ListenAddress ::

# Authentication
PermitRootLogin no
PubkeyAuthentication yes
#PasswordAuthentication yes
AuthorizedKeysFile .ssh/authorized_keys

# Security
X11Forwarding no
AllowAgentForwarding yes

Match User admin
    PasswordAuthentication yes
    ForceCommand /bin/admin-shell

Match Group developers
    AllowTcpForwarding yes
`

func TestNewServerConfigManager(t *testing.T) {
	mgr, err := NewServerConfigManager()
	require.NoError(t, err)
	assert.NotNil(t, mgr)
}

func TestNewServerConfigManager_WithOptions(t *testing.T) {
	mockExec := new(MockPrivilegeExecutor)
	mgr, err := NewServerConfigManager(
		WithServerConfigPath("/custom/path"),
		WithPrivilegeExecutor(mockExec),
	)
	require.NoError(t, err)
	assert.NotNil(t, mgr)
}

func TestServerConfigManager_Read(t *testing.T) {
	tmpDir := t.TempDir()
	configPath := filepath.Join(tmpDir, "sshd_config")

	err := os.WriteFile(configPath, []byte(sampleSSHDConfig), 0600)
	require.NoError(t, err)

	mgr, err := NewServerConfigManager(WithServerConfigPath(configPath))
	require.NoError(t, err)

	config, err := mgr.Read(context.Background())
	require.NoError(t, err)
	assert.NotNil(t, config)
	assert.NotEmpty(t, config.RawContent)
	assert.Equal(t, configPath, config.Path)
}

func TestServerConfigManager_Read_WithPrivilegeExecutor(t *testing.T) {
	mockExec := new(MockPrivilegeExecutor)
	mockExec.On("ReadFile", mock.Anything, "/etc/ssh/sshd_config").
		Return([]byte(sampleSSHDConfig), nil)

	mgr, err := NewServerConfigManager(WithPrivilegeExecutor(mockExec))
	require.NoError(t, err)

	config, err := mgr.Read(context.Background())
	require.NoError(t, err)
	assert.NotNil(t, config)

	mockExec.AssertExpectations(t)
}

func TestServerConfigManager_Parse(t *testing.T) {
	mgr, err := NewServerConfigManager()
	require.NoError(t, err)

	config, err := mgr.parse(sampleSSHDConfig)
	require.NoError(t, err)

	// Check we parsed directives
	assert.NotEmpty(t, config.Directives)

	// Check Port directives (should find 2)
	portCount := 0
	for _, d := range config.Directives {
		if d.Key == "Port" && !d.IsCommented {
			portCount++
		}
	}
	assert.Equal(t, 2, portCount)

	// Check commented directive
	var foundCommented bool
	for _, d := range config.Directives {
		if d.Key == "PasswordAuthentication" && d.IsCommented {
			foundCommented = true
			break
		}
	}
	assert.True(t, foundCommented)

	// Check Match block directive
	var foundMatchDirective bool
	for _, d := range config.Directives {
		if d.MatchBlock != "" {
			foundMatchDirective = true
			break
		}
	}
	assert.True(t, foundMatchDirective)
}

func TestServerConfig_GetDirective(t *testing.T) {
	mgr, err := NewServerConfigManager()
	require.NoError(t, err)

	config, err := mgr.parse(sampleSSHDConfig)
	require.NoError(t, err)

	// Get existing directive
	val, ok := config.GetDirective("PermitRootLogin")
	assert.True(t, ok)
	assert.Equal(t, "no", val)

	// Get non-existent directive
	_, ok = config.GetDirective("NonExistent")
	assert.False(t, ok)

	// Should not return commented directive
	_, ok = config.GetDirective("PasswordAuthentication")
	assert.False(t, ok)
}

func TestServerConfig_GetPort(t *testing.T) {
	mgr, err := NewServerConfigManager()
	require.NoError(t, err)

	config, err := mgr.parse(sampleSSHDConfig)
	require.NoError(t, err)

	ports := config.GetPort()
	assert.Len(t, ports, 2)
	assert.Contains(t, ports, 22)
	assert.Contains(t, ports, 2222)
}

func TestServerConfig_GetPort_Default(t *testing.T) {
	mgr, err := NewServerConfigManager()
	require.NoError(t, err)

	config, err := mgr.parse("PermitRootLogin no")
	require.NoError(t, err)

	ports := config.GetPort()
	assert.Equal(t, []int{22}, ports)
}

func TestServerConfig_GetBool(t *testing.T) {
	mgr, err := NewServerConfigManager()
	require.NoError(t, err)

	config, err := mgr.parse(sampleSSHDConfig)
	require.NoError(t, err)

	// PermitRootLogin no -> false
	result := config.GetBool("PermitRootLogin")
	require.NotNil(t, result)
	assert.False(t, *result)

	// PubkeyAuthentication yes -> true
	result = config.GetBool("PubkeyAuthentication")
	require.NotNil(t, result)
	assert.True(t, *result)

	// Non-existent returns nil
	result = config.GetBool("NonExistent")
	assert.Nil(t, result)
}

func TestServerConfigManager_Update(t *testing.T) {
	tmpDir := t.TempDir()
	configPath := filepath.Join(tmpDir, "sshd_config")

	err := os.WriteFile(configPath, []byte(sampleSSHDConfig), 0644)
	require.NoError(t, err)

	mgr, err := NewServerConfigManager(WithServerConfigPath(configPath))
	require.NoError(t, err)

	err = mgr.Update(context.Background(), "PermitRootLogin", "yes")
	require.NoError(t, err)

	// Read back and verify
	config, err := mgr.Read(context.Background())
	require.NoError(t, err)

	val, ok := config.GetDirective("PermitRootLogin")
	assert.True(t, ok)
	assert.Equal(t, "yes", val)
}

func TestServerConfigManager_Update_WithPrivilegeExecutor(t *testing.T) {
	mockExec := new(MockPrivilegeExecutor)
	mockExec.On("ReadFile", mock.Anything, "/etc/ssh/sshd_config").
		Return([]byte(sampleSSHDConfig), nil)
	mockExec.On("WriteFile", mock.Anything, "/etc/ssh/sshd_config", mock.Anything).
		Return(nil)

	mgr, err := NewServerConfigManager(WithPrivilegeExecutor(mockExec))
	require.NoError(t, err)

	err = mgr.Update(context.Background(), "PermitRootLogin", "yes")
	require.NoError(t, err)

	mockExec.AssertExpectations(t)
}

func TestServerConfigManager_UpdateDirective(t *testing.T) {
	mgr, err := NewServerConfigManager()
	require.NoError(t, err)

	// Test updating existing directive
	content := mgr.updateDirective(sampleSSHDConfig, "PermitRootLogin", "yes")
	assert.Contains(t, content, "PermitRootLogin yes")
	assert.NotContains(t, content, "PermitRootLogin no")

	// Test adding new directive
	content = mgr.updateDirective(sampleSSHDConfig, "NewDirective", "value")
	assert.Contains(t, content, "NewDirective value")
}

func TestServerConfigManager_UpdateDirective_Uncomments(t *testing.T) {
	mgr, err := NewServerConfigManager()
	require.NoError(t, err)

	// Update a commented directive should uncomment it
	content := mgr.updateDirective(sampleSSHDConfig, "PasswordAuthentication", "no")
	assert.Contains(t, content, "PasswordAuthentication no")
	assert.NotContains(t, content, "#PasswordAuthentication")
}

func TestServerConfigManager_Validate(t *testing.T) {
	mockExec := new(MockPrivilegeExecutor)
	mockExec.On("Execute", mock.Anything, "sshd", []string{"-t", "-f", "/etc/ssh/sshd_config"}).
		Return([]byte(""), nil)

	mgr, err := NewServerConfigManager(WithPrivilegeExecutor(mockExec))
	require.NoError(t, err)

	err = mgr.Validate(context.Background())
	require.NoError(t, err)

	mockExec.AssertExpectations(t)
}

func TestServerConfigManager_Validate_NoExecutor(t *testing.T) {
	mgr, err := NewServerConfigManager()
	require.NoError(t, err)

	err = mgr.Validate(context.Background())
	require.Error(t, err)
	assert.Contains(t, err.Error(), "privilege executor required")
}

func TestServerConfigManager_Validate_Failure(t *testing.T) {
	mockExec := new(MockPrivilegeExecutor)
	mockExec.On("Execute", mock.Anything, "sshd", mock.Anything).
		Return([]byte("syntax error"), assert.AnError)

	mgr, err := NewServerConfigManager(WithPrivilegeExecutor(mockExec))
	require.NoError(t, err)

	err = mgr.Validate(context.Background())
	require.Error(t, err)
	assert.Contains(t, err.Error(), "validation failed")
}

func TestServerConfigManager_RestartService(t *testing.T) {
	mockExec := new(MockPrivilegeExecutor)
	mockExec.On("Execute", mock.Anything, "systemctl", []string{"restart", "sshd"}).
		Return([]byte(""), nil)

	mgr, err := NewServerConfigManager(WithPrivilegeExecutor(mockExec))
	require.NoError(t, err)

	err = mgr.RestartService(context.Background(), false)
	require.NoError(t, err)

	mockExec.AssertExpectations(t)
}

func TestServerConfigManager_RestartService_ReloadOnly(t *testing.T) {
	mockExec := new(MockPrivilegeExecutor)
	mockExec.On("Execute", mock.Anything, "systemctl", []string{"reload", "sshd"}).
		Return([]byte(""), nil)

	mgr, err := NewServerConfigManager(WithPrivilegeExecutor(mockExec))
	require.NoError(t, err)

	err = mgr.RestartService(context.Background(), true)
	require.NoError(t, err)

	mockExec.AssertExpectations(t)
}

func TestServerConfigManager_RestartService_NoExecutor(t *testing.T) {
	mgr, err := NewServerConfigManager()
	require.NoError(t, err)

	err = mgr.RestartService(context.Background(), false)
	require.Error(t, err)
	assert.Contains(t, err.Error(), "privilege executor required")
}
