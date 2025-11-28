import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/di/injection.dart';
import '../../../core/generated/skeys/v1/config.pb.dart';
import '../../../core/generated/skeys/v1/system.pb.dart';
import '../../../core/grpc/grpc_client.dart';

/// Server status page showing SSH client/server installation and service status.
class ServerPage extends StatefulWidget {
  const ServerPage({super.key});

  @override
  State<ServerPage> createState() => _ServerPageState();
}

class _ServerPageState extends State<ServerPage> {
  final _grpcClient = getIt<GrpcClient>();
  GetSSHStatusResponse? _status;
  bool _loading = true;
  String? _error;
  bool _actionInProgress = false;

  @override
  void initState() {
    super.initState();
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final status = await _grpcClient.system.getSSHStatus(GetSSHStatusRequest());
      setState(() {
        _status = status;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _startService() async {
    setState(() => _actionInProgress = true);
    try {
      final response = await _grpcClient.system.startSSHService(StartSSHServiceRequest());
      if (response.success) {
        _showSnackBar('SSH service started successfully');
        await _loadStatus();
      } else {
        _showSnackBar('Failed to start SSH service: ${response.message}', isError: true);
      }
    } catch (e) {
      _showSnackBar('Error: $e', isError: true);
    } finally {
      setState(() => _actionInProgress = false);
    }
  }

  Future<void> _stopService() async {
    setState(() => _actionInProgress = true);
    try {
      final response = await _grpcClient.system.stopSSHService(StopSSHServiceRequest());
      if (response.success) {
        _showSnackBar('SSH service stopped successfully');
        await _loadStatus();
      } else {
        _showSnackBar('Failed to stop SSH service: ${response.message}', isError: true);
      }
    } catch (e) {
      _showSnackBar('Error: $e', isError: true);
    } finally {
      setState(() => _actionInProgress = false);
    }
  }

  Future<void> _restartService() async {
    setState(() => _actionInProgress = true);
    try {
      final response = await _grpcClient.system.restartSSHServiceWithStatus(
        RestartSSHServiceWithStatusRequest(),
      );
      if (response.success) {
        _showSnackBar('SSH service restarted successfully');
        await _loadStatus();
      } else {
        _showSnackBar('Failed to restart SSH service: ${response.message}', isError: true);
      }
    } catch (e) {
      _showSnackBar('Error: $e', isError: true);
    } finally {
      setState(() => _actionInProgress = false);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Theme.of(context).colorScheme.error : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('SSH Server Status'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: _loading ? null : _loadStatus,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _buildErrorState(colorScheme)
              : _buildContent(theme, colorScheme),
    );
  }

  Widget _buildErrorState(ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: colorScheme.error),
          const SizedBox(height: 16),
          Text(
            'Failed to load SSH status',
            style: TextStyle(color: colorScheme.error),
          ),
          const SizedBox(height: 8),
          Text(_error ?? 'Unknown error'),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _loadStatus,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(ThemeData theme, ColorScheme colorScheme) {
    final status = _status!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // System Info Card
          _buildSystemInfoCard(theme, colorScheme, status),
          const SizedBox(height: 16),
          // SSH Client Card
          _buildClientCard(theme, colorScheme, status.client),
          const SizedBox(height: 16),
          // SSH Server Card
          _buildServerCard(theme, colorScheme, status.server),
        ],
      ),
    );
  }

  Widget _buildSystemInfoCard(ThemeData theme, ColorScheme colorScheme, GetSSHStatusResponse status) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.computer, color: colorScheme.primary),
                const SizedBox(width: 12),
                Text(
                  'System Information',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            _buildInfoRow('Distribution', _formatDistribution(status.distribution), theme),
            if (status.distributionVersion.isNotEmpty)
              _buildInfoRow('Version', status.distributionVersion, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildClientCard(ThemeData theme, ColorScheme colorScheme, SSHClientStatus client) {
    final installed = client.installed;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildStatusIcon(installed, colorScheme),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SSH Client',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        installed ? 'Installed' : 'Not Installed',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: installed ? colorScheme.primary : colorScheme.error,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!installed)
                  FilledButton.tonalIcon(
                    onPressed: () => _showInstallInstructions(SSHComponent.SSH_COMPONENT_CLIENT),
                    icon: const Icon(Icons.help_outline),
                    label: const Text('How to Install'),
                  ),
              ],
            ),
            if (installed) ...[
              const Divider(height: 24),
              if (client.version.isNotEmpty)
                _buildInfoRow('Version', client.version, theme),
              if (client.binaryPath.isNotEmpty)
                _buildInfoRow('Binary', client.binaryPath, theme, copyable: true),
              if (client.systemConfig.path.isNotEmpty)
                _buildConfigPathRow('System Config', client.systemConfig, theme, colorScheme),
              if (client.userConfig.path.isNotEmpty)
                _buildConfigPathRow('User Config', client.userConfig, theme, colorScheme),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildServerCard(ThemeData theme, ColorScheme colorScheme, SSHServerStatus server) {
    final installed = server.installed;
    final service = server.service;
    final isRunning = service.state == ServiceState.SERVICE_STATE_RUNNING;
    final isStopped = service.state == ServiceState.SERVICE_STATE_STOPPED;
    final isFailed = service.state == ServiceState.SERVICE_STATE_FAILED;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildStatusIcon(installed && isRunning, colorScheme,
                    warning: installed && !isRunning && !isFailed,
                    error: isFailed),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SSH Server',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        _getServerStatusText(installed, service),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: _getServerStatusColor(installed, service, colorScheme),
                        ),
                      ),
                    ],
                  ),
                ),
                if (!installed)
                  FilledButton.tonalIcon(
                    onPressed: () => _showInstallInstructions(SSHComponent.SSH_COMPONENT_SERVER),
                    icon: const Icon(Icons.help_outline),
                    label: const Text('How to Install'),
                  ),
              ],
            ),
            if (installed) ...[
              const Divider(height: 24),
              // Service controls
              Row(
                children: [
                  if (isStopped || isFailed)
                    FilledButton.icon(
                      onPressed: _actionInProgress ? null : _startService,
                      icon: _actionInProgress
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.play_arrow),
                      label: const Text('Start'),
                    ),
                  if (isRunning) ...[
                    FilledButton.tonalIcon(
                      onPressed: _actionInProgress ? null : _restartService,
                      icon: _actionInProgress
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.refresh),
                      label: const Text('Restart'),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      onPressed: _actionInProgress ? null : _stopService,
                      icon: const Icon(Icons.stop),
                      label: const Text('Stop'),
                    ),
                  ],
                ],
              ),
              const Divider(height: 24),
              // Server info
              if (server.version.isNotEmpty)
                _buildInfoRow('Version', server.version, theme),
              if (server.binaryPath.isNotEmpty)
                _buildInfoRow('Binary', server.binaryPath, theme, copyable: true),
              if (service.serviceName.isNotEmpty)
                _buildInfoRow('Service', service.serviceName, theme),
              if (service.enabled)
                _buildInfoRow('Auto-start', 'Enabled', theme),
              if (isRunning && service.pid > 0)
                _buildInfoRow('PID', service.pid.toString(), theme),
              if (service.startedAt.isNotEmpty)
                _buildInfoRow('Started', service.startedAt, theme),
              if (server.config.path.isNotEmpty)
                _buildConfigPathRow('Config', server.config, theme, colorScheme),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIcon(bool ok, ColorScheme colorScheme, {bool warning = false, bool error = false}) {
    IconData icon;
    Color color;

    if (error) {
      icon = Icons.error;
      color = colorScheme.error;
    } else if (warning) {
      icon = Icons.warning_amber_rounded;
      color = Colors.orange;
    } else if (ok) {
      icon = Icons.check_circle;
      color = Colors.green;
    } else {
      icon = Icons.cancel;
      color = colorScheme.error;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }

  Widget _buildInfoRow(String label, String value, ThemeData theme, {bool copyable = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: copyable
                ? InkWell(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: value));
                      _showSnackBar('Copied to clipboard');
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            value,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                        Icon(
                          Icons.copy,
                          size: 14,
                          color: theme.colorScheme.outline,
                        ),
                      ],
                    ),
                  )
                : Text(
                    value,
                    style: theme.textTheme.bodyMedium,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfigPathRow(
    String label,
    ConfigPathInfo config,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    final exists = config.exists;
    final readable = config.readable;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  config.path,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontFamily: 'monospace',
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    _buildStatusChip(exists ? 'Exists' : 'Missing', exists, colorScheme),
                    const SizedBox(width: 4),
                    if (exists)
                      _buildStatusChip(readable ? 'Readable' : 'Not Readable', readable, colorScheme),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String label, bool ok, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: ok
            ? Colors.green.withValues(alpha: 0.1)
            : colorScheme.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          color: ok ? Colors.green : colorScheme.error,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _formatDistribution(String distro) {
    final distroNames = {
      'ubuntu': 'Ubuntu',
      'debian': 'Debian',
      'fedora': 'Fedora',
      'rhel': 'Red Hat Enterprise Linux',
      'centos': 'CentOS',
      'arch': 'Arch Linux',
      'manjaro': 'Manjaro',
      'pop': 'Pop!_OS',
      'mint': 'Linux Mint',
      'opensuse': 'openSUSE',
      'suse': 'SUSE',
    };
    return distroNames[distro.toLowerCase()] ?? distro;
  }

  String _getServerStatusText(bool installed, ServiceStatus service) {
    if (!installed) return 'Not Installed';

    switch (service.state) {
      case ServiceState.SERVICE_STATE_RUNNING:
        return 'Running';
      case ServiceState.SERVICE_STATE_STOPPED:
        return 'Stopped';
      case ServiceState.SERVICE_STATE_FAILED:
        return 'Failed';
      case ServiceState.SERVICE_STATE_NOT_FOUND:
        return 'Service Not Found';
      default:
        return 'Unknown';
    }
  }

  Color _getServerStatusColor(bool installed, ServiceStatus service, ColorScheme colorScheme) {
    if (!installed) return colorScheme.error;

    switch (service.state) {
      case ServiceState.SERVICE_STATE_RUNNING:
        return Colors.green;
      case ServiceState.SERVICE_STATE_STOPPED:
        return Colors.orange;
      case ServiceState.SERVICE_STATE_FAILED:
        return colorScheme.error;
      default:
        return colorScheme.onSurfaceVariant;
    }
  }

  Future<void> _showInstallInstructions(SSHComponent component) async {
    try {
      final instructions = await _grpcClient.system.getInstallInstructions(
        GetInstallInstructionsRequest()..component = component,
      );

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (context) => _InstallInstructionsDialog(instructions: instructions),
      );
    } catch (e) {
      _showSnackBar('Failed to load instructions: $e', isError: true);
    }
  }
}

class _InstallInstructionsDialog extends StatelessWidget {
  final GetInstallInstructionsResponse instructions;

  const _InstallInstructionsDialog({required this.instructions});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isServer = instructions.component == SSHComponent.SSH_COMPONENT_SERVER;

    return AlertDialog(
      title: Row(
        children: [
          Icon(
            isServer ? Icons.dns : Icons.terminal,
            color: colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Text('Install SSH ${isServer ? 'Server' : 'Client'}'),
        ],
      ),
      content: SizedBox(
        width: 500,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Package: ${instructions.packageName}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              if (instructions.installCommand.isNotEmpty) ...[
                Text(
                  'Quick Install',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          instructions.installCommand,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy, size: 18),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: instructions.installCommand));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Copied to clipboard')),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
              if (instructions.steps.isNotEmpty) ...[
                Text(
                  'Steps',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                ...instructions.steps.asMap().entries.map((entry) {
                  final index = entry.key + 1;
                  final step = entry.value;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '$index',
                            style: TextStyle(
                              color: colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: Text(step)),
                      ],
                    ),
                  );
                }),
              ],
              if (instructions.documentationUrl.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  'For more information, see the official documentation.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
