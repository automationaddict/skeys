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

/// Base class for all SSH agent-related events.
sealed class AgentEvent extends Equatable {
  /// Creates an AgentEvent.
  const AgentEvent();

  @override
  List<Object?> get props => [];
}

/// Event to request loading the agent status.
final class AgentLoadStatusRequested extends AgentEvent {
  /// Creates an AgentLoadStatusRequested event.
  const AgentLoadStatusRequested();
}

/// Event to request loading the list of keys in the agent.
final class AgentLoadKeysRequested extends AgentEvent {
  /// Creates an AgentLoadKeysRequested event.
  const AgentLoadKeysRequested();
}

/// Event to subscribe to agent status and key updates via streaming.
final class AgentWatchRequested extends AgentEvent {
  /// Creates an AgentWatchRequested event.
  const AgentWatchRequested();
}

/// Event to request adding a key to the agent.
final class AgentAddKeyRequested extends AgentEvent {
  /// The path to the key file to add.
  final String keyPath;

  /// Optional passphrase for encrypted keys.
  final String? passphrase;

  /// Optional lifetime after which the key is removed from the agent.
  final Duration? lifetime;

  /// Whether to require confirmation before using this key.
  final bool confirm;

  /// Creates an AgentAddKeyRequested event.
  const AgentAddKeyRequested({
    required this.keyPath,
    this.passphrase,
    this.lifetime,
    this.confirm = false,
  });

  @override
  List<Object?> get props => [keyPath, passphrase, lifetime, confirm];
}

/// Event to request removing a specific key from the agent.
final class AgentRemoveKeyRequested extends AgentEvent {
  /// The fingerprint of the key to remove.
  final String fingerprint;

  /// Creates an AgentRemoveKeyRequested event.
  const AgentRemoveKeyRequested(this.fingerprint);

  @override
  List<Object?> get props => [fingerprint];
}

/// Event to request removing all keys from the agent.
final class AgentRemoveAllKeysRequested extends AgentEvent {
  /// Creates an AgentRemoveAllKeysRequested event.
  const AgentRemoveAllKeysRequested();
}

/// Event to request locking the agent with a passphrase.
final class AgentLockRequested extends AgentEvent {
  /// The passphrase to use for locking the agent.
  final String passphrase;

  /// Creates an AgentLockRequested event.
  const AgentLockRequested(this.passphrase);

  @override
  List<Object?> get props => [passphrase];
}

/// Event to request unlocking a locked agent.
final class AgentUnlockRequested extends AgentEvent {
  /// The passphrase to unlock the agent.
  final String passphrase;

  /// Creates an AgentUnlockRequested event.
  const AgentUnlockRequested(this.passphrase);

  @override
  List<Object?> get props => [passphrase];
}

// Internal events for watch stream updates (not part of public API)

/// Internal event emitted when watch stream receives an update.
final class _AgentWatchUpdated extends AgentEvent {
  /// The updated watch state from the stream.
  final AgentWatchState watchState;

  /// Creates an _AgentWatchUpdated event.
  const _AgentWatchUpdated(this.watchState);

  @override
  List<Object?> get props => [watchState];
}

/// Internal event emitted when watch stream has an error.
final class _AgentWatchError extends AgentEvent {
  /// The error message.
  final String error;

  /// Creates an _AgentWatchError event.
  const _AgentWatchError(this.error);

  @override
  List<Object?> get props => [error];
}
