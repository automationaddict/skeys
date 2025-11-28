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

package adapter

import (
	"testing"

	"github.com/stretchr/testify/assert"

	"github.com/automationaddict/skeys-core/config"
	pb "github.com/automationaddict/skeys-daemon/api/gen/skeys/v1"
)

func TestToProtoHostConfig(t *testing.T) {
	entry := &config.HostEntry{
		Alias:                 "github",
		Hostname:              "github.com",
		User:                  "git",
		Port:                  22,
		IdentityFiles:         []string{"~/.ssh/github_ed25519"},
		ProxyJump:             "bastion",
		ProxyCommand:          "",
		ForwardAgent:          true,
		IdentitiesOnly:        true,
		StrictHostKeyChecking: "yes",
		ServerAliveInterval:   60,
		ServerAliveCountMax:   3,
		ExtraOptions:          map[string]string{"AddKeysToAgent": "yes"},
		IsPattern:             false,
		LineNumber:            15,
	}

	pbConfig := toProtoHostConfig(entry)
	assert.Equal(t, "github", pbConfig.Alias)
	assert.Equal(t, "github.com", pbConfig.Hostname)
	assert.Equal(t, "git", pbConfig.User)
	assert.Equal(t, int32(22), pbConfig.Port)
	assert.Equal(t, []string{"~/.ssh/github_ed25519"}, pbConfig.IdentityFiles)
	assert.Equal(t, "bastion", pbConfig.ProxyJump)
	assert.Empty(t, pbConfig.ProxyCommand)
	assert.True(t, pbConfig.ForwardAgent)
	assert.True(t, pbConfig.IdentitiesOnly)
	assert.Equal(t, "yes", pbConfig.StrictHostKeyChecking)
	assert.Equal(t, int32(60), pbConfig.ServerAliveInterval)
	assert.Equal(t, int32(3), pbConfig.ServerAliveCountMax)
	assert.Equal(t, map[string]string{"AddKeysToAgent": "yes"}, pbConfig.ExtraOptions)
	assert.False(t, pbConfig.IsPattern)
	assert.Equal(t, int32(15), pbConfig.LineNumber)
}

func TestFromProtoHostConfig(t *testing.T) {
	pbConfig := &pb.HostConfig{
		Alias:                 "production",
		Hostname:              "prod.example.com",
		User:                  "admin",
		Port:                  2222,
		IdentityFiles:         []string{"~/.ssh/prod_key"},
		ProxyJump:             "",
		ProxyCommand:          "ssh -W %h:%p bastion",
		ForwardAgent:          false,
		IdentitiesOnly:        true,
		StrictHostKeyChecking: "ask",
		ServerAliveInterval:   30,
		ServerAliveCountMax:   5,
		ExtraOptions:          map[string]string{"Compression": "yes"},
		IsPattern:             true,
		LineNumber:            42,
	}

	entry := fromProtoHostConfig(pbConfig)
	assert.Equal(t, "production", entry.Alias)
	assert.Equal(t, "prod.example.com", entry.Hostname)
	assert.Equal(t, "admin", entry.User)
	assert.Equal(t, 2222, entry.Port)
	assert.Equal(t, []string{"~/.ssh/prod_key"}, entry.IdentityFiles)
	assert.Empty(t, entry.ProxyJump)
	assert.Equal(t, "ssh -W %h:%p bastion", entry.ProxyCommand)
	assert.False(t, entry.ForwardAgent)
	assert.True(t, entry.IdentitiesOnly)
	assert.Equal(t, "ask", entry.StrictHostKeyChecking)
	assert.Equal(t, 30, entry.ServerAliveInterval)
	assert.Equal(t, 5, entry.ServerAliveCountMax)
	assert.Equal(t, map[string]string{"Compression": "yes"}, entry.ExtraOptions)
	assert.True(t, entry.IsPattern)
	assert.Equal(t, 42, entry.LineNumber)
}

