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
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';

import '../../../core/backend/daemon_status_service.dart';
import '../../../core/di/injection.dart';
import '../../../core/logging/app_logger.dart';
import '../../../core/settings/settings_service.dart';
import '../../agent/repository/agent_repository.dart';
import '../../remote/domain/remote_entity.dart';
import '../../remote/repository/remote_repository.dart';
import '../domain/key_entity.dart';
import '../repository/keys_repository.dart';

part 'keys_event.dart';
part 'keys_state.dart';

/// BLoC for managing SSH keys.
class KeysBloc extends Bloc<KeysEvent, KeysState> {
  final KeysRepository _repository;
  final RemoteRepository _remoteRepository;
  final AgentRepository _agentRepository;
  final AppLogger _log = AppLogger('bloc.keys');
  StreamSubscription<void>? _reconnectionSubscription;

  /// Creates a KeysBloc with the given repositories.
  KeysBloc(this._repository, this._remoteRepository, this._agentRepository)
    : super(const KeysState()) {
    // Use restartable for watch (cancels previous stream on new request)
    on<KeysWatchRequested>(_onWatchRequested, transformer: restartable());
    // Use concurrent/droppable for actions so they don't block on watch stream
    on<KeysLoadRequested>(_onLoadRequested, transformer: concurrent());
    on<KeysGenerateRequested>(_onGenerateRequested, transformer: droppable());
    on<KeysDeleteRequested>(_onDeleteRequested, transformer: droppable());
    on<KeysChangePassphraseRequested>(
      _onChangePassphraseRequested,
      transformer: droppable(),
    );
    on<KeysCopyPublicKeyRequested>(
      _onCopyPublicKeyRequested,
      transformer: concurrent(),
    );
    on<KeysTestConnectionRequested>(
      _onTestConnectionRequested,
      transformer: droppable(),
    );
    on<KeysTestConnectionCleared>(
      _onTestConnectionCleared,
      transformer: concurrent(),
    );
    on<KeysAddToAgentRequested>(
      _onAddToAgentRequested,
      transformer: droppable(),
    );
    on<KeysAddToAgentCleared>(_onAddToAgentCleared, transformer: concurrent());
    _log.debug('KeysBloc initialized');

    // Listen for reconnection events to refresh streams
    _reconnectionSubscription = getIt<DaemonStatusService>().onReconnected
        .listen((_) {
          _log.info('daemon reconnected, refreshing keys stream');
          add(KeysWatchRequested());
        });

    // Auto-start watching on creation (singleton pattern)
    // Note: The daemon's WatchKeys stream automatically updates when agent
    // state changes (keys added/removed), so no client-side listener needed.
    add(KeysWatchRequested());
  }

  @override
  Future<void> close() {
    _reconnectionSubscription?.cancel();
    return super.close();
  }

