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

// Package storage provides persistent storage for skeys application metadata.
package storage

import (
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"
	"sync"

	"github.com/automationaddict/skeys-core/logging"
)

// KeyMetadata stores metadata associated with an SSH key
type KeyMetadata struct {
	// KeyPath is the absolute path to the private key file (used as the key identifier)
	KeyPath string `json:"key_path"`
	// VerifiedService is the service (e.g., "github.com", "gitlab.com") that was used
	// to verify this key when it was added to the agent
	VerifiedService string `json:"verified_service,omitempty"`
	// VerifiedHost is the host used for verification
	VerifiedHost string `json:"verified_host,omitempty"`
	// VerifiedPort is the port used for verification
	VerifiedPort int `json:"verified_port,omitempty"`
	// VerifiedUser is the user used for verification
	VerifiedUser string `json:"verified_user,omitempty"`
}

// RemoteServer stores configuration for a remote SSH server
type RemoteServer struct {
	// ID is a unique identifier for this remote
	ID string `json:"id"`
	// Name is a human-friendly name for the remote
	Name string `json:"name"`
	// Host is the hostname or IP address
	Host string `json:"host"`
	// Port is the SSH port (default 22)
	Port int `json:"port"`
	// User is the SSH username
	User string `json:"user"`
	// IdentityFile is the path to the private key to use (optional)
	IdentityFile string `json:"identity_file,omitempty"`
	// SSHConfigAlias is an alias from ~/.ssh/config to use (optional)
	SSHConfigAlias string `json:"ssh_config_alias,omitempty"`
	// CreatedAt is when this remote was added
	CreatedAt int64 `json:"created_at"`
	// LastConnectedAt is when this remote was last connected to
	LastConnectedAt int64 `json:"last_connected_at,omitempty"`
}

// Store handles persistent storage of skeys metadata
type Store struct {
	dataDir  string
	metaFile string
	mu       sync.RWMutex
	data     *storeData
	log      *logging.Logger
}

// storeData is the on-disk format
type storeData struct {
	Version       int                      `json:"version"`
	KeyMetadata   map[string]*KeyMetadata  `json:"key_metadata"`   // keyed by key path
	RemoteServers map[string]*RemoteServer `json:"remote_servers"` // keyed by ID
}

// StoreOption configures the store
type StoreOption func(*Store)

// WithDataDir sets a custom data directory
func WithDataDir(dir string) StoreOption {
	return func(s *Store) {
		s.dataDir = dir
	}
}

// WithLogger sets a custom logger
func WithLogger(log *logging.Logger) StoreOption {
	return func(s *Store) {
		s.log = log
	}
}

// NewStore creates a new persistent store
func NewStore(opts ...StoreOption) (*Store, error) {
	// Default to XDG data directory
	homeDir, err := os.UserHomeDir()
	if err != nil {
		return nil, fmt.Errorf("failed to get home directory: %w", err)
	}

	s := &Store{
		dataDir: filepath.Join(homeDir, ".local", "share", "skeys"),
		log:     logging.Nop(),
	}

	for _, opt := range opts {
		opt(s)
	}

	s.metaFile = filepath.Join(s.dataDir, "metadata.json")

	// Ensure data directory exists
	if err := os.MkdirAll(s.dataDir, 0700); err != nil {
		return nil, fmt.Errorf("failed to create data directory: %w", err)
	}

	// Load existing data or create new
	if err := s.load(); err != nil {
		s.log.WarnWithFields("failed to load existing data, starting fresh", map[string]interface{}{
			"error": err.Error(),
		})
		s.data = &storeData{
			Version:       1,
			KeyMetadata:   make(map[string]*KeyMetadata),
			RemoteServers: make(map[string]*RemoteServer),
		}
	}

	s.log.InfoWithFields("storage initialized", map[string]interface{}{
		"data_dir": s.dataDir,
	})

	return s, nil
}

