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
	"time"

	"github.com/google/uuid"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
	"google.golang.org/protobuf/types/known/emptypb"
	"google.golang.org/protobuf/types/known/timestamppb"

	"github.com/automationaddict/skeys-core/remote"
	"github.com/automationaddict/skeys-core/storage"
	pb "github.com/automationaddict/skeys-daemon/api/gen/skeys/v1"
)

// RemoteServiceAdapter adapts the remote service to the gRPC RemoteService interface.
type RemoteServiceAdapter struct {
	pb.UnimplementedRemoteServiceServer
	pool            *remote.ConnectionPool
	store           *storage.Store
	agentSocketPath string
}

// NewRemoteServiceAdapter creates a new remote service adapter
func NewRemoteServiceAdapter(pool *remote.ConnectionPool, store *storage.Store, agentSocketPath string) *RemoteServiceAdapter {
	return &RemoteServiceAdapter{
		pool:            pool,
		store:           store,
		agentSocketPath: agentSocketPath,
	}
}

// ListRemotes returns all saved remotes
func (a *RemoteServiceAdapter) ListRemotes(ctx context.Context, req *pb.ListRemotesRequest) (*pb.ListRemotesResponse, error) {
	remotes := a.store.ListRemoteServers()

	// Build a map of connected remote IDs
	connectedRemoteIDs := make(map[string]bool)
	for _, conn := range a.pool.List() {
		connectedRemoteIDs[conn.RemoteID] = true
	}

	var pbRemotes []*pb.Remote
	for _, r := range remotes {
		pbRemote := storageRemoteToProto(r)
		// Set status based on active connections
		if connectedRemoteIDs[r.ID] {
			pbRemote.Status = pb.RemoteStatus_REMOTE_STATUS_CONNECTED
		}
		pbRemotes = append(pbRemotes, pbRemote)
	}

	return &pb.ListRemotesResponse{Remotes: pbRemotes}, nil
}

// GetRemote returns a specific remote by ID
func (a *RemoteServiceAdapter) GetRemote(ctx context.Context, req *pb.GetRemoteRequest) (*pb.Remote, error) {
	if req.GetId() == "" {
		return nil, status.Error(codes.InvalidArgument, "id is required")
	}

	r := a.store.GetRemoteServer(req.GetId())
	if r == nil {
		return nil, status.Errorf(codes.NotFound, "remote not found: %s", req.GetId())
	}

	pbRemote := storageRemoteToProto(r)
	// Check if this remote has an active connection
	for _, conn := range a.pool.List() {
		if conn.RemoteID == r.ID {
			pbRemote.Status = pb.RemoteStatus_REMOTE_STATUS_CONNECTED
			break
		}
	}

	return pbRemote, nil
}

// AddRemote saves a new remote configuration
func (a *RemoteServiceAdapter) AddRemote(ctx context.Context, req *pb.AddRemoteRequest) (*pb.Remote, error) {
	if req.GetHost() == "" {
		return nil, status.Error(codes.InvalidArgument, "host is required")
	}
	if req.GetUser() == "" {
		return nil, status.Error(codes.InvalidArgument, "user is required")
	}

	port := int(req.GetPort())
	if port == 0 {
		port = 22
	}

	r := &storage.RemoteServer{
		ID:             uuid.New().String(),
		Name:           req.GetName(),
		Host:           req.GetHost(),
		Port:           port,
		User:           req.GetUser(),
		IdentityFile:   req.GetIdentityFile(),
		SSHConfigAlias: req.GetSshConfigAlias(),
		CreatedAt:      time.Now().Unix(),
	}

	if err := a.store.AddRemoteServer(r); err != nil {
		return nil, status.Errorf(codes.Internal, "failed to save remote: %v", err)
	}

	return storageRemoteToProto(r), nil
}

// UpdateRemote updates an existing remote configuration
func (a *RemoteServiceAdapter) UpdateRemote(ctx context.Context, req *pb.UpdateRemoteRequest) (*pb.Remote, error) {
	if req.GetId() == "" {
		return nil, status.Error(codes.InvalidArgument, "id is required")
	}

	existing := a.store.GetRemoteServer(req.GetId())
	if existing == nil {
		return nil, status.Errorf(codes.NotFound, "remote not found: %s", req.GetId())
	}

	port := int(req.GetPort())
	if port == 0 {
		port = 22
	}

	r := &storage.RemoteServer{
		ID:              req.GetId(),
		Name:            req.GetName(),
		Host:            req.GetHost(),
		Port:            port,
		User:            req.GetUser(),
		IdentityFile:    req.GetIdentityFile(),
		SSHConfigAlias:  req.GetSshConfigAlias(),
		CreatedAt:       existing.CreatedAt,
		LastConnectedAt: existing.LastConnectedAt,
	}

	if err := a.store.UpdateRemoteServer(r); err != nil {
		return nil, status.Errorf(codes.Internal, "failed to update remote: %v", err)
	}

	return storageRemoteToProto(r), nil
}

