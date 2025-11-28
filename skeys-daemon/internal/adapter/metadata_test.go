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
	"path/filepath"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	"github.com/johnnelson/skeys-core/storage"
	pb "github.com/johnnelson/skeys-daemon/api/gen/skeys/v1"
)

func createTestStore(t *testing.T) *storage.Store {
	tmpDir := t.TempDir()
	store, err := storage.NewStore(storage.WithDataDir(filepath.Join(tmpDir, "data")))
	require.NoError(t, err)
	return store
}

func TestNewMetadataServiceAdapter(t *testing.T) {
	store := createTestStore(t)
	adapter := NewMetadataServiceAdapter(store)
	require.NotNil(t, adapter)
	assert.Equal(t, store, adapter.store)
}

func TestMetadataServiceAdapter_GetKeyMetadata_NotFound(t *testing.T) {
	store := createTestStore(t)
	adapter := NewMetadataServiceAdapter(store)

	_, err := adapter.GetKeyMetadata(context.Background(), &pb.GetKeyMetadataRequest{
		KeyPath: "/nonexistent/key",
	})
	require.Error(t, err)

	st, ok := status.FromError(err)
	require.True(t, ok)
	assert.Equal(t, codes.NotFound, st.Code())
}

func TestMetadataServiceAdapter_GetKeyMetadata_EmptyPath(t *testing.T) {
	store := createTestStore(t)
	adapter := NewMetadataServiceAdapter(store)

	_, err := adapter.GetKeyMetadata(context.Background(), &pb.GetKeyMetadataRequest{
		KeyPath: "",
	})
	require.Error(t, err)

	st, ok := status.FromError(err)
	require.True(t, ok)
	assert.Equal(t, codes.InvalidArgument, st.Code())
}

func TestMetadataServiceAdapter_SetKeyMetadata(t *testing.T) {
	store := createTestStore(t)
	adapter := NewMetadataServiceAdapter(store)

	// Set metadata
	_, err := adapter.SetKeyMetadata(context.Background(), &pb.SetKeyMetadataRequest{
		Metadata: &pb.KeyMetadata{
			KeyPath:         "/home/user/.ssh/id_ed25519",
			VerifiedService: "github.com",
			VerifiedHost:    "github.com",
			VerifiedPort:    22,
			VerifiedUser:    "git",
		},
	})
	require.NoError(t, err)

	// Get it back
	resp, err := adapter.GetKeyMetadata(context.Background(), &pb.GetKeyMetadataRequest{
		KeyPath: "/home/user/.ssh/id_ed25519",
	})
	require.NoError(t, err)
	assert.Equal(t, "/home/user/.ssh/id_ed25519", resp.KeyPath)
	assert.Equal(t, "github.com", resp.VerifiedService)
	assert.Equal(t, "github.com", resp.VerifiedHost)
	assert.Equal(t, int32(22), resp.VerifiedPort)
	assert.Equal(t, "git", resp.VerifiedUser)
}

func TestMetadataServiceAdapter_SetKeyMetadata_NilMetadata(t *testing.T) {
	store := createTestStore(t)
	adapter := NewMetadataServiceAdapter(store)

	_, err := adapter.SetKeyMetadata(context.Background(), &pb.SetKeyMetadataRequest{
		Metadata: nil,
	})
	require.Error(t, err)

	st, ok := status.FromError(err)
	require.True(t, ok)
	assert.Equal(t, codes.InvalidArgument, st.Code())
}

func TestMetadataServiceAdapter_SetKeyMetadata_EmptyKeyPath(t *testing.T) {
	store := createTestStore(t)
	adapter := NewMetadataServiceAdapter(store)

	_, err := adapter.SetKeyMetadata(context.Background(), &pb.SetKeyMetadataRequest{
		Metadata: &pb.KeyMetadata{
			KeyPath:         "",
			VerifiedService: "github.com",
		},
	})
	require.Error(t, err)

	st, ok := status.FromError(err)
	require.True(t, ok)
	assert.Equal(t, codes.InvalidArgument, st.Code())
}

