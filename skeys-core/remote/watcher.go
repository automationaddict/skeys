package remote

import (
	"context"
	"reflect"
	"time"
)

// ConnectionsUpdate contains a connections update or error
type ConnectionsUpdate struct {
	Connections []*Connection
	Err         error
}

// Watch returns a channel that emits connection updates when the list changes.
// It polls the connection pool every 2 seconds and sends updates when connections change.
func (p *ConnectionPool) Watch(ctx context.Context) <-chan ConnectionsUpdate {
	ch := make(chan ConnectionsUpdate)

	go func() {
		defer close(ch)

		var lastConnections []*Connection

		// Helper to compare connection lists
		connectionsChanged := func(a, b []*Connection) bool {
			if len(a) != len(b) {
				return true
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
					return true
				}
			}
			return false
		}

		// Send initial state
		connections := p.List()
		lastConnections = connections
		select {
		case ch <- ConnectionsUpdate{Connections: connections}:
		case <-ctx.Done():
			return
		}

		// Poll for changes every 2 seconds
		ticker := time.NewTicker(2 * time.Second)
		defer ticker.Stop()

		for {
			select {
			case <-ctx.Done():
				return
			case <-ticker.C:
				connections := p.List()
				if connectionsChanged(lastConnections, connections) {
					lastConnections = connections
					select {
					case ch <- ConnectionsUpdate{Connections: connections}:
					case <-ctx.Done():
						return
					}
				}
			}
		}
	}()

	return ch
}
