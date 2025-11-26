import 'package:flutter/material.dart';

import '../../domain/key_entity.dart';

/// List tile widget for displaying an SSH key.
class KeyListTile extends StatelessWidget {
  final KeyEntity keyEntity;
  final VoidCallback onCopyPublicKey;
  final VoidCallback onDelete;

  const KeyListTile({
    super.key,
    required this.keyEntity,
    required this.onCopyPublicKey,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: _buildKeyIcon(context),
        title: Text(
          keyEntity.name,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              '${_keyTypeLabel(keyEntity.type)} ${keyEntity.bits > 0 ? "(${keyEntity.bits} bits)" : ""}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 2),
            Text(
              keyEntity.fingerprint,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontFamily: 'monospace',
                    color: Theme.of(context).colorScheme.outline,
                  ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (keyEntity.isInAgent)
              Tooltip(
                message: 'Loaded in agent',
                child: Icon(
                  Icons.security,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            Tooltip(
              message: keyEntity.hasPassphrase
                  ? 'Passphrase protected'
                  : 'No passphrase (insecure)',
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Icon(
                  keyEntity.hasPassphrase ? Icons.lock : Icons.lock_open,
                  size: 20,
                  color: keyEntity.hasPassphrase
                      ? Colors.green
                      : Colors.orange,
                ),
              ),
            ),
            const SizedBox(width: 8),
            PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'copy':
                    onCopyPublicKey();
                    break;
                  case 'delete':
                    onDelete();
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'copy',
                  child: ListTile(
                    leading: Icon(Icons.copy),
                    title: Text('Copy Public Key'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: ListTile(
                    leading: Icon(Icons.delete, color: Colors.red),
                    title: Text('Delete', style: TextStyle(color: Colors.red)),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeyIcon(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.key,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  String _keyTypeLabel(KeyType type) {
    switch (type) {
      case KeyType.rsa:
        return 'RSA';
      case KeyType.ed25519:
        return 'ED25519';
      case KeyType.ecdsa:
        return 'ECDSA';
      case KeyType.ed25519Sk:
        return 'ED25519-SK';
      case KeyType.ecdsaSk:
        return 'ECDSA-SK';
      case KeyType.unknown:
        return 'Unknown';
    }
  }
}
