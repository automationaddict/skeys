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
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';

import '../../../core/logging/app_logger.dart';
import '../domain/config_entity.dart';
import '../repository/config_repository.dart';

part 'server_config_event.dart';
part 'server_config_state.dart';

/// BLoC for SSH server configuration (sshd_config) management.
///
/// This BLoC is responsible for managing the SSH server's configuration file,
/// separate from client-side SSH config which is handled by [ConfigBloc].
class ServerConfigBloc extends Bloc<ServerConfigEvent, ServerConfigState> {
  final ConfigRepository _repository;
  final AppLogger _log = AppLogger('bloc.server_config');

  /// Creates a ServerConfigBloc with the given repository.
  ServerConfigBloc(this._repository) : super(const ServerConfigState()) {
    on<ServerConfigLoadRequested>(_onLoadRequested, transformer: droppable());
    on<ServerConfigUpdateOptionRequested>(
      _onUpdateOptionRequested,
      transformer: droppable(),
    );
    on<ServerConfigRestartRequested>(
      _onRestartRequested,
      transformer: droppable(),
    );
    on<ServerConfigClearPendingRestart>(
      _onClearPendingRestart,
      transformer: concurrent(),
    );
    _log.debug('ServerConfigBloc initialized');
  }

  Future<void> _onLoadRequested(
    ServerConfigLoadRequested event,
    Emitter<ServerConfigState> emit,
  ) async {
    _log.debug('loading server config');
    emit(state.copyWith(status: ServerConfigStatus.loading));

    try {
      final config = await _repository.getServerConfig();
      _log.info('server config loaded', {'options': config.options.length});
      emit(state.copyWith(status: ServerConfigStatus.success, config: config));
    } catch (e, st) {
      _log.error('failed to load server config', e, st);
      emit(
        state.copyWith(
          status: ServerConfigStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onUpdateOptionRequested(
    ServerConfigUpdateOptionRequested event,
    Emitter<ServerConfigState> emit,
  ) async {
    _log.info('updating server option', {
      'key': event.key,
      'value': event.value,
    });
    emit(state.copyWith(status: ServerConfigStatus.loading));

    try {
      await _repository.updateServerConfig([
        ServerConfigUpdate(key: event.key, value: event.value),
      ]);
      _log.info('server option updated', {'key': event.key});
      final config = await _repository.getServerConfig();
      emit(
        state.copyWith(
          status: ServerConfigStatus.success,
          config: config,
          pendingRestart: true,
        ),
      );
    } catch (e, st) {
      _log.error('failed to update server option', e, st, {'key': event.key});
      emit(
        state.copyWith(
          status: ServerConfigStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onRestartRequested(
    ServerConfigRestartRequested event,
    Emitter<ServerConfigState> emit,
  ) async {
    _log.info('restarting SSH server');
    emit(state.copyWith(status: ServerConfigStatus.loading));

    try {
      await _repository.restartSSHServer();
      _log.info('SSH server restarted');
      emit(
        state.copyWith(
          status: ServerConfigStatus.success,
          pendingRestart: false,
        ),
      );
    } catch (e, st) {
      _log.error('failed to restart SSH server', e, st);
      emit(
        state.copyWith(
          status: ServerConfigStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onClearPendingRestart(
    ServerConfigClearPendingRestart event,
    Emitter<ServerConfigState> emit,
  ) {
    emit(state.copyWith(pendingRestart: false));
  }
}
