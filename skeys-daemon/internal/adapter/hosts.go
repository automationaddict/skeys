// Package adapter provides adapters between gRPC services and the core library.
package adapter

import (
	"context"
	"strconv"

	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
	"google.golang.org/protobuf/types/known/emptypb"

	"github.com/johnnelson/skeys-core/hosts"
	pb "github.com/johnnelson/skeys-daemon/api/gen/skeys/v1"
)

// HostsServiceAdapter adapts the hosts services to the gRPC HostsService interface.
type HostsServiceAdapter struct {
	pb.UnimplementedHostsServiceServer
	knownHosts     *hosts.KnownHostsManager
	authorizedKeys *hosts.AuthorizedKeysManager
}

// NewHostsServiceAdapter creates a new hosts service adapter
func NewHostsServiceAdapter(kh *hosts.KnownHostsManager, ak *hosts.AuthorizedKeysManager) *HostsServiceAdapter {
	return &HostsServiceAdapter{
		knownHosts:     kh,
		authorizedKeys: ak,
	}
}

// WatchKnownHosts streams known_hosts updates when changes are detected.
func (a *HostsServiceAdapter) WatchKnownHosts(req *pb.WatchKnownHostsRequest, stream pb.HostsService_WatchKnownHostsServer) error {
	ctx := stream.Context()

	// Use the core service's Watch method which polls for changes
	updates := a.knownHosts.Watch(ctx)

	for update := range updates {
		if update.Err != nil {
			return status.Errorf(codes.Internal, "watch error: %v", update.Err)
		}

		var pbHosts []*pb.KnownHost
		for _, h := range update.Hosts {
			pbHosts = append(pbHosts, toProtoKnownHost(h))
		}

		resp := &pb.ListKnownHostsResponse{Hosts: pbHosts}
		if err := stream.Send(resp); err != nil {
			return err
		}
	}

	return nil
}

// ListKnownHosts returns all entries in known_hosts
func (a *HostsServiceAdapter) ListKnownHosts(ctx context.Context, req *pb.ListKnownHostsRequest) (*pb.ListKnownHostsResponse, error) {
	hostList, err := a.knownHosts.List()
	if err != nil {
		return nil, status.Errorf(codes.Internal, "failed to list known hosts: %v", err)
	}

	var pbHosts []*pb.KnownHost
	for _, h := range hostList {
		pbHosts = append(pbHosts, toProtoKnownHost(h))
	}

	return &pb.ListKnownHostsResponse{Hosts: pbHosts}, nil
}

// GetKnownHost looks up entries for a specific hostname
func (a *HostsServiceAdapter) GetKnownHost(ctx context.Context, req *pb.GetKnownHostRequest) (*pb.GetKnownHostResponse, error) {
	hostname := req.GetHostname()
	if req.GetPort() != 0 && req.GetPort() != 22 {
		hostname = "[" + hostname + "]:" + strconv.Itoa(int(req.GetPort()))
	}

	hostList, err := a.knownHosts.Lookup(ctx, hostname)
	if err != nil {
		return nil, status.Errorf(codes.Internal, "failed to lookup known host: %v", err)
	}

	var pbHosts []*pb.KnownHost
	for _, h := range hostList {
		pbHosts = append(pbHosts, toProtoKnownHost(h))
	}

	return &pb.GetKnownHostResponse{Hosts: pbHosts}, nil
}

// RemoveKnownHost removes a host from known_hosts
func (a *HostsServiceAdapter) RemoveKnownHost(ctx context.Context, req *pb.RemoveKnownHostRequest) (*emptypb.Empty, error) {
	hostname := req.GetHostname()
	if req.GetPort() != 0 && req.GetPort() != 22 {
		hostname = "[" + hostname + "]:" + strconv.Itoa(int(req.GetPort()))
	}

	if err := a.knownHosts.Remove(ctx, hostname); err != nil {
		return nil, status.Errorf(codes.Internal, "failed to remove known host: %v", err)
	}

	return &emptypb.Empty{}, nil
}

