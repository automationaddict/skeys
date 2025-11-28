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
	"os"

	"golang.org/x/crypto/ssh"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
	"google.golang.org/protobuf/types/known/emptypb"

	"github.com/johnnelson/skeys-core/agent"
	pb "github.com/johnnelson/skeys-daemon/api/gen/skeys/v1"
)

// AgentServiceAdapter adapts the agent service to the gRPC AgentService interface.
type AgentServiceAdapter struct {
	pb.UnimplementedAgentServiceServer
	service      *agent.Service
	managedAgent *agent.ManagedAgent
}

// NewAgentServiceAdapter creates a new agent service adapter
func NewAgentServiceAdapter(service *agent.Service, managedAgent *agent.ManagedAgent) *AgentServiceAdapter {
	return &AgentServiceAdapter{
		service:      service,
		managedAgent: managedAgent,
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
	keyPath := req.GetKeyPath()
	passphrase := req.GetPassphrase()
	confirm := req.GetConfirm()

	// Calculate lifetime in seconds from duration
	var lifetimeSecs uint32
	if lifetime := req.GetLifetime(); lifetime != nil {
		lifetimeSecs = uint32(lifetime.GetSeconds())
	}

	// Read the private key file
	keyData, err := os.ReadFile(keyPath)
	if err != nil {
		return nil, status.Errorf(codes.NotFound, "failed to read key file: %v", err)
	}

	// Parse the private key
	var privateKey interface{}
	if passphrase != "" {
		privateKey, err = ssh.ParseRawPrivateKeyWithPassphrase(keyData, []byte(passphrase))
	} else {
		privateKey, err = ssh.ParseRawPrivateKey(keyData)
	}
	if err != nil {
		return nil, status.Errorf(codes.InvalidArgument, "failed to parse private key: %v", err)
	}

	// Add to managed agent directly
	if err := a.managedAgent.AddKeyDirect(privateKey, keyPath, lifetimeSecs, confirm); err != nil {
		return nil, status.Errorf(codes.Internal, "failed to add key to agent: %v", err)
	}

	return &emptypb.Empty{}, nil
}

// RemoveKeyFromAgent removes a key from the agent
func (a *AgentServiceAdapter) RemoveKeyFromAgent(ctx context.Context, req *pb.RemoveKeyFromAgentRequest) (*emptypb.Empty, error) {
	if err := a.service.RemoveKeyByFingerprint(req.GetFingerprint()); err != nil {
		return nil, status.Errorf(codes.Internal, "failed to remove key from agent: %v", err)
	}

	return &emptypb.Empty{}, nil
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

// WatchAgent streams agent status and key updates to the client whenever they change.
// Uses event-driven notifications from ManagedAgent instead of polling.
func (a *AgentServiceAdapter) WatchAgent(req *pb.WatchAgentRequest, stream pb.AgentService_WatchAgentServer) error {
	ctx := stream.Context()

	// Use the managed agent's Watch method which uses event notifications
	updates := a.managedAgent.Watch(ctx)

	for update := range updates {
		if update.Err != nil {
			return status.Errorf(codes.Internal, "watch error: %v", update.Err)
		}

		var pbKeys []*pb.AgentKey
		for _, k := range update.Keys {
			pbKeys = append(pbKeys, toProtoAgentKey(k))
		}

		resp := &pb.WatchAgentResponse{
			Running:    update.Status.Running,
			SocketPath: update.Status.SocketPath,
			IsLocked:   update.Status.IsLocked,
			Keys:       pbKeys,
		}

		if err := stream.Send(resp); err != nil {
			return err
		}
	}

	return nil
}
