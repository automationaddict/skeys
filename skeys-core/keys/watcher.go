package keys

import (
	"context"
	"time"

	"github.com/fsnotify/fsnotify"
)

// KeysUpdate represents a change notification for keys
type KeysUpdate struct {
	Keys []*Key
	Err  error
}

// Watch monitors the .ssh directory for changes and sends key list updates.
// It sends an initial update immediately, then only when files change.
// The returned channel is closed when the context is cancelled.
func (s *Service) Watch(ctx context.Context) <-chan KeysUpdate {
	updates := make(chan KeysUpdate, 1)

	go func() {
		defer close(updates)

		// Create filesystem watcher
		watcher, err := fsnotify.NewWatcher()
		if err != nil {
			s.log.Err(err, "failed to create file watcher")
			updates <- KeysUpdate{Err: err}
			return
		}
		defer watcher.Close()

		// Watch the .ssh directory
		if err := watcher.Add(s.sshDir); err != nil {
			s.log.Err(err, "failed to watch .ssh directory")
			updates <- KeysUpdate{Err: err}
			return
		}

		s.log.InfoWithFields("watching .ssh directory for changes", map[string]interface{}{
			"path": s.sshDir,
		})

		// Send initial key list
		keys, err := s.List(ctx)
		if err != nil {
			updates <- KeysUpdate{Err: err}
			return
		}
		updates <- KeysUpdate{Keys: keys}

		// Debounce timer to coalesce rapid changes
		var debounceTimer *time.Timer
		debounceDelay := 100 * time.Millisecond

		sendUpdate := func() {
			keys, err := s.List(ctx)
			if err != nil {
				s.log.Err(err, "failed to list keys during watch")
				updates <- KeysUpdate{Err: err}
				return
			}
			s.log.DebugWithFields("sending keys update", map[string]interface{}{
				"count": len(keys),
			})
			updates <- KeysUpdate{Keys: keys}
		}

		for {
			select {
			case <-ctx.Done():
				s.log.Debug("stopping .ssh directory watch")
				return

			case event, ok := <-watcher.Events:
				if !ok {
					return
				}

				// Only care about key-related file changes
				if s.shouldSkipFile(event.Name) {
					continue
				}

				// Log the event at debug level
				s.log.DebugWithFields("file system event", map[string]interface{}{
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
				s.log.Err(err, "file watcher error")
			}
		}
	}()

	return updates
}
