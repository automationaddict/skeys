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

import 'package:equatable/equatable.dart';

/// Service state for SSH server.
enum ServiceState {
  /// Service state not specified.
  unspecified,

  /// Service is running.
  running,

  /// Service is stopped.
  stopped,

  /// Service has failed.
  failed,

  /// Service not found on system.
  notFound,

  /// Service state is unknown.
  unknown,
}

/// Config file information.
class ConfigPathInfo extends Equatable {
  /// The file path.
  final String path;

  /// Whether the file exists.
  final bool exists;

  /// Whether the file is readable.
  final bool readable;

  /// Whether the file is writable.
  final bool writable;

  /// The include directory path.
  final String includeDir;

  /// Creates a ConfigPathInfo with the given parameters.
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
  /// The current service state.
  final ServiceState state;

  /// Whether the service is enabled for auto-start.
  final bool enabled;

  /// The systemd active state.
  final String activeState;

  /// The systemd sub state.
  final String subState;

  /// The systemd load state.
  final String loadState;

  /// The process ID of the service.
  final int pid;

  /// When the service was started.
  final String startedAt;

  /// The name of the service.
  final String serviceName;

  /// Creates a ServiceStatus with the given parameters.
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
  /// Whether the SSH client is installed.
  final bool installed;

  /// The SSH client version.
  final String version;

  /// Path to the SSH binary.
  final String binaryPath;

  /// System-wide SSH config information.
  final ConfigPathInfo systemConfig;

  /// User SSH config information.
  final ConfigPathInfo userConfig;

  /// Creates an SSHClientStatus with the given parameters.
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
  /// Whether the SSH server (sshd) is installed.
  final bool installed;

  /// The SSH server version.
  final String version;

  /// Path to the sshd binary.
  final String binaryPath;

  /// The service status information.
  final ServiceStatus service;

  /// Server config file information.
  final ConfigPathInfo config;

  /// Creates an SSHServerStatus with the given parameters.
  const SSHServerStatus({
    required this.installed,
    required this.version,
    required this.binaryPath,
    required this.service,
    required this.config,
  });

  @override
  List<Object?> get props => [installed, version, binaryPath, service, config];
}

/// Firewall type.
enum FirewallType {
  /// Firewall type not specified.
  unspecified,

  /// UFW (Uncomplicated Firewall).
  ufw,

  /// firewalld.
  firewalld,

  /// iptables.
  iptables,

  /// No firewall detected.
  none,
}

/// Network information for SSH.
class NetworkInfo extends Equatable {
  /// The system hostname.
  final String hostname;

  /// List of IP addresses on the system.
  final List<String> ipAddresses;

  /// The SSH listening port.
  final int sshPort;

  /// Creates a NetworkInfo with the given parameters.
  const NetworkInfo({
    required this.hostname,
    required this.ipAddresses,
    required this.sshPort,
  });

  @override
  List<Object?> get props => [hostname, ipAddresses, sshPort];
}

/// Firewall status.
class FirewallStatus extends Equatable {
  /// The firewall type.
  final FirewallType type;

  /// Whether the firewall is active.
  final bool active;

  /// Whether SSH connections are allowed.
  final bool sshAllowed;

  /// Human-readable status text.
  final String statusText;

  /// Creates a FirewallStatus with the given parameters.
  const FirewallStatus({
    required this.type,
    required this.active,
    required this.sshAllowed,
    required this.statusText,
  });

  @override
  List<Object?> get props => [type, active, sshAllowed, statusText];
}

/// Complete SSH system status.
class SSHSystemStatus extends Equatable {
  /// The Linux distribution name.
  final String distribution;

  /// The distribution version.
  final String distributionVersion;

  /// SSH client status information.
  final SSHClientStatus client;

  /// SSH server status information.
  final SSHServerStatus server;

  /// Network information if available.
  final NetworkInfo? network;

  /// Firewall status if available.
  final FirewallStatus? firewall;

  /// Creates an SSHSystemStatus with the given parameters.
  const SSHSystemStatus({
    required this.distribution,
    required this.distributionVersion,
    required this.client,
    required this.server,
    this.network,
    this.firewall,
  });

  @override
  List<Object?> get props => [
    distribution,
    distributionVersion,
    client,
    server,
    network,
    firewall,
  ];
}
