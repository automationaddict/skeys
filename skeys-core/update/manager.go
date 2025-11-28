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

// Package update provides automatic update functionality via GitHub releases.
package update

import (
	"archive/tar"
	"compress/gzip"
	"context"
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"os"
	"path/filepath"
	"strconv"
	"strings"
	"sync"
	"time"

	"github.com/johnnelson/skeys-core/logging"
)

const (
	githubRepo     = "automationaddict/skeys"
	githubAPIBase  = "https://api.github.com"
	defaultTimeout = 30 * time.Second
)

// Manager handles checking for and applying updates from GitHub releases.
type Manager struct {
	currentVersion string
	installDir     string
	cacheDir       string
	logger         *logging.Logger
	client         *http.Client

	mu     sync.RWMutex
	status Status
}

// Status represents the current state of the update system.
type Status struct {
	State            State
	AvailableUpdate  *ReleaseInfo
	DownloadProgress *Progress
	LastCheck        time.Time
	Error            string
}

// State represents the overall update system state.
type State int

const (
	StateIdle State = iota
	StateChecking
	StateUpdateAvailable
	StateDownloading
	StateReadyToApply
	StateApplying
	StateError
)

// ReleaseInfo contains information about a GitHub release.
type ReleaseInfo struct {
	TagName     string    `json:"tag_name"`
	Name        string    `json:"name"`
	Body        string    `json:"body"`
	HTMLURL     string    `json:"html_url"`
	Prerelease  bool      `json:"prerelease"`
	PublishedAt time.Time `json:"published_at"`
	Assets      []Asset   `json:"assets"`
}

// Asset represents a release asset (downloadable file).
type Asset struct {
	Name               string `json:"name"`
	Size               int64  `json:"size"`
	BrowserDownloadURL string `json:"browser_download_url"`
}

// Progress reports download progress.
type Progress struct {
	State           DownloadState
	BytesDownloaded int64
	TotalBytes      int64
	BytesPerSecond  int64
	Error           string
	DownloadedPath  string
}

// DownloadState represents the state of a download.
type DownloadState int

const (
	DownloadStarting DownloadState = iota
	DownloadDownloading
	DownloadVerifying
	DownloadCompleted
	DownloadError
)

// Settings configures automatic update behavior.
type Settings struct {
	AutoCheck          bool `json:"auto_check"`
	AutoDownload       bool `json:"auto_download"`
	AutoApply          bool `json:"auto_apply"`
	IncludePrereleases bool `json:"include_prereleases"`
	CheckIntervalHours int  `json:"check_interval_hours"`
	IncludePatches     bool `json:"include_patches"`
}

// DefaultSettings returns sensible default settings.
func DefaultSettings() Settings {
	return Settings{
		AutoCheck:          true,
		AutoDownload:       false,
		AutoApply:          false,
		IncludePrereleases: false,
		CheckIntervalHours: 24,
		IncludePatches:     true, // Default to including patch updates
	}
}

// NewManager creates a new update manager.
func NewManager(currentVersion, installDir, cacheDir string) *Manager {
	return &Manager{
		currentVersion: currentVersion,
		installDir:     installDir,
		cacheDir:       cacheDir,
		logger:         logging.New(logging.Config{Component: "update"}),
		client: &http.Client{
			Timeout: defaultTimeout,
		},
		status: Status{
			State: StateIdle,
		},
	}
}

// GetStatus returns the current update status.
func (m *Manager) GetStatus() Status {
	m.mu.RLock()
	defer m.mu.RUnlock()
	return m.status
}

func (m *Manager) setState(state State) {
	m.mu.Lock()
	m.status.State = state
	m.mu.Unlock()
}

func (m *Manager) setError(err error) {
	m.mu.Lock()
	m.status.State = StateError
	m.status.Error = err.Error()
	m.mu.Unlock()
}

