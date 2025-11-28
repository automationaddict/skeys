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
	"os"
	"path/filepath"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

const sampleSSHConfig = `Host github
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_github
    IdentitiesOnly yes

Host gitlab
    HostName gitlab.com
    User git
    Port 22
    IdentityFile ~/.ssh/id_rsa_gitlab

Host server1
    HostName 192.168.1.100
    User admin
    Port 2222
    ForwardAgent yes
    ProxyJump bastion

Host *.example.com
    User deploy
    StrictHostKeyChecking no

Match host *.internal.example.com
    User internal
    Compression yes
`

func TestNewClientConfig(t *testing.T) {
	tmpDir := t.TempDir()
	configPath := filepath.Join(tmpDir, "config")

	err := os.WriteFile(configPath, []byte(sampleSSHConfig), 0600)
	require.NoError(t, err)

	config, err := NewClientConfig(WithConfigPath(configPath))
	require.NoError(t, err)
	assert.NotNil(t, config)
}

func TestNewClientConfig_EmptyFile(t *testing.T) {
	tmpDir := t.TempDir()
	configPath := filepath.Join(tmpDir, "config")

	// Don't create file - should work with empty config
	config, err := NewClientConfig(WithConfigPath(configPath))
	require.NoError(t, err)
	assert.NotNil(t, config)
}

func TestClientConfig_ListEntries(t *testing.T) {
	tmpDir := t.TempDir()
	configPath := filepath.Join(tmpDir, "config")

	err := os.WriteFile(configPath, []byte(sampleSSHConfig), 0600)
	require.NoError(t, err)

	config, err := NewClientConfig(WithConfigPath(configPath))
	require.NoError(t, err)

	entries, err := config.ListEntries()
	require.NoError(t, err)
	assert.Len(t, entries, 5) // 4 Host blocks + 1 Match block

	// Check first entry (github)
	assert.Equal(t, EntryTypeHost, entries[0].Type)
	assert.Equal(t, []string{"github"}, entries[0].Patterns)
	assert.Equal(t, "github.com", entries[0].Options.Hostname)
	assert.Equal(t, "git", entries[0].Options.User)
	assert.True(t, entries[0].Options.IdentitiesOnly)

	// Check entry with ProxyJump
	var server1 *SSHConfigEntry
	for _, e := range entries {
		if len(e.Patterns) > 0 && e.Patterns[0] == "server1" {
			server1 = e
			break
		}
	}
	require.NotNil(t, server1)
	assert.Equal(t, "bastion", server1.Options.ProxyJump)
	assert.True(t, server1.Options.ForwardAgent)
	assert.Equal(t, 2222, server1.Options.Port)

	// Check Match block
	var matchEntry *SSHConfigEntry
	for _, e := range entries {
		if e.Type == EntryTypeMatch {
			matchEntry = e
			break
		}
	}
	require.NotNil(t, matchEntry)
	assert.Equal(t, EntryTypeMatch, matchEntry.Type)
	assert.True(t, matchEntry.Options.Compression)
}

func TestClientConfig_List(t *testing.T) {
	tmpDir := t.TempDir()
	configPath := filepath.Join(tmpDir, "config")

	err := os.WriteFile(configPath, []byte(sampleSSHConfig), 0600)
	require.NoError(t, err)

	config, err := NewClientConfig(WithConfigPath(configPath))
	require.NoError(t, err)

	// List should return only Host entries (not Match)
	hosts, err := config.List()
	require.NoError(t, err)
	assert.Len(t, hosts, 4)

	// Verify all are HostEntry type
	for _, h := range hosts {
		assert.NotEmpty(t, h.Alias)
	}
}

func TestClientConfig_Get(t *testing.T) {
	tmpDir := t.TempDir()
	configPath := filepath.Join(tmpDir, "config")

	err := os.WriteFile(configPath, []byte(sampleSSHConfig), 0600)
	require.NoError(t, err)

	config, err := NewClientConfig(WithConfigPath(configPath))
	require.NoError(t, err)

	host, err := config.Get("github")
	require.NoError(t, err)
	assert.Equal(t, "github", host.Alias)
	assert.Equal(t, "github.com", host.Hostname)
	assert.Equal(t, "git", host.User)
}

