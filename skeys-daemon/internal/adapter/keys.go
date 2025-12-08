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

// Package adapter provides adapters between gRPC services and the core library.
package adapter

import (
	"context"
	"fmt"
	"strings"

	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
	"google.golang.org/protobuf/types/known/emptypb"
	"google.golang.org/protobuf/types/known/timestamppb"

	"github.com/automationaddict/skeys-core/keys"
	"github.com/automationaddict/skeys-core/remote"
	pb "github.com/automationaddict/skeys-daemon/api/gen/skeys/v1"
)

// KeyServiceAdapter adapts the keys.Service to the gRPC KeyService interface.
type KeyServiceAdapter struct {
	pb.UnimplementedKeyServiceServer
	service *keys.Service
	pool    *remote.ConnectionPool
}

// NewKeyServiceAdapter creates a new key service adapter
func NewKeyServiceAdapter(service *keys.Service, pool *remote.ConnectionPool) *KeyServiceAdapter {
	return &KeyServiceAdapter{
		service: service,
		pool:    pool,
	}
}

// ListKeys returns all SSH keys
func (a *KeyServiceAdapter) ListKeys(ctx context.Context, req *pb.ListKeysRequest) (*pb.ListKeysResponse, error) {
	keyList, err := a.service.List(ctx)
	if err != nil {
		return nil, status.Errorf(codes.Internal, "failed to list keys: %v", err)
	}

	var pbKeys []*pb.SSHKey
	for _, k := range keyList {
		pbKeys = append(pbKeys, toProtoKey(k))
	}

	return &pb.ListKeysResponse{Keys: pbKeys}, nil
}

// GetKey returns a specific key by ID
func (a *KeyServiceAdapter) GetKey(ctx context.Context, req *pb.GetKeyRequest) (*pb.SSHKey, error) {
	key, err := a.service.Get(ctx, req.GetKeyId())
	if err != nil {
		return nil, status.Errorf(codes.NotFound, "key not found: %v", err)
	}

	return toProtoKey(key), nil
}

// GenerateKey creates a new SSH key pair
func (a *KeyServiceAdapter) GenerateKey(ctx context.Context, req *pb.GenerateKeyRequest) (*pb.SSHKey, error) {
	opts := keys.GenerateOptions{
		Name:       req.GetName(),
		Type:       fromProtoKeyType(req.GetType()),
		Bits:       int(req.GetBits()),
		Comment:    req.GetComment(),
		Passphrase: req.GetPassphrase(),
	}

	key, err := a.service.Generate(ctx, opts)
	if err != nil {
		return nil, status.Errorf(codes.Internal, "failed to generate key: %v", err)
	}

	return toProtoKey(key), nil
}

// DeleteKey removes an SSH key pair
func (a *KeyServiceAdapter) DeleteKey(ctx context.Context, req *pb.DeleteKeyRequest) (*emptypb.Empty, error) {
	if err := a.service.Delete(ctx, req.GetKeyId()); err != nil {
		return nil, status.Errorf(codes.Internal, "failed to delete key: %v", err)
	}

	return &emptypb.Empty{}, nil
}

// GetFingerprint returns the fingerprint of a key
func (a *KeyServiceAdapter) GetFingerprint(ctx context.Context, req *pb.GetFingerprintRequest) (*pb.GetFingerprintResponse, error) {
	algorithm := "sha256"
	if req.GetAlgorithm() == pb.FingerprintAlgorithm_FINGERPRINT_ALGORITHM_MD5 {
		algorithm = "md5"
	}

	fingerprint, err := a.service.Fingerprint(ctx, req.GetKeyId(), algorithm)
	if err != nil {
		return nil, status.Errorf(codes.Internal, "failed to get fingerprint: %v", err)
	}

	return &pb.GetFingerprintResponse{Fingerprint: fingerprint}, nil
}

