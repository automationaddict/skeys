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

package keys

import (
	"context"
	"reflect"
	"sync"
	"time"

	"github.com/fsnotify/fsnotify"
	"github.com/johnnelson/skeys-core/broadcast"
)

// KeysUpdate represents a change notification for keys
type KeysUpdate struct {
	Keys []*Key
	Err  error
}

// keysWatcher manages a single file watcher that broadcasts to all subscribers
type keysWatcher struct {
	service     *Service
	broadcaster *broadcast.Broadcaster[KeysUpdate]
	cancel      context.CancelFunc
	started     bool
	mu          sync.Mutex
}

func newKeysWatcher(s *Service) *keysWatcher {
	return &keysWatcher{
		service:     s,
		broadcaster: broadcast.New[KeysUpdate](),
	}
}

func (w *keysWatcher) start() {
	w.mu.Lock()
	defer w.mu.Unlock()

	if w.started {
		return
	}
	w.started = true

	ctx, cancel := context.WithCancel(context.Background())
	w.cancel = cancel

	go w.watchLoop(ctx)
}

func (w *keysWatcher) subscribe() chan KeysUpdate {
	w.start()
	return w.broadcaster.Subscribe(true)
}

func (w *keysWatcher) unsubscribe(ch chan KeysUpdate) {
	w.broadcaster.Unsubscribe(ch)
}

func (w *keysWatcher) watchLoop(ctx context.Context) {
	// Create filesystem watcher
	watcher, err := fsnotify.NewWatcher()
	if err != nil {
		w.service.log.Err(err, "failed to create file watcher")
		w.broadcaster.Broadcast(KeysUpdate{Err: err})
		return
	}
	defer watcher.Close()

	// Watch the .ssh directory
	if err := watcher.Add(w.service.sshDir); err != nil {
		w.service.log.Err(err, "failed to watch .ssh directory")
		w.broadcaster.Broadcast(KeysUpdate{Err: err})
		return
	}

	w.service.log.InfoWithFields("watching .ssh directory for changes", map[string]interface{}{
		"path": w.service.sshDir,
	})

	// Send initial key list
	keys, err := w.service.List(ctx)
	if err != nil {
		w.broadcaster.Broadcast(KeysUpdate{Err: err})
		return
	}
	w.broadcaster.Broadcast(KeysUpdate{Keys: keys})

	prevKeys := keys

	// Debounce timer to coalesce rapid changes
	var debounceTimer *time.Timer
	debounceDelay := 100 * time.Millisecond

	sendUpdate := func() {
		currentKeys, err := w.service.List(ctx)
		if err != nil {
			w.service.log.Err(err, "failed to list keys during watch")
			w.broadcaster.Broadcast(KeysUpdate{Err: err})
			return
		}
		// Only broadcast if keys actually changed
		if !keysEqual(prevKeys, currentKeys) {
			w.service.log.DebugWithFields("sending keys update", map[string]interface{}{
				"count": len(currentKeys),
			})
			w.broadcaster.Broadcast(KeysUpdate{Keys: currentKeys})
			prevKeys = currentKeys
		}
	}

	for {
		select {
		case <-ctx.Done():
			w.service.log.Debug("stopping .ssh directory watch")
			return

		case event, ok := <-watcher.Events:
			if !ok {
				return
			}

			// Only care about key-related file changes
			if w.service.shouldSkipFile(event.Name) {
				continue
			}

			// Log the event at debug level
			w.service.log.DebugWithFields("file system event", map[string]interface{}{
				"name": event.Name,
				"op":   event.Op.String(),
			})

			// Debounce: reset timer on each event
			if debounceTimer != nil {
				debounceTimer.Stop()
			}
			debounceTimer = time.AfterFunc(debounceDelay, sendUpdate)

		case err, ok := <-watcher.Errors:
			if !ok {
				return
			}
			w.service.log.Err(err, "file watcher error")
		}
	}
}

// Watch subscribes to key updates.
// Multiple callers share the same underlying file watcher.
func (s *Service) Watch(ctx context.Context) <-chan KeysUpdate {
	s.ensureWatcher()
	subCh := s.watcher.subscribe()
	outCh := make(chan KeysUpdate, 1)

	go func() {
		defer close(outCh)
		defer s.watcher.unsubscribe(subCh)

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

func (s *Service) ensureWatcher() {
	s.watcherMu.Lock()
	defer s.watcherMu.Unlock()
	if s.watcher == nil {
		s.watcher = newKeysWatcher(s)
	}
}

// keysEqual compares two Key slices for equality
func keysEqual(a, b []*Key) bool {
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
