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
	"reflect"
	"sync"
	"time"

	"github.com/automationaddict/skeys-core/broadcast"
)

// SSHConfigEntriesUpdate represents a change notification for SSH config entries
type SSHConfigEntriesUpdate struct {
	Entries []*SSHConfigEntry
	Err     error
}

// configWatcher manages a single polling loop that broadcasts to all subscribers
type configWatcher struct {
	config      *ClientConfig
	broadcaster *broadcast.Broadcaster[SSHConfigEntriesUpdate]
	cancel      context.CancelFunc
	started     bool
	mu          sync.Mutex
}

// newConfigWatcher creates a new watcher for the given config
func newConfigWatcher(c *ClientConfig) *configWatcher {
	return &configWatcher{
		config:      c,
		broadcaster: broadcast.New[SSHConfigEntriesUpdate](),
	}
}

// start begins the polling loop if not already started
func (w *configWatcher) start() {
	w.mu.Lock()
	defer w.mu.Unlock()

	if w.started {
		return
	}
	w.started = true

	ctx, cancel := context.WithCancel(context.Background())
	w.cancel = cancel

	go w.pollLoop(ctx)
}

// Stop terminates the polling loop
func (w *configWatcher) Stop() {
	w.mu.Lock()
	defer w.mu.Unlock()

	if w.cancel != nil {
		w.cancel()
		w.cancel = nil
	}
	w.started = false
	w.broadcaster.Close()
}

// subscribe returns a channel that receives updates
func (w *configWatcher) subscribe() chan SSHConfigEntriesUpdate {
	w.start() // Ensure watcher is running
	return w.broadcaster.Subscribe(true)
}

// unsubscribe removes a subscription
func (w *configWatcher) unsubscribe(ch chan SSHConfigEntriesUpdate) {
	w.broadcaster.Unsubscribe(ch)
}

// pollLoop runs the single polling loop that broadcasts to all subscribers
func (w *configWatcher) pollLoop(ctx context.Context) {
	pollInterval := 2 * time.Second
	ticker := time.NewTicker(pollInterval)
	defer ticker.Stop()

	// Send initial status
	entries, err := w.config.ListEntries()
	if err != nil {
		w.broadcaster.Broadcast(SSHConfigEntriesUpdate{Err: err})
		return
	}
	w.broadcaster.Broadcast(SSHConfigEntriesUpdate{Entries: entries})

	// Track previous state to detect changes
	prevEntries := entries

	for {
		select {
		case <-ctx.Done():
			return

		case <-ticker.C:
			// Reload config from file
			if err := w.config.load(); err != nil {
				// Don't send error on transient failures, just skip this poll
				continue
			}

			// Get current state
			currentEntries, err := w.config.ListEntries()
			if err != nil {
				// Don't send error on transient failures, just skip this poll
				continue
			}

			// Only broadcast if something changed
			if !sshConfigEntriesEqual(prevEntries, currentEntries) {
				w.broadcaster.Broadcast(SSHConfigEntriesUpdate{Entries: currentEntries})
				prevEntries = currentEntries
			}
		}
	}
}

// Watch subscribes to config entry updates.
// Multiple callers share the same underlying polling loop.
// The returned channel receives updates until the context is cancelled.
func (c *ClientConfig) Watch(ctx context.Context) <-chan SSHConfigEntriesUpdate {
	// Ensure watcher exists
	c.ensureWatcher()

	// Subscribe to broadcasts (bidirectional channel for unsubscribe)
	subCh := c.watcher.subscribe()

	// Create output channel that respects context cancellation
	outCh := make(chan SSHConfigEntriesUpdate, 1)

	go func() {
		defer close(outCh)
		defer c.watcher.unsubscribe(subCh)

		for {
			select {
			case <-ctx.Done():
				return
			case update, ok := <-subCh:
				if !ok {
					return
				}
				select {
				case outCh <- update:
				case <-ctx.Done():
					return
				}
			}
		}
	}()

	return outCh
}

// ensureWatcher creates the watcher if it doesn't exist
func (c *ClientConfig) ensureWatcher() {
	c.watcherMu.Lock()
	defer c.watcherMu.Unlock()

	if c.watcher == nil {
		c.watcher = newConfigWatcher(c)
	}
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
