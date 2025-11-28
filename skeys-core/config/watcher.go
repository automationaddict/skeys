package config

import (
	"context"
	"reflect"
	"time"
)

// SSHConfigEntriesUpdate represents a change notification for SSH config entries
type SSHConfigEntriesUpdate struct {
	Entries []*SSHConfigEntry
	Err     error
}

// Watch monitors the SSH config file and sends updates when changes are detected.
// It sends an initial update immediately, then polls for changes.
// The returned channel is closed when the context is cancelled.
func (c *ClientConfig) Watch(ctx context.Context) <-chan SSHConfigEntriesUpdate {
	updates := make(chan SSHConfigEntriesUpdate, 1)

	go func() {
		defer close(updates)

		// Poll interval for checking file changes
		pollInterval := 2 * time.Second
		ticker := time.NewTicker(pollInterval)
		defer ticker.Stop()

		// Send initial status
		entries, err := c.ListEntries()
		if err != nil {
			updates <- SSHConfigEntriesUpdate{Err: err}
			return
		}
		updates <- SSHConfigEntriesUpdate{Entries: entries}

		// Track previous state to detect changes
		prevEntries := entries

		for {
			select {
			case <-ctx.Done():
				return

			case <-ticker.C:
				// Reload config from file
				if err := c.load(); err != nil {
					// Don't send error on transient failures, just skip this poll
					continue
				}

				// Get current state
				currentEntries, err := c.ListEntries()
				if err != nil {
					// Don't send error on transient failures, just skip this poll
					continue
				}

				// Only send update if something changed
				if !sshConfigEntriesEqual(prevEntries, currentEntries) {
					updates <- SSHConfigEntriesUpdate{Entries: currentEntries}
					prevEntries = currentEntries
				}
			}
		}
	}()

	return updates
}

// sshConfigEntriesEqual compares two SSHConfigEntry slices for equality
func sshConfigEntriesEqual(a, b []*SSHConfigEntry) bool {
	if len(a) != len(b) {
		return false
	}

	for i := range a {
		if !reflect.DeepEqual(a[i], b[i]) {
			return false
		}
	}

	return true
}
