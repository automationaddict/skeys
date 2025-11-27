import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

import '../notifications/app_toast.dart';
import 'backup_service.dart';

/// Dialog for importing SSH configuration backup.
class ImportDialog extends StatefulWidget {
  const ImportDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => const ImportDialog(),
    );
  }

  @override
  State<ImportDialog> createState() => _ImportDialogState();
}

class _ImportDialogState extends State<ImportDialog> {
  final _passphraseController = TextEditingController();

  String? _selectedFile;
  BackupContents? _contents;
  bool _obscurePassphrase = true;
  bool _isLoading = false;
  bool _isRestoring = false;
  bool _overwriteExisting = false;
  String? _error;

  // Restore options
  bool _restoreKeys = true;
  bool _restoreConfig = true;
  bool _restoreKnownHosts = true;
  bool _restoreAuthorizedKeys = true;

  @override
  void dispose() {
    _passphraseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.download, color: colorScheme.primary),
          const SizedBox(width: 12),
          const Text('Import Backup'),
        ],
      ),
      content: SizedBox(
        width: 500,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // File selection
              _buildFileSelection(theme, colorScheme),

              if (_selectedFile != null) ...[
                const SizedBox(height: 24),

                // Passphrase entry
                _buildPassphraseSection(theme, colorScheme),

                if (_contents != null) ...[
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),

                  // Backup contents preview
                  _buildContentsPreview(theme, colorScheme),

                  const SizedBox(height: 24),

                  // Restore options
                  _buildRestoreOptions(theme, colorScheme),
                ],
              ],

              if (_error != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: colorScheme.error),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _error!,
                          style: TextStyle(color: colorScheme.onErrorContainer),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isRestoring ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        if (_contents != null)
          FilledButton.icon(
            onPressed: _isRestoring || !_hasRestoreSelection ? null : _restore,
            icon: _isRestoring
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colorScheme.onPrimary,
                    ),
                  )
                : const Icon(Icons.restore),
            label: Text(_isRestoring ? 'Restoring...' : 'Restore'),
          ),
      ],
    );
  }

  Widget _buildFileSelection(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Backup File:',
          style: theme.textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _selectFile,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: colorScheme.outline),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  _selectedFile != null ? Icons.description : Icons.folder_open,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _selectedFile != null
                        ? p.basename(_selectedFile!)
                        : 'Click to select a .skbak file',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: _selectedFile != null
                          ? colorScheme.onSurface
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPassphraseSection(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Passphrase:',
          style: theme.textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _passphraseController,
                obscureText: _obscurePassphrase,
                decoration: InputDecoration(
                  hintText: 'Enter backup passphrase',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassphrase
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassphrase = !_obscurePassphrase),
                  ),
                  border: const OutlineInputBorder(),
                ),
                onSubmitted: (_) => _decryptAndAnalyze(),
              ),
            ),
            const SizedBox(width: 8),
            FilledButton.tonal(
              onPressed: _isLoading ? null : _decryptAndAnalyze,
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Unlock'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContentsPreview(ThemeData theme, ColorScheme colorScheme) {
    final contents = _contents!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.check_circle, color: colorScheme.primary, size: 20),
            const SizedBox(width: 8),
            Text(
              'Backup Verified',
              style: theme.textTheme.titleSmall?.copyWith(
                color: colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Metadata
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              if (contents.hostname != null)
                _buildMetaRow('Source', contents.hostname!, Icons.computer),
              if (contents.createdAt != null)
                _buildMetaRow(
                  'Created',
                  _formatDate(contents.createdAt!),
                  Icons.schedule,
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Contents summary
        Text(
          'Contents:',
          style: theme.textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            if (contents.keyCount > 0)
              _buildChip(
                '${contents.keyCount} key${contents.keyCount == 1 ? '' : 's'}',
                Icons.key,
                colorScheme,
              ),
            if (contents.hasConfig)
              _buildChip('SSH Config', Icons.tune, colorScheme),
            if (contents.hasKnownHosts)
              _buildChip('Known Hosts', Icons.dns, colorScheme),
            if (contents.hasAuthorizedKeys)
              _buildChip('Authorized Keys', Icons.verified_user, colorScheme),
          ],
        ),
      ],
    );
  }

  Widget _buildMetaRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Text('$label: '),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildChip(String label, IconData icon, ColorScheme colorScheme) {
    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(label),
      backgroundColor: colorScheme.surfaceContainerHigh,
    );
  }

  Widget _buildRestoreOptions(ThemeData theme, ColorScheme colorScheme) {
    final contents = _contents!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Restore options:',
          style: theme.textTheme.titleSmall,
        ),
        const SizedBox(height: 8),

        if (contents.keyCount > 0)
          CheckboxListTile(
            value: _restoreKeys,
            onChanged: (v) => setState(() => _restoreKeys = v ?? true),
            title: Row(
              children: [
                const Icon(Icons.key, size: 20),
                const SizedBox(width: 8),
                Text('SSH Keys (${contents.keyCount})'),
              ],
            ),
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),

        if (contents.hasConfig)
          CheckboxListTile(
            value: _restoreConfig,
            onChanged: (v) => setState(() => _restoreConfig = v ?? true),
            title: const Row(
              children: [
                Icon(Icons.tune, size: 20),
                SizedBox(width: 8),
                Text('SSH Config'),
              ],
            ),
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),

        if (contents.hasKnownHosts)
          CheckboxListTile(
            value: _restoreKnownHosts,
            onChanged: (v) => setState(() => _restoreKnownHosts = v ?? true),
            title: const Row(
              children: [
                Icon(Icons.dns, size: 20),
                SizedBox(width: 8),
                Text('Known Hosts'),
              ],
            ),
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),

        if (contents.hasAuthorizedKeys)
          CheckboxListTile(
            value: _restoreAuthorizedKeys,
            onChanged: (v) => setState(() => _restoreAuthorizedKeys = v ?? true),
            title: const Row(
              children: [
                Icon(Icons.verified_user, size: 20),
                SizedBox(width: 8),
                Text('Authorized Keys'),
              ],
            ),
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),

        const SizedBox(height: 8),
        const Divider(),
        const SizedBox(height: 8),

        SwitchListTile(
          value: _overwriteExisting,
          onChanged: (v) => setState(() => _overwriteExisting = v),
          title: const Text('Overwrite existing files'),
          subtitle: Text(
            _overwriteExisting
                ? 'Existing files will be replaced'
                : 'Existing files will be skipped',
            style: theme.textTheme.bodySmall,
          ),
          dense: true,
          contentPadding: EdgeInsets.zero,
        ),

        if (_overwriteExisting) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.errorContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.warning_amber, color: colorScheme.error, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Existing keys and configuration will be overwritten!',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.error,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  bool get _hasRestoreSelection {
    final c = _contents;
    if (c == null) return false;
    return (_restoreKeys && c.keyCount > 0) ||
        (_restoreConfig && c.hasConfig) ||
        (_restoreKnownHosts && c.hasKnownHosts) ||
        (_restoreAuthorizedKeys && c.hasAuthorizedKeys);
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      dialogTitle: 'Select Backup File',
      type: FileType.custom,
      allowedExtensions: ['skbak'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFile = result.files.single.path;
        _contents = null;
        _error = null;
      });
    }
  }

  Future<void> _decryptAndAnalyze() async {
    if (_selectedFile == null || _passphraseController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _error = null;
      _contents = null;
    });

    try {
      final data = await File(_selectedFile!).readAsBytes();
      final service = BackupService();
      final contents = await service.analyzeBackup(
        data: data,
        passphrase: _passphraseController.text,
      );

      setState(() {
        _contents = contents;
        _restoreKeys = contents.keyCount > 0;
        _restoreConfig = contents.hasConfig;
        _restoreKnownHosts = contents.hasKnownHosts;
        _restoreAuthorizedKeys = contents.hasAuthorizedKeys;
      });
    } catch (e) {
      setState(() {
        _error = e.toString().contains('Decryption failed')
            ? 'Incorrect passphrase'
            : e.toString();
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _restore() async {
    if (_selectedFile == null || _contents == null) return;

    setState(() {
      _isRestoring = true;
      _error = null;
    });

    try {
      final data = await File(_selectedFile!).readAsBytes();
      final service = BackupService();

      final filter = BackupOptions(
        includeKeys: _restoreKeys,
        includeConfig: _restoreConfig,
        includeKnownHosts: _restoreKnownHosts,
        includeAuthorizedKeys: _restoreAuthorizedKeys,
      );

      final result = await service.restoreBackup(
        data: data,
        passphrase: _passphraseController.text,
        overwriteExisting: _overwriteExisting,
        filter: filter,
      );

      if (mounted) {
        Navigator.of(context).pop();
        _showResultToast(context, result);
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() => _isRestoring = false);
    }
  }

  void _showResultToast(BuildContext context, RestoreResult result) {
    final message = StringBuffer();

    if (result.restored.isNotEmpty) {
      message.write('Restored ${result.restored.length} file(s)');
    }
    if (result.skipped.isNotEmpty) {
      if (message.isNotEmpty) message.write(', ');
      message.write('skipped ${result.skipped.length}');
    }
    if (result.errors.isNotEmpty) {
      if (message.isNotEmpty) message.write(', ');
      message.write('${result.errors.length} error(s)');
    }

    if (result.hasErrors) {
      AppToast.warning(context, message: message.toString());
    } else {
      AppToast.success(context, message: message.toString());
    }
  }
}