// load reads the store data from disk
func (s *Store) load() error {
	data, err := os.ReadFile(s.metaFile)
	if err != nil {
		if os.IsNotExist(err) {
			s.data = &storeData{
				Version:       1,
				KeyMetadata:   make(map[string]*KeyMetadata),
				RemoteServers: make(map[string]*RemoteServer),
			}
			return nil
		}
		return fmt.Errorf("failed to read metadata file: %w", err)
	}

	s.data = &storeData{}
	if err := json.Unmarshal(data, s.data); err != nil {
		return fmt.Errorf("failed to parse metadata file: %w", err)
	}

	if s.data.KeyMetadata == nil {
		s.data.KeyMetadata = make(map[string]*KeyMetadata)
	}
	if s.data.RemoteServers == nil {
		s.data.RemoteServers = make(map[string]*RemoteServer)
	}

	return nil
}

// save writes the store data to disk
func (s *Store) save() error {
	data, err := json.MarshalIndent(s.data, "", "  ")
	if err != nil {
		return fmt.Errorf("failed to marshal metadata: %w", err)
	}

	// Write to temp file first, then rename for atomicity
	tmpFile := s.metaFile + ".tmp"
	if err := os.WriteFile(tmpFile, data, 0600); err != nil {
		return fmt.Errorf("failed to write metadata file: %w", err)
	}

	if err := os.Rename(tmpFile, s.metaFile); err != nil {
		os.Remove(tmpFile) // Clean up on failure
		return fmt.Errorf("failed to rename metadata file: %w", err)
	}

	return nil
}

// GetKeyMetadata returns metadata for a key, or nil if not found
func (s *Store) GetKeyMetadata(keyPath string) *KeyMetadata {
	s.mu.RLock()
	defer s.mu.RUnlock()

	meta := s.data.KeyMetadata[keyPath]
	if meta == nil {
		return nil
	}

	// Return a copy to prevent external modification
	return &KeyMetadata{
		KeyPath:         meta.KeyPath,
		VerifiedService: meta.VerifiedService,
		VerifiedHost:    meta.VerifiedHost,
		VerifiedPort:    meta.VerifiedPort,
		VerifiedUser:    meta.VerifiedUser,
	}
}

// SetKeyMetadata stores metadata for a key
func (s *Store) SetKeyMetadata(meta *KeyMetadata) error {
	if meta == nil || meta.KeyPath == "" {
		return fmt.Errorf("key path is required")
	}

	s.mu.Lock()
	defer s.mu.Unlock()

	s.data.KeyMetadata[meta.KeyPath] = &KeyMetadata{
		KeyPath:         meta.KeyPath,
		VerifiedService: meta.VerifiedService,
		VerifiedHost:    meta.VerifiedHost,
		VerifiedPort:    meta.VerifiedPort,
		VerifiedUser:    meta.VerifiedUser,
	}

	if err := s.save(); err != nil {
		s.log.ErrWithFields(err, "failed to save metadata", map[string]interface{}{
			"key_path": meta.KeyPath,
		})
		return err
	}

	s.log.DebugWithFields("saved key metadata", map[string]interface{}{
		"key_path":         meta.KeyPath,
		"verified_service": meta.VerifiedService,
	})

	return nil
}

// DeleteKeyMetadata removes metadata for a key
func (s *Store) DeleteKeyMetadata(keyPath string) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	delete(s.data.KeyMetadata, keyPath)

	if err := s.save(); err != nil {
		s.log.ErrWithFields(err, "failed to save metadata after delete", map[string]interface{}{
			"key_path": keyPath,
		})
		return err
	}

	return nil
}

// ListKeyMetadata returns all stored key metadata
func (s *Store) ListKeyMetadata() []*KeyMetadata {
	s.mu.RLock()
	defer s.mu.RUnlock()

	result := make([]*KeyMetadata, 0, len(s.data.KeyMetadata))
	for _, meta := range s.data.KeyMetadata {
		result = append(result, &KeyMetadata{
			KeyPath:         meta.KeyPath,
			VerifiedService: meta.VerifiedService,
			VerifiedHost:    meta.VerifiedHost,
			VerifiedPort:    meta.VerifiedPort,
			VerifiedUser:    meta.VerifiedUser,
		})
	}

	return result
}

