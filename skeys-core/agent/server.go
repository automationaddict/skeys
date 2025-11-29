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

// Package agent provides SSH agent management functionality.
package agent

import (
	"context"
	"crypto"
	"fmt"
	"io"
	"net"
	"os"
	"sync"
	"time"

	"github.com/automationaddict/skeys-core/logging"
	"golang.org/x/crypto/ssh"
	"golang.org/x/crypto/ssh/agent"
)

// ManagedAgent is an SSH agent server that we fully control.
// Unlike system agents (like GNOME Keyring), this supports all operations
// including individual key removal.
type ManagedAgent struct {
	mu            sync.RWMutex
	keys          map[string]*managedKey // fingerprint -> key
	locked        bool
	lockPass      []byte
	socketPath    string
	listener      net.Listener
	log           *logging.Logger
	stopChan      chan struct{}
	wg            sync.WaitGroup
	subscriptions *Subscriptions
}

// managedKey holds a private key and its metadata
type managedKey struct {
	signer   ssh.Signer
	comment  string
	addedAt  time.Time
	lifetime time.Duration // 0 means no expiry
	confirm  bool
}

// ManagedAgentOption is a functional option
type ManagedAgentOption func(*ManagedAgent)

// WithManagedAgentLogger sets a logger
func WithManagedAgentLogger(log *logging.Logger) ManagedAgentOption {
	return func(m *ManagedAgent) {
		m.log = log
	}
}

// NewManagedAgent creates a new managed SSH agent
func NewManagedAgent(socketPath string, opts ...ManagedAgentOption) *ManagedAgent {
	m := &ManagedAgent{
		keys:          make(map[string]*managedKey),
		socketPath:    socketPath,
		log:           logging.Nop(),
		stopChan:      make(chan struct{}),
		subscriptions: NewSubscriptions(),
	}
	for _, opt := range opts {
		opt(m)
	}
	return m
}

// Start starts the agent server listening on the socket
func (m *ManagedAgent) Start() error {
	// Remove existing socket if present
	if err := os.RemoveAll(m.socketPath); err != nil {
		return fmt.Errorf("failed to remove existing socket: %w", err)
	}

	listener, err := net.Listen("unix", m.socketPath)
	if err != nil {
		return fmt.Errorf("failed to listen on socket: %w", err)
	}

	// Set socket permissions (only owner can connect)
	if err := os.Chmod(m.socketPath, 0600); err != nil {
		listener.Close()
		return fmt.Errorf("failed to set socket permissions: %w", err)
	}

	m.listener = listener
	m.log.InfoWithFields("managed agent started", map[string]interface{}{
		"socket_path": m.socketPath,
	})

	// Start accepting connections
	m.wg.Add(1)
	go m.acceptLoop()

	// Start key expiry goroutine
	m.wg.Add(1)
	go m.expiryLoop()

	return nil
}

// Stop stops the agent server
func (m *ManagedAgent) Stop() error {
	close(m.stopChan)
	if m.listener != nil {
		m.listener.Close()
	}
	m.wg.Wait()

	// Clean up socket
	os.RemoveAll(m.socketPath)
	m.log.Info("managed agent stopped")
	return nil
}

// SocketPath returns the socket path for this agent
func (m *ManagedAgent) SocketPath() string {
	return m.socketPath
}

// Subscriptions returns the subscriptions manager for this agent.
// This can be used to subscribe to agent state changes.
func (m *ManagedAgent) Subscriptions() *Subscriptions {
	return m.subscriptions
}

func (m *ManagedAgent) acceptLoop() {
	defer m.wg.Done()

	for {
		conn, err := m.listener.Accept()
		if err != nil {
			select {
			case <-m.stopChan:
				return
			default:
				m.log.Err(err, "failed to accept connection")
				continue
			}
		}

		m.wg.Add(1)
		go func() {
			defer m.wg.Done()
			m.handleConnection(conn)
		}()
	}
}

func (m *ManagedAgent) handleConnection(conn net.Conn) {
	defer conn.Close()

	// Serve the agent protocol
	if err := agent.ServeAgent(m, conn); err != nil && err != io.EOF {
		m.log.Err(err, "agent serve error")
	}
}

func (m *ManagedAgent) expiryLoop() {
	defer m.wg.Done()
	ticker := time.NewTicker(10 * time.Second)
	defer ticker.Stop()

	for {
		select {
		case <-m.stopChan:
			return
		case <-ticker.C:
			m.expireKeys()
		}
	}
}

