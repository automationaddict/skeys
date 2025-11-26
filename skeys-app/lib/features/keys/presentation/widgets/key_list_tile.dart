import 'package:flutter/material.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/settings/settings_service.dart';
import '../../domain/key_entity.dart';

/// List tile widget for displaying an SSH key.
class KeyListTile extends StatefulWidget {
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
  State<KeyListTile> createState() => _KeyListTileState();
}

class _KeyListTileState extends State<KeyListTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = getIt<SettingsService>();
    final expirationStatus = settings.getKeyExpirationStatus(widget.keyEntity.createdAt);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: _buildKeyIcon(context),
        title: Text(
          widget.keyEntity.name,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              '${_keyTypeLabel(widget.keyEntity.type)} ${widget.keyEntity.bits > 0 ? "(${widget.keyEntity.bits} bits)" : ""}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 2),
            Text(
              widget.keyEntity.fingerprint,
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
            _buildExpirationIndicator(context, expirationStatus, settings),
            if (widget.keyEntity.isInAgent)
              Tooltip(
                message: 'Loaded in agent',
                child: Icon(
                  Icons.security,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            Tooltip(
              message: widget.keyEntity.hasPassphrase
                  ? 'Passphrase protected'
                  : 'No passphrase (insecure)',
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Icon(
                  widget.keyEntity.hasPassphrase ? Icons.lock : Icons.lock_open,
                  size: 20,
                  color: widget.keyEntity.hasPassphrase
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
                    widget.onCopyPublicKey();
                    break;
                  case 'delete':
                    widget.onDelete();
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

  Widget _buildExpirationIndicator(
    BuildContext context,
    KeyExpirationStatus status,
    SettingsService settings,
  ) {
    if (status == KeyExpirationStatus.ok) {
      return const SizedBox.shrink();
    }

    final keyAge = DateTime.now().difference(widget.keyEntity.createdAt).inDays;

    if (status == KeyExpirationStatus.critical) {
      return Tooltip(
        message: 'Key is $keyAge days old - rotation strongly recommended!\n'
            '(Critical threshold: ${settings.keyExpirationCriticalDays} days)',
        child: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: _pulseAnimation.value,
                child: const Icon(
                  Icons.error,
                  size: 20,
                  color: Colors.red,
                ),
              );
            },
          ),
        ),
      );
    }

    // Warning status
    return Tooltip(
      message: 'Key is $keyAge days old - consider rotating\n'
          '(Warning threshold: ${settings.keyExpirationWarningDays} days)',
      child: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Icon(
          Icons.warning_amber,
          size: 20,
          color: Colors.orange.shade700,
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