func TestClientConfig_Get_NotFound(t *testing.T) {
	tmpDir := t.TempDir()
	configPath := filepath.Join(tmpDir, "config")

	err := os.WriteFile(configPath, []byte(sampleSSHConfig), 0600)
	require.NoError(t, err)

	config, err := NewClientConfig(WithConfigPath(configPath))
	require.NoError(t, err)

	_, err = config.Get("nonexistent")
	require.Error(t, err)
	assert.Contains(t, err.Error(), "host not found")
}

func TestClientConfig_GetEntry(t *testing.T) {
	tmpDir := t.TempDir()
	configPath := filepath.Join(tmpDir, "config")

	err := os.WriteFile(configPath, []byte(sampleSSHConfig), 0600)
	require.NoError(t, err)

	config, err := NewClientConfig(WithConfigPath(configPath))
	require.NoError(t, err)

	// Get all entries first
	entries, err := config.ListEntries()
	require.NoError(t, err)
	require.NotEmpty(t, entries)

	// Get by ID
	entry, err := config.GetEntry(entries[0].ID)
	require.NoError(t, err)
	assert.Equal(t, entries[0].ID, entry.ID)
}

func TestClientConfig_Add(t *testing.T) {
	tmpDir := t.TempDir()
	configPath := filepath.Join(tmpDir, "config")

	config, err := NewClientConfig(WithConfigPath(configPath))
	require.NoError(t, err)

	entry := &HostEntry{
		Alias:         "newhost",
		Hostname:      "newhost.example.com",
		User:          "testuser",
		Port:          2222,
		IdentityFiles: []string{"~/.ssh/id_newhost"},
		ForwardAgent:  true,
	}

	err = config.Add(entry)
	require.NoError(t, err)

	// Verify it was added
	hosts, err := config.List()
	require.NoError(t, err)
	assert.Len(t, hosts, 1)
	assert.Equal(t, "newhost", hosts[0].Alias)
	assert.Equal(t, "newhost.example.com", hosts[0].Hostname)
}

func TestClientConfig_Add_Duplicate(t *testing.T) {
	tmpDir := t.TempDir()
	configPath := filepath.Join(tmpDir, "config")

	err := os.WriteFile(configPath, []byte(sampleSSHConfig), 0600)
	require.NoError(t, err)

	config, err := NewClientConfig(WithConfigPath(configPath))
	require.NoError(t, err)

	entry := &HostEntry{
		Alias:    "github", // Already exists
		Hostname: "github.example.com",
	}

	err = config.Add(entry)
	require.Error(t, err)
	assert.Contains(t, err.Error(), "already exists")
}

func TestClientConfig_Update(t *testing.T) {
	tmpDir := t.TempDir()
	configPath := filepath.Join(tmpDir, "config")

	err := os.WriteFile(configPath, []byte(sampleSSHConfig), 0600)
	require.NoError(t, err)

	config, err := NewClientConfig(WithConfigPath(configPath))
	require.NoError(t, err)

	entry := &HostEntry{
		Alias:    "github",
		Hostname: "updated.github.com",
		User:     "newuser",
	}

	err = config.Update("github", entry)
	require.NoError(t, err)

	// Verify update
	updated, err := config.Get("github")
	require.NoError(t, err)
	assert.Equal(t, "updated.github.com", updated.Hostname)
	assert.Equal(t, "newuser", updated.User)
}

func TestClientConfig_Delete(t *testing.T) {
	tmpDir := t.TempDir()
	configPath := filepath.Join(tmpDir, "config")

	err := os.WriteFile(configPath, []byte(sampleSSHConfig), 0600)
	require.NoError(t, err)

	config, err := NewClientConfig(WithConfigPath(configPath))
	require.NoError(t, err)

	err = config.Delete("github")
	require.NoError(t, err)

	// Verify deletion
	_, err = config.Get("github")
	require.Error(t, err)

	// Other entries should still exist
	hosts, err := config.List()
	require.NoError(t, err)
	assert.Len(t, hosts, 3) // Was 4, now 3
}