// GetRemoteServer returns a remote server by ID, or nil if not found
func (s *Store) GetRemoteServer(id string) *RemoteServer {
	s.mu.RLock()
	defer s.mu.RUnlock()

	remote := s.data.RemoteServers[id]
	if remote == nil {
		return nil
	}

	// Return a copy to prevent external modification
	return &RemoteServer{
		ID:              remote.ID,
		Name:            remote.Name,
		Host:            remote.Host,
		Port:            remote.Port,
		User:            remote.User,
		IdentityFile:    remote.IdentityFile,
		SSHConfigAlias:  remote.SSHConfigAlias,
		CreatedAt:       remote.CreatedAt,
		LastConnectedAt: remote.LastConnectedAt,
	}
}

// AddRemoteServer stores a new remote server configuration
func (s *Store) AddRemoteServer(remote *RemoteServer) error {
	if remote == nil || remote.ID == "" {
		return fmt.Errorf("remote ID is required")
	}

	s.mu.Lock()
	defer s.mu.Unlock()

	s.data.RemoteServers[remote.ID] = &RemoteServer{
		ID:              remote.ID,
		Name:            remote.Name,
		Host:            remote.Host,
		Port:            remote.Port,
		User:            remote.User,
		IdentityFile:    remote.IdentityFile,
		SSHConfigAlias:  remote.SSHConfigAlias,
		CreatedAt:       remote.CreatedAt,
		LastConnectedAt: remote.LastConnectedAt,
	}

	if err := s.save(); err != nil {
		s.log.ErrWithFields(err, "failed to save remote server", map[string]interface{}{
			"id":   remote.ID,
			"name": remote.Name,
		})
		return err
	}

	s.log.DebugWithFields("saved remote server", map[string]interface{}{
		"id":   remote.ID,
		"name": remote.Name,
		"host": remote.Host,
	})

	return nil
}

// UpdateRemoteServer updates an existing remote server configuration
func (s *Store) UpdateRemoteServer(remote *RemoteServer) error {
	if remote == nil || remote.ID == "" {
		return fmt.Errorf("remote ID is required")
	}

	s.mu.Lock()
	defer s.mu.Unlock()

	if _, exists := s.data.RemoteServers[remote.ID]; !exists {
		return fmt.Errorf("remote server not found: %s", remote.ID)
	}

	s.data.RemoteServers[remote.ID] = &RemoteServer{
		ID:              remote.ID,
		Name:            remote.Name,
		Host:            remote.Host,
		Port:            remote.Port,
		User:            remote.User,
		IdentityFile:    remote.IdentityFile,
		SSHConfigAlias:  remote.SSHConfigAlias,
		CreatedAt:       remote.CreatedAt,
		LastConnectedAt: remote.LastConnectedAt,
	}

	if err := s.save(); err != nil {
		s.log.ErrWithFields(err, "failed to update remote server", map[string]interface{}{
			"id": remote.ID,
		})
		return err
	}

	return nil
}

// DeleteRemoteServer removes a remote server by ID
func (s *Store) DeleteRemoteServer(id string) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	delete(s.data.RemoteServers, id)

	if err := s.save(); err != nil {
		s.log.ErrWithFields(err, "failed to save after deleting remote server", map[string]interface{}{
			"id": id,
		})
		return err
	}

	return nil
}

// ListRemoteServers returns all stored remote servers
func (s *Store) ListRemoteServers() []*RemoteServer {
	s.mu.RLock()
	defer s.mu.RUnlock()

	result := make([]*RemoteServer, 0, len(s.data.RemoteServers))
	for _, remote := range s.data.RemoteServers {
		result = append(result, &RemoteServer{
			ID:              remote.ID,
			Name:            remote.Name,
			Host:            remote.Host,
			Port:            remote.Port,
			User:            remote.User,
			IdentityFile:    remote.IdentityFile,
			SSHConfigAlias:  remote.SSHConfigAlias,
			CreatedAt:       remote.CreatedAt,
			LastConnectedAt: remote.LastConnectedAt,
		})
	}

	return result
}

// UpdateRemoteServerLastConnected updates the last connected timestamp
func (s *Store) UpdateRemoteServerLastConnected(id string, timestamp int64) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	remote, exists := s.data.RemoteServers[id]
	if !exists {
		return fmt.Errorf("remote server not found: %s", id)
	}

	remote.LastConnectedAt = timestamp

	if err := s.save(); err != nil {
		s.log.ErrWithFields(err, "failed to update last connected timestamp", map[string]interface{}{
			"id": id,
		})
		return err
	}

	return nil
}
