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

/// Status of keys operations.
enum KeysStatus { initial, loading, success, failure, testingConnection }

/// Result of a connection test for display purposes.
class ConnectionTestResult {
  final bool success;
  final String message;
  final String? serverVersion;
  final int? latencyMs;
  final String host;
  final HostKeyVerificationStatus hostKeyStatus;
  final HostKeyInfo? hostKeyInfo;

  const ConnectionTestResult({
    required this.success,
    required this.message,
    this.serverVersion,
    this.latencyMs,
    required this.host,
    this.hostKeyStatus = HostKeyVerificationStatus.unspecified,
    this.hostKeyInfo,
  });

  /// Whether the host key needs user approval (unknown host).
  bool get needsHostKeyApproval =>
      hostKeyStatus == HostKeyVerificationStatus.unknown;

  /// Whether there is a host key mismatch (potential security issue).
  bool get hasHostKeyMismatch =>
      hostKeyStatus == HostKeyVerificationStatus.mismatch;
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
      testConnectionResult: clearTestResult
          ? null
          : (testConnectionResult ?? this.testConnectionResult),
    );
  }

  @override
  List<Object?> get props => [
    status,
    keys,
    errorMessage,
    copiedPublicKey,
    testConnectionResult,
  ];
}
