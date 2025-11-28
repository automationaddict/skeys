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

import 'package:equatable/equatable.dart';

/// Known host entry from ~/.ssh/known_hosts.
class KnownHostEntry extends Equatable {
  /// The hostname or hashed hostname.
  final String host;

  /// The key type (e.g., "ssh-ed25519", "ssh-rsa").
  final String keyType;

  /// The public key data.
  final String publicKey;

  /// Whether the hostname is hashed for privacy.
  final bool isHashed;

  /// Creates a KnownHostEntry with the given parameters.
  const KnownHostEntry({
    required this.host,
    required this.keyType,
    required this.publicKey,
    required this.isHashed,
  });

  @override
  List<Object?> get props => [host, keyType, publicKey, isHashed];
}

/// Scanned host key entry (from ssh-keyscan operation).
class ScannedHostKey extends Equatable {
  /// The hostname that was scanned.
  final String hostname;

  /// The SSH port that was scanned.
  final int port;

  /// The key type (e.g., "ssh-ed25519", "ssh-rsa").
  final String keyType;

  /// The public key data.
  final String publicKey;

  /// The key fingerprint (SHA256 hash).
  final String fingerprint;

  /// Creates a ScannedHostKey with the given parameters.
  const ScannedHostKey({
    required this.hostname,
    required this.port,
    required this.keyType,
    required this.publicKey,
    required this.fingerprint,
  });

  @override
  List<Object?> get props => [hostname, port, keyType, publicKey, fingerprint];
}

/// Authorized key entry from ~/.ssh/authorized_keys.
class AuthorizedKeyEntry extends Equatable {
  /// The key type (e.g., "ssh-ed25519", "ssh-rsa").
  final String keyType;

  /// The public key data.
  final String publicKey;

  /// Comment associated with the key (usually user@host).
  final String comment;

  /// Any options preceding the key (e.g., "command=...", "no-port-forwarding").
  final List<String> options;

  /// Creates an AuthorizedKeyEntry with the given parameters.
  const AuthorizedKeyEntry({
    required this.keyType,
    required this.publicKey,
    required this.comment,
    this.options = const [],
  });

  @override
  List<Object?> get props => [keyType, publicKey, comment, options];
}
