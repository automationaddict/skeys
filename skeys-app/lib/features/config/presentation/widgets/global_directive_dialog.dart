import 'package:flutter/material.dart';

import '../../domain/config_entity.dart';

/// Dialog for adding or editing a global SSH directive.
class GlobalDirectiveDialog extends StatefulWidget {
  final GlobalDirective? directive;
  final void Function(String key, String value) onSave;

  const GlobalDirectiveDialog({
    super.key,
    this.directive,
    required this.onSave,
  });

  @override
  State<GlobalDirectiveDialog> createState() => _GlobalDirectiveDialogState();
}

class _GlobalDirectiveDialogState extends State<GlobalDirectiveDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _keyController;
  late TextEditingController _valueController;
  String? _selectedPreset;

  // Common SSH global directives for quick selection
  static const _commonDirectives = [
    _DirectivePreset('HashKnownHosts', 'yes', 'Hash hostnames in known_hosts file for privacy'),
    _DirectivePreset('AddKeysToAgent', 'yes', 'Automatically add keys to ssh-agent'),
    _DirectivePreset('IdentitiesOnly', 'yes', 'Only use explicitly configured identity files'),
    _DirectivePreset('ServerAliveInterval', '60', 'Send keepalive every N seconds'),
    _DirectivePreset('ServerAliveCountMax', '3', 'Max keepalive failures before disconnect'),
    _DirectivePreset('Compression', 'yes', 'Enable compression for slow networks'),
    _DirectivePreset('TCPKeepAlive', 'yes', 'Enable TCP keepalive messages'),
    _DirectivePreset('StrictHostKeyChecking', 'ask', 'Behavior for unknown host keys'),
    _DirectivePreset('UserKnownHostsFile', '~/.ssh/known_hosts', 'Path to known hosts file'),
    _DirectivePreset('VisualHostKey', 'no', 'Display visual ASCII art host key'),
    _DirectivePreset('BatchMode', 'no', 'Disable prompts for batch/script mode'),
    _DirectivePreset('ForwardAgent', 'no', 'Forward SSH agent to remote hosts'),
    _DirectivePreset('ForwardX11', 'no', 'Enable X11 forwarding'),
  ];

  bool get _isEditing => widget.directive != null;

  @override
  void initState() {
    super.initState();
    _keyController = TextEditingController(text: widget.directive?.key ?? '');
    _valueController = TextEditingController(text: widget.directive?.value ?? '');
  }

  @override
  void dispose() {
    _keyController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  void _selectPreset(_DirectivePreset preset) {
    setState(() {
      _selectedPreset = preset.key;
      _keyController.text = preset.key;
      _valueController.text = preset.defaultValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 700),
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
                    Icons.settings,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _isEditing ? 'Edit Directive' : 'Add Global Directive',
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Quick select presets (only for new directives)
                      if (!_isEditing) ...[
                        Text(
                          'Common Directives',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _commonDirectives.map((preset) {
                            final isSelected = _selectedPreset == preset.key;
                            return Tooltip(
                              message: preset.description,
                              child: FilterChip(
                                label: Text(preset.key),
                                selected: isSelected,
                                onSelected: (_) => _selectPreset(preset),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),
                        const Divider(),
                        const SizedBox(height: 16),
                        Text(
                          'Or enter custom directive:',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      // Key field
                      TextFormField(
                        controller: _keyController,
                        decoration: const InputDecoration(
                          labelText: 'Directive Name',
                          hintText: 'e.g., HashKnownHosts',
                          prefixIcon: Icon(Icons.key),
                        ),
                        enabled: !_isEditing, // Can't change key when editing
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a directive name';
                          }
                          if (value.contains(' ')) {
                            return 'Directive name cannot contain spaces';
                          }
                          return null;
                        },
                        onChanged: (_) {
                          setState(() => _selectedPreset = null);
                        },
                      ),
                      const SizedBox(height: 16),
                      // Value field
                      TextFormField(
                        controller: _valueController,
                        decoration: InputDecoration(
                          labelText: 'Value',
                          hintText: 'e.g., yes, no, or a path',
                          prefixIcon: const Icon(Icons.text_fields),
                          helperText: _getValueHelperText(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a value';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Info box
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 18,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Global directives apply to all SSH connections unless overridden by a Host block.',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
                    onPressed: _save,
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

  String? _getValueHelperText() {
    final key = _keyController.text.toLowerCase();
    if (key.contains('interval') || key.contains('timeout') || key.contains('count')) {
      return 'Enter a number (seconds or count)';
    }
    if (key.contains('file') || key.contains('path')) {
      return 'Enter a file path';
    }
    if (key.contains('forwarding') || key.contains('agent') ||
        key.contains('compression') || key == 'hashknownhosts' ||
        key == 'tcpkeepalive' || key == 'visualhostkey' ||
        key == 'batchmode' || key == 'identitiesonly') {
      return 'Common values: yes, no';
    }
    if (key == 'stricthostkeychecking') {
      return 'Common values: yes, no, ask, accept-new';
    }
    return null;
  }

  void _save() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSave(_keyController.text.trim(), _valueController.text.trim());
      Navigator.of(context).pop();
    }
  }
}

class _DirectivePreset {
  final String key;
  final String defaultValue;
  final String description;

  const _DirectivePreset(this.key, this.defaultValue, this.description);
}
