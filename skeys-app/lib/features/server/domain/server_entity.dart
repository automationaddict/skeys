import 'package:equatable/equatable.dart';

/// Service state for SSH server.
enum ServiceState {
  unspecified,
  running,
  stopped,
  failed,
  notFound,
  unknown,
}

/// Config file information.
class ConfigPathInfo extends Equatable {
  final String path;
  final bool exists;
  final bool readable;
  final bool writable;
  final String includeDir;

  const ConfigPathInfo({
    required this.path,
    required this.exists,
    required this.readable,
    required this.writable,
    required this.includeDir,
  });

  @override
  List<Object?> get props => [path, exists, readable, writable, includeDir];
}

/// SSH service status.
class ServiceStatus extends Equatable {
  final ServiceState state;
  final bool enabled;
  final String activeState;
  final String subState;
  final String loadState;
  final int pid;
  final String startedAt;
  final String serviceName;

  const ServiceStatus({
    required this.state,
    required this.enabled,
    required this.activeState,
    required this.subState,
    required this.loadState,
    required this.pid,
    required this.startedAt,
    required this.serviceName,
  });

  @override
  List<Object?> get props => [
        state,
        enabled,
        activeState,
        subState,
        loadState,
        pid,
        startedAt,
        serviceName,
      ];
}

/// SSH client status.
class SSHClientStatus extends Equatable {
  final bool installed;
  final String version;
  final String binaryPath;
  final ConfigPathInfo systemConfig;
  final ConfigPathInfo userConfig;

  const SSHClientStatus({
    required this.installed,
    required this.version,
    required this.binaryPath,
    required this.systemConfig,
    required this.userConfig,
  });

  @override
  List<Object?> get props => [
        installed,
        version,
        binaryPath,
        systemConfig,
        userConfig,
      ];
}

/// SSH server status.
class SSHServerStatus extends Equatable {
  final bool installed;
  final String version;
  final String binaryPath;
  final ServiceStatus service;
  final ConfigPathInfo config;

  const SSHServerStatus({
    required this.installed,
    required this.version,
    required this.binaryPath,
    required this.service,
    required this.config,
  });

  @override
  List<Object?> get props => [
        installed,
        version,
        binaryPath,
        service,
        config,
      ];
}

/// Complete SSH system status.
class SSHSystemStatus extends Equatable {
  final String distribution;
  final String distributionVersion;
  final SSHClientStatus client;
  final SSHServerStatus server;

  const SSHSystemStatus({
    required this.distribution,
    required this.distributionVersion,
    required this.client,
    required this.server,
  });

  @override
  List<Object?> get props => [
        distribution,
        distributionVersion,
        client,
        server,
      ];
}
