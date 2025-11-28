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

/// Base class for all remote-related events.
sealed class RemoteEvent extends Equatable {
  /// Creates a RemoteEvent.
  const RemoteEvent();

  @override
  List<Object?> get props => [];
}

/// Event to request loading all remote configurations.
final class RemoteLoadRequested extends RemoteEvent {
  /// Creates a RemoteLoadRequested event.
  const RemoteLoadRequested();
}

/// Event to request adding a new remote configuration.
final class RemoteAddRequested extends RemoteEvent {
  /// The display name for the remote.
  final String name;

  /// The hostname or IP address.
  final String host;

  /// The SSH port.
  final int port;

  /// The username for authentication.
  final String user;

  /// Optional path to identity file.
  final String? identityFile;

  /// Optional SSH config alias to use.
  final String? sshConfigAlias;

  /// Creates a RemoteAddRequested event.
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

/// Event to request deleting a remote configuration.
final class RemoteDeleteRequested extends RemoteEvent {
  /// The ID of the remote to delete.
  final String id;

  /// Creates a RemoteDeleteRequested event.
  const RemoteDeleteRequested(this.id);

  @override
  List<Object?> get props => [id];
}

/// Event to request connecting to a remote server.
final class RemoteConnectRequested extends RemoteEvent {
  /// The ID of the remote to connect to.
  final String remoteId;

  /// Optional passphrase if key is encrypted.
  final String? passphrase;

  /// Creates a RemoteConnectRequested event.
  const RemoteConnectRequested({required this.remoteId, this.passphrase});

  @override
  List<Object?> get props => [remoteId, passphrase];
}

/// Event to request disconnecting from a remote server.
final class RemoteDisconnectRequested extends RemoteEvent {
  /// The ID of the connection to close.
  final String connectionId;

  /// Creates a RemoteDisconnectRequested event.
  const RemoteDisconnectRequested(this.connectionId);

  @override
  List<Object?> get props => [connectionId];
}

/// Event to request loading active connections.
final class RemoteLoadConnectionsRequested extends RemoteEvent {
  /// Creates a RemoteLoadConnectionsRequested event.
  const RemoteLoadConnectionsRequested();
}

/// Event to start watching connections for changes.
final class RemoteWatchConnectionsRequested extends RemoteEvent {
  /// Creates a RemoteWatchConnectionsRequested event.
  const RemoteWatchConnectionsRequested();
}

/// Event to request executing a command on a remote server.
final class RemoteExecuteCommandRequested extends RemoteEvent {
  /// The ID of the connection to use.
  final String connectionId;

  /// The command to execute.
  final String command;

  /// Optional timeout in seconds.
  final int? timeout;

  /// Creates a RemoteExecuteCommandRequested event.
  const RemoteExecuteCommandRequested({
    required this.connectionId,
    required this.command,
    this.timeout,
  });

  @override
  List<Object?> get props => [connectionId, command, timeout];
}
