// Package adapter provides adapters between gRPC services and the core library.
package adapter

import (
	"context"

	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
	"google.golang.org/protobuf/types/known/emptypb"
	"google.golang.org/protobuf/types/known/timestamppb"

	"github.com/johnnelson/skeys-core/keys"
	pb "github.com/johnnelson/skeys-daemon/api/gen/skeys/v1"
)

// KeyServiceAdapter adapts the keys.Service to the gRPC KeyService interface.
type KeyServiceAdapter struct {
	pb.UnimplementedKeyServiceServer
	service *keys.Service
}

// NewKeyServiceAdapter creates a new key service adapter
func NewKeyServiceAdapter(service *keys.Service) *KeyServiceAdapter {
	return &KeyServiceAdapter{
		service: service,
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

// PushKeyToRemote pushes a key to a remote server
func (a *KeyServiceAdapter) PushKeyToRemote(ctx context.Context, req *pb.PushKeyToRemoteRequest) (*pb.PushKeyToRemoteResponse, error) {
	// TODO: Implement once remote functionality is wired up
	return nil, status.Errorf(codes.Unimplemented, "method PushKeyToRemote not implemented")
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
