import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/logging/app_logger.dart';
import '../domain/config_entity.dart';
import '../repository/config_repository.dart';

part 'config_event.dart';
part 'config_state.dart';

/// BLoC for SSH configuration management.
class ConfigBloc extends Bloc<ConfigEvent, ConfigState> {
  final ConfigRepository _repository;
  final AppLogger _log = AppLogger('bloc.config');

  ConfigBloc(this._repository) : super(const ConfigState()) {
    on<ConfigLoadClientHostsRequested>(_onLoadClientHosts);
    on<ConfigAddClientHostRequested>(_onAddClientHost);
    on<ConfigUpdateClientHostRequested>(_onUpdateClientHost);
    on<ConfigDeleteClientHostRequested>(_onDeleteClientHost);
    on<ConfigLoadServerConfigRequested>(_onLoadServerConfig);
    on<ConfigUpdateServerOptionRequested>(_onUpdateServerOption);
    _log.debug('ConfigBloc initialized');
  }

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
      ));
    } catch (e, st) {
      _log.error('failed to update server option', e, st, {'key': event.key});
      emit(state.copyWith(
        status: ConfigStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
