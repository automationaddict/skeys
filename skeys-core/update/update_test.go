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

package update

import (
	"context"
	"os"
	"path/filepath"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestNewManager(t *testing.T) {
	mgr := NewManager("1.0.0", "/install", "/cache")
	require.NotNil(t, mgr)
	assert.Equal(t, "1.0.0", mgr.currentVersion)
	assert.Equal(t, "/install", mgr.installDir)
	assert.Equal(t, "/cache", mgr.cacheDir)
}

func TestManager_GetStatus(t *testing.T) {
	mgr := NewManager("1.0.0", "/install", "/cache")
	status := mgr.GetStatus()
	assert.Equal(t, StateIdle, status.State)
}

func TestDefaultSettings(t *testing.T) {
	settings := DefaultSettings()
	assert.True(t, settings.AutoCheck)
	assert.False(t, settings.AutoDownload)
	assert.False(t, settings.AutoApply)
	assert.False(t, settings.IncludePrereleases)
	assert.Equal(t, 24, settings.CheckIntervalHours)
}

func TestIsNewerVersion(t *testing.T) {
	tests := []struct {
		name     string
		a        string
		b        string
		expected bool
	}{
		{"simple newer", "1.1.0", "1.0.0", true},
		{"same version", "1.0.0", "1.0.0", false},
		{"older version", "1.0.0", "1.1.0", false},
		{"major bump", "2.0.0", "1.9.9", true},
		{"minor bump", "1.2.0", "1.1.9", true},
		{"patch bump", "1.0.1", "1.0.0", true},
		{"with v prefix a", "v1.1.0", "1.0.0", true},
		{"with v prefix b", "1.1.0", "v1.0.0", true},
		{"with v prefix both", "v1.1.0", "v1.0.0", true},
		{"more parts newer", "1.0.0.1", "1.0.0", true},
		{"less parts older", "1.0.0", "1.0.0.1", false},
		{"double digit minor", "1.10.0", "1.9.0", true},
		{"double digit patch", "1.0.10", "1.0.9", true},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			result := isNewerVersion(tt.a, tt.b)
			assert.Equal(t, tt.expected, result)
		})
	}
}

func TestState(t *testing.T) {
	assert.Equal(t, State(0), StateIdle)
	assert.Equal(t, State(1), StateChecking)
	assert.Equal(t, State(2), StateUpdateAvailable)
	assert.Equal(t, State(3), StateDownloading)
	assert.Equal(t, State(4), StateReadyToApply)
	assert.Equal(t, State(5), StateApplying)
	assert.Equal(t, State(6), StateError)
}

func TestDownloadState(t *testing.T) {
	assert.Equal(t, DownloadState(0), DownloadStarting)
	assert.Equal(t, DownloadState(1), DownloadDownloading)
	assert.Equal(t, DownloadState(2), DownloadVerifying)
	assert.Equal(t, DownloadState(3), DownloadCompleted)
	assert.Equal(t, DownloadState(4), DownloadError)
}

func TestLoadSettings_NotExists(t *testing.T) {
	tmpDir := t.TempDir()

	settings, err := LoadSettings(tmpDir)
	require.NoError(t, err)

	// Should return defaults
	assert.True(t, settings.AutoCheck)
	assert.False(t, settings.AutoDownload)
}

func TestSaveSettings(t *testing.T) {
	tmpDir := t.TempDir()

	settings := Settings{
		AutoCheck:          false,
		AutoDownload:       true,
		AutoApply:          true,
		IncludePrereleases: true,
		CheckIntervalHours: 12,
	}

	err := SaveSettings(tmpDir, settings)
	require.NoError(t, err)

	// Verify file was created
	settingsPath := filepath.Join(tmpDir, "update-settings.json")
	_, err = os.Stat(settingsPath)
	require.NoError(t, err)

	// Load and verify
	loaded, err := LoadSettings(tmpDir)
	require.NoError(t, err)
	assert.Equal(t, settings, loaded)
}

