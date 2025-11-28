package system

import (
	"context"
	"reflect"
	"time"
)

// SSHStatusUpdate represents a change notification for SSH status
type SSHStatusUpdate struct {
	Status *SSHStatus
	Err    error
}

// Watch monitors SSH system status and sends updates when changes are detected.
// It sends an initial update immediately, then polls for changes.
// The returned channel is closed when the context is cancelled.
func (m *SystemManager) Watch(ctx context.Context) <-chan SSHStatusUpdate {
	updates := make(chan SSHStatusUpdate, 1)

	go func() {
		defer close(updates)

		// Poll interval for checking service status
		pollInterval := 2 * time.Second
		ticker := time.NewTicker(pollInterval)
		defer ticker.Stop()

		// Send initial status
		status, err := m.GetSSHStatus(ctx)
		if err != nil {
			updates <- SSHStatusUpdate{Err: err}
			return
		}
		updates <- SSHStatusUpdate{Status: status}

		// Track previous status to detect changes
		prevStatus := status

		for {
			select {
			case <-ctx.Done():
				return

			case <-ticker.C:
				// Get current status
				currentStatus, err := m.GetSSHStatus(ctx)
				if err != nil {
					// Don't send error on transient failures, just skip this poll
					continue
				}

				// Only send update if something changed
				if !m.statusEqual(prevStatus, currentStatus) {
					updates <- SSHStatusUpdate{Status: currentStatus}
					prevStatus = currentStatus
				}
			}
		}
	}()

	return updates
}

// statusEqual compares two SSHStatus structs for equality
func (m *SystemManager) statusEqual(a, b *SSHStatus) bool {
	if a == nil || b == nil {
		return a == b
	}

	// Compare server service status (most likely to change)
	if a.Server.Service.State != b.Server.Service.State {
		return false
	}
	if a.Server.Service.Enabled != b.Server.Service.Enabled {
		return false
	}
	if a.Server.Service.PID != b.Server.Service.PID {
		return false
	}
	if a.Server.Service.ActiveState != b.Server.Service.ActiveState {
		return false
	}
	if a.Server.Service.SubState != b.Server.Service.SubState {
		return false
	}

	// Compare installation status
	if a.Client.Installed != b.Client.Installed {
		return false
	}
	if a.Server.Installed != b.Server.Installed {
		return false
	}

	// Compare config existence/readability
	if !reflect.DeepEqual(a.Client.SystemConfig, b.Client.SystemConfig) {
		return false
	}
	if !reflect.DeepEqual(a.Client.UserConfig, b.Client.UserConfig) {
		return false
	}
	if !reflect.DeepEqual(a.Server.Config, b.Server.Config) {
		return false
	}

	return true
}
