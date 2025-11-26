import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/di/injection.dart';
import '../../../core/settings/settings_service.dart';
import '../service/agent_key_tracker.dart';

/// Widget that displays a countdown timer for a key's remaining time in the agent.
class KeyCountdownWidget extends StatefulWidget {
  final String fingerprint;
  /// If true, show "Unknown" for untracked keys instead of hiding.
  final bool showUnknown;

  const KeyCountdownWidget({
    super.key,
    required this.fingerprint,
    this.showUnknown = true,
  });

  @override
  State<KeyCountdownWidget> createState() => _KeyCountdownWidgetState();
}

class _KeyCountdownWidgetState extends State<KeyCountdownWidget> {
  final _tracker = getIt<AgentKeyTracker>();
  Timer? _timer;
  int? _remainingSeconds;

  @override
  void initState() {
    super.initState();
    _updateRemaining();
    // Update every second for accurate countdown
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateRemaining();
    });
  }

  void _updateRemaining() {
    final remaining = _tracker.getRemainingSeconds(widget.fingerprint);
    if (mounted && remaining != _remainingSeconds) {
      setState(() {
        _remainingSeconds = remaining;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingsService = getIt<SettingsService>();
    final timeoutMinutes = settingsService.agentKeyTimeoutMinutes;

    if (_remainingSeconds == null) {
      // Key not tracked - show "Unknown" if timeout is configured and showUnknown is true
      if (!widget.showUnknown || timeoutMinutes == 0) {
        return const SizedBox.shrink();
      }

      // Show indicator that this key has unknown remaining time
      final color = Theme.of(context).colorScheme.outline;
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.timer,
              size: 14,
              color: color,
            ),
            const SizedBox(width: 4),
            Text(
              'Unknown',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      );
    }

    final remaining = _remainingSeconds!;
    final isExpired = remaining <= 0;
    final isWarning = remaining > 0 && remaining < 300; // < 5 minutes

    final color = isExpired
        ? Colors.red
        : isWarning
            ? Colors.orange
            : Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isExpired ? Icons.timer_off : Icons.timer,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            isExpired ? 'Expired' : _formatDuration(remaining),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(int seconds) {
    if (seconds <= 0) return '0:00';

    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else if (minutes > 0) {
      return '$minutes:${secs.toString().padLeft(2, '0')}';
    } else {
      return '0:${secs.toString().padLeft(2, '0')}';
    }
  }
}
