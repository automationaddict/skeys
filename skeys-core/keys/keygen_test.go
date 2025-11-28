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

package keys

import (
	"os"
	"path/filepath"
	"strings"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestKeyGenerator_GenerateKeyPair_ED25519(t *testing.T) {
	tmpDir := t.TempDir()
	keyPath := filepath.Join(tmpDir, "test_ed25519")

	gen := NewKeyGenerator()
	err := gen.GenerateKeyPair(GenerateOptions{
		Name:    "test_ed25519",
		Type:    KeyTypeED25519,
		Comment: "test@example.com",
		path:    keyPath,
	})
	require.NoError(t, err)

	// Verify private key exists with correct permissions
	info, err := os.Stat(keyPath)
	require.NoError(t, err)
	assert.Equal(t, os.FileMode(0600), info.Mode().Perm())

	// Verify public key exists
	pubKeyPath := keyPath + ".pub"
	_, err = os.Stat(pubKeyPath)
	require.NoError(t, err)

	// Verify public key contains comment
	pubKeyData, err := os.ReadFile(pubKeyPath)
	require.NoError(t, err)
	assert.Contains(t, string(pubKeyData), "test@example.com")
	assert.Contains(t, string(pubKeyData), "ssh-ed25519")
}

func TestKeyGenerator_GenerateKeyPair_RSA(t *testing.T) {
	tmpDir := t.TempDir()
	keyPath := filepath.Join(tmpDir, "test_rsa")

	gen := NewKeyGenerator()
	err := gen.GenerateKeyPair(GenerateOptions{
		Name:    "test_rsa",
		Type:    KeyTypeRSA,
		Bits:    2048, // Use smaller key for faster tests
		Comment: "rsa@example.com",
		path:    keyPath,
	})
	require.NoError(t, err)

	// Verify public key type
	pubKeyData, err := os.ReadFile(keyPath + ".pub")
	require.NoError(t, err)
	assert.Contains(t, string(pubKeyData), "ssh-rsa")
}

func TestKeyGenerator_GenerateKeyPair_ECDSA(t *testing.T) {
	tmpDir := t.TempDir()
	keyPath := filepath.Join(tmpDir, "test_ecdsa")

	gen := NewKeyGenerator()
	err := gen.GenerateKeyPair(GenerateOptions{
		Name:    "test_ecdsa",
		Type:    KeyTypeECDSA,
		Comment: "ecdsa@example.com",
		path:    keyPath,
	})
	require.NoError(t, err)

	// Verify public key type
	pubKeyData, err := os.ReadFile(keyPath + ".pub")
	require.NoError(t, err)
	assert.Contains(t, string(pubKeyData), "ecdsa-sha2-nistp256")
}

func TestKeyGenerator_GenerateKeyPair_WithPassphrase(t *testing.T) {
	tmpDir := t.TempDir()
	keyPath := filepath.Join(tmpDir, "test_passphrase")

	gen := NewKeyGenerator()
	err := gen.GenerateKeyPair(GenerateOptions{
		Name:       "test_passphrase",
		Type:       KeyTypeED25519,
		Comment:    "passphrase@example.com",
		Passphrase: "testpassphrase123",
		path:       keyPath,
	})
	require.NoError(t, err)

	// Verify key is encrypted
	assert.True(t, checkHasPassphrase(keyPath))
}

func TestKeyGenerator_GenerateKeyPair_WithoutPassphrase(t *testing.T) {
	tmpDir := t.TempDir()
	keyPath := filepath.Join(tmpDir, "test_nopassphrase")

	gen := NewKeyGenerator()
	err := gen.GenerateKeyPair(GenerateOptions{
		Name:    "test_nopassphrase",
		Type:    KeyTypeED25519,
		Comment: "nopassphrase@example.com",
		path:    keyPath,
	})
	require.NoError(t, err)

	// Verify key is not encrypted
	assert.False(t, checkHasPassphrase(keyPath))
}

func TestKeyGenerator_GenerateKeyPair_UnsupportedType(t *testing.T) {
	tmpDir := t.TempDir()
	keyPath := filepath.Join(tmpDir, "test_unsupported")

	gen := NewKeyGenerator()
	err := gen.GenerateKeyPair(GenerateOptions{
		Name: "test_unsupported",
		Type: KeyType("unsupported"),
		path: keyPath,
	})
	require.Error(t, err)
	assert.Contains(t, err.Error(), "unsupported key type")
}

func TestKeyGenerator_CalculateFingerprint(t *testing.T) {
	tmpDir := t.TempDir()
	keyPath := filepath.Join(tmpDir, "test_fingerprint")

	gen := NewKeyGenerator()
	err := gen.GenerateKeyPair(GenerateOptions{
		Name: "test_fingerprint",
		Type: KeyTypeED25519,
		path: keyPath,
	})
	require.NoError(t, err)

	// Test SHA256 fingerprint
	fp, err := gen.CalculateFingerprint(keyPath+".pub", "sha256")
	require.NoError(t, err)
	assert.True(t, strings.HasPrefix(fp, "SHA256:"))

	// Test MD5 fingerprint
	fpMD5, err := gen.CalculateFingerprint(keyPath+".pub", "md5")
	require.NoError(t, err)
	assert.Contains(t, fpMD5, ":")
	assert.NotEqual(t, fp, fpMD5)

	// Test default (sha256)
	fpDefault, err := gen.CalculateFingerprint(keyPath+".pub", "")
	require.NoError(t, err)
	assert.Equal(t, fp, fpDefault)
}

func TestKeyGenerator_CalculateFingerprint_UnsupportedAlgorithm(t *testing.T) {
	tmpDir := t.TempDir()
	keyPath := filepath.Join(tmpDir, "test_fp_unsupported")

	gen := NewKeyGenerator()
	err := gen.GenerateKeyPair(GenerateOptions{
		Name: "test_fp_unsupported",
		Type: KeyTypeED25519,
		path: keyPath,
	})
	require.NoError(t, err)

	_, err = gen.CalculateFingerprint(keyPath+".pub", "sha512")
	require.Error(t, err)
	assert.Contains(t, err.Error(), "unsupported fingerprint algorithm")
}

func TestKeyGenerator_CalculateFingerprint_FileNotFound(t *testing.T) {
	gen := NewKeyGenerator()
	_, err := gen.CalculateFingerprint("/nonexistent/path.pub", "sha256")
	require.Error(t, err)
}

func TestKeyGenerator_ChangePassphrase_AddPassphrase(t *testing.T) {
	tmpDir := t.TempDir()
	keyPath := filepath.Join(tmpDir, "test_change_add")

	gen := NewKeyGenerator()
	// Generate key without passphrase
	err := gen.GenerateKeyPair(GenerateOptions{
		Name: "test_change_add",
		Type: KeyTypeED25519,
		path: keyPath,
	})
	require.NoError(t, err)
	assert.False(t, checkHasPassphrase(keyPath))

	// Add passphrase
	err = gen.ChangePassphrase(keyPath, "", "newpassphrase")
	require.NoError(t, err)
	assert.True(t, checkHasPassphrase(keyPath))
}

func TestKeyGenerator_ChangePassphrase_RemovePassphrase(t *testing.T) {
	tmpDir := t.TempDir()
	keyPath := filepath.Join(tmpDir, "test_change_remove")

	gen := NewKeyGenerator()
	// Generate key with passphrase
	err := gen.GenerateKeyPair(GenerateOptions{
		Name:       "test_change_remove",
		Type:       KeyTypeED25519,
		Passphrase: "oldpassphrase",
		path:       keyPath,
	})
	require.NoError(t, err)
	assert.True(t, checkHasPassphrase(keyPath))

	// Remove passphrase
	err = gen.ChangePassphrase(keyPath, "oldpassphrase", "")
	require.NoError(t, err)
	assert.False(t, checkHasPassphrase(keyPath))
}

func TestKeyGenerator_ChangePassphrase_WrongOldPassphrase(t *testing.T) {
	tmpDir := t.TempDir()
	keyPath := filepath.Join(tmpDir, "test_change_wrong")

	gen := NewKeyGenerator()
	err := gen.GenerateKeyPair(GenerateOptions{
		Name:       "test_change_wrong",
		Type:       KeyTypeED25519,
		Passphrase: "correctpassphrase",
		path:       keyPath,
	})
	require.NoError(t, err)

	// Try with wrong passphrase
	err = gen.ChangePassphrase(keyPath, "wrongpassphrase", "newpassphrase")
	require.Error(t, err)
}

func TestKeyGenerator_GetKeyBits(t *testing.T) {
	tmpDir := t.TempDir()
	gen := NewKeyGenerator()

	tests := []struct {
		name     string
		keyType  KeyType
		bits     int
		expected int
	}{
		{"ED25519", KeyTypeED25519, 0, 256},
		{"RSA 2048", KeyTypeRSA, 2048, 2048},
		{"RSA 4096", KeyTypeRSA, 4096, 4096},
		{"ECDSA", KeyTypeECDSA, 0, 256}, // P-256 curve
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			keyPath := filepath.Join(tmpDir, "test_bits_"+tt.name)
			err := gen.GenerateKeyPair(GenerateOptions{
				Name: "test_bits_" + tt.name,
				Type: tt.keyType,
				Bits: tt.bits,
				path: keyPath,
			})
			require.NoError(t, err)

			bits, err := gen.GetKeyBits(keyPath + ".pub")
			require.NoError(t, err)
			assert.Equal(t, tt.expected, bits)
		})
	}
}

