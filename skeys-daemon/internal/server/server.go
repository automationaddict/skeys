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

package server

import (
	"os"
	"path/filepath"
	"time"

	"google.golang.org/grpc"
	"google.golang.org/grpc/keepalive"
	"google.golang.org/grpc/reflection"

	"github.com/johnnelson/skeys-core/agent"
	"github.com/johnnelson/skeys-core/config"
	"github.com/johnnelson/skeys-core/hosts"
	"github.com/johnnelson/skeys-core/keys"
	"github.com/johnnelson/skeys-core/logging"
	"github.com/johnnelson/skeys-core/remote"
	"github.com/johnnelson/skeys-core/sshconfig"
	"github.com/johnnelson/skeys-core/storage"

	pb "github.com/johnnelson/skeys-daemon/api/gen/skeys/v1"
	"github.com/johnnelson/skeys-daemon/internal/adapter"
)

// Server wraps the gRPC server and all service adapters
type Server struct {
	*grpc.Server

	log *logging.Logger

	// Version info
	version string
	commit  string

	// Core library services
	keyService     *keys.Service
	clientConfig   *config.ClientConfig
	serverConfig   *config.ServerConfigManager
	knownHosts     *hosts.KnownHostsManager
	authorizedKeys *hosts.AuthorizedKeysManager
	agentService   *agent.Service
	managedAgent   *agent.ManagedAgent
	connectionPool *remote.ConnectionPool
	metadataStore  *storage.Store

	// gRPC service adapters
	keyAdapter      *adapter.KeyServiceAdapter
	configAdapter   *adapter.ConfigServiceAdapter
	hostsAdapter    *adapter.HostsServiceAdapter
	agentAdapter    *adapter.AgentServiceAdapter
	remoteAdapter   *adapter.RemoteServiceAdapter
	metadataAdapter *adapter.MetadataServiceAdapter
	versionAdapter  *adapter.VersionServiceAdapter
	systemAdapter   *adapter.SystemServiceAdapter
	updateAdapter   *adapter.UpdateServiceAdapter
}

// ServerOption is a functional option for configuring the Server
type ServerOption func(*Server)

// WithLogger sets a custom logger for the server and all services
func WithLogger(log *logging.Logger) ServerOption {
	return func(s *Server) {
		s.log = log
	}
}

// WithVersion sets the version and commit for the server
func WithVersion(version, commit string) ServerOption {
	return func(s *Server) {
		s.version = version
		s.commit = commit
	}
}

