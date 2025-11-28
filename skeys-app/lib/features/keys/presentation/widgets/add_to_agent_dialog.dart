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

import '../../../../core/di/injection.dart';
import '../../../../core/notifications/app_toast.dart';
import '../../../agent/bloc/agent_bloc.dart';
import '../../../metadata/domain/key_metadata_entity.dart';
import '../../../metadata/repository/metadata_repository.dart';
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

/// Dialog for adding a key to the SSH agent with connection verification.
class AddToAgentDialog extends StatefulWidget {
  /// The SSH key to add to the agent.
  final KeyEntity keyEntity;

  /// Creates an AddToAgentDialog widget.
  const AddToAgentDialog({super.key, required this.keyEntity});

  @override
  State<AddToAgentDialog> createState() => _AddToAgentDialogState();
}

class _AddToAgentDialogState extends State<AddToAgentDialog> {
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
  bool _verifyingConnection = false;
  bool _addingToAgent = false;

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
    return MultiBlocListener(
      listeners: [
        BlocListener<KeysBloc, KeysState>(
          listener: (context, state) {
            if (!_verifyingConnection) return;

            if (state.testConnectionResult != null) {
              final result = state.testConnectionResult!;

              // Handle host key verification states
              if (result.needsHostKeyApproval && result.hostKeyInfo != null) {
                _showHostKeyConfirmationDialog(context, result.hostKeyInfo!);
                return;
              }

              if (result.hasHostKeyMismatch && result.hostKeyInfo != null) {
                _showHostKeyMismatchWarning(context, result.hostKeyInfo!);
                setState(() => _verifyingConnection = false);
                return;
              }

              // Connection test completed
              if (result.success) {
                // Connection verified! Now add to agent
                _addKeyToAgent();
              } else {
                // Connection failed
                AppToast.error(
                  context,
                  message: 'Connection failed: ${result.message}',
                );
                setState(() => _verifyingConnection = false);
              }
            }
          },
        ),
        BlocListener<AgentBloc, AgentState>(
          listener: (context, agentState) {
            if (!_addingToAgent) return;

            // Only react to addKey completion, not watch stream updates
            if (agentState.status == AgentBlocStatus.success &&
                agentState.lastCompletedAction == AgentCompletedAction.addKey) {
              // Key added successfully - store metadata and close
              _onAgentAddSuccess();
            } else if (agentState.status == AgentBlocStatus.failure) {
              // Key add failed
              AppToast.error(
                context,
                message:
                    'Failed to add key: ${agentState.errorMessage ?? "Unknown error"}',
              );
              setState(() => _addingToAgent = false);
            }
          },
        ),
      ],
      child: BlocBuilder<KeysBloc, KeysState>(
        builder: (context, state) {
          final isLoading =
              _verifyingConnection ||
              _addingToAgent ||
              state.status == KeysStatus.testingConnection;

          return AlertDialog(
            title: const Text('Add Key to Agent'),
            content: SizedBox(
              width: 450,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add "${widget.keyEntity.name}" to the SSH agent after verifying it works with a service.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),

                    // Service presets
                    Text(
                      'Select Service to Verify',
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
                                    textInputAction:
                                        widget.keyEntity.hasPassphrase
                                        ? TextInputAction.next
                                        : TextInputAction.done,
                                    enabled: !isLoading,
                                    onFieldSubmitted: (_) {
                                      if (widget.keyEntity.hasPassphrase) {
                                        _passphraseFocusNode.requestFocus();
                                      } else {
                                        _onVerifyAndAdd();
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

                    // Passphrase field - shown when key has passphrase
                    if ((_selectedPreset != null || _useCustom) &&
                        widget.keyEntity.hasPassphrase) ...[
                      Form(
                        key: _selectedPreset != null ? _formKey : null,
                        child: TextFormField(
                          controller: _passphraseController,
                          focusNode: _passphraseFocusNode,
                          decoration: InputDecoration(
                            labelText: 'Key Passphrase',
                            helperText: 'Required to unlock your private key',
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
                          onFieldSubmitted: (_) => _onVerifyAndAdd(),
                          validator: (value) {
                            if (widget.keyEntity.hasPassphrase &&
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
                            _addingToAgent
                                ? 'Adding key to agent...'
                                : _selectedPreset != null
                                ? 'Verifying connection to ${_selectedPreset!.name}...'
                                : 'Verifying connection to ${_hostController.text}...',
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
                onPressed: () {
                  // Always allow cancel - abort pending operations
                  setState(() {
                    _verifyingConnection = false;
                    _addingToAgent = false;
                  });
                  context.read<KeysBloc>().add(
                    const KeysTestConnectionCleared(),
                  );
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              if (_selectedPreset != null || _useCustom)
                FilledButton(
                  autofocus: true,
                  onPressed: isLoading ? null : _onVerifyAndAdd,
                  child: isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Verify & Add'),
                ),
            ],
          );
        },
      ),
    );
  }

  void _onVerifyAndAdd() {
    // Validate form if it exists (for custom or passphrase fields)
    if (_formKey.currentState != null && !_formKey.currentState!.validate()) {
      return;
    }

    // If the key is already in the agent, just update metadata and close
    if (widget.keyEntity.isInAgent) {
      _updateMetadataAndClose();
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

    setState(() => _verifyingConnection = true);

    context.read<KeysBloc>().add(
      KeysTestConnectionRequested(
        keyPath: widget.keyEntity.path,
        host: host,
        port: port,
        user: user,
        passphrase: widget.keyEntity.hasPassphrase
            ? _passphraseController.text
            : null,
      ),
    );
  }

  /// Called when key is already in agent - just update metadata.
  void _updateMetadataAndClose() async {
    await _storeServiceMetadata();

    if (mounted) {
      final serviceName = _selectedPreset?.name ?? _hostController.text;
      AppToast.success(
        context,
        message: 'Service metadata updated for $serviceName',
      );
      Navigator.of(context).pop();
    }
  }

  void _addKeyToAgent() {
    setState(() {
      _verifyingConnection = false;
      _addingToAgent = true;
    });

    // Add key to agent - the BlocListener will handle completion
    context.read<AgentBloc>().add(
      AgentAddKeyRequested(
        keyPath: widget.keyEntity.path,
        passphrase: widget.keyEntity.hasPassphrase
            ? _passphraseController.text
            : null,
      ),
    );
  }

  /// Called when the agent successfully adds the key.
  void _onAgentAddSuccess() async {
    // Store the verified service metadata
    await _storeServiceMetadata();

    // Show success and close dialog
    if (mounted) {
      final serviceName = _selectedPreset?.name ?? _hostController.text;
      AppToast.success(
        context,
        message: 'Key added to agent and verified with $serviceName',
      );

      // Reload keys to update isInAgent status
      context.read<KeysBloc>().add(const KeysLoadRequested());

      Navigator.of(context).pop();
    }
  }

  Future<void> _storeServiceMetadata() async {
    final String serviceName;
    final String host;
    final int port;
    final String user;

    if (_selectedPreset != null) {
      serviceName = _selectedPreset!.name;
      host = _selectedPreset!.host;
      port = _selectedPreset!.port;
      user = _selectedPreset!.user;
    } else {
      serviceName = 'Custom';
      host = _hostController.text;
      port = int.parse(_portController.text);
      user = _userController.text;
    }

    try {
      final metadataRepo = getIt<MetadataRepository>();
      await metadataRepo.setKeyMetadata(
        KeyMetadataEntity(
          keyPath: widget.keyEntity.path,
          verifiedService: serviceName,
          verifiedHost: host,
          verifiedPort: port,
          verifiedUser: user,
        ),
      );
    } catch (e) {
      // Log but don't fail - metadata storage is best-effort
      debugPrint('Failed to store key metadata: $e');
    }
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
              setState(() => _verifyingConnection = false);
            },
            child: const Text('Cancel'),
          ),
          FilledButton(
            autofocus: true,
            onPressed: () {
              Navigator.of(dialogContext).pop();
              _onVerifyWithTrustHostKey();
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

  /// Retry the verification with trustHostKey set to true.
  void _onVerifyWithTrustHostKey() {
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
        passphrase: widget.keyEntity.hasPassphrase
            ? _passphraseController.text
            : null,
        trustHostKey: true,
      ),
    );
  }
}
