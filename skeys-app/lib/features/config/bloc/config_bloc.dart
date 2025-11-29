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
import '../domain/config_entity.dart';
import '../domain/ssh_config_entry.dart';
import '../repository/config_repository.dart';

part 'config_event.dart';
part 'config_state.dart';

/// BLoC for SSH configuration management.
class ConfigBloc extends Bloc<ConfigEvent, ConfigState> {
  final ConfigRepository _repository;
  final AppLogger _log = AppLogger('bloc.config');
  StreamSubscription<void>? _reconnectionSubscription;

  /// Creates a ConfigBloc with the given repository.
  ConfigBloc(this._repository) : super(const ConfigState()) {
    // Use restartable for watch (cancels previous stream on new request)
    on<ConfigWatchSSHEntriesRequested>(
      _onWatchSSHEntries,
      transformer: restartable(),
    );

    // Use concurrent/droppable for actions so they don't block on watch stream
    // SSH config handlers
    on<ConfigLoadSSHEntriesRequested>(
      _onLoadSSHEntries,
      transformer: concurrent(),
    );
    on<ConfigCreateSSHEntryRequested>(
      _onCreateSSHEntry,
      transformer: droppable(),
    );
    on<ConfigUpdateSSHEntryRequested>(
      _onUpdateSSHEntry,
      transformer: droppable(),
    );
    on<ConfigDeleteSSHEntryRequested>(
      _onDeleteSSHEntry,
      transformer: droppable(),
    );
    on<ConfigReorderSSHEntriesRequested>(
      _onReorderSSHEntries,
      transformer: droppable(),
    );

    // Global directives handlers
    on<ConfigLoadGlobalDirectivesRequested>(
      _onLoadGlobalDirectives,
      transformer: concurrent(),
    );
    on<ConfigSetGlobalDirectiveRequested>(
      _onSetGlobalDirective,
      transformer: droppable(),
    );
    on<ConfigDeleteGlobalDirectiveRequested>(
      _onDeleteGlobalDirective,
      transformer: droppable(),
    );

    // Legacy client host handlers
    on<ConfigLoadClientHostsRequested>(
      _onLoadClientHosts,
      transformer: concurrent(),
    );
    on<ConfigAddClientHostRequested>(
      _onAddClientHost,
      transformer: droppable(),
    );
    on<ConfigUpdateClientHostRequested>(
      _onUpdateClientHost,
      transformer: droppable(),
    );
    on<ConfigDeleteClientHostRequested>(
      _onDeleteClientHost,
      transformer: droppable(),
    );

    _log.debug('ConfigBloc initialized');

    // Listen for reconnection events to refresh streams
    _reconnectionSubscription = getIt<DaemonStatusService>().onReconnected
        .listen((_) {
          _log.info('daemon reconnected, refreshing config stream');
          add(ConfigWatchSSHEntriesRequested());
        });

    // Auto-start watching on creation (singleton pattern)
    add(ConfigWatchSSHEntriesRequested());
  }

  @override
  Future<void> close() {
    _reconnectionSubscription?.cancel();
    return super.close();
  }

  // ============================================================
  // New unified SSH config API handlers
  // ============================================================