// HashKnownHosts hashes all hostnames in known_hosts
func (a *HostsServiceAdapter) HashKnownHosts(ctx context.Context, req *pb.HashKnownHostsRequest) (*emptypb.Empty, error) {
	if err := a.knownHosts.Hash(ctx); err != nil {
		return nil, status.Errorf(codes.Internal, "failed to hash known hosts: %v", err)
	}

	return &emptypb.Empty{}, nil
}

// ScanHostKeys scans a remote host and returns its public keys
func (a *HostsServiceAdapter) ScanHostKeys(ctx context.Context, req *pb.ScanHostKeysRequest) (*pb.ScanHostKeysResponse, error) {
	hostname := req.GetHostname()
	if hostname == "" {
		return nil, status.Errorf(codes.InvalidArgument, "hostname is required")
	}

	port := int(req.GetPort())
	timeout := int(req.GetTimeoutSeconds())

	keys, err := a.knownHosts.ScanHostKeys(ctx, hostname, port, timeout)
	if err != nil {
		return nil, status.Errorf(codes.Internal, "failed to scan host keys: %v", err)
	}

	var pbKeys []*pb.ScannedHostKey
	for _, k := range keys {
		pbKeys = append(pbKeys, &pb.ScannedHostKey{
			Hostname:    k.Hostname,
			Port:        int32(k.Port),
			KeyType:     k.KeyType,
			PublicKey:   k.PublicKey,
			Fingerprint: k.Fingerprint,
		})
	}

	return &pb.ScanHostKeysResponse{Keys: pbKeys}, nil
}

// AddKnownHost adds a new host key to known_hosts
func (a *HostsServiceAdapter) AddKnownHost(ctx context.Context, req *pb.AddKnownHostRequest) (*pb.KnownHost, error) {
	hostname := req.GetHostname()
	if hostname == "" {
		return nil, status.Errorf(codes.InvalidArgument, "hostname is required")
	}
	keyType := req.GetKeyType()
	if keyType == "" {
		return nil, status.Errorf(codes.InvalidArgument, "key_type is required")
	}
	publicKey := req.GetPublicKey()
	if publicKey == "" {
		return nil, status.Errorf(codes.InvalidArgument, "public_key is required")
	}

	port := int(req.GetPort())
	hashHostname := req.GetHashHostname()

	host, err := a.knownHosts.Add(ctx, hostname, port, keyType, publicKey, hashHostname)
	if err != nil {
		return nil, status.Errorf(codes.Internal, "failed to add known host: %v", err)
	}

	return toProtoKnownHost(host), nil
}

// WatchAuthorizedKeys streams authorized_keys updates when changes are detected.
func (a *HostsServiceAdapter) WatchAuthorizedKeys(req *pb.WatchAuthorizedKeysRequest, stream pb.HostsService_WatchAuthorizedKeysServer) error {
	ctx := stream.Context()

	// Use the core service's Watch method which polls for changes
	updates := a.authorizedKeys.Watch(ctx)

	for update := range updates {
		if update.Err != nil {
			return status.Errorf(codes.Internal, "watch error: %v", update.Err)
		}

		var pbKeys []*pb.AuthorizedKey
		for _, k := range update.Keys {
			pbKeys = append(pbKeys, toProtoAuthorizedKey(k))
		}

		resp := &pb.ListAuthorizedKeysResponse{Keys: pbKeys}
		if err := stream.Send(resp); err != nil {
			return err
		}
	}

	return nil
}

// ListAuthorizedKeys returns all keys in authorized_keys
func (a *HostsServiceAdapter) ListAuthorizedKeys(ctx context.Context, req *pb.ListAuthorizedKeysRequest) (*pb.ListAuthorizedKeysResponse, error) {
	keyList, err := a.authorizedKeys.List()
	if err != nil {
		return nil, status.Errorf(codes.Internal, "failed to list authorized keys: %v", err)
	}

	var pbKeys []*pb.AuthorizedKey
	for _, k := range keyList {
		pbKeys = append(pbKeys, toProtoAuthorizedKey(k))
	}

	return &pb.ListAuthorizedKeysResponse{Keys: pbKeys}, nil
}

