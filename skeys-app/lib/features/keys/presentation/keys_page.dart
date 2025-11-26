import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injection.dart';
import '../../../core/settings/settings_service.dart';
import '../../agent/bloc/agent_bloc.dart';
import '../../agent/service/agent_key_tracker.dart';
import '../bloc/keys_bloc.dart';
import '../domain/key_entity.dart';
import 'widgets/key_list_tile.dart';
import 'widgets/generate_key_dialog.dart';

/// Page displaying SSH keys.
class KeysPage extends StatefulWidget {
  const KeysPage({super.key});

  @override
  State<KeysPage> createState() => _KeysPageState();
}

class _KeysPageState extends State<KeysPage> {
  @override
  void initState() {
    super.initState();
    context.read<KeysBloc>().add(const KeysLoadRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SSH Keys'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<KeysBloc>().add(const KeysLoadRequested());
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: BlocConsumer<KeysBloc, KeysState>(
        listener: (context, state) {
          if (state.copiedPublicKey != null) {
            Clipboard.setData(ClipboardData(text: state.copiedPublicKey!));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Public key copied to clipboard')),
            );
          }
          if (state.status == KeysStatus.failure && state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == KeysStatus.loading && state.keys.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.keys.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.key_off,
                    size: 64,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No SSH keys found',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Generate a new key to get started',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<KeysBloc>().add(const KeysLoadRequested());
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.keys.length,
              itemBuilder: (context, index) {
                final key = state.keys[index];
                return KeyListTile(
                  keyEntity: key,
                  onCopyPublicKey: () {
                    context.read<KeysBloc>().add(KeysCopyPublicKeyRequested(key.path));
                  },
                  onDelete: () => _confirmDelete(context, key),
                  onAddToAgent: () => _addToAgent(context, key),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showGenerateDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Generate Key'),
      ),
    );
  }

  void _showGenerateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<KeysBloc>(),
        child: const GenerateKeyDialog(),
      ),
    );
  }

  void _confirmDelete(BuildContext context, KeyEntity key) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Key'),
        content: Text('Are you sure you want to delete "${key.name}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<KeysBloc>().add(KeysDeleteRequested(key.path));
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _addToAgent(BuildContext context, KeyEntity key) {
    final settingsService = getIt<SettingsService>();
    final timeoutMinutes = settingsService.agentKeyTimeoutMinutes;

    // Add the key to the agent
    context.read<AgentBloc>().add(AgentAddKeyRequested(keyPath: key.path));

    // Track the key for countdown display
    if (timeoutMinutes > 0) {
      final tracker = getIt<AgentKeyTracker>();
      tracker.keyAdded(key.fingerprint, timeoutMinutes * 60);
    }

    // Show feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Adding "${key.name}" to agent...'),
        duration: const Duration(seconds: 2),
      ),
    );

    // Reload keys to update isInAgent status
    Future.delayed(const Duration(milliseconds: 500), () {
      if (context.mounted) {
        context.read<KeysBloc>().add(const KeysLoadRequested());
      }
    });
  }
}
