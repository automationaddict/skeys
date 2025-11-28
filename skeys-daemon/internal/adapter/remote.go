// Package adapter provides adapters between gRPC services and the core library.
package adapter

import (
	"context"
	"time"

	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
	"google.golang.org/protobuf/types/known/emptypb"
	"google.golang.org/protobuf/types/known/timestamppb"

	"github.com/johnnelson/skeys-core/remote"
	pb "github.com/johnnelson/skeys-daemon/api/gen/skeys/v1"
)

// RemoteServiceAdapter adapts the remote service to the gRPC RemoteService interface.
type RemoteServiceAdapter struct {
	pb.UnimplementedRemoteServiceServer
	pool            *remote.ConnectionPool
	agentSocketPath string
}

// NewRemoteServiceAdapter creates a new remote service adapter
func NewRemoteServiceAdapter(pool *remote.ConnectionPool, agentSocketPath string) *RemoteServiceAdapter {
	return &RemoteServiceAdapter{
		pool:            pool,
		agentSocketPath: agentSocketPath,
	}
}

// ListRemotes returns all saved remotes
func (a *RemoteServiceAdapter) ListRemotes(ctx context.Context, req *pb.ListRemotesRequest) (*pb.ListRemotesResponse, error) {
	// TODO: Implement remote storage - currently remotes are not persisted
	return &pb.ListRemotesResponse{Remotes: []*pb.Remote{}}, nil
}

// GetRemote returns a specific remote by ID
func (a *RemoteServiceAdapter) GetRemote(ctx context.Context, req *pb.GetRemoteRequest) (*pb.Remote, error) {
	// TODO: Implement remote storage
	return nil, status.Errorf(codes.Unimplemented, "method GetRemote not implemented")
}

// AddRemote saves a new remote configuration
func (a *RemoteServiceAdapter) AddRemote(ctx context.Context, req *pb.AddRemoteRequest) (*pb.Remote, error) {
	// TODO: Implement remote storage
	return nil, status.Errorf(codes.Unimplemented, "method AddRemote not implemented")
}

// UpdateRemote updates an existing remote configuration
func (a *RemoteServiceAdapter) UpdateRemote(ctx context.Context, req *pb.UpdateRemoteRequest) (*pb.Remote, error) {
	// TODO: Implement remote storage
	return nil, status.Errorf(codes.Unimplemented, "method UpdateRemote not implemented")
}

// DeleteRemote removes a saved remote configuration
func (a *RemoteServiceAdapter) DeleteRemote(ctx context.Context, req *pb.DeleteRemoteRequest) (*emptypb.Empty, error) {
	// TODO: Implement remote storage
	return nil, status.Errorf(codes.Unimplemented, "method DeleteRemote not implemented")
}

// TestConnection tests connectivity to a remote host with real SSH authentication
// and proper host key verification
func (a *RemoteServiceAdapter) TestConnection(ctx context.Context, req *pb.TestRemoteConnectionRequest) (*pb.TestRemoteConnectionResponse, error) {
	cfg := remote.ConnectionConfig{
		Host:           req.GetHost(),
		Port:           int(req.GetPort()),
		User:           req.GetUser(),
		AgentSocket:    a.agentSocketPath,
		PrivateKeyPath: req.GetIdentityFile(),
		TrustHostKey:   req.GetTrustHostKey(),
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
	// TODO: Look up remote by ID and create connection config
	// For now, this requires the remote storage to be implemented
	return nil, status.Errorf(codes.Unimplemented, "method Connect not implemented - requires remote storage")
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
		Host:           c.Host,
		Port:           int32(c.Port),
		User:           c.User,
		ServerVersion:  c.ServerVersion,
		ConnectedAt:    timestamppb.New(c.ConnectedAt),
		LastActivityAt: timestamppb.New(c.LastActivityAt),
	}
}