// CheckForUpdates queries GitHub for the latest release.
func (m *Manager) CheckForUpdates(ctx context.Context, includePrereleases, includePatches bool) (*ReleaseInfo, error) {
	m.setState(StateChecking)
	m.logger.InfoWithFields("checking for updates", map[string]interface{}{
		"current_version": m.currentVersion,
		"include_patches": includePatches,
	})

	release, err := m.fetchLatestRelease(ctx, includePrereleases)
	if err != nil {
		m.setError(err)
		return nil, fmt.Errorf("failed to fetch latest release: %w", err)
	}

	m.mu.Lock()
	m.status.LastCheck = time.Now()
	m.mu.Unlock()

	// Compare versions (strip 'v' prefix if present)
	latestVersion := strings.TrimPrefix(release.TagName, "v")
	currentVersion := strings.TrimPrefix(m.currentVersion, "v")

	// Check if there's a newer version
	if !isNewerVersion(latestVersion, currentVersion) {
		m.logger.InfoWithFields("already up to date", map[string]interface{}{
			"current": currentVersion,
			"latest":  latestVersion,
		})
		m.setState(StateIdle)
		return nil, nil
	}

	// If not including patches, check if this is only a patch update
	if !includePatches && isPatchUpdate(currentVersion, latestVersion) {
		m.logger.InfoWithFields("patch update available but patches disabled", map[string]interface{}{
			"current": currentVersion,
			"latest":  latestVersion,
		})
		m.setState(StateIdle)
		return nil, nil
	}

	m.logger.InfoWithFields("update available", map[string]interface{}{
		"current": currentVersion,
		"latest":  latestVersion,
	})
	m.mu.Lock()
	m.status.State = StateUpdateAvailable
	m.status.AvailableUpdate = release
	m.mu.Unlock()

	return release, nil
}

func (m *Manager) fetchLatestRelease(ctx context.Context, includePrereleases bool) (*ReleaseInfo, error) {
	var url string
	if includePrereleases {
		// Need to list releases and find the latest (including prereleases)
		url = fmt.Sprintf("%s/repos/%s/releases", githubAPIBase, githubRepo)
	} else {
		url = fmt.Sprintf("%s/repos/%s/releases/latest", githubAPIBase, githubRepo)
	}

	req, err := http.NewRequestWithContext(ctx, "GET", url, nil)
	if err != nil {
		return nil, err
	}
	req.Header.Set("Accept", "application/vnd.github.v3+json")
	req.Header.Set("User-Agent", "skeys-updater/"+m.currentVersion)

	resp, err := m.client.Do(req)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	if resp.StatusCode == http.StatusNotFound {
		return nil, fmt.Errorf("no releases found")
	}
	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("unexpected status: %s", resp.Status)
	}

	if includePrereleases {
		var releases []ReleaseInfo
		if err := json.NewDecoder(resp.Body).Decode(&releases); err != nil {
			return nil, err
		}
		if len(releases) == 0 {
			return nil, fmt.Errorf("no releases found")
		}
		return &releases[0], nil
	}

	var release ReleaseInfo
	if err := json.NewDecoder(resp.Body).Decode(&release); err != nil {
		return nil, err
	}
	return &release, nil
}