  Future<void> _onLoadRequested(
    KeysLoadRequested event,
    Emitter<KeysState> emit,
  ) async {
    _log.debug('loading keys');
    emit(state.copyWith(status: KeysStatus.loading));

    try {
      final keys = await _repository.listKeys();
      _log.info('keys loaded', {'count': keys.length});
      emit(state.copyWith(status: KeysStatus.success, keys: keys));
    } catch (e, st) {
      _log.error('failed to load keys', e, st);
      emit(
        state.copyWith(status: KeysStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onWatchRequested(
    KeysWatchRequested event,
    Emitter<KeysState> emit,
  ) async {
    _log.debug('subscribing to keys stream');
    emit(state.copyWith(status: KeysStatus.loading));

    await emit.forEach<List<KeyEntity>>(
      _repository.watchKeys(),
      onData: (keys) {
        _log.debug('keys stream update', {'count': keys.length});
        return state.copyWith(status: KeysStatus.success, keys: keys);
      },
      onError: (error, stackTrace) {
        _log.error('keys stream error', error, stackTrace);
        return state.copyWith(
          status: KeysStatus.failure,
          errorMessage: error.toString(),
        );
      },
    );
  }

  Future<void> _onGenerateRequested(
    KeysGenerateRequested event,
    Emitter<KeysState> emit,
  ) async {
    _log.info('generating key', {
      'name': event.name,
      'type': event.type.name,
      'bits': event.bits,
    });
    emit(state.copyWith(status: KeysStatus.loading));

    try {
      await _repository.generateKey(
        name: event.name,
        type: event.type,
        bits: event.bits,
        comment: event.comment,
        passphrase: event.passphrase,
        addToAgent: event.addToAgent,
      );
      _log.info('key generated successfully', {'name': event.name});

      // Reload keys after generation
      final keys = await _repository.listKeys();
      emit(state.copyWith(status: KeysStatus.success, keys: keys));
    } catch (e, st) {
      _log.error('failed to generate key', e, st, {'name': event.name});
      emit(
        state.copyWith(status: KeysStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onDeleteRequested(
    KeysDeleteRequested event,
    Emitter<KeysState> emit,
  ) async {
    _log.info('deleting key', {'path': event.path});
    emit(state.copyWith(status: KeysStatus.loading));

    try {
      await _repository.deleteKey(event.path);
      _log.info('key deleted successfully', {'path': event.path});

      // Reload keys after deletion
      final keys = await _repository.listKeys();
      emit(state.copyWith(status: KeysStatus.success, keys: keys));
    } catch (e, st) {
      _log.error('failed to delete key', e, st, {'path': event.path});
      emit(
        state.copyWith(status: KeysStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onChangePassphraseRequested(
    KeysChangePassphraseRequested event,
    Emitter<KeysState> emit,
  ) async {
    _log.info('changing passphrase', {'path': event.path});
    emit(state.copyWith(status: KeysStatus.loading));

    try {
      await _repository.changePassphrase(
        event.path,
        event.oldPassphrase,
        event.newPassphrase,
      );
      _log.info('passphrase changed successfully', {'path': event.path});

      emit(state.copyWith(status: KeysStatus.success));
    } catch (e, st) {
      _log.error('failed to change passphrase', e, st, {'path': event.path});
      emit(
        state.copyWith(status: KeysStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onCopyPublicKeyRequested(
    KeysCopyPublicKeyRequested event,
    Emitter<KeysState> emit,
  ) async {
    _log.debug('copying public key', {'path': event.path});

    try {
      // Get the key to access its public key content
      final key = await _repository.getKey(event.path);
      _log.debug('public key retrieved for copy', {'path': event.path});
      emit(
        state.copyWith(
          status: KeysStatus.success,
          copiedPublicKey: key.publicKey,
        ),
      );
    } catch (e, st) {
      _log.error('failed to get public key', e, st, {'path': event.path});
      emit(
        state.copyWith(status: KeysStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onTestConnectionRequested(
    KeysTestConnectionRequested event,
    Emitter<KeysState> emit,
  ) async {
    _log.info('testing connection', {
      'keyPath': event.keyPath,
      'host': event.host,
      'port': event.port,
      'user': event.user,
      'trustHostKey': event.trustHostKey,
    });
    emit(
      state.copyWith(
        status: KeysStatus.testingConnection,
        clearTestResult: true,
      ),
    );

    try {
      final result = await _remoteRepository.testConnection(
        host: event.host,
        port: event.port,
        user: event.user,
        identityFile: event.keyPath,
        timeoutSeconds: 10,
        passphrase: event.passphrase,
        trustHostKey: event.trustHostKey,
      );
      _log.info('connection test completed', {
        'success': result.success,
        'message': result.message,
        'hostKeyStatus': result.hostKeyStatus.name,
      });
      emit(
        state.copyWith(
          status: KeysStatus.success,
          testConnectionResult: ConnectionTestResult(
            success: result.success,
            message: result.message,
            serverVersion: result.serverVersion,
            latencyMs: result.latencyMs,
            host: event.host,
            hostKeyStatus: result.hostKeyStatus,
            hostKeyInfo: result.hostKeyInfo,
          ),
        ),
      );
    } catch (e, st) {
      _log.error('connection test failed', e, st, {'host': event.host});
      emit(
        state.copyWith(
          status: KeysStatus.success,
          testConnectionResult: ConnectionTestResult(
            success: false,
            message: e.toString(),
            host: event.host,
          ),
        ),
      );
    }
  }

  void _onTestConnectionCleared(
    KeysTestConnectionCleared event,
    Emitter<KeysState> emit,
  ) {
    emit(state.copyWith(clearTestResult: true));
  }

  Future<void> _onAddToAgentRequested(
    KeysAddToAgentRequested event,
    Emitter<KeysState> emit,
  ) async {
    _log.info('add to agent requested', {
      'keyPath': event.keyPath,
      'host': event.host,
      'verifyConnection': event.host != null,
    });

    // If host is provided, verify connection first
    if (event.host != null && event.user != null) {
      emit(
        state.copyWith(
          addToAgentStatus: AddToAgentStatus.verifyingConnection,
          clearAddToAgentResult: true,
        ),
      );

      try {
        final result = await _remoteRepository.testConnection(
          host: event.host!,
          port: event.port ?? 22,
          user: event.user!,
          identityFile: event.keyPath,
          timeoutSeconds: 10,
          passphrase: event.passphrase,
          trustHostKey: event.trustHostKey,
        );

        _log.info('connection test completed', {
          'success': result.success,
          'hostKeyStatus': result.hostKeyStatus.name,
        });

        // Handle host key verification states
        if (result.hostKeyStatus == HostKeyVerificationStatus.unknown &&
            result.hostKeyInfo != null) {
          emit(
            state.copyWith(
              addToAgentStatus: AddToAgentStatus.hostKeyUnknown,
              addToAgentResult: AddToAgentResult(
                status: AddToAgentStatus.hostKeyUnknown,
                hostKeyInfo: result.hostKeyInfo,
                verifiedHost: event.host,
              ),
            ),
          );
          return;
        }

        if (result.hostKeyStatus == HostKeyVerificationStatus.mismatch &&
            result.hostKeyInfo != null) {
          emit(
            state.copyWith(
              addToAgentStatus: AddToAgentStatus.hostKeyMismatch,
              addToAgentResult: AddToAgentResult(
                status: AddToAgentStatus.hostKeyMismatch,
                hostKeyInfo: result.hostKeyInfo,
                verifiedHost: event.host,
              ),
            ),
          );
          return;
        }

        if (!result.success) {
          emit(
            state.copyWith(
              addToAgentStatus: AddToAgentStatus.connectionFailed,
              addToAgentResult: AddToAgentResult(
                status: AddToAgentStatus.connectionFailed,
                errorMessage: result.message,
                verifiedHost: event.host,
              ),
            ),
          );
          return;
        }

        // Connection verified, proceed to add to agent
      } catch (e, st) {
        _log.error('connection verification failed', e, st);
        emit(
          state.copyWith(
            addToAgentStatus: AddToAgentStatus.connectionFailed,
            addToAgentResult: AddToAgentResult(
              status: AddToAgentStatus.connectionFailed,
              errorMessage: e.toString(),
              verifiedHost: event.host,
            ),
          ),
        );
        return;
      }
    }

    // Add key to agent
    emit(state.copyWith(addToAgentStatus: AddToAgentStatus.addingToAgent));

    try {
      // Get timeout from settings
      final settingsService = getIt<SettingsService>();
      final timeoutMinutes = settingsService.agentKeyTimeoutMinutes;
      final lifetime = timeoutMinutes > 0
          ? Duration(minutes: timeoutMinutes)
          : null;

      await _agentRepository.addKey(
        event.keyPath,
        passphrase: event.passphrase,
        lifetime: lifetime,
      );

      _log.info('key added to agent', {'path': event.keyPath});
      emit(
        state.copyWith(
          addToAgentStatus: AddToAgentStatus.success,
          addToAgentResult: AddToAgentResult(
            status: AddToAgentStatus.success,
            verifiedHost: event.host,
          ),
        ),
      );
    } catch (e, st) {
      _log.error('failed to add key to agent', e, st, {'path': event.keyPath});
      emit(
        state.copyWith(
          addToAgentStatus: AddToAgentStatus.agentFailed,
          addToAgentResult: AddToAgentResult(
            status: AddToAgentStatus.agentFailed,
            errorMessage: e.toString(),
          ),
        ),
      );
    }
  }

  void _onAddToAgentCleared(
    KeysAddToAgentCleared event,
    Emitter<KeysState> emit,
  ) {
    emit(
      state.copyWith(
        addToAgentStatus: AddToAgentStatus.idle,
        clearAddToAgentResult: true,
      ),
    );
  }
}