// DeleteRemote removes a saved remote configuration
func (a *RemoteServiceAdapter) DeleteRemote(ctx context.Context, req *pb.DeleteRemoteRequest) (*emptypb.Empty, error) {
	if req.GetId() == "" {
		return nil, status.Error(codes.InvalidArgument, "id is required")
	}

	if err := a.store.DeleteRemoteServer(req.GetId()); err != nil {
		return nil, status.Errorf(codes.Internal, "failed to delete remote: %v", err)
	}

	return &emptypb.Empty{}, nil
}

// storageRemoteToProto converts storage.RemoteServer to protobuf
func storageRemoteToProto(r *storage.RemoteServer) *pb.Remote {
	remote := &pb.Remote{
		Id:             r.ID,
		Name:           r.Name,
		Host:           r.Host,
		Port:           int32(r.Port),
		User:           r.User,
		IdentityFile:   r.IdentityFile,
		SshConfigAlias: r.SSHConfigAlias,
		CreatedAt:      timestamppb.New(time.Unix(r.CreatedAt, 0)),
		Status:         pb.RemoteStatus_REMOTE_STATUS_DISCONNECTED,
	}

	if r.LastConnectedAt > 0 {
		remote.LastConnectedAt = timestamppb.New(time.Unix(r.LastConnectedAt, 0))
	}

	return remote
}

// TestConnection tests connectivity to a remote host with real SSH authentication
// and proper host key verification
func (a *RemoteServiceAdapter) TestConnection(ctx context.Context, req *pb.TestRemoteConnectionRequest) (*pb.TestRemoteConnectionResponse, error) {
	cfg := remote.ConnectionConfig{
		Host:           req.GetHost(),
		Port:           int(req.GetPort()),
		User:           req.GetUser(),
		PrivateKeyPath: req.GetIdentityFile(),
		TrustHostKey:   req.GetTrustHostKey(),
		// Note: We intentionally don't set AgentSocket here.
		// TestConnection is typically called BEFORE adding a key to the agent,
		// so we should authenticate using the private key file directly with
		// the provided passphrase, not try to use the agent which may not have
		// the key yet.
	}

	if req.GetPassphrase() != "" {
		cfg.Passphrase = []byte(req.GetPassphrase())
	}

	if cfg.Port == 0 {
		cfg.Port = 22
	}

	if req.GetTimeoutSeconds() > 0 {
		cfg.Timeout = time.Duration(req.GetTimeoutSeconds()) * time.Second
	}

	result, err := remote.TestConnection(ctx, cfg)
	if err != nil {
		return nil, status.Errorf(codes.Internal, "test connection failed: %v", err)
	}

	// Build response with host key status
	resp := &pb.TestRemoteConnectionResponse{
		Success:       result.Success,
		Message:       result.Message,
		ServerVersion: result.ServerVersion,
		LatencyMs:     int32(result.LatencyMs),
		HostKeyStatus: toProtoHostKeyStatus(result.HostKeyStatus),
	}

	// Include host key info if available
	if result.HostKeyInfo != nil {
		resp.HostKeyInfo = &pb.HostKeyInfo{
			Hostname:    result.HostKeyInfo.Hostname,
			Port:        int32(result.HostKeyInfo.Port),
			KeyType:     result.HostKeyInfo.KeyType,
			Fingerprint: result.HostKeyInfo.Fingerprint,
			PublicKey:   result.HostKeyInfo.PublicKey,
		}
	}

	return resp, nil
}

// toProtoHostKeyStatus converts core HostKeyStatus to proto HostKeyStatus
func toProtoHostKeyStatus(s remote.HostKeyStatus) pb.HostKeyStatus {
	switch s {
	case remote.HostKeyStatusVerified:
		return pb.HostKeyStatus_HOST_KEY_STATUS_VERIFIED
	case remote.HostKeyStatusUnknown:
		return pb.HostKeyStatus_HOST_KEY_STATUS_UNKNOWN
	case remote.HostKeyStatusMismatch:
		return pb.HostKeyStatus_HOST_KEY_STATUS_MISMATCH
	case remote.HostKeyStatusAdded:
		return pb.HostKeyStatus_HOST_KEY_STATUS_ADDED
	default:
		return pb.HostKeyStatus_HOST_KEY_STATUS_UNSPECIFIED
	}
}

