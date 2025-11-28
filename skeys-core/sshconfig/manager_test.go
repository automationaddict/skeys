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

package sshconfig

import (
	"bytes"
	"os"
	"path/filepath"
	"strings"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"

	"github.com/johnnelson/skeys-core/logging"
)

func TestNewManager(t *testing.T) {
	tmpDir := t.TempDir()
	configPath := filepath.Join(tmpDir, ".ssh", "config")

	mgr, err := NewManager(WithConfigPath(configPath))
	require.NoError(t, err)
	require.NotNil(t, mgr)

	assert.Equal(t, configPath, mgr.configPath)
}

func TestNewManager_DefaultPaths(t *testing.T) {
	mgr, err := NewManager()
	require.NoError(t, err)
	require.NotNil(t, mgr)

	// Should have default paths set
	assert.Contains(t, mgr.configPath, ".ssh/config")
	assert.Contains(t, mgr.agentSocket, "skeys-agent.sock")
}

func TestNewManager_WithOptions(t *testing.T) {
	tmpDir := t.TempDir()
	configPath := filepath.Join(tmpDir, "config")
	socketPath := "/tmp/test.sock"

	var buf bytes.Buffer
	log := logging.New(logging.Config{Level: "debug", Output: &buf})

	mgr, err := NewManager(
		WithConfigPath(configPath),
		WithAgentSocket(socketPath),
		WithManagerLogger(log),
	)
	require.NoError(t, err)

	assert.Equal(t, configPath, mgr.configPath)
	assert.Equal(t, socketPath, mgr.agentSocket)
}

func TestManager_GetAgentSocket(t *testing.T) {
	mgr, err := NewManager(WithAgentSocket("/test/socket.sock"))
	require.NoError(t, err)

	assert.Equal(t, "/test/socket.sock", mgr.GetAgentSocket())
}

func TestManager_IsEnabled_NoConfigFile(t *testing.T) {
	tmpDir := t.TempDir()
	configPath := filepath.Join(tmpDir, ".ssh", "config")

	mgr, err := NewManager(WithConfigPath(configPath))
	require.NoError(t, err)

	enabled, err := mgr.IsEnabled()
	require.NoError(t, err)
	assert.False(t, enabled)
}

func TestManager_IsEnabled_ConfigWithoutBlock(t *testing.T) {
	tmpDir := t.TempDir()
	sshDir := filepath.Join(tmpDir, ".ssh")
	require.NoError(t, os.MkdirAll(sshDir, 0700))

	configPath := filepath.Join(sshDir, "config")
	configContent := `Host github.com
    IdentityFile ~/.ssh/github_key
    User git
`
	require.NoError(t, os.WriteFile(configPath, []byte(configContent), 0600))

	mgr, err := NewManager(WithConfigPath(configPath))
	require.NoError(t, err)

	enabled, err := mgr.IsEnabled()
	require.NoError(t, err)
	assert.False(t, enabled)
}

func TestManager_IsEnabled_ConfigWithBlock(t *testing.T) {
	tmpDir := t.TempDir()
	sshDir := filepath.Join(tmpDir, ".ssh")
	require.NoError(t, os.MkdirAll(sshDir, 0700))

	configPath := filepath.Join(sshDir, "config")
	configContent := `# BEGIN skeys managed block
Host *
    IdentityAgent /run/user/1000/skeys-agent.sock
# END skeys managed block

Host github.com
    User git
`
	require.NoError(t, os.WriteFile(configPath, []byte(configContent), 0600))

	mgr, err := NewManager(WithConfigPath(configPath))
	require.NoError(t, err)

	enabled, err := mgr.IsEnabled()
	require.NoError(t, err)
	assert.True(t, enabled)
}

