import 'package:equatable/equatable.dart';

/// Remote connection status.
enum RemoteStatus {
  disconnected,
  connecting,
  connected,
  error,
}

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

/// Result of testing an SSH connection.
class TestConnectionResult extends Equatable {
  final bool success;
  final String message;
  final String? serverVersion;
  final int? latencyMs;

  const TestConnectionResult({
    required this.success,
    required this.message,
    this.serverVersion,
    this.latencyMs,
  });

  @override
  List<Object?> get props => [success, message, serverVersion, latencyMs];
}
