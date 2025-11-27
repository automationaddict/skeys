import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/notifications/app_toast.dart';
import '../../../../core/settings/settings_service.dart';
import '../../domain/key_entity.dart';

/// List tile widget for displaying an SSH key.
class KeyListTile extends StatefulWidget {
  final KeyEntity keyEntity;
  final VoidCallback onCopyPublicKey;
  final VoidCallback onDelete;
  final VoidCallback? onAddToAgent;
  final VoidCallback? onTestConnection;

  const KeyListTile({
    super.key,
    required this.keyEntity,
    required this.onCopyPublicKey,
    required this.onDelete,
    this.onAddToAgent,
    this.onTestConnection,
  });

  @override
  State<KeyListTile> createState() => _KeyListTileState();
}

class _KeyListTileState extends State<KeyListTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _isExpanded = false;

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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final settings = getIt<SettingsService>();
    final expirationStatus = settings.getKeyExpirationStatus(widget.keyEntity.createdAt);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: _buildKeyIcon(context),
            title: Text(
              widget.keyEntity.name,
              style: theme.textTheme.titleMedium,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  '${_keyTypeLabel(widget.keyEntity.type)} ${widget.keyEntity.bits > 0 ? "(${widget.keyEntity.bits} bits)" : ""}',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 2),
                Text(
                  widget.keyEntity.fingerprint,
                  style: theme.textTheme.bodySmall?.copyWith(
                        fontFamily: 'monospace',
                        color: colorScheme.outline,
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
                      color: colorScheme.primary,
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
                IconButton(
                  icon: AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(Icons.expand_more),
                  ),
                  onPressed: () => setState(() => _isExpanded = !_isExpanded),
                  tooltip: _isExpanded ? 'Hide key' : 'Show key',
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'copy':
                        widget.onCopyPublicKey();
                        break;
                      case 'add_to_agent':
                        widget.onAddToAgent?.call();
                        break;
                      case 'test_connection':
                        widget.onTestConnection?.call();
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
                    if (!widget.keyEntity.isInAgent && widget.onAddToAgent != null)
                      const PopupMenuItem(
                        value: 'add_to_agent',
                        child: ListTile(
                          leading: Icon(Icons.add_circle_outline),
                          title: Text('Add to Agent'),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    if (widget.onTestConnection != null)
                      const PopupMenuItem(
                        value: 'test_connection',
                        child: ListTile(
                          leading: Icon(Icons.wifi_tethering),
                          title: Text('Test Connection'),
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
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'Public Key',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.copy, size: 18),
                        onPressed: () => _copyPublicKey(context),
                        tooltip: 'Copy public key',
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SelectableText(
                      widget.keyEntity.publicKey,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontFamily: 'monospace',
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }

  void _copyPublicKey(BuildContext context) {
    Clipboard.setData(ClipboardData(text: widget.keyEntity.publicKey));
    AppToast.success(context, message: 'Public key copied to clipboard');
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
