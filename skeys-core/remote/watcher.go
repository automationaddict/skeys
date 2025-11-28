package remote

import (
	"context"
	"reflect"
	"sync"
	"time"

	"github.com/johnnelson/skeys-core/broadcast"
)

// ConnectionsUpdate contains a connections update or error
type ConnectionsUpdate struct {
	Connections []*Connection
	Err         error
}

// connectionsWatcher manages a single polling loop that broadcasts to all subscribers
type connectionsWatcher struct {
	pool        *ConnectionPool
	broadcaster *broadcast.Broadcaster[ConnectionsUpdate]
	cancel      context.CancelFunc
	started     bool
	mu          sync.Mutex
}

func newConnectionsWatcher(p *ConnectionPool) *connectionsWatcher {
	return &connectionsWatcher{
		pool:        p,
		broadcaster: broadcast.New[ConnectionsUpdate](),
	}
}

func (w *connectionsWatcher) start() {
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

func (w *connectionsWatcher) subscribe() chan ConnectionsUpdate {
	w.start()
	return w.broadcaster.Subscribe(true)
}

func (w *connectionsWatcher) unsubscribe(ch chan ConnectionsUpdate) {
	w.broadcaster.Unsubscribe(ch)
}

func (w *connectionsWatcher) pollLoop(ctx context.Context) {
	pollInterval := 2 * time.Second
	ticker := time.NewTicker(pollInterval)
	defer ticker.Stop()

	// Send initial state
	connections := w.pool.List()
	w.broadcaster.Broadcast(ConnectionsUpdate{Connections: connections})

	prevConnections := connections

	for {
		select {
		case <-ctx.Done():
			return
		case <-ticker.C:
			currentConnections := w.pool.List()
			if !connectionsEqual(prevConnections, currentConnections) {
				w.broadcaster.Broadcast(ConnectionsUpdate{Connections: currentConnections})
				prevConnections = currentConnections
			}
		}
	}
}

// Watch subscribes to connection updates.
// Multiple callers share the same underlying polling loop.
func (p *ConnectionPool) Watch(ctx context.Context) <-chan ConnectionsUpdate {
	p.ensureWatcher()
	subCh := p.watcher.subscribe()
	outCh := make(chan ConnectionsUpdate, 1)

	go func() {
		defer close(outCh)
		defer p.watcher.unsubscribe(subCh)

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

func (p *ConnectionPool) ensureWatcher() {
	p.watcherMu.Lock()
	defer p.watcherMu.Unlock()
	if p.watcher == nil {
		p.watcher = newConnectionsWatcher(p)
	}
}

// connectionsEqual compares two Connection slices for equality
func connectionsEqual(a, b []*Connection) bool {
	if len(a) != len(b) {
		return false
	}
	// Build maps for comparison
	aMap := make(map[string]*Connection)
	for _, c := range a {
		aMap[c.ID] = c
	}
	for _, c := range b {
		if ac, ok := aMap[c.ID]; !ok {
			return true
		} else if !reflect.DeepEqual(ac.Host, c.Host) ||
			!reflect.DeepEqual(ac.Port, c.Port) ||
			!reflect.DeepEqual(ac.User, c.User) ||
			!reflect.DeepEqual(ac.ServerVersion, c.ServerVersion) {
			return false
		}
	}
	return true
}
