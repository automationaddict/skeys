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

package hosts

import (
	"os"
	"path/filepath"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

const sampleAuthorizedKeys = `ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnk... user@host1
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAB... user@host2
# This is a comment
command="/bin/ls",no-pty ssh-ed25519 AAAAC3NzaC1lZDI1NTE5... restricted@host
from="192.168.1.*",no-agent-forwarding ssh-rsa AAAAB3... network@host
`

func TestNewAuthorizedKeysManager(t *testing.T) {
	tmpDir := t.TempDir()
	authKeysPath := filepath.Join(tmpDir, "authorized_keys")

	mgr, err := NewAuthorizedKeysManager(WithAuthorizedKeysPath(authKeysPath))
	require.NoError(t, err)
	assert.NotNil(t, mgr)
}

func TestAuthorizedKeysManager_List_Empty(t *testing.T) {
	tmpDir := t.TempDir()
	authKeysPath := filepath.Join(tmpDir, "authorized_keys")

	mgr, err := NewAuthorizedKeysManager(WithAuthorizedKeysPath(authKeysPath))
	require.NoError(t, err)

	keys, err := mgr.List()
	require.NoError(t, err)
	assert.Empty(t, keys)
}

func TestAuthorizedKeysManager_List_WithEntries(t *testing.T) {
	tmpDir := t.TempDir()
	authKeysPath := filepath.Join(tmpDir, "authorized_keys")

	err := os.WriteFile(authKeysPath, []byte(sampleAuthorizedKeys), 0600)
	require.NoError(t, err)

	mgr, err := NewAuthorizedKeysManager(WithAuthorizedKeysPath(authKeysPath))
	require.NoError(t, err)

	keys, err := mgr.List()
	require.NoError(t, err)
	assert.Len(t, keys, 4)

	// Check first entry (simple key)
	assert.Equal(t, "ssh-ed25519", keys[0].KeyType)
	assert.Equal(t, "user@host1", keys[0].Comment)
	assert.Empty(t, keys[0].Options)

	// Check second entry
	assert.Equal(t, "ssh-rsa", keys[1].KeyType)
	assert.Equal(t, "user@host2", keys[1].Comment)

	// Check third entry (with options)
	assert.Equal(t, "ssh-ed25519", keys[2].KeyType)
	assert.Equal(t, "restricted@host", keys[2].Comment)
	assert.Contains(t, keys[2].Options, `command="/bin/ls"`)
	assert.Contains(t, keys[2].Options, "no-pty")

	// Check fourth entry (with from restriction)
	assert.Contains(t, keys[3].Options, `from="192.168.1.*"`)
	assert.Contains(t, keys[3].Options, "no-agent-forwarding")
}

func TestAuthorizedKeysManager_ParseLine(t *testing.T) {
	mgr, err := NewAuthorizedKeysManager(WithAuthorizedKeysPath("/tmp/test"))
	require.NoError(t, err)

	tests := []struct {
		name       string
		line       string
		keyType    string
		comment    string
		options    []string
		shouldSkip bool
	}{
		{
			name:    "simple ed25519",
			line:    "ssh-ed25519 AAAAC3NzaC1... user@example",
			keyType: "ssh-ed25519",
			comment: "user@example",
			options: nil,
		},
		{
			name:    "simple rsa",
			line:    "ssh-rsa AAAAB3... comment with spaces",
			keyType: "ssh-rsa",
			comment: "comment with spaces",
			options: nil,
		},
		{
			name:    "ecdsa",
			line:    "ecdsa-sha2-nistp256 AAAAE2... user",
			keyType: "ecdsa-sha2-nistp256",
			comment: "user",
		},
		{
			name:    "sk-ssh-ed25519",
			line:    "sk-ssh-ed25519@openssh.com AAAA... security-key",
			keyType: "sk-ssh-ed25519@openssh.com",
			comment: "security-key",
		},
		{
			name:    "with simple command option",
			line:    `command="/bin/ls" ssh-ed25519 AAAA... user`,
			keyType: "ssh-ed25519",
			comment: "user",
			options: []string{`command="/bin/ls"`},
		},
		{
			name:    "with multiple options",
			line:    `no-pty,no-agent-forwarding,from="10.0.0.*" ssh-rsa AAAA... restricted`,
			keyType: "ssh-rsa",
			comment: "restricted",
			options: []string{"no-pty", "no-agent-forwarding", `from="10.0.0.*"`},
		},
		{
			name:       "invalid - single field",
			line:       "justonefield",
			shouldSkip: true,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			result := mgr.parseLine(tt.line, 1)
			if tt.shouldSkip {
				assert.Nil(t, result)
			} else {
				require.NotNil(t, result)
				assert.Equal(t, tt.keyType, result.KeyType)
				assert.Equal(t, tt.comment, result.Comment)
				if tt.options != nil {
					assert.Equal(t, tt.options, result.Options)
				}
			}
		})
	}
}

func TestParseOptions(t *testing.T) {
	tests := []struct {
		input    string
		expected []string
	}{
		{
			input:    "no-pty",
			expected: []string{"no-pty"},
		},
		{
			input:    "no-pty,no-agent-forwarding",
			expected: []string{"no-pty", "no-agent-forwarding"},
		},
		{
			input:    `command="/bin/ls"`,
			expected: []string{`command="/bin/ls"`},
		},
		{
			input:    `command="/bin/ls -la",no-pty`,
			expected: []string{`command="/bin/ls -la"`, "no-pty"},
		},
		{
			input:    `from="192.168.1.*,10.0.0.*",no-pty`,
			expected: []string{`from="192.168.1.*,10.0.0.*"`, "no-pty"},
		},
		{
			input:    `command="echo \"hello\""`,
			expected: []string{`command="echo \"hello\""`},
		},
	}

	for _, tt := range tests {
		t.Run(tt.input, func(t *testing.T) {
			result := parseOptions(tt.input)
			assert.Equal(t, tt.expected, result)
		})
	}
}

