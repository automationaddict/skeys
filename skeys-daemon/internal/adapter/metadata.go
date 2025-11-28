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

	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
	"google.golang.org/protobuf/types/known/emptypb"

	"github.com/johnnelson/skeys-core/storage"
	pb "github.com/johnnelson/skeys-daemon/api/gen/skeys/v1"
)

// MetadataServiceAdapter adapts the storage.Store to the gRPC MetadataService interface.
type MetadataServiceAdapter struct {
	pb.UnimplementedMetadataServiceServer
	store *storage.Store
}

// NewMetadataServiceAdapter creates a new metadata service adapter
func NewMetadataServiceAdapter(store *storage.Store) *MetadataServiceAdapter {
	return &MetadataServiceAdapter{
		store: store,
	}
}

// GetKeyMetadata retrieves metadata for a specific key
func (a *MetadataServiceAdapter) GetKeyMetadata(ctx context.Context, req *pb.GetKeyMetadataRequest) (*pb.KeyMetadata, error) {
	if req.GetKeyPath() == "" {
		return nil, status.Error(codes.InvalidArgument, "key_path is required")
	}

	meta := a.store.GetKeyMetadata(req.GetKeyPath())
	if meta == nil {
		return nil, status.Errorf(codes.NotFound, "no metadata found for key: %s", req.GetKeyPath())
	}

	return toProtoKeyMetadata(meta), nil
}

// SetKeyMetadata stores metadata for a key
func (a *MetadataServiceAdapter) SetKeyMetadata(ctx context.Context, req *pb.SetKeyMetadataRequest) (*emptypb.Empty, error) {
	if req.GetMetadata() == nil {
		return nil, status.Error(codes.InvalidArgument, "metadata is required")
	}

	meta := fromProtoKeyMetadata(req.GetMetadata())
	if meta.KeyPath == "" {
		return nil, status.Error(codes.InvalidArgument, "key_path is required")
	}

	if err := a.store.SetKeyMetadata(meta); err != nil {
		return nil, status.Errorf(codes.Internal, "failed to store metadata: %v", err)
	}

	return &emptypb.Empty{}, nil
}

// DeleteKeyMetadata removes metadata for a key
func (a *MetadataServiceAdapter) DeleteKeyMetadata(ctx context.Context, req *pb.DeleteKeyMetadataRequest) (*emptypb.Empty, error) {
	if req.GetKeyPath() == "" {
		return nil, status.Error(codes.InvalidArgument, "key_path is required")
	}

	if err := a.store.DeleteKeyMetadata(req.GetKeyPath()); err != nil {
		return nil, status.Errorf(codes.Internal, "failed to delete metadata: %v", err)
	}

	return &emptypb.Empty{}, nil
}

// ListKeyMetadata returns all stored key metadata
func (a *MetadataServiceAdapter) ListKeyMetadata(ctx context.Context, req *pb.ListKeyMetadataRequest) (*pb.ListKeyMetadataResponse, error) {
	metaList := a.store.ListKeyMetadata()

	var pbMeta []*pb.KeyMetadata
	for _, m := range metaList {
		pbMeta = append(pbMeta, toProtoKeyMetadata(m))
	}

	return &pb.ListKeyMetadataResponse{Metadata: pbMeta}, nil
}

// toProtoKeyMetadata converts a storage.KeyMetadata to protobuf
func toProtoKeyMetadata(m *storage.KeyMetadata) *pb.KeyMetadata {
	if m == nil {
		return nil
	}
	return &pb.KeyMetadata{
		KeyPath:         m.KeyPath,
		VerifiedService: m.VerifiedService,
		VerifiedHost:    m.VerifiedHost,
		VerifiedPort:    int32(m.VerifiedPort),
		VerifiedUser:    m.VerifiedUser,
	}
}

// fromProtoKeyMetadata converts a protobuf KeyMetadata to storage.KeyMetadata
func fromProtoKeyMetadata(m *pb.KeyMetadata) *storage.KeyMetadata {
	if m == nil {
		return nil
	}
	return &storage.KeyMetadata{
		KeyPath:         m.GetKeyPath(),
		VerifiedService: m.GetVerifiedService(),
		VerifiedHost:    m.GetVerifiedHost(),
		VerifiedPort:    int(m.GetVerifiedPort()),
		VerifiedUser:    m.GetVerifiedUser(),
	}
}