func TestLoadSettings_Invalid(t *testing.T) {
	tmpDir := t.TempDir()
	settingsPath := filepath.Join(tmpDir, "update-settings.json")

	err := os.WriteFile(settingsPath, []byte("not valid json{{{"), 0600)
	require.NoError(t, err)

	// Should return defaults on parse error
	settings, err := LoadSettings(tmpDir)
	require.Error(t, err)
	_ = settings
}

func TestReleaseInfo(t *testing.T) {
	release := ReleaseInfo{
		TagName:    "v1.0.0",
		Name:       "Release 1.0.0",
		Body:       "Release notes",
		HTMLURL:    "https://github.com/example/repo/releases/v1.0.0",
		Prerelease: false,
		Assets: []Asset{
			{
				Name:               "skeys-v1.0.0-linux-x64.tar.gz",
				Size:               1024000,
				BrowserDownloadURL: "https://github.com/example/repo/releases/download/v1.0.0/skeys-v1.0.0-linux-x64.tar.gz",
			},
		},
	}

	assert.Equal(t, "v1.0.0", release.TagName)
	assert.Len(t, release.Assets, 1)
	assert.Equal(t, int64(1024000), release.Assets[0].Size)
}

func TestProgress(t *testing.T) {
	progress := Progress{
		State:           DownloadDownloading,
		BytesDownloaded: 512000,
		TotalBytes:      1024000,
		BytesPerSecond:  100000,
	}

	assert.Equal(t, DownloadDownloading, progress.State)
	assert.Equal(t, int64(512000), progress.BytesDownloaded)
}

func TestStatus(t *testing.T) {
	status := Status{
		State: StateUpdateAvailable,
		AvailableUpdate: &ReleaseInfo{
			TagName: "v1.1.0",
		},
	}

	assert.Equal(t, StateUpdateAvailable, status.State)
	assert.NotNil(t, status.AvailableUpdate)
	assert.Equal(t, "v1.1.0", status.AvailableUpdate.TagName)
}

func TestManager_Rollback_NoBackup(t *testing.T) {
	tmpDir := t.TempDir()
	installDir := filepath.Join(tmpDir, "install")

	mgr := NewManager("1.0.0", installDir, filepath.Join(tmpDir, "cache"))

	err := mgr.Rollback()
	require.Error(t, err)
	assert.Contains(t, err.Error(), "no backup available")
}

func TestManager_SetState(t *testing.T) {
	tmpDir := t.TempDir()
	mgr := NewManager("1.0.0", filepath.Join(tmpDir, "install"), filepath.Join(tmpDir, "cache"))

	mgr.setState(StateChecking)
	assert.Equal(t, StateChecking, mgr.GetStatus().State)

	mgr.setState(StateDownloading)
	assert.Equal(t, StateDownloading, mgr.GetStatus().State)
}

func TestManager_SetError(t *testing.T) {
	tmpDir := t.TempDir()
	mgr := NewManager("1.0.0", filepath.Join(tmpDir, "install"), filepath.Join(tmpDir, "cache"))

	mgr.setError(assert.AnError)
	status := mgr.GetStatus()
	assert.Equal(t, StateError, status.State)
	assert.NotEmpty(t, status.Error)
}

func TestManager_VerifyChecksum(t *testing.T) {
	tmpDir := t.TempDir()
	mgr := NewManager("1.0.0", filepath.Join(tmpDir, "install"), filepath.Join(tmpDir, "cache"))

	// Create a test file
	testContent := []byte("test content for checksum")
	testFile := filepath.Join(tmpDir, "testfile")
	err := os.WriteFile(testFile, testContent, 0600)
	require.NoError(t, err)

	// Create checksum file with correct hash
	// SHA256 of "test content for checksum" = 5be3c5e9d54f8a17b4d1e8b2f5c3a7c6d8e9f0a1b2c3d4e5f6a7b8c9d0e1f2a3 (example)
	// Actually compute: 5be3c5e9d54f8a17b4d1e8b2f5c3a7c6d8e9f0a1b2c3d4e5f6a7b8c9d0e1f2a3
	checksumFile := filepath.Join(tmpDir, "testfile.sha256")
	// Using actual SHA256 hash
	err = os.WriteFile(checksumFile, []byte("a63de8be6d5c76c0c18d5c5c9c5b6a7e8d9f0a1b2c3d4e5f6a7b8c9d0e1f2a3b4  testfile"), 0600)
	require.NoError(t, err)

	// Verification should fail because we used a fake hash
	err = mgr.verifyChecksum(testFile, checksumFile)
	require.Error(t, err)
	assert.Contains(t, err.Error(), "checksum mismatch")
}