func TestManager_Enable_NewFile(t *testing.T) {
	tmpDir := t.TempDir()
	sshDir := filepath.Join(tmpDir, ".ssh")
	configPath := filepath.Join(sshDir, "config")
	socketPath := "/run/user/1000/skeys-agent.sock"

	mgr, err := NewManager(
		WithConfigPath(configPath),
		WithAgentSocket(socketPath),
	)
	require.NoError(t, err)

	err = mgr.Enable()
	require.NoError(t, err)

	// Verify file was created
	content, err := os.ReadFile(configPath)
	require.NoError(t, err)

	assert.Contains(t, string(content), "# BEGIN skeys managed block")
	assert.Contains(t, string(content), "Host *")
	assert.Contains(t, string(content), "IdentityAgent "+socketPath)
	assert.Contains(t, string(content), "# END skeys managed block")

	// Check permissions
	info, err := os.Stat(configPath)
	require.NoError(t, err)
	assert.Equal(t, os.FileMode(0600), info.Mode().Perm())
}

func TestManager_Enable_ExistingFile(t *testing.T) {
	tmpDir := t.TempDir()
	sshDir := filepath.Join(tmpDir, ".ssh")
	require.NoError(t, os.MkdirAll(sshDir, 0700))

	configPath := filepath.Join(sshDir, "config")
	existingContent := `Host github.com
    IdentityFile ~/.ssh/github_key
    User git
`
	require.NoError(t, os.WriteFile(configPath, []byte(existingContent), 0600))

	socketPath := "/run/user/1000/skeys-agent.sock"
	mgr, err := NewManager(
		WithConfigPath(configPath),
		WithAgentSocket(socketPath),
	)
	require.NoError(t, err)

	err = mgr.Enable()
	require.NoError(t, err)

	content, err := os.ReadFile(configPath)
	require.NoError(t, err)

	// Block should be prepended
	assert.True(t, strings.HasPrefix(string(content), "# BEGIN skeys managed block"))
	// Original content should still be there
	assert.Contains(t, string(content), "Host github.com")
	assert.Contains(t, string(content), "IdentityFile ~/.ssh/github_key")
}

func TestManager_Enable_AlreadyEnabled(t *testing.T) {
	tmpDir := t.TempDir()
	sshDir := filepath.Join(tmpDir, ".ssh")
	require.NoError(t, os.MkdirAll(sshDir, 0700))

	configPath := filepath.Join(sshDir, "config")
	existingContent := `# BEGIN skeys managed block
Host *
    IdentityAgent /run/user/1000/skeys-agent.sock
# END skeys managed block

Host github.com
    User git
`
	require.NoError(t, os.WriteFile(configPath, []byte(existingContent), 0600))

	mgr, err := NewManager(WithConfigPath(configPath))
	require.NoError(t, err)

	// Should be idempotent
	err = mgr.Enable()
	require.NoError(t, err)

	content, err := os.ReadFile(configPath)
	require.NoError(t, err)

	// Should not duplicate the block
	count := strings.Count(string(content), "# BEGIN skeys managed block")
	assert.Equal(t, 1, count)
}

func TestManager_Enable_CreatesBackup(t *testing.T) {
	tmpDir := t.TempDir()
	sshDir := filepath.Join(tmpDir, ".ssh")
	require.NoError(t, os.MkdirAll(sshDir, 0700))

	configPath := filepath.Join(sshDir, "config")
	originalContent := `Host github.com
    User git
`
	require.NoError(t, os.WriteFile(configPath, []byte(originalContent), 0600))

	mgr, err := NewManager(WithConfigPath(configPath))
	require.NoError(t, err)

	err = mgr.Enable()
	require.NoError(t, err)

	// Check backup was created
	backupPath := configPath + ".skeys.bak"
	backupContent, err := os.ReadFile(backupPath)
	require.NoError(t, err)
	assert.Equal(t, originalContent, string(backupContent))
}

func TestManager_Disable_NotEnabled(t *testing.T) {
	tmpDir := t.TempDir()
	sshDir := filepath.Join(tmpDir, ".ssh")
	require.NoError(t, os.MkdirAll(sshDir, 0700))

	configPath := filepath.Join(sshDir, "config")
	existingContent := `Host github.com
    User git
`
	require.NoError(t, os.WriteFile(configPath, []byte(existingContent), 0600))

	mgr, err := NewManager(WithConfigPath(configPath))
	require.NoError(t, err)

	// Should be idempotent
	err = mgr.Disable()
	require.NoError(t, err)

	content, err := os.ReadFile(configPath)
	require.NoError(t, err)
	assert.Equal(t, existingContent, string(content))
}

