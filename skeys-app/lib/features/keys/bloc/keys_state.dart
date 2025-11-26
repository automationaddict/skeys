part of 'keys_bloc.dart';

/// Status of keys operations.
enum KeysStatus {
  initial,
  loading,
  success,
  failure,
}

/// State for the keys feature.
final class KeysState extends Equatable {
  final KeysStatus status;
  final List<KeyEntity> keys;
  final String? errorMessage;
  final String? copiedPublicKey;

  const KeysState({
    this.status = KeysStatus.initial,
    this.keys = const [],
    this.errorMessage,
    this.copiedPublicKey,
  });

  KeysState copyWith({
    KeysStatus? status,
    List<KeyEntity>? keys,
    String? errorMessage,
    String? copiedPublicKey,
  }) {
    return KeysState(
      status: status ?? this.status,
      keys: keys ?? this.keys,
      errorMessage: errorMessage,
      copiedPublicKey: copiedPublicKey,
    );
  }

  @override
  List<Object?> get props => [status, keys, errorMessage, copiedPublicKey];
}
