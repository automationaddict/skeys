part of 'hosts_bloc.dart';

enum HostsStatus {
  initial,
  loading,
  success,
  failure,
}

final class HostsState extends Equatable {
  final HostsStatus status;
  final List<KnownHostEntry> knownHosts;
  final List<AuthorizedKeyEntry> authorizedKeys;
  final String? errorMessage;

  const HostsState({
    this.status = HostsStatus.initial,
    this.knownHosts = const [],
    this.authorizedKeys = const [],
    this.errorMessage,
  });

  HostsState copyWith({
    HostsStatus? status,
    List<KnownHostEntry>? knownHosts,
    List<AuthorizedKeyEntry>? authorizedKeys,
    String? errorMessage,
  }) {
    return HostsState(
      status: status ?? this.status,
      knownHosts: knownHosts ?? this.knownHosts,
      authorizedKeys: authorizedKeys ?? this.authorizedKeys,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, knownHosts, authorizedKeys, errorMessage];
}
