import 'package:flutter/material.dart';

/// Widget that displays a countdown timer for a key's remaining time in the agent.
///
/// The [lifetimeSeconds] is provided by the backend and represents the remaining
/// time before the key expires. The parent widget rebuilds when the backend
/// stream provides updated values.
class KeyCountdownWidget extends StatelessWidget {
  /// Whether the key has a lifetime configured.
  final bool hasLifetime;

  /// Remaining seconds until the key expires. Only meaningful if [hasLifetime] is true.
  final int lifetimeSeconds;

  const KeyCountdownWidget({
    super.key,
    required this.hasLifetime,
    required this.lifetimeSeconds,
  });

  @override
  Widget build(BuildContext context) {
    // No lifetime configured - don't show anything
    if (!hasLifetime) {
      return const SizedBox.shrink();
    }

    final isExpired = lifetimeSeconds <= 0;
    final isWarning = lifetimeSeconds > 0 && lifetimeSeconds < 300; // < 5 minutes

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
            isExpired ? 'Expired' : _formatDuration(lifetimeSeconds),
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
