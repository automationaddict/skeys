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

part of 'server_config_bloc.dart';

/// Status of the ServerConfigBloc operations.
enum ServerConfigStatus {
  /// Initial state before any operation.
  initial,

  /// An operation is in progress.
  loading,

  /// The operation completed successfully.
  success,

  /// The operation failed with an error.
  failure,
}

/// State of the SSH server configuration BLoC.
final class ServerConfigState extends Equatable {
  /// The current status of BLoC operations.
  final ServerConfigStatus status;

  /// Server configuration (sshd_config).
  final ServerConfig? config;

  /// Whether the server config has pending changes requiring SSH service restart.
  final bool pendingRestart;

  /// Error message if the last operation failed.
  final String? errorMessage;

  /// Creates a ServerConfigState.
  const ServerConfigState({
    this.status = ServerConfigStatus.initial,
    this.config,
    this.pendingRestart = false,
    this.errorMessage,
  });

  /// Creates a copy of this state with the given fields replaced.
  ServerConfigState copyWith({
    ServerConfigStatus? status,
    ServerConfig? config,
    bool? pendingRestart,
    String? errorMessage,
  }) {
    return ServerConfigState(
      status: status ?? this.status,
      config: config ?? this.config,
      pendingRestart: pendingRestart ?? this.pendingRestart,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, config, pendingRestart, errorMessage];
}
