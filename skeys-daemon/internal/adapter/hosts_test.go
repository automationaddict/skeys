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

	"github.com/stretchr/testify/assert"

	"github.com/johnnelson/skeys-core/hosts"
)

func TestToProtoKnownHost(t *testing.T) {
	host := &hosts.KnownHost{
		ID:          "host-id-123",
		Hostnames:   []string{"github.com", "192.168.1.1"},
		KeyType:     "ssh-ed25519",
		Fingerprint: "SHA256:abc123",
		PublicKey:   "AAAAC3NzaC1...",
		IsHashed:    true,
		IsRevoked:   false,
		IsCertAuth:  true,
		LineNumber:  5,
	}

	pbHost := toProtoKnownHost(host)
	assert.Equal(t, "host-id-123", pbHost.Id)
	assert.Equal(t, []string{"github.com", "192.168.1.1"}, pbHost.Hostnames)
	assert.Equal(t, "ssh-ed25519", pbHost.KeyType)
	assert.Equal(t, "SHA256:abc123", pbHost.Fingerprint)
	assert.Equal(t, "AAAAC3NzaC1...", pbHost.PublicKey)
	assert.True(t, pbHost.IsHashed)
	assert.False(t, pbHost.IsRevoked)
	assert.True(t, pbHost.IsCertAuthority)
	assert.Equal(t, int32(5), pbHost.LineNumber)
}

func TestToProtoKnownHost_Minimal(t *testing.T) {
	host := &hosts.KnownHost{
		ID:        "minimal-id",
		Hostnames: []string{"example.com"},
		KeyType:   "ssh-rsa",
		PublicKey: "AAAA...",
	}

	pbHost := toProtoKnownHost(host)
	assert.Equal(t, "minimal-id", pbHost.Id)
	assert.Equal(t, []string{"example.com"}, pbHost.Hostnames)
	assert.False(t, pbHost.IsHashed)
	assert.False(t, pbHost.IsRevoked)
	assert.False(t, pbHost.IsCertAuthority)
	assert.Equal(t, int32(0), pbHost.LineNumber)
}

func TestToProtoAuthorizedKey(t *testing.T) {
	key := &hosts.AuthorizedKey{
		ID:          "key-id-456",
		KeyType:     "ssh-ed25519",
		Fingerprint: "SHA256:xyz789",
		Comment:     "user@example.com",
		PublicKey:   "AAAAC3NzaC1...",
		Options:     []string{"no-pty", "command=\"/usr/bin/git-shell\""},
		LineNumber:  10,
	}

	pbKey := toProtoAuthorizedKey(key)
	assert.Equal(t, "key-id-456", pbKey.Id)
	assert.Equal(t, "ssh-ed25519", pbKey.KeyType)
	assert.Equal(t, "SHA256:xyz789", pbKey.Fingerprint)
	assert.Equal(t, "user@example.com", pbKey.Comment)
	assert.Equal(t, "AAAAC3NzaC1...", pbKey.PublicKey)
	assert.Equal(t, []string{"no-pty", "command=\"/usr/bin/git-shell\""}, pbKey.Options)
	assert.Equal(t, int32(10), pbKey.LineNumber)
}

func TestToProtoAuthorizedKey_NoOptions(t *testing.T) {
	key := &hosts.AuthorizedKey{
		ID:          "key-no-opts",
		KeyType:     "ssh-rsa",
		Fingerprint: "SHA256:abc",
		Comment:     "simple key",
		PublicKey:   "AAAA...",
		Options:     nil,
		LineNumber:  1,
	}

	pbKey := toProtoAuthorizedKey(key)
	assert.Equal(t, "key-no-opts", pbKey.Id)
	assert.Nil(t, pbKey.Options)
	assert.Equal(t, int32(1), pbKey.LineNumber)
}

func TestNewHostsServiceAdapter(t *testing.T) {
	// Verify constructor doesn't panic with nil
	adapter := NewHostsServiceAdapter(nil, nil)
	assert.NotNil(t, adapter)
	assert.Nil(t, adapter.knownHosts)
	assert.Nil(t, adapter.authorizedKeys)
}

func TestToProtoKnownHost_EmptyHostnames(t *testing.T) {
	host := &hosts.KnownHost{
		ID:        "empty-hostnames",
		Hostnames: []string{},
		KeyType:   "ssh-ed25519",
		PublicKey: "AAAA...",
	}

	pbHost := toProtoKnownHost(host)
	assert.Empty(t, pbHost.Hostnames)
}

func TestToProtoAuthorizedKey_EmptyOptions(t *testing.T) {
	key := &hosts.AuthorizedKey{
		ID:          "empty-opts",
		KeyType:     "ssh-ed25519",
		Fingerprint: "SHA256:abc",
		Comment:     "test",
		PublicKey:   "AAAA...",
		Options:     []string{},
		LineNumber:  1,
	}

	pbKey := toProtoAuthorizedKey(key)
	assert.Empty(t, pbKey.Options)
}

func TestToProtoKnownHost_AllFlags(t *testing.T) {
	// Test with all boolean flags set to true
	host := &hosts.KnownHost{
		ID:         "all-flags",
		Hostnames:  []string{"test.com"},
		KeyType:    "ssh-ed25519",
		PublicKey:  "AAAA...",
		IsHashed:   true,
		IsRevoked:  true,
		IsCertAuth: true,
	}

	pbHost := toProtoKnownHost(host)
	assert.True(t, pbHost.IsHashed)
	assert.True(t, pbHost.IsRevoked)
	assert.True(t, pbHost.IsCertAuthority)
}
