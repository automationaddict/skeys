import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/remote_bloc.dart';
import '../domain/remote_entity.dart';

/// Page for remote server management.
class RemotePage extends StatefulWidget {
  const RemotePage({super.key});

  @override
  State<RemotePage> createState() => _RemotePageState();
}

class _RemotePageState extends State<RemotePage> {
  @override
  void initState() {
    super.initState();
    context.read<RemoteBloc>().add(const RemoteLoadRequested());
    context.read<RemoteBloc>().add(const RemoteWatchConnectionsRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Remote Servers'),
      ),
      body: BlocBuilder<RemoteBloc, RemoteState>(
        builder: (context, state) {
          if (state.status == RemoteBlocStatus.loading && state.remotes.isEmpty) {
            return const Center(child: CircularProgressIndicator());
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
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
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
              final connection = state.connections.where((c) => c.remoteId == remote.id).firstOrNull;
              return _RemoteCard(
                remote: remote,
                connection: connection,
                onConnect: () {
                  context.read<RemoteBloc>().add(RemoteConnectRequested(remoteId: remote.id));
                },
                onDisconnect: connection != null
                    ? () {
                        context.read<RemoteBloc>().add(RemoteDisconnectRequested(connection.id));
                      }
                    : null,
                onDelete: () {
                  context.read<RemoteBloc>().add(RemoteDeleteRequested(remote.id));
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Remote'),
      ),
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
              context.read<RemoteBloc>().add(RemoteAddRequested(
                    name: nameController.text,
                    host: hostController.text,
                    port: int.tryParse(portController.text) ?? 22,
                    user: userController.text,
                  ));
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

class _RemoteCard extends StatelessWidget {
  final RemoteEntity remote;
  final ConnectionEntity? connection;
  final VoidCallback onConnect;
  final VoidCallback? onDisconnect;
  final VoidCallback onDelete;

  const _RemoteCard({
    required this.remote,
    this.connection,
    required this.onConnect,
    this.onDisconnect,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isConnected = remote.status == RemoteStatus.connected;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isConnected
                        ? Colors.green.withOpacity(0.2)
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
                        remote.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        '${remote.user}@${remote.host}:${remote.port}',
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
            if (connection != null) ...[
              const SizedBox(height: 12),
              Text(
                'Server: ${connection!.serverVersion}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (isConnected && onDisconnect != null)
                  OutlinedButton(
                    onPressed: onDisconnect,
                    child: const Text('Disconnect'),
                  )
                else
                  FilledButton(
                    onPressed: onConnect,
                    child: const Text('Connect'),
                  ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: onDelete,
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
    final (label, color) = switch (remote.status) {
      RemoteStatus.connected => ('Connected', Colors.green),
      RemoteStatus.connecting => ('Connecting', Colors.orange),
      RemoteStatus.error => ('Error', Colors.red),
      RemoteStatus.disconnected => ('Disconnected', Colors.grey),
    };

    return Chip(
      label: Text(
        label,
        style: TextStyle(color: color, fontSize: 12),
      ),
      backgroundColor: color.withOpacity(0.1),
      side: BorderSide.none,
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
    );
  }
}
