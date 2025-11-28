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
  final bool isRunning;
  final String socketPath;
  final bool isLocked;
  final int keyCount;

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
  final String fingerprint;
  final String comment;
  final String type;
  final int bits;
  final bool hasLifetime;
  final int lifetimeSeconds;
  final bool requiresConfirmation;

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