func TestToProtoServerConfig(t *testing.T) {
	cfg := &config.ServerConfig{
		Directives: []config.ServerDirective{
			{
				Key:         "Port",
				Value:       "22",
				LineNumber:  5,
				IsCommented: false,
				MatchBlock:  "",
			},
			{
				Key:         "PermitRootLogin",
				Value:       "no",
				LineNumber:  10,
				IsCommented: false,
				MatchBlock:  "",
			},
			{
				Key:         "PasswordAuthentication",
				Value:       "yes",
				LineNumber:  15,
				IsCommented: true,
				MatchBlock:  "",
			},
			{
				Key:         "AllowUsers",
				Value:       "admin",
				LineNumber:  25,
				IsCommented: false,
				MatchBlock:  "Match User admin",
			},
		},
		RawContent: "Port 22\nPermitRootLogin no\n#PasswordAuthentication yes\n",
	}

	pbConfig := toProtoServerConfig(cfg)
	assert.Len(t, pbConfig.Directives, 4)
	assert.Equal(t, "Port", pbConfig.Directives[0].Key)
	assert.Equal(t, "22", pbConfig.Directives[0].Value)
	assert.Equal(t, int32(5), pbConfig.Directives[0].LineNumber)
	assert.False(t, pbConfig.Directives[0].IsCommented)
	assert.Empty(t, pbConfig.Directives[0].MatchBlock)

	assert.Equal(t, "PermitRootLogin", pbConfig.Directives[1].Key)
	assert.Equal(t, "no", pbConfig.Directives[1].Value)

	assert.True(t, pbConfig.Directives[2].IsCommented)

	assert.Equal(t, "Match User admin", pbConfig.Directives[3].MatchBlock)
	assert.Contains(t, pbConfig.RawContent, "Port 22")
}

func TestToProtoSSHConfigEntry_Host(t *testing.T) {
	entry := &config.SSHConfigEntry{
		ID:       "entry-1",
		Type:     config.EntryTypeHost,
		Position: 0,
		Patterns: []string{"github.com", "*.github.com"},
		Options: config.SSHOptions{
			Hostname:              "github.com",
			Port:                  22,
			User:                  "git",
			IdentityFiles:         []string{"~/.ssh/github"},
			ForwardAgent:          true,
			IdentitiesOnly:        true,
			StrictHostKeyChecking: "yes",
			ServerAliveInterval:   60,
			ServerAliveCountMax:   3,
			Compression:           true,
			ExtraOptions:          map[string]string{"AddKeysToAgent": "yes"},
		},
	}

	pbEntry := toProtoSSHConfigEntry(entry)
	assert.Equal(t, "entry-1", pbEntry.Id)
	assert.Equal(t, pb.SSHConfigEntryType_SSH_CONFIG_ENTRY_TYPE_HOST, pbEntry.Type)
	assert.Equal(t, int32(0), pbEntry.Position)
	assert.Equal(t, []string{"github.com", "*.github.com"}, pbEntry.Patterns)
	assert.Equal(t, "github.com", pbEntry.Options.Hostname)
	assert.Equal(t, int32(22), pbEntry.Options.Port)
	assert.Equal(t, "git", pbEntry.Options.User)
	assert.True(t, pbEntry.Options.ForwardAgent)
	assert.True(t, pbEntry.Options.Compression)
}

func TestToProtoSSHConfigEntry_Match(t *testing.T) {
	entry := &config.SSHConfigEntry{
		ID:       "entry-2",
		Type:     config.EntryTypeMatch,
		Position: 1,
		Patterns: []string{"host *.example.com user admin"},
		Options: config.SSHOptions{
			User: "root",
		},
	}

	pbEntry := toProtoSSHConfigEntry(entry)
	assert.Equal(t, "entry-2", pbEntry.Id)
	assert.Equal(t, pb.SSHConfigEntryType_SSH_CONFIG_ENTRY_TYPE_MATCH, pbEntry.Type)
	assert.Equal(t, int32(1), pbEntry.Position)
}