// ChangePassphrase changes the passphrase of an existing key
func (a *KeyServiceAdapter) ChangePassphrase(ctx context.Context, req *pb.ChangePassphraseRequest) (*emptypb.Empty, error) {
	if err := a.service.ChangePassphrase(ctx, req.GetKeyId(), req.GetOldPassphrase(), req.GetNewPassphrase()); err != nil {
		return nil, status.Errorf(codes.Internal, "failed to change passphrase: %v", err)
	}

	return &emptypb.Empty{}, nil
}

// PushKeyToRemote pushes a key to a remote server's authorized_keys file.
// This works similar to ssh-copy-id, but uses an existing connection.
func (a *KeyServiceAdapter) PushKeyToRemote(ctx context.Context, req *pb.PushKeyToRemoteRequest) (*pb.PushKeyToRemoteResponse, error) {
	if req.GetKeyId() == "" {
		return nil, status.Error(codes.InvalidArgument, "key_id is required")
	}
	if req.GetRemoteId() == "" {
		return nil, status.Error(codes.InvalidArgument, "remote_id is required")
	}

	// Find a connection for this remote
	conn := a.findConnectionByRemoteID(req.GetRemoteId())
	if conn == nil {
		return nil, status.Errorf(codes.FailedPrecondition, "no active connection to remote %s", req.GetRemoteId())
	}

	// Get the public key content by looking up the key by fingerprint
	publicKey, err := a.getPublicKeyByFingerprint(ctx, req.GetKeyId())
	if err != nil {
		return nil, status.Errorf(codes.NotFound, "key not found: %v", err)
	}

	// Ensure public key ends with newline
	publicKey = strings.TrimSpace(publicKey) + "\n"

	// Execute ssh-copy-id style commands:
	// 1. Create ~/.ssh directory if it doesn't exist (with correct permissions)
	// 2. Create authorized_keys if it doesn't exist
	// 3. Check if key already exists (avoid duplicates)
	// 4. Append the key

	// Escape the public key for use in shell commands
	escapedKey := strings.ReplaceAll(publicKey, "'", "'\"'\"'")

	// Combined command that handles all cases
	// Uses printf to avoid echo interpretation issues
	script := fmt.Sprintf(`
mkdir -p ~/.ssh && chmod 700 ~/.ssh
touch ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys
KEY='%s'
if grep -qF "$KEY" ~/.ssh/authorized_keys 2>/dev/null; then
    echo "Key already exists in authorized_keys"
else
    printf '%%s' "$KEY" >> ~/.ssh/authorized_keys
    echo "Key added to authorized_keys"
fi
`, strings.TrimSpace(escapedKey))

	stdout, stderr, err := conn.Execute(ctx, script)
	if err != nil {
		errMsg := string(stderr)
		if errMsg == "" {
			errMsg = err.Error()
		}
		return &pb.PushKeyToRemoteResponse{
			Success: false,
			Message: fmt.Sprintf("failed to push key: %s", errMsg),
		}, nil
	}

	// Parse the output to determine what happened
	output := strings.TrimSpace(string(stdout))
	if strings.Contains(output, "Key already exists") {
		return &pb.PushKeyToRemoteResponse{
			Success: true,
			Message: "Key already exists in authorized_keys",
		}, nil
	}

	return &pb.PushKeyToRemoteResponse{
		Success: true,
		Message: "Key added to authorized_keys",
	}, nil
}

// findConnectionByRemoteID finds an active connection for the given remote ID
func (a *KeyServiceAdapter) findConnectionByRemoteID(remoteID string) *remote.Connection {
	if a.pool == nil {
		return nil
	}

	connections := a.pool.List()
	for _, conn := range connections {
		if conn.RemoteID == remoteID {
			return conn
		}
	}
	return nil
}

