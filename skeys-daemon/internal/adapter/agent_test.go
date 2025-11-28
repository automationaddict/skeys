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

	"github.com/johnnelson/skeys-core/agent"
)

func TestToProtoAgentKey(t *testing.T) {
	agentKey := &agent.AgentKey{
		Fingerprint:     "SHA256:abc123",
		Comment:         "test comment",
		Type:            "ssh-ed25519",
		Bits:            256,
		HasLifetime:     true,
		LifetimeSeconds: 3600,
		IsConfirm:       true,
	}

	pbKey := toProtoAgentKey(agentKey)
	assert.Equal(t, "SHA256:abc123", pbKey.Fingerprint)
	assert.Equal(t, "test comment", pbKey.Comment)
	assert.Equal(t, "ssh-ed25519", pbKey.Type)
	assert.Equal(t, int32(256), pbKey.Bits)
	assert.True(t, pbKey.HasLifetime)
	assert.Equal(t, int32(3600), pbKey.LifetimeSeconds)
	assert.True(t, pbKey.IsConfirm)
}

func TestToProtoAgentKey_NoLifetime(t *testing.T) {
	agentKey := &agent.AgentKey{
		Fingerprint: "SHA256:abc123",
		Comment:     "test comment",
		Type:        "ssh-ed25519",
		HasLifetime: false,
		IsConfirm:   false,
	}

	pbKey := toProtoAgentKey(agentKey)
	assert.False(t, pbKey.HasLifetime)
	assert.Equal(t, int32(0), pbKey.LifetimeSeconds)
	assert.False(t, pbKey.IsConfirm)
}

func TestNewAgentServiceAdapter(t *testing.T) {
	// Can't easily test without a real agent.Service
	// This test just verifies the constructor doesn't panic with nil
	adapter := NewAgentServiceAdapter(nil, nil)
	assert.NotNil(t, adapter)
	assert.Nil(t, adapter.service)
	assert.Nil(t, adapter.managedAgent)
}
