// Package keys provides SSH key management functionality.
package keys

import (
	"crypto"
	"crypto/ecdsa"
	"crypto/ed25519"
	"crypto/elliptic"
	"crypto/rand"
	"crypto/rsa"
	"encoding/pem"
	"fmt"
	"os"

	"golang.org/x/crypto/ssh"
)

// KeyGenerator handles native SSH key generation without shelling out to ssh-keygen
type KeyGenerator struct{}

// NewKeyGenerator creates a new key generator
func NewKeyGenerator() *KeyGenerator {
	return &KeyGenerator{}
}

// GenerateKeyPair generates an SSH key pair and writes it to disk
func (g *KeyGenerator) GenerateKeyPair(opts GenerateOptions) error {
	var privateKey crypto.PrivateKey
	var err error

	// Generate the appropriate key type
	switch opts.Type {
	case KeyTypeED25519, "":
		_, privateKey, err = ed25519.GenerateKey(rand.Reader)
	case KeyTypeECDSA:
		privateKey, err = ecdsa.GenerateKey(elliptic.P256(), rand.Reader)
	case KeyTypeRSA:
		bits := opts.Bits
		if bits == 0 {
			bits = 4096 // Default RSA key size
		}
		privateKey, err = rsa.GenerateKey(rand.Reader, bits)
	default:
		return fmt.Errorf("unsupported key type: %s", opts.Type)
	}

	if err != nil {
		return fmt.Errorf("failed to generate key: %w", err)
	}

	// Marshal the private key to OpenSSH format
	var privateKeyPEM *pem.Block
	if opts.Passphrase != "" {
		// Encrypt the private key with the passphrase
		privateKeyPEM, err = ssh.MarshalPrivateKeyWithPassphrase(privateKey, opts.Comment, []byte(opts.Passphrase))
	} else {
		privateKeyPEM, err = ssh.MarshalPrivateKey(privateKey, opts.Comment)
	}
	if err != nil {
		return fmt.Errorf("failed to marshal private key: %w", err)
	}

	// Write private key with restrictive permissions
	privateKeyPath := opts.path
	privateKeyData := pem.EncodeToMemory(privateKeyPEM)
	if err := os.WriteFile(privateKeyPath, privateKeyData, 0600); err != nil {
		return fmt.Errorf("failed to write private key: %w", err)
	}

	// Generate and write public key
	signer, err := ssh.NewSignerFromKey(privateKey)
	if err != nil {
		// Clean up private key on failure
		os.Remove(privateKeyPath)
		return fmt.Errorf("failed to create signer: %w", err)
	}

	publicKey := signer.PublicKey()
	publicKeyData := ssh.MarshalAuthorizedKey(publicKey)

	// Add comment to public key if provided
	if opts.Comment != "" {
		// MarshalAuthorizedKey adds a newline, so we need to insert the comment before it
		publicKeyData = append(publicKeyData[:len(publicKeyData)-1], []byte(" "+opts.Comment+"\n")...)
	}

	publicKeyPath := privateKeyPath + ".pub"
	if err := os.WriteFile(publicKeyPath, publicKeyData, 0644); err != nil {
		// Clean up private key on failure
		os.Remove(privateKeyPath)
		return fmt.Errorf("failed to write public key: %w", err)
	}

	return nil
}

// CalculateFingerprint calculates the fingerprint of a public key file
func (g *KeyGenerator) CalculateFingerprint(publicKeyPath string, algorithm string) (string, error) {
	// Read the public key file
	pubKeyData, err := os.ReadFile(publicKeyPath)
	if err != nil {
		return "", fmt.Errorf("failed to read public key: %w", err)
	}

	return CalculateFingerprintFromData(pubKeyData, algorithm)
}

// CalculateFingerprintFromData calculates the fingerprint from public key bytes
func CalculateFingerprintFromData(pubKeyData []byte, algorithm string) (string, error) {
	// Parse the public key
	pubKey, _, _, _, err := ssh.ParseAuthorizedKey(pubKeyData)
	if err != nil {
		return "", fmt.Errorf("failed to parse public key: %w", err)
	}

	return CalculateFingerprintFromPublicKey(pubKey, algorithm)
}

// CalculateFingerprintFromPublicKey calculates the fingerprint from an ssh.PublicKey
func CalculateFingerprintFromPublicKey(pubKey ssh.PublicKey, algorithm string) (string, error) {
	if algorithm == "" {
		algorithm = "sha256"
	}

	switch algorithm {
	case "sha256":
		return ssh.FingerprintSHA256(pubKey), nil
	case "md5":
		return ssh.FingerprintLegacyMD5(pubKey), nil
	default:
		return "", fmt.Errorf("unsupported fingerprint algorithm: %s", algorithm)
	}
}

