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

import '../../../../core/di/injection.dart';
import '../../../agent/domain/agent_entity.dart';
import '../../../agent/repository/agent_repository.dart';

/// Result from the key selection dialog.
class SelectKeyResult {
  /// The selected key's fingerprint.
  final String fingerprint;

  /// The selected key's comment (usually the file path).
  final String comment;

  /// Creates a SelectKeyResult.
  const SelectKeyResult({required this.fingerprint, required this.comment});
}

/// Dialog for selecting a key from the agent to use for connection.
class SelectKeyDialog extends StatefulWidget {
  /// The name of the remote server being connected to.
  final String remoteName;

  /// Creates a SelectKeyDialog.
  const SelectKeyDialog({super.key, required this.remoteName});

  /// Shows the dialog and returns the selected key, or null if cancelled.
  static Future<SelectKeyResult?> show(
    BuildContext context, {
    required String remoteName,
  }) {
    return showDialog<SelectKeyResult>(
      context: context,
      builder: (context) => SelectKeyDialog(remoteName: remoteName),
    );
  }

  @override
  State<SelectKeyDialog> createState() => _SelectKeyDialogState();
}

class _SelectKeyDialogState extends State<SelectKeyDialog> {
  final AgentRepository _agentRepo = getIt<AgentRepository>();
  List<AgentKeyEntry>? _keys;
  String? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadKeys();
  }

  Future<void> _loadKeys() async {
    try {
      final keys = await _agentRepo.listKeys();
      if (mounted) {
        setState(() {
          _keys = keys;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Key for ${widget.remoteName}'),
      content: SizedBox(width: 450, height: 300, child: _buildContent()),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  Widget _buildContent() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load keys',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (_keys == null || _keys!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.vpn_key_off,
              size: 48,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'No keys loaded in agent',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Add a key from the Keys page first',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _keys!.length,
      itemBuilder: (context, index) {
        final key = _keys![index];
        return _KeyListTile(
          keyEntry: key,
          onTap: () {
            Navigator.pop(
              context,
              SelectKeyResult(
                fingerprint: key.fingerprint,
                comment: key.comment,
              ),
            );
          },
        );
      },
    );
  }
}

class _KeyListTile extends StatelessWidget {
  final AgentKeyEntry keyEntry;
  final VoidCallback onTap;

  const _KeyListTile({required this.keyEntry, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final hasLifetime = keyEntry.hasLifetime && keyEntry.lifetimeSeconds > 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.vpn_key,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        title: Text(
          keyEntry.comment.isNotEmpty ? keyEntry.comment : 'Unnamed key',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${keyEntry.type} ${keyEntry.bits} bits',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (hasLifetime)
              Text(
                'Expires in ${_formatDuration(keyEntry.lifetimeSeconds)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  String _formatDuration(int seconds) {
    if (seconds < 60) return '${seconds}s';
    if (seconds < 3600) return '${seconds ~/ 60}m';
    final hours = seconds ~/ 3600;
    final mins = (seconds % 3600) ~/ 60;
    return mins > 0 ? '${hours}h ${mins}m' : '${hours}h';
  }
}
