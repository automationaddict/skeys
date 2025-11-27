// Package keys provides SSH key management functionality.
// This is the core library for managing SSH keys - it can be used
// independently of any transport layer (gRPC, REST, CLI, etc.)
package keys

import (
	"context"
	"fmt"
	"os"
	"path/filepath"
	"strings"
	"time"

	"github.com/johnnelson/skeys-core/logging"
)

// KeyType represents the algorithm used for an SSH key
type KeyType string

const (
	KeyTypeRSA       KeyType = "rsa"
	KeyTypeED25519   KeyType = "ed25519"
	KeyTypeECDSA     KeyType = "ecdsa"
	KeyTypeED25519SK KeyType = "ed25519-sk"
	KeyTypeECDSASK   KeyType = "ecdsa-sk"
	KeyTypeUnknown   KeyType = "unknown"
)

// Key represents an SSH key pair
type Key struct {
	ID                string
	Name              string
	PrivateKeyPath    string
	PublicKeyPath     string
	Type              KeyType
	Bits              int
	Comment           string
	FingerprintSHA256 string
	FingerprintMD5    string
	PublicKey         string
	HasPassphrase     bool
	InAgent           bool
	CreatedAt         time.Time
	ModifiedAt        time.Time
}

// GenerateOptions contains options for generating a new SSH key
type GenerateOptions struct {
	Name       string
	Type       KeyType
	Bits       int    // For RSA: 2048, 4096
	Comment    string
	Passphrase string
	path       string // internal: full path to write the key
}

// AgentChecker is the interface for checking if keys are loaded in the SSH agent
// This allows the keys service to query the agent without tight coupling
type AgentChecker interface {
	// ListLoadedFingerprints returns fingerprints of all keys loaded in the agent
	ListLoadedFingerprints() ([]string, error)
	// RemoveKeyByFingerprint removes a key from the agent by its fingerprint
	RemoveKeyByFingerprint(fingerprint string) error
}

// Service provides SSH key management operations.
// It is designed to be reusable across different transports.
type Service struct {
	sshDir       string
	agentChecker AgentChecker
	keyGenerator *KeyGenerator
	log          *logging.Logger
}

// ServiceOption is a functional option for configuring the Service
type ServiceOption func(*Service)

// WithSSHDir sets a custom SSH directory
func WithSSHDir(dir string) ServiceOption {
	return func(s *Service) {
		s.sshDir = dir
	}
}

// WithAgentChecker sets an agent checker for querying loaded keys
func WithAgentChecker(checker AgentChecker) ServiceOption {
	return func(s *Service) {
		s.agentChecker = checker
	}
}

// WithLogger sets a custom logger
func WithLogger(log *logging.Logger) ServiceOption {
	return func(s *Service) {
		s.log = log
	}
}

// NewService creates a new key management service
func NewService(opts ...ServiceOption) (*Service, error) {
	homeDir, err := os.UserHomeDir()
	if err != nil {
		return nil, fmt.Errorf("failed to get home directory: %w", err)
	}

	s := &Service{
		sshDir:       filepath.Join(homeDir, ".ssh"),
		keyGenerator: NewKeyGenerator(),
		log:          logging.Nop(),
	}

	for _, opt := range opts {
		opt(s)
	}

	// Ensure .ssh directory exists with correct permissions
	if err := os.MkdirAll(s.sshDir, 0700); err != nil {
		s.log.Err(err, "failed to create .ssh directory")
		return nil, fmt.Errorf("failed to create .ssh directory: %w", err)
	}

	s.log.InfoWithFields("keys service initialized", map[string]interface{}{
		"ssh_dir": s.sshDir,
	})

	return s, nil
}

