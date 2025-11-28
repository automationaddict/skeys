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

import 'dart:io';

import 'package:grpc/grpc.dart';

import '../generated/skeys/v1/keys.pbgrpc.dart';
import '../generated/skeys/v1/config.pbgrpc.dart';
import '../generated/skeys/v1/hosts.pbgrpc.dart';
import '../generated/skeys/v1/agent.pbgrpc.dart';
import '../generated/skeys/v1/remote.pbgrpc.dart';
import '../generated/skeys/v1/metadata.pbgrpc.dart';
import '../generated/skeys/v1/version.pbgrpc.dart';
import '../generated/skeys/v1/system.pbgrpc.dart';
import '../generated/skeys/v1/update.pbgrpc.dart';
import '../logging/app_logger.dart';

/// gRPC client for communicating with skeys-daemon.
///
/// Uses Unix socket for local communication.
class GrpcClient {
  final String socketPath;
  final AppLogger _log = AppLogger('grpc');

  ClientChannel? _channel;

  // Service stubs
  KeyServiceClient? _keys;
  ConfigServiceClient? _config;
  HostsServiceClient? _hosts;
  AgentServiceClient? _agent;
  RemoteServiceClient? _remote;
  MetadataServiceClient? _metadata;
  VersionServiceClient? _version;
  SystemServiceClient? _system;
  UpdateServiceClient? _update;

  KeyServiceClient get keys {
    if (_keys == null) {
      throw StateError('gRPC client not connected. Call connect() first.');
    }
    return _keys!;
  }

  ConfigServiceClient get config {
    if (_config == null) {
      throw StateError('gRPC client not connected. Call connect() first.');
    }
    return _config!;
  }

  HostsServiceClient get hosts {
    if (_hosts == null) {
      throw StateError('gRPC client not connected. Call connect() first.');
    }
    return _hosts!;
  }

  AgentServiceClient get agent {
    if (_agent == null) {
      throw StateError('gRPC client not connected. Call connect() first.');
    }
    return _agent!;
  }

  RemoteServiceClient get remote {
    if (_remote == null) {
      throw StateError('gRPC client not connected. Call connect() first.');
    }
    return _remote!;
  }

  MetadataServiceClient get metadata {
    if (_metadata == null) {
      throw StateError('gRPC client not connected. Call connect() first.');
    }
    return _metadata!;
  }

  VersionServiceClient get version {
    if (_version == null) {
      throw StateError('gRPC client not connected. Call connect() first.');
    }
    return _version!;
  }

  SystemServiceClient get system {
    if (_system == null) {
      throw StateError('gRPC client not connected. Call connect() first.');
    }
    return _system!;
  }

  UpdateServiceClient get update {
    if (_update == null) {
      throw StateError('gRPC client not connected. Call connect() first.');
    }
    return _update!;
  }

  GrpcClient(this.socketPath) {
    _log.debug('gRPC client created', {'socket_path': socketPath});
  }

  /// Connects to the skeys-daemon via Unix socket.
  Future<void> connect() async {
    _log.info('connecting to daemon', {'socket_path': socketPath});

    // Verify socket exists
    final socketFile = File(socketPath);
    if (!await socketFile.exists()) {
      _log.error('socket file does not exist', null, null, {
        'path': socketPath,
      });
      throw StateError('Socket file does not exist: $socketPath');
    }

    _log.debug('socket file exists, creating channel');

    try {
      // Create Unix socket channel
      _channel = ClientChannel(
        InternetAddress(socketPath, type: InternetAddressType.unix),
        port: 0,
        options: const ChannelOptions(
          credentials: ChannelCredentials.insecure(),
        ),
      );

      // Initialize service stubs
      _keys = KeyServiceClient(_channel!);
      _config = ConfigServiceClient(_channel!);
      _hosts = HostsServiceClient(_channel!);
      _agent = AgentServiceClient(_channel!);
      _remote = RemoteServiceClient(_channel!);
      _metadata = MetadataServiceClient(_channel!);
      _version = VersionServiceClient(_channel!);
      _system = SystemServiceClient(_channel!);
      _update = UpdateServiceClient(_channel!);

      _log.info('gRPC client connected successfully');
    } catch (e, st) {
      _log.error('failed to create gRPC channel', e, st);
      rethrow;
    }
  }

  /// Disconnects from the daemon.
  Future<void> disconnect() async {
    _log.info('disconnecting gRPC client');

    if (_channel == null) {
      _log.debug('channel already null, nothing to disconnect');
      return;
    }

    try {
      await _channel!.shutdown();
      _log.info('gRPC channel shutdown complete');
    } catch (e, st) {
      _log.error('error during channel shutdown', e, st);
    }

    _channel = null;
    _keys = null;
    _config = null;
    _hosts = null;
    _agent = null;
    _remote = null;
    _metadata = null;
    _version = null;
    _system = null;
    _update = null;
  }

  /// Checks if the connection is healthy.
  Future<bool> isHealthy() async {
    _log.debug('checking connection health');

    if (_keys == null) {
      _log.debug('health check failed: client not connected');
      return false;
    }

    try {
      // Try a simple operation to verify connection
      await _keys!.listKeys(ListKeysRequest());
      _log.debug('health check passed');
      return true;
    } catch (e) {
      _log.warning('health check failed', {'error': e.toString()});
      return false;
    }
  }
}