// DownloadUpdate downloads the release tarball and returns progress via callback.
func (m *Manager) DownloadUpdate(ctx context.Context, release *ReleaseInfo, progressFn func(Progress)) (string, error) {
	m.setState(StateDownloading)

	// Find the appropriate asset
	assetName := fmt.Sprintf("skeys-%s-linux-x64.tar.gz", release.TagName)
	var asset *Asset
	for i := range release.Assets {
		if release.Assets[i].Name == assetName {
			asset = &release.Assets[i]
			break
		}
	}
	if asset == nil {
		err := fmt.Errorf("asset %s not found in release", assetName)
		m.setError(err)
		return "", err
	}

	// Create cache directory
	if err := os.MkdirAll(m.cacheDir, 0700); err != nil {
		m.setError(err)
		return "", fmt.Errorf("failed to create cache directory: %w", err)
	}

	// Download tarball
	tarballPath := filepath.Join(m.cacheDir, assetName)
	checksumPath := tarballPath + ".sha256"

	m.logger.InfoWithFields("downloading update", map[string]interface{}{
		"url":  asset.BrowserDownloadURL,
		"size": asset.Size,
	})

	progress := Progress{
		State:      DownloadStarting,
		TotalBytes: asset.Size,
	}
	if progressFn != nil {
		progressFn(progress)
	}

	// Download tarball
	if err := m.downloadFile(ctx, asset.BrowserDownloadURL, tarballPath, asset.Size, func(downloaded, total, speed int64) {
		progress.State = DownloadDownloading
		progress.BytesDownloaded = downloaded
		progress.TotalBytes = total
		progress.BytesPerSecond = speed
		m.mu.Lock()
		m.status.DownloadProgress = &progress
		m.mu.Unlock()
		if progressFn != nil {
			progressFn(progress)
		}
	}); err != nil {
		m.setError(err)
		return "", fmt.Errorf("failed to download tarball: %w", err)
	}

	// Download checksum
	checksumURL := asset.BrowserDownloadURL + ".sha256"
	if err := m.downloadFile(ctx, checksumURL, checksumPath, 0, nil); err != nil {
		m.logger.WarnWithFields("checksum file not available, skipping verification", map[string]interface{}{
			"error": err.Error(),
		})
	} else {
		// Verify checksum
		progress.State = DownloadVerifying
		if progressFn != nil {
			progressFn(progress)
		}

		if err := m.verifyChecksum(tarballPath, checksumPath); err != nil {
			os.Remove(tarballPath)
			os.Remove(checksumPath)
			m.setError(err)
			return "", fmt.Errorf("checksum verification failed: %w", err)
		}
		m.logger.Info("checksum verified")
	}

	progress.State = DownloadCompleted
	progress.DownloadedPath = tarballPath
	if progressFn != nil {
		progressFn(progress)
	}

	m.mu.Lock()
	m.status.State = StateReadyToApply
	m.status.DownloadProgress = &progress
	m.mu.Unlock()

	return tarballPath, nil
}

func (m *Manager) downloadFile(ctx context.Context, url, destPath string, expectedSize int64, progressFn func(downloaded, total, speed int64)) error {
	req, err := http.NewRequestWithContext(ctx, "GET", url, nil)
	if err != nil {
		return err
	}
	req.Header.Set("User-Agent", "skeys-updater/"+m.currentVersion)

	resp, err := m.client.Do(req)
	if err != nil {
		return err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return fmt.Errorf("download failed: %s", resp.Status)
	}

	totalSize := resp.ContentLength
	if totalSize <= 0 && expectedSize > 0 {
		totalSize = expectedSize
	}

	f, err := os.Create(destPath)
	if err != nil {
		return err
	}
	defer f.Close()

	var downloaded int64
	startTime := time.Now()
	buf := make([]byte, 32*1024)

	for {
		n, err := resp.Body.Read(buf)
		if n > 0 {
			if _, werr := f.Write(buf[:n]); werr != nil {
				return werr
			}
			downloaded += int64(n)

			if progressFn != nil {
				elapsed := time.Since(startTime).Seconds()
				var speed int64
				if elapsed > 0 {
					speed = int64(float64(downloaded) / elapsed)
				}
				progressFn(downloaded, totalSize, speed)
			}
		}
		if err == io.EOF {
			break
		}
		if err != nil {
			return err
		}
	}

	return nil
}