// List returns all SSH keys in the .ssh directory
func (s *Service) List(ctx context.Context) ([]*Key, error) {
	s.log.Debug("listing SSH keys")

	entries, err := os.ReadDir(s.sshDir)
	if err != nil {
		s.log.Err(err, "failed to read .ssh directory")
		return nil, fmt.Errorf("failed to read .ssh directory: %w", err)
	}

	var keys []*Key
	seen := make(map[string]bool)

	for _, entry := range entries {
		if entry.IsDir() {
			continue
		}

		name := entry.Name()

		// Skip non-key files
		if s.shouldSkipFile(name) {
			s.log.Debugf("skipping file: %s", name)
			continue
		}

		// Check if this is a private key by looking for matching .pub file
		pubKeyPath := filepath.Join(s.sshDir, name+".pub")
		if _, err := os.Stat(pubKeyPath); os.IsNotExist(err) {
			continue
		}

		if seen[name] {
			continue
		}
		seen[name] = true

		key, err := s.load(ctx, name)
		if err != nil {
			s.log.ErrWithFields(err, "failed to load key, skipping", map[string]interface{}{
				"key_name": name,
			})
			continue
		}

		keys = append(keys, key)
	}

	s.log.DebugWithFields("listed SSH keys", map[string]interface{}{
		"count": len(keys),
	})

	return keys, nil
}

// Get returns a specific key by name
func (s *Service) Get(ctx context.Context, name string) (*Key, error) {
	s.log.DebugWithFields("getting key", map[string]interface{}{
		"key_name": name,
	})
	key, err := s.load(ctx, name)
	if err != nil {
		s.log.ErrWithFields(err, "failed to get key", map[string]interface{}{
			"key_name": name,
		})
		return nil, err
	}
	return key, nil
}

// Generate creates a new SSH key pair
func (s *Service) Generate(ctx context.Context, opts GenerateOptions) (*Key, error) {
	s.log.InfoWithFields("generating new SSH key", map[string]interface{}{
		"key_name": opts.Name,
		"key_type": opts.Type,
		"bits":     opts.Bits,
		"comment":  opts.Comment,
	})

	if err := s.validateKeyName(opts.Name); err != nil {
		s.log.ErrWithFields(err, "invalid key name", map[string]interface{}{
			"key_name": opts.Name,
		})
		return nil, err
	}

	keyPath := filepath.Join(s.sshDir, opts.Name)

	// Check if key already exists
	if _, err := os.Stat(keyPath); err == nil {
		s.log.WarnWithFields("key already exists", map[string]interface{}{
			"key_name": opts.Name,
			"key_path": keyPath,
		})
		return nil, fmt.Errorf("key already exists: %s", opts.Name)
	}

	// Determine key type
	keyType := opts.Type
	if keyType == "" {
		keyType = KeyTypeED25519 // Default to ED25519
	}

	// Set up options for native key generation
	opts.path = keyPath
	if opts.Type == "" {
		opts.Type = keyType
	}

	s.log.DebugWithFields("generating key natively", map[string]interface{}{
		"key_type": keyType,
		"key_path": keyPath,
	})

	// Generate key using native Go implementation
	if err := s.keyGenerator.GenerateKeyPair(opts); err != nil {
		s.log.Err(err, "key generation failed")
		return nil, fmt.Errorf("key generation failed: %w", err)
	}

	s.log.InfoWithFields("SSH key generated successfully", map[string]interface{}{
		"key_name": opts.Name,
	})

	// Load and return the generated key
	return s.load(ctx, opts.Name)
}

// Delete removes an SSH key pair
func (s *Service) Delete(ctx context.Context, name string) error {
	s.log.InfoWithFields("deleting SSH key", map[string]interface{}{
		"key_name": name,
	})

	// Handle both full paths and key names
	var privatePath string
	if filepath.IsAbs(name) {
		privatePath = name
	} else {
		if err := s.validateKeyName(name); err != nil {
			s.log.ErrWithFields(err, "invalid key name", map[string]interface{}{
				"key_name": name,
			})
			return err
		}
		privatePath = filepath.Join(s.sshDir, name)
	}
	publicPath := privatePath + ".pub"

	// Get fingerprint before deleting so we can remove from agent
	fingerprint, err := s.Fingerprint(ctx, name, "sha256")
	if err != nil {
		s.log.WarnWithFields("could not get fingerprint before deletion", map[string]interface{}{
			"key_name": name,
			"error":    err.Error(),
		})
		// Continue with deletion even if we can't get fingerprint
	}

	// Remove from SSH agent if loaded (do this before deleting files)
	if fingerprint != "" && s.agentChecker != nil {
		if err := s.agentChecker.RemoveKeyByFingerprint(fingerprint); err != nil {
			s.log.WarnWithFields("could not remove key from agent", map[string]interface{}{
				"key_name":    name,
				"fingerprint": fingerprint,
				"error":       err.Error(),
			})
			// Continue with file deletion even if agent removal fails
		} else {
			s.log.InfoWithFields("removed key from SSH agent", map[string]interface{}{
				"key_name":    name,
				"fingerprint": fingerprint,
			})
		}
	}

	// Remove private key
	if err := os.Remove(privatePath); err != nil && !os.IsNotExist(err) {
		s.log.ErrWithFields(err, "failed to delete private key", map[string]interface{}{
			"key_path": privatePath,
		})
		return fmt.Errorf("failed to delete private key: %w", err)
	}

	// Remove public key
	if err := os.Remove(publicPath); err != nil && !os.IsNotExist(err) {
		s.log.ErrWithFields(err, "failed to delete public key", map[string]interface{}{
			"key_path": publicPath,
		})
		return fmt.Errorf("failed to delete public key: %w", err)
	}

	s.log.InfoWithFields("SSH key deleted successfully", map[string]interface{}{
		"key_name": name,
	})

	return nil
}

