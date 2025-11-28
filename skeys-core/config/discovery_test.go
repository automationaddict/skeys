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
	"github.com/stretchr/testify/require"
)

func TestNewConfigDiscoverer(t *testing.T) {
	d := NewConfigDiscoverer()
	assert.NotNil(t, d)
}

func TestDiscoveryMethod_String(t *testing.T) {
	tests := []struct {
		method   DiscoveryMethod
		expected string
	}{
		{DiscoveryMethodUnspecified, "unspecified"},
		{DiscoveryMethodCommand, "command"},
		{DiscoveryMethodPackageManager, "package_manager"},
		{DiscoveryMethodCommonPath, "common_path"},
		{DiscoveryMethodUserSpecified, "user_specified"},
	}

	for _, tt := range tests {
		t.Run(tt.expected, func(t *testing.T) {
			assert.Equal(t, tt.expected, tt.method.String())
		})
	}
}

func TestConfigDiscoverer_Discover(t *testing.T) {
	d := NewConfigDiscoverer()

	paths, err := d.Discover(context.Background())
	require.NoError(t, err)
	assert.NotNil(t, paths)

	// Distribution should be detected
	assert.NotEmpty(t, paths.Distribution)

	// Client user config path should be set (even if doesn't exist)
	assert.NotEmpty(t, paths.ClientUserConfig.Path)
	assert.Contains(t, paths.ClientUserConfig.Path, ".ssh/config")

	// Server config path should be set
	assert.NotEmpty(t, paths.ServerConfig.Path)

	// SSH client should be installed (common on most systems)
	// This might fail on minimal containers, so just check the field exists
	_ = paths.SSHClientInstalled
}

func TestConfigDiscoverer_DiscoverClientUserConfig(t *testing.T) {
	d := NewConfigDiscoverer()

	info := d.discoverClientUserConfig()

	// Path should be set
	assert.NotEmpty(t, info.Path)
	assert.Contains(t, info.Path, ".ssh/config")
	assert.Equal(t, DiscoveryMethodCommonPath, info.DiscoveryMethod)
}

func TestConfigDiscoverer_CheckPath_Exists(t *testing.T) {
	tmpDir := t.TempDir()
	testFile := filepath.Join(tmpDir, "test_config")

	err := os.WriteFile(testFile, []byte("test content"), 0644)
	require.NoError(t, err)

	d := NewConfigDiscoverer()
	info := d.checkPath(testFile)

	assert.Equal(t, testFile, info.Path)
	assert.True(t, info.Exists)
	assert.True(t, info.Readable)
	assert.True(t, info.Writable)
}

func TestConfigDiscoverer_CheckPath_NotExists(t *testing.T) {
	d := NewConfigDiscoverer()
	info := d.checkPath("/nonexistent/path/config")

	assert.False(t, info.Exists)
	assert.False(t, info.Readable)
	assert.False(t, info.Writable)
}

func TestConfigDiscoverer_CheckPath_ReadOnly(t *testing.T) {
	tmpDir := t.TempDir()
	testFile := filepath.Join(tmpDir, "readonly_config")

	err := os.WriteFile(testFile, []byte("test content"), 0444)
	require.NoError(t, err)

	d := NewConfigDiscoverer()
	info := d.checkPath(testFile)

	assert.True(t, info.Exists)
	assert.True(t, info.Readable)
	// Writable depends on whether running as root
	if os.Getuid() != 0 {
		assert.False(t, info.Writable)
	}
}

func TestConfigDiscoverer_IsCommandAvailable(t *testing.T) {
	d := NewConfigDiscoverer()

	// These commands should be available on most systems
	assert.True(t, d.isCommandAvailable("ls"))
	assert.True(t, d.isCommandAvailable("cat"))

	// This should not exist
	assert.False(t, d.isCommandAvailable("nonexistent_command_xyz123"))
}

func TestConfigDiscoverer_DetectDistribution(t *testing.T) {
	d := NewConfigDiscoverer()

	distro := d.detectDistribution()
	// Should return something (even "unknown" if detection fails)
	assert.NotEmpty(t, distro)
}

func TestConfigDiscoverer_GetDefaultServerConfigPath(t *testing.T) {
	d := NewConfigDiscoverer()

	path := d.GetDefaultServerConfigPath()
	assert.NotEmpty(t, path)
	// Should be a standard path
	assert.Contains(t, path, "sshd_config")
}

func TestConfigDiscoverer_GetDefaultClientConfigPath(t *testing.T) {
	d := NewConfigDiscoverer()

	path := d.GetDefaultClientConfigPath()
	assert.NotEmpty(t, path)
	// Should be a standard path
	assert.Contains(t, path, "ssh_config")
}

func TestDiscoveredPaths_Summary(t *testing.T) {
	paths := &DiscoveredPaths{
		Distribution:       "ubuntu",
		SSHClientInstalled: true,
		SSHServerInstalled: true,
		ClientUserConfig: ConfigPathInfo{
			Path:            "/home/user/.ssh/config",
			Exists:          true,
			Readable:        true,
			Writable:        true,
			DiscoveryMethod: DiscoveryMethodCommonPath,
		},
		ClientSystemConfig: ConfigPathInfo{
			Path:            "/etc/ssh/ssh_config",
			Exists:          true,
			Readable:        true,
			Writable:        false,
			IncludeDir:      "/etc/ssh/ssh_config.d",
			DiscoveryMethod: DiscoveryMethodCommonPath,
		},
		ServerConfig: ConfigPathInfo{
			Path:            "/etc/ssh/sshd_config",
			Exists:          true,
			Readable:        false,
			Writable:        false,
			IncludeDir:      "/etc/ssh/sshd_config.d",
			DiscoveryMethod: DiscoveryMethodCommonPath,
		},
	}

	summary := paths.Summary()

	assert.Contains(t, summary, "Distribution: ubuntu")
	assert.Contains(t, summary, "SSH Client Installed: true")
	assert.Contains(t, summary, "SSH Server Installed: true")
	assert.Contains(t, summary, "/home/user/.ssh/config")
	assert.Contains(t, summary, "/etc/ssh/ssh_config")
	assert.Contains(t, summary, "/etc/ssh/sshd_config")
	assert.Contains(t, summary, "Include Dir:")
}

func TestConfigDiscoverer_DiscoverServerConfig_CommonPath(t *testing.T) {
	d := NewConfigDiscoverer()

	// This tests the fallback to common paths
	info := d.discoverServerConfig(context.Background())

	// Should have some path set
	assert.NotEmpty(t, info.Path)
	// Discovery method should be set
	assert.NotEqual(t, DiscoveryMethodUnspecified, info.DiscoveryMethod)
}

func TestConfigDiscoverer_DiscoverClientSystemConfig(t *testing.T) {
	d := NewConfigDiscoverer()

	info := d.discoverClientSystemConfig(context.Background())

	// Should have some path set
	assert.NotEmpty(t, info.Path)
	// Discovery method should be set
	assert.NotEqual(t, DiscoveryMethodUnspecified, info.DiscoveryMethod)
}
