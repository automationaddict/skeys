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

package storage

import (
	"os"
	"path/filepath"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestNewStore(t *testing.T) {
	tmpDir := t.TempDir()

	store, err := NewStore(WithDataDir(tmpDir))
	require.NoError(t, err)
	assert.NotNil(t, store)

	// Verify directory was created
	info, err := os.Stat(tmpDir)
	require.NoError(t, err)
	assert.True(t, info.IsDir())
}

func TestStore_SetKeyMetadata(t *testing.T) {
	tmpDir := t.TempDir()

	store, err := NewStore(WithDataDir(tmpDir))
	require.NoError(t, err)

	meta := &KeyMetadata{
		KeyPath:         "/home/user/.ssh/id_ed25519",
		VerifiedService: "GitHub",
		VerifiedHost:    "github.com",
		VerifiedPort:    22,
		VerifiedUser:    "git",
	}

	err = store.SetKeyMetadata(meta)
	require.NoError(t, err)

	// Verify file was written
	_, err = os.Stat(filepath.Join(tmpDir, "metadata.json"))
	require.NoError(t, err)
}

func TestStore_SetKeyMetadata_NilMeta(t *testing.T) {
	tmpDir := t.TempDir()

	store, err := NewStore(WithDataDir(tmpDir))
	require.NoError(t, err)

	err = store.SetKeyMetadata(nil)
	require.Error(t, err)
	assert.Contains(t, err.Error(), "key path is required")
}

func TestStore_SetKeyMetadata_EmptyKeyPath(t *testing.T) {
	tmpDir := t.TempDir()

	store, err := NewStore(WithDataDir(tmpDir))
	require.NoError(t, err)

	err = store.SetKeyMetadata(&KeyMetadata{KeyPath: ""})
	require.Error(t, err)
	assert.Contains(t, err.Error(), "key path is required")
}

func TestStore_GetKeyMetadata(t *testing.T) {
	tmpDir := t.TempDir()

	store, err := NewStore(WithDataDir(tmpDir))
	require.NoError(t, err)

	keyPath := "/home/user/.ssh/id_ed25519"
	meta := &KeyMetadata{
		KeyPath:         keyPath,
		VerifiedService: "GitHub",
		VerifiedHost:    "github.com",
		VerifiedPort:    22,
		VerifiedUser:    "git",
	}

	err = store.SetKeyMetadata(meta)
	require.NoError(t, err)

	retrieved := store.GetKeyMetadata(keyPath)
	require.NotNil(t, retrieved)
	assert.Equal(t, keyPath, retrieved.KeyPath)
	assert.Equal(t, "GitHub", retrieved.VerifiedService)
	assert.Equal(t, "github.com", retrieved.VerifiedHost)
	assert.Equal(t, 22, retrieved.VerifiedPort)
	assert.Equal(t, "git", retrieved.VerifiedUser)
}

func TestStore_GetKeyMetadata_NotFound(t *testing.T) {
	tmpDir := t.TempDir()

	store, err := NewStore(WithDataDir(tmpDir))
	require.NoError(t, err)

	retrieved := store.GetKeyMetadata("/nonexistent/key")
	assert.Nil(t, retrieved)
}

func TestStore_GetKeyMetadata_ReturnsCopy(t *testing.T) {
	tmpDir := t.TempDir()

	store, err := NewStore(WithDataDir(tmpDir))
	require.NoError(t, err)

	keyPath := "/home/user/.ssh/id_ed25519"
	err = store.SetKeyMetadata(&KeyMetadata{
		KeyPath:         keyPath,
		VerifiedService: "GitHub",
	})
	require.NoError(t, err)

	// Get the metadata and modify it
	retrieved := store.GetKeyMetadata(keyPath)
	retrieved.VerifiedService = "MODIFIED"

	// Get again and verify original is unchanged
	original := store.GetKeyMetadata(keyPath)
	assert.Equal(t, "GitHub", original.VerifiedService)
}

func TestStore_DeleteKeyMetadata(t *testing.T) {
	tmpDir := t.TempDir()

	store, err := NewStore(WithDataDir(tmpDir))
	require.NoError(t, err)

	keyPath := "/home/user/.ssh/id_ed25519"
	err = store.SetKeyMetadata(&KeyMetadata{
		KeyPath:         keyPath,
		VerifiedService: "GitHub",
	})
	require.NoError(t, err)

	// Delete it
	err = store.DeleteKeyMetadata(keyPath)
	require.NoError(t, err)

	// Verify it's gone
	retrieved := store.GetKeyMetadata(keyPath)
	assert.Nil(t, retrieved)
}

func TestStore_DeleteKeyMetadata_NotFound(t *testing.T) {
	tmpDir := t.TempDir()

	store, err := NewStore(WithDataDir(tmpDir))
	require.NoError(t, err)

	// Deleting non-existent key should not error
	err = store.DeleteKeyMetadata("/nonexistent/key")
	require.NoError(t, err)
}

func TestStore_ListKeyMetadata(t *testing.T) {
	tmpDir := t.TempDir()

	store, err := NewStore(WithDataDir(tmpDir))
	require.NoError(t, err)

	// Add multiple keys
	keys := []string{"/key1", "/key2", "/key3"}
	for _, key := range keys {
		err = store.SetKeyMetadata(&KeyMetadata{
			KeyPath:         key,
			VerifiedService: "Test",
		})
		require.NoError(t, err)
	}

	// List all
	all := store.ListKeyMetadata()
	assert.Len(t, all, 3)

	// Verify all keys are present
	paths := make(map[string]bool)
	for _, meta := range all {
		paths[meta.KeyPath] = true
	}
	for _, key := range keys {
		assert.True(t, paths[key])
	}
}

func TestStore_ListKeyMetadata_Empty(t *testing.T) {
	tmpDir := t.TempDir()

	store, err := NewStore(WithDataDir(tmpDir))
	require.NoError(t, err)

	all := store.ListKeyMetadata()
	assert.Empty(t, all)
}

func TestStore_Persistence(t *testing.T) {
	tmpDir := t.TempDir()

	// Create store and add data
	store1, err := NewStore(WithDataDir(tmpDir))
	require.NoError(t, err)

	keyPath := "/home/user/.ssh/id_ed25519"
	err = store1.SetKeyMetadata(&KeyMetadata{
		KeyPath:         keyPath,
		VerifiedService: "GitHub",
		VerifiedHost:    "github.com",
		VerifiedPort:    22,
		VerifiedUser:    "git",
	})
	require.NoError(t, err)

	// Create a new store instance (simulating restart)
	store2, err := NewStore(WithDataDir(tmpDir))
	require.NoError(t, err)

	// Data should be loaded from disk
	retrieved := store2.GetKeyMetadata(keyPath)
	require.NotNil(t, retrieved)
	assert.Equal(t, "GitHub", retrieved.VerifiedService)
	assert.Equal(t, "github.com", retrieved.VerifiedHost)
}

func TestStore_LoadCorruptedFile(t *testing.T) {
	tmpDir := t.TempDir()

	// Create corrupted file
	metaFile := filepath.Join(tmpDir, "metadata.json")
	err := os.WriteFile(metaFile, []byte("not valid json{{{"), 0600)
	require.NoError(t, err)

	// Should recover gracefully
	store, err := NewStore(WithDataDir(tmpDir))
	require.NoError(t, err)

	// Should have empty data
	all := store.ListKeyMetadata()
	assert.Empty(t, all)
}

func TestStore_UpdateExisting(t *testing.T) {
	tmpDir := t.TempDir()

	store, err := NewStore(WithDataDir(tmpDir))
	require.NoError(t, err)

	keyPath := "/home/user/.ssh/id_ed25519"

	// Set initial metadata
	err = store.SetKeyMetadata(&KeyMetadata{
		KeyPath:         keyPath,
		VerifiedService: "GitHub",
	})
	require.NoError(t, err)

	// Update with new service
	err = store.SetKeyMetadata(&KeyMetadata{
		KeyPath:         keyPath,
		VerifiedService: "GitLab",
		VerifiedHost:    "gitlab.com",
	})
	require.NoError(t, err)

	// Verify update
	retrieved := store.GetKeyMetadata(keyPath)
	require.NotNil(t, retrieved)
	assert.Equal(t, "GitLab", retrieved.VerifiedService)
	assert.Equal(t, "gitlab.com", retrieved.VerifiedHost)

	// Should still be only one entry
	all := store.ListKeyMetadata()
	assert.Len(t, all, 1)
}

func TestStore_FilePermissions(t *testing.T) {
	tmpDir := t.TempDir()

	store, err := NewStore(WithDataDir(tmpDir))
	require.NoError(t, err)

	err = store.SetKeyMetadata(&KeyMetadata{
		KeyPath:         "/test/key",
		VerifiedService: "Test",
	})
	require.NoError(t, err)

	// Check file permissions (should be 0600)
	info, err := os.Stat(filepath.Join(tmpDir, "metadata.json"))
	require.NoError(t, err)
	assert.Equal(t, os.FileMode(0600), info.Mode().Perm())
}
