import 'package:flutter/foundation.dart';

import '../../../core/logging/app_logger.dart';

/// Tracks when keys were added to the agent for countdown display.
///
/// The SSH agent protocol doesn't expose when keys were added, only the
/// configured lifetime. This service tracks addition times locally so we
/// can display accurate countdown timers.
class AgentKeyTracker extends ChangeNotifier {
  final AppLogger _log = AppLogger('agent_key_tracker');

  /// Map of fingerprint -> DateTime when key was added
  final Map<String, DateTime> _addedTimes = {};

  /// Map of fingerprint -> timeout duration in seconds (0 = no timeout)
  final Map<String, int> _timeouts = {};

  /// Record that a key was added with a specific timeout.
  void keyAdded(String fingerprint, int timeoutSeconds) {
    _addedTimes[fingerprint] = DateTime.now();
    _timeouts[fingerprint] = timeoutSeconds;
    _log.debug('key added to tracker', {
      'fingerprint': fingerprint,
      'timeout_seconds': timeoutSeconds,
    });
    notifyListeners();
  }

  /// Record that a key was removed.
  void keyRemoved(String fingerprint) {
    _addedTimes.remove(fingerprint);
    _timeouts.remove(fingerprint);
    _log.debug('key removed from tracker', {'fingerprint': fingerprint});
    notifyListeners();
  }

  /// Clear all tracked keys.
  void clear() {
    _addedTimes.clear();
    _timeouts.clear();
    _log.debug('tracker cleared');
    notifyListeners();
  }

  /// Sync tracker with current keys from agent.
  /// Removes entries for keys no longer in agent, preserves existing tracked keys.
  void syncWithAgentKeys(List<String> currentFingerprints) {
    final toRemove = _addedTimes.keys
        .where((fp) => !currentFingerprints.contains(fp))
        .toList();

    for (final fp in toRemove) {
      _addedTimes.remove(fp);
      _timeouts.remove(fp);
    }

    if (toRemove.isNotEmpty) {
      _log.debug('synced tracker, removed stale entries', {'count': toRemove.length});
      notifyListeners();
    }
  }

  /// Get when a key was added. Returns null if not tracked.
  DateTime? getAddedTime(String fingerprint) {
    return _addedTimes[fingerprint];
  }

  /// Get the timeout for a key. Returns 0 if not tracked or no timeout.
  int getTimeout(String fingerprint) {
    return _timeouts[fingerprint] ?? 0;
  }

  /// Get remaining time for a key in seconds. Returns null if not tracked or no timeout.
  int? getRemainingSeconds(String fingerprint) {
    final addedTime = _addedTimes[fingerprint];
    final timeout = _timeouts[fingerprint];

    if (addedTime == null || timeout == null || timeout == 0) {
      return null;
    }

    final elapsed = DateTime.now().difference(addedTime).inSeconds;
    final remaining = timeout - elapsed;

    return remaining > 0 ? remaining : 0;
  }

  /// Check if a key is expired (past its timeout).
  bool isExpired(String fingerprint) {
    final remaining = getRemainingSeconds(fingerprint);
    return remaining != null && remaining <= 0;
  }

  /// Check if we have tracking data for a key.
  bool isTracked(String fingerprint) {
    return _addedTimes.containsKey(fingerprint);
  }
}
