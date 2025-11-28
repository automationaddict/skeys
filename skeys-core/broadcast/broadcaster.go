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

// Package broadcast provides a generic hub/broadcaster pattern for fan-out of updates.
// One producer broadcasts to multiple subscribers, each receiving updates via channels.
package broadcast

import (
	"sync"
)

// Broadcaster fans out updates from a single producer to multiple subscribers.
// It is generic over the update type T.
type Broadcaster[T any] struct {
	mu          sync.RWMutex
	subscribers map[chan T]struct{}
	lastValue   *T // Cache last value for new subscribers
}

// New creates a new Broadcaster.
func New[T any]() *Broadcaster[T] {
	return &Broadcaster[T]{
		subscribers: make(map[chan T]struct{}),
	}
}

// Subscribe creates a new subscription channel.
// The returned channel receives all broadcasts.
// Call Unsubscribe when done to prevent leaks.
// If replay is true, the last broadcast value (if any) is immediately sent.
func (b *Broadcaster[T]) Subscribe(replay bool) chan T {
	ch := make(chan T, 1) // Buffered to prevent blocking

	b.mu.Lock()
	b.subscribers[ch] = struct{}{}
	lastVal := b.lastValue
	b.mu.Unlock()

	// Send last value if replay requested and we have one
	if replay && lastVal != nil {
		select {
		case ch <- *lastVal:
		default:
			// Channel full, skip replay
		}
	}

	return ch
}

// Unsubscribe removes a subscription and closes the channel.
func (b *Broadcaster[T]) Unsubscribe(ch chan T) {
	b.mu.Lock()
	defer b.mu.Unlock()

	if _, ok := b.subscribers[ch]; ok {
		delete(b.subscribers, ch)
		close(ch)
	}
}

// Broadcast sends a value to all subscribers (non-blocking).
// Slow subscribers will miss updates (their channel buffer is size 1).
func (b *Broadcaster[T]) Broadcast(value T) {
	b.mu.Lock()
	defer b.mu.Unlock()

	// Cache for replay
	b.lastValue = &value

	for ch := range b.subscribers {
		select {
		case ch <- value:
		default:
			// Subscriber channel full, drop update for slow consumer
		}
	}
}

// SubscriberCount returns the current number of subscribers.
func (b *Broadcaster[T]) SubscriberCount() int {
	b.mu.RLock()
	defer b.mu.RUnlock()
	return len(b.subscribers)
}

// Close unsubscribes and closes all subscriber channels.
func (b *Broadcaster[T]) Close() {
	b.mu.Lock()
	defer b.mu.Unlock()

	for ch := range b.subscribers {
		close(ch)
	}
	b.subscribers = make(map[chan T]struct{})
}
