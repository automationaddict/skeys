import 'package:flutter/material.dart';

/// Dialog for entering a passphrase to unlock a key.
class PassphraseDialog extends StatefulWidget {
  final String keyName;

  const PassphraseDialog({super.key, required this.keyName});

  @override
  State<PassphraseDialog> createState() => _PassphraseDialogState();
}

class _PassphraseDialogState extends State<PassphraseDialog> {
  final _passphraseController = TextEditingController();
  bool _showPassphrase = false;

  @override
  void dispose() {
    _passphraseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Enter Passphrase'),
      content: SizedBox(
        width: 350,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter the passphrase for "${widget.keyName}" to add it to the SSH agent.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passphraseController,
              obscureText: !_showPassphrase,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Passphrase',
                suffixIcon: IconButton(
                  icon: Icon(_showPassphrase ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _showPassphrase = !_showPassphrase;
                    });
                  },
                ),
              ),
              onSubmitted: (_) => _submit(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _submit,
          child: const Text('Unlock'),
        ),
      ],
    );
  }

  void _submit() {
    final passphrase = _passphraseController.text;
    if (passphrase.isNotEmpty) {
      Navigator.of(context).pop(passphrase);
    }
  }
}
