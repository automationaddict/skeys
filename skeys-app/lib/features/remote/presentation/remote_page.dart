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
import '../../../core/help/help_context_service.dart';
import '../../../core/help/help_panel.dart';
import '../../../core/help/help_service.dart';
import '../../../core/notifications/app_toast.dart';
import '../../../core/settings/settings_service.dart';
import '../../../core/widgets/app_bar_with_help.dart';
import '../../agent/domain/agent_entity.dart';
import '../../agent/repository/agent_repository.dart';
import '../../keys/repository/keys_repository.dart';
import '../bloc/remote_bloc.dart';
import '../domain/remote_entity.dart';

/// Page for remote server management.
class RemotePage extends StatefulWidget {
  /// Creates a RemotePage widget.
  const RemotePage({super.key});

  @override
  State<RemotePage> createState() => _RemotePageState();
}

class _RemotePageState extends State<RemotePage> {
  final _helpService = HelpService();
  final _helpContextService = getIt<HelpContextService>();

  @override
  void initState() {
    super.initState();
    // Load remotes on first visit (watch is auto-started by BLoC singleton)
    context.read<RemoteBloc>().add(const RemoteLoadRequested());
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _helpContextService,
      builder: (context, _) {
        return CallbackShortcuts(
          bindings: {
            const SingleActivator(LogicalKeyboardKey.f1):
                _helpContextService.toggleHelp,
          },
          child: Focus(
            autofocus: true,
            child: Scaffold(
              appBar: AppBarWithHelp(
                title: 'Remote Servers',
                helpRoute: 'remotes',
                onHelpPressed: _helpContextService.toggleHelp,
              ),
              body: Row(
                children: [
                  Expanded(
                    child: BlocConsumer<RemoteBloc, RemoteState>(
                      listener: (context, state) {
                        if (state.status == RemoteBlocStatus.failure &&
                            state.errorMessage != null) {
                          AppToast.error(
                            context,
                            title: 'Connection Failed',
                            message: state.errorMessage!,
                          );
                        }
                        // Show toast when a connection is unexpectedly dropped
                        if (state.droppedConnectionName != null) {
                          AppToast.warning(
                            context,
                            title: 'Connection Lost',
                            message:
                                'Connection to ${state.droppedConnectionName} was dropped',
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state.status == RemoteBlocStatus.loading &&
                            state.remotes.isEmpty) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (state.remotes.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.cloud_off,
                                  size: 64,
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No remote servers configured',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Add a remote server to get started',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.outline,
                                      ),
                                ),
                              ],
                            ),
                          );
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: state.remotes.length,
                          itemBuilder: (context, index) {
                            final remote = state.remotes[index];
                            final connection = state.connections
                                .where((c) => c.remoteId == remote.id)
                                .firstOrNull;
                            return _RemoteCard(
                              key: ValueKey(remote.id),
                              remote: remote,
                              connection: connection,
                            );
                          },
                        );
                      },
                    ),
                  ),
                  if (_helpContextService.isHelpVisible)
                    HelpPanel(
                      baseRoute: '/remotes',
                      helpService: _helpService,
                      onClose: _helpContextService.hideHelp,
                    ),
                ],
              ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () => _showAddDialog(context),
                icon: const Icon(Icons.add),
                label: const Text('Add Remote'),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showAddDialog(BuildContext context) {
    final nameController = TextEditingController();
    final hostController = TextEditingController();
    final portController = TextEditingController(text: '22');
    final userController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add Remote Server'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: hostController,
                decoration: const InputDecoration(labelText: 'Host'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: portController,
                decoration: const InputDecoration(labelText: 'Port'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: userController,
                decoration: const InputDecoration(labelText: 'User'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<RemoteBloc>().add(
                RemoteAddRequested(
                  name: nameController.text,
                  host: hostController.text,
                  port: int.tryParse(portController.text) ?? 22,
                  user: userController.text,
                ),
              );
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

class _RemoteCard extends StatefulWidget {
  final RemoteEntity remote;
  final ConnectionEntity? connection;

  const _RemoteCard({super.key, required this.remote, this.connection});

  @override
  State<_RemoteCard> createState() => _RemoteCardState();
}

class _RemoteCardState extends State<_RemoteCard> {
  final _agentRepository = getIt<AgentRepository>();
  final _keysRepository = getIt<KeysRepository>();
  final _settingsService = getIt<SettingsService>();

  List<AgentKeyEntry> _keys = [];
  AgentKeyEntry? _selectedKey;
  bool _isLoadingKeys = true;
  bool _isPushingKey = false;

  @override
  void initState() {
    super.initState();
    _loadKeys();
  }

  String? get _savedKeyFingerprint =>
      _settingsService.getRemoteKeyFingerprint(widget.remote.id);

  Future<void> _loadKeys() async {
    try {
      final keys = await _agentRepository.listKeys();
      if (mounted) {
        setState(() {
          _keys = keys;
          _isLoadingKeys = false;

          // Try to find the previously saved key for this remote
          final savedFingerprint = _savedKeyFingerprint;
          if (savedFingerprint != null && keys.isNotEmpty) {
            final savedKey = keys
                .where((k) => k.fingerprint == savedFingerprint)
                .firstOrNull;
            if (savedKey != null) {
              _selectedKey = savedKey;
              return;
            }
          }

          // Fall back to first key if none selected
          if (_selectedKey == null && keys.isNotEmpty) {
            _selectedKey = keys.first;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingKeys = false;
        });
      }
    }
  }

  Future<void> _onConnect() async {
    if (_selectedKey == null) {
      AppToast.warning(
        context,
        title: 'No Key Selected',
        message: 'Please select a key to connect with.',
      );
      return;
    }

    // Save the key selection for this remote
    await _settingsService.setRemoteKeyFingerprint(
      widget.remote.id,
      _selectedKey!.fingerprint,
    );

    if (!mounted) return;

    context.read<RemoteBloc>().add(
      RemoteConnectRequested(
        remoteId: widget.remote.id,
        keyFingerprint: _selectedKey!.fingerprint,
      ),
    );
  }

  Future<void> _onDisconnect() async {
    if (widget.connection == null) return;
    context.read<RemoteBloc>().add(
      RemoteDisconnectRequested(widget.connection!.id),
    );
  }

  Future<void> _onDelete() async {
    context.read<RemoteBloc>().add(RemoteDeleteRequested(widget.remote.id));
  }

  Future<void> _onPushKey() async {
    if (_selectedKey == null) {
      AppToast.warning(
        context,
        title: 'No Key Selected',
        message: 'Please select a key to push.',
      );
      return;
    }

    setState(() => _isPushingKey = true);

    try {
      final result = await _keysRepository.pushKeyToRemote(
        keyId: _selectedKey!.fingerprint,
        remoteId: widget.remote.id,
      );

      if (!mounted) return;

      if (result.success) {
        AppToast.success(
          context,
          title: 'Key Pushed',
          message: result.message.isNotEmpty
              ? result.message
              : 'Public key added to authorized_keys',
        );
      } else {
        AppToast.error(context, title: 'Push Failed', message: result.message);
      }
    } catch (e) {
      if (!mounted) return;
      AppToast.error(context, title: 'Push Failed', message: e.toString());
    } finally {
      if (mounted) {
        setState(() => _isPushingKey = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isConnected = widget.remote.status == RemoteStatus.connected;
    final isConnecting = widget.remote.status == RemoteStatus.connecting;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row with icon, name, and status
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isConnected
                        ? Colors.green.withValues(alpha: 0.2)
                        : Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    isConnected ? Icons.cloud_done : Icons.cloud_outlined,
                    color: isConnected ? Colors.green : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.remote.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        '${widget.remote.user}@${widget.remote.host}:${widget.remote.port}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(context),
              ],
            ),

            // Connection info when connected
            if (widget.connection != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Server: ${widget.connection!.serverVersion}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Key selection dropdown
            Row(
              children: [
                Expanded(
                  child: _isLoadingKeys
                      ? const LinearProgressIndicator()
                      : DropdownButtonFormField<AgentKeyEntry>(
                          // ignore: deprecated_member_use
                          value: _selectedKey,
                          decoration: InputDecoration(
                            labelText: 'SSH Key',
                            border: const OutlineInputBorder(),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            suffixIcon: _keys.isEmpty
                                ? Tooltip(
                                    message:
                                        'No keys in agent. Add keys via the Agent page.',
                                    child: Icon(
                                      Icons.warning_amber,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.error,
                                    ),
                                  )
                                : null,
                          ),
                          isExpanded: true,
                          items: _keys.map((key) {
                            final displayName = key.comment.isNotEmpty
                                ? key.comment
                                : key.fingerprint.substring(0, 16);
                            return DropdownMenuItem<AgentKeyEntry>(
                              value: key,
                              child: Text(
                                '$displayName (${key.type})',
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onChanged: (key) {
                            setState(() => _selectedKey = key);
                          },
                          hint: Text(
                            _keys.isEmpty ? 'No keys in agent' : 'Select a key',
                          ),
                        ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _loadKeys,
                  tooltip: 'Refresh keys',
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Push Key button (only when connected)
                if (isConnected)
                  OutlinedButton.icon(
                    onPressed: _isPushingKey ? null : _onPushKey,
                    icon: _isPushingKey
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.upload, size: 18),
                    label: const Text('Push Key'),
                  ),
                if (isConnected) const SizedBox(width: 8),

                // Connect/Disconnect button
                if (isConnected)
                  OutlinedButton(
                    onPressed: _onDisconnect,
                    child: const Text('Disconnect'),
                  )
                else
                  FilledButton(
                    onPressed: isConnecting || _keys.isEmpty
                        ? null
                        : _onConnect,
                    child: isConnecting
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Connect'),
                  ),

                const SizedBox(width: 8),

                // Delete button
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: _onDelete,
                  tooltip: 'Delete',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context) {
    final (label, color) = switch (widget.remote.status) {
      RemoteStatus.connected => ('Connected', Colors.green),
      RemoteStatus.connecting => ('Connecting', Colors.orange),
      RemoteStatus.error => ('Error', Colors.red),
      RemoteStatus.disconnected => ('Disconnected', Colors.grey),
    };

    return Chip(
      label: Text(label, style: TextStyle(color: color, fontSize: 12)),
      backgroundColor: color.withValues(alpha: 0.1),
      side: BorderSide.none,
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
    );
  }
}
