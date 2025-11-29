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
enum KeysStatus {
  /// Initial state before any operation.
  initial,

  /// A load or operation is in progress.
  loading,

  /// The operation completed successfully.
  success,

  /// The operation failed with an error.
  failure,

  /// A connection test is in progress.
  testingConnection,
}

/// Status of the add-to-agent workflow.
enum AddToAgentStatus {
  /// No add-to-agent operation in progress.
  idle,

  /// Verifying SSH connection before adding to agent.
  verifyingConnection,

  /// Adding the key to the SSH agent.
  addingToAgent,

  /// Key was successfully added to the agent.
  success,

  /// SSH connection verification failed.
  connectionFailed,

  /// Host key is unknown and requires user approval.
  hostKeyUnknown,

  /// Host key mismatch detected (potential MITM attack).
  hostKeyMismatch,

  /// Failed to add key to the agent.
  agentFailed,
}

/// Result of the add-to-agent workflow.
class AddToAgentResult extends Equatable {
  /// The status of the workflow.
  final AddToAgentStatus status;

  /// Error message if the workflow failed.
  final String? errorMessage;

  /// Host key information if host key approval is needed.
  final HostKeyInfo? hostKeyInfo;

  /// The host that was verified (for success messages).
  final String? verifiedHost;

  /// Creates an AddToAgentResult with the given parameters.
  const AddToAgentResult({
    required this.status,
    this.errorMessage,
    this.hostKeyInfo,
    this.verifiedHost,
  });

  @override
  List<Object?> get props => [status, errorMessage, hostKeyInfo, verifiedHost];
}

/// Result of a connection test for display purposes.
class ConnectionTestResult {
  /// Whether the connection succeeded.
  final bool success;

  /// Status message describing the result.
  final String message;

  /// The SSH server version string if available.
  final String? serverVersion;

  /// Connection latency in milliseconds.
  final int? latencyMs;

  /// The host that was tested.
  final String host;

  /// The status of host key verification.
  final HostKeyVerificationStatus hostKeyStatus;

  /// Information about the host key if available.
  final HostKeyInfo? hostKeyInfo;

  /// Creates a ConnectionTestResult with the given parameters.
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
  /// The current status of BLoC operations.
  final KeysStatus status;

  /// List of SSH key entities.
  final List<KeyEntity> keys;

  /// Error message if the last operation failed.
  final String? errorMessage;

  /// Public key content that was copied to clipboard.
  final String? copiedPublicKey;

  /// Result of the last connection test.
  final ConnectionTestResult? testConnectionResult;

  /// Status of the add-to-agent workflow.
  final AddToAgentStatus addToAgentStatus;

  /// Result of the add-to-agent workflow.
  final AddToAgentResult? addToAgentResult;

  /// Creates a KeysState with the given parameters.
  const KeysState({
    this.status = KeysStatus.initial,
    this.keys = const [],
    this.errorMessage,
    this.copiedPublicKey,
    this.testConnectionResult,
    this.addToAgentStatus = AddToAgentStatus.idle,
    this.addToAgentResult,
  });

  /// Creates a copy of this state with the given fields replaced.
  KeysState copyWith({
    KeysStatus? status,
    List<KeyEntity>? keys,
    String? errorMessage,
    String? copiedPublicKey,
    ConnectionTestResult? testConnectionResult,
    bool clearTestResult = false,
    AddToAgentStatus? addToAgentStatus,
    AddToAgentResult? addToAgentResult,
    bool clearAddToAgentResult = false,
  }) {
    return KeysState(
      status: status ?? this.status,
      keys: keys ?? this.keys,
      errorMessage: errorMessage,
      copiedPublicKey: copiedPublicKey,
      testConnectionResult: clearTestResult
          ? null
          : (testConnectionResult ?? this.testConnectionResult),
      addToAgentStatus: addToAgentStatus ?? this.addToAgentStatus,
      addToAgentResult: clearAddToAgentResult
          ? null
          : (addToAgentResult ?? this.addToAgentResult),
    );
  }

  @override
  List<Object?> get props => [
    status,
    keys,
    errorMessage,
    copiedPublicKey,
    testConnectionResult,
    addToAgentStatus,
    addToAgentResult,
  ];
}