// ChangePassphrase changes the passphrase on an existing private key
func (g *KeyGenerator) ChangePassphrase(privateKeyPath, oldPassphrase, newPassphrase string) error {
	// Read the private key file
	privateKeyData, err := os.ReadFile(privateKeyPath)
	if err != nil {
		return fmt.Errorf("failed to read private key: %w", err)
	}

	// Parse the private key (with old passphrase if encrypted)
	var privateKey interface{}
	if oldPassphrase != "" {
		privateKey, err = ssh.ParseRawPrivateKeyWithPassphrase(privateKeyData, []byte(oldPassphrase))
	} else {
		privateKey, err = ssh.ParseRawPrivateKey(privateKeyData)
	}
	if err != nil {
		return fmt.Errorf("failed to parse private key: %w", err)
	}

	// Extract the comment from the original key if possible
	comment := extractCommentFromPrivateKey(privateKeyData)

	// Re-marshal with new passphrase (or without passphrase if newPassphrase is empty)
	var newPEM *pem.Block
	if newPassphrase != "" {
		newPEM, err = ssh.MarshalPrivateKeyWithPassphrase(privateKey, comment, []byte(newPassphrase))
	} else {
		newPEM, err = ssh.MarshalPrivateKey(privateKey, comment)
	}
	if err != nil {
		return fmt.Errorf("failed to marshal private key: %w", err)
	}

	// Write back to file
	newKeyData := pem.EncodeToMemory(newPEM)
	if err := os.WriteFile(privateKeyPath, newKeyData, 0600); err != nil {
		return fmt.Errorf("failed to write private key: %w", err)
	}

	return nil
}

// GetKeyBits returns the bit size of a key from its public key file
func (g *KeyGenerator) GetKeyBits(publicKeyPath string) (int, error) {
	pubKeyData, err := os.ReadFile(publicKeyPath)
	if err != nil {
		return 0, fmt.Errorf("failed to read public key: %w", err)
	}

	return GetKeyBitsFromData(pubKeyData)
}

// GetKeyBitsFromData returns the bit size from public key bytes
func GetKeyBitsFromData(pubKeyData []byte) (int, error) {
	pubKey, _, _, _, err := ssh.ParseAuthorizedKey(pubKeyData)
	if err != nil {
		return 0, fmt.Errorf("failed to parse public key: %w", err)
	}

	return GetKeyBitsFromPublicKey(pubKey)
}

// GetKeyBitsFromPublicKey returns the bit size from an ssh.PublicKey
func GetKeyBitsFromPublicKey(pubKey ssh.PublicKey) (int, error) {
	// Get the crypto public key
	cryptoPubKey := pubKey.(ssh.CryptoPublicKey).CryptoPublicKey()

	switch key := cryptoPubKey.(type) {
	case *rsa.PublicKey:
		return key.N.BitLen(), nil
	case *ecdsa.PublicKey:
		return key.Curve.Params().BitSize, nil
	case ed25519.PublicKey:
		return 256, nil // ED25519 keys are always 256 bits
	default:
		return 0, fmt.Errorf("unsupported key type: %T", key)
	}
}

// extractCommentFromPrivateKey tries to extract the comment from a private key file
func extractCommentFromPrivateKey(data []byte) string {
	// The comment is embedded in the OpenSSH private key format
	// We try to decode and re-encode to preserve it
	block, _ := pem.Decode(data)
	if block == nil {
		return ""
	}

	// For openssh-key-v1 format, the comment is inside the encrypted blob
	// We can't easily extract it without parsing the full format
	// Return empty string for now - the comment is also in the public key
	return ""
}

// GetKeyType returns the key type string from a public key file
func (g *KeyGenerator) GetKeyType(publicKeyPath string) (string, error) {
	pubKeyData, err := os.ReadFile(publicKeyPath)
	if err != nil {
		return "", fmt.Errorf("failed to read public key: %w", err)
	}

	return GetKeyTypeFromData(pubKeyData)
}

// GetKeyTypeFromData returns the key type from public key bytes
func GetKeyTypeFromData(pubKeyData []byte) (string, error) {
	pubKey, _, _, _, err := ssh.ParseAuthorizedKey(pubKeyData)
	if err != nil {
		return "", fmt.Errorf("failed to parse public key: %w", err)
	}

	return GetKeyTypeFromPublicKey(pubKey), nil
}

// GetKeyTypeFromPublicKey returns the key type string from an ssh.PublicKey
func GetKeyTypeFromPublicKey(pubKey ssh.PublicKey) string {
	switch pubKey.Type() {
	case ssh.KeyAlgoRSA:
		return string(KeyTypeRSA)
	case ssh.KeyAlgoECDSA256, ssh.KeyAlgoECDSA384, ssh.KeyAlgoECDSA521:
		return string(KeyTypeECDSA)
	case ssh.KeyAlgoED25519:
		return string(KeyTypeED25519)
	default:
		return pubKey.Type()
	}
}