func (m *ManagedAgent) expireKeys() {
	m.mu.Lock()
	defer m.mu.Unlock()

	now := time.Now()
	var expired []string

	for fp, key := range m.keys {
		if key.lifetime > 0 && now.Sub(key.addedAt) > key.lifetime {
			expired = append(expired, fp)
		}
	}

	for _, fp := range expired {
		delete(m.keys, fp)
		m.log.InfoWithFields("key expired", map[string]interface{}{
			"fingerprint": fp,
		})
	}

	// Notify watchers if any keys expired
	if len(expired) > 0 {
		go m.notifyChange()
	}
}

// Implement agent.Agent interface

// List returns the identities known to the agent
func (m *ManagedAgent) List() ([]*agent.Key, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	if m.locked {
		return nil, fmt.Errorf("agent is locked")
	}

	var keys []*agent.Key
	for _, k := range m.keys {
		pubKey := k.signer.PublicKey()
		keys = append(keys, &agent.Key{
			Format:  pubKey.Type(),
			Blob:    pubKey.Marshal(),
			Comment: k.comment,
		})
	}
	return keys, nil
}

// Sign has the agent sign the data using a protocol 2 key as identified by the contents of blob.
func (m *ManagedAgent) Sign(key ssh.PublicKey, data []byte) (*ssh.Signature, error) {
	return m.SignWithFlags(key, data, 0)
}

// SignWithFlags is like Sign but with signature flags
func (m *ManagedAgent) SignWithFlags(key ssh.PublicKey, data []byte, flags agent.SignatureFlags) (*ssh.Signature, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	if m.locked {
		return nil, fmt.Errorf("agent is locked")
	}

	fp := ssh.FingerprintSHA256(key)
	k, ok := m.keys[fp]
	if !ok {
		return nil, fmt.Errorf("key not found")
	}

	// Handle signing flags for algorithm selection
	var algo string
	switch flags {
	case agent.SignatureFlagRsaSha256:
		algo = ssh.KeyAlgoRSASHA256
	case agent.SignatureFlagRsaSha512:
		algo = ssh.KeyAlgoRSASHA512
	default:
		algo = "" // Use default algorithm
	}

	if algo != "" {
		if algoSigner, ok := k.signer.(ssh.AlgorithmSigner); ok {
			return algoSigner.SignWithAlgorithm(nil, data, algo)
		}
	}

	return k.signer.Sign(nil, data)
}

// Add adds a private key to the agent
func (m *ManagedAgent) Add(key agent.AddedKey) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	if m.locked {
		return fmt.Errorf("agent is locked")
	}

	signer, err := ssh.NewSignerFromKey(key.PrivateKey)
	if err != nil {
		return fmt.Errorf("failed to create signer: %w", err)
	}

	fp := ssh.FingerprintSHA256(signer.PublicKey())
	m.keys[fp] = &managedKey{
		signer:   signer,
		comment:  key.Comment,
		addedAt:  time.Now(),
		lifetime: time.Duration(key.LifetimeSecs) * time.Second,
		confirm:  key.ConfirmBeforeUse,
	}

	m.log.InfoWithFields("key added to managed agent", map[string]interface{}{
		"fingerprint":   fp,
		"comment":       key.Comment,
		"lifetime_secs": key.LifetimeSecs,
	})

	// Notify watchers (must be done after releasing lock)
	go m.notifyChange()

	return nil
}

// Remove removes the identity with the given public key
func (m *ManagedAgent) Remove(key ssh.PublicKey) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	if m.locked {
		return fmt.Errorf("agent is locked")
	}

	fp := ssh.FingerprintSHA256(key)
	if _, ok := m.keys[fp]; !ok {
		return fmt.Errorf("key not found")
	}

	delete(m.keys, fp)
	m.log.InfoWithFields("key removed from managed agent", map[string]interface{}{
		"fingerprint": fp,
	})

	// Notify watchers
	go m.notifyChange()

	return nil
}

// RemoveAll removes all identities
func (m *ManagedAgent) RemoveAll() error {
	m.mu.Lock()
	defer m.mu.Unlock()

	if m.locked {
		return fmt.Errorf("agent is locked")
	}

	m.keys = make(map[string]*managedKey)
	m.log.Info("all keys removed from managed agent")

	// Notify watchers
	go m.notifyChange()

	return nil
}

// Lock locks the agent with a passphrase
func (m *ManagedAgent) Lock(passphrase []byte) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	if m.locked {
		return fmt.Errorf("agent is already locked")
	}

	m.locked = true
	m.lockPass = make([]byte, len(passphrase))
	copy(m.lockPass, passphrase)
	m.log.Info("managed agent locked")

	// Notify watchers
	go m.notifyChange()

	return nil
}

