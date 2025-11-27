// Package adapter provides adapters between gRPC services and the core library.
package adapter

import (
	"context"

	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
	"google.golang.org/protobuf/types/known/emptypb"

	"github.com/johnnelson/skeys-core/config"
	"github.com/johnnelson/skeys-core/sshconfig"
	pb "github.com/johnnelson/skeys-daemon/api/gen/skeys/v1"
)

// ConfigServiceAdapter adapts the config services to the gRPC ConfigService interface.
type ConfigServiceAdapter struct {
	pb.UnimplementedConfigServiceServer
	clientConfig    *config.ClientConfig
	serverConfig    *config.ServerConfigManager
	sshConfigMgr    *sshconfig.Manager
}

// NewConfigServiceAdapter creates a new config service adapter
func NewConfigServiceAdapter(client *config.ClientConfig, server *config.ServerConfigManager, sshMgr *sshconfig.Manager) *ConfigServiceAdapter {
	return &ConfigServiceAdapter{
		clientConfig:    client,
		serverConfig:    server,
		sshConfigMgr:    sshMgr,
	}
}

// ListHostConfigs returns all host configurations from ~/.ssh/config
func (a *ConfigServiceAdapter) ListHostConfigs(ctx context.Context, req *pb.ListHostConfigsRequest) (*pb.ListHostConfigsResponse, error) {
	entries, err := a.clientConfig.List()
	if err != nil {
		return nil, status.Errorf(codes.Internal, "failed to list host configs: %v", err)
	}

	var hosts []*pb.HostConfig
	for _, e := range entries {
		hosts = append(hosts, toProtoHostConfig(e))
	}

	return &pb.ListHostConfigsResponse{Hosts: hosts}, nil
}

// GetHostConfig returns a specific host configuration
func (a *ConfigServiceAdapter) GetHostConfig(ctx context.Context, req *pb.GetHostConfigRequest) (*pb.HostConfig, error) {
	entry, err := a.clientConfig.Get(req.GetAlias())
	if err != nil {
		return nil, status.Errorf(codes.NotFound, "host config not found: %v", err)
	}

	return toProtoHostConfig(entry), nil
}

// CreateHostConfig creates a new host configuration
func (a *ConfigServiceAdapter) CreateHostConfig(ctx context.Context, req *pb.CreateHostConfigRequest) (*pb.HostConfig, error) {
	entry := fromProtoHostConfig(req.GetConfig())

	if err := a.clientConfig.Add(entry); err != nil {
		return nil, status.Errorf(codes.Internal, "failed to create host config: %v", err)
	}

	// Return the created config
	created, err := a.clientConfig.Get(entry.Alias)
	if err != nil {
		return nil, status.Errorf(codes.Internal, "failed to get created host config: %v", err)
	}

	return toProtoHostConfig(created), nil
}

// UpdateHostConfig updates an existing host configuration
func (a *ConfigServiceAdapter) UpdateHostConfig(ctx context.Context, req *pb.UpdateHostConfigRequest) (*pb.HostConfig, error) {
	entry := fromProtoHostConfig(req.GetConfig())

	if err := a.clientConfig.Update(req.GetAlias(), entry); err != nil {
		return nil, status.Errorf(codes.Internal, "failed to update host config: %v", err)
	}

	// Return the updated config
	updated, err := a.clientConfig.Get(req.GetAlias())
	if err != nil {
		return nil, status.Errorf(codes.Internal, "failed to get updated host config: %v", err)
	}

	return toProtoHostConfig(updated), nil
}

// DeleteHostConfig removes a host configuration
func (a *ConfigServiceAdapter) DeleteHostConfig(ctx context.Context, req *pb.DeleteHostConfigRequest) (*emptypb.Empty, error) {
	if err := a.clientConfig.Delete(req.GetAlias()); err != nil {
		return nil, status.Errorf(codes.Internal, "failed to delete host config: %v", err)
	}

	return &emptypb.Empty{}, nil
}

// TestConnection tests connectivity to a configured host
func (a *ConfigServiceAdapter) TestConnection(ctx context.Context, req *pb.TestConnectionRequest) (*pb.TestConnectionResponse, error) {
	// TODO: Implement connection testing
	return nil, status.Errorf(codes.Unimplemented, "method TestConnection not implemented")
}

// GetServerConfig reads the sshd_config file
func (a *ConfigServiceAdapter) GetServerConfig(ctx context.Context, req *pb.GetServerConfigRequest) (*pb.ServerConfig, error) {
	cfg, err := a.serverConfig.Read(ctx)
	if err != nil {
		return nil, status.Errorf(codes.Internal, "failed to read server config: %v", err)
	}

	return toProtoServerConfig(cfg), nil
}

// UpdateServerConfig updates directives in sshd_config
func (a *ConfigServiceAdapter) UpdateServerConfig(ctx context.Context, req *pb.UpdateServerConfigRequest) (*pb.ServerConfig, error) {
	for _, update := range req.GetUpdates() {
		if update.GetDelete() {
			// Delete is not directly supported, skip for now
			continue
		}
		if err := a.serverConfig.Update(ctx, update.GetKey(), update.GetValue()); err != nil {
			return nil, status.Errorf(codes.Internal, "failed to update server config directive %s: %v", update.GetKey(), err)
		}
	}

	// Return the updated config
	cfg, err := a.serverConfig.Read(ctx)
	if err != nil {
		return nil, status.Errorf(codes.Internal, "failed to read updated server config: %v", err)
	}

	return toProtoServerConfig(cfg), nil
}

