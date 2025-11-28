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

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

import '../notifications/app_toast.dart';
import 'backup_service.dart';

/// Dialog for exporting SSH configuration backup.
class ExportDialog extends StatefulWidget {
  const ExportDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => const ExportDialog(),
    );
  }

  @override
  State<ExportDialog> createState() => _ExportDialogState();
}

class _ExportDialogState extends State<ExportDialog> {
  final _passphraseController = TextEditingController();
  final _confirmController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _includeKeys = true;
  bool _includeConfig = true;
  bool _includeKnownHosts = true;
  bool _includeAuthorizedKeys = false;
  bool _obscurePassphrase = true;
  bool _isExporting = false;
  String? _error;

  @override
  void dispose() {
    _passphraseController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.upload_file, color: colorScheme.primary),
          const SizedBox(width: 12),
          const Text('Export Backup'),
        ],
      ),
      content: SizedBox(
        width: 450,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Warning banner
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.errorContainer.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: colorScheme.error.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning_amber, color: colorScheme.error),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'This backup will contain sensitive private keys. '
                          'Store it securely and use a strong passphrase.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onErrorContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Include options
                Text('Include in backup:', style: theme.textTheme.titleSmall),
                const SizedBox(height: 8),
                _buildCheckbox(
                  'SSH Keys',
                  'Private and public key pairs',
                  _includeKeys,
                  (v) => setState(() => _includeKeys = v ?? true),
                  Icons.key,
                ),
                _buildCheckbox(
                  'SSH Config',
                  'Host aliases and connection settings',
                  _includeConfig,
                  (v) => setState(() => _includeConfig = v ?? true),
                  Icons.tune,
                ),
                _buildCheckbox(
                  'Known Hosts',
                  'Trusted server fingerprints',
                  _includeKnownHosts,
                  (v) => setState(() => _includeKnownHosts = v ?? true),
                  Icons.dns,
                ),
                _buildCheckbox(
                  'Authorized Keys',
                  'Keys allowed to access this machine',
                  _includeAuthorizedKeys,
                  (v) => setState(() => _includeAuthorizedKeys = v ?? false),
                  Icons.verified_user,
                ),

                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),

                // Passphrase
                Text(
                  'Encryption Passphrase:',
                  style: theme.textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  'Required to decrypt the backup on another machine',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _passphraseController,
                  obscureText: _obscurePassphrase,
                  decoration: InputDecoration(
                    labelText: 'Passphrase',
                    hintText: 'Enter a strong passphrase',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassphrase
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () => setState(
                        () => _obscurePassphrase = !_obscurePassphrase,
                      ),
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Passphrase is required';
                    }
                    if (value.length < 8) {
                      return 'Passphrase must be at least 8 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _confirmController,
                  obscureText: _obscurePassphrase,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Passphrase',
                    hintText: 'Re-enter passphrase',
                    prefixIcon: Icon(Icons.lock_outline),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value != _passphraseController.text) {
                      return 'Passphrases do not match';
                    }
                    return null;
                  },
                ),

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
                            style: TextStyle(
                              color: colorScheme.onErrorContainer,
                            ),
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
      ),
      actions: [
        TextButton(
          onPressed: _isExporting ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          autofocus: true,
          onPressed: _isExporting || !_hasSelection ? null : _export,
          icon: _isExporting
              ? SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: colorScheme.onPrimary,
                  ),
                )
              : const Icon(Icons.download),
          label: Text(_isExporting ? 'Exporting...' : 'Export'),
        ),
      ],
    );
  }

  bool get _hasSelection =>
      _includeKeys ||
      _includeConfig ||
      _includeKnownHosts ||
      _includeAuthorizedKeys;

  Widget _buildCheckbox(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool?> onChanged,
    IconData icon,
  ) {
    return CheckboxListTile(
      value: value,
      onChanged: onChanged,
      title: Row(
        children: [Icon(icon, size: 20), const SizedBox(width: 8), Text(title)],
      ),
      subtitle: Text(subtitle),
      dense: true,
      contentPadding: EdgeInsets.zero,
    );
  }

  Future<void> _export() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isExporting = true;
      _error = null;
    });

    try {
      final service = BackupService();
      final options = BackupOptions(
        includeKeys: _includeKeys,
        includeConfig: _includeConfig,
        includeKnownHosts: _includeKnownHosts,
        includeAuthorizedKeys: _includeAuthorizedKeys,
      );

      final data = await service.createBackup(
        passphrase: _passphraseController.text,
        options: options,
      );

      // Pick save location
      final timestamp = DateTime.now()
          .toIso8601String()
          .replaceAll(':', '-')
          .split('.')
          .first;
      final defaultName = 'skeys-backup-$timestamp.skbak';

      final savePath = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Backup',
        fileName: defaultName,
        type: FileType.custom,
        allowedExtensions: ['skbak'],
      );

      if (savePath == null) {
        setState(() => _isExporting = false);
        return;
      }

      // Ensure .skbak extension
      final finalPath = savePath.endsWith('.skbak')
          ? savePath
          : '$savePath.skbak';

      await File(finalPath).writeAsBytes(data);

      if (mounted) {
        Navigator.of(context).pop();
        AppToast.success(
          context,
          message: 'Backup saved to ${p.basename(finalPath)}',
        );
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isExporting = false;
      });
    }
  }
}
