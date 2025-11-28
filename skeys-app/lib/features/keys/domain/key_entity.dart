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
enum KeyType { rsa, ed25519, ecdsa, ed25519Sk, ecdsaSk, unknown }

/// Domain entity representing an SSH key.
class KeyEntity extends Equatable {
  final String path;
  final String name;
  final KeyType type;
  final int bits;
  final String fingerprint;
  final String publicKey;
  final String comment;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final bool hasPassphrase;
  final bool isInAgent;

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
