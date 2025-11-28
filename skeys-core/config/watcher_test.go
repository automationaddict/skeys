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
	"time"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestClientConfig_Watch(t *testing.T) {
	tmpDir := t.TempDir()
	configPath := filepath.Join(tmpDir, "config")

	sample := `Host server1
    HostName server1.example.com
`
	err := os.WriteFile(configPath, []byte(sample), 0600)
	require.NoError(t, err)

	config, err := NewClientConfig(WithConfigPath(configPath))
	require.NoError(t, err)

	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	ch := config.Watch(ctx)

	// Should receive initial entries
	select {
	case update := <-ch:
		require.NoError(t, update.Err)
		assert.Len(t, update.Entries, 1)
		assert.Equal(t, "server1", update.Entries[0].Patterns[0])
	case <-ctx.Done():
		t.Fatal("timeout waiting for initial update")
	}
}

func TestClientConfig_Watch_MultipleSubscribers(t *testing.T) {
	tmpDir := t.TempDir()
	configPath := filepath.Join(tmpDir, "config")

	sample := `Host server1
    HostName server1.example.com
`
	err := os.WriteFile(configPath, []byte(sample), 0600)
	require.NoError(t, err)

	config, err := NewClientConfig(WithConfigPath(configPath))
	require.NoError(t, err)

	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	// Create two subscribers
	ch1 := config.Watch(ctx)
	ch2 := config.Watch(ctx)

	// Both should receive initial entries
	var update1, update2 SSHConfigEntriesUpdate

	select {
	case update1 = <-ch1:
	case <-ctx.Done():
		t.Fatal("timeout waiting for update1")
	}

	select {
	case update2 = <-ch2:
	case <-ctx.Done():
		t.Fatal("timeout waiting for update2")
	}

	require.NoError(t, update1.Err)
	require.NoError(t, update2.Err)
	assert.Len(t, update1.Entries, 1)
	assert.Len(t, update2.Entries, 1)
}

func TestClientConfig_Watch_ContextCancellation(t *testing.T) {
	tmpDir := t.TempDir()
	configPath := filepath.Join(tmpDir, "config")

	config, err := NewClientConfig(WithConfigPath(configPath))
	require.NoError(t, err)

	ctx, cancel := context.WithCancel(context.Background())
	ch := config.Watch(ctx)

	// Cancel the context
	cancel()

	// Channel should close
	select {
	case _, ok := <-ch:
		if ok {
			// Might get initial message, wait for close
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

func TestConfigWatcher_Start(t *testing.T) {
	tmpDir := t.TempDir()
	configPath := filepath.Join(tmpDir, "config")

	config, err := NewClientConfig(WithConfigPath(configPath))
	require.NoError(t, err)

	watcher := newConfigWatcher(config)
	assert.NotNil(t, watcher)

	// Start should be idempotent
	watcher.start()
	watcher.start() // Second call should not panic

	// Stop
	watcher.Stop()
}

func TestConfigWatcher_Stop(t *testing.T) {
	tmpDir := t.TempDir()
	configPath := filepath.Join(tmpDir, "config")

	config, err := NewClientConfig(WithConfigPath(configPath))
	require.NoError(t, err)

	watcher := newConfigWatcher(config)
	watcher.start()

	// Subscribe
	ch := watcher.subscribe()
	assert.NotNil(t, ch)

	// Stop should close everything
	watcher.Stop()

	// Stop should be idempotent
	watcher.Stop()
}

func TestSSHConfigEntriesEqual(t *testing.T) {
	entry1 := &SSHConfigEntry{
		ID:       "abc123",
		Type:     EntryTypeHost,
		Patterns: []string{"server1"},
		Options: SSHOptions{
			Hostname: "server1.example.com",
		},
	}

	entry2 := &SSHConfigEntry{
		ID:       "abc123",
		Type:     EntryTypeHost,
		Patterns: []string{"server1"},
		Options: SSHOptions{
			Hostname: "server1.example.com",
		},
	}

	entry3 := &SSHConfigEntry{
		ID:       "abc123",
		Type:     EntryTypeHost,
		Patterns: []string{"server2"},
		Options: SSHOptions{
			Hostname: "server2.example.com",
		},
	}

	// Same entries
	assert.True(t, sshConfigEntriesEqual([]*SSHConfigEntry{entry1}, []*SSHConfigEntry{entry2}))

	// Different entries
	assert.False(t, sshConfigEntriesEqual([]*SSHConfigEntry{entry1}, []*SSHConfigEntry{entry3}))

	// Different lengths
	assert.False(t, sshConfigEntriesEqual([]*SSHConfigEntry{entry1}, []*SSHConfigEntry{entry1, entry2}))

	// Empty slices
	assert.True(t, sshConfigEntriesEqual([]*SSHConfigEntry{}, []*SSHConfigEntry{}))

	// Nil slices
	assert.True(t, sshConfigEntriesEqual(nil, nil))
}

func TestSSHConfigEntriesUpdate(t *testing.T) {
	update := SSHConfigEntriesUpdate{
		Entries: []*SSHConfigEntry{
			{
				ID:       "abc",
				Type:     EntryTypeHost,
				Patterns: []string{"server"},
			},
		},
		Err: nil,
	}

	assert.Len(t, update.Entries, 1)
	assert.NoError(t, update.Err)
}
