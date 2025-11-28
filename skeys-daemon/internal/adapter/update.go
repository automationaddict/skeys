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
	"context"
	"os"
	"path/filepath"

	"google.golang.org/protobuf/types/known/emptypb"
	"google.golang.org/protobuf/types/known/timestamppb"

	"github.com/johnnelson/skeys-core/update"
	pb "github.com/johnnelson/skeys-daemon/api/gen/skeys/v1"
)

// UpdateServiceAdapter implements the gRPC UpdateService
type UpdateServiceAdapter struct {
	pb.UnimplementedUpdateServiceServer

	manager   *update.Manager
	configDir string
}

// NewUpdateServiceAdapter creates a new UpdateServiceAdapter
func NewUpdateServiceAdapter(currentVersion string) *UpdateServiceAdapter {
	homeDir, _ := os.UserHomeDir()
	installDir := filepath.Join(homeDir, ".local", "share", "skeys")
	cacheDir := filepath.Join(homeDir, ".cache", "skeys")
	configDir := filepath.Join(homeDir, ".config", "skeys")

	return &UpdateServiceAdapter{
		manager:   update.NewManager(currentVersion, installDir, cacheDir),
		configDir: configDir,
	}
}

// CheckForUpdates checks GitHub for a newer version
func (a *UpdateServiceAdapter) CheckForUpdates(ctx context.Context, req *emptypb.Empty) (*pb.UpdateInfo, error) {
	settings, _ := update.LoadSettings(a.configDir)

	release, err := a.manager.CheckForUpdates(ctx, settings.IncludePrereleases)
	if err != nil {
		return nil, err
	}

	if release == nil {
		// No update available - already on latest version
		return &pb.UpdateInfo{
			UpdateAvailable: false,
		}, nil
	}

	// Find download size
	var downloadSize int64
	assetName := "skeys-" + release.TagName + "-linux-x64.tar.gz"
	for _, asset := range release.Assets {
		if asset.Name == assetName {
			downloadSize = asset.Size
			break
		}
	}

	return &pb.UpdateInfo{
		UpdateAvailable: true,
		CurrentVersion:  a.manager.GetStatus().AvailableUpdate.TagName,
		LatestVersion:   release.TagName,
		ReleaseUrl:      release.HTMLURL,
		ReleaseNotes:    release.Body,
		DownloadSize:    downloadSize,
		PublishedAt:     timestamppb.New(release.PublishedAt),
		Prerelease:      release.Prerelease,
	}, nil
}

// DownloadUpdate downloads the latest release tarball
func (a *UpdateServiceAdapter) DownloadUpdate(req *pb.DownloadUpdateRequest, stream pb.UpdateService_DownloadUpdateServer) error {
	status := a.manager.GetStatus()
	if status.AvailableUpdate == nil {
		return nil
	}

	_, err := a.manager.DownloadUpdate(stream.Context(), status.AvailableUpdate, func(progress update.Progress) {
		pbProgress := &pb.DownloadProgress{
			State:           convertDownloadState(progress.State),
			BytesDownloaded: progress.BytesDownloaded,
			TotalBytes:      progress.TotalBytes,
			BytesPerSecond:  progress.BytesPerSecond,
			Error:           progress.Error,
			DownloadedPath:  progress.DownloadedPath,
		}
		stream.Send(pbProgress)
	})

	return err
}

func convertDownloadState(state update.DownloadState) pb.DownloadState {
	switch state {
	case update.DownloadStarting:
		return pb.DownloadState_DOWNLOAD_STATE_STARTING
	case update.DownloadDownloading:
		return pb.DownloadState_DOWNLOAD_STATE_DOWNLOADING
	case update.DownloadVerifying:
		return pb.DownloadState_DOWNLOAD_STATE_VERIFYING
	case update.DownloadCompleted:
		return pb.DownloadState_DOWNLOAD_STATE_COMPLETED
	case update.DownloadError:
		return pb.DownloadState_DOWNLOAD_STATE_ERROR
	default:
		return pb.DownloadState_DOWNLOAD_STATE_UNSPECIFIED
	}
}