func TestFromProtoSSHConfigEntry_Host(t *testing.T) {
	pbEntry := &pb.SSHConfigEntry{
		Id:       "proto-entry-1",
		Type:     pb.SSHConfigEntryType_SSH_CONFIG_ENTRY_TYPE_HOST,
		Position: 5,
		Patterns: []string{"prod-*"},
		Options: &pb.SSHOptions{
			Hostname:              "prod.example.com",
			Port:                  2222,
			User:                  "deploy",
			IdentityFiles:         []string{"~/.ssh/deploy_key"},
			ProxyJump:             "bastion",
			ForwardAgent:          false,
			IdentitiesOnly:        true,
			StrictHostKeyChecking: "no",
			ServerAliveInterval:   30,
			ServerAliveCountMax:   5,
			Compression:           false,
			ExtraOptions:          map[string]string{"LogLevel": "ERROR"},
		},
	}

	entry := fromProtoSSHConfigEntry(pbEntry)
	assert.Equal(t, "proto-entry-1", entry.ID)
	assert.Equal(t, config.EntryTypeHost, entry.Type)
	assert.Equal(t, 5, entry.Position)
	assert.Equal(t, []string{"prod-*"}, entry.Patterns)
	assert.Equal(t, "prod.example.com", entry.Options.Hostname)
	assert.Equal(t, 2222, entry.Options.Port)
	assert.Equal(t, "deploy", entry.Options.User)
	assert.Equal(t, "bastion", entry.Options.ProxyJump)
	assert.False(t, entry.Options.ForwardAgent)
	assert.True(t, entry.Options.IdentitiesOnly)
}

func TestFromProtoSSHConfigEntry_Match(t *testing.T) {
	pbEntry := &pb.SSHConfigEntry{
		Id:       "proto-entry-2",
		Type:     pb.SSHConfigEntryType_SSH_CONFIG_ENTRY_TYPE_MATCH,
		Position: 10,
		Patterns: []string{"host *.internal.com"},
	}

	entry := fromProtoSSHConfigEntry(pbEntry)
	assert.Equal(t, "proto-entry-2", entry.ID)
	assert.Equal(t, config.EntryTypeMatch, entry.Type)
}

func TestFromProtoSSHOptions_Nil(t *testing.T) {
	result := fromProtoSSHOptions(nil)
	assert.Equal(t, config.SSHOptions{}, result)
}

func TestToProtoSSHOptions(t *testing.T) {
	opts := &config.SSHOptions{
		Hostname:              "example.com",
		Port:                  22,
		User:                  "testuser",
		IdentityFiles:         []string{"~/.ssh/id_ed25519", "~/.ssh/id_rsa"},
		ProxyJump:             "jump-host",
		ProxyCommand:          "",
		ForwardAgent:          true,
		IdentitiesOnly:        false,
		StrictHostKeyChecking: "accept-new",
		ServerAliveInterval:   120,
		ServerAliveCountMax:   10,
		Compression:           true,
		ExtraOptions:          map[string]string{"TCPKeepAlive": "yes"},
	}

	pbOpts := toProtoSSHOptions(opts)
	assert.Equal(t, "example.com", pbOpts.Hostname)
	assert.Equal(t, int32(22), pbOpts.Port)
	assert.Equal(t, "testuser", pbOpts.User)
	assert.Equal(t, []string{"~/.ssh/id_ed25519", "~/.ssh/id_rsa"}, pbOpts.IdentityFiles)
	assert.Equal(t, "jump-host", pbOpts.ProxyJump)
	assert.Empty(t, pbOpts.ProxyCommand)
	assert.True(t, pbOpts.ForwardAgent)
	assert.False(t, pbOpts.IdentitiesOnly)
	assert.Equal(t, "accept-new", pbOpts.StrictHostKeyChecking)
	assert.Equal(t, int32(120), pbOpts.ServerAliveInterval)
	assert.Equal(t, int32(10), pbOpts.ServerAliveCountMax)
	assert.True(t, pbOpts.Compression)
	assert.Equal(t, map[string]string{"TCPKeepAlive": "yes"}, pbOpts.ExtraOptions)
}

