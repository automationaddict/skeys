import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as path;

import '../logging/app_logger.dart';

/// Launches and manages the skeys-daemon backend process.
///
/// The daemon communicates via Unix socket for gRPC.
///
/// In dev mode (SKEYS_DEV=true), connects to /tmp/skeys-dev.sock and expects
/// the daemon to be running externally (e.g., via Tilt container).
///
/// In production mode, connects to /tmp/skeys.sock and will launch the
/// installed daemon if not already running.
class BackendLauncher {
  final AppLogger _log = AppLogger('backend');

  Process? _process;
  String? _socketPath;
  bool _isRunning = false;
  bool _externalDaemon = false;

  /// Returns true if running in development mode (SKEYS_DEV=true)
  static bool get isDevMode => Platform.environment['SKEYS_DEV'] == 'true';

  /// Returns the appropriate socket path based on mode
  static String get defaultSocketPath =>
      isDevMode ? '/tmp/skeys-dev.sock' : '/tmp/skeys.sock';

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

    _log.info('starting backend launcher', {
      'dev_mode': isDevMode,
    });

    // Use appropriate socket path for mode
    _socketPath = defaultSocketPath;
    _log.debug('using socket path', {'socket_path': _socketPath});

    // In dev mode, connect to existing daemon (managed externally by Tilt/container)
    if (isDevMode) {
      final socketFile = File(_socketPath!);
      if (await socketFile.exists() && await _isSocketListening(_socketPath!)) {
        _log.info('dev mode: connecting to external daemon', {
          'socket_path': _socketPath,
        });
        _isRunning = true;
        _externalDaemon = true;
        return;
      }
      throw StateError(
        'Dev mode: daemon not running. Start it with "tilt up" or "just dev".\n'
        'Expected socket at: $_socketPath',
      );
    }

    // Production mode: always kill any existing daemon to ensure we run the
    // latest version (important after updates)
    await _killExistingDaemon();

    // Production mode: find and launch the daemon
    String daemonPath;
    try {
      daemonPath = await _findDaemonExecutable();
      _log.info('found daemon executable', {'path': daemonPath});
    } catch (e) {
      _log.error('failed to find daemon executable', e);
      rethrow;
    }

    // Start the daemon process
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

  /// Kills any existing skeys-daemon process to ensure we start fresh.
  /// This is important after updates to ensure the new binary is used.
  Future<void> _killExistingDaemon() async {
    _log.debug('killing any existing daemon process');

    // Kill daemon by name (covers any socket path)
    try {
      final result = await Process.run('pkill', ['-f', 'skeys-daemon']);
      if (result.exitCode == 0) {
        _log.info('killed existing daemon process');
        // Give it time to shut down gracefully
        await Future.delayed(const Duration(milliseconds: 500));
      }
    } catch (e) {
      _log.debug('pkill returned non-zero (no daemon running)', {'error': e});
    }

    // Clean up any stale socket file
    final socketFile = File(_socketPath!);
    if (await socketFile.exists()) {
      _log.debug('removing stale socket file', {'path': _socketPath});
      try {
        await socketFile.delete();
      } catch (e) {
        _log.warning('failed to remove socket file', {'error': e});
      }
    }
  }

  Future<String> _findDaemonExecutable() async {
    // Only search installed locations - dev mode uses containerized daemon
    final locations = [
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
      'Please install skeys with "just install" or download from GitHub releases.',
    );
  }

  /// Checks if a Unix socket is actually listening (not just a stale file).
  Future<bool> _isSocketListening(String socketPath) async {
    try {
      // Use a short timeout to avoid hanging on stale sockets
      final socket = await Socket.connect(
        InternetAddress(socketPath, type: InternetAddressType.unix),
        0,
      ).timeout(const Duration(milliseconds: 500));
      await socket.close();
      return true;
    } on TimeoutException {
      _log.debug('socket connection timed out (stale socket)', {'path': socketPath});
      return false;
    } on SocketException catch (e) {
      _log.debug('socket connection failed', {'path': socketPath, 'error': e.message});
      return false;
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
