// Package storage provides persistent storage for skeys application metadata.
package storage

import (
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"
	"sync"

	"github.com/johnnelson/skeys-core/logging"
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
	Version     int                     `json:"version"`
	KeyMetadata map[string]*KeyMetadata `json:"key_metadata"` // keyed by key path
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
			Version:     1,
			KeyMetadata: make(map[string]*KeyMetadata),
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
				Version:     1,
				KeyMetadata: make(map[string]*KeyMetadata),
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
