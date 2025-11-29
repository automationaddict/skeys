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

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/backend/daemon_status_service.dart';
import '../../../core/di/injection.dart';
import '../../../core/logging/app_logger.dart';
import '../../../core/settings/settings_service.dart';
import '../domain/agent_entity.dart';
import '../repository/agent_repository.dart';

part 'agent_event.dart';
part 'agent_state.dart';

/// BLoC for SSH agent management.
class AgentBloc extends Bloc<AgentEvent, AgentState> {
  final AgentRepository _repository;
  final AppLogger _log = AppLogger('bloc.agent');
  StreamSubscription<void>? _reconnectionSubscription;
  StreamSubscription<AgentWatchState>? _watchSubscription;

  /// Creates an AgentBloc with the given repository.
  AgentBloc(this._repository) : super(const AgentState()) {
    on<AgentWatchRequested>(_onWatchRequested);
    on<_AgentWatchUpdated>(_onWatchUpdated);
    on<_AgentWatchError>(_onWatchError);
    on<AgentLoadStatusRequested>(_onLoadStatus);
    on<AgentLoadKeysRequested>(_onLoadKeys);
    on<AgentAddKeyRequested>(_onAddKey);
    on<AgentRemoveKeyRequested>(_onRemoveKey);
    on<AgentRemoveAllKeysRequested>(_onRemoveAllKeys);
    on<AgentLockRequested>(_onLock);
    on<AgentUnlockRequested>(_onUnlock);
    _log.debug('AgentBloc initialized');

    // Listen for reconnection events to refresh streams
    _reconnectionSubscription = getIt<DaemonStatusService>().onReconnected
        .listen((_) {
          _log.info('daemon reconnected, refreshing agent stream');
          add(AgentWatchRequested());
        });

    // Auto-start watching on creation (singleton pattern)
    add(AgentWatchRequested());
  }