func TestToProtoConfigPathInfo(t *testing.T) {
	info := &config.ConfigPathInfo{
		Path:            "/etc/ssh/ssh_config",
		Exists:          true,
		Readable:        true,
		Writable:        false,
		IncludeDir:      "/etc/ssh/ssh_config.d",
		DiscoveryMethod: config.DiscoveryMethodCommand,
	}

	pbInfo := toProtoConfigPathInfo(info)
	assert.Equal(t, "/etc/ssh/ssh_config", pbInfo.Path)
	assert.True(t, pbInfo.Exists)
	assert.True(t, pbInfo.Readable)
	assert.False(t, pbInfo.Writable)
	assert.Equal(t, "/etc/ssh/ssh_config.d", pbInfo.IncludeDir)
	assert.Equal(t, pb.DiscoveryMethod_DISCOVERY_METHOD_COMMAND, pbInfo.DiscoveryMethod)
}

func TestToProtoDiscoveryMethod(t *testing.T) {
	tests := []struct {
		input    config.DiscoveryMethod
		expected pb.DiscoveryMethod
	}{
		{config.DiscoveryMethodCommand, pb.DiscoveryMethod_DISCOVERY_METHOD_COMMAND},
		{config.DiscoveryMethodPackageManager, pb.DiscoveryMethod_DISCOVERY_METHOD_PACKAGE_MANAGER},
		{config.DiscoveryMethodCommonPath, pb.DiscoveryMethod_DISCOVERY_METHOD_COMMON_PATH},
		{config.DiscoveryMethodUserSpecified, pb.DiscoveryMethod_DISCOVERY_METHOD_USER_SPECIFIED},
		{config.DiscoveryMethod(999), pb.DiscoveryMethod_DISCOVERY_METHOD_UNSPECIFIED}, // Unknown value
	}

	for _, tt := range tests {
		t.Run(tt.expected.String(), func(t *testing.T) {
			result := toProtoDiscoveryMethod(tt.input)
			assert.Equal(t, tt.expected, result)
		})
	}
}

func TestNewConfigServiceAdapter(t *testing.T) {
	// Verify constructor doesn't panic with nil
	adapter := NewConfigServiceAdapter(nil, nil, nil)
	assert.NotNil(t, adapter)
	assert.Nil(t, adapter.clientConfig)
	assert.Nil(t, adapter.serverConfig)
	assert.Nil(t, adapter.sshConfigMgr)
	// configDiscoverer is created internally, so it should not be nil
	assert.NotNil(t, adapter.configDiscoverer)
}

func TestToProtoHostConfig_Minimal(t *testing.T) {
	entry := &config.HostEntry{
		Alias: "simple",
	}

	pbConfig := toProtoHostConfig(entry)
	assert.Equal(t, "simple", pbConfig.Alias)
	assert.Empty(t, pbConfig.Hostname)
	assert.Empty(t, pbConfig.User)
	assert.Equal(t, int32(0), pbConfig.Port)
}

func TestFromProtoHostConfig_Minimal(t *testing.T) {
	pbConfig := &pb.HostConfig{
		Alias: "minimal",
	}

	entry := fromProtoHostConfig(pbConfig)
	assert.Equal(t, "minimal", entry.Alias)
	assert.Empty(t, entry.Hostname)
	assert.Equal(t, 0, entry.Port)
}

func TestToProtoServerConfig_Empty(t *testing.T) {
	cfg := &config.ServerConfig{
		Directives: []config.ServerDirective{},
		RawContent: "",
	}

	pbConfig := toProtoServerConfig(cfg)
	assert.Empty(t, pbConfig.Directives)
	assert.Empty(t, pbConfig.RawContent)
}

func TestToProtoSSHConfigEntry_EmptyOptions(t *testing.T) {
	entry := &config.SSHConfigEntry{
		ID:       "empty-opts",
		Type:     config.EntryTypeHost,
		Position: 0,
		Patterns: []string{"*"},
		Options:  config.SSHOptions{},
	}

	pbEntry := toProtoSSHConfigEntry(entry)
	assert.Equal(t, "empty-opts", pbEntry.Id)
	assert.NotNil(t, pbEntry.Options)
	assert.Empty(t, pbEntry.Options.Hostname)
	assert.Equal(t, int32(0), pbEntry.Options.Port)
}