func TestClientConfig_AddEntry(t *testing.T) {
	tmpDir := t.TempDir()
	configPath := filepath.Join(tmpDir, "config")

	config, err := NewClientConfig(WithConfigPath(configPath))
	require.NoError(t, err)

	entry := &SSHConfigEntry{
		Type:     EntryTypeHost,
		Patterns: []string{"newserver"},
		Options: SSHOptions{
			Hostname:     "newserver.example.com",
			User:         "admin",
			Port:         22,
			ForwardAgent: true,
		},
	}

	err = config.AddEntry(entry, -1)
	require.NoError(t, err)

	// Verify
	entries, err := config.ListEntries()
	require.NoError(t, err)
	assert.Len(t, entries, 1)
	assert.Equal(t, "newserver.example.com", entries[0].Options.Hostname)
}

func TestClientConfig_DeleteEntry(t *testing.T) {
	tmpDir := t.TempDir()
	configPath := filepath.Join(tmpDir, "config")

	err := os.WriteFile(configPath, []byte(sampleSSHConfig), 0600)
	require.NoError(t, err)

	config, err := NewClientConfig(WithConfigPath(configPath))
	require.NoError(t, err)

	entries, err := config.ListEntries()
	require.NoError(t, err)
	originalCount := len(entries)

	// Delete first entry
	err = config.DeleteEntry(entries[0].ID)
	require.NoError(t, err)

	// Verify
	entries, err = config.ListEntries()
	require.NoError(t, err)
	assert.Len(t, entries, originalCount-1)
}

func TestClientConfig_Backup(t *testing.T) {
	tmpDir := t.TempDir()
	configPath := filepath.Join(tmpDir, "config")

	err := os.WriteFile(configPath, []byte(sampleSSHConfig), 0600)
	require.NoError(t, err)

	config, err := NewClientConfig(WithConfigPath(configPath))
	require.NoError(t, err)

	// Trigger a save which creates backup
	err = config.Add(&HostEntry{
		Alias:    "testhost",
		Hostname: "test.example.com",
	})
	require.NoError(t, err)

	// Check backup exists
	backupPath := configPath + ".bak"
	_, err = os.Stat(backupPath)
	require.NoError(t, err)

	// Backup should contain original content
	backupContent, err := os.ReadFile(backupPath)
	require.NoError(t, err)
	assert.Equal(t, sampleSSHConfig, string(backupContent))
}

func TestClientConfig_FilePermissions(t *testing.T) {
	tmpDir := t.TempDir()
	configPath := filepath.Join(tmpDir, "config")

	config, err := NewClientConfig(WithConfigPath(configPath))
	require.NoError(t, err)

	err = config.Add(&HostEntry{
		Alias:    "testhost",
		Hostname: "test.example.com",
	})
	require.NoError(t, err)

	// Check file permissions (should be 0600)
	info, err := os.Stat(configPath)
	require.NoError(t, err)
	assert.Equal(t, os.FileMode(0600), info.Mode().Perm())
}

func TestClientConfig_GlobalDirectives(t *testing.T) {
	tmpDir := t.TempDir()
	configPath := filepath.Join(tmpDir, "config")

	sampleWithGlobal := `AddKeysToAgent yes
IdentitiesOnly yes

Host server
    HostName server.example.com
`
	err := os.WriteFile(configPath, []byte(sampleWithGlobal), 0600)
	require.NoError(t, err)

	config, err := NewClientConfig(WithConfigPath(configPath))
	require.NoError(t, err)

	directives, err := config.GetGlobalDirectives()
	require.NoError(t, err)
	assert.Len(t, directives, 2)

	// Check values
	found := make(map[string]string)
	for _, d := range directives {
		found[d.Key] = d.Value
	}
	assert.Equal(t, "yes", found["AddKeysToAgent"])
	assert.Equal(t, "yes", found["IdentitiesOnly"])
}

func TestClientConfig_SetGlobalDirective(t *testing.T) {
	tmpDir := t.TempDir()
	configPath := filepath.Join(tmpDir, "config")

	config, err := NewClientConfig(WithConfigPath(configPath))
	require.NoError(t, err)

	err = config.SetGlobalDirective("AddKeysToAgent", "yes")
	require.NoError(t, err)

	directives, err := config.GetGlobalDirectives()
	require.NoError(t, err)
	assert.Len(t, directives, 1)
	assert.Equal(t, "AddKeysToAgent", directives[0].Key)
	assert.Equal(t, "yes", directives[0].Value)
}

