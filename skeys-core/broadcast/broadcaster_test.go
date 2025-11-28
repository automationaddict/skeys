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

package broadcast

import (
	"sync"
	"testing"
	"time"

	"github.com/stretchr/testify/assert"
)

func TestNew(t *testing.T) {
	b := New[string]()
	assert.NotNil(t, b)
	assert.Equal(t, 0, b.SubscriberCount())
}

func TestBroadcaster_Subscribe(t *testing.T) {
	b := New[string]()

	ch := b.Subscribe(false)
	assert.NotNil(t, ch)
	assert.Equal(t, 1, b.SubscriberCount())

	// Subscribe again
	ch2 := b.Subscribe(false)
	assert.NotNil(t, ch2)
	assert.Equal(t, 2, b.SubscriberCount())
}

func TestBroadcaster_Unsubscribe(t *testing.T) {
	b := New[string]()

	ch := b.Subscribe(false)
	assert.Equal(t, 1, b.SubscriberCount())

	b.Unsubscribe(ch)
	assert.Equal(t, 0, b.SubscriberCount())

	// Channel should be closed
	_, ok := <-ch
	assert.False(t, ok)
}

func TestBroadcaster_Unsubscribe_Idempotent(t *testing.T) {
	b := New[string]()

	ch := b.Subscribe(false)
	b.Unsubscribe(ch)
	b.Unsubscribe(ch) // Should not panic

	assert.Equal(t, 0, b.SubscriberCount())
}

func TestBroadcaster_Broadcast(t *testing.T) {
	b := New[string]()

	ch := b.Subscribe(false)

	b.Broadcast("hello")

	select {
	case msg := <-ch:
		assert.Equal(t, "hello", msg)
	case <-time.After(time.Second):
		t.Fatal("timeout waiting for broadcast")
	}
}

func TestBroadcaster_Broadcast_MultipleSubscribers(t *testing.T) {
	b := New[int]()

	ch1 := b.Subscribe(false)
	ch2 := b.Subscribe(false)
	ch3 := b.Subscribe(false)

	b.Broadcast(42)

	// All subscribers should receive the message
	for i, ch := range []chan int{ch1, ch2, ch3} {
		select {
		case msg := <-ch:
			assert.Equal(t, 42, msg, "subscriber %d", i)
		case <-time.After(time.Second):
			t.Fatalf("timeout waiting for broadcast to subscriber %d", i)
		}
	}
}

func TestBroadcaster_Subscribe_WithReplay(t *testing.T) {
	b := New[string]()

	// Broadcast before any subscribers
	b.Broadcast("first")

	// Subscribe with replay
	ch := b.Subscribe(true)

	select {
	case msg := <-ch:
		assert.Equal(t, "first", msg)
	case <-time.After(time.Second):
		t.Fatal("timeout waiting for replay")
	}
}

func TestBroadcaster_Subscribe_WithReplay_NoLastValue(t *testing.T) {
	b := New[string]()

	// Subscribe with replay but no broadcast yet
	ch := b.Subscribe(true)

	// Should not receive anything immediately
	select {
	case <-ch:
		t.Fatal("should not receive anything")
	case <-time.After(100 * time.Millisecond):
		// Expected
	}
}

func TestBroadcaster_Subscribe_WithoutReplay(t *testing.T) {
	b := New[string]()

	// Broadcast before subscriber
	b.Broadcast("first")

	// Subscribe without replay
	ch := b.Subscribe(false)

	// Should not receive the previous broadcast
	select {
	case <-ch:
		t.Fatal("should not receive previous broadcast")
	case <-time.After(100 * time.Millisecond):
		// Expected
	}
}

func TestBroadcaster_Broadcast_SlowSubscriber(t *testing.T) {
	b := New[int]()

	ch := b.Subscribe(false)

	// Fill the buffer
	b.Broadcast(1)

	// This should not block (non-blocking send)
	done := make(chan struct{})
	go func() {
		b.Broadcast(2) // Channel buffer is full, should drop
		b.Broadcast(3)
		close(done)
	}()

	select {
	case <-done:
		// Success - broadcast didn't block
	case <-time.After(time.Second):
		t.Fatal("broadcast blocked on slow subscriber")
	}

	// Subscriber should receive at least one message
	select {
	case msg := <-ch:
		assert.Equal(t, 1, msg)
	case <-time.After(time.Second):
		t.Fatal("timeout")
	}
}

