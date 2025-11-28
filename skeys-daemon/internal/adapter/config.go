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
	clientConfig     *config.ClientConfig
	serverConfig     *config.ServerConfigManager
	sshConfigMgr     *sshconfig.Manager
	configDiscoverer *config.ConfigDiscoverer
}

// NewConfigServiceAdapter creates a new config service adapter
func NewConfigServiceAdapter(client *config.ClientConfig, server *config.ServerConfigManager, sshMgr *sshconfig.Manager) *ConfigServiceAdapter {
	return &ConfigServiceAdapter{
		clientConfig:     client,
		serverConfig:     server,
		sshConfigMgr:     sshMgr,
		configDiscoverer: config.NewConfigDiscoverer(),
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

// ============================================================
// New unified SSH Config API
// ============================================================

// ListSSHConfigEntries returns all SSH config entries (Host and Match blocks)
func (a *ConfigServiceAdapter) ListSSHConfigEntries(ctx context.Context, req *pb.ListSSHConfigEntriesRequest) (*pb.ListSSHConfigEntriesResponse, error) {
	entries, err := a.clientConfig.ListEntries()
	if err != nil {
		return nil, status.Errorf(codes.Internal, "failed to list SSH config entries: %v", err)
	}

	var pbEntries []*pb.SSHConfigEntry
	for _, e := range entries {
		pbEntries = append(pbEntries, toProtoSSHConfigEntry(e))
	}

	return &pb.ListSSHConfigEntriesResponse{Entries: pbEntries}, nil
}

// WatchSSHConfigEntries streams SSH config entry updates when changes are detected.
func (a *ConfigServiceAdapter) WatchSSHConfigEntries(req *pb.WatchSSHConfigEntriesRequest, stream pb.ConfigService_WatchSSHConfigEntriesServer) error {
	ctx := stream.Context()

	// Use the core service's Watch method which polls for changes
	updates := a.clientConfig.Watch(ctx)

	for update := range updates {
		if update.Err != nil {
			return status.Errorf(codes.Internal, "watch error: %v", update.Err)
		}

		var pbEntries []*pb.SSHConfigEntry
		for _, e := range update.Entries {
			pbEntries = append(pbEntries, toProtoSSHConfigEntry(e))
		}

		resp := &pb.ListSSHConfigEntriesResponse{Entries: pbEntries}
		if err := stream.Send(resp); err != nil {
			return err
		}
	}

	return nil
}

// GetSSHConfigEntry returns a specific SSH config entry by ID
func (a *ConfigServiceAdapter) GetSSHConfigEntry(ctx context.Context, req *pb.GetSSHConfigEntryRequest) (*pb.SSHConfigEntry, error) {
	entry, err := a.clientConfig.GetEntry(req.GetId())
	if err != nil {
		return nil, status.Errorf(codes.NotFound, "SSH config entry not found: %v", err)
	}

	return toProtoSSHConfigEntry(entry), nil
}

// CreateSSHConfigEntry creates a new SSH config entry
func (a *ConfigServiceAdapter) CreateSSHConfigEntry(ctx context.Context, req *pb.CreateSSHConfigEntryRequest) (*pb.SSHConfigEntry, error) {
	entry := fromProtoSSHConfigEntry(req.GetEntry())

	if err := a.clientConfig.AddEntry(entry, int(req.GetInsertPosition())); err != nil {
		return nil, status.Errorf(codes.Internal, "failed to create SSH config entry: %v", err)
	}

	// Return the created entry (with generated ID)
	return toProtoSSHConfigEntry(entry), nil
}

// UpdateSSHConfigEntry updates an existing SSH config entry
func (a *ConfigServiceAdapter) UpdateSSHConfigEntry(ctx context.Context, req *pb.UpdateSSHConfigEntryRequest) (*pb.SSHConfigEntry, error) {
	entry := fromProtoSSHConfigEntry(req.GetEntry())

	if err := a.clientConfig.UpdateEntry(req.GetId(), entry); err != nil {
		return nil, status.Errorf(codes.Internal, "failed to update SSH config entry: %v", err)
	}

	// Return the updated entry
	updated, err := a.clientConfig.GetEntry(req.GetId())
	if err != nil {
		// Entry ID may have changed if patterns changed, return the entry we passed in
		return toProtoSSHConfigEntry(entry), nil
	}

	return toProtoSSHConfigEntry(updated), nil
}

// DeleteSSHConfigEntry removes an SSH config entry
func (a *ConfigServiceAdapter) DeleteSSHConfigEntry(ctx context.Context, req *pb.DeleteSSHConfigEntryRequest) (*emptypb.Empty, error) {
	if err := a.clientConfig.DeleteEntry(req.GetId()); err != nil {
		return nil, status.Errorf(codes.Internal, "failed to delete SSH config entry: %v", err)
	}

	return &emptypb.Empty{}, nil
}

// ReorderSSHConfigEntries reorders SSH config entries
func (a *ConfigServiceAdapter) ReorderSSHConfigEntries(ctx context.Context, req *pb.ReorderSSHConfigEntriesRequest) (*pb.ListSSHConfigEntriesResponse, error) {
	if err := a.clientConfig.Reorder(req.GetEntryIds()); err != nil {
		return nil, status.Errorf(codes.Internal, "failed to reorder SSH config entries: %v", err)
	}

	// Return the reordered list
	return a.ListSSHConfigEntries(ctx, &pb.ListSSHConfigEntriesRequest{Target: req.GetTarget()})
}

// ============================================================
// Global Directives API
// ============================================================

// ListGlobalDirectives returns all global directives (options outside Host/Match blocks)
func (a *ConfigServiceAdapter) ListGlobalDirectives(ctx context.Context, req *pb.ListGlobalDirectivesRequest) (*pb.ListGlobalDirectivesResponse, error) {
	directives, err := a.clientConfig.GetGlobalDirectives()
	if err != nil {
		return nil, status.Errorf(codes.Internal, "failed to get global directives: %v", err)
	}

	var pbDirectives []*pb.GlobalDirective
	for _, d := range directives {
		pbDirectives = append(pbDirectives, &pb.GlobalDirective{
			Key:   d.Key,
			Value: d.Value,
		})
	}

	return &pb.ListGlobalDirectivesResponse{Directives: pbDirectives}, nil
}

// SetGlobalDirective sets a global directive value
func (a *ConfigServiceAdapter) SetGlobalDirective(ctx context.Context, req *pb.SetGlobalDirectiveRequest) (*pb.GlobalDirective, error) {
	if err := a.clientConfig.SetGlobalDirective(req.GetKey(), req.GetValue()); err != nil {
		return nil, status.Errorf(codes.Internal, "failed to set global directive: %v", err)
	}

	return &pb.GlobalDirective{
		Key:   req.GetKey(),
		Value: req.GetValue(),
	}, nil
}

// DeleteGlobalDirective removes a global directive
func (a *ConfigServiceAdapter) DeleteGlobalDirective(ctx context.Context, req *pb.DeleteGlobalDirectiveRequest) (*emptypb.Empty, error) {
	if err := a.clientConfig.DeleteGlobalDirective(req.GetKey()); err != nil {
		return nil, status.Errorf(codes.Internal, "failed to delete global directive: %v", err)
	}

	return &emptypb.Empty{}, nil
}

// ============================================================
// Server Config Methods
// ============================================================

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

// ============================================================
// Config Path Discovery
// ============================================================

// DiscoverConfigPaths auto-detects SSH config file locations
func (a *ConfigServiceAdapter) DiscoverConfigPaths(ctx context.Context, req *pb.DiscoverConfigPathsRequest) (*pb.DiscoverConfigPathsResponse, error) {
	discovered, err := a.configDiscoverer.Discover(ctx)
	if err != nil {
		return nil, status.Errorf(codes.Internal, "failed to discover config paths: %v", err)
	}

	return &pb.DiscoverConfigPathsResponse{
		ClientSystemConfig: toProtoConfigPathInfo(&discovered.ClientSystemConfig),
		ClientUserConfig:   toProtoConfigPathInfo(&discovered.ClientUserConfig),
		ServerConfig:       toProtoConfigPathInfo(&discovered.ServerConfig),
		Distribution:       discovered.Distribution,
		SshClientInstalled: discovered.SSHClientInstalled,
		SshServerInstalled: discovered.SSHServerInstalled,
	}, nil
}

// toProtoConfigPathInfo converts a core ConfigPathInfo to a proto ConfigPathInfo
func toProtoConfigPathInfo(info *config.ConfigPathInfo) *pb.ConfigPathInfo {
	return &pb.ConfigPathInfo{
		Path:            info.Path,
		Exists:          info.Exists,
		Readable:        info.Readable,
		Writable:        info.Writable,
		IncludeDir:      info.IncludeDir,
		DiscoveryMethod: toProtoDiscoveryMethod(info.DiscoveryMethod),
	}
}

// toProtoDiscoveryMethod converts a core DiscoveryMethod to a proto DiscoveryMethod
func toProtoDiscoveryMethod(m config.DiscoveryMethod) pb.DiscoveryMethod {
	switch m {
	case config.DiscoveryMethodCommand:
		return pb.DiscoveryMethod_DISCOVERY_METHOD_COMMAND
	case config.DiscoveryMethodPackageManager:
		return pb.DiscoveryMethod_DISCOVERY_METHOD_PACKAGE_MANAGER
	case config.DiscoveryMethodCommonPath:
		return pb.DiscoveryMethod_DISCOVERY_METHOD_COMMON_PATH
	case config.DiscoveryMethodUserSpecified:
		return pb.DiscoveryMethod_DISCOVERY_METHOD_USER_SPECIFIED
	default:
		return pb.DiscoveryMethod_DISCOVERY_METHOD_UNSPECIFIED
	}
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

// ============================================================
// SSHConfigEntry conversion functions
// ============================================================

// toProtoSSHConfigEntry converts a core SSHConfigEntry to a proto SSHConfigEntry
func toProtoSSHConfigEntry(e *config.SSHConfigEntry) *pb.SSHConfigEntry {
	entryType := pb.SSHConfigEntryType_SSH_CONFIG_ENTRY_TYPE_HOST
	if e.Type == config.EntryTypeMatch {
		entryType = pb.SSHConfigEntryType_SSH_CONFIG_ENTRY_TYPE_MATCH
	}

	return &pb.SSHConfigEntry{
		Id:       e.ID,
		Type:     entryType,
		Position: int32(e.Position),
		Patterns: e.Patterns,
		Options:  toProtoSSHOptions(&e.Options),
	}
}

// fromProtoSSHConfigEntry converts a proto SSHConfigEntry to a core SSHConfigEntry
func fromProtoSSHConfigEntry(e *pb.SSHConfigEntry) *config.SSHConfigEntry {
	entryType := config.EntryTypeHost
	if e.GetType() == pb.SSHConfigEntryType_SSH_CONFIG_ENTRY_TYPE_MATCH {
		entryType = config.EntryTypeMatch
	}

	return &config.SSHConfigEntry{
		ID:       e.GetId(),
		Type:     entryType,
		Position: int(e.GetPosition()),
		Patterns: e.GetPatterns(),
		Options:  fromProtoSSHOptions(e.GetOptions()),
	}
}

// toProtoSSHOptions converts core SSHOptions to proto SSHOptions
func toProtoSSHOptions(o *config.SSHOptions) *pb.SSHOptions {
	return &pb.SSHOptions{
		Hostname:              o.Hostname,
		Port:                  int32(o.Port),
		User:                  o.User,
		IdentityFiles:         o.IdentityFiles,
		ProxyJump:             o.ProxyJump,
		ProxyCommand:          o.ProxyCommand,
		ForwardAgent:          o.ForwardAgent,
		IdentitiesOnly:        o.IdentitiesOnly,
		StrictHostKeyChecking: o.StrictHostKeyChecking,
		ServerAliveInterval:   int32(o.ServerAliveInterval),
		ServerAliveCountMax:   int32(o.ServerAliveCountMax),
		Compression:           o.Compression,
		ExtraOptions:          o.ExtraOptions,
	}
}

// fromProtoSSHOptions converts proto SSHOptions to core SSHOptions
func fromProtoSSHOptions(o *pb.SSHOptions) config.SSHOptions {
	if o == nil {
		return config.SSHOptions{}
	}
	return config.SSHOptions{
		Hostname:              o.GetHostname(),
		Port:                  int(o.GetPort()),
		User:                  o.GetUser(),
		IdentityFiles:         o.GetIdentityFiles(),
		ProxyJump:             o.GetProxyJump(),
		ProxyCommand:          o.GetProxyCommand(),
		ForwardAgent:          o.GetForwardAgent(),
		IdentitiesOnly:        o.GetIdentitiesOnly(),
		StrictHostKeyChecking: o.GetStrictHostKeyChecking(),
		ServerAliveInterval:   int(o.GetServerAliveInterval()),
		ServerAliveCountMax:   int(o.GetServerAliveCountMax()),
		Compression:           o.GetCompression(),
		ExtraOptions:          o.GetExtraOptions(),
	}
}
