import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/keys_bloc.dart';
import '../../domain/key_entity.dart';

/// Dialog for generating a new SSH key.
class GenerateKeyDialog extends StatefulWidget {
  const GenerateKeyDialog({super.key});

  @override
  State<GenerateKeyDialog> createState() => _GenerateKeyDialogState();
}

class _GenerateKeyDialogState extends State<GenerateKeyDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _commentController = TextEditingController();
  final _passphraseController = TextEditingController();
  final _confirmPassphraseController = TextEditingController();

  KeyType _selectedType = KeyType.ed25519;
  int? _selectedBits;
  bool _showPassphrase = false;

  @override
  void dispose() {
    _nameController.dispose();
    _commentController.dispose();
    _passphraseController.dispose();
    _confirmPassphraseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Generate SSH Key'),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Key Name',
                  hintText: 'e.g., id_ed25519_github',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a key name';
                  }
                  if (value.contains(' ') || value.contains('/')) {
                    return 'Name cannot contain spaces or slashes';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<KeyType>(
                value: _selectedType,
                decoration: const InputDecoration(
                  labelText: 'Key Type',
                ),
                items: const [
                  DropdownMenuItem(value: KeyType.ed25519, child: Text('ED25519 (Recommended)')),
                  DropdownMenuItem(value: KeyType.rsa, child: Text('RSA')),
                  DropdownMenuItem(value: KeyType.ecdsa, child: Text('ECDSA')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedType = value!;
                    _selectedBits = null;
                  });
                },
              ),
              if (_selectedType == KeyType.rsa) ...[
                const SizedBox(height: 16),
                DropdownButtonFormField<int>(
                  value: _selectedBits ?? 4096,
                  decoration: const InputDecoration(
                    labelText: 'Key Size (bits)',
                  ),
                  items: const [
                    DropdownMenuItem(value: 2048, child: Text('2048')),
                    DropdownMenuItem(value: 3072, child: Text('3072')),
                    DropdownMenuItem(value: 4096, child: Text('4096 (Recommended)')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedBits = value;
                    });
                  },
                ),
              ],
              if (_selectedType == KeyType.ecdsa) ...[
                const SizedBox(height: 16),
                DropdownButtonFormField<int>(
                  value: _selectedBits ?? 256,
                  decoration: const InputDecoration(
                    labelText: 'Key Size (bits)',
                  ),
                  items: const [
                    DropdownMenuItem(value: 256, child: Text('256')),
                    DropdownMenuItem(value: 384, child: Text('384')),
                    DropdownMenuItem(value: 521, child: Text('521')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedBits = value;
                    });
                  },
                ),
              ],
              const SizedBox(height: 16),
              TextFormField(
                controller: _commentController,
                decoration: const InputDecoration(
                  labelText: 'Comment (optional)',
                  hintText: 'e.g., user@hostname',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passphraseController,
                obscureText: !_showPassphrase,
                decoration: InputDecoration(
                  labelText: 'Passphrase (optional)',
                  suffixIcon: IconButton(
                    icon: Icon(_showPassphrase ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _showPassphrase = !_showPassphrase;
                      });
                    },
                  ),
                ),
                onChanged: (_) {
                  // Trigger rebuild to show/hide confirm passphrase field
                  setState(() {});
                },
              ),
              if (_passphraseController.text.isNotEmpty) ...[
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPassphraseController,
                  obscureText: !_showPassphrase,
                  decoration: InputDecoration(
                    labelText: 'Confirm Passphrase',
                    suffixIcon: IconButton(
                      icon: Icon(_showPassphrase ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _showPassphrase = !_showPassphrase;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (_passphraseController.text.isNotEmpty &&
                        value != _passphraseController.text) {
                      return 'Passphrases do not match';
                    }
                    return null;
                  },
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _onGenerate,
          child: const Text('Generate'),
        ),
      ],
    );
  }

  void _onGenerate() {
    if (_formKey.currentState!.validate()) {
      context.read<KeysBloc>().add(KeysGenerateRequested(
            name: _nameController.text,
            type: _selectedType,
            bits: _selectedBits,
            comment: _commentController.text.isNotEmpty ? _commentController.text : null,
            passphrase: _passphraseController.text.isNotEmpty ? _passphraseController.text : null,
          ));
      Navigator.of(context).pop();
    }
  }
}
