import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as path;

import '../logging/app_logger.dart';

/// Launches and manages the skeys-daemon backend process.
///
/// The daemon communicates via Unix socket for gRPC.
class BackendLauncher {
  final AppLogger _log = AppLogger('backend');

  Process? _process;
  String? _socketPath;
  bool _isRunning = false;
  bool _externalDaemon = false;

  String get socketPath {
    if (_socketPath == null) {
      throw StateError('Backend not started. Call start() first.');
    }
    return _socketPath!;
  }

  bool get isRunning => _isRunning;

  /// Starts the skeys-daemon backend process or connects to an existing one.
  Future<void> start() async {
    if (_isRunning) {
      _log.debug('backend already running');
      return;
    }

    _log.info('starting backend launcher');

    // Determine socket path - use /tmp for consistency with daemon
    _socketPath = '/tmp/skeys.sock';
    _log.debug('using socket path', {'socket_path': _socketPath});

    // Check if socket already exists (daemon already running externally)
    final socketFile = File(_socketPath!);
    if (await socketFile.exists()) {
      // Verify the socket is actually listening by trying to connect
      if (await _isSocketListening(_socketPath!)) {
        _log.info('found existing daemon socket, connecting to external daemon', {
          'socket_path': _socketPath,
        });
        _isRunning = true;
        _externalDaemon = true;
        return;
      } else {
        // Stale socket file - remove it
        _log.warning('found stale socket file, removing', {'path': _socketPath});
        await socketFile.delete();
      }
    }

    // Find the daemon executable
    String daemonPath;
    try {
      daemonPath = await _findDaemonExecutable();
      _log.info('found daemon executable', {'path': daemonPath});
    } catch (e) {
      _log.error('failed to find daemon executable', e);
      rethrow;
    }

    // Start the daemon process (not detached so we can monitor it)
    _log.info('starting daemon process', {
      'executable': daemonPath,
      'socket': _socketPath,
    });

    try {
      // Start daemon in a new session to prevent terminal state issues
      _process = await Process.start(
        'setsid',
        ['-f', daemonPath, '--socket', _socketPath!],
      );
      _log.debug('daemon process started via setsid', {'pid': _process!.pid});
    } catch (e) {
      _log.error('failed to start daemon process', e);
      rethrow;
    }

    // Wait for socket to be created
    try {
      await _waitForSocket();
      _log.info('daemon socket is ready');
    } catch (e) {
      _log.error('timeout waiting for daemon socket', e);
      _process?.kill();
      rethrow;
    }

    _isRunning = true;
    _externalDaemon = false;

    // Note: With setsid -f, the daemon runs in its own session and we can't
    // directly monitor its exit or capture its output. The daemon logs to
    // its own stdout which goes to the terminal or /dev/null.

    _log.info('backend launcher started successfully');
  }

  /// Stops the backend process (only if we started it).
  Future<void> stop() async {
    if (!_isRunning) {
      _log.debug('backend not running, nothing to stop');
      return;
    }

    if (_externalDaemon) {
      _log.info('not stopping external daemon');
      _isRunning = false;
      return;
    }

    _log.info('stopping daemon process');

    // Find and kill the daemon process by name since we used setsid
    try {
      await Process.run('pkill', ['-f', 'skeys-daemon.*--socket.*$_socketPath']);
      _log.info('sent SIGTERM to daemon');

      // Give it time to shut down gracefully
      await Future.delayed(const Duration(seconds: 2));
    } catch (e) {
      _log.warning('error stopping daemon', {'error': e});
    }

    // Clean up socket file
    if (_socketPath != null) {
      final socketFile = File(_socketPath!);
      if (await socketFile.exists()) {
        _log.debug('cleaning up socket file', {'path': _socketPath});
        await socketFile.delete();
      }
    }

    _isRunning = false;
    _process = null;
    _log.info('backend launcher stopped');
  }

  Future<String> _findDaemonExecutable() async {
    // Check common locations for the daemon
    final locations = [
      // Development: relative to app
      path.join(Directory.current.path, '..', 'skeys-daemon', 'skeys-daemon'),
      // Development: in daemon build dir
      path.join(Directory.current.path, '..', 'skeys-daemon', 'bin', 'skeys-daemon'),
      // Installed: user local bin
      path.join(Platform.environment['HOME'] ?? '', '.local', 'bin', 'skeys-daemon'),
      // Installed: system bin
      '/usr/local/bin/skeys-daemon',
      '/usr/bin/skeys-daemon',
    ];

    _log.debug('searching for daemon executable', {'locations': locations.length});

    for (final location in locations) {
      final file = File(location);
      if (await file.exists()) {
        _log.debug('found daemon at location', {'path': location});
        return location;
      }
    }

    // Try to find it in PATH
    _log.debug('checking PATH for daemon');
    final result = await Process.run('which', ['skeys-daemon']);
    if (result.exitCode == 0) {
      final foundPath = (result.stdout as String).trim();
      _log.debug('found daemon in PATH', {'path': foundPath});
      return foundPath;
    }

    _log.error('daemon executable not found', null, null, {
      'searched_locations': locations,
    });

    throw StateError(
      'Could not find skeys-daemon executable. '
      'Please build the daemon or install it to one of: ${locations.join(", ")}',
    );
  }

  /// Checks if a Unix socket is actually listening (not just a stale file).
  Future<bool> _isSocketListening(String socketPath) async {
    try {
      final socket = await Socket.connect(
        InternetAddress(socketPath, type: InternetAddressType.unix),
        0,
      );
      await socket.close();
      return true;
    } catch (e) {
      _log.debug('socket connection test failed', {'path': socketPath, 'error': e});
      return false;
    }
  }

  Future<void> _waitForSocket() async {
    const maxAttempts = 50; // 5 seconds total
    const delay = Duration(milliseconds: 100);

    _log.debug('waiting for socket', {
      'path': _socketPath,
      'max_wait_ms': maxAttempts * delay.inMilliseconds,
    });

    for (var i = 0; i < maxAttempts; i++) {
      final socketFile = File(_socketPath!);
      if (await socketFile.exists()) {
        _log.debug('socket appeared', {'attempts': i + 1});
        return;
      }
      await Future.delayed(delay);
    }

    throw StateError(
      'Timeout waiting for skeys-daemon socket at $_socketPath',
    );
  }
}
