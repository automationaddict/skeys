package agent

import (
	"context"
	"sync"
)

// AgentUpdate represents a change notification for the agent
type AgentUpdate struct {
	Status *AgentStatus
	Keys   []*AgentKey
	Err    error
}

// subscriber represents a single watcher subscription
type subscriber struct {
	ch     chan AgentUpdate
	ctx    context.Context
	cancel context.CancelFunc
}

// Subscriptions manages watchers for agent changes
type Subscriptions struct {
	mu          sync.RWMutex
	subscribers map[*subscriber]struct{}
}

// NewSubscriptions creates a new subscription manager
func NewSubscriptions() *Subscriptions {
	return &Subscriptions{
		subscribers: make(map[*subscriber]struct{}),
	}
}

// Subscribe creates a new subscription that receives agent updates.
// The returned channel is closed when the context is cancelled.
func (s *Subscriptions) Subscribe(ctx context.Context) <-chan AgentUpdate {
	ch := make(chan AgentUpdate, 1)

	subCtx, cancel := context.WithCancel(ctx)
	sub := &subscriber{
		ch:     ch,
		ctx:    subCtx,
		cancel: cancel,
	}

	s.mu.Lock()
	s.subscribers[sub] = struct{}{}
	s.mu.Unlock()

	// Clean up when context is done
	go func() {
		<-subCtx.Done()
		s.mu.Lock()
		delete(s.subscribers, sub)
		s.mu.Unlock()
		close(ch)
	}()

	return ch
}

// Notify sends an update to all subscribers
func (s *Subscriptions) Notify(update AgentUpdate) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	for sub := range s.subscribers {
		select {
		case sub.ch <- update:
		case <-sub.ctx.Done():
			// Subscriber cancelled, skip
		default:
			// Channel full, skip (non-blocking)
		}
	}
}

// Count returns the number of active subscribers
func (s *Subscriptions) Count() int {
	s.mu.RLock()
	defer s.mu.RUnlock()
	return len(s.subscribers)
}
