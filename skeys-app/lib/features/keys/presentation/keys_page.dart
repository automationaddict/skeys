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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injection.dart';
import '../../../core/help/help_panel.dart';
import '../../../core/help/help_service.dart';
import '../../../core/notifications/app_toast.dart';
import '../../../core/widgets/app_bar_with_help.dart';
import '../../metadata/repository/metadata_repository.dart';
import '../bloc/keys_bloc.dart';
import '../domain/key_entity.dart';
import 'widgets/key_list_tile.dart';
import 'widgets/generate_key_dialog.dart';
import 'widgets/add_to_agent_dialog.dart';

/// Page displaying SSH keys.
class KeysPage extends StatefulWidget {
  /// Creates a KeysPage widget.
  const KeysPage({super.key});

  @override
  State<KeysPage> createState() => _KeysPageState();
}

class _KeysPageState extends State<KeysPage> {
  bool _showHelp = false;
  final _helpService = HelpService();

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.f1): () {
          setState(() => _showHelp = !_showHelp);
        },
      },
      child: Scaffold(
        appBar: AppBarWithHelp(
          title: 'SSH Keys',
          helpRoute: 'keys',
          onHelpPressed: () => setState(() => _showHelp = !_showHelp),
        ),
        body: Row(
          children: [
            Expanded(
              child: BlocConsumer<KeysBloc, KeysState>(
                listener: (context, state) {
                  if (state.copiedPublicKey != null) {
                    Clipboard.setData(
                      ClipboardData(text: state.copiedPublicKey!),
                    );
                    AppToast.success(
                      context,
                      message: 'Public key copied to clipboard',
                    );
                  }
                  if (state.status == KeysStatus.failure &&
                      state.errorMessage != null) {
                    AppToast.error(context, message: state.errorMessage!);
                  }
                  // Handle test connection result from immediate tests
                  if (state.testConnectionResult != null) {
                    final result = state.testConnectionResult!;
                    // Only show toast for immediate tests (not ones from dialog)
                    // The dialog handles its own toast
                    if (!result.needsHostKeyApproval &&
                        !result.hasHostKeyMismatch) {
                      AppToast.connectionResult(
                        context,
                        success: result.success,
                        message: result.message,
                        serverVersion: result.serverVersion,
                        latencyMs: result.latencyMs,
                      );
                      // Clear the result
                      context.read<KeysBloc>().add(
                        const KeysTestConnectionCleared(),
                      );
                    }
                  }
                },
                builder: (context, state) {
                  if (state.status == KeysStatus.loading &&
                      state.keys.isEmpty) {
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
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.keys.length,
                    itemBuilder: (context, index) {
                      final key = state.keys[index];
                      return KeyListTile(
                        keyEntity: key,
                        onCopyPublicKey: () {
                          context.read<KeysBloc>().add(
                            KeysCopyPublicKeyRequested(key.path),
                          );
                        },
                        onDelete: () => _confirmDelete(context, key),
                        onAddToAgent: () => _addToAgent(context, key),
                        // Only show Test Connection when key is in agent
                        onTestConnection: key.isInAgent
                            ? () => _testConnection(context, key)
                            : null,
                      );
                    },
                  );
                },
              ),
            ),
            if (_showHelp)
              HelpPanel(
                baseRoute: '/keys',
                helpService: _helpService,
                onClose: () => setState(() => _showHelp = false),
              ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showGenerateDialog(context),
          icon: const Icon(Icons.add),
          label: const Text('Generate Key'),
        ),
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
        content: Text(
          'Are you sure you want to delete "${key.name}"? This action cannot be undone.',
        ),
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
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<KeysBloc>(),
        child: AddToAgentDialog(keyEntity: key),
      ),
    );
  }

  /// Test connection immediately using stored metadata (no dialog).
  void _testConnection(BuildContext context, KeyEntity key) async {
    // Get stored metadata for this key
    final metadataRepo = getIt<MetadataRepository>();
    final metadata = await metadataRepo.getKeyMetadata(key.path);

    if (!context.mounted) return;

    if (metadata == null || metadata.verifiedHost == null) {
      AppToast.error(
        context,
        message:
            'No verified service found for this key. Re-add to agent to set up.',
      );
      return;
    }

    // Show testing toast
    AppToast.info(
      context,
      message:
          'Testing connection to ${metadata.verifiedService ?? metadata.verifiedHost}...',
    );

    // Test the connection
    context.read<KeysBloc>().add(
      KeysTestConnectionRequested(
        keyPath: key.path,
        host: metadata.verifiedHost!,
        port: metadata.verifiedPort ?? 22,
        user: metadata.verifiedUser ?? 'git',
        // No passphrase needed - key is already in agent
      ),
    );
  }
}