// Fingerprint returns the fingerprint of a key
func (s *Service) Fingerprint(ctx context.Context, name string, algorithm string) (string, error) {
	// Handle both full paths and key names
	keyPath := name
	if !filepath.IsAbs(name) {
		keyPath = filepath.Join(s.sshDir, name)
	}

	if algorithm == "" {
		algorithm = "sha256"
	}

	// Try public key first, then private key path
	publicKeyPath := keyPath + ".pub"
	if _, err := os.Stat(publicKeyPath); os.IsNotExist(err) {
		publicKeyPath = keyPath // Maybe they passed the public key path directly
	}

	fingerprint, err := s.keyGenerator.CalculateFingerprint(publicKeyPath, algorithm)
	if err != nil {
		s.log.ErrWithFields(err, "failed to get fingerprint", map[string]interface{}{
			"key_name":  name,
			"algorithm": algorithm,
		})
		return "", fmt.Errorf("failed to calculate fingerprint: %w", err)
	}

	return fingerprint, nil
}

// ChangePassphrase changes the passphrase of an existing key
func (s *Service) ChangePassphrase(ctx context.Context, name, oldPass, newPass string) error {
	s.log.InfoWithFields("changing passphrase", map[string]interface{}{
		"key_name": name,
	})

	// Handle both full paths and key names
	var keyPath string
	if filepath.IsAbs(name) {
		keyPath = name
	} else {
		if err := s.validateKeyName(name); err != nil {
			s.log.ErrWithFields(err, "invalid key name", map[string]interface{}{
				"key_name": name,
			})
			return err
		}
		keyPath = filepath.Join(s.sshDir, name)
	}

	if err := s.keyGenerator.ChangePassphrase(keyPath, oldPass, newPass); err != nil {
		s.log.ErrWithFields(err, "failed to change passphrase", map[string]interface{}{
			"key_name": name,
		})
		return fmt.Errorf("failed to change passphrase: %w", err)
	}

	s.log.InfoWithFields("passphrase changed successfully", map[string]interface{}{
		"key_name": name,
	})

	return nil
}

