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

/// SSH Key types.
enum KeyType {
  /// RSA algorithm.
  rsa,

  /// ED25519 algorithm (modern, recommended).
  ed25519,

  /// ECDSA algorithm.
  ecdsa,

  /// ED25519 with hardware security key.
  ed25519Sk,

  /// ECDSA with hardware security key.
  ecdsaSk,

  /// Unknown key type.
  unknown,
}

/// Domain entity representing an SSH key.
class KeyEntity extends Equatable {
  /// The file path to the private key.
  final String path;

  /// The key name (usually filename without path).
  final String name;

  /// The key type (RSA, ED25519, etc.).
  final KeyType type;

  /// The key size in bits.
  final int bits;

  /// The SHA256 fingerprint of the key.
  final String fingerprint;

  /// The public key content.
  final String publicKey;

  /// Comment associated with the key.
  final String comment;

  /// When the key was created.
  final DateTime createdAt;

  /// When the key was last modified.
  final DateTime modifiedAt;

  /// Whether the key is protected by a passphrase.
  final bool hasPassphrase;

  /// Whether the key is currently loaded in the SSH agent.
  final bool isInAgent;

  /// Creates a KeyEntity with the given parameters.
  const KeyEntity({
    required this.path,
    required this.name,
    required this.type,
    required this.bits,
    required this.fingerprint,
    required this.publicKey,
    required this.comment,
    required this.createdAt,
    required this.modifiedAt,
    required this.hasPassphrase,
    required this.isInAgent,
  });

  @override
  List<Object?> get props => [
    path,
    name,
    type,
    bits,
    fingerprint,
    publicKey,
    comment,
    createdAt,
    modifiedAt,
    hasPassphrase,
    isInAgent,
  ];

  /// Creates a copy of this entity with the given fields replaced.
  KeyEntity copyWith({
    String? path,
    String? name,
    KeyType? type,
    int? bits,
    String? fingerprint,
    String? publicKey,
    String? comment,
    DateTime? createdAt,
    DateTime? modifiedAt,
    bool? hasPassphrase,
    bool? isInAgent,
  }) {
    return KeyEntity(
      path: path ?? this.path,
      name: name ?? this.name,
      type: type ?? this.type,
      bits: bits ?? this.bits,
      fingerprint: fingerprint ?? this.fingerprint,
      publicKey: publicKey ?? this.publicKey,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      hasPassphrase: hasPassphrase ?? this.hasPassphrase,
      isInAgent: isInAgent ?? this.isInAgent,
    );
  }
}
