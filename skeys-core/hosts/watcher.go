package hosts

import (
	"context"
	"reflect"
	"time"
)

// KnownHostsUpdate represents a change notification for known_hosts
type KnownHostsUpdate struct {
	Hosts []*KnownHost
	Err   error
}

// AuthorizedKeysUpdate represents a change notification for authorized_keys
type AuthorizedKeysUpdate struct {
	Keys []*AuthorizedKey
	Err  error
}

// Watch monitors the known_hosts file and sends updates when changes are detected.
// It sends an initial update immediately, then polls for changes.
// The returned channel is closed when the context is cancelled.
func (m *KnownHostsManager) Watch(ctx context.Context) <-chan KnownHostsUpdate {
	updates := make(chan KnownHostsUpdate, 1)

	go func() {
		defer close(updates)

		// Poll interval for checking file changes
		pollInterval := 2 * time.Second
		ticker := time.NewTicker(pollInterval)
		defer ticker.Stop()

		// Send initial status
		hosts, err := m.List()
		if err != nil {
			updates <- KnownHostsUpdate{Err: err}
			return
		}
		updates <- KnownHostsUpdate{Hosts: hosts}

		// Track previous state to detect changes
		prevHosts := hosts

		for {
			select {
			case <-ctx.Done():
				return

			case <-ticker.C:
				// Get current state
				currentHosts, err := m.List()
				if err != nil {
					// Don't send error on transient failures, just skip this poll
					continue
				}

				// Only send update if something changed
				if !knownHostsEqual(prevHosts, currentHosts) {
					updates <- KnownHostsUpdate{Hosts: currentHosts}
					prevHosts = currentHosts
				}
			}
		}
	}()

	return updates
}

// Watch monitors the authorized_keys file and sends updates when changes are detected.
// It sends an initial update immediately, then polls for changes.
// The returned channel is closed when the context is cancelled.
func (m *AuthorizedKeysManager) Watch(ctx context.Context) <-chan AuthorizedKeysUpdate {
	updates := make(chan AuthorizedKeysUpdate, 1)

	go func() {
		defer close(updates)

		// Poll interval for checking file changes
		pollInterval := 2 * time.Second
		ticker := time.NewTicker(pollInterval)
		defer ticker.Stop()

		// Send initial status
		keys, err := m.List()
		if err != nil {
			updates <- AuthorizedKeysUpdate{Err: err}
			return
		}
		updates <- AuthorizedKeysUpdate{Keys: keys}

		// Track previous state to detect changes
		prevKeys := keys

		for {
			select {
			case <-ctx.Done():
				return

			case <-ticker.C:
				// Get current state
				currentKeys, err := m.List()
				if err != nil {
					// Don't send error on transient failures, just skip this poll
					continue
				}

				// Only send update if something changed
				if !authorizedKeysEqual(prevKeys, currentKeys) {
					updates <- AuthorizedKeysUpdate{Keys: currentKeys}
					prevKeys = currentKeys
				}
			}
		}
	}()

	return updates
}

// knownHostsEqual compares two KnownHost slices for equality
func knownHostsEqual(a, b []*KnownHost) bool {
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

// authorizedKeysEqual compares two AuthorizedKey slices for equality
func authorizedKeysEqual(a, b []*AuthorizedKey) bool {
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
