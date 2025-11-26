// Package adapter provides adapters between gRPC services and the core library.
package adapter

import (
	"context"

	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
	"google.golang.org/protobuf/types/known/emptypb"

	"github.com/johnnelson/skeys-core/agent"
	pb "github.com/johnnelson/skeys-daemon/api/gen/skeys/v1"
)

// AgentServiceAdapter adapts the agent service to the gRPC AgentService interface.
type AgentServiceAdapter struct {
	pb.UnimplementedAgentServiceServer
	service *agent.Service
}

// NewAgentServiceAdapter creates a new agent service adapter
func NewAgentServiceAdapter(service *agent.Service) *AgentServiceAdapter {
	return &AgentServiceAdapter{
		service: service,
	}
}

// GetAgentStatus returns the status of the SSH agent
func (a *AgentServiceAdapter) GetAgentStatus(ctx context.Context, req *pb.GetAgentStatusRequest) (*pb.GetAgentStatusResponse, error) {
	agentStatus, err := a.service.Status()
	if err != nil {
		return nil, status.Errorf(codes.Internal, "failed to get agent status: %v", err)
	}

	return &pb.GetAgentStatusResponse{
		Running:    agentStatus.Running,
		SocketPath: agentStatus.SocketPath,
		IsLocked:   agentStatus.IsLocked,
		KeyCount:   int32(agentStatus.KeyCount),
	}, nil
}

// ListAgentKeys returns all keys loaded in the agent
func (a *AgentServiceAdapter) ListAgentKeys(ctx context.Context, req *pb.ListAgentKeysRequest) (*pb.ListAgentKeysResponse, error) {
	keyList, err := a.service.ListKeys()
	if err != nil {
		return nil, status.Errorf(codes.Internal, "failed to list agent keys: %v", err)
	}

	var pbKeys []*pb.AgentKey
	for _, k := range keyList {
		pbKeys = append(pbKeys, toProtoAgentKey(k))
	}

	return &pb.ListAgentKeysResponse{Keys: pbKeys}, nil
}

// AddKeyToAgent adds a key to the agent
func (a *AgentServiceAdapter) AddKeyToAgent(ctx context.Context, req *pb.AddKeyToAgentRequest) (*emptypb.Empty, error) {
	// TODO: Implement key loading from file path with passphrase
	// This is complex as it requires reading and decrypting the private key
	return nil, status.Errorf(codes.Unimplemented, "method AddKeyToAgent not implemented")
}

// RemoveKeyFromAgent removes a key from the agent
func (a *AgentServiceAdapter) RemoveKeyFromAgent(ctx context.Context, req *pb.RemoveKeyFromAgentRequest) (*emptypb.Empty, error) {
	// TODO: Implement - requires finding key by fingerprint and removing it
	return nil, status.Errorf(codes.Unimplemented, "method RemoveKeyFromAgent not implemented")
}

// RemoveAllKeysFromAgent removes all keys from the agent
func (a *AgentServiceAdapter) RemoveAllKeysFromAgent(ctx context.Context, req *pb.RemoveAllKeysFromAgentRequest) (*emptypb.Empty, error) {
	if err := a.service.RemoveAll(); err != nil {
		return nil, status.Errorf(codes.Internal, "failed to remove all keys from agent: %v", err)
	}

	return &emptypb.Empty{}, nil
}

// LockAgent locks the agent with a passphrase
func (a *AgentServiceAdapter) LockAgent(ctx context.Context, req *pb.LockAgentRequest) (*emptypb.Empty, error) {
	if err := a.service.Lock([]byte(req.GetPassphrase())); err != nil {
		return nil, status.Errorf(codes.Internal, "failed to lock agent: %v", err)
	}

	return &emptypb.Empty{}, nil
}

// UnlockAgent unlocks the agent
func (a *AgentServiceAdapter) UnlockAgent(ctx context.Context, req *pb.UnlockAgentRequest) (*emptypb.Empty, error) {
	if err := a.service.Unlock([]byte(req.GetPassphrase())); err != nil {
		return nil, status.Errorf(codes.Internal, "failed to unlock agent: %v", err)
	}

	return &emptypb.Empty{}, nil
}

// toProtoAgentKey converts a core AgentKey to a proto AgentKey
func toProtoAgentKey(k *agent.AgentKey) *pb.AgentKey {
	return &pb.AgentKey{
		Fingerprint:     k.Fingerprint,
		Comment:         k.Comment,
		Type:            k.Type,
		Bits:            int32(k.Bits),
		HasLifetime:     k.HasLifetime,
		LifetimeSeconds: int32(k.LifetimeSeconds),
		IsConfirm:       k.IsConfirm,
	}
}
