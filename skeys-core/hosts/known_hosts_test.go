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
	"context"
	"os"
	"path/filepath"
	"testing"
	"time"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/mock"
	"github.com/stretchr/testify/require"

	"github.com/johnnelson/skeys-core/logging"
)

// MockExecutor implements executor.Executor for testing
type MockExecutor struct {
	mock.Mock
}

func (m *MockExecutor) Run(ctx context.Context, name string, args ...string) ([]byte, error) {
	called := m.Called(ctx, name, args)
	if called.Get(0) == nil {
		return nil, called.Error(1)
	}
	return called.Get(0).([]byte), called.Error(1)
}

// Sample known_hosts content for testing
const sampleKnownHosts = `github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl
gitlab.com,192.168.1.1 ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC...
# This is a comment
[bitbucket.org]:22 ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTY...
@revoked example.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5...
@cert-authority *.example.org ssh-rsa AAAAB3NzaC1yc2EAAAA...
|1|abcd1234=|efgh5678= ssh-ed25519 AAAAC3NzaC1lZDI1NTE5...
`

func TestNewKnownHostsManager(t *testing.T) {
	tmpDir := t.TempDir()
	knownHostsPath := filepath.Join(tmpDir, "known_hosts")

	mgr, err := NewKnownHostsManager(WithKnownHostsPath(knownHostsPath))
	require.NoError(t, err)
	assert.NotNil(t, mgr)
}

func TestKnownHostsManager_List_Empty(t *testing.T) {
	tmpDir := t.TempDir()
	knownHostsPath := filepath.Join(tmpDir, "known_hosts")

	mgr, err := NewKnownHostsManager(WithKnownHostsPath(knownHostsPath))
	require.NoError(t, err)

	hosts, err := mgr.List()
	require.NoError(t, err)
	assert.Empty(t, hosts)
}

func TestKnownHostsManager_List_WithEntries(t *testing.T) {
	tmpDir := t.TempDir()
	knownHostsPath := filepath.Join(tmpDir, "known_hosts")

	err := os.WriteFile(knownHostsPath, []byte(sampleKnownHosts), 0600)
	require.NoError(t, err)

	mgr, err := NewKnownHostsManager(WithKnownHostsPath(knownHostsPath))
	require.NoError(t, err)

	hosts, err := mgr.List()
	require.NoError(t, err)
	assert.Len(t, hosts, 6)

	// Check first entry
	assert.Equal(t, []string{"github.com"}, hosts[0].Hostnames)
	assert.Equal(t, "ssh-ed25519", hosts[0].KeyType)
	assert.False(t, hosts[0].IsHashed)
	assert.False(t, hosts[0].IsRevoked)
	assert.False(t, hosts[0].IsCertAuth)

	// Check multi-hostname entry
	assert.Equal(t, []string{"gitlab.com", "192.168.1.1"}, hosts[1].Hostnames)

	// Check port entry
	assert.Equal(t, []string{"[bitbucket.org]:22"}, hosts[2].Hostnames)

	// Check revoked entry
	assert.True(t, hosts[3].IsRevoked)

	// Check cert-authority entry
	assert.True(t, hosts[4].IsCertAuth)

	// Check hashed entry
	assert.True(t, hosts[5].IsHashed)
	assert.Equal(t, []string{"[hashed]"}, hosts[5].Hostnames)
}