// Unlock unlocks the agent
func (m *ManagedAgent) Unlock(passphrase []byte) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	if !m.locked {
		return fmt.Errorf("agent is not locked")
	}

	if string(passphrase) != string(m.lockPass) {
		return fmt.Errorf("incorrect passphrase")
	}

	m.locked = false
	m.lockPass = nil
	m.log.Info("managed agent unlocked")

	// Notify watchers
	go m.notifyChange()

	return nil
}

// Signers returns a list of signers (required for agent.ExtendedAgent)
func (m *ManagedAgent) Signers() ([]ssh.Signer, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	if m.locked {
		return nil, fmt.Errorf("agent is locked")
	}

	var signers []ssh.Signer
	for _, k := range m.keys {
		signers = append(signers, k.signer)
	}
	return signers, nil
}

// Extension processes custom agent extensions (required for some SSH operations)
func (m *ManagedAgent) Extension(extensionType string, contents []byte) ([]byte, error) {
	return nil, agent.ErrExtensionUnsupported
}

// Helper methods for the Service to interact with managed agent

// AddKeyDirect adds a key directly to the managed agent (bypassing socket)
func (m *ManagedAgent) AddKeyDirect(privateKey crypto.PrivateKey, comment string, lifetimeSecs uint32, confirm bool) error {
	return m.Add(agent.AddedKey{
		PrivateKey:       privateKey,
		Comment:          comment,
		LifetimeSecs:     lifetimeSecs,
		ConfirmBeforeUse: confirm,
	})
}

// RemoveKeyByFingerprint removes a key by its fingerprint
func (m *ManagedAgent) RemoveKeyByFingerprint(fingerprint string) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	if m.locked {
		return fmt.Errorf("agent is locked")
	}

	if _, ok := m.keys[fingerprint]; !ok {
		// Not found is not an error - key may have expired
		return nil
	}

	delete(m.keys, fingerprint)
	m.log.InfoWithFields("key removed from managed agent by fingerprint", map[string]interface{}{
		"fingerprint": fingerprint,
	})

	// Notify watchers
	go m.notifyChange()

	return nil
}

// ListKeys returns all keys as AgentKey structs
func (m *ManagedAgent) ListKeys() ([]*AgentKey, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	if m.locked {
		return nil, fmt.Errorf("agent is locked")
	}

	var result []*AgentKey
	now := time.Now()
	for fp, k := range m.keys {
		remaining := 0
		if k.lifetime > 0 {
			remaining = int(k.lifetime.Seconds()) - int(now.Sub(k.addedAt).Seconds())
			if remaining < 0 {
				remaining = 0
			}
		}
		result = append(result, &AgentKey{
			Fingerprint:     fp,
			Comment:         k.comment,
			Type:            k.signer.PublicKey().Type(),
			Bits:            0, // Would need to inspect key type
			HasLifetime:     k.lifetime > 0,
			LifetimeSeconds: remaining,
			IsConfirm:       k.confirm,
		})
	}
	return result, nil
}

// Status returns the managed agent status
func (m *ManagedAgent) Status() *AgentStatus {
	m.mu.RLock()
	defer m.mu.RUnlock()

	return &AgentStatus{
		Running:    m.listener != nil,
		SocketPath: m.socketPath,
		IsLocked:   m.locked,
		KeyCount:   len(m.keys),
	}
}

// IsLocked returns whether the agent is locked
func (m *ManagedAgent) IsLocked() bool {
	m.mu.RLock()
	defer m.mu.RUnlock()
	return m.locked
}

// KeyCount returns the number of keys
func (m *ManagedAgent) KeyCount() int {
	m.mu.RLock()
	defer m.mu.RUnlock()
	return len(m.keys)
}

// Watch returns a channel that receives updates whenever the agent state changes.
// Sends an initial update immediately, then on every add/remove/lock/unlock.
// The channel is closed when the context is cancelled.
func (m *ManagedAgent) Watch(ctx context.Context) <-chan AgentUpdate {
	ch := m.subscriptions.Subscribe(ctx)

	// Send initial state
	go func() {
		status := m.Status()
		keys, _ := m.ListKeys()
		select {
		case <-ctx.Done():
		default:
			m.subscriptions.Notify(AgentUpdate{
				Status: status,
				Keys:   keys,
			})
		}
	}()

	return ch
}

// notifyChange sends an update to all watchers
func (m *ManagedAgent) notifyChange() {
	if m.subscriptions.Count() == 0 {
		return
	}

	status := m.Status()
	keys, _ := m.ListKeys()
	m.subscriptions.Notify(AgentUpdate{
		Status: status,
		Keys:   keys,
	})
}
