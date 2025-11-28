import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

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

  ConfigBloc(this._repository) : super(const ConfigState()) {
    // New unified SSH config API handlers
    on<ConfigLoadSSHEntriesRequested>(_onLoadSSHEntries);
    on<ConfigWatchSSHEntriesRequested>(_onWatchSSHEntries);
    on<ConfigCreateSSHEntryRequested>(_onCreateSSHEntry);
    on<ConfigUpdateSSHEntryRequested>(_onUpdateSSHEntry);
    on<ConfigDeleteSSHEntryRequested>(_onDeleteSSHEntry);
    on<ConfigReorderSSHEntriesRequested>(_onReorderSSHEntries);

    // Global directives handlers
    on<ConfigLoadGlobalDirectivesRequested>(_onLoadGlobalDirectives);
    on<ConfigSetGlobalDirectiveRequested>(_onSetGlobalDirective);
    on<ConfigDeleteGlobalDirectiveRequested>(_onDeleteGlobalDirective);

    // Legacy client host handlers
    on<ConfigLoadClientHostsRequested>(_onLoadClientHosts);
    on<ConfigAddClientHostRequested>(_onAddClientHost);
    on<ConfigUpdateClientHostRequested>(_onUpdateClientHost);
    on<ConfigDeleteClientHostRequested>(_onDeleteClientHost);

    // Server config handlers
    on<ConfigLoadServerConfigRequested>(_onLoadServerConfig);
    on<ConfigUpdateServerOptionRequested>(_onUpdateServerOption);
    on<ConfigRestartSSHServerRequested>(_onRestartSSHServer);

    _log.debug('ConfigBloc initialized');
    // Auto-start watching on creation (singleton pattern)
    add(ConfigWatchSSHEntriesRequested());
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
      emit(state.copyWith(
        status: ConfigStatus.success,
        sshEntries: entries,
      ));
    } catch (e, st) {
      _log.error('failed to load SSH config entries', e, st);
      emit(state.copyWith(
        status: ConfigStatus.failure,
        errorMessage: e.toString(),
      ));
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
        _log.debug('SSH config entries stream update', {'count': entries.length});
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
      emit(state.copyWith(
        status: ConfigStatus.success,
        sshEntries: entries,
      ));
    } catch (e, st) {
      _log.error('failed to create SSH config entry', e, st, {'patterns': event.entry.patterns});
      emit(state.copyWith(
        status: ConfigStatus.failure,
        errorMessage: e.toString(),
      ));
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
      emit(state.copyWith(
        status: ConfigStatus.success,
        sshEntries: entries,
      ));
    } catch (e, st) {
      _log.error('failed to update SSH config entry', e, st, {'id': event.id});
      emit(state.copyWith(
        status: ConfigStatus.failure,
        errorMessage: e.toString(),
      ));
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
      emit(state.copyWith(
        status: ConfigStatus.success,
        sshEntries: entries,
      ));
    } catch (e, st) {
      _log.error('failed to delete SSH config entry', e, st, {'id': event.id});
      emit(state.copyWith(
        status: ConfigStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onReorderSSHEntries(
    ConfigReorderSSHEntriesRequested event,
    Emitter<ConfigState> emit,
  ) async {
    _log.info('reordering SSH config entries', {'count': event.entryIds.length});
    emit(state.copyWith(status: ConfigStatus.loading));

    try {
      final entries = await _repository.reorderSSHConfigEntries(event.entryIds);
      _log.info('SSH config entries reordered');
      emit(state.copyWith(
        status: ConfigStatus.success,
        sshEntries: entries,
      ));
    } catch (e, st) {
      _log.error('failed to reorder SSH config entries', e, st);
      emit(state.copyWith(
        status: ConfigStatus.failure,
        errorMessage: e.toString(),
      ));
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
      emit(state.copyWith(
        status: ConfigStatus.success,
        globalDirectives: directives,
      ));
    } catch (e, st) {
      _log.error('failed to load global directives', e, st);
      emit(state.copyWith(
        status: ConfigStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onSetGlobalDirective(
    ConfigSetGlobalDirectiveRequested event,
    Emitter<ConfigState> emit,
  ) async {
    _log.info('setting global directive', {'key': event.key, 'value': event.value});
    emit(state.copyWith(status: ConfigStatus.loading));

    try {
      await _repository.setGlobalDirective(event.key, event.value);
      _log.info('global directive set', {'key': event.key});
      final directives = await _repository.listGlobalDirectives();
      emit(state.copyWith(
        status: ConfigStatus.success,
        globalDirectives: directives,
      ));
    } catch (e, st) {
      _log.error('failed to set global directive', e, st, {'key': event.key});
      emit(state.copyWith(
        status: ConfigStatus.failure,
        errorMessage: e.toString(),
      ));
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
      emit(state.copyWith(
        status: ConfigStatus.success,
        globalDirectives: directives,
      ));
    } catch (e, st) {
      _log.error('failed to delete global directive', e, st, {'key': event.key});
      emit(state.copyWith(
        status: ConfigStatus.failure,
        errorMessage: e.toString(),
      ));
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
      emit(state.copyWith(
        status: ConfigStatus.success,
        clientHosts: hosts,
      ));
    } catch (e, st) {
      _log.error('failed to load client hosts', e, st);
      emit(state.copyWith(
        status: ConfigStatus.failure,
        errorMessage: e.toString(),
      ));
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
      emit(state.copyWith(
        status: ConfigStatus.success,
        clientHosts: hosts,
      ));
    } catch (e, st) {
      _log.error('failed to add client host', e, st, {'host': event.entry.host});
      emit(state.copyWith(
        status: ConfigStatus.failure,
        errorMessage: e.toString(),
      ));
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
      emit(state.copyWith(
        status: ConfigStatus.success,
        clientHosts: hosts,
      ));
    } catch (e, st) {
      _log.error('failed to update client host', e, st, {'host': event.entry.host});
      emit(state.copyWith(
        status: ConfigStatus.failure,
        errorMessage: e.toString(),
      ));
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
      emit(state.copyWith(
        status: ConfigStatus.success,
        clientHosts: hosts,
      ));
    } catch (e, st) {
      _log.error('failed to delete client host', e, st, {'host': event.host});
      emit(state.copyWith(
        status: ConfigStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onLoadServerConfig(
    ConfigLoadServerConfigRequested event,
    Emitter<ConfigState> emit,
  ) async {
    _log.debug('loading server config');
    emit(state.copyWith(status: ConfigStatus.loading));

    try {
      final config = await _repository.getServerConfig();
      _log.info('server config loaded', {'options': config.options.length});
      emit(state.copyWith(
        status: ConfigStatus.success,
        serverConfig: config,
      ));
    } catch (e, st) {
      _log.error('failed to load server config', e, st);
      emit(state.copyWith(
        status: ConfigStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onUpdateServerOption(
    ConfigUpdateServerOptionRequested event,
    Emitter<ConfigState> emit,
  ) async {
    _log.info('updating server option', {'key': event.key, 'value': event.value});
    emit(state.copyWith(status: ConfigStatus.loading));

    try {
      await _repository.updateServerConfig([
        ServerConfigUpdate(key: event.key, value: event.value),
      ]);
      _log.info('server option updated', {'key': event.key});
      final config = await _repository.getServerConfig();
      emit(state.copyWith(
        status: ConfigStatus.success,
        serverConfig: config,
        serverConfigPendingRestart: true,
      ));
    } catch (e, st) {
      _log.error('failed to update server option', e, st, {'key': event.key});
      emit(state.copyWith(
        status: ConfigStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onRestartSSHServer(
    ConfigRestartSSHServerRequested event,
    Emitter<ConfigState> emit,
  ) async {
    _log.info('restarting SSH server');
    emit(state.copyWith(status: ConfigStatus.loading));

    try {
      await _repository.restartSSHServer();
      _log.info('SSH server restarted');
      emit(state.copyWith(
        status: ConfigStatus.success,
        serverConfigPendingRestart: false,
      ));
    } catch (e, st) {
      _log.error('failed to restart SSH server', e, st);
      emit(state.copyWith(
        status: ConfigStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