func TestKnownHostsManager_ParseLine(t *testing.T) {
	mgr, err := NewKnownHostsManager(WithKnownHostsPath("/tmp/test"))
	require.NoError(t, err)

	tests := []struct {
		name       string
		line       string
		expected   *KnownHost
		shouldSkip bool
	}{
		{
			name: "simple entry",
			line: "github.com ssh-ed25519 AAAAC3NzaC1...",
			expected: &KnownHost{
				Hostnames:  []string{"github.com"},
				KeyType:    "ssh-ed25519",
				PublicKey:  "AAAAC3NzaC1...",
				LineNumber: 1,
			},
		},
		{
			name: "multiple hostnames",
			line: "host1,host2,192.168.1.1 ssh-rsa AAAAB3...",
			expected: &KnownHost{
				Hostnames:  []string{"host1", "host2", "192.168.1.1"},
				KeyType:    "ssh-rsa",
				PublicKey:  "AAAAB3...",
				LineNumber: 1,
			},
		},
		{
			name: "with port",
			line: "[example.com]:2222 ssh-ed25519 AAAAC3...",
			expected: &KnownHost{
				Hostnames:  []string{"[example.com]:2222"},
				KeyType:    "ssh-ed25519",
				PublicKey:  "AAAAC3...",
				LineNumber: 1,
			},
		},
		{
			name: "revoked",
			line: "@revoked host.com ssh-ed25519 AAAAC3...",
			expected: &KnownHost{
				Hostnames:  []string{"host.com"},
				KeyType:    "ssh-ed25519",
				PublicKey:  "AAAAC3...",
				IsRevoked:  true,
				LineNumber: 1,
			},
		},
		{
			name: "cert-authority",
			line: "@cert-authority *.domain.com ssh-rsa AAAAB3...",
			expected: &KnownHost{
				Hostnames:  []string{"*.domain.com"},
				KeyType:    "ssh-rsa",
				PublicKey:  "AAAAB3...",
				IsCertAuth: true,
				LineNumber: 1,
			},
		},
		{
			name: "hashed",
			line: "|1|abc123=|def456= ssh-ed25519 AAAAC3...",
			expected: &KnownHost{
				Hostnames:  []string{"[hashed]"},
				KeyType:    "ssh-ed25519",
				PublicKey:  "AAAAC3...",
				IsHashed:   true,
				LineNumber: 1,
			},
		},
		{
			name:       "invalid - too few parts",
			line:       "hostname only",
			shouldSkip: true,
		},
		{
			name:       "invalid - empty",
			line:       "",
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
				assert.Equal(t, tt.expected.Hostnames, result.Hostnames)
				assert.Equal(t, tt.expected.KeyType, result.KeyType)
				assert.Equal(t, tt.expected.PublicKey, result.PublicKey)
				assert.Equal(t, tt.expected.IsHashed, result.IsHashed)
				assert.Equal(t, tt.expected.IsRevoked, result.IsRevoked)
				assert.Equal(t, tt.expected.IsCertAuth, result.IsCertAuth)
			}
		})
	}
}

func TestKnownHostsManager_Lookup_WithMock(t *testing.T) {
	tmpDir := t.TempDir()
	knownHostsPath := filepath.Join(tmpDir, "known_hosts")

	mockExec := new(MockExecutor)
	mockExec.On("Run", mock.Anything, "ssh-keygen", []string{"-F", "github.com", "-f", knownHostsPath}).
		Return([]byte("github.com ssh-ed25519 AAAAC3NzaC1...\n"), nil)

	mgr, err := NewKnownHostsManager(
		WithKnownHostsPath(knownHostsPath),
		WithKnownHostsExecutor(mockExec),
	)
	require.NoError(t, err)

	hosts, err := mgr.Lookup(context.Background(), "github.com")
	require.NoError(t, err)
	assert.Len(t, hosts, 1)
	assert.Equal(t, []string{"github.com"}, hosts[0].Hostnames)

	mockExec.AssertExpectations(t)
}

func TestKnownHostsManager_Lookup_NotFound(t *testing.T) {
	tmpDir := t.TempDir()
	knownHostsPath := filepath.Join(tmpDir, "known_hosts")

	mockExec := new(MockExecutor)
	mockExec.On("Run", mock.Anything, "ssh-keygen", mock.Anything).
		Return(nil, assert.AnError)

	mgr, err := NewKnownHostsManager(
		WithKnownHostsPath(knownHostsPath),
		WithKnownHostsExecutor(mockExec),
	)
	require.NoError(t, err)

	hosts, err := mgr.Lookup(context.Background(), "unknown.com")
	require.NoError(t, err)
	assert.Empty(t, hosts)
}

func TestKnownHostsManager_Remove_WithMock(t *testing.T) {
	tmpDir := t.TempDir()
	knownHostsPath := filepath.Join(tmpDir, "known_hosts")

	// Create a file so .old cleanup works
	os.WriteFile(knownHostsPath, []byte(""), 0600)

	mockExec := new(MockExecutor)
	mockExec.On("Run", mock.Anything, "ssh-keygen", []string{"-R", "github.com", "-f", knownHostsPath}).
		Return([]byte(""), nil)

	mgr, err := NewKnownHostsManager(
		WithKnownHostsPath(knownHostsPath),
		WithKnownHostsExecutor(mockExec),
	)
	require.NoError(t, err)

	err = mgr.Remove(context.Background(), "github.com")
	require.NoError(t, err)

	mockExec.AssertExpectations(t)
}

