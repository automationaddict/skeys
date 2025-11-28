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

import '../grpc/grpc_client.dart';
import '../generated/skeys/v1/config.pb.dart';
import '../logging/app_logger.dart';

/// Dialog for enabling skeys SSH config integration.
///
/// Shows when user first launches the app (or from Settings) to configure
/// skeys as the default SSH agent.
class SshConfigDialog extends StatefulWidget {
  /// The gRPC client used to communicate with the daemon.
  final GrpcClient grpcClient;

  /// Creates an SshConfigDialog with the given gRPC client.
  const SshConfigDialog({super.key, required this.grpcClient});

  /// Shows the dialog and returns true if user enabled, false if declined.
  static Future<bool> show(BuildContext context, GrpcClient grpcClient) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => SshConfigDialog(grpcClient: grpcClient),
    );
    return result ?? false;
  }

  @override
  State<SshConfigDialog> createState() => _SshConfigDialogState();
}

class _SshConfigDialogState extends State<SshConfigDialog> {
  final _log = AppLogger('ssh_config_dialog');
  bool _isLoading = false;
  String? _error;

  Future<void> _onEnable() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      _log.info('enabling SSH config integration');
      final response = await widget.grpcClient.config.enableSshConfig(
        EnableSshConfigRequest(),
      );

      if (response.success) {
        _log.info('SSH config integration enabled successfully');
        if (mounted) {
          Navigator.of(context).pop(true);
        }
      } else {
        _log.error('failed to enable SSH config', null, null, {
          'message': response.message,
        });
        setState(() {
          _error = response.message;
          _isLoading = false;
        });
      }
    } catch (e, st) {
      _log.error('error enabling SSH config', e, st);
      setState(() {
        _error = 'Failed to enable SSH config: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.vpn_key, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          const Text('Enable SSH Key Management'),
        ],
      ),
      content: SizedBox(
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Skeys can manage your SSH connections so commands like '
              '`git push` and `ssh` work automatically with your keys.',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'What this does:',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildBulletPoint(
                    context,
                    'Adds a configuration block to ~/.ssh/config',
                  ),
                  _buildBulletPoint(
                    context,
                    'All SSH operations will use keys managed by skeys',
                  ),
                  _buildBulletPoint(
                    context,
                    'Works with git, ssh, scp, and other SSH tools',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withAlpha(100),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: theme.colorScheme.primary.withAlpha(50),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 20,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'If you uninstall skeys and remove the config block, '
                      'your system will use its default SSH agent as before.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 20,
                      color: theme.colorScheme.onErrorContainer,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _error!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onErrorContainer,
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
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(false),
          child: const Text('Not Now'),
        ),
        FilledButton(
          autofocus: true,
          onPressed: _isLoading ? null : _onEnable,
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('Enable'),
        ),
      ],
    );
  }

  Widget _buildBulletPoint(BuildContext context, String text) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('  \u2022  ', style: theme.textTheme.bodyMedium),
          Expanded(child: Text(text, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
