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
    on<HostsWatchKnownHostsRequested>(_onWatchKnownHosts);
    on<HostsRemoveKnownHostRequested>(_onRemoveKnownHost);
    on<HostsHashKnownHostsRequested>(_onHashKnownHosts);
    on<HostsLoadAuthorizedKeysRequested>(_onLoadAuthorizedKeys);
    on<HostsWatchAuthorizedKeysRequested>(_onWatchAuthorizedKeys);
    on<HostsAddAuthorizedKeyRequested>(_onAddAuthorizedKey);
    on<HostsRemoveAuthorizedKeyRequested>(_onRemoveAuthorizedKey);
    on<HostsScanHostKeysRequested>(_onScanHostKeys);
    on<HostsAddKnownHostRequested>(_onAddKnownHost);
    on<HostsClearScannedKeysRequested>(_onClearScannedKeys);
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

  Future<void> _onWatchKnownHosts(
    HostsWatchKnownHostsRequested event,
    Emitter<HostsState> emit,
  ) async {
    _log.debug('subscribing to known hosts stream');
    emit(state.copyWith(status: HostsStatus.loading));

    await emit.forEach<List<KnownHostEntry>>(
      _repository.watchKnownHosts(),
      onData: (hosts) {
        _log.debug('known hosts stream update', {'count': hosts.length});
        return state.copyWith(
          status: HostsStatus.success,
          knownHosts: hosts,
        );
      },
      onError: (error, stackTrace) {
        _log.error('known hosts stream error', error, stackTrace);
        return state.copyWith(
          status: HostsStatus.failure,
          errorMessage: error.toString(),
        );
      },
    );
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

  Future<void> _onWatchAuthorizedKeys(
    HostsWatchAuthorizedKeysRequested event,
    Emitter<HostsState> emit,
  ) async {
    _log.debug('subscribing to authorized keys stream');
    emit(state.copyWith(status: HostsStatus.loading));

    await emit.forEach<List<AuthorizedKeyEntry>>(
      _repository.watchAuthorizedKeys(),
      onData: (keys) {
        _log.debug('authorized keys stream update', {'count': keys.length});
        return state.copyWith(
          status: HostsStatus.success,
          authorizedKeys: keys,
        );
      },
      onError: (error, stackTrace) {
        _log.error('authorized keys stream error', error, stackTrace);
        return state.copyWith(
          status: HostsStatus.failure,
          errorMessage: error.toString(),
        );
      },
    );
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

  Future<void> _onScanHostKeys(
    HostsScanHostKeysRequested event,
    Emitter<HostsState> emit,
  ) async {
    _log.info('scanning host keys', {'hostname': event.hostname, 'port': event.port});
    emit(state.copyWith(status: HostsStatus.scanning, scannedKeys: []));

    try {
      final keys = await _repository.scanHostKeys(
        event.hostname,
        port: event.port,
        timeout: event.timeout,
      );
      _log.info('host keys scanned', {'hostname': event.hostname, 'count': keys.length});
      emit(state.copyWith(
        status: HostsStatus.success,
        scannedKeys: keys,
      ));
    } catch (e, st) {
      _log.error('failed to scan host keys', e, st, {'hostname': event.hostname});
      emit(state.copyWith(
        status: HostsStatus.failure,
        scannedKeys: [],
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onAddKnownHost(
    HostsAddKnownHostRequested event,
    Emitter<HostsState> emit,
  ) async {
    _log.info('adding known host', {'hostname': event.hostname, 'keyType': event.keyType});
    emit(state.copyWith(status: HostsStatus.loading));

    try {
      await _repository.addKnownHost(
        event.hostname,
        event.keyType,
        event.publicKey,
        port: event.port,
        hashHostname: event.hashHostname,
      );
      _log.info('known host added', {'hostname': event.hostname});
      final hosts = await _repository.listKnownHosts();
      emit(state.copyWith(
        status: HostsStatus.success,
        knownHosts: hosts,
        scannedKeys: [],
      ));
    } catch (e, st) {
      _log.error('failed to add known host', e, st, {'hostname': event.hostname});
      emit(state.copyWith(
        status: HostsStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onClearScannedKeys(
    HostsClearScannedKeysRequested event,
    Emitter<HostsState> emit,
  ) async {
    emit(state.copyWith(scannedKeys: []));
  }
}
