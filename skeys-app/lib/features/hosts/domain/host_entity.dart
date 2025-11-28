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

/// Known host entry.
class KnownHostEntry extends Equatable {
  final String host;
  final String keyType;
  final String publicKey;
  final bool isHashed;

  const KnownHostEntry({
    required this.host,
    required this.keyType,
    required this.publicKey,
    required this.isHashed,
  });

  @override
  List<Object?> get props => [host, keyType, publicKey, isHashed];
}

/// Scanned host key entry (from ssh-keyscan).
class ScannedHostKey extends Equatable {
  final String hostname;
  final int port;
  final String keyType;
  final String publicKey;
  final String fingerprint;

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

/// Authorized key entry.
class AuthorizedKeyEntry extends Equatable {
  final String keyType;
  final String publicKey;
  final String comment;
  final List<String> options;

  const AuthorizedKeyEntry({
    required this.keyType,
    required this.publicKey,
    required this.comment,
    this.options = const [],
  });

  @override
  List<Object?> get props => [keyType, publicKey, comment, options];
}