  Future<void> _onLoadSSHEntries(
    ConfigLoadSSHEntriesRequested event,
    Emitter<ConfigState> emit,
  ) async {
    _log.debug('loading SSH config entries');
    emit(state.copyWith(status: ConfigStatus.loading));

    try {
      final entries = await _repository.listSSHConfigEntries();
      _log.info('SSH config entries loaded', {'count': entries.length});
      emit(state.copyWith(status: ConfigStatus.success, sshEntries: entries));
    } catch (e, st) {
      _log.error('failed to load SSH config entries', e, st);
      emit(
        state.copyWith(
          status: ConfigStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onWatchSSHEntries(
    ConfigWatchSSHEntriesRequested event,
    Emitter<ConfigState> emit,
  ) async {
    _log.debug('subscribing to SSH config entries stream');
    emit(state.copyWith(status: ConfigStatus.loading));

    await emit.forEach<List<SSHConfigEntry>>(
      _repository.watchSSHConfigEntries(),
      onData: (entries) {
        _log.debug('SSH config entries stream update', {
          'count': entries.length,
        });
        return state.copyWith(
          status: ConfigStatus.success,
          sshEntries: entries,
        );
      },
      onError: (error, stackTrace) {
        _log.error('SSH config entries stream error', error, stackTrace);
        return state.copyWith(
          status: ConfigStatus.failure,
          errorMessage: error.toString(),
        );
      },
    );
  }

  Future<void> _onCreateSSHEntry(
    ConfigCreateSSHEntryRequested event,
    Emitter<ConfigState> emit,
  ) async {
    _log.info('creating SSH config entry', {'patterns': event.entry.patterns});
    emit(state.copyWith(status: ConfigStatus.loading));

    try {
      await _repository.createSSHConfigEntry(
        event.entry,
        insertPosition: event.insertPosition,
      );
      _log.info('SSH config entry created', {'patterns': event.entry.patterns});
      final entries = await _repository.listSSHConfigEntries();
      emit(state.copyWith(status: ConfigStatus.success, sshEntries: entries));
    } catch (e, st) {
      _log.error('failed to create SSH config entry', e, st, {
        'patterns': event.entry.patterns,
      });
      emit(
        state.copyWith(
          status: ConfigStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onUpdateSSHEntry(
    ConfigUpdateSSHEntryRequested event,
    Emitter<ConfigState> emit,
  ) async {
    _log.info('updating SSH config entry', {'id': event.id});
    emit(state.copyWith(status: ConfigStatus.loading));

    try {
      await _repository.updateSSHConfigEntry(event.id, event.entry);
      _log.info('SSH config entry updated', {'id': event.id});
      final entries = await _repository.listSSHConfigEntries();
      emit(state.copyWith(status: ConfigStatus.success, sshEntries: entries));
    } catch (e, st) {
      _log.error('failed to update SSH config entry', e, st, {'id': event.id});
      emit(
        state.copyWith(
          status: ConfigStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onDeleteSSHEntry(
    ConfigDeleteSSHEntryRequested event,
    Emitter<ConfigState> emit,
  ) async {
    _log.info('deleting SSH config entry', {'id': event.id});
    emit(state.copyWith(status: ConfigStatus.loading));

    try {
      await _repository.deleteSSHConfigEntry(event.id);
      _log.info('SSH config entry deleted', {'id': event.id});
      final entries = await _repository.listSSHConfigEntries();
      emit(state.copyWith(status: ConfigStatus.success, sshEntries: entries));
    } catch (e, st) {
      _log.error('failed to delete SSH config entry', e, st, {'id': event.id});
      emit(
        state.copyWith(
          status: ConfigStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onReorderSSHEntries(
    ConfigReorderSSHEntriesRequested event,
    Emitter<ConfigState> emit,
  ) async {
    _log.info('reordering SSH config entries', {
      'count': event.entryIds.length,
    });
    emit(state.copyWith(status: ConfigStatus.loading));

    try {
      final entries = await _repository.reorderSSHConfigEntries(event.entryIds);
      _log.info('SSH config entries reordered');
      emit(state.copyWith(status: ConfigStatus.success, sshEntries: entries));
    } catch (e, st) {
      _log.error('failed to reorder SSH config entries', e, st);
      emit(
        state.copyWith(
          status: ConfigStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  // ============================================================
  // Global directives handlers
  // ============================================================

  Future<void> _onLoadGlobalDirectives(
    ConfigLoadGlobalDirectivesRequested event,
    Emitter<ConfigState> emit,
  ) async {
    _log.debug('loading global directives');
    emit(state.copyWith(status: ConfigStatus.loading));

    try {
      final directives = await _repository.listGlobalDirectives();
      _log.info('global directives loaded', {'count': directives.length});
      emit(
        state.copyWith(
          status: ConfigStatus.success,
          globalDirectives: directives,
        ),
      );
    } catch (e, st) {
      _log.error('failed to load global directives', e, st);
      emit(
        state.copyWith(
          status: ConfigStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onSetGlobalDirective(
    ConfigSetGlobalDirectiveRequested event,
    Emitter<ConfigState> emit,
  ) async {
    _log.info('setting global directive', {
      'key': event.key,
      'value': event.value,
    });
    emit(state.copyWith(status: ConfigStatus.loading));

    try {
      await _repository.setGlobalDirective(event.key, event.value);
      _log.info('global directive set', {'key': event.key});
      final directives = await _repository.listGlobalDirectives();
      emit(
        state.copyWith(
          status: ConfigStatus.success,
          globalDirectives: directives,
        ),
      );
    } catch (e, st) {
      _log.error('failed to set global directive', e, st, {'key': event.key});
      emit(
        state.copyWith(
          status: ConfigStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onDeleteGlobalDirective(
    ConfigDeleteGlobalDirectiveRequested event,
    Emitter<ConfigState> emit,
  ) async {
    _log.info('deleting global directive', {'key': event.key});
    emit(state.copyWith(status: ConfigStatus.loading));

    try {
      await _repository.deleteGlobalDirective(event.key);
      _log.info('global directive deleted', {'key': event.key});
      final directives = await _repository.listGlobalDirectives();
      emit(
        state.copyWith(
          status: ConfigStatus.success,
          globalDirectives: directives,
        ),
      );
    } catch (e, st) {
      _log.error('failed to delete global directive', e, st, {
        'key': event.key,
      });
      emit(
        state.copyWith(
          status: ConfigStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  // ============================================================
  // Legacy client host handlers
  // ============================================================

  Future<void> _onLoadClientHosts(
    ConfigLoadClientHostsRequested event,
    Emitter<ConfigState> emit,
  ) async {
    _log.debug('loading client hosts');
    emit(state.copyWith(status: ConfigStatus.loading));

    try {
      final hosts = await _repository.listHostConfigs();
      _log.info('client hosts loaded', {'count': hosts.length});
      emit(state.copyWith(status: ConfigStatus.success, clientHosts: hosts));
    } catch (e, st) {
      _log.error('failed to load client hosts', e, st);
      emit(
        state.copyWith(
          status: ConfigStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onAddClientHost(
    ConfigAddClientHostRequested event,
    Emitter<ConfigState> emit,
  ) async {
    _log.info('adding client host', {'host': event.entry.host});
    emit(state.copyWith(status: ConfigStatus.loading));

    try {
      await _repository.createHostConfig(event.entry);
      _log.info('client host added', {'host': event.entry.host});
      final hosts = await _repository.listHostConfigs();
      emit(state.copyWith(status: ConfigStatus.success, clientHosts: hosts));
    } catch (e, st) {
      _log.error('failed to add client host', e, st, {
        'host': event.entry.host,
      });
      emit(
        state.copyWith(
          status: ConfigStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onUpdateClientHost(
    ConfigUpdateClientHostRequested event,
    Emitter<ConfigState> emit,
  ) async {
    _log.info('updating client host', {'host': event.entry.host});
    emit(state.copyWith(status: ConfigStatus.loading));

    try {
      await _repository.updateHostConfig(event.entry.host, event.entry);
      _log.info('client host updated', {'host': event.entry.host});
      final hosts = await _repository.listHostConfigs();
      emit(state.copyWith(status: ConfigStatus.success, clientHosts: hosts));
    } catch (e, st) {
      _log.error('failed to update client host', e, st, {
        'host': event.entry.host,
      });
      emit(
        state.copyWith(
          status: ConfigStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onDeleteClientHost(
    ConfigDeleteClientHostRequested event,
    Emitter<ConfigState> emit,
  ) async {
    _log.info('deleting client host', {'host': event.host});
    emit(state.copyWith(status: ConfigStatus.loading));

    try {
      await _repository.deleteHostConfig(event.host);
      _log.info('client host deleted', {'host': event.host});
      final hosts = await _repository.listHostConfigs();
      emit(state.copyWith(status: ConfigStatus.success, clientHosts: hosts));
    } catch (e, st) {
      _log.error('failed to delete client host', e, st, {'host': event.host});
      emit(
        state.copyWith(
          status: ConfigStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
