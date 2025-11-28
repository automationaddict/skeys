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

import '../../domain/ssh_config_entry.dart';
import 'key_picker_dialog.dart';

/// Dialog for creating or editing SSH config entries.
/// Uses progressive disclosure to show advanced options only when needed.
class SSHConfigDialog extends StatefulWidget {
  /// The entry to edit, or null to create a new one.
  final SSHConfigEntry? entry;

  /// Callback when the user saves the entry.
  final void Function(SSHConfigEntry entry) onSave;

  const SSHConfigDialog({super.key, this.entry, required this.onSave});

  @override
  State<SSHConfigDialog> createState() => _SSHConfigDialogState();
}

class _SSHConfigDialogState extends State<SSHConfigDialog> {
  final _formKey = GlobalKey<FormState>();

  // Entry type
  late SSHConfigEntryType _entryType;

  // Basic fields
  final _patternsController = TextEditingController();
  final _hostnameController = TextEditingController();
  final _userController = TextEditingController();
  final _portController = TextEditingController();
  final _identityFileController = TextEditingController();
  bool _forwardAgent = false;

  // Connection options
  final _proxyJumpController = TextEditingController();
  final _proxyCommandController = TextEditingController();
  final _serverAliveIntervalController = TextEditingController();
  final _serverAliveCountMaxController = TextEditingController();

  // Security options
  bool _identitiesOnly = false;
  bool _compression = false;
  String? _strictHostKeyChecking;

  // Extra options
  final _extraOptionsController = TextEditingController();

  // Progressive disclosure
  bool _showAdvanced = false;

  bool get _isEditing => widget.entry != null;

  @override
  void initState() {
    super.initState();
    _initializeFromEntry();
  }

  void _initializeFromEntry() {
    final entry = widget.entry;
    if (entry != null) {
      _entryType = entry.type;
      _patternsController.text = entry.patterns.join(' ');

      final opts = entry.options;
      _hostnameController.text = opts.hostname ?? '';
      _userController.text = opts.user ?? '';
      _portController.text = opts.port?.toString() ?? '';
      _identityFileController.text = opts.primaryIdentityFile ?? '';
      _forwardAgent = opts.forwardAgent ?? false;

      _proxyJumpController.text = opts.proxyJump ?? '';
      _proxyCommandController.text = opts.proxyCommand ?? '';
      _serverAliveIntervalController.text =
          opts.serverAliveInterval?.toString() ?? '';
      _serverAliveCountMaxController.text =
          opts.serverAliveCountMax?.toString() ?? '';

      _identitiesOnly = opts.identitiesOnly ?? false;
      _compression = opts.compression ?? false;
      _strictHostKeyChecking = opts.strictHostKeyChecking;

      // Convert extra options to key=value format
      if (opts.extraOptions.isNotEmpty) {
        _extraOptionsController.text = opts.extraOptions.entries
            .map((e) => '${e.key} ${e.value}')
            .join('\n');
      }

      // Show advanced if any advanced options are set
      _showAdvanced = opts.advancedOptionsCount > 0;
    } else {
      _entryType = SSHConfigEntryType.host;
    }
  }

  @override
  void dispose() {
    _patternsController.dispose();
    _hostnameController.dispose();
    _userController.dispose();
    _portController.dispose();
    _identityFileController.dispose();
    _proxyJumpController.dispose();
    _proxyCommandController.dispose();
    _serverAliveIntervalController.dispose();
    _serverAliveCountMaxController.dispose();
    _extraOptionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 550, maxHeight: 700),
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
                    _isEditing ? Icons.edit : Icons.add,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _isEditing
                        ? 'Edit SSH Config Entry'
                        : 'Add SSH Config Entry',
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
            // Form
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Entry Type selector
                      _buildSectionHeader(context, 'Entry Type'),
                      const SizedBox(height: 8),
                      SegmentedButton<SSHConfigEntryType>(
                        segments: const [
                          ButtonSegment(
                            value: SSHConfigEntryType.host,
                            label: Text('Host'),
                            icon: Icon(Icons.dns),
                          ),
                          ButtonSegment(
                            value: SSHConfigEntryType.match,
                            label: Text('Match'),
                            icon: Icon(Icons.filter_alt),
                          ),
                        ],
                        selected: {_entryType},
                        onSelectionChanged: (selection) {
                          setState(() => _entryType = selection.first);
                        },
                      ),
                      const SizedBox(height: 16),