func TestKnownHostsManager_Hash_WithMock(t *testing.T) {
	tmpDir := t.TempDir()
	knownHostsPath := filepath.Join(tmpDir, "known_hosts")

	mockExec := new(MockExecutor)
	mockExec.On("Run", mock.Anything, "ssh-keygen", []string{"-H", "-f", knownHostsPath}).
		Return([]byte(""), nil)

	mgr, err := NewKnownHostsManager(
		WithKnownHostsPath(knownHostsPath),
		WithKnownHostsExecutor(mockExec),
	)
	require.NoError(t, err)

	err = mgr.Hash(context.Background())
	require.NoError(t, err)

	mockExec.AssertExpectations(t)
}

func TestKnownHostsManager_Add_NoHash(t *testing.T) {
	tmpDir := t.TempDir()
	knownHostsPath := filepath.Join(tmpDir, "known_hosts")

	mockExec := new(MockExecutor)

	mgr, err := NewKnownHostsManager(
		WithKnownHostsPath(knownHostsPath),
		WithKnownHostsExecutor(mockExec),
	)
	require.NoError(t, err)

	host, err := mgr.Add(context.Background(), "newhost.com", 22, "ssh-ed25519", "AAAAC3NzaC1...", false)
	require.NoError(t, err)
	assert.NotNil(t, host)

	// Verify the file was written
	content, err := os.ReadFile(knownHostsPath)
	require.NoError(t, err)
	assert.Contains(t, string(content), "newhost.com ssh-ed25519 AAAAC3NzaC1...")
}

func TestKnownHostsManager_Add_WithNonStandardPort(t *testing.T) {
	tmpDir := t.TempDir()
	knownHostsPath := filepath.Join(tmpDir, "known_hosts")

	mockExec := new(MockExecutor)

	mgr, err := NewKnownHostsManager(
		WithKnownHostsPath(knownHostsPath),
		WithKnownHostsExecutor(mockExec),
	)
	require.NoError(t, err)

	_, err = mgr.Add(context.Background(), "newhost.com", 2222, "ssh-ed25519", "AAAAC3NzaC1...", false)
	require.NoError(t, err)

	content, err := os.ReadFile(knownHostsPath)
	require.NoError(t, err)
	assert.Contains(t, string(content), "[newhost.com]:2222")
}

func TestKnownHostsManager_ScanHostKeys_WithMock(t *testing.T) {
	tmpDir := t.TempDir()
	knownHostsPath := filepath.Join(tmpDir, "known_hosts")

	mockExec := new(MockExecutor)

	// Mock ssh-keyscan
	mockExec.On("Run", mock.Anything, "ssh-keyscan", []string{"-T", "10", "github.com"}).
		Return([]byte("github.com ssh-ed25519 AAAAC3NzaC1...\ngithub.com ssh-rsa AAAAB3...\n"), nil)

	// Mock ssh-keygen for fingerprint (called twice, once per key)
	mockExec.On("Run", mock.Anything, "ssh-keygen", mock.MatchedBy(func(args []string) bool {
		return len(args) == 3 && args[0] == "-l" && args[1] == "-f"
	})).Return([]byte("256 SHA256:abc123 github.com (ED25519)\n"), nil)

	mgr, err := NewKnownHostsManager(
		WithKnownHostsPath(knownHostsPath),
		WithKnownHostsExecutor(mockExec),
	)
	require.NoError(t, err)

	keys, err := mgr.ScanHostKeys(context.Background(), "github.com", 0, 0)
	require.NoError(t, err)
	assert.Len(t, keys, 2)

	assert.Equal(t, "github.com", keys[0].Hostname)
	assert.Equal(t, "ssh-ed25519", keys[0].KeyType)
	assert.Equal(t, "SHA256:abc123", keys[0].Fingerprint)
}

func TestKnownHostsManager_ScanHostKeys_WithCustomPort(t *testing.T) {
	tmpDir := t.TempDir()
	knownHostsPath := filepath.Join(tmpDir, "known_hosts")

	mockExec := new(MockExecutor)
	mockExec.On("Run", mock.Anything, "ssh-keyscan", []string{"-T", "5", "-p", "2222", "example.com"}).
		Return([]byte("[example.com]:2222 ssh-ed25519 AAAAC3...\n"), nil)
	mockExec.On("Run", mock.Anything, "ssh-keygen", mock.Anything).
		Return([]byte("256 SHA256:xyz789 example.com (ED25519)\n"), nil)

	mgr, err := NewKnownHostsManager(
		WithKnownHostsPath(knownHostsPath),
		WithKnownHostsExecutor(mockExec),
	)
	require.NoError(t, err)

	keys, err := mgr.ScanHostKeys(context.Background(), "example.com", 2222, 5)
	require.NoError(t, err)
	assert.Len(t, keys, 1)
	assert.Equal(t, 2222, keys[0].Port)
}