func TestMetadataServiceAdapter_DeleteKeyMetadata(t *testing.T) {
	store := createTestStore(t)
	adapter := NewMetadataServiceAdapter(store)

	// Set metadata first
	_, err := adapter.SetKeyMetadata(context.Background(), &pb.SetKeyMetadataRequest{
		Metadata: &pb.KeyMetadata{
			KeyPath:         "/home/user/.ssh/id_ed25519",
			VerifiedService: "github.com",
		},
	})
	require.NoError(t, err)

	// Delete it
	_, err = adapter.DeleteKeyMetadata(context.Background(), &pb.DeleteKeyMetadataRequest{
		KeyPath: "/home/user/.ssh/id_ed25519",
	})
	require.NoError(t, err)

	// Verify it's gone
	_, err = adapter.GetKeyMetadata(context.Background(), &pb.GetKeyMetadataRequest{
		KeyPath: "/home/user/.ssh/id_ed25519",
	})
	require.Error(t, err)
	st, _ := status.FromError(err)
	assert.Equal(t, codes.NotFound, st.Code())
}

func TestMetadataServiceAdapter_DeleteKeyMetadata_EmptyPath(t *testing.T) {
	store := createTestStore(t)
	adapter := NewMetadataServiceAdapter(store)

	_, err := adapter.DeleteKeyMetadata(context.Background(), &pb.DeleteKeyMetadataRequest{
		KeyPath: "",
	})
	require.Error(t, err)

	st, ok := status.FromError(err)
	require.True(t, ok)
	assert.Equal(t, codes.InvalidArgument, st.Code())
}

func TestMetadataServiceAdapter_ListKeyMetadata_Empty(t *testing.T) {
	store := createTestStore(t)
	adapter := NewMetadataServiceAdapter(store)

	resp, err := adapter.ListKeyMetadata(context.Background(), &pb.ListKeyMetadataRequest{})
	require.NoError(t, err)
	assert.Empty(t, resp.Metadata)
}

func TestMetadataServiceAdapter_ListKeyMetadata(t *testing.T) {
	store := createTestStore(t)
	adapter := NewMetadataServiceAdapter(store)

	// Add some metadata
	_, err := adapter.SetKeyMetadata(context.Background(), &pb.SetKeyMetadataRequest{
		Metadata: &pb.KeyMetadata{
			KeyPath:         "/home/user/.ssh/id_ed25519",
			VerifiedService: "github.com",
		},
	})
	require.NoError(t, err)

	_, err = adapter.SetKeyMetadata(context.Background(), &pb.SetKeyMetadataRequest{
		Metadata: &pb.KeyMetadata{
			KeyPath:         "/home/user/.ssh/id_rsa",
			VerifiedService: "gitlab.com",
		},
	})
	require.NoError(t, err)

	// List all
	resp, err := adapter.ListKeyMetadata(context.Background(), &pb.ListKeyMetadataRequest{})
	require.NoError(t, err)
	assert.Len(t, resp.Metadata, 2)
}

func TestToProtoKeyMetadata(t *testing.T) {
	meta := &storage.KeyMetadata{
		KeyPath:         "/home/user/.ssh/id_ed25519",
		VerifiedService: "github.com",
		VerifiedHost:    "github.com",
		VerifiedPort:    22,
		VerifiedUser:    "git",
	}

	pb := toProtoKeyMetadata(meta)
	require.NotNil(t, pb)
	assert.Equal(t, "/home/user/.ssh/id_ed25519", pb.KeyPath)
	assert.Equal(t, "github.com", pb.VerifiedService)
	assert.Equal(t, "github.com", pb.VerifiedHost)
	assert.Equal(t, int32(22), pb.VerifiedPort)
	assert.Equal(t, "git", pb.VerifiedUser)
}

func TestToProtoKeyMetadata_Nil(t *testing.T) {
	pb := toProtoKeyMetadata(nil)
	assert.Nil(t, pb)
}

func TestFromProtoKeyMetadata(t *testing.T) {
	pbMeta := &pb.KeyMetadata{
		KeyPath:         "/home/user/.ssh/id_ed25519",
		VerifiedService: "github.com",
		VerifiedHost:    "github.com",
		VerifiedPort:    22,
		VerifiedUser:    "git",
	}

	meta := fromProtoKeyMetadata(pbMeta)
	require.NotNil(t, meta)
	assert.Equal(t, "/home/user/.ssh/id_ed25519", meta.KeyPath)
	assert.Equal(t, "github.com", meta.VerifiedService)
	assert.Equal(t, "github.com", meta.VerifiedHost)
	assert.Equal(t, 22, meta.VerifiedPort)
	assert.Equal(t, "git", meta.VerifiedUser)
}

func TestFromProtoKeyMetadata_Nil(t *testing.T) {
	meta := fromProtoKeyMetadata(nil)
	assert.Nil(t, meta)
}