func TestKeyGenerator_GetKeyType(t *testing.T) {
	tmpDir := t.TempDir()
	gen := NewKeyGenerator()

	tests := []struct {
		name     string
		keyType  KeyType
		expected string
	}{
		{"ED25519", KeyTypeED25519, "ed25519"},
		{"RSA", KeyTypeRSA, "rsa"},
		{"ECDSA", KeyTypeECDSA, "ecdsa"},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			keyPath := filepath.Join(tmpDir, "test_type_"+tt.name)
			err := gen.GenerateKeyPair(GenerateOptions{
				Name: "test_type_" + tt.name,
				Type: tt.keyType,
				Bits: 2048, // For RSA
				path: keyPath,
			})
			require.NoError(t, err)

			keyType, err := gen.GetKeyType(keyPath + ".pub")
			require.NoError(t, err)
			assert.Equal(t, tt.expected, keyType)
		})
	}
}

func TestCalculateFingerprintFromData(t *testing.T) {
	tmpDir := t.TempDir()
	keyPath := filepath.Join(tmpDir, "test_fp_data")

	gen := NewKeyGenerator()
	err := gen.GenerateKeyPair(GenerateOptions{
		Name: "test_fp_data",
		Type: KeyTypeED25519,
		path: keyPath,
	})
	require.NoError(t, err)

	pubKeyData, err := os.ReadFile(keyPath + ".pub")
	require.NoError(t, err)

	fp, err := CalculateFingerprintFromData(pubKeyData, "sha256")
	require.NoError(t, err)
	assert.True(t, strings.HasPrefix(fp, "SHA256:"))
}