// ValidateServerConfig validates the sshd_config
func (a *ConfigServiceAdapter) ValidateServerConfig(ctx context.Context, req *pb.ValidateServerConfigRequest) (*pb.ValidateServerConfigResponse, error) {
	err := a.serverConfig.Validate(ctx)
	if err != nil {
		return &pb.ValidateServerConfigResponse{
			Valid:        false,
			ErrorMessage: err.Error(),
		}, nil
	}

	return &pb.ValidateServerConfigResponse{Valid: true}, nil
}

// RestartSSHService restarts or reloads the SSH service
func (a *ConfigServiceAdapter) RestartSSHService(ctx context.Context, req *pb.RestartSSHServiceRequest) (*pb.RestartSSHServiceResponse, error) {
	err := a.serverConfig.RestartService(ctx, req.GetReloadOnly())
	if err != nil {
		return &pb.RestartSSHServiceResponse{
			Success: false,
			Message: err.Error(),
		}, nil
	}

	action := "restarted"
	if req.GetReloadOnly() {
		action = "reloaded"
	}

	return &pb.RestartSSHServiceResponse{
		Success: true,
		Message: "SSH service " + action + " successfully",
	}, nil
}

// GetSshConfigStatus returns the current status of skeys SSH config integration
func (a *ConfigServiceAdapter) GetSshConfigStatus(ctx context.Context, req *pb.GetSshConfigStatusRequest) (*pb.GetSshConfigStatusResponse, error) {
	enabled, err := a.sshConfigMgr.IsEnabled()
	if err != nil {
		return nil, status.Errorf(codes.Internal, "failed to check SSH config status: %v", err)
	}

	return &pb.GetSshConfigStatusResponse{
		Enabled:     enabled,
		AgentSocket: a.sshConfigMgr.GetAgentSocket(),
	}, nil
}

// EnableSshConfig enables skeys SSH config integration
func (a *ConfigServiceAdapter) EnableSshConfig(ctx context.Context, req *pb.EnableSshConfigRequest) (*pb.EnableSshConfigResponse, error) {
	if err := a.sshConfigMgr.Enable(); err != nil {
		return &pb.EnableSshConfigResponse{
			Success: false,
			Message: err.Error(),
		}, nil
	}

	return &pb.EnableSshConfigResponse{
		Success: true,
		Message: "SSH config integration enabled successfully",
	}, nil
}

// DisableSshConfig disables skeys SSH config integration
func (a *ConfigServiceAdapter) DisableSshConfig(ctx context.Context, req *pb.DisableSshConfigRequest) (*pb.DisableSshConfigResponse, error) {
	if err := a.sshConfigMgr.Disable(); err != nil {
		return &pb.DisableSshConfigResponse{
			Success: false,
			Message: err.Error(),
		}, nil
	}

	return &pb.DisableSshConfigResponse{
		Success: true,
		Message: "SSH config integration disabled successfully",
	}, nil
}

// toProtoHostConfig converts a core HostEntry to a proto HostConfig
func toProtoHostConfig(e *config.HostEntry) *pb.HostConfig {
	return &pb.HostConfig{
		Alias:                 e.Alias,
		Hostname:              e.Hostname,
		User:                  e.User,
		Port:                  int32(e.Port),
		IdentityFiles:         e.IdentityFiles,
		ProxyJump:             e.ProxyJump,
		ProxyCommand:          e.ProxyCommand,
		ForwardAgent:          e.ForwardAgent,
		IdentitiesOnly:        e.IdentitiesOnly,
		StrictHostKeyChecking: e.StrictHostKeyChecking,
		ServerAliveInterval:   int32(e.ServerAliveInterval),
		ServerAliveCountMax:   int32(e.ServerAliveCountMax),
		ExtraOptions:          e.ExtraOptions,
		IsPattern:             e.IsPattern,
		LineNumber:            int32(e.LineNumber),
	}
}

// fromProtoHostConfig converts a proto HostConfig to a core HostEntry
func fromProtoHostConfig(c *pb.HostConfig) *config.HostEntry {
	return &config.HostEntry{
		Alias:                 c.GetAlias(),
		Hostname:              c.GetHostname(),
		User:                  c.GetUser(),
		Port:                  int(c.GetPort()),
		IdentityFiles:         c.GetIdentityFiles(),
		ProxyJump:             c.GetProxyJump(),
		ProxyCommand:          c.GetProxyCommand(),
		ForwardAgent:          c.GetForwardAgent(),
		IdentitiesOnly:        c.GetIdentitiesOnly(),
		StrictHostKeyChecking: c.GetStrictHostKeyChecking(),
		ServerAliveInterval:   int(c.GetServerAliveInterval()),
		ServerAliveCountMax:   int(c.GetServerAliveCountMax()),
		ExtraOptions:          c.GetExtraOptions(),
		IsPattern:             c.GetIsPattern(),
		LineNumber:            int(c.GetLineNumber()),
	}
}

// toProtoServerConfig converts a core ServerConfig to a proto ServerConfig
func toProtoServerConfig(cfg *config.ServerConfig) *pb.ServerConfig {
	var directives []*pb.ServerConfigDirective
	for _, d := range cfg.Directives {
		directives = append(directives, &pb.ServerConfigDirective{
			Key:         d.Key,
			Value:       d.Value,
			LineNumber:  int32(d.LineNumber),
			IsCommented: d.IsCommented,
			MatchBlock:  d.MatchBlock,
		})
	}

	return &pb.ServerConfig{
		Directives: directives,
		RawContent: cfg.RawContent,
	}
}
