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
