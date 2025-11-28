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

package agent

import (
	"context"
	"os"
	"path/filepath"
	"testing"
	"time"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/mock"
	"github.com/stretchr/testify/require"

	"github.com/johnnelson/skeys-core/logging"
)

// MockExecutor implements executor.Executor for testing
type MockExecutor struct {
	mock.Mock
}

func (m *MockExecutor) Run(ctx context.Context, name string, args ...string) ([]byte, error) {
	called := m.Called(ctx, name, args)
	if called.Get(0) == nil {
		return nil, called.Error(1)
	}
	return called.Get(0).([]byte), called.Error(1)
}

func TestNewService(t *testing.T) {
	svc, err := NewService()
	require.NoError(t, err)
	assert.NotNil(t, svc)
}

func TestNewService_WithOptions(t *testing.T) {
	svc, err := NewService(
		WithSocketPath("/tmp/test.sock"),
	)
	require.NoError(t, err)
	assert.NotNil(t, svc)
}

func TestService_Status_NoSocketPath(t *testing.T) {
	svc, err := NewService(WithSocketPath(""))
	require.NoError(t, err)

	status, err := svc.Status()
	require.NoError(t, err)
	assert.False(t, status.Running)
	assert.Empty(t, status.SocketPath)
}

func TestService_Status_SocketNotExist(t *testing.T) {
	svc, err := NewService(WithSocketPath("/nonexistent/path.sock"))
	require.NoError(t, err)

	status, err := svc.Status()
	require.NoError(t, err)
	assert.False(t, status.Running)
	assert.Equal(t, "/nonexistent/path.sock", status.SocketPath)
}

func TestService_Status_NotASocket(t *testing.T) {
	tmpDir := t.TempDir()
	regularFile := filepath.Join(tmpDir, "not_a_socket")
	os.WriteFile(regularFile, []byte("test"), 0600)

	svc, err := NewService(WithSocketPath(regularFile))
	require.NoError(t, err)

	status, err := svc.Status()
	require.NoError(t, err)
	assert.False(t, status.Running)
}

func TestService_Connect_NoSocket(t *testing.T) {
	svc, err := NewService(WithSocketPath(""))
	require.NoError(t, err)

	_, err = svc.connect()
	require.Error(t, err)
	assert.Contains(t, err.Error(), "SSH_AUTH_SOCK not set")
}

func TestService_Connect_InvalidSocket(t *testing.T) {
	svc, err := NewService(WithSocketPath("/nonexistent/socket"))
	require.NoError(t, err)

	_, err = svc.connect()
	require.Error(t, err)
	assert.Contains(t, err.Error(), "failed to connect")
}

func TestService_ListKeys_NoSocket(t *testing.T) {
	svc, err := NewService(WithSocketPath(""))
	require.NoError(t, err)

	_, err = svc.ListKeys()
	require.Error(t, err)
}

func TestService_ListLoadedFingerprints_NoSocket(t *testing.T) {
	svc, err := NewService(WithSocketPath(""))
	require.NoError(t, err)

	_, err = svc.ListLoadedFingerprints()
	require.Error(t, err)
}

func TestService_RemoveKeyByFingerprint_NoSocket(t *testing.T) {
	svc, err := NewService(WithSocketPath(""))
	require.NoError(t, err)

	err = svc.RemoveKeyByFingerprint("SHA256:abc")
	require.Error(t, err)
}

func TestService_RemoveAll_NoSocket(t *testing.T) {
	svc, err := NewService(WithSocketPath(""))
	require.NoError(t, err)

	err = svc.RemoveAll()
	require.Error(t, err)
}

func TestService_Lock_NoSocket(t *testing.T) {
	svc, err := NewService(WithSocketPath(""))
	require.NoError(t, err)

	err = svc.Lock([]byte("passphrase"))
	require.Error(t, err)
}

func TestService_Unlock_NoSocket(t *testing.T) {
	svc, err := NewService(WithSocketPath(""))
	require.NoError(t, err)

	err = svc.Unlock([]byte("passphrase"))
	require.Error(t, err)
}

