import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../backend/daemon_status_service.dart';
import '../di/injection.dart';
import '../notifications/app_toast.dart';

/// A small indicator showing the daemon connection status.
class DaemonStatusIndicator extends StatelessWidget {
  const DaemonStatusIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final statusService = getIt<DaemonStatusService>();

    return ListenableBuilder(
      listenable: statusService,
      builder: (context, _) {
        return _buildIndicator(context, statusService);
      },
    );
  }

  Widget _buildIndicator(BuildContext context, DaemonStatusService statusService) {
    final status = statusService.status;

    IconData icon;
    Color color;
    String tooltip;

    switch (status) {
      case DaemonStatus.connected:
        icon = Icons.circle;
        color = Colors.green;
        tooltip = 'Daemon connected';
      case DaemonStatus.disconnected:
        icon = Icons.circle;
        color = Colors.red;
        tooltip = 'Daemon disconnected - tap to reconnect';
      case DaemonStatus.reconnecting:
        icon = Icons.sync;
        color = Colors.orange;
        tooltip = 'Reconnecting to daemon...';
    }

    return GestureDetector(
      onTap: status == DaemonStatus.disconnected
          ? () => _showDisconnectedDialog(context, statusService)
          : null,
      child: Tooltip(
        message: tooltip,
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: status == DaemonStatus.reconnecting
              ? SizedBox(
                  width: 16,
                  height: 16,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: color,
                    ),
                  ),
                )
              : Icon(
                  icon,
                  size: 12,
                  color: color,
                ),
        ),
      ),
    );
  }

  void _showDisconnectedDialog(
    BuildContext context,
    DaemonStatusService statusService,
  ) {
    showDialog(
      context: context,
      builder: (context) => _DisconnectedDialog(statusService: statusService),
    );
  }
}

class _DisconnectedDialog extends StatelessWidget {
  final DaemonStatusService statusService;

  const _DisconnectedDialog({required this.statusService});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: statusService,
      builder: (context, _) {
        final needsManualIntervention = statusService.needsManualIntervention;

        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.orange,
              ),
              const SizedBox(width: 12),
              const Text('Daemon Disconnected'),
            ],
          ),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'The connection to the skeys-daemon has been lost.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                if (statusService.lastError != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      statusService.lastError!,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onErrorContainer,
                      ),
                    ),
                  ),
                ],
                if (needsManualIntervention) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Multiple reconnection attempts have failed. Try these commands:',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  _CommandTile(
                    label: 'Check daemon status:',
                    command: 'systemctl --user status skeys-daemon',
                  ),
                  const SizedBox(height: 8),
                  _CommandTile(
                    label: 'Restart daemon:',
                    command: 'systemctl --user restart skeys-daemon',
                  ),
                  const SizedBox(height: 8),
                  _CommandTile(
                    label: 'View logs:',
                    command: 'journalctl --user -u skeys-daemon -f',
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
            if (statusService.status != DaemonStatus.reconnecting)
              FilledButton.icon(
                onPressed: () async {
                  final success = await statusService.reconnect();
                  if (success && context.mounted) {
                    Navigator.of(context).pop();
                    AppToast.success(context, message: 'Reconnected to daemon');
                  }
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Reconnect'),
              )
            else
              const FilledButton(
                onPressed: null,
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _CommandTile extends StatelessWidget {
  final String label;
  final String command;

  const _CommandTile({
    required this.label,
    required this.command,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall,
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  command,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.copy, size: 16),
                tooltip: 'Copy to clipboard',
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: command));
                  AppToast.info(context, message: 'Copied: $command', duration: const Duration(seconds: 1));
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 24,
                  minHeight: 24,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
