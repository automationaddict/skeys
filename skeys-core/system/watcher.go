package system

import (
	"context"
	"reflect"
	"sync"
	"time"

	"github.com/johnnelson/skeys-core/broadcast"
)

// SSHStatusUpdate represents a change notification for SSH status
type SSHStatusUpdate struct {
	Status *SSHStatus
	Err    error
}

// systemWatcher manages a single polling loop that broadcasts to all subscribers
type systemWatcher struct {
	manager     *SystemManager
	broadcaster *broadcast.Broadcaster[SSHStatusUpdate]
	cancel      context.CancelFunc
	started     bool
	mu          sync.Mutex
}

func newSystemWatcher(m *SystemManager) *systemWatcher {
	return &systemWatcher{
		manager:     m,
		broadcaster: broadcast.New[SSHStatusUpdate](),
	}
}

func (w *systemWatcher) start() {
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

func (w *systemWatcher) subscribe() chan SSHStatusUpdate {
	w.start()
	return w.broadcaster.Subscribe(true)
}

func (w *systemWatcher) unsubscribe(ch chan SSHStatusUpdate) {
	w.broadcaster.Unsubscribe(ch)
}

func (w *systemWatcher) pollLoop(ctx context.Context) {
	pollInterval := 2 * time.Second
	ticker := time.NewTicker(pollInterval)
	defer ticker.Stop()

	// Send initial status
	status, err := w.manager.GetSSHStatus(ctx)
	if err != nil {
		w.broadcaster.Broadcast(SSHStatusUpdate{Err: err})
		return
	}
	w.broadcaster.Broadcast(SSHStatusUpdate{Status: status})

	prevStatus := status

	for {
		select {
		case <-ctx.Done():
			return
		case <-ticker.C:
			currentStatus, err := w.manager.GetSSHStatus(ctx)
			if err != nil {
				// Don't send error on transient failures, just skip this poll
				continue
			}
			if !statusEqual(prevStatus, currentStatus) {
				w.broadcaster.Broadcast(SSHStatusUpdate{Status: currentStatus})
				prevStatus = currentStatus
			}
		}
	}
}

// Watch subscribes to SSH status updates.
// Multiple callers share the same underlying polling loop.
func (m *SystemManager) Watch(ctx context.Context) <-chan SSHStatusUpdate {
	m.ensureWatcher()
	subCh := m.watcher.subscribe()
	outCh := make(chan SSHStatusUpdate, 1)

	go func() {
		defer close(outCh)
		defer m.watcher.unsubscribe(subCh)

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

func (m *SystemManager) ensureWatcher() {
	m.watcherMu.Lock()
	defer m.watcherMu.Unlock()
	if m.watcher == nil {
		m.watcher = newSystemWatcher(m)
	}
}

// statusEqual compares two SSHStatus structs for equality
func statusEqual(a, b *SSHStatus) bool {
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
