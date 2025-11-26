package server

import (
	"google.golang.org/grpc"
	"google.golang.org/grpc/reflection"

	"github.com/johnnelson/skeys-core/agent"
	"github.com/johnnelson/skeys-core/config"
	"github.com/johnnelson/skeys-core/hosts"
	"github.com/johnnelson/skeys-core/keys"
	"github.com/johnnelson/skeys-core/logging"
	"github.com/johnnelson/skeys-core/remote"

	pb "github.com/johnnelson/skeys-daemon/api/gen/skeys/v1"
	"github.com/johnnelson/skeys-daemon/internal/adapter"
)

// Server wraps the gRPC server and all service adapters
type Server struct {
	*grpc.Server

	log *logging.Logger

	// Core library services
	keyService     *keys.Service
	clientConfig   *config.ClientConfig
	serverConfig   *config.ServerConfigManager
	knownHosts     *hosts.KnownHostsManager
	authorizedKeys *hosts.AuthorizedKeysManager
	agentService   *agent.Service
	connectionPool *remote.ConnectionPool

	// gRPC service adapters
	keyAdapter    *adapter.KeyServiceAdapter
	configAdapter *adapter.ConfigServiceAdapter
	hostsAdapter  *adapter.HostsServiceAdapter
	agentAdapter  *adapter.AgentServiceAdapter
	remoteAdapter *adapter.RemoteServiceAdapter
}

// ServerOption is a functional option for configuring the Server
type ServerOption func(*Server)

// WithLogger sets a custom logger for the server and all services
func WithLogger(log *logging.Logger) ServerOption {
	return func(s *Server) {
		s.log = log
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

	// Create gRPC server with logging interceptor
	grpcServer := grpc.NewServer(
		grpc.UnaryInterceptor(newLoggingInterceptor(s.log)),
	)
	s.Server = grpcServer

	// Initialize core library services with logging
	keysLog := s.log.WithComponent("keys")
	keyService, err := keys.NewService(keys.WithLogger(keysLog))
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

	serverConfig := config.NewServerConfigManager(config.WithServerLogger(configLog))
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

	agentLog := s.log.WithComponent("agent")
	agentService := agent.NewService(agent.WithLogger(agentLog))
	s.agentService = agentService
	s.log.Debug("agent service initialized")

	remoteLog := s.log.WithComponent("remote")
	connectionPool := remote.NewConnectionPool(remote.PoolConfig{}, remote.WithPoolLogger(remoteLog))
	s.connectionPool = connectionPool
	s.log.Debug("connection pool initialized")

	// Create adapters (logging happens through core services and gRPC interceptor)
	s.keyAdapter = adapter.NewKeyServiceAdapter(keyService)
	s.configAdapter = adapter.NewConfigServiceAdapter(clientConfig, serverConfig)
	s.hostsAdapter = adapter.NewHostsServiceAdapter(knownHosts, authorizedKeys)
	s.agentAdapter = adapter.NewAgentServiceAdapter(agentService)
	s.remoteAdapter = adapter.NewRemoteServiceAdapter(connectionPool)

	// Register gRPC services
	pb.RegisterKeyServiceServer(grpcServer, s.keyAdapter)
	pb.RegisterConfigServiceServer(grpcServer, s.configAdapter)
	pb.RegisterHostsServiceServer(grpcServer, s.hostsAdapter)
	pb.RegisterAgentServiceServer(grpcServer, s.agentAdapter)
	pb.RegisterRemoteServiceServer(grpcServer, s.remoteAdapter)

	// Enable reflection for debugging
	reflection.Register(grpcServer)

	s.log.Info("all services initialized and registered")
	return s, nil
}
