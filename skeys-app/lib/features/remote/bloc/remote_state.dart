part of 'remote_bloc.dart';

enum RemoteBlocStatus {
  initial,
  loading,
  success,
  failure,
}

final class RemoteState extends Equatable {
  final RemoteBlocStatus status;
  final List<RemoteEntity> remotes;
  final List<ConnectionEntity> connections;
  final CommandResult? lastCommandResult;
  final String? errorMessage;

  const RemoteState({
    this.status = RemoteBlocStatus.initial,
    this.remotes = const [],
    this.connections = const [],
    this.lastCommandResult,
    this.errorMessage,
  });

  RemoteState copyWith({
    RemoteBlocStatus? status,
    List<RemoteEntity>? remotes,
    List<ConnectionEntity>? connections,
    CommandResult? lastCommandResult,
    String? errorMessage,
  }) {
    return RemoteState(
      status: status ?? this.status,
      remotes: remotes ?? this.remotes,
      connections: connections ?? this.connections,
      lastCommandResult: lastCommandResult ?? this.lastCommandResult,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, remotes, connections, lastCommandResult, errorMessage];
}