// load loads a key from the filesystem
func (s *Service) load(ctx context.Context, name string) (*Key, error) {
	// Handle both full paths and key names
	var privatePath string
	if filepath.IsAbs(name) {
		privatePath = name
		// Extract just the key name for the Name field
		name = filepath.Base(name)
	} else {
		privatePath = filepath.Join(s.sshDir, name)
	}
	publicPath := privatePath + ".pub"

	// Read public key
	pubKeyData, err := os.ReadFile(publicPath)
	if err != nil {
		return nil, fmt.Errorf("failed to read public key: %w", err)
	}

	// Parse public key to get type and comment
	parts := strings.Fields(string(pubKeyData))
	if len(parts) < 2 {
		return nil, fmt.Errorf("invalid public key format")
	}

	keyType := parseKeyType(parts[0])
	comment := ""
	if len(parts) >= 3 {
		comment = strings.Join(parts[2:], " ")
	}

	// Get fingerprint
	fingerprint, err := s.Fingerprint(ctx, name, "sha256")
	if err != nil {
		fingerprint = "unknown"
	}

	// Check if key has passphrase
	hasPassphrase := checkHasPassphrase(privatePath)

	// Check if key is in agent
	inAgent := s.isKeyInAgent(ctx, fingerprint)

	// Get key bits
	bits := s.getKeyBits(ctx, publicPath)

	// Get file info for timestamps
	info, _ := os.Stat(privatePath)
	var modTime time.Time
	if info != nil {
		modTime = info.ModTime()
	}

	return &Key{
		ID:                fingerprint,
		Name:              name,
		PrivateKeyPath:    privatePath,
		PublicKeyPath:     publicPath,
		Type:              keyType,
		Bits:              bits,
		Comment:           comment,
		FingerprintSHA256: fingerprint,
		PublicKey:         strings.TrimSpace(string(pubKeyData)),
		HasPassphrase:     hasPassphrase,
		InAgent:           inAgent,
		CreatedAt:         modTime, // Use modTime as best approximation (Linux doesn't reliably track birth time)
		ModifiedAt:        modTime,
	}, nil
}

// shouldSkipFile returns true if the file should not be treated as a key
func (s *Service) shouldSkipFile(name string) bool {
	skipFiles := []string{"config", "known_hosts", "authorized_keys", "environment"}
	for _, skip := range skipFiles {
		if name == skip {
			return true
		}
	}
	return strings.HasSuffix(name, ".pub") || strings.HasPrefix(name, ".")
}

// validateKeyName validates a key name for safety
func (s *Service) validateKeyName(name string) error {
	if name == "" {
		return fmt.Errorf("key name cannot be empty")
	}
	if strings.Contains(name, "/") || strings.Contains(name, "\\") {
		return fmt.Errorf("key name cannot contain path separators")
	}
	if strings.HasPrefix(name, ".") {
		return fmt.Errorf("key name cannot start with a dot")
	}
	return nil
}

// parseKeyType converts SSH key type string to KeyType
func parseKeyType(keyTypeStr string) KeyType {
	switch keyTypeStr {
	case "ssh-rsa":
		return KeyTypeRSA
	case "ssh-ed25519":
		return KeyTypeED25519
	case "ecdsa-sha2-nistp256", "ecdsa-sha2-nistp384", "ecdsa-sha2-nistp521":
		return KeyTypeECDSA
	case "sk-ssh-ed25519@openssh.com":
		return KeyTypeED25519SK
	case "sk-ecdsa-sha2-nistp256@openssh.com":
		return KeyTypeECDSASK
	default:
		return KeyTypeUnknown
	}
}

// checkHasPassphrase checks if a private key is encrypted
func checkHasPassphrase(keyPath string) bool {
	data, err := os.ReadFile(keyPath)
	if err != nil {
		return false
	}

	content := string(data)

	// Check for old PEM format encryption markers
	if strings.Contains(content, "ENCRYPTED") ||
		strings.Contains(content, "Proc-Type: 4,ENCRYPTED") {
		return true
	}

	// Check for new OpenSSH format (openssh-key-v1)
	// The format is: "-----BEGIN OPENSSH PRIVATE KEY-----" followed by base64 data
	// The base64 data starts with "openssh-key-v1\x00" + cipher name + kdf name
	// For unencrypted keys: cipher="none", kdf="none"
	// For encrypted keys: cipher="aes256-ctr" (or similar), kdf="bcrypt"
	if strings.Contains(content, "BEGIN OPENSSH PRIVATE KEY") {
		// Extract the base64 content between the markers
		start := strings.Index(content, "-----BEGIN OPENSSH PRIVATE KEY-----")
		end := strings.Index(content, "-----END OPENSSH PRIVATE KEY-----")
		if start == -1 || end == -1 || end <= start {
			return false
		}

		// Get the base64 portion and decode enough to check the cipher
		base64Content := content[start+len("-----BEGIN OPENSSH PRIVATE KEY-----") : end]
		base64Content = strings.ReplaceAll(base64Content, "\n", "")
		base64Content = strings.ReplaceAll(base64Content, "\r", "")
		base64Content = strings.TrimSpace(base64Content)

		// Decode at least the first 64 bytes to get the header info
		// Format after "openssh-key-v1\x00":
		//   - 4 bytes: cipher name length (big endian)
		//   - N bytes: cipher name
		//   - 4 bytes: kdf name length
		//   - N bytes: kdf name
		if len(base64Content) < 48 {
			return false
		}

		decoded := make([]byte, 64)
		n, err := base64Decode(decoded, []byte(base64Content[:48]))
		if err != nil || n < 32 {
			return false
		}

		// Check for "openssh-key-v1\x00" magic (15 bytes)
		magic := "openssh-key-v1\x00"
		if n < len(magic)+8 {
			return false
		}

		if string(decoded[:len(magic)]) != magic {
			return false
		}

		// Read cipher name length (4 bytes, big endian) starting at offset 15
		offset := len(magic)
		if offset+4 > n {
			return false
		}
		cipherLen := int(decoded[offset])<<24 | int(decoded[offset+1])<<16 | int(decoded[offset+2])<<8 | int(decoded[offset+3])
		offset += 4

		if cipherLen <= 0 || cipherLen > 32 || offset+cipherLen > n {
			return false
		}

		cipher := string(decoded[offset : offset+cipherLen])

		// If cipher is "none", the key is not encrypted
		return cipher != "none"
	}

	return false
}