func TestManager_Disable_NoConfigFile(t *testing.T) {
	tmpDir := t.TempDir()
	configPath := filepath.Join(tmpDir, ".ssh", "config")

	mgr, err := NewManager(WithConfigPath(configPath))
	require.NoError(t, err)

	// Should not error on missing file
	err = mgr.Disable()
	require.NoError(t, err)
}

func TestManager_Disable_RemovesBlock(t *testing.T) {
	tmpDir := t.TempDir()
	sshDir := filepath.Join(tmpDir, ".ssh")
	require.NoError(t, os.MkdirAll(sshDir, 0700))

	configPath := filepath.Join(sshDir, "config")
	existingContent := `# BEGIN skeys managed block
Host *
    IdentityAgent /run/user/1000/skeys-agent.sock
# END skeys managed block

Host github.com
    User git
`
	require.NoError(t, os.WriteFile(configPath, []byte(existingContent), 0600))

	mgr, err := NewManager(WithConfigPath(configPath))
	require.NoError(t, err)

	err = mgr.Disable()
	require.NoError(t, err)

	content, err := os.ReadFile(configPath)
	require.NoError(t, err)

	// Block should be removed
	assert.NotContains(t, string(content), "# BEGIN skeys managed block")
	assert.NotContains(t, string(content), "# END skeys managed block")
	assert.NotContains(t, string(content), "IdentityAgent")

	// Original content should still be there
	assert.Contains(t, string(content), "Host github.com")
	assert.Contains(t, string(content), "User git")
}

func TestManager_Disable_BlockInMiddle(t *testing.T) {
	tmpDir := t.TempDir()
	sshDir := filepath.Join(tmpDir, ".ssh")
	require.NoError(t, os.MkdirAll(sshDir, 0700))

	configPath := filepath.Join(sshDir, "config")
	existingContent := `Host work.example.com
    User admin

# BEGIN skeys managed block
Host *
    IdentityAgent /run/user/1000/skeys-agent.sock
# END skeys managed block

Host github.com
    User git
`
	require.NoError(t, os.WriteFile(configPath, []byte(existingContent), 0600))

	mgr, err := NewManager(WithConfigPath(configPath))
	require.NoError(t, err)

	err = mgr.Disable()
	require.NoError(t, err)

	content, err := os.ReadFile(configPath)
	require.NoError(t, err)

	// Both hosts should remain
	assert.Contains(t, string(content), "Host work.example.com")
	assert.Contains(t, string(content), "Host github.com")
	assert.NotContains(t, string(content), "# BEGIN skeys managed block")
}

func TestManager_EnableDisable_RoundTrip(t *testing.T) {
	tmpDir := t.TempDir()
	sshDir := filepath.Join(tmpDir, ".ssh")
	require.NoError(t, os.MkdirAll(sshDir, 0700))

	configPath := filepath.Join(sshDir, "config")
	originalContent := `Host github.com
    User git
    IdentityFile ~/.ssh/github

Host work
    HostName work.example.com
    User admin
`
	require.NoError(t, os.WriteFile(configPath, []byte(originalContent), 0600))

	mgr, err := NewManager(WithConfigPath(configPath))
	require.NoError(t, err)

	// Enable
	err = mgr.Enable()
	require.NoError(t, err)

	enabled, _ := mgr.IsEnabled()
	assert.True(t, enabled)

	// Disable
	err = mgr.Disable()
	require.NoError(t, err)

	enabled, _ = mgr.IsEnabled()
	assert.False(t, enabled)

	// Content should be similar (may have slight whitespace differences)
	content, err := os.ReadFile(configPath)
	require.NoError(t, err)
	assert.Contains(t, string(content), "Host github.com")
	assert.Contains(t, string(content), "Host work")
}

