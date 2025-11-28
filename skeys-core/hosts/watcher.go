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

package hosts

import (
	"context"
	"reflect"
	"sync"
	"time"

	"github.com/johnnelson/skeys-core/broadcast"
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

// knownHostsWatcher manages a single polling loop that broadcasts to all subscribers
type knownHostsWatcher struct {
	manager     *KnownHostsManager
	broadcaster *broadcast.Broadcaster[KnownHostsUpdate]
	cancel      context.CancelFunc
	started     bool
	mu          sync.Mutex
}

func newKnownHostsWatcher(m *KnownHostsManager) *knownHostsWatcher {
	return &knownHostsWatcher{
		manager:     m,
		broadcaster: broadcast.New[KnownHostsUpdate](),
	}
}

func (w *knownHostsWatcher) start() {
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

func (w *knownHostsWatcher) subscribe() chan KnownHostsUpdate {
	w.start()
	return w.broadcaster.Subscribe(true)
}

func (w *knownHostsWatcher) unsubscribe(ch chan KnownHostsUpdate) {
	w.broadcaster.Unsubscribe(ch)
}

func (w *knownHostsWatcher) pollLoop(ctx context.Context) {
	pollInterval := 2 * time.Second
	ticker := time.NewTicker(pollInterval)
	defer ticker.Stop()

	hosts, err := w.manager.List()
	if err != nil {
		w.broadcaster.Broadcast(KnownHostsUpdate{Err: err})
		return
	}
	w.broadcaster.Broadcast(KnownHostsUpdate{Hosts: hosts})

	prevHosts := hosts

	for {
		select {
		case <-ctx.Done():
			return
		case <-ticker.C:
			currentHosts, err := w.manager.List()
			if err != nil {
				continue
			}
			if !knownHostsEqual(prevHosts, currentHosts) {
				w.broadcaster.Broadcast(KnownHostsUpdate{Hosts: currentHosts})
				prevHosts = currentHosts
			}
		}
	}
}

// Watch subscribes to known hosts updates.
// Multiple callers share the same underlying polling loop.
func (m *KnownHostsManager) Watch(ctx context.Context) <-chan KnownHostsUpdate {
	m.ensureWatcher()
	subCh := m.watcher.subscribe()
	outCh := make(chan KnownHostsUpdate, 1)

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

func (m *KnownHostsManager) ensureWatcher() {
	m.watcherMu.Lock()
	defer m.watcherMu.Unlock()
	if m.watcher == nil {
		m.watcher = newKnownHostsWatcher(m)
	}
}

// authorizedKeysWatcher manages a single polling loop that broadcasts to all subscribers
type authorizedKeysWatcher struct {
	manager     *AuthorizedKeysManager
	broadcaster *broadcast.Broadcaster[AuthorizedKeysUpdate]
	cancel      context.CancelFunc
	started     bool
	mu          sync.Mutex
}

func newAuthorizedKeysWatcher(m *AuthorizedKeysManager) *authorizedKeysWatcher {
	return &authorizedKeysWatcher{
		manager:     m,
		broadcaster: broadcast.New[AuthorizedKeysUpdate](),
	}
}

func (w *authorizedKeysWatcher) start() {
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

func (w *authorizedKeysWatcher) subscribe() chan AuthorizedKeysUpdate {
	w.start()
	return w.broadcaster.Subscribe(true)
}

func (w *authorizedKeysWatcher) unsubscribe(ch chan AuthorizedKeysUpdate) {
	w.broadcaster.Unsubscribe(ch)
}

func (w *authorizedKeysWatcher) pollLoop(ctx context.Context) {
	pollInterval := 2 * time.Second
	ticker := time.NewTicker(pollInterval)
	defer ticker.Stop()

	keys, err := w.manager.List()
	if err != nil {
		w.broadcaster.Broadcast(AuthorizedKeysUpdate{Err: err})
		return
	}
	w.broadcaster.Broadcast(AuthorizedKeysUpdate{Keys: keys})

	prevKeys := keys

	for {
		select {
		case <-ctx.Done():
			return
		case <-ticker.C:
			currentKeys, err := w.manager.List()
			if err != nil {
				continue
			}
			if !authorizedKeysEqual(prevKeys, currentKeys) {
				w.broadcaster.Broadcast(AuthorizedKeysUpdate{Keys: currentKeys})
				prevKeys = currentKeys
			}
		}
	}
}

// Watch subscribes to authorized keys updates.
// Multiple callers share the same underlying polling loop.
func (m *AuthorizedKeysManager) Watch(ctx context.Context) <-chan AuthorizedKeysUpdate {
	m.ensureWatcher()
	subCh := m.watcher.subscribe()
	outCh := make(chan AuthorizedKeysUpdate, 1)

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

func (m *AuthorizedKeysManager) ensureWatcher() {
	m.watcherMu.Lock()
	defer m.watcherMu.Unlock()
	if m.watcher == nil {
		m.watcher = newAuthorizedKeysWatcher(m)
	}
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