// base64Decode decodes base64 data into dst, returning the number of bytes written
func base64Decode(dst, src []byte) (int, error) {
	// Standard base64 decoding table
	decodeMap := [256]byte{}
	for i := range decodeMap {
		decodeMap[i] = 0xFF
	}
	const alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
	for i, c := range alphabet {
		decodeMap[c] = byte(i)
	}
	decodeMap['='] = 0

	si, di := 0, 0
	for si < len(src) && di < len(dst) {
		// Skip whitespace
		if src[si] == ' ' || src[si] == '\t' || src[si] == '\n' || src[si] == '\r' {
			si++
			continue
		}

		// Need 4 input bytes for 3 output bytes
		if si+4 > len(src) {
			break
		}

		// Decode 4 bytes
		var val uint32
		for j := 0; j < 4; j++ {
			c := src[si+j]
			if c == '=' {
				break
			}
			if decodeMap[c] == 0xFF {
				return di, fmt.Errorf("invalid base64 character")
			}
			val = val<<6 | uint32(decodeMap[c])
		}

		// Determine padding and output bytes
		padding := 0
		if src[si+3] == '=' {
			padding++
		}
		if src[si+2] == '=' {
			padding++
		}

		switch padding {
		case 0:
			if di+3 > len(dst) {
				return di, nil
			}
			dst[di] = byte(val >> 16)
			dst[di+1] = byte(val >> 8)
			dst[di+2] = byte(val)
			di += 3
		case 1:
			if di+2 > len(dst) {
				return di, nil
			}
			val <<= 6
			dst[di] = byte(val >> 16)
			dst[di+1] = byte(val >> 8)
			di += 2
		case 2:
			if di+1 > len(dst) {
				return di, nil
			}
			val <<= 12
			dst[di] = byte(val >> 16)
			di += 1
		}
		si += 4
	}

	return di, nil
}

// isKeyInAgent checks if a key with the given fingerprint is loaded in the SSH agent
func (s *Service) isKeyInAgent(ctx context.Context, fingerprint string) bool {
	if fingerprint == "" || fingerprint == "unknown" {
		return false
	}

	// Requires an agent checker to be configured
	if s.agentChecker == nil {
		s.log.Debug("no agent checker configured, cannot check if key is in agent")
		return false
	}

	fingerprints, err := s.agentChecker.ListLoadedFingerprints()
	if err != nil {
		s.log.DebugWithFields("agent checker failed", map[string]interface{}{
			"error": err.Error(),
		})
		return false
	}
	for _, fp := range fingerprints {
		if fp == fingerprint {
			return true
		}
	}
	return false
}

// getKeyBits extracts the bit size from a public key file
func (s *Service) getKeyBits(ctx context.Context, publicKeyPath string) int {
	bits, err := s.keyGenerator.GetKeyBits(publicKeyPath)
	if err != nil {
		return 0
	}
	return bits
}
