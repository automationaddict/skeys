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

part of 'hosts_bloc.dart';

/// Base class for all host-related events.
sealed class HostsEvent extends Equatable {
  /// Creates a HostsEvent.
  const HostsEvent();

  @override
  List<Object?> get props => [];
}

/// Event to request loading known hosts.
final class HostsLoadKnownHostsRequested extends HostsEvent {
  /// Creates a HostsLoadKnownHostsRequested event.
  const HostsLoadKnownHostsRequested();
}

/// Event to start watching known hosts for changes.
final class HostsWatchKnownHostsRequested extends HostsEvent {
  /// Creates a HostsWatchKnownHostsRequested event.
  const HostsWatchKnownHostsRequested();
}

/// Event to request removing a known host.
final class HostsRemoveKnownHostRequested extends HostsEvent {
  /// The hostname to remove.
  final String host;

  /// Creates a HostsRemoveKnownHostRequested event.
  const HostsRemoveKnownHostRequested(this.host);

  @override
  List<Object?> get props => [host];
}

/// Event to request hashing all hostnames in known_hosts.
final class HostsHashKnownHostsRequested extends HostsEvent {
  /// Creates a HostsHashKnownHostsRequested event.
  const HostsHashKnownHostsRequested();
}

/// Event to request loading authorized keys.
final class HostsLoadAuthorizedKeysRequested extends HostsEvent {
  /// Creates a HostsLoadAuthorizedKeysRequested event.
  const HostsLoadAuthorizedKeysRequested();
}

/// Event to start watching authorized keys for changes.
final class HostsWatchAuthorizedKeysRequested extends HostsEvent {
  /// Creates a HostsWatchAuthorizedKeysRequested event.
  const HostsWatchAuthorizedKeysRequested();
}

/// Event to request adding an authorized key.
final class HostsAddAuthorizedKeyRequested extends HostsEvent {
  /// The public key to authorize.
  final String publicKey;

  /// Creates a HostsAddAuthorizedKeyRequested event.
  const HostsAddAuthorizedKeyRequested(this.publicKey);

  @override
  List<Object?> get props => [publicKey];
}

/// Event to request removing an authorized key.
final class HostsRemoveAuthorizedKeyRequested extends HostsEvent {
  /// The public key to remove from authorized keys.
  final String publicKey;

  /// Creates a HostsRemoveAuthorizedKeyRequested event.
  const HostsRemoveAuthorizedKeyRequested(this.publicKey);

  @override
  List<Object?> get props => [publicKey];
}

/// Event to request scanning a host for its public keys.
final class HostsScanHostKeysRequested extends HostsEvent {
  /// The hostname to scan.
  final String hostname;

  /// The SSH port to scan.
  final int port;

  /// Timeout in seconds for the scan operation.
  final int timeout;

  /// Creates a HostsScanHostKeysRequested event.
  const HostsScanHostKeysRequested(
    this.hostname, {
    this.port = 22,
    this.timeout = 10,
  });

  @override
  List<Object?> get props => [hostname, port, timeout];
}

/// Event to request adding a known host entry.
final class HostsAddKnownHostRequested extends HostsEvent {
  /// The hostname to add.
  final String hostname;

  /// The key type (e.g., "ssh-ed25519").
  final String keyType;

  /// The public key data.
  final String publicKey;

  /// The SSH port for this host.
  final int port;

  /// Whether to hash the hostname in the known_hosts file.
  final bool hashHostname;

  /// Creates a HostsAddKnownHostRequested event.
  const HostsAddKnownHostRequested({
    required this.hostname,
    required this.keyType,
    required this.publicKey,
    this.port = 22,
    this.hashHostname = false,
  });

  @override
  List<Object?> get props => [hostname, keyType, publicKey, port, hashHostname];
}

/// Event to clear scanned host keys from the UI state.
final class HostsClearScannedKeysRequested extends HostsEvent {
  /// Creates a HostsClearScannedKeysRequested event.
  const HostsClearScannedKeysRequested();
}
