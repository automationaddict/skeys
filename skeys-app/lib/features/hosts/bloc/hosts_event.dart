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

final class HostsScanHostKeysRequested extends HostsEvent {
  final String hostname;
  final int port;
  final int timeout;

  const HostsScanHostKeysRequested(this.hostname, {this.port = 22, this.timeout = 10});

  @override
  List<Object?> get props => [hostname, port, timeout];
}

final class HostsAddKnownHostRequested extends HostsEvent {
  final String hostname;
  final String keyType;
  final String publicKey;
  final int port;
  final bool hashHostname;

  const HostsAddKnownHostRequested({
    required this.hostname,
    required this.keyType,
    required this.publicKey,
    this.port = 22,
    this.hashHostname = false,
  });

  @override
  List<Object?> get props => [hostname, keyType, publicKey, port, hashHostname];
}

final class HostsClearScannedKeysRequested extends HostsEvent {
  const HostsClearScannedKeysRequested();
}
