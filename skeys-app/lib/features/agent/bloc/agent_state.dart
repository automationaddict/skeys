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

part of 'agent_bloc.dart';

enum AgentBlocStatus { initial, loading, success, failure }

final class AgentState extends Equatable {
  final AgentBlocStatus status;
  final AgentStatus? agentStatus;
  final List<AgentKeyEntry> loadedKeys;
  final String? errorMessage;

  const AgentState({
    this.status = AgentBlocStatus.initial,
    this.agentStatus,
    this.loadedKeys = const [],
    this.errorMessage,
  });

  AgentState copyWith({
    AgentBlocStatus? status,
    AgentStatus? agentStatus,
    List<AgentKeyEntry>? loadedKeys,
    String? errorMessage,
  }) {
    return AgentState(
      status: status ?? this.status,
      agentStatus: agentStatus ?? this.agentStatus,
      loadedKeys: loadedKeys ?? this.loadedKeys,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, agentStatus, loadedKeys, errorMessage];
}
