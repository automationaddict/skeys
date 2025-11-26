import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/logging/app_logger.dart';
import '../domain/agent_entity.dart';
import '../repository/agent_repository.dart';

part 'agent_event.dart';
part 'agent_state.dart';

/// BLoC for SSH agent management.
class AgentBloc extends Bloc<AgentEvent, AgentState> {
  final AgentRepository _repository;
  final AppLogger _log = AppLogger('bloc.agent');

  AgentBloc(this._repository) : super(const AgentState()) {
    on<AgentLoadStatusRequested>(_onLoadStatus);
    on<AgentLoadKeysRequested>(_onLoadKeys);
    on<AgentAddKeyRequested>(_onAddKey);
    on<AgentRemoveKeyRequested>(_onRemoveKey);
    on<AgentRemoveAllKeysRequested>(_onRemoveAllKeys);
    on<AgentLockRequested>(_onLock);
    on<AgentUnlockRequested>(_onUnlock);
    _log.debug('AgentBloc initialized');
  }

  Future<void> _onLoadStatus(
    AgentLoadStatusRequested event,
    Emitter<AgentState> emit,
  ) async {
    _log.debug('loading agent status');
    emit(state.copyWith(status: AgentBlocStatus.loading));

    try {
      final agentStatus = await _repository.getStatus();
      _log.info('agent status loaded', {
        'running': agentStatus.isRunning,
        'locked': agentStatus.isLocked,
        'key_count': agentStatus.keyCount,
      });
      emit(state.copyWith(
        status: AgentBlocStatus.success,
        agentStatus: agentStatus,
      ));
    } catch (e, st) {
      _log.error('failed to load agent status', e, st);
      emit(state.copyWith(
        status: AgentBlocStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onLoadKeys(
    AgentLoadKeysRequested event,
    Emitter<AgentState> emit,
  ) async {
    _log.debug('loading agent keys');
    emit(state.copyWith(status: AgentBlocStatus.loading));

    try {
      final keys = await _repository.listKeys();
      _log.info('agent keys loaded', {'count': keys.length});
      emit(state.copyWith(
        status: AgentBlocStatus.success,
        loadedKeys: keys,
      ));
    } catch (e, st) {
      _log.error('failed to load agent keys', e, st);
      emit(state.copyWith(
        status: AgentBlocStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onAddKey(
    AgentAddKeyRequested event,
    Emitter<AgentState> emit,
  ) async {
    _log.info('adding key to agent', {
      'path': event.keyPath,
      'lifetime': event.lifetime,
      'confirm': event.confirm,
    });
    emit(state.copyWith(status: AgentBlocStatus.loading));

    try {
      await _repository.addKey(
        event.keyPath,
        passphrase: event.passphrase,
        lifetime: event.lifetime,
        confirm: event.confirm,
      );
      _log.info('key added to agent', {'path': event.keyPath});
      final keys = await _repository.listKeys();
      final agentStatus = await _repository.getStatus();
      emit(state.copyWith(
        status: AgentBlocStatus.success,
        loadedKeys: keys,
        agentStatus: agentStatus,
      ));
    } catch (e, st) {
      _log.error('failed to add key to agent', e, st, {'path': event.keyPath});
      emit(state.copyWith(
        status: AgentBlocStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onRemoveKey(
    AgentRemoveKeyRequested event,
    Emitter<AgentState> emit,
  ) async {
    _log.info('removing key from agent', {'fingerprint': event.fingerprint});
    emit(state.copyWith(status: AgentBlocStatus.loading));

    try {
      await _repository.removeKey(event.fingerprint);
      _log.info('key removed from agent', {'fingerprint': event.fingerprint});
      final keys = await _repository.listKeys();
      final agentStatus = await _repository.getStatus();
      emit(state.copyWith(
        status: AgentBlocStatus.success,
        loadedKeys: keys,
        agentStatus: agentStatus,
      ));
    } catch (e, st) {
      _log.error('failed to remove key from agent', e, st, {'fingerprint': event.fingerprint});
      emit(state.copyWith(
        status: AgentBlocStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onRemoveAllKeys(
    AgentRemoveAllKeysRequested event,
    Emitter<AgentState> emit,
  ) async {
    _log.info('removing all keys from agent');
    emit(state.copyWith(status: AgentBlocStatus.loading));

    try {
      await _repository.removeAllKeys();
      _log.info('all keys removed from agent');
      final agentStatus = await _repository.getStatus();
      emit(state.copyWith(
        status: AgentBlocStatus.success,
        loadedKeys: [],
        agentStatus: agentStatus,
      ));
    } catch (e, st) {
      _log.error('failed to remove all keys from agent', e, st);
      emit(state.copyWith(
        status: AgentBlocStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onLock(
    AgentLockRequested event,
    Emitter<AgentState> emit,
  ) async {
    _log.info('locking agent');
    emit(state.copyWith(status: AgentBlocStatus.loading));

    try {
      await _repository.lock(event.passphrase);
      _log.info('agent locked');
      final agentStatus = await _repository.getStatus();
      emit(state.copyWith(
        status: AgentBlocStatus.success,
        agentStatus: agentStatus,
      ));
    } catch (e, st) {
      _log.error('failed to lock agent', e, st);
      emit(state.copyWith(
        status: AgentBlocStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onUnlock(
    AgentUnlockRequested event,
    Emitter<AgentState> emit,
  ) async {
    _log.info('unlocking agent');
    emit(state.copyWith(status: AgentBlocStatus.loading));

    try {
      await _repository.unlock(event.passphrase);
      _log.info('agent unlocked');
      final agentStatus = await _repository.getStatus();
      emit(state.copyWith(
        status: AgentBlocStatus.success,
        agentStatus: agentStatus,
      ));
    } catch (e, st) {
      _log.error('failed to unlock agent', e, st);
      emit(state.copyWith(
        status: AgentBlocStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