// ApplyUpdate extracts and applies a downloaded update
func (a *UpdateServiceAdapter) ApplyUpdate(ctx context.Context, req *pb.ApplyUpdateRequest) (*pb.ApplyUpdateResponse, error) {
	err := a.manager.ApplyUpdate(ctx, req.TarballPath, req.Force)
	if err != nil {
		return &pb.ApplyUpdateResponse{
			Success: false,
			Error:   err.Error(),
		}, nil
	}

	return &pb.ApplyUpdateResponse{
		Success:         true,
		RestartRequired: true,
	}, nil
}

// GetUpdateSettings returns the current update configuration
func (a *UpdateServiceAdapter) GetUpdateSettings(ctx context.Context, req *emptypb.Empty) (*pb.UpdateSettings, error) {
	settings, err := update.LoadSettings(a.configDir)
	if err != nil {
		return nil, err
	}

	return &pb.UpdateSettings{
		AutoCheck:          settings.AutoCheck,
		AutoDownload:       settings.AutoDownload,
		AutoApply:          settings.AutoApply,
		IncludePrereleases: settings.IncludePrereleases,
		CheckIntervalHours: int32(settings.CheckIntervalHours),
	}, nil
}

// SetUpdateSettings updates the update configuration
func (a *UpdateServiceAdapter) SetUpdateSettings(ctx context.Context, req *pb.UpdateSettings) (*pb.UpdateSettings, error) {
	settings := update.Settings{
		AutoCheck:          req.AutoCheck,
		AutoDownload:       req.AutoDownload,
		AutoApply:          req.AutoApply,
		IncludePrereleases: req.IncludePrereleases,
		CheckIntervalHours: int(req.CheckIntervalHours),
	}

	if err := update.SaveSettings(a.configDir, settings); err != nil {
		return nil, err
	}

	return req, nil
}

// GetUpdateStatus returns the current update state
func (a *UpdateServiceAdapter) GetUpdateStatus(ctx context.Context, req *emptypb.Empty) (*pb.UpdateStatus, error) {
	status := a.manager.GetStatus()

	pbStatus := &pb.UpdateStatus{
		State:     convertUpdateState(status.State),
		LastCheck: timestamppb.New(status.LastCheck),
		Error:     status.Error,
	}

	if status.AvailableUpdate != nil {
		var downloadSize int64
		assetName := "skeys-" + status.AvailableUpdate.TagName + "-linux-x64.tar.gz"
		for _, asset := range status.AvailableUpdate.Assets {
			if asset.Name == assetName {
				downloadSize = asset.Size
				break
			}
		}

		pbStatus.AvailableUpdate = &pb.UpdateInfo{
			UpdateAvailable: true,
			LatestVersion:   status.AvailableUpdate.TagName,
			ReleaseUrl:      status.AvailableUpdate.HTMLURL,
			ReleaseNotes:    status.AvailableUpdate.Body,
			DownloadSize:    downloadSize,
			PublishedAt:     timestamppb.New(status.AvailableUpdate.PublishedAt),
			Prerelease:      status.AvailableUpdate.Prerelease,
		}
	}

	if status.DownloadProgress != nil {
		pbStatus.DownloadProgress = &pb.DownloadProgress{
			State:           convertDownloadState(status.DownloadProgress.State),
			BytesDownloaded: status.DownloadProgress.BytesDownloaded,
			TotalBytes:      status.DownloadProgress.TotalBytes,
			BytesPerSecond:  status.DownloadProgress.BytesPerSecond,
			Error:           status.DownloadProgress.Error,
			DownloadedPath:  status.DownloadProgress.DownloadedPath,
		}
	}

	return pbStatus, nil
}

func convertUpdateState(state update.State) pb.UpdateState {
	switch state {
	case update.StateIdle:
		return pb.UpdateState_UPDATE_STATE_IDLE
	case update.StateChecking:
		return pb.UpdateState_UPDATE_STATE_CHECKING
	case update.StateUpdateAvailable:
		return pb.UpdateState_UPDATE_STATE_UPDATE_AVAILABLE
	case update.StateDownloading:
		return pb.UpdateState_UPDATE_STATE_DOWNLOADING
	case update.StateReadyToApply:
		return pb.UpdateState_UPDATE_STATE_READY_TO_APPLY
	case update.StateApplying:
		return pb.UpdateState_UPDATE_STATE_APPLYING
	case update.StateError:
		return pb.UpdateState_UPDATE_STATE_ERROR
	default:
		return pb.UpdateState_UPDATE_STATE_UNSPECIFIED
	}
}
