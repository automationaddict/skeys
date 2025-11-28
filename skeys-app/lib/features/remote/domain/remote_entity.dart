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

/// Remote connection status.
enum RemoteStatus {
  /// Not connected to the remote.
  disconnected,

  /// Connection is being established.
  connecting,

  /// Successfully connected.
  connected,

  /// Connection error occurred.
  error,
}

/// Remote server configuration.
class RemoteEntity extends Equatable {
  /// Unique identifier for the remote.
  final String id;

  /// Display name for the remote.
  final String name;

  /// Hostname or IP address.
  final String host;

  /// SSH port number.
  final int port;

  /// Username for authentication.
  final String user;

  /// Optional path to identity file.
  final String? identityFile;

  /// Optional SSH config alias.
  final String? sshConfigAlias;

  /// When the remote was created.
  final DateTime createdAt;

  /// When the remote was last connected to.
  final DateTime? lastConnectedAt;

  /// Current connection status.
  final RemoteStatus status;

  /// Creates a RemoteEntity with the given parameters.
  const RemoteEntity({
    required this.id,
    required this.name,
    required this.host,
    required this.port,
    required this.user,
    this.identityFile,
    this.sshConfigAlias,
    required this.createdAt,
    this.lastConnectedAt,
    required this.status,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    host,
    port,
    user,
    identityFile,
    sshConfigAlias,
    createdAt,
    lastConnectedAt,
    status,
  ];
}

/// Active SSH connection.
class ConnectionEntity extends Equatable {
  /// Unique identifier for the connection.
  final String id;

  /// The remote configuration ID this connection uses.
  final String remoteId;

  /// Hostname or IP address.
  final String host;

  /// SSH port number.
  final int port;

  /// Username for the connection.
  final String user;

  /// SSH server version string.
  final String serverVersion;

  /// When the connection was established.
  final DateTime connectedAt;

  /// When the last activity occurred.
  final DateTime lastActivityAt;

  /// Creates a ConnectionEntity with the given parameters.
  const ConnectionEntity({
    required this.id,
    required this.remoteId,
    required this.host,
    required this.port,
    required this.user,
    required this.serverVersion,
    required this.connectedAt,
    required this.lastActivityAt,
  });

  @override
  List<Object?> get props => [
    id,
    remoteId,
    host,
    port,
    user,
    serverVersion,
    connectedAt,
    lastActivityAt,
  ];
}

/// Command execution result.
class CommandResult extends Equatable {
  /// The exit code of the command.
  final int exitCode;

  /// Standard output from the command.
  final String stdout;

  /// Standard error output from the command.
  final String stderr;

  /// Creates a CommandResult with the given parameters.
  const CommandResult({
    required this.exitCode,
    required this.stdout,
    required this.stderr,
  });

  /// Whether the command completed successfully.
  bool get isSuccess => exitCode == 0;

  @override
  List<Object?> get props => [exitCode, stdout, stderr];
}

/// Status of host key verification.
enum HostKeyVerificationStatus {
  /// Unspecified or unknown status
  unspecified,

  /// Host key matched known_hosts
  verified,

  /// Host not in known_hosts, needs user approval
  unknown,

  /// Host key changed (possible MITM attack)
  mismatch,

  /// Host key was added to known_hosts
  added,
}

/// Information about a host key.
class HostKeyInfo extends Equatable {
  /// The hostname this key belongs to.
  final String hostname;

  /// The SSH port.
  final int port;

  /// The key algorithm (e.g., ssh-ed25519).
  final String keyType;

  /// The SHA256 fingerprint of the key.
  final String fingerprint;

  /// The public key data.
  final String publicKey;

  /// Creates a HostKeyInfo with the given parameters.
  const HostKeyInfo({
    required this.hostname,
    required this.port,
    required this.keyType,
    required this.fingerprint,
    required this.publicKey,
  });

  @override
  List<Object?> get props => [hostname, port, keyType, fingerprint, publicKey];
}

/// Result of testing an SSH connection.
class TestConnectionResult extends Equatable {
  /// Whether the connection test succeeded.
  final bool success;

  /// Status message describing the result.
  final String message;

  /// The SSH server version string if available.
  final String? serverVersion;

  /// Connection latency in milliseconds.
  final int? latencyMs;

  /// The status of host key verification.
  final HostKeyVerificationStatus hostKeyStatus;

  /// Information about the host key if available.
  final HostKeyInfo? hostKeyInfo;

  /// Creates a TestConnectionResult with the given parameters.
  const TestConnectionResult({
    required this.success,
    required this.message,
    this.serverVersion,
    this.latencyMs,
    this.hostKeyStatus = HostKeyVerificationStatus.unspecified,
    this.hostKeyInfo,
  });

  /// Whether the host key needs user approval (unknown host).
  bool get needsHostKeyApproval =>
      hostKeyStatus == HostKeyVerificationStatus.unknown;

  /// Whether there is a host key mismatch (potential security issue).
  bool get hasHostKeyMismatch =>
      hostKeyStatus == HostKeyVerificationStatus.mismatch;

  @override
  List<Object?> get props => [
    success,
    message,
    serverVersion,
    latencyMs,
    hostKeyStatus,
    hostKeyInfo,
  ];
}
