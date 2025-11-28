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

package adapter

import (
	"testing"
	"time"

	"github.com/stretchr/testify/assert"

	"github.com/automationaddict/skeys-core/keys"
	pb "github.com/automationaddict/skeys-daemon/api/gen/skeys/v1"
)

func TestToProtoKeyType(t *testing.T) {
	tests := []struct {
		input    keys.KeyType
		expected pb.KeyType
	}{
		{keys.KeyTypeRSA, pb.KeyType_KEY_TYPE_RSA},
		{keys.KeyTypeED25519, pb.KeyType_KEY_TYPE_ED25519},
		{keys.KeyTypeECDSA, pb.KeyType_KEY_TYPE_ECDSA},
		{keys.KeyTypeED25519SK, pb.KeyType_KEY_TYPE_ED25519_SK},
		{keys.KeyTypeECDSASK, pb.KeyType_KEY_TYPE_ECDSA_SK},
		{keys.KeyType("unknown"), pb.KeyType_KEY_TYPE_UNSPECIFIED},
	}

	for _, tt := range tests {
		t.Run(string(tt.input), func(t *testing.T) {
			result := toProtoKeyType(tt.input)
			assert.Equal(t, tt.expected, result)
		})
	}
}

func TestFromProtoKeyType(t *testing.T) {
	tests := []struct {
		input    pb.KeyType
		expected keys.KeyType
	}{
		{pb.KeyType_KEY_TYPE_RSA, keys.KeyTypeRSA},
		{pb.KeyType_KEY_TYPE_ED25519, keys.KeyTypeED25519},
		{pb.KeyType_KEY_TYPE_ECDSA, keys.KeyTypeECDSA},
		{pb.KeyType_KEY_TYPE_ED25519_SK, keys.KeyTypeED25519SK},
		{pb.KeyType_KEY_TYPE_ECDSA_SK, keys.KeyTypeECDSASK},
		{pb.KeyType_KEY_TYPE_UNSPECIFIED, keys.KeyTypeED25519}, // Default
	}

	for _, tt := range tests {
		t.Run(tt.input.String(), func(t *testing.T) {
			result := fromProtoKeyType(tt.input)
			assert.Equal(t, tt.expected, result)
		})
	}
}

func TestToProtoKey(t *testing.T) {
	now := time.Now()
	key := &keys.Key{
		ID:                "test-key-id",
		Name:              "my-key",
		PrivateKeyPath:    "/home/user/.ssh/id_ed25519",
		PublicKeyPath:     "/home/user/.ssh/id_ed25519.pub",
		Type:              keys.KeyTypeED25519,
		Bits:              256,
		Comment:           "test comment",
		FingerprintSHA256: "SHA256:abc123",
		FingerprintMD5:    "aa:bb:cc:dd",
		PublicKey:         "ssh-ed25519 AAAA... comment",
		HasPassphrase:     true,
		InAgent:           true,
		CreatedAt:         now,
		ModifiedAt:        now,
	}

	pbKey := toProtoKey(key)
	assert.Equal(t, "test-key-id", pbKey.Id)
	assert.Equal(t, "my-key", pbKey.Name)
	assert.Equal(t, "/home/user/.ssh/id_ed25519", pbKey.PrivateKeyPath)
	assert.Equal(t, "/home/user/.ssh/id_ed25519.pub", pbKey.PublicKeyPath)
	assert.Equal(t, pb.KeyType_KEY_TYPE_ED25519, pbKey.Type)
	assert.Equal(t, int32(256), pbKey.Bits)
	assert.Equal(t, "test comment", pbKey.Comment)
	assert.Equal(t, "SHA256:abc123", pbKey.FingerprintSha256)
	assert.Equal(t, "aa:bb:cc:dd", pbKey.FingerprintMd5)
	assert.Equal(t, "ssh-ed25519 AAAA... comment", pbKey.PublicKey)
	assert.True(t, pbKey.HasPassphrase)
	assert.True(t, pbKey.InAgent)
	assert.NotNil(t, pbKey.CreatedAt)
	assert.NotNil(t, pbKey.ModifiedAt)
}

func TestNewKeyServiceAdapter(t *testing.T) {
	// Can't easily test without a real keys.Service due to filesystem dependencies
	// This test just verifies the constructor doesn't panic with nil
	adapter := NewKeyServiceAdapter(nil)
	assert.NotNil(t, adapter)
	assert.Nil(t, adapter.service)
}