func TestAuthorizedKeysManager_Add(t *testing.T) {
	tmpDir := t.TempDir()
	authKeysPath := filepath.Join(tmpDir, "authorized_keys")

	mgr, err := NewAuthorizedKeysManager(WithAuthorizedKeysPath(authKeysPath))
	require.NoError(t, err)

	// Add without options
	err = mgr.Add("ssh-ed25519 AAAAC3... user@test", nil)
	require.NoError(t, err)

	content, err := os.ReadFile(authKeysPath)
	require.NoError(t, err)
	assert.Contains(t, string(content), "ssh-ed25519 AAAAC3... user@test")
}

func TestAuthorizedKeysManager_Add_WithOptions(t *testing.T) {
	tmpDir := t.TempDir()
	authKeysPath := filepath.Join(tmpDir, "authorized_keys")

	mgr, err := NewAuthorizedKeysManager(WithAuthorizedKeysPath(authKeysPath))
	require.NoError(t, err)

	err = mgr.Add("ssh-ed25519 AAAAC3... user@test", []string{"no-pty", `command="/bin/ls"`})
	require.NoError(t, err)

	content, err := os.ReadFile(authKeysPath)
	require.NoError(t, err)
	assert.Contains(t, string(content), `no-pty,command="/bin/ls" ssh-ed25519`)
}

func TestAuthorizedKeysManager_Add_CreatesDirectory(t *testing.T) {
	tmpDir := t.TempDir()
	authKeysPath := filepath.Join(tmpDir, ".ssh", "authorized_keys")

	mgr, err := NewAuthorizedKeysManager(WithAuthorizedKeysPath(authKeysPath))
	require.NoError(t, err)

	err = mgr.Add("ssh-ed25519 AAAAC3... user@test", nil)
	require.NoError(t, err)

	// Verify directory was created
	info, err := os.Stat(filepath.Dir(authKeysPath))
	require.NoError(t, err)
	assert.True(t, info.IsDir())
}

func TestAuthorizedKeysManager_Remove(t *testing.T) {
	tmpDir := t.TempDir()
	authKeysPath := filepath.Join(tmpDir, "authorized_keys")

	// Create file with multiple keys
	content := `ssh-ed25519 AAAAC3... user1
ssh-rsa AAAAB3... user2
ssh-ed25519 AAAAC4... user3
`
	err := os.WriteFile(authKeysPath, []byte(content), 0600)
	require.NoError(t, err)

	mgr, err := NewAuthorizedKeysManager(WithAuthorizedKeysPath(authKeysPath))
	require.NoError(t, err)

	// Remove line 2
	err = mgr.Remove(2)
	require.NoError(t, err)

	// Verify
	keys, err := mgr.List()
	require.NoError(t, err)
	assert.Len(t, keys, 2)
	assert.Equal(t, "user1", keys[0].Comment)
	assert.Equal(t, "user3", keys[1].Comment)
}

func TestAuthorizedKeysManager_Update(t *testing.T) {
	tmpDir := t.TempDir()
	authKeysPath := filepath.Join(tmpDir, "authorized_keys")

	content := "ssh-ed25519 AAAAC3... user1\n"
	err := os.WriteFile(authKeysPath, []byte(content), 0600)
	require.NoError(t, err)

	mgr, err := NewAuthorizedKeysManager(WithAuthorizedKeysPath(authKeysPath))
	require.NoError(t, err)

	// Add options to line 1
	err = mgr.Update(1, []string{"no-pty", "no-agent-forwarding"})
	require.NoError(t, err)

	// Verify
	keys, err := mgr.List()
	require.NoError(t, err)
	require.Len(t, keys, 1)
	assert.Contains(t, keys[0].Options, "no-pty")
	assert.Contains(t, keys[0].Options, "no-agent-forwarding")
}

func TestAuthorizedKeysManager_Update_RemoveOptions(t *testing.T) {
	tmpDir := t.TempDir()
	authKeysPath := filepath.Join(tmpDir, "authorized_keys")

	content := "no-pty ssh-ed25519 AAAAC3... user1\n"
	err := os.WriteFile(authKeysPath, []byte(content), 0600)
	require.NoError(t, err)

	mgr, err := NewAuthorizedKeysManager(WithAuthorizedKeysPath(authKeysPath))
	require.NoError(t, err)

	// Remove all options
	err = mgr.Update(1, nil)
	require.NoError(t, err)

	// Verify
	keys, err := mgr.List()
	require.NoError(t, err)
	require.Len(t, keys, 1)
	assert.Empty(t, keys[0].Options)
}

func TestAuthorizedKeysManager_FilePermissions(t *testing.T) {
	tmpDir := t.TempDir()
	authKeysPath := filepath.Join(tmpDir, "authorized_keys")

	mgr, err := NewAuthorizedKeysManager(WithAuthorizedKeysPath(authKeysPath))
	require.NoError(t, err)

	err = mgr.Add("ssh-ed25519 AAAAC3... user@test", nil)
	require.NoError(t, err)

	info, err := os.Stat(authKeysPath)
	require.NoError(t, err)
	assert.Equal(t, os.FileMode(0600), info.Mode().Perm())
}
