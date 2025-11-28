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
import 'dart:async';

import 'logging/app_logger.dart';

/// Ensures only one instance of the app can run at a time.
///
/// Uses a Unix domain socket as a lock - if we can bind to it, we're the
/// first instance. If bind fails, another instance is already running.
class SingleInstance {
  static final _log = AppLogger('single_instance');
  static ServerSocket? _serverSocket;
  static String? _socketPath;

  /// The socket path used for the instance lock
  static String get socketPath {
    if (_socketPath != null) return _socketPath!;

    final runtimeDir = Platform.environment['XDG_RUNTIME_DIR'];
    if (runtimeDir != null) {
      _socketPath = '$runtimeDir/skeys-app.sock';
    } else {
      _socketPath =
          '/tmp/skeys-app-${Platform.environment['USER'] ?? 'unknown'}.sock';
    }
    return _socketPath!;
  }

  /// Attempts to acquire the single instance lock.
  ///
  /// Returns true if this is the only instance (lock acquired).
  /// Returns false if another instance is already running.
  static Future<bool> acquire() async {
    _log.debug('attempting to acquire single instance lock', {
      'socket_path': socketPath,
    });

    // Clean up stale socket if it exists but nothing is listening
    final socketFile = File(socketPath);
    if (await socketFile.exists()) {
      if (await _isSocketListening(socketPath)) {
        _log.info('another instance is already running');
        return false;
      }
      // Stale socket - remove it
      _log.debug('removing stale socket file');
      await socketFile.delete();
    }

    // Try to bind to the socket
    try {
      _serverSocket = await ServerSocket.bind(
        InternetAddress(socketPath, type: InternetAddressType.unix),
        0,
      );

      // Set socket permissions (owner only)
      await Process.run('chmod', ['600', socketPath]);

      _log.info('single instance lock acquired', {'socket_path': socketPath});

      // Listen for connections from other instances trying to start
      _serverSocket!.listen((socket) {
        _log.debug('received connection from another instance');
        // Could send a message to bring window to front here
        socket.close();
      });

      return true;
    } on SocketException catch (e) {
      _log.warning('failed to acquire lock', {'error': e.message});
      return false;
    }
  }

  /// Releases the single instance lock.
  static Future<void> release() async {
    if (_serverSocket != null) {
      _log.debug('releasing single instance lock');
      await _serverSocket!.close();
      _serverSocket = null;

      // Clean up socket file
      final socketFile = File(socketPath);
      if (await socketFile.exists()) {
        await socketFile.delete();
      }
    }
  }

  /// Checks if a socket is actively listening.
  static Future<bool> _isSocketListening(String path) async {
    try {
      final socket = await Socket.connect(
        InternetAddress(path, type: InternetAddressType.unix),
        0,
      ).timeout(const Duration(milliseconds: 500));
      await socket.close();
      return true;
    } catch (_) {
      return false;
    }
  }
}