func TestGetKeyBitsFromData(t *testing.T) {
	tmpDir := t.TempDir()
	keyPath := filepath.Join(tmpDir, "test_bits_data")

	gen := NewKeyGenerator()
	err := gen.GenerateKeyPair(GenerateOptions{
		Name: "test_bits_data",
		Type: KeyTypeED25519,
		path: keyPath,
	})
	require.NoError(t, err)

	pubKeyData, err := os.ReadFile(keyPath + ".pub")
	require.NoError(t, err)

	bits, err := GetKeyBitsFromData(pubKeyData)
	require.NoError(t, err)
	assert.Equal(t, 256, bits)
}

func TestGetKeyTypeFromData(t *testing.T) {
	tmpDir := t.TempDir()
	keyPath := filepath.Join(tmpDir, "test_type_data")

	gen := NewKeyGenerator()
	err := gen.GenerateKeyPair(GenerateOptions{
		Name: "test_type_data",
		Type: KeyTypeED25519,
		path: keyPath,
	})
	require.NoError(t, err)

	pubKeyData, err := os.ReadFile(keyPath + ".pub")
	require.NoError(t, err)

	keyType, err := GetKeyTypeFromData(pubKeyData)
	require.NoError(t, err)
	assert.Equal(t, "ed25519", keyType)
}