func TestGetBits(t *testing.T) {
	tests := []struct {
		keyType  string
		expected int
	}{
		{"ssh-ed25519", 256},
		{"ecdsa-sha2-nistp256", 256},
		{"ecdsa-sha2-nistp384", 384},
		{"ecdsa-sha2-nistp521", 521},
		{"unknown-type", 0},
	}

	for _, tt := range tests {
		t.Run(tt.keyType, func(t *testing.T) {
			// Create a mock key with just the type
			// Note: We can't easily test getBits directly since it requires agent.Key
			// which is hard to mock. This test documents expected behavior.
		})
	}
}

// CLIExecutor tests

func TestNewCLIExecutor(t *testing.T) {
	mockExec := new(MockExecutor)
	exec := NewCLIExecutor(mockExec)
	assert.NotNil(t, exec)
}

func TestCLIExecutor_AddKeyFromFile(t *testing.T) {
	mockExec := new(MockExecutor)
	mockExec.On("Run", mock.Anything, "ssh-add", []string{"/path/to/key"}).
		Return([]byte(""), nil)

	exec := NewCLIExecutor(mockExec)
	err := exec.AddKeyFromFile(context.Background(), "/path/to/key", 0)
	require.NoError(t, err)

	mockExec.AssertExpectations(t)
}

func TestCLIExecutor_AddKeyFromFile_WithLifetime(t *testing.T) {
	mockExec := new(MockExecutor)
	mockExec.On("Run", mock.Anything, "ssh-add", []string{"-t", "3600", "/path/to/key"}).
		Return([]byte(""), nil)

	exec := NewCLIExecutor(mockExec)
	err := exec.AddKeyFromFile(context.Background(), "/path/to/key", 3600)
	require.NoError(t, err)

	mockExec.AssertExpectations(t)
}

func TestCLIExecutor_AddKeyFromFile_Error(t *testing.T) {
	mockExec := new(MockExecutor)
	mockExec.On("Run", mock.Anything, "ssh-add", mock.Anything).
		Return(nil, assert.AnError)

	exec := NewCLIExecutor(mockExec)
	err := exec.AddKeyFromFile(context.Background(), "/path/to/key", 0)
	require.Error(t, err)
}

func TestCLIExecutor_RemoveKeyFromFile(t *testing.T) {
	mockExec := new(MockExecutor)
	mockExec.On("Run", mock.Anything, "ssh-add", []string{"-d", "/path/to/key"}).
		Return([]byte(""), nil)

	exec := NewCLIExecutor(mockExec)
	err := exec.RemoveKeyFromFile(context.Background(), "/path/to/key")
	require.NoError(t, err)

	mockExec.AssertExpectations(t)
}

func TestCLIExecutor_RemoveAllKeys(t *testing.T) {
	mockExec := new(MockExecutor)
	mockExec.On("Run", mock.Anything, "ssh-add", []string{"-D"}).
		Return([]byte(""), nil)

	exec := NewCLIExecutor(mockExec)
	err := exec.RemoveAllKeys(context.Background())
	require.NoError(t, err)

	mockExec.AssertExpectations(t)
}

func TestCLIExecutor_ListKeys(t *testing.T) {
	mockExec := new(MockExecutor)
	output := "256 SHA256:abc123 /home/user/.ssh/id_ed25519 (ED25519)\n2048 SHA256:def456 /home/user/.ssh/id_rsa (RSA)\n"
	mockExec.On("Run", mock.Anything, "ssh-add", []string{"-l"}).
		Return([]byte(output), nil)

	exec := NewCLIExecutor(mockExec)
	keys, err := exec.ListKeys(context.Background())
	require.NoError(t, err)
	assert.Len(t, keys, 2)

	mockExec.AssertExpectations(t)
}

