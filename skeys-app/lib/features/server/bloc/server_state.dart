part of 'server_bloc.dart';

/// Status of server operations.
enum ServerStatus {
  initial,
  loading,
  success,
  failure,
}

/// Result of a service control action.
class ActionResult {
  final bool success;
  final String message;

  const ActionResult({
    required this.success,
    required this.message,
  });
}

/// State for the server feature.
final class ServerState extends Equatable {
  final ServerStatus status;
  final SSHSystemStatus? sshStatus;
  final String? errorMessage;
  final bool actionInProgress;
  final ActionResult? actionResult;

  const ServerState({
    this.status = ServerStatus.initial,
    this.sshStatus,
    this.errorMessage,
    this.actionInProgress = false,
    this.actionResult,
  });

  ServerState copyWith({
    ServerStatus? status,
    SSHSystemStatus? sshStatus,
    String? errorMessage,
    bool? actionInProgress,
    ActionResult? actionResult,
    bool clearActionResult = false,
  }) {
    return ServerState(
      status: status ?? this.status,
      sshStatus: sshStatus ?? this.sshStatus,
      errorMessage: errorMessage,
      actionInProgress: actionInProgress ?? this.actionInProgress,
      actionResult: clearActionResult ? null : (actionResult ?? this.actionResult),
    );
  }

  @override
  List<Object?> get props => [status, sshStatus, errorMessage, actionInProgress, actionResult];
}
