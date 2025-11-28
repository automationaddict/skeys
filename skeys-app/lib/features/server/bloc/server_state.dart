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

part of 'server_bloc.dart';

/// Status of server operations.
enum ServerStatus { initial, loading, success, failure }

/// Result of a service control action.
class ActionResult {
  final bool success;
  final String message;

  const ActionResult({required this.success, required this.message});
}

/// State for the server feature.
final class ServerState extends Equatable {
  final ServerStatus status;
  final SSHSystemStatus? sshStatus;
  final String? errorMessage;
  final bool actionInProgress;
  final ActionResult? actionResult;

  const ServerState({
    this.status = ServerStatus.initial,
    this.sshStatus,
    this.errorMessage,
    this.actionInProgress = false,
    this.actionResult,
  });

  ServerState copyWith({
    ServerStatus? status,
    SSHSystemStatus? sshStatus,
    String? errorMessage,
    bool? actionInProgress,
    ActionResult? actionResult,
    bool clearActionResult = false,
  }) {
    return ServerState(
      status: status ?? this.status,
      sshStatus: sshStatus ?? this.sshStatus,
      errorMessage: errorMessage,
      actionInProgress: actionInProgress ?? this.actionInProgress,
      actionResult: clearActionResult
          ? null
          : (actionResult ?? this.actionResult),
    );
  }

  @override
  List<Object?> get props => [
    status,
    sshStatus,
    errorMessage,
    actionInProgress,
    actionResult,
  ];
}
