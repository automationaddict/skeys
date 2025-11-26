import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/logging/app_logger.dart';
import '../domain/host_entity.dart';
import '../repository/hosts_repository.dart';

part 'hosts_event.dart';
part 'hosts_state.dart';

/// BLoC for host management.
class HostsBloc extends Bloc<HostsEvent, HostsState> {
  final HostsRepository _repository;
  final AppLogger _log = AppLogger('bloc.hosts');

  HostsBloc(this._repository) : super(const HostsState()) {
    on<HostsLoadKnownHostsRequested>(_onLoadKnownHosts);
    on<HostsRemoveKnownHostRequested>(_onRemoveKnownHost);
    on<HostsHashKnownHostsRequested>(_onHashKnownHosts);
    on<HostsLoadAuthorizedKeysRequested>(_onLoadAuthorizedKeys);
    on<HostsAddAuthorizedKeyRequested>(_onAddAuthorizedKey);
    on<HostsRemoveAuthorizedKeyRequested>(_onRemoveAuthorizedKey);
    _log.debug('HostsBloc initialized');
  }

  Future<void> _onLoadKnownHosts(
    HostsLoadKnownHostsRequested event,
    Emitter<HostsState> emit,
  ) async {
    _log.debug('loading known hosts');
    emit(state.copyWith(status: HostsStatus.loading));

    try {
      final hosts = await _repository.listKnownHosts();
      _log.info('known hosts loaded', {'count': hosts.length});
      emit(state.copyWith(
        status: HostsStatus.success,
        knownHosts: hosts,
      ));
    } catch (e, st) {
      _log.error('failed to load known hosts', e, st);
      emit(state.copyWith(
        status: HostsStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onRemoveKnownHost(
    HostsRemoveKnownHostRequested event,
    Emitter<HostsState> emit,
  ) async {
    _log.info('removing known host', {'host': event.host});
    emit(state.copyWith(status: HostsStatus.loading));

    try {
      await _repository.removeKnownHost(event.host);
      _log.info('known host removed', {'host': event.host});
      final hosts = await _repository.listKnownHosts();
      emit(state.copyWith(
        status: HostsStatus.success,
        knownHosts: hosts,
      ));
    } catch (e, st) {
      _log.error('failed to remove known host', e, st, {'host': event.host});
      emit(state.copyWith(
        status: HostsStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onHashKnownHosts(
    HostsHashKnownHostsRequested event,
    Emitter<HostsState> emit,
  ) async {
    _log.info('hashing known hosts');
    emit(state.copyWith(status: HostsStatus.loading));

    try {
      await _repository.hashKnownHosts();
      _log.info('known hosts hashed successfully');
      final hosts = await _repository.listKnownHosts();
      emit(state.copyWith(
        status: HostsStatus.success,
        knownHosts: hosts,
      ));
    } catch (e, st) {
      _log.error('failed to hash known hosts', e, st);
      emit(state.copyWith(
        status: HostsStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onLoadAuthorizedKeys(
    HostsLoadAuthorizedKeysRequested event,
    Emitter<HostsState> emit,
  ) async {
    _log.debug('loading authorized keys');
    emit(state.copyWith(status: HostsStatus.loading));

    try {
      final keys = await _repository.listAuthorizedKeys();
      _log.info('authorized keys loaded', {'count': keys.length});
      emit(state.copyWith(
        status: HostsStatus.success,
        authorizedKeys: keys,
      ));
    } catch (e, st) {
      _log.error('failed to load authorized keys', e, st);
      emit(state.copyWith(
        status: HostsStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onAddAuthorizedKey(
    HostsAddAuthorizedKeyRequested event,
    Emitter<HostsState> emit,
  ) async {
    _log.info('adding authorized key');
    emit(state.copyWith(status: HostsStatus.loading));

    try {
      await _repository.addAuthorizedKey(event.publicKey);
      _log.info('authorized key added');
      final keys = await _repository.listAuthorizedKeys();
      emit(state.copyWith(
        status: HostsStatus.success,
        authorizedKeys: keys,
      ));
    } catch (e, st) {
      _log.error('failed to add authorized key', e, st);
      emit(state.copyWith(
        status: HostsStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onRemoveAuthorizedKey(
    HostsRemoveAuthorizedKeyRequested event,
    Emitter<HostsState> emit,
  ) async {
    _log.info('removing authorized key');
    emit(state.copyWith(status: HostsStatus.loading));

    try {
      await _repository.removeAuthorizedKey(event.publicKey);
      _log.info('authorized key removed');
      final keys = await _repository.listAuthorizedKeys();
      emit(state.copyWith(
        status: HostsStatus.success,
        authorizedKeys: keys,
      ));
    } catch (e, st) {
      _log.error('failed to remove authorized key', e, st);
      emit(state.copyWith(
        status: HostsStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