func TestClientConfig_DeleteGlobalDirective(t *testing.T) {
	tmpDir := t.TempDir()
	configPath := filepath.Join(tmpDir, "config")

	sample := `AddKeysToAgent yes
IdentitiesOnly yes
`
	err := os.WriteFile(configPath, []byte(sample), 0600)
	require.NoError(t, err)

	config, err := NewClientConfig(WithConfigPath(configPath))
	require.NoError(t, err)

	err = config.DeleteGlobalDirective("AddKeysToAgent")
	require.NoError(t, err)

	directives, err := config.GetGlobalDirectives()
	require.NoError(t, err)
	assert.Len(t, directives, 1)
	assert.Equal(t, "IdentitiesOnly", directives[0].Key)
}

func TestClientConfig_DeleteGlobalDirective_NotFound(t *testing.T) {
	tmpDir := t.TempDir()
	configPath := filepath.Join(tmpDir, "config")

	config, err := NewClientConfig(WithConfigPath(configPath))
	require.NoError(t, err)

	err = config.DeleteGlobalDirective("NonExistent")
	require.Error(t, err)
	assert.Contains(t, err.Error(), "not found")
}

func TestEntryType_String(t *testing.T) {
	assert.Equal(t, "Host", EntryTypeHost.String())
	assert.Equal(t, "Match", EntryTypeMatch.String())
	assert.Equal(t, "Unknown", EntryType(0).String())
}

func TestGenerateEntryID(t *testing.T) {
	entry1 := &SSHConfigEntry{
		Type:     EntryTypeHost,
		Patterns: []string{"server1"},
	}
	entry2 := &SSHConfigEntry{
		Type:     EntryTypeHost,
		Patterns: []string{"server1"},
	}
	entry3 := &SSHConfigEntry{
		Type:     EntryTypeHost,
		Patterns: []string{"server2"},
	}

	// Same content should produce same ID
	id1 := generateEntryID(entry1)
	id2 := generateEntryID(entry2)
	assert.Equal(t, id1, id2)

	// Different content should produce different ID
	id3 := generateEntryID(entry3)
	assert.NotEqual(t, id1, id3)

	// ID should be 12 characters
	assert.Len(t, id1, 12)
}

func TestParsePatternString(t *testing.T) {
	tests := []struct {
		input    string
		expected []string
	}{
		{"server1", []string{"server1"}},
		{"server1 server2", []string{"server1", "server2"}},
		{"*.example.com", []string{"*.example.com"}},
		{"  server1   server2  ", []string{"server1", "server2"}},
	}

	for _, tt := range tests {
		t.Run(tt.input, func(t *testing.T) {
			result := parsePatternString(tt.input)
			assert.Equal(t, tt.expected, result)
		})
	}
}

func TestSSHConfigEntry_ToHostEntry(t *testing.T) {
	entry := &SSHConfigEntry{
		Type:     EntryTypeHost,
		Position: 5,
		Patterns: []string{"*.example.com"},
		Options: SSHOptions{
			Hostname:      "example.com",
			User:          "admin",
			Port:          22,
			IdentityFiles: []string{"~/.ssh/id_example"},
			ForwardAgent:  true,
		},
	}

	hostEntry := entry.toHostEntry()
	assert.Equal(t, "*.example.com", hostEntry.Alias)
	assert.Equal(t, "example.com", hostEntry.Hostname)
	assert.Equal(t, "admin", hostEntry.User)
	assert.Equal(t, 22, hostEntry.Port)
	assert.True(t, hostEntry.IsPattern) // Contains wildcard
	assert.Equal(t, 5, hostEntry.LineNumber)
}

func TestHostEntryToSSHConfigEntry(t *testing.T) {
	hostEntry := &HostEntry{
		Alias:         "myserver",
		Hostname:      "myserver.example.com",
		User:          "admin",
		Port:          2222,
		IdentityFiles: []string{"~/.ssh/id_myserver"},
		ForwardAgent:  true,
		ProxyJump:     "bastion",
	}

	entry := hostEntryToSSHConfigEntry(hostEntry)
	assert.Equal(t, EntryTypeHost, entry.Type)
	assert.Equal(t, []string{"myserver"}, entry.Patterns)
	assert.Equal(t, "myserver.example.com", entry.Options.Hostname)
	assert.Equal(t, "admin", entry.Options.User)
	assert.Equal(t, 2222, entry.Options.Port)
	assert.True(t, entry.Options.ForwardAgent)
	assert.Equal(t, "bastion", entry.Options.ProxyJump)
}