  @override
  Future<void> close() {
    _reconnectionSubscription?.cancel();
    _watchSubscription?.cancel();
    return super.close();
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
      emit(
        state.copyWith(
          status: AgentBlocStatus.success,
          agentStatus: agentStatus,
        ),
      );
    } catch (e, st) {
      _log.error('failed to load agent status', e, st);
      emit(
        state.copyWith(
          status: AgentBlocStatus.failure,
          errorMessage: e.toString(),
        ),
      );
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
      emit(state.copyWith(status: AgentBlocStatus.success, loadedKeys: keys));
    } catch (e, st) {
      _log.error('failed to load agent keys', e, st);
      emit(
        state.copyWith(
          status: AgentBlocStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  /// Subscribes to the agent stream using manual [StreamSubscription] management.
  ///
  /// This pattern differs from other BLoCs that use `emit.forEach`. The manual
  /// subscription approach is intentional here because:
  ///
  /// 1. **Non-blocking operations**: Using `emit.forEach` blocks the event
  ///    handler until the stream completes. Since the agent stream is long-lived,
  ///    this would prevent other events (add key, remove key, lock, unlock) from
  ///    being processed.
  ///
  /// 2. **Compatible with transformers**: The `restartable` transformer on
  ///    `AgentWatchRequested` can cancel the previous watch when a new one is
  ///    requested. Manual subscription makes this explicit and controllable.
  ///
  /// 3. **Separate event handling**: Stream updates are dispatched as internal
  ///    `_AgentWatchUpdated` events, allowing proper state management and logging
  ///    per update while keeping the watch handler simple.
  ///
  /// Compare with KeysBloc which uses `emit.forEach` - the same pattern works
  /// there because `restartable` cancels the previous forEach automatically.
  /// Both approaches are valid; this one provides more explicit control.
  void _onWatchRequested(AgentWatchRequested event, Emitter<AgentState> emit) {
    _log.debug('subscribing to agent stream');
    _watchSubscription?.cancel();
    emit(state.copyWith(status: AgentBlocStatus.loading));

    _watchSubscription = _repository.watchAgent().listen(
      (watchState) => add(_AgentWatchUpdated(watchState)),
      onError: (error, stackTrace) => add(_AgentWatchError(error.toString())),
    );
  }

  void _onWatchUpdated(_AgentWatchUpdated event, Emitter<AgentState> emit) {
    _log.debug('agent stream update', {
      'running': event.watchState.status.isRunning,
      'locked': event.watchState.status.isLocked,
      'key_count': event.watchState.keys.length,
    });
    emit(
      state.copyWith(
        status: AgentBlocStatus.success,
        agentStatus: event.watchState.status,
        loadedKeys: event.watchState.keys,
        lastCompletedAction: AgentCompletedAction.watchUpdate,
      ),
    );
  }

  void _onWatchError(_AgentWatchError event, Emitter<AgentState> emit) {
    _log.error('agent stream error: ${event.error}');
    emit(
      state.copyWith(
        status: AgentBlocStatus.failure,
        errorMessage: event.error,
      ),
    );
  }

  Future<void> _onAddKey(
    AgentAddKeyRequested event,
    Emitter<AgentState> emit,
  ) async {
    // Get timeout from settings if not specified in event
    final settingsService = getIt<SettingsService>();
    final timeoutMinutes = settingsService.agentKeyTimeoutMinutes;
    final lifetime =
        event.lifetime ??
        (timeoutMinutes > 0 ? Duration(minutes: timeoutMinutes) : null);

    _log.info('adding key to agent', {
      'path': event.keyPath,
      'lifetime': lifetime,
      'confirm': event.confirm,
    });
    emit(state.copyWith(status: AgentBlocStatus.loading));

    try {
      await _repository.addKey(
        event.keyPath,
        passphrase: event.passphrase,
        lifetime: lifetime,
        confirm: event.confirm,
      );
      _log.info('key added to agent', {'path': event.keyPath});
      final keys = await _repository.listKeys();
      final agentStatus = await _repository.getStatus();

      emit(
        state.copyWith(
          status: AgentBlocStatus.success,
          loadedKeys: keys,
          agentStatus: agentStatus,
          lastCompletedAction: AgentCompletedAction.addKey,
        ),
      );
    } catch (e, st) {
      _log.error('failed to add key to agent', e, st, {'path': event.keyPath});
      emit(
        state.copyWith(
          status: AgentBlocStatus.failure,
          errorMessage: e.toString(),
        ),
      );
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
      emit(
        state.copyWith(
          status: AgentBlocStatus.success,
          loadedKeys: keys,
          agentStatus: agentStatus,
          lastCompletedAction: AgentCompletedAction.removeKey,
        ),
      );
    } catch (e, st) {
      _log.error('failed to remove key from agent', e, st, {
        'fingerprint': event.fingerprint,
      });
      emit(
        state.copyWith(
          status: AgentBlocStatus.failure,
          errorMessage: e.toString(),
        ),
      );
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
      emit(
        state.copyWith(
          status: AgentBlocStatus.success,
          loadedKeys: [],
          agentStatus: agentStatus,
          lastCompletedAction: AgentCompletedAction.removeAllKeys,
        ),
      );
    } catch (e, st) {
      _log.error('failed to remove all keys from agent', e, st);
      emit(
        state.copyWith(
          status: AgentBlocStatus.failure,
          errorMessage: e.toString(),
        ),
      );
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
      emit(
        state.copyWith(
          status: AgentBlocStatus.success,
          agentStatus: agentStatus,
          lastCompletedAction: AgentCompletedAction.lock,
        ),
      );
    } catch (e, st) {
      _log.error('failed to lock agent', e, st);
      emit(
        state.copyWith(
          status: AgentBlocStatus.failure,
          errorMessage: e.toString(),
        ),
      );
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
      emit(
        state.copyWith(
          status: AgentBlocStatus.success,
          agentStatus: agentStatus,
          lastCompletedAction: AgentCompletedAction.unlock,
        ),
      );
    } catch (e, st) {
      _log.error('failed to unlock agent', e, st);
      emit(
        state.copyWith(
          status: AgentBlocStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