func TestBroadcaster_Close(t *testing.T) {
	b := New[string]()

	ch1 := b.Subscribe(false)
	ch2 := b.Subscribe(false)
	assert.Equal(t, 2, b.SubscriberCount())

	b.Close()

	assert.Equal(t, 0, b.SubscriberCount())

	// All channels should be closed
	_, ok1 := <-ch1
	_, ok2 := <-ch2
	assert.False(t, ok1)
	assert.False(t, ok2)
}

func TestBroadcaster_Close_Empty(t *testing.T) {
	b := New[string]()
	b.Close() // Should not panic
	assert.Equal(t, 0, b.SubscriberCount())
}

func TestBroadcaster_SubscriberCount(t *testing.T) {
	b := New[int]()

	assert.Equal(t, 0, b.SubscriberCount())

	ch1 := b.Subscribe(false)
	assert.Equal(t, 1, b.SubscriberCount())

	ch2 := b.Subscribe(false)
	assert.Equal(t, 2, b.SubscriberCount())

	b.Unsubscribe(ch1)
	assert.Equal(t, 1, b.SubscriberCount())

	b.Unsubscribe(ch2)
	assert.Equal(t, 0, b.SubscriberCount())
}

func TestBroadcaster_Concurrent(t *testing.T) {
	b := New[int]()

	var wg sync.WaitGroup
	numSubscribers := 10
	numMessages := 100

	// Start subscribers
	channels := make([]chan int, numSubscribers)
	for i := 0; i < numSubscribers; i++ {
		channels[i] = b.Subscribe(false)
	}

	// Start receivers
	received := make([]int, numSubscribers)
	for i := 0; i < numSubscribers; i++ {
		wg.Add(1)
		go func(idx int, ch chan int) {
			defer wg.Done()
			for range ch {
				received[idx]++
			}
		}(i, channels[i])
	}

	// Broadcast messages
	for i := 0; i < numMessages; i++ {
		b.Broadcast(i)
	}

	// Close all subscriptions
	for _, ch := range channels {
		b.Unsubscribe(ch)
	}

	wg.Wait()

	// Each subscriber should have received some messages
	// (may not be all due to non-blocking sends)
	for i, count := range received {
		assert.Greater(t, count, 0, "subscriber %d received no messages", i)
	}
}

// Test with different types
func TestBroadcaster_IntType(t *testing.T) {
	b := New[int]()
	ch := b.Subscribe(false)
	b.Broadcast(42)

	msg := <-ch
	assert.Equal(t, 42, msg)
}

func TestBroadcaster_StructType(t *testing.T) {
	type Event struct {
		Name  string
		Value int
	}

	b := New[Event]()
	ch := b.Subscribe(false)
	b.Broadcast(Event{Name: "test", Value: 123})

	msg := <-ch
	assert.Equal(t, "test", msg.Name)
	assert.Equal(t, 123, msg.Value)
}

func TestBroadcaster_PointerType(t *testing.T) {
	type Data struct {
		Value int
	}

	b := New[*Data]()
	ch := b.Subscribe(false)
	data := &Data{Value: 42}
	b.Broadcast(data)

	msg := <-ch
	assert.Equal(t, 42, msg.Value)
	assert.Same(t, data, msg) // Should be the same pointer
}

func TestBroadcaster_ReplayUpdatesLastValue(t *testing.T) {
	b := New[string]()

	b.Broadcast("first")
	b.Broadcast("second")
	b.Broadcast("third")

	// Subscribe with replay should get last value
	ch := b.Subscribe(true)

	msg := <-ch
	assert.Equal(t, "third", msg)
}

func TestBroadcaster_SubscribeAfterClose(t *testing.T) {
	b := New[string]()
	b.Close()

	// Subscribing after close should still work (new subscribers map)
	ch := b.Subscribe(false)
	assert.NotNil(t, ch)
	assert.Equal(t, 1, b.SubscriberCount())
}
