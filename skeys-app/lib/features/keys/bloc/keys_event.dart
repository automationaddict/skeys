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

part of 'keys_bloc.dart';

/// Base class for all keys events.
sealed class KeysEvent extends Equatable {
  /// Creates a KeysEvent.
  const KeysEvent();

  @override
  List<Object?> get props => [];
}

/// Load all SSH keys.
final class KeysLoadRequested extends KeysEvent {
  /// Creates a KeysLoadRequested event.
  const KeysLoadRequested();
}

/// Subscribe to key list updates via streaming.
final class KeysWatchRequested extends KeysEvent {
  /// Creates a KeysWatchRequested event.
  const KeysWatchRequested();
}

/// Generate a new SSH key.
final class KeysGenerateRequested extends KeysEvent {
  /// The name for the new key file.
  final String name;

  /// The key type (RSA, ED25519, etc.).
  final KeyType type;

  /// The key size in bits (for RSA/ECDSA).
  final int? bits;

  /// Optional comment for the key.
  final String? comment;

  /// Optional passphrase to protect the key.
  final String? passphrase;

  /// Whether to add the key to the SSH agent after generation.
  final bool addToAgent;

  /// Creates a KeysGenerateRequested event.
  const KeysGenerateRequested({
    required this.name,
    required this.type,
    this.bits,
    this.comment,
    this.passphrase,
    this.addToAgent = false,
  });

  @override
  List<Object?> get props => [
    name,
    type,
    bits,
    comment,
    passphrase,
    addToAgent,
  ];
}

/// Delete an SSH key.
final class KeysDeleteRequested extends KeysEvent {
  /// The path to the key file to delete.
  final String path;

  /// Creates a KeysDeleteRequested event.
  const KeysDeleteRequested(this.path);

  @override
  List<Object?> get props => [path];
}

/// Change passphrase for an SSH key.
final class KeysChangePassphraseRequested extends KeysEvent {
  /// The path to the key file.
  final String path;

  /// The current passphrase.
  final String oldPassphrase;

  /// The new passphrase to set.
  final String newPassphrase;

  /// Creates a KeysChangePassphraseRequested event.
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
  /// The path to the key file.
  final String path;

  /// Creates a KeysCopyPublicKeyRequested event.
  const KeysCopyPublicKeyRequested(this.path);

  @override
  List<Object?> get props => [path];
}

/// Test SSH connection with a key.
final class KeysTestConnectionRequested extends KeysEvent {
  /// The path to the key file.
  final String keyPath;

  /// The hostname to connect to.
  final String host;

  /// The SSH port number.
  final int port;

  /// The username for authentication.
  final String user;

  /// Optional passphrase if key is encrypted.
  final String? passphrase;

  /// Whether to trust an unknown host key.
  final bool trustHostKey;

  /// Creates a KeysTestConnectionRequested event.
  const KeysTestConnectionRequested({
    required this.keyPath,
    required this.host,
    required this.port,
    required this.user,
    this.passphrase,
    this.trustHostKey = false,
  });

  @override
  List<Object?> get props => [
    keyPath,
    host,
    port,
    user,
    passphrase,
    trustHostKey,
  ];
}

/// Clear the test connection result.
final class KeysTestConnectionCleared extends KeysEvent {
  /// Creates a KeysTestConnectionCleared event.
  const KeysTestConnectionCleared();
}

/// Event to add a key to the SSH agent with optional connection verification.
///
/// This event handles the complete workflow of:
/// 1. Optionally verifying SSH connection to a host
/// 2. Adding the key to the SSH agent
///
/// If host/port/user are provided, connection is verified first.
/// If not provided, the key is added directly to the agent.
final class KeysAddToAgentRequested extends KeysEvent {
  /// The path to the key file.
  final String keyPath;

  /// Optional passphrase if the key is encrypted.
  final String? passphrase;

  /// The hostname to verify connection with (optional).
  final String? host;

  /// The SSH port number (optional, defaults to 22 if host is provided).
  final int? port;

  /// The username for authentication (optional).
  final String? user;

  /// Whether to trust an unknown host key during verification.
  final bool trustHostKey;

  /// Creates a KeysAddToAgentRequested event.
  const KeysAddToAgentRequested({
    required this.keyPath,
    this.passphrase,
    this.host,
    this.port,
    this.user,
    this.trustHostKey = false,
  });

  @override
  List<Object?> get props => [
    keyPath,
    passphrase,
    host,
    port,
    user,
    trustHostKey,
  ];
}

/// Clear the add to agent result and reset status.
final class KeysAddToAgentCleared extends KeysEvent {
  /// Creates a KeysAddToAgentCleared event.
  const KeysAddToAgentCleared();
}
