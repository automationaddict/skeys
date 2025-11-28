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

import 'dart:async';

import 'package:flutter/foundation.dart';

import '../di/injection.dart';
import '../generated/google/protobuf/empty.pb.dart';
import '../generated/skeys/v1/update.pbgrpc.dart';
import '../grpc/grpc_client.dart';
import '../logging/app_logger.dart';

/// Service for managing update status and notifications.
///
/// This service periodically checks for updates and notifies listeners
/// when an update is available.
class UpdateService extends ChangeNotifier {
  final _log = AppLogger('update_service');
  final GrpcClient _grpcClient;

  Timer? _checkTimer;
  UpdateStatus? _status;
  bool _updateAvailable = false;
  String? _latestVersion;

  /// Creates an UpdateService with an optional gRPC client.
  UpdateService({GrpcClient? grpcClient})
    : _grpcClient = grpcClient ?? getIt<GrpcClient>();

  /// Whether an update is available.
  bool get updateAvailable => _updateAvailable;

  /// The latest available version, if any.
  String? get latestVersion => _latestVersion;

  /// The current update status.
  UpdateStatus? get status => _status;

  /// Initializes the service and starts periodic update checks.
  Future<void> initialize() async {
    _log.info('initializing update service');

    // Do an initial check
    await checkForUpdates();

    // Start periodic checks (every 6 hours)
    _checkTimer?.cancel();
    _checkTimer = Timer.periodic(
      const Duration(hours: 6),
      (_) => checkForUpdates(),
    );
  }

  /// Checks for available updates.
  Future<void> checkForUpdates() async {
    try {
      _log.debug('checking for updates');

      final status = await _grpcClient.update.getUpdateStatus(Empty());
      _status = status;

      final hasUpdate =
          status.hasAvailableUpdate() && status.availableUpdate.updateAvailable;

      if (hasUpdate != _updateAvailable ||
          status.availableUpdate.latestVersion != _latestVersion) {
        _updateAvailable = hasUpdate;
        _latestVersion = hasUpdate
            ? status.availableUpdate.latestVersion
            : null;
        notifyListeners();

        if (hasUpdate) {
          _log.info('update available', {'version': _latestVersion});
        }
      }
    } catch (e, st) {
      _log.error('error checking for updates', e, st);
    }
  }

  @override
  void dispose() {
    _checkTimer?.cancel();
    super.dispose();
  }
}