func (m *Manager) verifyChecksum(tarballPath, checksumPath string) error {
	// Read expected checksum
	data, err := os.ReadFile(checksumPath)
	if err != nil {
		return err
	}

	// Parse checksum file (format: "hash  filename" or just "hash")
	parts := strings.Fields(string(data))
	if len(parts) == 0 {
		return fmt.Errorf("empty checksum file")
	}
	expectedHash := strings.ToLower(parts[0])

	// Calculate actual checksum
	f, err := os.Open(tarballPath)
	if err != nil {
		return err
	}
	defer f.Close()

	hasher := sha256.New()
	if _, err := io.Copy(hasher, f); err != nil {
		return err
	}
	actualHash := hex.EncodeToString(hasher.Sum(nil))

	if actualHash != expectedHash {
		return fmt.Errorf("checksum mismatch: expected %s, got %s", expectedHash, actualHash)
	}

	return nil
}

// ApplyUpdate extracts and installs the update from the tarball.
func (m *Manager) ApplyUpdate(ctx context.Context, tarballPath string, force bool) error {
	m.setState(StateApplying)
	m.logger.InfoWithFields("applying update", map[string]interface{}{
		"tarball": tarballPath,
	})

	// Create backup
	backupDir := m.installDir + ".backup"
	if err := os.RemoveAll(backupDir); err != nil && !os.IsNotExist(err) {
		m.logger.WarnWithFields("failed to remove old backup", map[string]interface{}{
			"error": err.Error(),
		})
	}

	// Check if install directory exists
	if _, err := os.Stat(m.installDir); err == nil {
		m.logger.InfoWithFields("backing up current installation", map[string]interface{}{
			"backup": backupDir,
		})
		if err := os.Rename(m.installDir, backupDir); err != nil {
			m.setError(err)
			return fmt.Errorf("failed to create backup: %w", err)
		}
	}

	// Create new install directory
	if err := os.MkdirAll(m.installDir, 0755); err != nil {
		// Rollback
		os.Rename(backupDir, m.installDir)
		m.setError(err)
		return fmt.Errorf("failed to create install directory: %w", err)
	}

	// Extract tarball
	if err := m.extractTarball(tarballPath, m.installDir); err != nil {
		// Rollback
		os.RemoveAll(m.installDir)
		os.Rename(backupDir, m.installDir)
		m.setError(err)
		return fmt.Errorf("failed to extract update: %w", err)
	}

	// Make binaries executable
	for _, bin := range []string{"skeys-app", "skeys-daemon"} {
		binPath := filepath.Join(m.installDir, bin)
		if err := os.Chmod(binPath, 0755); err != nil {
			m.logger.WarnWithFields("failed to set executable permission", map[string]interface{}{
				"path":  binPath,
				"error": err.Error(),
			})
		}
	}

	m.logger.Info("update applied successfully")
	m.setState(StateIdle)

	// Clean up
	os.Remove(tarballPath)
	os.Remove(tarballPath + ".sha256")

	return nil
}

func (m *Manager) extractTarball(tarballPath, destDir string) error {
	f, err := os.Open(tarballPath)
	if err != nil {
		return err
	}
	defer f.Close()

	gzr, err := gzip.NewReader(f)
	if err != nil {
		return err
	}
	defer gzr.Close()

	tr := tar.NewReader(gzr)

	for {
		header, err := tr.Next()
		if err == io.EOF {
			break
		}
		if err != nil {
			return err
		}

		// Strip the first directory component (e.g., "skeys-v0.1.0-linux-x64/")
		name := header.Name
		if idx := strings.Index(name, "/"); idx != -1 {
			name = name[idx+1:]
		}
		if name == "" {
			continue
		}

		target := filepath.Join(destDir, name)

		// Security: prevent path traversal
		if !strings.HasPrefix(filepath.Clean(target), filepath.Clean(destDir)) {
			return fmt.Errorf("invalid tar path: %s", header.Name)
		}

		switch header.Typeflag {
		case tar.TypeDir:
			if err := os.MkdirAll(target, 0755); err != nil {
				return err
			}
		case tar.TypeReg:
			if err := os.MkdirAll(filepath.Dir(target), 0755); err != nil {
				return err
			}
			outFile, err := os.Create(target)
			if err != nil {
				return err
			}
			if _, err := io.Copy(outFile, tr); err != nil {
				outFile.Close()
				return err
			}
			outFile.Close()
			// Preserve executable bit
			if header.Mode&0111 != 0 {
				os.Chmod(target, os.FileMode(header.Mode))
			}
		}
	}

	return nil
}

