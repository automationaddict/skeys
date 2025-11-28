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
	"context"
	"runtime"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
	"google.golang.org/protobuf/types/known/emptypb"

	skeyscore "github.com/automationaddict/skeys-core"
)

func TestNewVersionServiceAdapter(t *testing.T) {
	adapter := NewVersionServiceAdapter("1.0.0", "abc123")
	require.NotNil(t, adapter)
	assert.Equal(t, "1.0.0", adapter.version)
	assert.Equal(t, "abc123", adapter.commit)
}

func TestVersionServiceAdapter_GetVersion(t *testing.T) {
	adapter := NewVersionServiceAdapter("1.2.3", "def456")

	resp, err := adapter.GetVersion(context.Background(), &emptypb.Empty{})
	require.NoError(t, err)
	require.NotNil(t, resp)

	assert.Equal(t, "1.2.3", resp.DaemonVersion)
	assert.Equal(t, "def456", resp.DaemonCommit)
	assert.Equal(t, runtime.Version(), resp.GoVersion)
	assert.Equal(t, skeyscore.Version, resp.CoreVersion)
	assert.Equal(t, skeyscore.Commit, resp.CoreCommit)
}

func TestVersionServiceAdapter_GetVersion_EmptyValues(t *testing.T) {
	adapter := NewVersionServiceAdapter("", "")

	resp, err := adapter.GetVersion(context.Background(), &emptypb.Empty{})
	require.NoError(t, err)
	require.NotNil(t, resp)

	assert.Empty(t, resp.DaemonVersion)
	assert.Empty(t, resp.DaemonCommit)
	// Go version should still be populated
	assert.NotEmpty(t, resp.GoVersion)
}
