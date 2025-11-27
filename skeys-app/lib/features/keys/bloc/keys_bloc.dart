import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/logging/app_logger.dart';
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
  final AppLogger _log = AppLogger('bloc.keys');

  KeysBloc(this._repository, this._remoteRepository) : super(const KeysState()) {
    on<KeysLoadRequested>(_onLoadRequested);
    on<KeysGenerateRequested>(_onGenerateRequested);
    on<KeysDeleteRequested>(_onDeleteRequested);
    on<KeysChangePassphraseRequested>(_onChangePassphraseRequested);
    on<KeysCopyPublicKeyRequested>(_onCopyPublicKeyRequested);
    on<KeysTestConnectionRequested>(_onTestConnectionRequested);
    on<KeysTestConnectionCleared>(_onTestConnectionCleared);
    _log.debug('KeysBloc initialized');
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
      emit(state.copyWith(
        status: KeysStatus.success,
        keys: keys,
      ));
    } catch (e, st) {
      _log.error('failed to load keys', e, st);
      emit(state.copyWith(
        status: KeysStatus.failure,
        errorMessage: e.toString(),
      ));
    }
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
      emit(state.copyWith(
        status: KeysStatus.success,
        keys: keys,
      ));
    } catch (e, st) {
      _log.error('failed to generate key', e, st, {'name': event.name});
      emit(state.copyWith(
        status: KeysStatus.failure,
        errorMessage: e.toString(),
      ));
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
      emit(state.copyWith(
        status: KeysStatus.success,
        keys: keys,
      ));
    } catch (e, st) {
      _log.error('failed to delete key', e, st, {'path': event.path});
      emit(state.copyWith(
        status: KeysStatus.failure,
        errorMessage: e.toString(),
      ));
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
      emit(state.copyWith(
        status: KeysStatus.failure,
        errorMessage: e.toString(),
      ));
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
      emit(state.copyWith(
        status: KeysStatus.success,
        copiedPublicKey: key.publicKey,
      ));
    } catch (e, st) {
      _log.error('failed to get public key', e, st, {'path': event.path});
      emit(state.copyWith(
        status: KeysStatus.failure,
        errorMessage: e.toString(),
      ));
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
    emit(state.copyWith(status: KeysStatus.testingConnection, clearTestResult: true));

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
      emit(state.copyWith(
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
      ));
    } catch (e, st) {
      _log.error('connection test failed', e, st, {'host': event.host});
      emit(state.copyWith(
        status: KeysStatus.success,
        testConnectionResult: ConnectionTestResult(
          success: false,
          message: e.toString(),
          host: event.host,
        ),
      ));
    }
  }

  void _onTestConnectionCleared(
    KeysTestConnectionCleared event,
    Emitter<KeysState> emit,
  ) {
    emit(state.copyWith(clearTestResult: true));
  }
}