// Rollback restores the previous installation from backup.
func (m *Manager) Rollback() error {
	backupDir := m.installDir + ".backup"

	if _, err := os.Stat(backupDir); os.IsNotExist(err) {
		return fmt.Errorf("no backup available")
	}

	m.logger.Info("rolling back to previous version")

	if err := os.RemoveAll(m.installDir); err != nil {
		return fmt.Errorf("failed to remove current installation: %w", err)
	}

	if err := os.Rename(backupDir, m.installDir); err != nil {
		return fmt.Errorf("failed to restore backup: %w", err)
	}

	return nil
}

// isNewerVersion compares semantic versions, returns true if a > b.
func isNewerVersion(a, b string) bool {
	// Strip any leading 'v' prefix
	a = strings.TrimPrefix(a, "v")
	b = strings.TrimPrefix(b, "v")

	// Split into numeric parts
	aParts := strings.Split(a, ".")
	bParts := strings.Split(b, ".")

	// Compare each part numerically
	for i := 0; i < len(aParts) && i < len(bParts); i++ {
		aNum, aErr := strconv.Atoi(aParts[i])
		bNum, bErr := strconv.Atoi(bParts[i])

		// If both are numbers, compare numerically
		if aErr == nil && bErr == nil {
			if aNum > bNum {
				return true
			}
			if aNum < bNum {
				return false
			}
		} else {
			// Fall back to string comparison for non-numeric parts
			if aParts[i] > bParts[i] {
				return true
			}
			if aParts[i] < bParts[i] {
				return false
			}
		}
	}

	return len(aParts) > len(bParts)
}

// isPatchUpdate returns true if the update from 'current' to 'latest' is only a patch or build update.
// A patch update is when only the patch version (third component) or build number changes.
// For example: 1.0.1 -> 1.0.2 is a patch, 0.0.4+1 -> 0.0.4+2 is a build update, but 1.0.1 -> 1.1.0 is not.
func isPatchUpdate(current, latest string) bool {
	// Strip any leading 'v' prefix
	current = strings.TrimPrefix(current, "v")
	latest = strings.TrimPrefix(latest, "v")

	// Split off build metadata (after +) if present
	currentBase, _ := splitBuildMetadata(current)
	latestBase, _ := splitBuildMetadata(latest)

	// Split into parts
	currentParts := strings.Split(currentBase, ".")
	latestParts := strings.Split(latestBase, ".")

	// Need at least 2 parts (major.minor) to compare
	if len(currentParts) < 2 || len(latestParts) < 2 {
		return false
	}

	// Compare major version
	currentMajor, err1 := strconv.Atoi(currentParts[0])
	latestMajor, err2 := strconv.Atoi(latestParts[0])
	if err1 != nil || err2 != nil || currentMajor != latestMajor {
		return false // Major version changed, not a patch
	}

	// Compare minor version
	currentMinor, err1 := strconv.Atoi(currentParts[1])
	latestMinor, err2 := strconv.Atoi(latestParts[1])
	if err1 != nil || err2 != nil || currentMinor != latestMinor {
		return false // Minor version changed, not a patch
	}

	// If major and minor are the same, it's a patch/build update
	return true
}

// splitBuildMetadata splits a version string into base version and build metadata.
// For "0.0.4+2" returns ("0.0.4", "2"), for "0.0.4" returns ("0.0.4", "").
func splitBuildMetadata(version string) (base, build string) {
	if idx := strings.Index(version, "+"); idx != -1 {
		return version[:idx], version[idx+1:]
	}
	return version, ""
}
