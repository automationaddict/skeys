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

sealed class AgentEvent extends Equatable {
  const AgentEvent();

  @override
  List<Object?> get props => [];
}

final class AgentLoadStatusRequested extends AgentEvent {
  const AgentLoadStatusRequested();
}

final class AgentLoadKeysRequested extends AgentEvent {
  const AgentLoadKeysRequested();
}

/// Subscribe to agent status and key updates via streaming.
final class AgentWatchRequested extends AgentEvent {
  const AgentWatchRequested();
}

final class AgentAddKeyRequested extends AgentEvent {
  final String keyPath;
  final String? passphrase;
  final Duration? lifetime;
  final bool confirm;

  const AgentAddKeyRequested({
    required this.keyPath,
    this.passphrase,
    this.lifetime,
    this.confirm = false,
  });

  @override
  List<Object?> get props => [keyPath, passphrase, lifetime, confirm];
}

final class AgentRemoveKeyRequested extends AgentEvent {
  final String fingerprint;

  const AgentRemoveKeyRequested(this.fingerprint);

  @override
  List<Object?> get props => [fingerprint];
}

final class AgentRemoveAllKeysRequested extends AgentEvent {
  const AgentRemoveAllKeysRequested();
}

final class AgentLockRequested extends AgentEvent {
  final String passphrase;

  const AgentLockRequested(this.passphrase);

  @override
  List<Object?> get props => [passphrase];
}

final class AgentUnlockRequested extends AgentEvent {
  final String passphrase;

  const AgentUnlockRequested(this.passphrase);

  @override
  List<Object?> get props => [passphrase];
}