                      // Patterns
                      TextFormField(
                        controller: _patternsController,
                        decoration: InputDecoration(
                          labelText: _entryType == SSHConfigEntryType.host
                              ? 'Host Patterns'
                              : 'Match Criteria',
                          hintText: _entryType == SSHConfigEntryType.host
                              ? 'e.g., github.com *.example.com'
                              : 'e.g., host *.internal user admin',
                          helperText: 'Space-separated patterns or criteria',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'At least one pattern is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // Basic Options
                      _buildSectionHeader(context, 'Basic Options'),
                      const SizedBox(height: 12),

                      // Hostname & User row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _hostnameController,
                              decoration: const InputDecoration(
                                labelText: 'Hostname',
                                hintText: 'e.g., 192.168.1.100',
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _userController,
                              decoration: const InputDecoration(
                                labelText: 'User',
                                hintText: 'e.g., admin',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Port & IdentityFile row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 120,
                            child: TextFormField(
                              controller: _portController,
                              decoration: const InputDecoration(
                                labelText: 'Port',
                                hintText: '22',
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: (value) {
                                if (value != null && value.isNotEmpty) {
                                  final port = int.tryParse(value);
                                  if (port == null ||
                                      port < 1 ||
                                      port > 65535) {
                                    return 'Invalid port';
                                  }
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _identityFileController,
                              decoration: InputDecoration(
                                labelText: 'Identity File',
                                hintText: '~/.ssh/id_ed25519',
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.folder_open),
                                  tooltip: 'Browse keys',
                                  onPressed: _showKeyPicker,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // ForwardAgent checkbox
                      CheckboxListTile(
                        value: _forwardAgent,
                        onChanged: (value) {
                          setState(() => _forwardAgent = value ?? false);
                        },
                        title: const Text('Forward Agent'),
                        subtitle: const Text('Allow authentication forwarding'),
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                      ),

                      const SizedBox(height: 16),

                      // Advanced Options toggle
                      InkWell(
                        onTap: () =>
                            setState(() => _showAdvanced = !_showAdvanced),
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              Icon(
                                _showAdvanced
                                    ? Icons.expand_less
                                    : Icons.expand_more,
                                color: colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Advanced Options',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  color: colorScheme.primary,
                                ),
                              ),
                              if (_hasAdvancedOptions()) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colorScheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '${_countAdvancedOptions()} configured',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: colorScheme.onPrimaryContainer,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),

                      // Advanced options (collapsible)
                      if (_showAdvanced) ...[
                        const SizedBox(height: 16),
                        _buildAdvancedOptions(context),
                      ],
                    ],
                  ),
                ),
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
                    onPressed: _onSave,
                    child: Text(_isEditing ? 'Save' : 'Add'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildAdvancedOptions(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Connection section
          _buildSectionHeader(context, 'Connection'),
          const SizedBox(height: 12),

          TextFormField(
            controller: _proxyJumpController,
            decoration: const InputDecoration(
              labelText: 'ProxyJump',
              hintText: 'e.g., bastion.example.com',
              helperText: 'SSH jump host for tunneling',
            ),
          ),
          const SizedBox(height: 12),

          TextFormField(
            controller: _proxyCommandController,
            decoration: const InputDecoration(
              labelText: 'ProxyCommand',
              hintText: 'e.g., ssh -W %h:%p proxy',
              helperText: 'Custom proxy command',
            ),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _serverAliveIntervalController,
                  decoration: const InputDecoration(
                    labelText: 'ServerAliveInterval',
                    hintText: 'seconds',
                    suffixText: 'sec',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _serverAliveCountMaxController,
                  decoration: const InputDecoration(
                    labelText: 'ServerAliveCountMax',
                    hintText: 'count',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Security section
          _buildSectionHeader(context, 'Security'),
          const SizedBox(height: 12),

          CheckboxListTile(
            value: _identitiesOnly,
            onChanged: (value) {
              setState(() => _identitiesOnly = value ?? false);
            },
            title: const Text('IdentitiesOnly'),
            subtitle: const Text('Only use explicitly configured keys'),
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
          ),

          CheckboxListTile(
            value: _compression,
            onChanged: (value) {
              setState(() => _compression = value ?? false);
            },
            title: const Text('Compression'),
            subtitle: const Text('Enable compression'),
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
          ),

          const SizedBox(height: 8),

          DropdownButtonFormField<String?>(
            initialValue: _strictHostKeyChecking,
            decoration: const InputDecoration(
              labelText: 'StrictHostKeyChecking',
            ),
            items: const [
              DropdownMenuItem(value: null, child: Text('Default')),
              DropdownMenuItem(value: 'yes', child: Text('Yes (strict)')),
              DropdownMenuItem(value: 'no', child: Text('No (accept all)')),
              DropdownMenuItem(value: 'ask', child: Text('Ask (prompt)')),
              DropdownMenuItem(value: 'accept-new', child: Text('Accept new')),
            ],
            onChanged: (value) {
              setState(() => _strictHostKeyChecking = value);
            },
          ),

          const SizedBox(height: 24),

          // Extra options section
          _buildSectionHeader(context, 'Custom Options'),
          const SizedBox(height: 12),

          TextFormField(
            controller: _extraOptionsController,
            decoration: const InputDecoration(
              labelText: 'Extra Options',
              hintText: 'AddKeysToAgent yes\nLocalForward 8080 localhost:80',
              helperText: 'One option per line: Key Value',
            ),
            maxLines: 4,
          ),
        ],
      ),
    );
  }

  bool _hasAdvancedOptions() {
    return _proxyJumpController.text.isNotEmpty ||
        _proxyCommandController.text.isNotEmpty ||
        _serverAliveIntervalController.text.isNotEmpty ||
        _serverAliveCountMaxController.text.isNotEmpty ||
        _identitiesOnly ||
        _compression ||
        _strictHostKeyChecking != null ||
        _extraOptionsController.text.isNotEmpty;
  }

  int _countAdvancedOptions() {
    var count = 0;
    if (_proxyJumpController.text.isNotEmpty) count++;
    if (_proxyCommandController.text.isNotEmpty) count++;
    if (_serverAliveIntervalController.text.isNotEmpty) count++;
    if (_serverAliveCountMaxController.text.isNotEmpty) count++;
    if (_identitiesOnly) count++;
    if (_compression) count++;
    if (_strictHostKeyChecking != null) count++;
    if (_extraOptionsController.text.isNotEmpty) {
      count += _extraOptionsController.text
          .trim()
          .split('\n')
          .where((l) => l.trim().isNotEmpty)
          .length;
    }
    return count;
  }

  void _showKeyPicker() async {
    final selectedKey = await showDialog<String>(
      context: context,
      builder: (context) => const KeyPickerDialog(),
    );

    if (selectedKey != null) {
      setState(() {
        _identityFileController.text = selectedKey;
      });
    }
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Parse patterns
    final patterns = _patternsController.text
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();

    // Parse identity files
    final identityFiles = <String>[];
    if (_identityFileController.text.isNotEmpty) {
      identityFiles.add(_identityFileController.text.trim());
    }

    // Parse extra options
    final extraOptions = <String, String>{};
    if (_extraOptionsController.text.isNotEmpty) {
      for (final line in _extraOptionsController.text.split('\n')) {
        final trimmed = line.trim();
        if (trimmed.isNotEmpty) {
          final spaceIndex = trimmed.indexOf(' ');
          if (spaceIndex > 0) {
            final key = trimmed.substring(0, spaceIndex);
            final value = trimmed.substring(spaceIndex + 1).trim();
            if (key.isNotEmpty && value.isNotEmpty) {
              extraOptions[key] = value;
            }
          }
        }
      }
    }

    // Build options
    final options = SSHOptions(
      hostname: _hostnameController.text.isNotEmpty
          ? _hostnameController.text.trim()
          : null,
      user: _userController.text.isNotEmpty
          ? _userController.text.trim()
          : null,
      port: _portController.text.isNotEmpty
          ? int.tryParse(_portController.text)
          : null,
      identityFiles: identityFiles,
      forwardAgent: _forwardAgent ? true : null,
      proxyJump: _proxyJumpController.text.isNotEmpty
          ? _proxyJumpController.text.trim()
          : null,
      proxyCommand: _proxyCommandController.text.isNotEmpty
          ? _proxyCommandController.text.trim()
          : null,
      serverAliveInterval: _serverAliveIntervalController.text.isNotEmpty
          ? int.tryParse(_serverAliveIntervalController.text)
          : null,
      serverAliveCountMax: _serverAliveCountMaxController.text.isNotEmpty
          ? int.tryParse(_serverAliveCountMaxController.text)
          : null,
      identitiesOnly: _identitiesOnly ? true : null,
      compression: _compression ? true : null,
      strictHostKeyChecking: _strictHostKeyChecking,
      extraOptions: extraOptions,
    );

    // Build entry
    final entry = SSHConfigEntry(
      id: widget.entry?.id ?? '',
      type: _entryType,
      position: widget.entry?.position ?? 0,
      patterns: patterns,
      options: options,
    );

    widget.onSave(entry);
    Navigator.of(context).pop();
  }
}
