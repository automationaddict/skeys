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

/// Agent status information.
class AgentStatus extends Equatable {
  /// Whether the SSH agent is currently running.
  final bool isRunning;

  /// The path to the agent's Unix socket.
  final String socketPath;

  /// Whether the agent is currently locked.
  final bool isLocked;

  /// The number of keys currently loaded in the agent.
  final int keyCount;

  /// Creates an AgentStatus with the given parameters.
  const AgentStatus({
    required this.isRunning,
    required this.socketPath,
    required this.isLocked,
    required this.keyCount,
  });

  @override
  List<Object?> get props => [isRunning, socketPath, isLocked, keyCount];
}

/// Key loaded in the SSH agent.
class AgentKeyEntry extends Equatable {
  /// The key's fingerprint (SHA256 hash).
  final String fingerprint;

  /// The comment associated with the key.
  final String comment;

  /// The key type (e.g., "ssh-ed25519", "ssh-rsa").
  final String type;

  /// The key size in bits.
  final int bits;

  /// Whether the key has a configured lifetime.
  final bool hasLifetime;

  /// Remaining seconds until the key is removed from the agent.
  final int lifetimeSeconds;

  /// Whether the key requires user confirmation before use.
  final bool requiresConfirmation;

  /// Creates an AgentKeyEntry with the given parameters.
  const AgentKeyEntry({
    required this.fingerprint,
    required this.comment,
    required this.type,
    required this.bits,
    required this.hasLifetime,
    required this.lifetimeSeconds,
    required this.requiresConfirmation,
  });

  @override
  List<Object?> get props => [
    fingerprint,
    comment,
    type,
    bits,
    hasLifetime,
    lifetimeSeconds,
    requiresConfirmation,
  ];
}
