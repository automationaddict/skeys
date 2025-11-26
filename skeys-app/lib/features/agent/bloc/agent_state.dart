part of 'agent_bloc.dart';

enum AgentBlocStatus {
  initial,
  loading,
  success,
  failure,
}

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