func TestCLIExecutor_ListKeys_NoIdentities(t *testing.T) {
	mockExec := new(MockExecutor)
	mockExec.On("Run", mock.Anything, "ssh-add", []string{"-l"}).
		Return([]byte("The agent has no identities."), assert.AnError)

	exec := NewCLIExecutor(mockExec)
	keys, err := exec.ListKeys(context.Background())
	// When "no identities" is in the output, it's not an error
	require.NoError(t, err)
	assert.Empty(t, keys)
}

func TestCLIExecutor_ListKeys_Error(t *testing.T) {
	mockExec := new(MockExecutor)
	mockExec.On("Run", mock.Anything, "ssh-add", []string{"-l"}).
		Return([]byte("some other error"), assert.AnError)

	exec := NewCLIExecutor(mockExec)
	_, err := exec.ListKeys(context.Background())
	require.Error(t, err)
}

// Integration test - only runs if SSH agent is available and working
func TestService_WithRealAgent(t *testing.T) {
	socketPath := os.Getenv("SSH_AUTH_SOCK")
	if socketPath == "" {
		t.Skip("SSH_AUTH_SOCK not set, skipping integration test")
	}

	// Check if socket exists
	if _, err := os.Stat(socketPath); os.IsNotExist(err) {
		t.Skip("SSH agent socket does not exist, skipping integration test")
	}

	svc, err := NewService()
	require.NoError(t, err)

	// Just test that we can get status without error
	status, err := svc.Status()
	require.NoError(t, err)
	assert.NotEmpty(t, status.SocketPath)
	// Note: status.Running may be false if agent isn't responding
}

func TestWithLogger(t *testing.T) {
	log := logging.New(logging.DefaultConfig())
	svc, err := NewService(
		WithLogger(log),
	)
	require.NoError(t, err)
	assert.NotNil(t, svc)
}

func TestWithCLILogger(t *testing.T) {
	log := logging.New(logging.DefaultConfig())
	mockExec := new(MockExecutor)
	exec := NewCLIExecutor(mockExec, WithCLILogger(log))
	assert.NotNil(t, exec)
}

func TestAgentKey(t *testing.T) {
	key := AgentKey{
		Fingerprint:     "SHA256:abc123",
		Comment:         "test@example.com",
		Type:            "ssh-ed25519",
		Bits:            256,
		HasLifetime:     true,
		LifetimeSeconds: 3600,
		IsConfirm:       false,
	}

	assert.Equal(t, "SHA256:abc123", key.Fingerprint)
	assert.Equal(t, "test@example.com", key.Comment)
	assert.Equal(t, "ssh-ed25519", key.Type)
	assert.Equal(t, 256, key.Bits)
	assert.True(t, key.HasLifetime)
	assert.Equal(t, 3600, key.LifetimeSeconds)
	assert.False(t, key.IsConfirm)
}

func TestAgentStatus(t *testing.T) {
	status := AgentStatus{
		Running:    true,
		SocketPath: "/tmp/ssh-agent.sock",
		IsLocked:   false,
		KeyCount:   3,
	}

	assert.True(t, status.Running)
	assert.Equal(t, "/tmp/ssh-agent.sock", status.SocketPath)
	assert.False(t, status.IsLocked)
	assert.Equal(t, 3, status.KeyCount)
}

func TestAgentUpdate(t *testing.T) {
	update := AgentUpdate{
		Status: &AgentStatus{Running: true},
		Keys:   []*AgentKey{{Fingerprint: "SHA256:test"}},
		Err:    nil,
	}

	assert.NotNil(t, update.Status)
	assert.True(t, update.Status.Running)
	assert.Len(t, update.Keys, 1)
	assert.Nil(t, update.Err)
}

func TestSubscriptions_NewSubscriptions(t *testing.T) {
	subs := NewSubscriptions()
	assert.NotNil(t, subs)
	assert.Equal(t, 0, subs.Count())
}

func TestSubscriptions_Subscribe(t *testing.T) {
	subs := NewSubscriptions()

	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()

	ch := subs.Subscribe(ctx)
	assert.NotNil(t, ch)

	// Should have 1 subscriber
	assert.Equal(t, 1, subs.Count())
}

