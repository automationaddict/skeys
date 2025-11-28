import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injection.dart';
import '../../../core/settings/settings_service.dart';
import '../bloc/agent_bloc.dart';
import 'key_countdown_widget.dart';

/// Page for SSH agent management.
class AgentPage extends StatefulWidget {
  const AgentPage({super.key});

  @override
  State<AgentPage> createState() => _AgentPageState();
}

class _AgentPageState extends State<AgentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SSH Agent'),
      ),
      body: BlocBuilder<AgentBloc, AgentState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatusCard(context, state),
                const SizedBox(height: 24),
                _buildActionsCard(context, state),
                const SizedBox(height: 24),
                _buildKeysSection(context, state),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context, AgentState state) {
    final agentStatus = state.agentStatus;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Agent Status',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            if (agentStatus == null)
              const Center(child: CircularProgressIndicator())
            else ...[
              _buildStatusRow(
                context,
                'Status',
                agentStatus.isRunning ? 'Running' : 'Not Running',
                agentStatus.isRunning ? Colors.green : Colors.red,
              ),
              const SizedBox(height: 8),
              _buildStatusRow(
                context,
                'Locked',
                agentStatus.isLocked ? 'Yes' : 'No',
                agentStatus.isLocked ? Colors.orange : Colors.green,
              ),
              const SizedBox(height: 8),
              _buildStatusRow(
                context,
                'Keys Loaded',
                '${agentStatus.keyCount}',
                null,
              ),
              const SizedBox(height: 8),
              Text(
                'Socket: ${agentStatus.socketPath}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontFamily: 'monospace',
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(BuildContext context, String label, String value, Color? valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  Widget _buildActionsCard(BuildContext context, AgentState state) {
    final isLocked = state.agentStatus?.isLocked ?? false;
    final settingsService = getIt<SettingsService>();

    return ListenableBuilder(
      listenable: settingsService,
      builder: (context, _) {
        final timeoutMinutes = settingsService.agentKeyTimeoutMinutes;
        final timeoutText = timeoutMinutes == 0
            ? 'No timeout'
            : timeoutMinutes >= 60
                ? '${timeoutMinutes ~/ 60}h ${timeoutMinutes % 60}m'
                : '$timeoutMinutes min';

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Actions',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Spacer(),
                    Icon(
                      Icons.timer_outlined,
                      size: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Timeout: $timeoutText',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (isLocked)
                      OutlinedButton.icon(
                        onPressed: () => _showUnlockDialog(context),
                        icon: const Icon(Icons.lock_open),
                        label: const Text('Unlock'),
                      )
                    else
                      OutlinedButton.icon(
                        onPressed: () => _showLockDialog(context),
                        icon: const Icon(Icons.lock),
                        label: const Text('Lock'),
                      ),
                    OutlinedButton.icon(
                      onPressed: state.loadedKeys.isNotEmpty
                          ? () => _confirmRemoveAll(context)
                          : null,
                      icon: const Icon(Icons.clear_all),
                      label: const Text('Remove All Keys'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildKeysSection(BuildContext context, AgentState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Loaded Keys',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        if (state.loadedKeys.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.key_off,
                      size: 48,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No keys loaded',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          ...state.loadedKeys.map((key) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.key),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    key.comment.isNotEmpty ? key.comment : 'No comment',
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ),
                                KeyCountdownWidget(
                                  hasLifetime: key.hasLifetime,
                                  lifetimeSeconds: key.lifetimeSeconds,
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${key.type} (${key.bits} bits)',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              key.fingerprint,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontFamily: 'monospace',
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () {
                          context.read<AgentBloc>().add(AgentRemoveKeyRequested(key.fingerprint));
                        },
                      ),
                    ],
                  ),
                ),
              )),
      ],
    );
  }

  void _showLockDialog(BuildContext context) {
    final controller = TextEditingController();
    void submit() {
      Navigator.pop(context);
      context.read<AgentBloc>().add(AgentLockRequested(controller.text));
    }
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Lock Agent'),
        content: TextField(
          controller: controller,
          obscureText: true,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Passphrase'),
          onSubmitted: (_) => submit(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: submit,
            child: const Text('Lock'),
          ),
        ],
      ),
    );
  }

  void _showUnlockDialog(BuildContext context) {
    final controller = TextEditingController();
    void submit() {
      Navigator.pop(context);
      context.read<AgentBloc>().add(AgentUnlockRequested(controller.text));
    }
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Unlock Agent'),
        content: TextField(
          controller: controller,
          obscureText: true,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Passphrase'),
          onSubmitted: (_) => submit(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: submit,
            child: const Text('Unlock'),
          ),
        ],
      ),
    );
  }

  void _confirmRemoveAll(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Remove All Keys'),
        content: const Text('Are you sure you want to remove all keys from the agent?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<AgentBloc>().add(const AgentRemoveAllKeysRequested());
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Remove All'),
          ),
        ],
      ),
    );
  }
}