// Connect establishes a connection to a remote server
func (a *RemoteServiceAdapter) Connect(ctx context.Context, req *pb.ConnectRequest) (*pb.ConnectResponse, error) {
	if req.GetRemoteId() == "" {
		return nil, status.Error(codes.InvalidArgument, "remote_id is required")
	}

	// Look up the remote configuration
	r := a.store.GetRemoteServer(req.GetRemoteId())
	if r == nil {
		return nil, status.Errorf(codes.NotFound, "remote not found: %s", req.GetRemoteId())
	}

	// Build connection config
	cfg := remote.ConnectionConfig{
		Host:           r.Host,
		Port:           r.Port,
		User:           r.User,
		AgentSocket:    a.agentSocketPath,
		PrivateKeyPath: r.IdentityFile,
		KeyFingerprint: req.GetKeyFingerprint(),
	}

	if req.GetPassphrase() != "" {
		cfg.Passphrase = []byte(req.GetPassphrase())
	}

	// Connect via the pool
	conn, err := a.pool.Connect(ctx, cfg)
	if err != nil {
		return nil, status.Errorf(codes.Internal, "failed to connect: %v", err)
	}

	// Update last connected time
	_ = a.store.UpdateRemoteServerLastConnected(r.ID, time.Now().Unix())

	// Set the remote ID on the connection for tracking
	conn.RemoteID = r.ID

	return &pb.ConnectResponse{
		Connection: toProtoConnection(conn),
	}, nil
}

// Disconnect closes an active connection
func (a *RemoteServiceAdapter) Disconnect(ctx context.Context, req *pb.DisconnectRequest) (*emptypb.Empty, error) {
	if err := a.pool.Disconnect(req.GetConnectionId()); err != nil {
		return nil, status.Errorf(codes.NotFound, "failed to disconnect: %v", err)
	}

	return &emptypb.Empty{}, nil
}

// ListConnections returns all active connections
func (a *RemoteServiceAdapter) ListConnections(ctx context.Context, req *pb.ListConnectionsRequest) (*pb.ListConnectionsResponse, error) {
	connList := a.pool.List()

	var pbConns []*pb.Connection
	for _, c := range connList {
		pbConns = append(pbConns, toProtoConnection(c))
	}

	return &pb.ListConnectionsResponse{Connections: pbConns}, nil
}

// WatchConnections streams connection updates to the client
func (a *RemoteServiceAdapter) WatchConnections(req *pb.WatchConnectionsRequest, stream pb.RemoteService_WatchConnectionsServer) error {
	ctx := stream.Context()
	updates := a.pool.Watch(ctx)

	for update := range updates {
		if update.Err != nil {
			return status.Errorf(codes.Internal, "failed to watch connections: %v", update.Err)
		}

		var pbConns []*pb.Connection
		for _, c := range update.Connections {
			pbConns = append(pbConns, toProtoConnection(c))
		}

		if err := stream.Send(&pb.ListConnectionsResponse{Connections: pbConns}); err != nil {
			return err
		}
	}

	return nil
}

// ExecuteCommand runs a command on a connected remote server
func (a *RemoteServiceAdapter) ExecuteCommand(ctx context.Context, req *pb.ExecuteCommandRequest) (*pb.ExecuteCommandResponse, error) {
	conn, err := a.pool.Get(req.GetConnectionId())
	if err != nil {
		return nil, status.Errorf(codes.NotFound, "connection not found: %v", err)
	}

	// Apply timeout if specified
	execCtx := ctx
	if req.GetTimeoutSeconds() > 0 {
		var cancel context.CancelFunc
		execCtx, cancel = context.WithTimeout(ctx, time.Duration(req.GetTimeoutSeconds())*time.Second)
		defer cancel()
	}

	stdout, stderr, err := conn.Execute(execCtx, req.GetCommand())

	// Determine exit code from error
	exitCode := 0
	if err != nil {
		// Try to extract exit code from error
		exitCode = 1
	}

	return &pb.ExecuteCommandResponse{
		ExitCode: int32(exitCode),
		Stdout:   string(stdout),
		Stderr:   string(stderr),
	}, nil
}

// toProtoConnection converts a core Connection to a proto Connection
func toProtoConnection(c *remote.Connection) *pb.Connection {
	return &pb.Connection{
		Id:             c.ID,
		RemoteId:       c.RemoteID,
		Host:           c.Host,
		Port:           int32(c.Port),
		User:           c.User,
		ServerVersion:  c.ServerVersion,
		ConnectedAt:    timestamppb.New(c.ConnectedAt),
		LastActivityAt: timestamppb.New(c.LastActivityAt),
	}
}
