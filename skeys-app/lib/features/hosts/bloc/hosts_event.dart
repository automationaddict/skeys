part of 'hosts_bloc.dart';

sealed class HostsEvent extends Equatable {
  const HostsEvent();

  @override
  List<Object?> get props => [];
}

final class HostsLoadKnownHostsRequested extends HostsEvent {
  const HostsLoadKnownHostsRequested();
}

final class HostsRemoveKnownHostRequested extends HostsEvent {
  final String host;

  const HostsRemoveKnownHostRequested(this.host);

  @override
  List<Object?> get props => [host];
}

final class HostsHashKnownHostsRequested extends HostsEvent {
  const HostsHashKnownHostsRequested();
}

final class HostsLoadAuthorizedKeysRequested extends HostsEvent {
  const HostsLoadAuthorizedKeysRequested();
}

final class HostsAddAuthorizedKeyRequested extends HostsEvent {
  final String publicKey;

  const HostsAddAuthorizedKeyRequested(this.publicKey);

  @override
  List<Object?> get props => [publicKey];
}

final class HostsRemoveAuthorizedKeyRequested extends HostsEvent {
  final String publicKey;

  const HostsRemoveAuthorizedKeyRequested(this.publicKey);

  @override
  List<Object?> get props => [publicKey];
}
