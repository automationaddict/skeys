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