// New creates a new gRPC server with all services registered
func New(opts ...ServerOption) (*Server, error) {
	s := &Server{
		log: logging.Nop(),
	}

	// Apply options first to get logger
	for _, opt := range opts {
		opt(s)
	}

	s.log.Info("initializing gRPC server")

	// Configure keepalive to detect dead connections and keep streams alive
	kaParams := keepalive.ServerParameters{
		// Send pings every 15 seconds if there is no activity
		Time: 15 * time.Second,
		// Wait 5 seconds for ping ack before considering connection dead
		Timeout: 5 * time.Second,
	}

	kaPolicy := keepalive.EnforcementPolicy{
		// Allow pings even when there are no active streams
		PermitWithoutStream: true,
		// Allow clients to send pings as frequently as they want
		MinTime: 5 * time.Second,
	}

	// Create gRPC server with keepalive and logging interceptor
	grpcServer := grpc.NewServer(
		grpc.KeepaliveParams(kaParams),
		grpc.KeepaliveEnforcementPolicy(kaPolicy),
		grpc.UnaryInterceptor(newLoggingInterceptor(s.log)),
	)
	s.Server = grpcServer

	s.log.InfoWithFields("gRPC keepalive configured", map[string]interface{}{
		"ping_interval": "15s",
		"ping_timeout":  "5s",
	})

	// Start managed SSH agent
	agentLog := s.log.WithComponent("agent")
	agentSocketPath := getManagedAgentSocketPath()
	managedAgent := agent.NewManagedAgent(agentSocketPath, agent.WithManagedAgentLogger(agentLog))
	if err := managedAgent.Start(); err != nil {
		s.log.Err(err, "failed to start managed agent")
		return nil, err
	}
	s.managedAgent = managedAgent
	s.log.InfoWithFields("managed agent started", map[string]interface{}{
		"socket_path": agentSocketPath,
	})

	// Initialize agent service pointing to our managed agent
	agentService, err := agent.NewService(agent.WithSocketPath(agentSocketPath), agent.WithLogger(agentLog))
	if err != nil {
		s.log.Err(err, "failed to initialize agent service")
		return nil, err
	}
	s.agentService = agentService
	s.log.Debug("agent service initialized")

	// Initialize core library services with logging
	keysLog := s.log.WithComponent("keys")
	keyService, err := keys.NewService(
		keys.WithLogger(keysLog),
		keys.WithAgentChecker(agentService), // Inject agent service for checking loaded keys
	)
	if err != nil {
		s.log.Err(err, "failed to initialize keys service")
		return nil, err
	}
	s.keyService = keyService
	s.log.Debug("keys service initialized")

	configLog := s.log.WithComponent("config")
	clientConfig, err := config.NewClientConfig(config.WithClientLogger(configLog))
	if err != nil {
		s.log.Err(err, "failed to initialize client config")
		return nil, err
	}
	s.clientConfig = clientConfig
	s.log.Debug("client config initialized")

	serverConfig, err := config.NewServerConfigManager(config.WithServerLogger(configLog))
	if err != nil {
		s.log.Err(err, "failed to initialize server config")
		return nil, err
	}
	s.serverConfig = serverConfig
	s.log.Debug("server config initialized")

	hostsLog := s.log.WithComponent("hosts")
	knownHosts, err := hosts.NewKnownHostsManager(hosts.WithKnownHostsLogger(hostsLog))
	if err != nil {
		s.log.Err(err, "failed to initialize known_hosts manager")
		return nil, err
	}
	s.knownHosts = knownHosts
	s.log.Debug("known_hosts manager initialized")

	authorizedKeys, err := hosts.NewAuthorizedKeysManager(hosts.WithAuthorizedKeysLogger(hostsLog))
	if err != nil {
		s.log.Err(err, "failed to initialize authorized_keys manager")
		return nil, err
	}
	s.authorizedKeys = authorizedKeys
	s.log.Debug("authorized_keys manager initialized")

	remoteLog := s.log.WithComponent("remote")
	connectionPool := remote.NewConnectionPool(remote.PoolConfig{}, remote.WithPoolLogger(remoteLog))
	s.connectionPool = connectionPool
	s.log.Debug("connection pool initialized")

	// Initialize metadata storage
	storageLog := s.log.WithComponent("storage")
	metadataStore, err := storage.NewStore(storage.WithLogger(storageLog))
	if err != nil {
		s.log.Err(err, "failed to initialize metadata store")
		return nil, err
	}
	s.metadataStore = metadataStore
	s.log.Debug("metadata store initialized")

	// Initialize SSH config manager for skeys agent integration
	sshConfigLog := s.log.WithComponent("sshconfig")
	sshConfigMgr, err := sshconfig.NewManager(
		sshconfig.WithAgentSocket(agentSocketPath),
		sshconfig.WithManagerLogger(sshConfigLog),
	)
	if err != nil {
		s.log.Err(err, "failed to initialize SSH config manager")
		return nil, err
	}
	s.log.Debug("SSH config manager initialized")

	// Create adapters (logging happens through core services and gRPC interceptor)
	s.keyAdapter = adapter.NewKeyServiceAdapter(keyService)
	s.configAdapter = adapter.NewConfigServiceAdapter(clientConfig, serverConfig, sshConfigMgr)
	s.hostsAdapter = adapter.NewHostsServiceAdapter(knownHosts, authorizedKeys)
	s.agentAdapter = adapter.NewAgentServiceAdapter(agentService, managedAgent)
	s.remoteAdapter = adapter.NewRemoteServiceAdapter(connectionPool, agentSocketPath)
	s.metadataAdapter = adapter.NewMetadataServiceAdapter(metadataStore)
	s.versionAdapter = adapter.NewVersionServiceAdapter(s.version, s.commit)
	s.systemAdapter = adapter.NewSystemServiceAdapter()
	s.updateAdapter = adapter.NewUpdateServiceAdapter(s.version)

	// Register gRPC services
	pb.RegisterKeyServiceServer(grpcServer, s.keyAdapter)
	pb.RegisterConfigServiceServer(grpcServer, s.configAdapter)
	pb.RegisterHostsServiceServer(grpcServer, s.hostsAdapter)
	pb.RegisterAgentServiceServer(grpcServer, s.agentAdapter)
	pb.RegisterRemoteServiceServer(grpcServer, s.remoteAdapter)
	pb.RegisterMetadataServiceServer(grpcServer, s.metadataAdapter)
	pb.RegisterVersionServiceServer(grpcServer, s.versionAdapter)
	pb.RegisterSystemServiceServer(grpcServer, s.systemAdapter)
	pb.RegisterUpdateServiceServer(grpcServer, s.updateAdapter)

	// Enable reflection for debugging
	reflection.Register(grpcServer)

	s.log.Info("all services initialized and registered")
	return s, nil
}

// Stop gracefully stops the server and managed agent
func (s *Server) Stop() {
	s.log.Info("stopping server")
	s.Server.GracefulStop()
	if s.managedAgent != nil {
		s.managedAgent.Stop()
	}
}

// ManagedAgentSocketPath returns the socket path for the managed SSH agent
func (s *Server) ManagedAgentSocketPath() string {
	if s.managedAgent != nil {
		return s.managedAgent.SocketPath()
	}
	return ""
}

// getManagedAgentSocketPath returns the socket path for the managed SSH agent
func getManagedAgentSocketPath() string {
	// Use XDG_RUNTIME_DIR if available (typical on Linux)
	if runtimeDir := os.Getenv("XDG_RUNTIME_DIR"); runtimeDir != "" {
		return filepath.Join(runtimeDir, "skeys-agent.sock")
	}
	// Fall back to /tmp
	return "/tmp/skeys-agent.sock"
}
