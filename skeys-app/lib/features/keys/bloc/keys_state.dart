part of 'keys_bloc.dart';

/// Status of keys operations.
enum KeysStatus {
  initial,
  loading,
  success,
  failure,
  testingConnection,
}

/// Result of a connection test for display purposes.
class ConnectionTestResult {
  final bool success;
  final String message;
  final String? serverVersion;
  final int? latencyMs;
  final String host;

  const ConnectionTestResult({
    required this.success,
    required this.message,
    this.serverVersion,
    this.latencyMs,
    required this.host,
  });
}

/// State for the keys feature.
final class KeysState extends Equatable {
  final KeysStatus status;
  final List<KeyEntity> keys;
  final String? errorMessage;
  final String? copiedPublicKey;
  final ConnectionTestResult? testConnectionResult;

  const KeysState({
    this.status = KeysStatus.initial,
    this.keys = const [],
    this.errorMessage,
    this.copiedPublicKey,
    this.testConnectionResult,
  });

  KeysState copyWith({
    KeysStatus? status,
    List<KeyEntity>? keys,
    String? errorMessage,
    String? copiedPublicKey,
    ConnectionTestResult? testConnectionResult,
    bool clearTestResult = false,
  }) {
    return KeysState(
      status: status ?? this.status,
      keys: keys ?? this.keys,
      errorMessage: errorMessage,
      copiedPublicKey: copiedPublicKey,
      testConnectionResult: clearTestResult ? null : (testConnectionResult ?? this.testConnectionResult),
    );
  }

  @override
  List<Object?> get props => [status, keys, errorMessage, copiedPublicKey, testConnectionResult];
}