func TestSettings(t *testing.T) {
	settings := Settings{
		AutoCheck:          true,
		AutoDownload:       false,
		AutoApply:          false,
		IncludePrereleases: false,
		CheckIntervalHours: 24,
	}

	assert.True(t, settings.AutoCheck)
	assert.False(t, settings.AutoDownload)
	assert.Equal(t, 24, settings.CheckIntervalHours)
}

func TestManager_VerifyChecksum_ValidHash(t *testing.T) {
	tmpDir := t.TempDir()
	mgr := NewManager("1.0.0", filepath.Join(tmpDir, "install"), filepath.Join(tmpDir, "cache"))

	// Create a test file
	testContent := []byte("hello world")
	testFile := filepath.Join(tmpDir, "testfile")
	err := os.WriteFile(testFile, testContent, 0600)
	require.NoError(t, err)

	// SHA256 of "hello world" = b94d27b9934d3e08a52e52d7da7dabfac484efe37a5380ee9088f7ace2efcde9
	checksumFile := filepath.Join(tmpDir, "testfile.sha256")
	err = os.WriteFile(checksumFile, []byte("b94d27b9934d3e08a52e52d7da7dabfac484efe37a5380ee9088f7ace2efcde9  testfile"), 0600)
	require.NoError(t, err)

	err = mgr.verifyChecksum(testFile, checksumFile)
	require.NoError(t, err)
}

func TestManager_VerifyChecksum_EmptyChecksumFile(t *testing.T) {
	tmpDir := t.TempDir()
	mgr := NewManager("1.0.0", filepath.Join(tmpDir, "install"), filepath.Join(tmpDir, "cache"))

	testFile := filepath.Join(tmpDir, "testfile")
	err := os.WriteFile(testFile, []byte("test"), 0600)
	require.NoError(t, err)

	checksumFile := filepath.Join(tmpDir, "testfile.sha256")
	err = os.WriteFile(checksumFile, []byte(""), 0600)
	require.NoError(t, err)

	err = mgr.verifyChecksum(testFile, checksumFile)
	require.Error(t, err)
	assert.Contains(t, err.Error(), "empty checksum file")
}

func TestManager_VerifyChecksum_FileNotExist(t *testing.T) {
	tmpDir := t.TempDir()
	mgr := NewManager("1.0.0", filepath.Join(tmpDir, "install"), filepath.Join(tmpDir, "cache"))

	testFile := filepath.Join(tmpDir, "nonexistent")
	checksumFile := filepath.Join(tmpDir, "testfile.sha256")
	err := os.WriteFile(checksumFile, []byte("abc123  testfile"), 0600)
	require.NoError(t, err)

	err = mgr.verifyChecksum(testFile, checksumFile)
	require.Error(t, err)
}

func TestManager_VerifyChecksum_ChecksumFileNotExist(t *testing.T) {
	tmpDir := t.TempDir()
	mgr := NewManager("1.0.0", filepath.Join(tmpDir, "install"), filepath.Join(tmpDir, "cache"))

	testFile := filepath.Join(tmpDir, "testfile")
	err := os.WriteFile(testFile, []byte("test"), 0600)
	require.NoError(t, err)

	err = mgr.verifyChecksum(testFile, filepath.Join(tmpDir, "nonexistent.sha256"))
	require.Error(t, err)
}

