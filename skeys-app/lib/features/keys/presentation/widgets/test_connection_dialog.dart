import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/notifications/app_toast.dart';
import '../../bloc/keys_bloc.dart';
import '../../domain/key_entity.dart';

/// Preset service configurations for common SSH services.
class ServicePreset {
  final String name;
  final String host;
  final int port;
  final String user;
  final IconData icon;

  const ServicePreset({
    required this.name,
    required this.host,
    required this.port,
    required this.user,
    required this.icon,
  });

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
  final KeyEntity keyEntity;

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

  ServicePreset? _selectedPreset;
  bool _useCustom = false;
  bool _obscurePassphrase = true;

  /// Whether to show the passphrase field - needed when key has passphrase and is not in agent.
  bool get _needsPassphrase =>
      widget.keyEntity.hasPassphrase && !widget.keyEntity.isInAgent;

  @override
  void dispose() {
    _hostController.dispose();
    _portController.dispose();
    _userController.dispose();
    _passphraseController.dispose();
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
          // Show result as toast
          final result = state.testConnectionResult!;
          AppToast.connectionResult(
            context,
            success: result.success,
            message: result.message,
            serverVersion: result.serverVersion,
            latencyMs: result.latencyMs,
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.status == KeysStatus.testingConnection;

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
                      ...ServicePreset.presets.map((preset) => ChoiceChip(
                        avatar: Icon(preset.icon, size: 18),
                        label: Text(preset.name),
                        selected: _selectedPreset == preset,
                        onSelected: isLoading ? null : (_) => _selectPreset(preset),
                      )),
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
                            decoration: const InputDecoration(
                              labelText: 'Host',
                              hintText: 'e.g., my-server.com',
                            ),
                            enabled: !isLoading,
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
                                  decoration: const InputDecoration(
                                    labelText: 'User',
                                    hintText: 'e.g., root',
                                  ),
                                  enabled: !isLoading,
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
                                  decoration: const InputDecoration(
                                    labelText: 'Port',
                                  ),
                                  keyboardType: TextInputType.number,
                                  enabled: !isLoading,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Required';
                                    }
                                    final port = int.tryParse(value);
                                    if (port == null || port < 1 || port > 65535) {
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
                  if ((_selectedPreset != null || _useCustom) && _needsPassphrase) ...[
                    Form(
                      key: _selectedPreset != null ? _formKey : null,
                      child: TextFormField(
                        controller: _passphraseController,
                        decoration: InputDecoration(
                          labelText: 'Key Passphrase',
                          helperText: 'Required - key is not loaded in SSH agent',
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
                        enabled: !isLoading,
                        validator: (value) {
                          if (_needsPassphrase &&
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
              onPressed: isLoading ? null : () {
                context.read<KeysBloc>().add(const KeysTestConnectionCleared());
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
            if (_selectedPreset != null || _useCustom)
              FilledButton(
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

    context.read<KeysBloc>().add(KeysTestConnectionRequested(
      keyPath: widget.keyEntity.path,
      host: host,
      port: port,
      user: user,
      passphrase: _needsPassphrase ? _passphraseController.text : null,
    ));
  }
}
