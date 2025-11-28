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
enum ServiceState { unspecified, running, stopped, failed, notFound, unknown }

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
  List<Object?> get props => [installed, version, binaryPath, service, config];
}

/// Firewall type.
enum FirewallType { unspecified, ufw, firewalld, iptables, none }

/// Network information for SSH.
class NetworkInfo extends Equatable {
  final String hostname;
  final List<String> ipAddresses;
  final int sshPort;

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
  final FirewallType type;
  final bool active;
  final bool sshAllowed;
  final String statusText;

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
  final String distribution;
  final String distributionVersion;
  final SSHClientStatus client;
  final SSHServerStatus server;
  final NetworkInfo? network;
  final FirewallStatus? firewall;

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