func TestManager_ExtractTarball_InvalidFile(t *testing.T) {
	tmpDir := t.TempDir()
	mgr := NewManager("1.0.0", filepath.Join(tmpDir, "install"), filepath.Join(tmpDir, "cache"))

	// Create a file that's not a valid tarball
	tarball := filepath.Join(tmpDir, "fake.tar.gz")
	err := os.WriteFile(tarball, []byte("not a tarball"), 0600)
	require.NoError(t, err)

	err = mgr.extractTarball(tarball, filepath.Join(tmpDir, "dest"))
	require.Error(t, err)
}

func TestManager_ExtractTarball_FileNotExist(t *testing.T) {
	tmpDir := t.TempDir()
	mgr := NewManager("1.0.0", filepath.Join(tmpDir, "install"), filepath.Join(tmpDir, "cache"))

	err := mgr.extractTarball(filepath.Join(tmpDir, "nonexistent.tar.gz"), filepath.Join(tmpDir, "dest"))
	require.Error(t, err)
}

func TestManager_ApplyUpdate_TarballNotExist(t *testing.T) {
	tmpDir := t.TempDir()
	installDir := filepath.Join(tmpDir, "install")
	mgr := NewManager("1.0.0", installDir, filepath.Join(tmpDir, "cache"))

	err := mgr.ApplyUpdate(context.Background(), filepath.Join(tmpDir, "nonexistent.tar.gz"), false)
	require.Error(t, err)
}

func TestManager_Rollback_Success(t *testing.T) {
	tmpDir := t.TempDir()
	installDir := filepath.Join(tmpDir, "install")

	// Create install directory
	err := os.MkdirAll(installDir, 0755)
	require.NoError(t, err)
	err = os.WriteFile(filepath.Join(installDir, "file.txt"), []byte("new"), 0600)
	require.NoError(t, err)

	// Create backup
	backupDir := installDir + ".backup"
	err = os.MkdirAll(backupDir, 0755)
	require.NoError(t, err)
	err = os.WriteFile(filepath.Join(backupDir, "file.txt"), []byte("old"), 0600)
	require.NoError(t, err)

	mgr := NewManager("1.0.0", installDir, filepath.Join(tmpDir, "cache"))

	err = mgr.Rollback()
	require.NoError(t, err)

	// Verify rollback
	content, err := os.ReadFile(filepath.Join(installDir, "file.txt"))
	require.NoError(t, err)
	assert.Equal(t, "old", string(content))
}

func TestManager_DownloadUpdate_NoMatchingAsset(t *testing.T) {
	tmpDir := t.TempDir()
	mgr := NewManager("1.0.0", filepath.Join(tmpDir, "install"), filepath.Join(tmpDir, "cache"))

	release := &ReleaseInfo{
		TagName: "v1.0.0",
		Assets: []Asset{
			{
				Name:               "different-asset.tar.gz",
				BrowserDownloadURL: "http://example.com/different.tar.gz",
			},
		},
	}

	_, err := mgr.DownloadUpdate(context.Background(), release, nil)
	require.Error(t, err)
	assert.Contains(t, err.Error(), "not found in release")
}

func TestAsset(t *testing.T) {
	asset := Asset{
		Name:               "test.tar.gz",
		Size:               1024,
		BrowserDownloadURL: "http://example.com/test.tar.gz",
	}

	assert.Equal(t, "test.tar.gz", asset.Name)
	assert.Equal(t, int64(1024), asset.Size)
	assert.Equal(t, "http://example.com/test.tar.gz", asset.BrowserDownloadURL)
}

func TestIsNewerVersion_NonNumeric(t *testing.T) {
	// Test with non-numeric parts - falls back to string comparison
	// These tests document actual behavior, not necessarily desired behavior
	assert.True(t, isNewerVersion("1.0.0-beta", "1.0.0-alpha"))  // beta > alpha lexicographically
	assert.False(t, isNewerVersion("1.0.0-alpha", "1.0.0-beta")) // alpha < beta lexicographically
}
