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
	pool *remote.ConnectionPool
}

// NewRemoteServiceAdapter creates a new remote service adapter
func NewRemoteServiceAdapter(pool *remote.ConnectionPool) *RemoteServiceAdapter {
	return &RemoteServiceAdapter{
		pool: pool,
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

// TestConnection tests connectivity to a remote host
func (a *RemoteServiceAdapter) TestConnection(ctx context.Context, req *pb.TestRemoteConnectionRequest) (*pb.TestRemoteConnectionResponse, error) {
	cfg := remote.ConnectionConfig{
		Host: req.GetHost(),
		Port: int(req.GetPort()),
		User: req.GetUser(),
	}

	if cfg.Port == 0 {
		cfg.Port = 22
	}

	if req.GetTimeoutSeconds() > 0 {
		cfg.Timeout = time.Duration(req.GetTimeoutSeconds()) * time.Second
	}

	start := time.Now()
	err := remote.TestConnection(ctx, cfg)
	latency := time.Since(start).Milliseconds()

	if err != nil {
		return &pb.TestRemoteConnectionResponse{
			Success:   false,
			Message:   err.Error(),
			LatencyMs: int32(latency),
		}, nil
	}

	return &pb.TestRemoteConnectionResponse{
		Success:   true,
		Message:   "Connection successful",
		LatencyMs: int32(latency),
	}, nil
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