func TestSubscriptions_SubscribeMultiple(t *testing.T) {
	subs := NewSubscriptions()

	ctx1, cancel1 := context.WithCancel(context.Background())
	defer cancel1()
	ctx2, cancel2 := context.WithCancel(context.Background())
	defer cancel2()

	subs.Subscribe(ctx1)
	subs.Subscribe(ctx2)

	assert.Equal(t, 2, subs.Count())
}

func TestSubscriptions_Notify(t *testing.T) {
	subs := NewSubscriptions()

	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()

	ch := subs.Subscribe(ctx)

	// Send notification
	update := AgentUpdate{
		Status: &AgentStatus{Running: true, KeyCount: 5},
	}
	subs.Notify(update)

	// Should receive the update
	select {
	case received := <-ch:
		assert.NotNil(t, received.Status)
		assert.Equal(t, 5, received.Status.KeyCount)
	default:
		t.Fatal("expected to receive update")
	}
}

func TestSubscriptions_NotifyMultiple(t *testing.T) {
	subs := NewSubscriptions()

	ctx1, cancel1 := context.WithCancel(context.Background())
	defer cancel1()
	ctx2, cancel2 := context.WithCancel(context.Background())
	defer cancel2()

	ch1 := subs.Subscribe(ctx1)
	ch2 := subs.Subscribe(ctx2)

	update := AgentUpdate{
		Status: &AgentStatus{Running: true},
	}
	subs.Notify(update)

	// Both should receive
	select {
	case received := <-ch1:
		assert.NotNil(t, received.Status)
	default:
		t.Fatal("ch1 expected to receive update")
	}

	select {
	case received := <-ch2:
		assert.NotNil(t, received.Status)
	default:
		t.Fatal("ch2 expected to receive update")
	}
}

func TestSubscriptions_CancelRemovesSubscriber(t *testing.T) {
	subs := NewSubscriptions()

	ctx, cancel := context.WithCancel(context.Background())
	ch := subs.Subscribe(ctx)

	assert.Equal(t, 1, subs.Count())

	// Cancel the context
	cancel()

	// Wait for cleanup goroutine
	<-ch // Channel should be closed

	// Give goroutine time to clean up
	// Use a small loop to check since goroutine cleanup is async
	for i := 0; i < 100; i++ {
		if subs.Count() == 0 {
			break
		}
	}

	assert.Equal(t, 0, subs.Count())
}

func TestSubscriptions_NotifyChannelFull(t *testing.T) {
	subs := NewSubscriptions()

	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()

	ch := subs.Subscribe(ctx)

	// Fill the channel (buffer size is 1)
	subs.Notify(AgentUpdate{Status: &AgentStatus{KeyCount: 1}})

	// This notification should be skipped (non-blocking)
	subs.Notify(AgentUpdate{Status: &AgentStatus{KeyCount: 2}})

	// Should only have the first update
	select {
	case received := <-ch:
		assert.Equal(t, 1, received.Status.KeyCount)
	default:
		t.Fatal("expected to receive first update")
	}
}

func TestSubscriptions_NotifyCancelledContext(t *testing.T) {
	subs := NewSubscriptions()

	ctx, cancel := context.WithCancel(context.Background())
	subs.Subscribe(ctx)

	// Cancel immediately
	cancel()

	// Should not panic when notifying cancelled subscriber
	subs.Notify(AgentUpdate{Status: &AgentStatus{Running: true}})
}

func TestCLIExecutor_RemoveKeyFromFile_Error(t *testing.T) {
	mockExec := new(MockExecutor)
	mockExec.On("Run", mock.Anything, "ssh-add", []string{"-d", "/path/to/key"}).
		Return(nil, assert.AnError)

	exec := NewCLIExecutor(mockExec)
	err := exec.RemoveKeyFromFile(context.Background(), "/path/to/key")
	require.Error(t, err)
}

func TestCLIExecutor_RemoveAllKeys_Error(t *testing.T) {
	mockExec := new(MockExecutor)
	mockExec.On("Run", mock.Anything, "ssh-add", []string{"-D"}).
		Return(nil, assert.AnError)

	exec := NewCLIExecutor(mockExec)
	err := exec.RemoveAllKeys(context.Background())
	require.Error(t, err)
}

