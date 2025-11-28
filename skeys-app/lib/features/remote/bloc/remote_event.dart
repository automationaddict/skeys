part of 'remote_bloc.dart';

sealed class RemoteEvent extends Equatable {
  const RemoteEvent();

  @override
  List<Object?> get props => [];
}

final class RemoteLoadRequested extends RemoteEvent {
  const RemoteLoadRequested();
}

final class RemoteAddRequested extends RemoteEvent {
  final String name;
  final String host;
  final int port;
  final String user;
  final String? identityFile;
  final String? sshConfigAlias;

  const RemoteAddRequested({
    required this.name,
    required this.host,
    required this.port,
    required this.user,
    this.identityFile,
    this.sshConfigAlias,
  });

  @override
  List<Object?> get props => [name, host, port, user, identityFile, sshConfigAlias];
}

final class RemoteDeleteRequested extends RemoteEvent {
  final String id;

  const RemoteDeleteRequested(this.id);

  @override
  List<Object?> get props => [id];
}

final class RemoteConnectRequested extends RemoteEvent {
  final String remoteId;
  final String? passphrase;

  const RemoteConnectRequested({
    required this.remoteId,
    this.passphrase,
  });

  @override
  List<Object?> get props => [remoteId, passphrase];
}

final class RemoteDisconnectRequested extends RemoteEvent {
  final String connectionId;

  const RemoteDisconnectRequested(this.connectionId);

  @override
  List<Object?> get props => [connectionId];
}

final class RemoteLoadConnectionsRequested extends RemoteEvent {
  const RemoteLoadConnectionsRequested();
}

final class RemoteWatchConnectionsRequested extends RemoteEvent {
  const RemoteWatchConnectionsRequested();
}

final class RemoteExecuteCommandRequested extends RemoteEvent {
  final String connectionId;
  final String command;
  final int? timeout;

  const RemoteExecuteCommandRequested({
    required this.connectionId,
    required this.command,
    this.timeout,
  });

  @override
  List<Object?> get props => [connectionId, command, timeout];
}
