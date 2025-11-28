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
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/notifications/app_toast.dart';
import '../../../remote/domain/remote_entity.dart';
import '../../bloc/keys_bloc.dart';
import '../../domain/key_entity.dart';

/// Preset service configurations for common SSH services.
class ServicePreset {
  /// The display name of the service.
  final String name;

  /// The hostname of the service.
  final String host;

  /// The SSH port of the service.
  final int port;

  /// The username to use for authentication.
  final String user;

  /// The icon to display for this service.
  final IconData icon;

  /// Creates a ServicePreset with the given parameters.
  const ServicePreset({
    required this.name,
    required this.host,
    required this.port,
    required this.user,
    required this.icon,
  });

  /// List of common service presets.
  static const List<ServicePreset> presets = [
    ServicePreset(
      name: 'GitHub',
      host: 'github.com',
      port: 22,
      user: 'git',
      icon: Icons.code,
    ),
    ServicePreset(
      name: 'GitLab',
      host: 'gitlab.com',
      port: 22,
      user: 'git',
      icon: Icons.account_tree,
    ),
    ServicePreset(
      name: 'Bitbucket',
      host: 'bitbucket.org',
      port: 22,
      user: 'git',
      icon: Icons.cloud,
    ),
  ];
}

/// Dialog for testing SSH connection with a key.
class TestConnectionDialog extends StatefulWidget {
  /// The SSH key to test.
  final KeyEntity keyEntity;

  /// Creates a TestConnectionDialog widget.
  const TestConnectionDialog({super.key, required this.keyEntity});

  @override
  State<TestConnectionDialog> createState() => _TestConnectionDialogState();
}