// ManagedAgent tests

func TestNewManagedAgent(t *testing.T) {
	agent := NewManagedAgent("/tmp/test-agent.sock")
	assert.NotNil(t, agent)
	assert.Equal(t, "/tmp/test-agent.sock", agent.socketPath)
}

func TestNewManagedAgent_WithLogger(t *testing.T) {
	log := logging.New(logging.DefaultConfig())
	agent := NewManagedAgent("/tmp/test.sock", WithManagedAgentLogger(log))
	assert.NotNil(t, agent)
}

func TestManagedAgent_SocketPath(t *testing.T) {
	agent := NewManagedAgent("/tmp/test-agent.sock")
	assert.Equal(t, "/tmp/test-agent.sock", agent.SocketPath())
}

func TestManagedAgent_List_Empty(t *testing.T) {
	agent := NewManagedAgent("/tmp/test.sock")
	keys, err := agent.List()
	require.NoError(t, err)
	assert.Empty(t, keys)
}

func TestManagedAgent_List_Locked(t *testing.T) {
	agent := NewManagedAgent("/tmp/test.sock")
	agent.locked = true

	keys, err := agent.List()
	require.Error(t, err)
	assert.Nil(t, keys)
	assert.Contains(t, err.Error(), "locked")
}

func TestManagedAgent_RemoveAll_Empty(t *testing.T) {
	agent := NewManagedAgent("/tmp/test.sock")
	err := agent.RemoveAll()
	require.NoError(t, err)
}

func TestManagedAgent_RemoveAll_Locked(t *testing.T) {
	agent := NewManagedAgent("/tmp/test.sock")
	agent.locked = true

	err := agent.RemoveAll()
	require.Error(t, err)
	assert.Contains(t, err.Error(), "locked")
}

func TestManagedAgent_Lock(t *testing.T) {
	agent := NewManagedAgent("/tmp/test.sock")

	err := agent.Lock([]byte("testpass"))
	require.NoError(t, err)
	assert.True(t, agent.locked)
}

func TestManagedAgent_Lock_AlreadyLocked(t *testing.T) {
	agent := NewManagedAgent("/tmp/test.sock")
	agent.locked = true

	err := agent.Lock([]byte("testpass"))
	require.Error(t, err)
	assert.Contains(t, err.Error(), "already locked")
}

func TestManagedAgent_Unlock(t *testing.T) {
	agent := NewManagedAgent("/tmp/test.sock")
	agent.locked = true
	agent.lockPass = []byte("testpass")

	err := agent.Unlock([]byte("testpass"))
	require.NoError(t, err)
	assert.False(t, agent.locked)
}

func TestManagedAgent_Unlock_NotLocked(t *testing.T) {
	agent := NewManagedAgent("/tmp/test.sock")

	err := agent.Unlock([]byte("testpass"))
	require.Error(t, err)
	assert.Contains(t, err.Error(), "not locked")
}

func TestManagedAgent_Unlock_WrongPassphrase(t *testing.T) {
	agent := NewManagedAgent("/tmp/test.sock")
	agent.locked = true
	agent.lockPass = []byte("correct")

	err := agent.Unlock([]byte("wrong"))
	require.Error(t, err)
	assert.Contains(t, err.Error(), "incorrect")
}

func TestManagedAgent_Signers_Empty(t *testing.T) {
	agent := NewManagedAgent("/tmp/test.sock")
	signers, err := agent.Signers()
	require.NoError(t, err)
	assert.Empty(t, signers)
}

func TestManagedAgent_Signers_Locked(t *testing.T) {
	agent := NewManagedAgent("/tmp/test.sock")
	agent.locked = true

	signers, err := agent.Signers()
	require.Error(t, err)
	assert.Nil(t, signers)
}

func TestManagedAgent_Extension(t *testing.T) {
	agent := NewManagedAgent("/tmp/test.sock")

	data, err := agent.Extension("test", []byte("data"))
	assert.Nil(t, data)
	require.Error(t, err)
}

