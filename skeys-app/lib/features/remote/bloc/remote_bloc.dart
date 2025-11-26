import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/logging/app_logger.dart';
import '../domain/remote_entity.dart';
import '../repository/remote_repository.dart';

part 'remote_event.dart';
part 'remote_state.dart';

/// BLoC for remote server management.
class RemoteBloc extends Bloc<RemoteEvent, RemoteState> {
  final RemoteRepository _repository;
  final AppLogger _log = AppLogger('bloc.remote');

  RemoteBloc(this._repository) : super(const RemoteState()) {
    on<RemoteLoadRequested>(_onLoadRequested);
    on<RemoteAddRequested>(_onAddRequested);
    on<RemoteDeleteRequested>(_onDeleteRequested);
    on<RemoteConnectRequested>(_onConnectRequested);
    on<RemoteDisconnectRequested>(_onDisconnectRequested);
    on<RemoteLoadConnectionsRequested>(_onLoadConnections);
    on<RemoteExecuteCommandRequested>(_onExecuteCommand);
    _log.debug('RemoteBloc initialized');
  }

  Future<void> _onLoadRequested(
    RemoteLoadRequested event,
    Emitter<RemoteState> emit,
  ) async {
    _log.debug('loading remotes');
    emit(state.copyWith(status: RemoteBlocStatus.loading));

    try {
      final remotes = await _repository.listRemotes();
      _log.info('remotes loaded', {'count': remotes.length});
      emit(state.copyWith(
        status: RemoteBlocStatus.success,
        remotes: remotes,
      ));
    } catch (e, st) {
      _log.error('failed to load remotes', e, st);
      emit(state.copyWith(
        status: RemoteBlocStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onAddRequested(
    RemoteAddRequested event,
    Emitter<RemoteState> emit,
  ) async {
    _log.info('adding remote', {
      'name': event.name,
      'host': event.host,
      'port': event.port,
      'user': event.user,
    });
    emit(state.copyWith(status: RemoteBlocStatus.loading));

    try {
      await _repository.addRemote(
        name: event.name,
        host: event.host,
        port: event.port,
        user: event.user,
        identityFile: event.identityFile,
        sshConfigAlias: event.sshConfigAlias,
      );
      _log.info('remote added', {'name': event.name});
      final remotes = await _repository.listRemotes();
      emit(state.copyWith(
        status: RemoteBlocStatus.success,
        remotes: remotes,
      ));
    } catch (e, st) {
      _log.error('failed to add remote', e, st, {'name': event.name});
      emit(state.copyWith(
        status: RemoteBlocStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onDeleteRequested(
    RemoteDeleteRequested event,
    Emitter<RemoteState> emit,
  ) async {
    _log.info('deleting remote', {'id': event.id});
    emit(state.copyWith(status: RemoteBlocStatus.loading));

    try {
      await _repository.deleteRemote(event.id);
      _log.info('remote deleted', {'id': event.id});
      final remotes = await _repository.listRemotes();
      emit(state.copyWith(
        status: RemoteBlocStatus.success,
        remotes: remotes,
      ));
    } catch (e, st) {
      _log.error('failed to delete remote', e, st, {'id': event.id});
      emit(state.copyWith(
        status: RemoteBlocStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onConnectRequested(
    RemoteConnectRequested event,
    Emitter<RemoteState> emit,
  ) async {
    _log.info('connecting to remote', {'remote_id': event.remoteId});
    emit(state.copyWith(status: RemoteBlocStatus.loading));

    try {
      await _repository.connect(event.remoteId, passphrase: event.passphrase);
      _log.info('connected to remote', {'remote_id': event.remoteId});
      final remotes = await _repository.listRemotes();
      final connections = await _repository.listConnections();
      emit(state.copyWith(
        status: RemoteBlocStatus.success,
        remotes: remotes,
        connections: connections,
      ));
    } catch (e, st) {
      _log.error('failed to connect to remote', e, st, {'remote_id': event.remoteId});
      emit(state.copyWith(
        status: RemoteBlocStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onDisconnectRequested(
    RemoteDisconnectRequested event,
    Emitter<RemoteState> emit,
  ) async {
    _log.info('disconnecting from remote', {'connection_id': event.connectionId});
    emit(state.copyWith(status: RemoteBlocStatus.loading));

    try {
      await _repository.disconnect(event.connectionId);
      _log.info('disconnected from remote', {'connection_id': event.connectionId});
      final remotes = await _repository.listRemotes();
      final connections = await _repository.listConnections();
      emit(state.copyWith(
        status: RemoteBlocStatus.success,
        remotes: remotes,
        connections: connections,
      ));
    } catch (e, st) {
      _log.error('failed to disconnect from remote', e, st, {'connection_id': event.connectionId});
      emit(state.copyWith(
        status: RemoteBlocStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onLoadConnections(
    RemoteLoadConnectionsRequested event,
    Emitter<RemoteState> emit,
  ) async {
    _log.debug('loading connections');

    try {
      final connections = await _repository.listConnections();
      _log.info('connections loaded', {'count': connections.length});
      emit(state.copyWith(connections: connections));
    } catch (e, st) {
      _log.error('failed to load connections', e, st);
      emit(state.copyWith(
        status: RemoteBlocStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onExecuteCommand(
    RemoteExecuteCommandRequested event,
    Emitter<RemoteState> emit,
  ) async {
    _log.info('executing command', {
      'connection_id': event.connectionId,
      'command': event.command,
    });
    emit(state.copyWith(status: RemoteBlocStatus.loading));

    try {
      final result = await _repository.executeCommand(
        event.connectionId,
        event.command,
        timeout: event.timeout,
      );
      _log.info('command executed', {
        'connection_id': event.connectionId,
        'exit_code': result.exitCode,
      });
      emit(state.copyWith(
        status: RemoteBlocStatus.success,
        lastCommandResult: result,
      ));
    } catch (e, st) {
      _log.error('failed to execute command', e, st, {
        'connection_id': event.connectionId,
        'command': event.command,
      });
      emit(state.copyWith(
        status: RemoteBlocStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