func TestDefaultExecutor_AllowedCommands(t *testing.T) {
	exec := &defaultExecutor{}

	// Test disallowed command
	_, err := exec.Run(context.Background(), "rm", "-rf", "/")
	require.Error(t, err)
	assert.Contains(t, err.Error(), "command not allowed")

	// Note: We don't test allowed commands here as they would actually run
}

// Watcher tests

func TestKnownHostsUpdate(t *testing.T) {
	update := KnownHostsUpdate{
		Hosts: []*KnownHost{
			{Hostnames: []string{"github.com"}, KeyType: "ssh-ed25519"},
		},
		Err: nil,
	}

	assert.Len(t, update.Hosts, 1)
	assert.NoError(t, update.Err)
}

func TestKnownHostsUpdate_WithError(t *testing.T) {
	update := KnownHostsUpdate{
		Hosts: nil,
		Err:   assert.AnError,
	}

	assert.Nil(t, update.Hosts)
	assert.Error(t, update.Err)
}

func TestKnownHostsManager_Watch(t *testing.T) {
	tmpDir := t.TempDir()
	knownHostsPath := filepath.Join(tmpDir, "known_hosts")

	// Create a known_hosts file
	os.WriteFile(knownHostsPath, []byte(sampleKnownHosts), 0600)

	mockExec := new(MockExecutor)
	mgr, err := NewKnownHostsManager(
		WithKnownHostsPath(knownHostsPath),
		WithKnownHostsExecutor(mockExec),
	)
	require.NoError(t, err)

	ctx, cancel := context.WithTimeout(context.Background(), 2*time.Second)
	defer cancel()

	ch := mgr.Watch(ctx)

	// Should receive initial update
	select {
	case update := <-ch:
		require.NoError(t, update.Err)
		assert.NotEmpty(t, update.Hosts)
	case <-ctx.Done():
		t.Fatal("timeout waiting for initial update")
	}
}

func TestKnownHostsManager_Watch_ContextCancellation(t *testing.T) {
	tmpDir := t.TempDir()
	knownHostsPath := filepath.Join(tmpDir, "known_hosts")
	os.WriteFile(knownHostsPath, []byte(sampleKnownHosts), 0600)

	mockExec := new(MockExecutor)
	mgr, err := NewKnownHostsManager(
		WithKnownHostsPath(knownHostsPath),
		WithKnownHostsExecutor(mockExec),
	)
	require.NoError(t, err)

	ctx, cancel := context.WithCancel(context.Background())
	ch := mgr.Watch(ctx)

	// Get initial update
	select {
	case <-ch:
	case <-time.After(2 * time.Second):
		t.Fatal("timeout waiting for initial update")
	}

	// Cancel context
	cancel()

	// Channel should close
	select {
	case _, ok := <-ch:
		if ok {
			// May get one more message, wait for close
			select {
			case _, ok := <-ch:
				assert.False(t, ok, "channel should be closed")
			case <-time.After(2 * time.Second):
				t.Fatal("timeout waiting for channel close")
			}
		}
	case <-time.After(2 * time.Second):
		t.Fatal("timeout waiting for channel response")
	}
}

func TestKnownHostsManager_EnsureWatcher(t *testing.T) {
	tmpDir := t.TempDir()
	knownHostsPath := filepath.Join(tmpDir, "known_hosts")
	os.WriteFile(knownHostsPath, []byte(sampleKnownHosts), 0600)

	mockExec := new(MockExecutor)
	mgr, err := NewKnownHostsManager(
		WithKnownHostsPath(knownHostsPath),
		WithKnownHostsExecutor(mockExec),
	)
	require.NoError(t, err)

	assert.Nil(t, mgr.watcher)

	mgr.ensureWatcher()
	assert.NotNil(t, mgr.watcher)

	// Calling again should return same watcher
	watcher1 := mgr.watcher
	mgr.ensureWatcher()
	assert.Equal(t, watcher1, mgr.watcher)
}