class _TestConnectionDialogState extends State<TestConnectionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _hostController = TextEditingController();
  final _portController = TextEditingController(text: '22');
  final _userController = TextEditingController();
  final _passphraseController = TextEditingController();

  final _hostFocusNode = FocusNode();
  final _userFocusNode = FocusNode();
  final _portFocusNode = FocusNode();
  final _passphraseFocusNode = FocusNode();

  ServicePreset? _selectedPreset;
  bool _useCustom = false;
  bool _obscurePassphrase = true;

  /// Cached value of whether passphrase is needed, updated during build.
  bool _currentNeedsPassphrase = false;

  /// Whether to show the passphrase field - needed when key has passphrase and is not in agent.
  /// We need to check the current KeysBloc state to get the up-to-date isInAgent status,
  /// since the widget.keyEntity may be stale (e.g., key was added to agent after dialog opened).
  bool _needsPassphrase(KeysState state) {
    // Find the current state of this key in the bloc
    final currentKey = state.keys.firstWhere(
      (k) => k.path == widget.keyEntity.path,
      orElse: () => widget.keyEntity,
    );
    return currentKey.hasPassphrase && !currentKey.isInAgent;
  }

  @override
  void dispose() {
    _hostController.dispose();
    _portController.dispose();
    _userController.dispose();
    _passphraseController.dispose();
    _hostFocusNode.dispose();
    _userFocusNode.dispose();
    _portFocusNode.dispose();
    _passphraseFocusNode.dispose();
    super.dispose();
  }

  void _selectPreset(ServicePreset preset) {
    setState(() {
      _selectedPreset = preset;
      _useCustom = false;
    });
  }

  void _selectCustom() {
    setState(() {
      _selectedPreset = null;
      _useCustom = true;
      _hostController.clear();
      _portController.text = '22';
      _userController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<KeysBloc, KeysState>(
      listener: (context, state) {
        if (state.testConnectionResult != null) {
          final result = state.testConnectionResult!;

          // Handle host key verification states
          if (result.needsHostKeyApproval && result.hostKeyInfo != null) {
            // Show host key confirmation dialog
            _showHostKeyConfirmationDialog(context, result.hostKeyInfo!);
            return;
          }

          if (result.hasHostKeyMismatch && result.hostKeyInfo != null) {
            // Show warning about host key mismatch
            _showHostKeyMismatchWarning(context, result.hostKeyInfo!);
            return;
          }

          // Show result as toast for normal cases
          AppToast.connectionResult(
            context,
            success: result.success,
            message: result.message,
            serverVersion: result.serverVersion,
            latencyMs: result.latencyMs,
          );

          // Close the dialog on successful connection
          if (result.success) {
            Navigator.of(context).pop();
          }
        }
      },
      builder: (context, state) {
        final isLoading = state.status == KeysStatus.testingConnection;
        // Update cached value for use in callbacks
        _currentNeedsPassphrase = _needsPassphrase(state);

        return AlertDialog(
          title: const Text('Test SSH Connection'),
          content: SizedBox(
            width: 450,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Test your key "${widget.keyEntity.name}" with a remote server.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),

                  // Service presets
                  Text(
                    'Select Service',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ...ServicePreset.presets.map(
                        (preset) => ChoiceChip(
                          avatar: Icon(preset.icon, size: 18),
                          label: Text(preset.name),
                          selected: _selectedPreset == preset,
                          onSelected: isLoading
                              ? null
                              : (_) => _selectPreset(preset),
                        ),
                      ),
                      ChoiceChip(
                        avatar: const Icon(Icons.dns, size: 18),
                        label: const Text('Custom'),
                        selected: _useCustom,
                        onSelected: isLoading ? null : (_) => _selectCustom(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Custom server form - only shown for Custom option
                  if (_useCustom) ...[
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _hostController,
                            focusNode: _hostFocusNode,
                            decoration: const InputDecoration(
                              labelText: 'Host',
                              hintText: 'e.g., my-server.com',
                            ),
                            textInputAction: TextInputAction.next,
                            enabled: !isLoading,
                            onFieldSubmitted: (_) =>
                                _userFocusNode.requestFocus(),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a host';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: TextFormField(
                                  controller: _userController,
                                  focusNode: _userFocusNode,
                                  decoration: const InputDecoration(
                                    labelText: 'User',
                                    hintText: 'e.g., root',
                                  ),
                                  textInputAction: TextInputAction.next,
                                  enabled: !isLoading,
                                  onFieldSubmitted: (_) =>
                                      _portFocusNode.requestFocus(),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a user';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextFormField(
                                  controller: _portController,
                                  focusNode: _portFocusNode,
                                  decoration: const InputDecoration(
                                    labelText: 'Port',
                                  ),
                                  keyboardType: TextInputType.number,
                                  textInputAction: _currentNeedsPassphrase
                                      ? TextInputAction.next
                                      : TextInputAction.done,
                                  enabled: !isLoading,
                                  onFieldSubmitted: (_) {
                                    if (_currentNeedsPassphrase) {
                                      _passphraseFocusNode.requestFocus();
                                    } else {
                                      _onTest();
                                    }
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Required';
                                    }
                                    final port = int.tryParse(value);
                                    if (port == null ||
                                        port < 1 ||
                                        port > 65535) {
                                      return 'Invalid';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Passphrase field - shown when key has passphrase and is not in agent
                  if ((_selectedPreset != null || _useCustom) &&
                      _currentNeedsPassphrase) ...[
                    Form(
                      key: _selectedPreset != null ? _formKey : null,
                      child: TextFormField(
                        controller: _passphraseController,
                        focusNode: _passphraseFocusNode,
                        decoration: InputDecoration(
                          labelText: 'Key Passphrase',
                          helperText:
                              'Required - key is not loaded in SSH agent',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassphrase
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassphrase = !_obscurePassphrase;
                              });
                            },
                          ),
                        ),
                        obscureText: _obscurePassphrase,
                        textInputAction: TextInputAction.done,
                        enabled: !isLoading,
                        onFieldSubmitted: (_) => _onTest(),
                        validator: (value) {
                          if (_currentNeedsPassphrase &&
                              (value == null || value.isEmpty)) {
                            return 'Passphrase required for this key';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Loading indicator
                  if (isLoading) ...[
                    const Divider(),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _selectedPreset != null
                              ? 'Testing connection to ${_selectedPreset!.name}...'
                              : 'Testing connection to ${_hostController.text}...',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: isLoading
                  ? null
                  : () {
                      context.read<KeysBloc>().add(
                        const KeysTestConnectionCleared(),
                      );
                      Navigator.of(context).pop();
                    },
              child: const Text('Close'),
            ),
            if (_selectedPreset != null || _useCustom)
              FilledButton(
                autofocus: true,
                onPressed: isLoading ? null : _onTest,
                child: isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Test Connection'),
              ),
          ],
        );
      },
    );
  }

  void _onTest() {
    // Validate form if it exists (for custom or passphrase fields)
    if (_formKey.currentState != null && !_formKey.currentState!.validate()) {
      return;
    }

    // Get connection details from preset or custom form
    final String host;
    final int port;
    final String user;

    if (_selectedPreset != null) {
      host = _selectedPreset!.host;
      port = _selectedPreset!.port;
      user = _selectedPreset!.user;
    } else {
      host = _hostController.text;
      port = int.parse(_portController.text);
      user = _userController.text;
    }

    context.read<KeysBloc>().add(
      KeysTestConnectionRequested(
        keyPath: widget.keyEntity.path,
        host: host,
        port: port,
        user: user,
        passphrase: _currentNeedsPassphrase ? _passphraseController.text : null,
      ),
    );
  }

  /// Shows a dialog asking the user to confirm an unknown host key.
  void _showHostKeyConfirmationDialog(
    BuildContext context,
    HostKeyInfo hostKeyInfo,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(Icons.security, color: Colors.orange),
        title: const Text('Unknown Host'),
        content: SizedBox(
          width: 450,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'The authenticity of host "${hostKeyInfo.hostname}" cannot be established.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHostKeyInfoRow(context, 'Host', hostKeyInfo.hostname),
                    _buildHostKeyInfoRow(
                      context,
                      'Port',
                      hostKeyInfo.port.toString(),
                    ),
                    _buildHostKeyInfoRow(
                      context,
                      'Key Type',
                      hostKeyInfo.keyType,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Fingerprint: ',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: SelectableText(
                            hostKeyInfo.fingerprint,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(fontFamily: 'monospace'),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy, size: 16),
                          onPressed: () {
                            Clipboard.setData(
                              ClipboardData(text: hostKeyInfo.fingerprint),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Fingerprint copied to clipboard',
                                ),
                              ),
                            );
                          },
                          tooltip: 'Copy fingerprint',
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Are you sure you want to continue connecting?',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'This will add the host key to your known_hosts file.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
            child: const Text('Cancel'),
          ),
          FilledButton(
            autofocus: true,
            onPressed: () {
              Navigator.of(dialogContext).pop();
              _onTestWithTrustHostKey();
            },
            child: const Text('Trust & Connect'),
          ),
        ],
      ),
    );
  }

  /// Shows a warning dialog about a host key mismatch (possible MITM attack).
  void _showHostKeyMismatchWarning(
    BuildContext context,
    HostKeyInfo hostKeyInfo,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(Icons.warning, color: Colors.red),
        title: const Text('Host Key Mismatch'),
        content: SizedBox(
          width: 450,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error,
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'It is possible that someone is doing something nasty! '
                'Someone could be eavesdropping on you right now (man-in-the-middle attack)!',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              Text(
                'It is also possible that a host key has just been changed. '
                'Contact your system administrator to verify.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'New Key Information:',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildHostKeyInfoRow(context, 'Host', hostKeyInfo.hostname),
                    _buildHostKeyInfoRow(
                      context,
                      'Key Type',
                      hostKeyInfo.keyType,
                    ),
                    _buildHostKeyInfoRow(
                      context,
                      'Fingerprint',
                      hostKeyInfo.fingerprint,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'To fix this, you need to remove the old host key from your known_hosts file manually.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        actions: [
          FilledButton(
            autofocus: true,
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildHostKeyInfoRow(
    BuildContext context,
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: SelectableText(
              value,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  /// Retry the test connection with trustHostKey set to true.
  void _onTestWithTrustHostKey() {
    final String host;
    final int port;
    final String user;

    if (_selectedPreset != null) {
      host = _selectedPreset!.host;
      port = _selectedPreset!.port;
      user = _selectedPreset!.user;
    } else {
      host = _hostController.text;
      port = int.parse(_portController.text);
      user = _userController.text;
    }

    context.read<KeysBloc>().add(
      KeysTestConnectionRequested(
        keyPath: widget.keyEntity.path,
        host: host,
        port: port,
        user: user,
        passphrase: _currentNeedsPassphrase ? _passphraseController.text : null,
        trustHostKey: true,
      ),
    );
  }
}
