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

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/logging/app_logger.dart';
import '../domain/server_entity.dart';
import '../repository/server_repository.dart';

part 'server_event.dart';
part 'server_state.dart';

/// BLoC for managing SSH server status and controls.
class ServerBloc extends Bloc<ServerEvent, ServerState> {
  final ServerRepository _repository;
  final AppLogger _log = AppLogger('bloc.server');

  ServerBloc(this._repository) : super(const ServerState()) {
    on<ServerWatchRequested>(_onWatchRequested);
    on<ServerStartRequested>(_onStartRequested);
    on<ServerStopRequested>(_onStopRequested);
    on<ServerRestartRequested>(_onRestartRequested);
    on<ServerEnableRequested>(_onEnableRequested);
    on<ServerDisableRequested>(_onDisableRequested);
    on<ServerActionResultCleared>(_onActionResultCleared);
    _log.debug('ServerBloc initialized');
    // Auto-start watching on creation (singleton pattern)
    add(ServerWatchRequested());
  }

  Future<void> _onWatchRequested(
    ServerWatchRequested event,
    Emitter<ServerState> emit,
  ) async {
    _log.debug('subscribing to SSH status stream');
    emit(state.copyWith(status: ServerStatus.loading));

    await emit.forEach<SSHSystemStatus>(
      _repository.watchSSHStatus(),
      onData: (sshStatus) {
        _log.debug('SSH status stream update');
        return state.copyWith(
          status: ServerStatus.success,
          sshStatus: sshStatus,
        );
      },
      onError: (error, stackTrace) {
        _log.error('SSH status stream error', error, stackTrace);
        return state.copyWith(
          status: ServerStatus.failure,
          errorMessage: error.toString(),
        );
      },
    );
  }

  Future<void> _onStartRequested(
    ServerStartRequested event,
    Emitter<ServerState> emit,
  ) async {
    _log.info('starting SSH service');
    emit(state.copyWith(actionInProgress: true, clearActionResult: true));

    try {
      final result = await _repository.startService();
      _log.info('SSH service start result', {
        'success': result.success,
        'message': result.message,
      });
      emit(
        state.copyWith(
          actionInProgress: false,
          actionResult: ActionResult(
            success: result.success,
            message: result.success
                ? 'SSH service started successfully'
                : 'Failed to start SSH service: ${result.message}',
          ),
        ),
      );
    } catch (e, st) {
      _log.error('failed to start SSH service', e, st);
      emit(
        state.copyWith(
          actionInProgress: false,
          actionResult: ActionResult(success: false, message: 'Error: $e'),
        ),
      );
    }
  }

  Future<void> _onStopRequested(
    ServerStopRequested event,
    Emitter<ServerState> emit,
  ) async {
    _log.info('stopping SSH service');
    emit(state.copyWith(actionInProgress: true, clearActionResult: true));

    try {
      final result = await _repository.stopService();
      _log.info('SSH service stop result', {
        'success': result.success,
        'message': result.message,
      });
      emit(
        state.copyWith(
          actionInProgress: false,
          actionResult: ActionResult(
            success: result.success,
            message: result.success
                ? 'SSH service stopped successfully'
                : 'Failed to stop SSH service: ${result.message}',
          ),
        ),
      );
    } catch (e, st) {
      _log.error('failed to stop SSH service', e, st);
      emit(
        state.copyWith(
          actionInProgress: false,
          actionResult: ActionResult(success: false, message: 'Error: $e'),
        ),
      );
    }
  }

  Future<void> _onRestartRequested(
    ServerRestartRequested event,
    Emitter<ServerState> emit,
  ) async {
    _log.info('restarting SSH service');
    emit(state.copyWith(actionInProgress: true, clearActionResult: true));

    try {
      final result = await _repository.restartService();
      _log.info('SSH service restart result', {
        'success': result.success,
        'message': result.message,
      });
      emit(
        state.copyWith(
          actionInProgress: false,
          actionResult: ActionResult(
            success: result.success,
            message: result.success
                ? 'SSH service restarted successfully'
                : 'Failed to restart SSH service: ${result.message}',
          ),
        ),
      );
    } catch (e, st) {
      _log.error('failed to restart SSH service', e, st);
      emit(
        state.copyWith(
          actionInProgress: false,
          actionResult: ActionResult(success: false, message: 'Error: $e'),
        ),
      );
    }
  }

  Future<void> _onEnableRequested(
    ServerEnableRequested event,
    Emitter<ServerState> emit,
  ) async {
    _log.info('enabling SSH service auto-start');
    emit(state.copyWith(actionInProgress: true, clearActionResult: true));

    try {
      final result = await _repository.enableService();
      _log.info('SSH service enable result', {
        'success': result.success,
        'message': result.message,
      });
      emit(
        state.copyWith(
          actionInProgress: false,
          actionResult: ActionResult(
            success: result.success,
            message: result.success
                ? 'SSH service will start automatically on boot'
                : 'Failed to enable SSH service: ${result.message}',
          ),
        ),
      );
    } catch (e, st) {
      _log.error('failed to enable SSH service', e, st);
      emit(
        state.copyWith(
          actionInProgress: false,
          actionResult: ActionResult(success: false, message: 'Error: $e'),
        ),
      );
    }
  }

  Future<void> _onDisableRequested(
    ServerDisableRequested event,
    Emitter<ServerState> emit,
  ) async {
    _log.info('disabling SSH service auto-start');
    emit(state.copyWith(actionInProgress: true, clearActionResult: true));

    try {
      final result = await _repository.disableService();
      _log.info('SSH service disable result', {
        'success': result.success,
        'message': result.message,
      });
      emit(
        state.copyWith(
          actionInProgress: false,
          actionResult: ActionResult(
            success: result.success,
            message: result.success
                ? 'SSH service will not start automatically on boot'
                : 'Failed to disable SSH service: ${result.message}',
          ),
        ),
      );
    } catch (e, st) {
      _log.error('failed to disable SSH service', e, st);
      emit(
        state.copyWith(
          actionInProgress: false,
          actionResult: ActionResult(success: false, message: 'Error: $e'),
        ),
      );
    }
  }

  void _onActionResultCleared(
    ServerActionResultCleared event,
    Emitter<ServerState> emit,
  ) {
    emit(state.copyWith(clearActionResult: true));
  }
}
