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

part of 'remote_bloc.dart';

sealed class RemoteEvent extends Equatable {
  const RemoteEvent();

  @override
  List<Object?> get props => [];
}

final class RemoteLoadRequested extends RemoteEvent {
  const RemoteLoadRequested();
}

final class RemoteAddRequested extends RemoteEvent {
  final String name;
  final String host;
  final int port;
  final String user;
  final String? identityFile;
  final String? sshConfigAlias;

  const RemoteAddRequested({
    required this.name,
    required this.host,
    required this.port,
    required this.user,
    this.identityFile,
    this.sshConfigAlias,
  });

  @override
  List<Object?> get props => [
    name,
    host,
    port,
    user,
    identityFile,
    sshConfigAlias,
  ];
}

final class RemoteDeleteRequested extends RemoteEvent {
  final String id;

  const RemoteDeleteRequested(this.id);

  @override
  List<Object?> get props => [id];
}

final class RemoteConnectRequested extends RemoteEvent {
  final String remoteId;
  final String? passphrase;

  const RemoteConnectRequested({required this.remoteId, this.passphrase});

  @override
  List<Object?> get props => [remoteId, passphrase];
}

final class RemoteDisconnectRequested extends RemoteEvent {
  final String connectionId;

  const RemoteDisconnectRequested(this.connectionId);

  @override
  List<Object?> get props => [connectionId];
}

final class RemoteLoadConnectionsRequested extends RemoteEvent {
  const RemoteLoadConnectionsRequested();
}

final class RemoteWatchConnectionsRequested extends RemoteEvent {
  const RemoteWatchConnectionsRequested();
}

final class RemoteExecuteCommandRequested extends RemoteEvent {
  final String connectionId;
  final String command;
  final int? timeout;

  const RemoteExecuteCommandRequested({
    required this.connectionId,
    required this.command,
    this.timeout,
  });

  @override
  List<Object?> get props => [connectionId, command, timeout];
}