func TestNewKnownHostsWatcher(t *testing.T) {
	tmpDir := t.TempDir()
	knownHostsPath := filepath.Join(tmpDir, "known_hosts")
	os.WriteFile(knownHostsPath, []byte(sampleKnownHosts), 0600)

	mockExec := new(MockExecutor)
	mgr, err := NewKnownHostsManager(
		WithKnownHostsPath(knownHostsPath),
		WithKnownHostsExecutor(mockExec),
	)
	require.NoError(t, err)

	watcher := newKnownHostsWatcher(mgr)
	assert.NotNil(t, watcher)
	assert.Equal(t, mgr, watcher.manager)
	assert.NotNil(t, watcher.broadcaster)
}

func TestKnownHostsWatcher_StartOnce(t *testing.T) {
	tmpDir := t.TempDir()
	knownHostsPath := filepath.Join(tmpDir, "known_hosts")
	os.WriteFile(knownHostsPath, []byte(sampleKnownHosts), 0600)

	mockExec := new(MockExecutor)
	mgr, err := NewKnownHostsManager(
		WithKnownHostsPath(knownHostsPath),
		WithKnownHostsExecutor(mockExec),
	)
	require.NoError(t, err)

	watcher := newKnownHostsWatcher(mgr)

	// Start
	watcher.start()
	assert.True(t, watcher.started)
	assert.NotNil(t, watcher.cancel)

	// Start again - should not change anything
	watcher.start()
	assert.True(t, watcher.started)

	// Clean up
	watcher.cancel()
}

func TestKnownHostsWatcher_Subscribe(t *testing.T) {
	tmpDir := t.TempDir()
	knownHostsPath := filepath.Join(tmpDir, "known_hosts")
	os.WriteFile(knownHostsPath, []byte(sampleKnownHosts), 0600)

	mockExec := new(MockExecutor)
	mgr, err := NewKnownHostsManager(
		WithKnownHostsPath(knownHostsPath),
		WithKnownHostsExecutor(mockExec),
	)
	require.NoError(t, err)

	watcher := newKnownHostsWatcher(mgr)
	ch := watcher.subscribe()
	assert.NotNil(t, ch)
	assert.True(t, watcher.started)

	// Clean up
	watcher.unsubscribe(ch)
	if watcher.cancel != nil {
		watcher.cancel()
	}
}

func TestKnownHostsEqual(t *testing.T) {
	tests := []struct {
		name     string
		a        []*KnownHost
		b        []*KnownHost
		expected bool
	}{
		{
			name:     "both nil",
			a:        nil,
			b:        nil,
			expected: true,
		},
		{
			name:     "both empty",
			a:        []*KnownHost{},
			b:        []*KnownHost{},
			expected: true,
		},
		{
			name:     "different length",
			a:        []*KnownHost{{Hostnames: []string{"a"}}},
			b:        []*KnownHost{{Hostnames: []string{"a"}}, {Hostnames: []string{"b"}}},
			expected: false,
		},
		{
			name: "same hosts",
			a: []*KnownHost{
				{Hostnames: []string{"github.com"}, KeyType: "ssh-ed25519"},
				{Hostnames: []string{"gitlab.com"}, KeyType: "ssh-rsa"},
			},
			b: []*KnownHost{
				{Hostnames: []string{"github.com"}, KeyType: "ssh-ed25519"},
				{Hostnames: []string{"gitlab.com"}, KeyType: "ssh-rsa"},
			},
			expected: true,
		},
		{
			name: "different hosts",
			a: []*KnownHost{
				{Hostnames: []string{"github.com"}, KeyType: "ssh-ed25519"},
			},
			b: []*KnownHost{
				{Hostnames: []string{"gitlab.com"}, KeyType: "ssh-ed25519"},
			},
			expected: false,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			result := knownHostsEqual(tt.a, tt.b)
			assert.Equal(t, tt.expected, result)
		})
	}
}

func TestWithKnownHostsLogger(t *testing.T) {
	tmpDir := t.TempDir()
	knownHostsPath := filepath.Join(tmpDir, "known_hosts")
	os.WriteFile(knownHostsPath, []byte(sampleKnownHosts), 0600)

	log := logging.New(logging.DefaultConfig())
	mgr, err := NewKnownHostsManager(
		WithKnownHostsPath(knownHostsPath),
		WithKnownHostsLogger(log),
	)
	require.NoError(t, err)
	assert.NotNil(t, mgr)
}
