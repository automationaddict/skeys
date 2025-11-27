import 'package:flutter/material.dart';

import '../../../../core/di/injection.dart';
import '../../../keys/domain/key_entity.dart';
import '../../../keys/repository/keys_repository.dart';

/// Dialog for selecting an SSH key for IdentityFile configuration.
class KeyPickerDialog extends StatefulWidget {
  const KeyPickerDialog({super.key});

  @override
  State<KeyPickerDialog> createState() => _KeyPickerDialogState();
}

class _KeyPickerDialogState extends State<KeyPickerDialog> {
  late Future<List<KeyEntity>> _keysFuture;
  String? _selectedPath;

  @override
  void initState() {
    super.initState();
    _loadKeys();
  }

  void _loadKeys() {
    final repository = getIt<KeysRepository>();
    _keysFuture = repository.listKeys();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.key,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Select SSH Key',
                    style: theme.textTheme.titleLarge,
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            // Content
            Flexible(
              child: FutureBuilder<List<KeyEntity>>(
                future: _keysFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 48,
                              color: colorScheme.error,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Failed to load keys',
                              style: theme.textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${snapshot.error}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            FilledButton.tonal(
                              onPressed: () {
                                setState(() => _loadKeys());
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final keys = snapshot.data ?? [];

                  if (keys.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.vpn_key_off_outlined,
                              size: 48,
                              color: colorScheme.outline,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No SSH keys found',
                              style: theme.textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Generate or import keys from the Keys page',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: keys.length,
                    itemBuilder: (context, index) {
                      final key = keys[index];
                      return _KeyListTile(
                        key: ValueKey(key.path),
                        keyEntity: key,
                        isSelected: _selectedPath == key.path,
                        onTap: () {
                          setState(() => _selectedPath = key.path);
                        },
                        onDoubleTap: () {
                          Navigator.of(context).pop(key.path);
                        },
                      );
                    },
                  );
                },
              ),
            ),
            // Actions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: colorScheme.outlineVariant),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  FilledButton(
                    onPressed: _selectedPath != null
                        ? () => Navigator.of(context).pop(_selectedPath)
                        : null,
                    child: const Text('Select'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// List tile for displaying a key in the picker.
class _KeyListTile extends StatelessWidget {
  final KeyEntity keyEntity;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onDoubleTap;

  const _KeyListTile({
    super.key,
    required this.keyEntity,
    required this.isSelected,
    required this.onTap,
    required this.onDoubleTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: isSelected ? colorScheme.primaryContainer.withValues(alpha: 0.3) : null,
        child: Row(
          children: [
            // Selection indicator
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? colorScheme.primary : colorScheme.outline,
                  width: isSelected ? 2 : 1,
                ),
                color: isSelected ? colorScheme.primary : null,
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      size: 16,
                      color: colorScheme.onPrimary,
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            // Key type icon
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _getKeyTypeColor(keyEntity.type, colorScheme).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getKeyTypeIcon(keyEntity.type),
                color: _getKeyTypeColor(keyEntity.type, colorScheme),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            // Key info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    keyEntity.name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${_getKeyTypeName(keyEntity.type)} ${keyEntity.bits > 0 ? '(${keyEntity.bits} bits)' : ''}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    keyEntity.path,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.outline,
                      fontFamily: 'monospace',
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Status indicators
            if (keyEntity.hasPassphrase)
              Tooltip(
                message: 'Passphrase protected',
                child: Icon(
                  Icons.lock,
                  size: 16,
                  color: colorScheme.outline,
                ),
              ),
            if (keyEntity.isInAgent) ...[
              const SizedBox(width: 8),
              Tooltip(
                message: 'Loaded in agent',
                child: Icon(
                  Icons.check_circle,
                  size: 16,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getKeyTypeIcon(KeyType type) {
    switch (type) {
      case KeyType.ed25519:
      case KeyType.ed25519Sk:
        return Icons.vpn_key;
      case KeyType.rsa:
        return Icons.key;
      case KeyType.ecdsa:
      case KeyType.ecdsaSk:
        return Icons.security;
      case KeyType.unknown:
        return Icons.help_outline;
    }
  }

  Color _getKeyTypeColor(KeyType type, ColorScheme colorScheme) {
    switch (type) {
      case KeyType.ed25519:
      case KeyType.ed25519Sk:
        return colorScheme.primary;
      case KeyType.rsa:
        return colorScheme.tertiary;
      case KeyType.ecdsa:
      case KeyType.ecdsaSk:
        return colorScheme.secondary;
      case KeyType.unknown:
        return colorScheme.outline;
    }
  }

  String _getKeyTypeName(KeyType type) {
    switch (type) {
      case KeyType.ed25519:
        return 'ED25519';
      case KeyType.ed25519Sk:
        return 'ED25519-SK';
      case KeyType.rsa:
        return 'RSA';
      case KeyType.ecdsa:
        return 'ECDSA';
      case KeyType.ecdsaSk:
        return 'ECDSA-SK';
      case KeyType.unknown:
        return 'Unknown';
    }
  }
}
