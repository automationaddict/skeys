part of 'keys_bloc.dart';

/// Base class for all keys events.
sealed class KeysEvent extends Equatable {
  const KeysEvent();

  @override
  List<Object?> get props => [];
}

/// Load all SSH keys.
final class KeysLoadRequested extends KeysEvent {
  const KeysLoadRequested();
}

/// Generate a new SSH key.
final class KeysGenerateRequested extends KeysEvent {
  final String name;
  final KeyType type;
  final int? bits;
  final String? comment;
  final String? passphrase;
  final bool addToAgent;

  const KeysGenerateRequested({
    required this.name,
    required this.type,
    this.bits,
    this.comment,
    this.passphrase,
    this.addToAgent = false,
  });

  @override
  List<Object?> get props => [name, type, bits, comment, passphrase, addToAgent];
}

/// Delete an SSH key.
final class KeysDeleteRequested extends KeysEvent {
  final String path;

  const KeysDeleteRequested(this.path);

  @override
  List<Object?> get props => [path];
}

/// Change passphrase for an SSH key.
final class KeysChangePassphraseRequested extends KeysEvent {
  final String path;
  final String oldPassphrase;
  final String newPassphrase;

  const KeysChangePassphraseRequested({
    required this.path,
    required this.oldPassphrase,
    required this.newPassphrase,
  });

  @override
  List<Object?> get props => [path, oldPassphrase, newPassphrase];
}

/// Copy public key to clipboard.
final class KeysCopyPublicKeyRequested extends KeysEvent {
  final String path;

  const KeysCopyPublicKeyRequested(this.path);

  @override
  List<Object?> get props => [path];
}

/// Test SSH connection with a key.
final class KeysTestConnectionRequested extends KeysEvent {
  final String keyPath;
  final String host;
  final int port;
  final String user;
  final String? passphrase;
  final bool trustHostKey;

  const KeysTestConnectionRequested({
    required this.keyPath,
    required this.host,
    required this.port,
    required this.user,
    this.passphrase,
    this.trustHostKey = false,
  });

  @override
  List<Object?> get props => [keyPath, host, port, user, passphrase, trustHostKey];
}

/// Clear the test connection result.
final class KeysTestConnectionCleared extends KeysEvent {
  const KeysTestConnectionCleared();
}
