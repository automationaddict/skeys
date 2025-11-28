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

part of 'remote_bloc.dart';

enum RemoteBlocStatus { initial, loading, success, failure }

final class RemoteState extends Equatable {
  final RemoteBlocStatus status;
  final List<RemoteEntity> remotes;
  final List<ConnectionEntity> connections;
  final CommandResult? lastCommandResult;
  final String? errorMessage;

  const RemoteState({
    this.status = RemoteBlocStatus.initial,
    this.remotes = const [],
    this.connections = const [],
    this.lastCommandResult,
    this.errorMessage,
  });

  RemoteState copyWith({
    RemoteBlocStatus? status,
    List<RemoteEntity>? remotes,
    List<ConnectionEntity>? connections,
    CommandResult? lastCommandResult,
    String? errorMessage,
  }) {
    return RemoteState(
      status: status ?? this.status,
      remotes: remotes ?? this.remotes,
      connections: connections ?? this.connections,
      lastCommandResult: lastCommandResult ?? this.lastCommandResult,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    remotes,
    connections,
    lastCommandResult,
    errorMessage,
  ];
}