// AddAuthorizedKey adds a new key to authorized_keys
func (a *HostsServiceAdapter) AddAuthorizedKey(ctx context.Context, req *pb.AddAuthorizedKeyRequest) (*pb.AuthorizedKey, error) {
	if err := a.authorizedKeys.Add(req.GetPublicKey(), req.GetOptions()); err != nil {
		return nil, status.Errorf(codes.Internal, "failed to add authorized key: %v", err)
	}

	// Get the newly added key (last entry)
	keyList, err := a.authorizedKeys.List()
	if err != nil {
		return nil, status.Errorf(codes.Internal, "failed to get added key: %v", err)
	}

	if len(keyList) == 0 {
		return nil, status.Errorf(codes.Internal, "no keys found after adding")
	}

	return toProtoAuthorizedKey(keyList[len(keyList)-1]), nil
}

// UpdateAuthorizedKey updates key options
func (a *HostsServiceAdapter) UpdateAuthorizedKey(ctx context.Context, req *pb.UpdateAuthorizedKeyRequest) (*pb.AuthorizedKey, error) {
	lineNumber, err := strconv.Atoi(req.GetKeyId())
	if err != nil {
		return nil, status.Errorf(codes.InvalidArgument, "invalid key_id: must be a line number")
	}

	if err := a.authorizedKeys.Update(lineNumber, req.GetOptions()); err != nil {
		return nil, status.Errorf(codes.Internal, "failed to update authorized key: %v", err)
	}

	// Get the updated key
	keyList, err := a.authorizedKeys.List()
	if err != nil {
		return nil, status.Errorf(codes.Internal, "failed to get updated key: %v", err)
	}

	for _, k := range keyList {
		if k.LineNumber == lineNumber {
			return toProtoAuthorizedKey(k), nil
		}
	}

	return nil, status.Errorf(codes.NotFound, "key not found after update")
}

// RemoveAuthorizedKey removes a key from authorized_keys
func (a *HostsServiceAdapter) RemoveAuthorizedKey(ctx context.Context, req *pb.RemoveAuthorizedKeyRequest) (*emptypb.Empty, error) {
	lineNumber, err := strconv.Atoi(req.GetKeyId())
	if err != nil {
		return nil, status.Errorf(codes.InvalidArgument, "invalid key_id: must be a line number")
	}

	if err := a.authorizedKeys.Remove(lineNumber); err != nil {
		return nil, status.Errorf(codes.Internal, "failed to remove authorized key: %v", err)
	}

	return &emptypb.Empty{}, nil
}

// toProtoKnownHost converts a core KnownHost to a proto KnownHost
func toProtoKnownHost(h *hosts.KnownHost) *pb.KnownHost {
	return &pb.KnownHost{
		Id:              h.ID,
		Hostnames:       h.Hostnames,
		KeyType:         h.KeyType,
		Fingerprint:     h.Fingerprint,
		PublicKey:       h.PublicKey,
		IsHashed:        h.IsHashed,
		IsRevoked:       h.IsRevoked,
		IsCertAuthority: h.IsCertAuth,
		LineNumber:      int32(h.LineNumber),
	}
}

// toProtoAuthorizedKey converts a core AuthorizedKey to a proto AuthorizedKey
func toProtoAuthorizedKey(k *hosts.AuthorizedKey) *pb.AuthorizedKey {
	return &pb.AuthorizedKey{
		Id:          k.ID,
		KeyType:     k.KeyType,
		Fingerprint: k.Fingerprint,
		Comment:     k.Comment,
		PublicKey:   k.PublicKey,
		Options:     k.Options,
		LineNumber:  int32(k.LineNumber),
	}
}