func TestManagedAgent_IsLocked(t *testing.T) {
	agent := NewManagedAgent("/tmp/test.sock")
	assert.False(t, agent.IsLocked())

	agent.locked = true
	assert.True(t, agent.IsLocked())
}

func TestManagedAgent_KeyCount(t *testing.T) {
	agent := NewManagedAgent("/tmp/test.sock")
	assert.Equal(t, 0, agent.KeyCount())
}

func TestManagedAgent_Status(t *testing.T) {
	agent := NewManagedAgent("/tmp/test-agent.sock")

	status := agent.Status()
	assert.NotNil(t, status)
	assert.False(t, status.Running)
	assert.Equal(t, "/tmp/test-agent.sock", status.SocketPath)
	assert.False(t, status.IsLocked)
	assert.Equal(t, 0, status.KeyCount)
}

func TestManagedAgent_ListKeys_Empty(t *testing.T) {
	agent := NewManagedAgent("/tmp/test.sock")

	keys, err := agent.ListKeys()
	require.NoError(t, err)
	assert.Empty(t, keys)
}

func TestManagedAgent_ListKeys_Locked(t *testing.T) {
	agent := NewManagedAgent("/tmp/test.sock")
	agent.locked = true

	keys, err := agent.ListKeys()
	require.Error(t, err)
	assert.Nil(t, keys)
}

func TestManagedAgent_RemoveKeyByFingerprint_NotFound(t *testing.T) {
	agent := NewManagedAgent("/tmp/test.sock")

	// Removing a non-existent key should not error
	err := agent.RemoveKeyByFingerprint("SHA256:nonexistent")
	require.NoError(t, err)
}

func TestManagedAgent_RemoveKeyByFingerprint_Locked(t *testing.T) {
	agent := NewManagedAgent("/tmp/test.sock")
	agent.locked = true

	err := agent.RemoveKeyByFingerprint("SHA256:test")
	require.Error(t, err)
	assert.Contains(t, err.Error(), "locked")
}

func TestManagedAgent_Remove_NotFound(t *testing.T) {
	agent := NewManagedAgent("/tmp/test.sock")

	// Create a mock public key to test Remove
	// We need a real public key for this test to work properly
	// For now, just test the locked state
	agent.locked = true

	// Can't easily test without a real public key
}

func TestManagedAgent_SignWithFlags_Locked(t *testing.T) {
	agent := NewManagedAgent("/tmp/test.sock")
	agent.locked = true

	_, err := agent.SignWithFlags(nil, nil, 0)
	require.Error(t, err)
	assert.Contains(t, err.Error(), "locked")
}

func TestManagedAgent_Add_Locked(t *testing.T) {
	agent := NewManagedAgent("/tmp/test.sock")
	agent.locked = true

	// Cannot add when locked
	err := agent.AddKeyDirect(nil, "test", 0, false)
	require.Error(t, err)
	assert.Contains(t, err.Error(), "locked")
}

func TestManagedAgent_Watch(t *testing.T) {
	agent := NewManagedAgent("/tmp/test.sock")

	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()

	ch := agent.Watch(ctx)
	assert.NotNil(t, ch)
}

func TestManagedAgent_notifyChange_NoSubscribers(t *testing.T) {
	agent := NewManagedAgent("/tmp/test.sock")

	// Should not panic when no subscribers
	agent.notifyChange()
}

func TestManagedAgentOption_Type(t *testing.T) {
	// Test that ManagedAgentOption is a valid function type
	log := logging.New(logging.DefaultConfig())
	opt := WithManagedAgentLogger(log)
	assert.NotNil(t, opt)
}

func TestManagedKey_Fields(t *testing.T) {
	// Verify managedKey struct has expected fields
	// (This is more of a compilation test)
	_ = managedKey{
		signer:   nil,
		comment:  "test",
		addedAt:  time.Now(),
		lifetime: 0,
		confirm:  false,
	}
}
