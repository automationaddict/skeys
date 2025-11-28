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
  String? _selectedDropdownValue;

  // SSH directives with constrained value options
  // Reference: https://man.openbsd.org/ssh_config
  static const _directiveValueOptions = <String, List<String>>{
    // Boolean directives (yes/no)
    'BatchMode': ['yes', 'no'],
    'CheckHostIP': ['yes', 'no'],
    'ClearAllForwardings': ['yes', 'no'],
    'Compression': ['yes', 'no'],
    'EnableEscapeCommandline': ['yes', 'no'],
    'EnableSSHKeysign': ['yes', 'no'],
    'ExitOnForwardFailure': ['yes', 'no'],
    'ForkAfterAuthentication': ['yes', 'no'],
    'ForwardX11': ['yes', 'no'],
    'ForwardX11Trusted': ['yes', 'no'],
    'GatewayPorts': ['yes', 'no'],
    'GSSAPIAuthentication': ['yes', 'no'],
    'GSSAPIDelegateCredentials': ['yes', 'no'],
    'GSSAPIKeyExchange': ['yes', 'no'],
    'GSSAPIRenewalForcesRekey': ['yes', 'no'],
    'GSSAPIServerIdentity': ['yes', 'no'],
    'GSSAPITrustDns': ['yes', 'no'],
    'HashKnownHosts': ['yes', 'no'],
    'HostbasedAuthentication': ['yes', 'no'],
    'IdentitiesOnly': ['yes', 'no'],
    'KbdInteractiveAuthentication': ['yes', 'no'],
    'NoHostAuthenticationForLocalhost': ['yes', 'no'],
    'PasswordAuthentication': ['yes', 'no'],
    'PermitLocalCommand': ['yes', 'no'],
    'ProxyUseFdpass': ['yes', 'no'],
    'StdinNull': ['yes', 'no'],
    'StreamLocalBindUnlink': ['yes', 'no'],
    'TCPKeepAlive': ['yes', 'no'],
    'UseKeychain': ['yes', 'no'],
    'VisualHostKey': ['yes', 'no'],
    // Deprecated but still in use
    'ChallengeResponseAuthentication': ['yes', 'no'],

    // Multi-value directives
    'AddKeysToAgent': ['yes', 'no', 'ask', 'confirm'],
    'AddressFamily': ['any', 'inet', 'inet6'],
    'CanonicalizeHostname': ['yes', 'no', 'always', 'none'],
    'ControlMaster': ['yes', 'no', 'ask', 'auto', 'autoask'],
    'FingerprintHash': ['md5', 'sha256'],
    'ForwardAgent': ['yes', 'no'],
    'IPQoS': [
      'af11',
      'af12',
      'af13',
      'af21',
      'af22',
      'af23',
      'af31',
      'af32',
      'af33',
      'af41',
      'af42',
      'af43',
      'cs0',
      'cs1',
      'cs2',
      'cs3',
      'cs4',
      'cs5',
      'cs6',
      'cs7',
      'ef',
      'le',
      'lowdelay',
      'throughput',
      'reliability',
      'none',
    ],
    'LogLevel': [
      'QUIET',
      'FATAL',
      'ERROR',
      'INFO',
      'VERBOSE',
      'DEBUG',
      'DEBUG1',
      'DEBUG2',
      'DEBUG3',
    ],
    'ObscureKeystrokeTiming': ['yes', 'no'],
    'PubkeyAuthentication': ['yes', 'no', 'unbound', 'host-bound'],
    'RequestTTY': ['no', 'yes', 'force', 'auto'],
    'SessionType': ['none', 'subsystem', 'default'],
    'StrictHostKeyChecking': ['yes', 'no', 'ask', 'accept-new', 'off'],
    'Tunnel': ['yes', 'no', 'point-to-point', 'ethernet'],
    'UpdateHostKeys': ['yes', 'no', 'ask'],
    'VerifyHostKeyDNS': ['yes', 'no', 'ask'],
    'WarnWeakCrypto': ['yes', 'no'],
  };

  // Common SSH global directives for quick selection
  static const _commonDirectives = [
    // Connection & keepalive
    _DirectivePreset(
      'ServerAliveInterval',
      '60',
      'Send keepalive every N seconds',
    ),
    _DirectivePreset(
      'ServerAliveCountMax',
      '3',
      'Max keepalive failures before disconnect',
    ),
    _DirectivePreset('ConnectTimeout', '30', 'Connection timeout in seconds'),
    _DirectivePreset('TCPKeepAlive', 'yes', 'Enable TCP keepalive messages'),
    _DirectivePreset(
      'Compression',
      'yes',
      'Enable compression for slow networks',
    ),
    // Security & authentication
    _DirectivePreset(
      'HashKnownHosts',
      'yes',
      'Hash hostnames in known_hosts file for privacy',
    ),
    _DirectivePreset(
      'StrictHostKeyChecking',
      'ask',
      'Behavior for unknown host keys',
    ),
    _DirectivePreset(
      'VerifyHostKeyDNS',
      'ask',
      'Verify host keys using DNS SSHFP records',
    ),
    _DirectivePreset(
      'UpdateHostKeys',
      'ask',
      'Accept updated host keys from server',
    ),
    _DirectivePreset('CheckHostIP', 'yes', 'Check host IP against known_hosts'),
    _DirectivePreset(
      'PasswordAuthentication',
      'yes',
      'Allow password authentication',
    ),
    _DirectivePreset(
      'PubkeyAuthentication',
      'yes',
      'Enable public key authentication',
    ),
    // Agent & keys
    _DirectivePreset(
      'AddKeysToAgent',
      'yes',
      'Automatically add keys to ssh-agent',
    ),
    _DirectivePreset(
      'IdentitiesOnly',
      'yes',
      'Only use explicitly configured identity files',
    ),
    _DirectivePreset('ForwardAgent', 'no', 'Forward SSH agent to remote hosts'),
    // Files & paths
    _DirectivePreset(
      'UserKnownHostsFile',
      '~/.ssh/known_hosts',
      'Path to known hosts file',
    ),
    _DirectivePreset(
      'IdentityFile',
      '~/.ssh/id_ed25519',
      'Path to private key file',
    ),
    _DirectivePreset(
      'ControlPath',
      '~/.ssh/sockets/%r@%h-%p',
      'Path for control socket',
    ),
    // Multiplexing
    _DirectivePreset('ControlMaster', 'auto', 'Enable connection sharing'),
    _DirectivePreset(
      'ControlPersist',
      '600',
      'Keep master connection open (seconds)',
    ),
    // Forwarding
    _DirectivePreset('ForwardX11', 'no', 'Enable X11 forwarding'),
    _DirectivePreset('ForwardX11Trusted', 'no', 'Trust remote X11 clients'),
    _DirectivePreset(
      'GatewayPorts',
      'no',
      'Allow remote hosts to connect to local forwards',
    ),
    // Misc
    _DirectivePreset('AddressFamily', 'any', 'IPv4/IPv6 preference'),
    _DirectivePreset(
      'BatchMode',
      'no',
      'Disable prompts for batch/script mode',
    ),
    _DirectivePreset(
      'VisualHostKey',
      'no',
      'Display visual ASCII art host key',
    ),
    _DirectivePreset('LogLevel', 'INFO', 'Logging verbosity level'),
    // GSSAPI (Kerberos)
    _DirectivePreset(
      'GSSAPIAuthentication',
      'yes',
      'Enable GSSAPI authentication',
    ),
    _DirectivePreset(
      'GSSAPIDelegateCredentials',
      'no',
      'Delegate GSSAPI credentials',
    ),
  ];

  bool get _isEditing => widget.directive != null;

  @override
  void initState() {
    super.initState();
    _keyController = TextEditingController(text: widget.directive?.key ?? '');
    _valueController = TextEditingController(
      text: widget.directive?.value ?? '',
    );
    // Initialize dropdown value if this directive has constrained options
    if (widget.directive != null) {
      final options = _directiveValueOptions[widget.directive!.key];
      if (options != null && options.contains(widget.directive!.value)) {
        _selectedDropdownValue = widget.directive!.value;
      }
    }
  }

  /// Returns the allowed values for the current directive, or null if free-form
  List<String>? get _currentValueOptions {
    final key = _keyController.text;
    return _directiveValueOptions[key];
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
      // Set dropdown value if this directive has constrained options
      final options = _directiveValueOptions[preset.key];
      if (options != null && options.contains(preset.defaultValue)) {
        _selectedDropdownValue = preset.defaultValue;
      } else {
        _selectedDropdownValue = null;
      }
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
                  Icon(Icons.settings, color: colorScheme.primary),
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
                      // Value field - dropdown for constrained options, text field otherwise
                      _buildValueField(theme, colorScheme),
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

  Widget _buildValueField(ThemeData theme, ColorScheme colorScheme) {
    final options = _currentValueOptions;

    // If directive has constrained options, show dropdown
    if (options != null) {
      return DropdownButtonFormField<String>(
        initialValue: _selectedDropdownValue,
        decoration: const InputDecoration(
          labelText: 'Value',
          prefixIcon: Icon(Icons.list),
        ),
        items: options.map((option) {
          return DropdownMenuItem<String>(value: option, child: Text(option));
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedDropdownValue = value;
            _valueController.text = value ?? '';
          });
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select a value';
          }
          return null;
        },
      );
    }

    // Otherwise show free-form text field
    return TextFormField(
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
    );
  }

  String? _getValueHelperText() {
    final key = _keyController.text.toLowerCase();
    if (key.contains('interval') ||
        key.contains('timeout') ||
        key.contains('count')) {
      return 'Enter a number (seconds or count)';
    }
    if (key.contains('file') || key.contains('path')) {
      return 'Enter a file path';
    }
    return null;
  }

  void _save() {
    if (_formKey.currentState?.validate() ?? false) {
      // Use dropdown value if available, otherwise text controller
      final value = _currentValueOptions != null
          ? (_selectedDropdownValue ?? '')
          : _valueController.text.trim();
      widget.onSave(_keyController.text.trim(), value);
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
