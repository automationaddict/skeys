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
enum RemoteStatus { disconnected, connecting, connected, error }

/// Remote server configuration.
class RemoteEntity extends Equatable {
  final String id;
  final String name;
  final String host;
  final int port;
  final String user;
  final String? identityFile;
  final String? sshConfigAlias;
  final DateTime createdAt;
  final DateTime? lastConnectedAt;
  final RemoteStatus status;

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
  final String id;
  final String remoteId;
  final String host;
  final int port;
  final String user;
  final String serverVersion;
  final DateTime connectedAt;
  final DateTime lastActivityAt;

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
  final int exitCode;
  final String stdout;
  final String stderr;

  const CommandResult({
    required this.exitCode,
    required this.stdout,
    required this.stderr,
  });

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
  final String hostname;
  final int port;
  final String keyType;
  final String fingerprint;
  final String publicKey;

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
  final bool success;
  final String message;
  final String? serverVersion;
  final int? latencyMs;
  final HostKeyVerificationStatus hostKeyStatus;
  final HostKeyInfo? hostKeyInfo;

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
