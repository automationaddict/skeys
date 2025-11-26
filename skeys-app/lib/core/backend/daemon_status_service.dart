import 'dart:async';

import 'package:flutter/foundation.dart';

import '../di/injection.dart';
import '../grpc/grpc_client.dart';
import '../logging/app_logger.dart';

/// Status of the daemon connection.
enum DaemonStatus {
  connected,
  disconnected,
  reconnecting,
}

/// Service that monitors daemon connection health and provides reconnection.
class DaemonStatusService extends ChangeNotifier {
  final AppLogger _log = AppLogger('daemon_status');

  Timer? _healthCheckTimer;
  DaemonStatus _status = DaemonStatus.connected;
  String? _lastError;
  int _reconnectAttempts = 0;
  static const _maxReconnectAttempts = 3;
  static const _healthCheckInterval = Duration(seconds: 30);
  static const _reconnectDelay = Duration(seconds: 2);

  DaemonStatus get status => _status;
  String? get lastError => _lastError;
  bool get isConnected => _status == DaemonStatus.connected;

  DaemonStatusService() {
    _startHealthCheck();
  }

  void _startHealthCheck() {
    _healthCheckTimer?.cancel();
    _healthCheckTimer = Timer.periodic(_healthCheckInterval, (_) => checkHealth());
    // Defer initial check to next frame to ensure everything is initialized
    Future.delayed(const Duration(milliseconds: 100), checkHealth);
  }

  /// Check if the daemon connection is healthy.
  Future<void> checkHealth() async {
    try {
      final grpcClient = getIt<GrpcClient>();
      final healthy = await grpcClient.isHealthy();

      if (healthy) {
        if (_status != DaemonStatus.connected) {
          _log.info('daemon connection restored');
          _status = DaemonStatus.connected;
          _lastError = null;
          _reconnectAttempts = 0;
          notifyListeners();
        }
      } else {
        _handleDisconnection('Health check failed');
      }
    } catch (e) {
      _handleDisconnection(e.toString());
    }
  }

  void _handleDisconnection(String error) {
    if (_status == DaemonStatus.connected) {
      _log.warning('daemon connection lost', {'error': error});
      _status = DaemonStatus.disconnected;
      _lastError = error;
      notifyListeners();
    }
  }

  /// Attempt to reconnect to the daemon.
  Future<bool> reconnect() async {
    if (_status == DaemonStatus.reconnecting) {
      _log.debug('reconnect already in progress');
      return false;
    }

    _log.info('attempting to reconnect to daemon');
    _status = DaemonStatus.reconnecting;
    _reconnectAttempts++;
    notifyListeners();

    try {
      final grpcClient = getIt<GrpcClient>();

      // Disconnect first
      await grpcClient.disconnect();

      // Wait a bit for the daemon to recover (systemd should restart it)
      await Future.delayed(_reconnectDelay);

      // Try to reconnect
      await grpcClient.connect();

      // Verify the connection works
      final healthy = await grpcClient.isHealthy();

      if (healthy) {
        _log.info('reconnection successful');
        _status = DaemonStatus.connected;
        _lastError = null;
        _reconnectAttempts = 0;
        notifyListeners();
        return true;
      } else {
        throw Exception('Connection established but health check failed');
      }
    } catch (e) {
      _log.error('reconnection failed', e);
      _status = DaemonStatus.disconnected;
      _lastError = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Whether we should show manual intervention instructions.
  bool get needsManualIntervention =>
      _status == DaemonStatus.disconnected &&
      _reconnectAttempts >= _maxReconnectAttempts;

  @override
  void dispose() {
    _healthCheckTimer?.cancel();
    super.dispose();
  }
}