func TestManager_ValidateConfig_NoFile(t *testing.T) {
	tmpDir := t.TempDir()
	configPath := filepath.Join(tmpDir, ".ssh", "config")

	mgr, err := NewManager(WithConfigPath(configPath))
	require.NoError(t, err)

	// Should not error on missing file
	err = mgr.ValidateConfig()
	require.NoError(t, err)
}

func TestManager_ValidateConfig_ValidConfig(t *testing.T) {
	tmpDir := t.TempDir()
	sshDir := filepath.Join(tmpDir, ".ssh")
	require.NoError(t, os.MkdirAll(sshDir, 0700))

	configPath := filepath.Join(sshDir, "config")
	validContent := `# Comment line
Host github.com
    User git
    IdentityFile ~/.ssh/github

Host *
    AddKeysToAgent yes
    IdentitiesOnly yes
`
	require.NoError(t, os.WriteFile(configPath, []byte(validContent), 0600))

	mgr, err := NewManager(WithConfigPath(configPath))
	require.NoError(t, err)

	err = mgr.ValidateConfig()
	require.NoError(t, err)
}

func TestManager_ValidateConfig_EmptyFile(t *testing.T) {
	tmpDir := t.TempDir()
	sshDir := filepath.Join(tmpDir, ".ssh")
	require.NoError(t, os.MkdirAll(sshDir, 0700))

	configPath := filepath.Join(sshDir, "config")
	require.NoError(t, os.WriteFile(configPath, []byte(""), 0600))

	mgr, err := NewManager(WithConfigPath(configPath))
	require.NoError(t, err)

	err = mgr.ValidateConfig()
	require.NoError(t, err)
}

func TestManager_buildManagedBlock(t *testing.T) {
	socketPath := "/run/user/1000/skeys-agent.sock"
	mgr := &Manager{
		agentSocket: socketPath,
	}

	block := mgr.buildManagedBlock()

	assert.Contains(t, block, "# BEGIN skeys managed block")
	assert.Contains(t, block, "Host *")
	assert.Contains(t, block, "IdentityAgent "+socketPath)
	assert.Contains(t, block, "# END skeys managed block")
}

func TestManager_removeManagedBlock(t *testing.T) {
	mgr := &Manager{}

	tests := []struct {
		name        string
		input       string
		expectedOut string
		expectedChg bool
	}{
		{
			name:        "no block",
			input:       "Host github.com\n    User git\n",
			expectedOut: "Host github.com\n    User git\n",
			expectedChg: false,
		},
		{
			name: "block at start",
			input: `# BEGIN skeys managed block
Host *
    IdentityAgent /tmp/test.sock
# END skeys managed block

Host github.com
    User git`,
			expectedOut: "Host github.com\n    User git",
			expectedChg: true,
		},
		{
			name: "block in middle",
			input: `Host work
    User admin

# BEGIN skeys managed block
Host *
    IdentityAgent /tmp/test.sock
# END skeys managed block

Host github.com
    User git`,
			expectedOut: "Host work\n    User admin\n\n\nHost github.com\n    User git",
			expectedChg: true,
		},
		{
			name: "block at end",
			input: `Host github.com
    User git

# BEGIN skeys managed block
Host *
    IdentityAgent /tmp/test.sock
# END skeys managed block`,
			expectedOut: "Host github.com\n    User git",
			expectedChg: true,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			result, changed := mgr.removeManagedBlock(tt.input)
			assert.Equal(t, tt.expectedChg, changed)
			if changed {
				// Just check that block markers are gone
				assert.NotContains(t, result, "# BEGIN skeys managed block")
				assert.NotContains(t, result, "# END skeys managed block")
			}
		})
	}
}

func TestManager_SshDirPermissions(t *testing.T) {
	tmpDir := t.TempDir()
	sshDir := filepath.Join(tmpDir, ".ssh")
	configPath := filepath.Join(sshDir, "config")

	mgr, err := NewManager(WithConfigPath(configPath))
	require.NoError(t, err)

	err = mgr.Enable()
	require.NoError(t, err)

	// Check .ssh directory permissions
	info, err := os.Stat(sshDir)
	require.NoError(t, err)
	assert.Equal(t, os.FileMode(0700), info.Mode().Perm())
}