// getPublicKeyByFingerprint looks up a key by its fingerprint and returns the public key content
func (a *KeyServiceAdapter) getPublicKeyByFingerprint(ctx context.Context, fingerprint string) (string, error) {
	// List all keys and find one matching the fingerprint
	keyList, err := a.service.List(ctx)
	if err != nil {
		return "", fmt.Errorf("failed to list keys: %w", err)
	}

	for _, key := range keyList {
		// Match by SHA256 fingerprint (with or without prefix)
		fpClean := strings.TrimPrefix(fingerprint, "SHA256:")
		keyFpClean := strings.TrimPrefix(key.FingerprintSHA256, "SHA256:")
		if fpClean == keyFpClean {
			return key.PublicKey, nil
		}
	}

	return "", fmt.Errorf("key with fingerprint %s not found", fingerprint)
}

// toProtoKey converts a core Key to a proto SSHKey
func toProtoKey(k *keys.Key) *pb.SSHKey {
	return &pb.SSHKey{
		Id:                k.ID,
		Name:              k.Name,
		PrivateKeyPath:    k.PrivateKeyPath,
		PublicKeyPath:     k.PublicKeyPath,
		Type:              toProtoKeyType(k.Type),
		Bits:              int32(k.Bits),
		Comment:           k.Comment,
		FingerprintSha256: k.FingerprintSHA256,
		FingerprintMd5:    k.FingerprintMD5,
		PublicKey:         k.PublicKey,
		HasPassphrase:     k.HasPassphrase,
		InAgent:           k.InAgent,
		CreatedAt:         timestamppb.New(k.CreatedAt),
		ModifiedAt:        timestamppb.New(k.ModifiedAt),
	}
}

// toProtoKeyType converts a core KeyType to a proto KeyType
func toProtoKeyType(t keys.KeyType) pb.KeyType {
	switch t {
	case keys.KeyTypeRSA:
		return pb.KeyType_KEY_TYPE_RSA
	case keys.KeyTypeED25519:
		return pb.KeyType_KEY_TYPE_ED25519
	case keys.KeyTypeECDSA:
		return pb.KeyType_KEY_TYPE_ECDSA
	case keys.KeyTypeED25519SK:
		return pb.KeyType_KEY_TYPE_ED25519_SK
	case keys.KeyTypeECDSASK:
		return pb.KeyType_KEY_TYPE_ECDSA_SK
	default:
		return pb.KeyType_KEY_TYPE_UNSPECIFIED
	}
}

// fromProtoKeyType converts a proto KeyType to a core KeyType
func fromProtoKeyType(t pb.KeyType) keys.KeyType {
	switch t {
	case pb.KeyType_KEY_TYPE_RSA:
		return keys.KeyTypeRSA
	case pb.KeyType_KEY_TYPE_ED25519:
		return keys.KeyTypeED25519
	case pb.KeyType_KEY_TYPE_ECDSA:
		return keys.KeyTypeECDSA
	case pb.KeyType_KEY_TYPE_ED25519_SK:
		return keys.KeyTypeED25519SK
	case pb.KeyType_KEY_TYPE_ECDSA_SK:
		return keys.KeyTypeECDSASK
	default:
		return keys.KeyTypeED25519
	}
}

// WatchKeys streams key list updates to the client whenever keys change.
// Uses filesystem watching to detect changes efficiently.
func (a *KeyServiceAdapter) WatchKeys(req *pb.WatchKeysRequest, stream pb.KeyService_WatchKeysServer) error {
	ctx := stream.Context()

	// Use the core service's Watch method which uses fsnotify
	updates := a.service.Watch(ctx)

	for update := range updates {
		if update.Err != nil {
			return status.Errorf(codes.Internal, "watch error: %v", update.Err)
		}

		var pbKeys []*pb.SSHKey
		for _, k := range update.Keys {
			pbKeys = append(pbKeys, toProtoKey(k))
		}

		if err := stream.Send(&pb.ListKeysResponse{Keys: pbKeys}); err != nil {
			return err
		}
	}

	return nil
}
