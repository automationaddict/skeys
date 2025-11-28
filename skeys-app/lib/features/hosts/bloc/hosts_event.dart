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

part of 'hosts_bloc.dart';

sealed class HostsEvent extends Equatable {
  const HostsEvent();

  @override
  List<Object?> get props => [];
}

final class HostsLoadKnownHostsRequested extends HostsEvent {
  const HostsLoadKnownHostsRequested();
}

final class HostsWatchKnownHostsRequested extends HostsEvent {
  const HostsWatchKnownHostsRequested();
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

final class HostsWatchAuthorizedKeysRequested extends HostsEvent {
  const HostsWatchAuthorizedKeysRequested();
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

  const HostsScanHostKeysRequested(
    this.hostname, {
    this.port = 22,
    this.timeout = 10,
  });

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
