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

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../backup/export_dialog.dart';
import '../backup/import_dialog.dart';
import '../di/injection.dart';
import '../generated/google/protobuf/empty.pb.dart';
import '../generated/skeys/v1/config.pb.dart';
import '../generated/skeys/v1/update.pbgrpc.dart';
import '../generated/skeys/v1/version.pb.dart';
import '../grpc/grpc_client.dart';
import '../help/help_navigation_service.dart';
import '../logging/app_logger.dart';
import '../notifications/app_toast.dart';
import 'settings_service.dart';

/// Settings dialog with tabbed interface.
///
/// Provides access to display, security, backup, logging, update, and about
/// settings in a tabbed layout.
class SettingsDialog extends StatefulWidget {
  /// The initial tab index to display when the dialog opens.
  final int initialTab;

  /// Creates a SettingsDialog with an optional initial tab.
  const SettingsDialog({super.key, this.initialTab = 0});

  /// Shows the settings dialog as a modal.
  static Future<void> show(BuildContext context, {int initialTab = 0}) {
    return showDialog(
      context: context,
      builder: (context) => SettingsDialog(initialTab: initialTab),
    );
  }

  /// Tab index for the Display settings tab.
  static const int tabDisplay = 0;

  /// Tab index for the Security settings tab.
  static const int tabSecurity = 1;

  /// Tab index for the Backup settings tab.
  static const int tabBackup = 2;

  /// Tab index for the Logging settings tab.
  static const int tabLogging = 3;

  /// Tab index for the Update settings tab.
  static const int tabUpdate = 4;

  /// Tab index for the About tab.
  static const int tabAbout = 5;

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 6,
      vsync: this,
      initialIndex: widget.initialTab,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showHelpForCurrentTab() {
    // Map tab index to help route
    final helpRoutes = [
      'settings/display',
      'settings/security',
      'settings/backup',
      'settings/logging',
      'settings/update',
      'settings/about',
    ];

    final route = helpRoutes[_tabController.index];

    // Request help to be shown, then close the dialog
    final helpNav = getIt<HelpNavigationService>();
    helpNav.requestHelp(route);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.settings,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Settings',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.help_outline),
                    tooltip: 'Help for this tab',
                    onPressed: _showHelpForCurrentTab,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            // Tabs
            TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.center,
              tabs: const [
                Tab(icon: Icon(Icons.text_fields_outlined), text: 'Display'),
                Tab(icon: Icon(Icons.shield_outlined), text: 'Security'),
                Tab(icon: Icon(Icons.backup_outlined), text: 'Backup'),
                Tab(icon: Icon(Icons.article_outlined), text: 'Logging'),
                Tab(icon: Icon(Icons.system_update_outlined), text: 'Update'),
                Tab(icon: Icon(Icons.info_outline), text: 'About'),
              ],
            ),
            // Tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  _DisplayTab(),
                  _SecurityTab(),
                  _BackupTab(),
                  _LoggingTab(),
                  _UpdateTab(),
                  _AboutTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Display settings tab.
class _DisplayTab extends StatefulWidget {
  const _DisplayTab();

  @override
  State<_DisplayTab> createState() => _DisplayTabState();
}

class _DisplayTabState extends State<_DisplayTab> {
  late TextScale _selectedScale;
  late AppThemeMode _selectedTheme;

  @override
  void initState() {
    super.initState();
    _selectedScale = getIt<SettingsService>().textScale;
    _selectedTheme = getIt<SettingsService>().themeMode;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Theme section
          Text('Theme', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            'Choose your preferred color theme.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),

          // Theme mode options as segmented button
          _buildThemeSelector(context),

          const SizedBox(height: 32),

          // Text size section
          Text('Text Size', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            'Adjust the text size throughout the application for better readability.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),

          // Text scale options as styled cards
          ...TextScale.values.map(
            (scale) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _buildTextScaleCard(context, scale),
            ),
          ),

          const SizedBox(height: 16),

          // Preview card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.5),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.preview, color: colorScheme.primary, size: 24),
                    const SizedBox(width: 12),
                    Text('Preview', style: theme.textTheme.titleSmall),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'The quick brown fox jumps over the lazy dog.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 14 * _selectedScale.scale,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Currently using ${_selectedScale.label.toLowerCase()} text size (${((_selectedScale.scale * 100).round())}%)',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 12 * _selectedScale.scale,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextScaleCard(BuildContext context, TextScale scale) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = _selectedScale == scale;

    return InkWell(
      onTap: () async {
        setState(() => _selectedScale = scale);
        await getIt<SettingsService>().setTextScale(scale);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.outline.withValues(alpha: 0.5),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected
              ? colorScheme.primaryContainer.withValues(alpha: 0.3)
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected
                    ? colorScheme.primary.withValues(alpha: 0.1)
                    : colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  'Aa',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: 14 * scale.scale,
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    scale.label,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: isSelected ? colorScheme.primary : null,
                    ),
                  ),
                  Text(
                    '${(scale.scale * 100).round()}% of normal size',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: colorScheme.primary, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeSelector(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: AppThemeMode.values.map((mode) {
              final isSelected = _selectedTheme == mode;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: mode != AppThemeMode.values.last ? 8 : 0,
                  ),
                  child: InkWell(
                    onTap: () async {
                      setState(() => _selectedTheme = mode);
                      await getIt<SettingsService>().setThemeMode(mode);
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colorScheme.primaryContainer
                            : colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                        border: isSelected
                            ? Border.all(color: colorScheme.primary, width: 2)
                            : null,
                      ),
                      child: Column(
                        children: [
                          Icon(
                            _getThemeIcon(mode),
                            color: isSelected
                                ? colorScheme.onPrimaryContainer
                                : colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            mode.label,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: isSelected
                                  ? colorScheme.onPrimaryContainer
                                  : colorScheme.onSurfaceVariant,
                              fontWeight: isSelected ? FontWeight.w600 : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          Text(
            _selectedTheme.description,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getThemeIcon(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.system:
        return Icons.brightness_auto;
      case AppThemeMode.light:
        return Icons.light_mode;
      case AppThemeMode.dark:
        return Icons.dark_mode;
    }
  }
}

/// Security settings tab with key expiration thresholds.
class _SecurityTab extends StatefulWidget {
  const _SecurityTab();

  @override
  State<_SecurityTab> createState() => _SecurityTabState();
}

class _SecurityTabState extends State<_SecurityTab> {
  final _log = AppLogger('settings_security');
  final _grpcClient = getIt<GrpcClient>();
  late int _warningDays;
  late int _criticalDays;
  late int _agentTimeoutMinutes;
  bool _sshConfigEnabled = false;
  bool _sshConfigLoading = true;

  @override
  void initState() {
    super.initState();
    final settings = getIt<SettingsService>();
    _warningDays = settings.keyExpirationWarningDays;
    _criticalDays = settings.keyExpirationCriticalDays;
    _agentTimeoutMinutes = settings.agentKeyTimeoutMinutes;
    _loadSshConfigStatus();
  }

  Future<void> _loadSshConfigStatus() async {
    try {
      final status = await _grpcClient.config.getSshConfigStatus(
        GetSshConfigStatusRequest(),
      );
      if (mounted) {
        setState(() {
          _sshConfigEnabled = status.enabled;
          _sshConfigLoading = false;
        });
      }
    } catch (e, st) {
      _log.error('error loading SSH config status', e, st);
      if (mounted) {
        setState(() => _sshConfigLoading = false);
      }
    }
  }

  Future<void> _toggleSshConfig(bool enable) async {
    setState(() => _sshConfigLoading = true);

    try {
      if (enable) {
        final response = await _grpcClient.config.enableSshConfig(
          EnableSshConfigRequest(),
        );
        if (response.success) {
          _log.info('SSH config enabled');
          if (mounted) {
            setState(() {
              _sshConfigEnabled = true;
              _sshConfigLoading = false;
            });
          }
        } else {
          _log.error('failed to enable SSH config', null, null, {
            'message': response.message,
          });
          if (mounted) {
            setState(() => _sshConfigLoading = false);
            AppToast.error(
              context,
              message: 'Failed to enable: ${response.message}',
            );
          }
        }
      } else {
        final response = await _grpcClient.config.disableSshConfig(
          DisableSshConfigRequest(),
        );
        if (response.success) {
          _log.info('SSH config disabled');
          if (mounted) {
            setState(() {
              _sshConfigEnabled = false;
              _sshConfigLoading = false;
            });
          }
        } else {
          _log.error('failed to disable SSH config', null, null, {
            'message': response.message,
          });
          if (mounted) {
            setState(() => _sshConfigLoading = false);
            AppToast.error(
              context,
              message: 'Failed to disable: ${response.message}',
            );
          }
        }
      }
    } catch (e, st) {
      _log.error('error toggling SSH config', e, st);
      if (mounted) {
        setState(() => _sshConfigLoading = false);
        AppToast.error(context, message: 'Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Key Rotation Reminders', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            'Get notified when your SSH keys are due for rotation. '
            'Regular key rotation is a security best practice.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),

          // Warning threshold
          _buildThresholdSetting(
            context: context,
            title: 'Warning Threshold',
            description:
                'Show a warning icon when key age exceeds this many days',
            icon: Icons.warning_amber_rounded,
            iconColor: Colors.orange,
            value: _warningDays,
            onChanged: (value) async {
              setState(() => _warningDays = value);
              await getIt<SettingsService>().setKeyExpirationWarningDays(value);
            },
          ),

          const SizedBox(height: 20),

          // Critical threshold
          _buildThresholdSetting(
            context: context,
            title: 'Critical Threshold',
            description:
                'Show a critical alert when key age exceeds this many days',
            icon: Icons.error_rounded,
            iconColor: Colors.red,
            value: _criticalDays,
            onChanged: (value) async {
              setState(() => _criticalDays = value);
              await getIt<SettingsService>().setKeyExpirationCriticalDays(
                value,
              );
            },
          ),

          const SizedBox(height: 16),

          // Info box for key rotation thresholds
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, size: 20, color: colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Keys older than the warning threshold will show a yellow indicator. '
                    'Keys older than the critical threshold will show a pulsing red indicator.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Agent timeout section
          Text('SSH Agent Timeout', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            'Automatically remove keys from the agent after a specified time for security.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),

          // Agent timeout setting
          _buildAgentTimeoutSetting(context),

          const SizedBox(height: 32),

          // SSH Config Integration section
          Text('SSH Config Integration', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            'Configure your system to use skeys for all SSH connections.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),

          // SSH config toggle
          _buildSshConfigToggle(context),
        ],
      ),
    );
  }

  Widget _buildAgentTimeoutSetting(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.timer_outlined, color: colorScheme.primary, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Key Timeout', style: theme.textTheme.titleSmall),
                    const SizedBox(height: 2),
                    Text(
                      'Keys added to the agent will be automatically removed after this time',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: _agentTimeoutMinutes.toDouble(),
                  min: 0,
                  max: 480, // 8 hours max
                  divisions: 48, // 10 minute increments
                  onChanged: (v) async {
                    final rounded =
                        (v / 10).round() * 10; // Round to nearest 10
                    setState(() => _agentTimeoutMinutes = rounded);
                    await getIt<SettingsService>().setAgentKeyTimeoutMinutes(
                      rounded,
                    );
                  },
                ),
              ),
              SizedBox(
                width: 100,
                child: Text(
                  _agentTimeoutMinutes == 0
                      ? 'No timeout'
                      : _agentTimeoutMinutes >= 60
                      ? '${_agentTimeoutMinutes ~/ 60}h ${_agentTimeoutMinutes % 60}m'
                      : '$_agentTimeoutMinutes min',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSshConfigToggle(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.terminal, color: colorScheme.primary, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Use skeys for SSH',
                      style: theme.textTheme.titleSmall,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Add IdentityAgent directive to ~/.ssh/config',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (_sshConfigLoading)
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                Switch(value: _sshConfigEnabled, onChanged: _toggleSshConfig),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _sshConfigEnabled
                  ? colorScheme.primaryContainer.withValues(alpha: 0.3)
                  : colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  _sshConfigEnabled
                      ? Icons.check_circle_outline
                      : Icons.info_outline,
                  size: 18,
                  color: _sshConfigEnabled
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _sshConfigEnabled
                        ? 'SSH commands will use keys managed by skeys'
                        : 'Enable to use skeys as your SSH agent for git, ssh, scp, etc.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: _sshConfigEnabled
                          ? colorScheme.onPrimaryContainer
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThresholdSetting({
    required BuildContext context,
    required String title,
    required String description,
    required IconData icon,
    required Color iconColor,
    required int value,
    required ValueChanged<int> onChanged,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: theme.textTheme.titleSmall),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: value.toDouble(),
                  min: 7,
                  max: 365,
                  divisions: 358,
                  onChanged: (v) => onChanged(v.round()),
                ),
              ),
              SizedBox(
                width: 80,
                child: Text(
                  '$value days',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Logging settings tab.
class _LoggingTab extends StatefulWidget {
  const _LoggingTab();

  @override
  State<_LoggingTab> createState() => _LoggingTabState();
}

class _LoggingTabState extends State<_LoggingTab> {
  late Level _selectedLevel;

  @override
  void initState() {
    super.initState();
    _selectedLevel = getIt<SettingsService>().logLevel;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Log Level', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            'Controls the verbosity of application logs. Higher levels show more detail.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),

          // Log level options as styled cards
          ...Level.values
              .where(
                (l) => l != Level.off && l != Level.all && l != Level.fatal,
              )
              .map(
                (level) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _buildLogLevelCard(context, level),
                ),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, size: 20, color: colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Log level changes take effect immediately. Use Debug or Trace when troubleshooting issues.',
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
    );
  }

  Widget _buildLogLevelCard(BuildContext context, Level level) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = _selectedLevel == level;
    final description = _getLogLevelDescription(level);
    final icon = _getLogLevelIcon(level);
    final iconColor = _getLogLevelColor(level);

    return InkWell(
      onTap: () async {
        setState(() => _selectedLevel = level);
        await getIt<SettingsService>().setLogLevel(level);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.outline.withValues(alpha: 0.5),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected
              ? colorScheme.primaryContainer.withValues(alpha: 0.3)
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected
                    ? iconColor.withValues(alpha: 0.15)
                    : colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 20,
                color: isSelected ? iconColor : colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getLevelName(level),
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: isSelected ? colorScheme.primary : null,
                    ),
                  ),
                  Text(
                    description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: colorScheme.primary, size: 24),
          ],
        ),
      ),
    );
  }

  String _getLevelName(Level level) {
    switch (level) {
      case Level.trace:
        return 'Trace';
      case Level.debug:
        return 'Debug';
      case Level.info:
        return 'Info';
      case Level.warning:
        return 'Warning';
      case Level.error:
        return 'Error';
      default:
        return level.name;
    }
  }

  String _getLogLevelDescription(Level level) {
    switch (level) {
      case Level.trace:
        return 'Everything, very verbose';
      case Level.debug:
        return 'Detailed debugging information';
      case Level.info:
        return 'Important events (recommended)';
      case Level.warning:
        return 'Warnings and errors only';
      case Level.error:
        return 'Errors only';
      default:
        return '';
    }
  }

  IconData _getLogLevelIcon(Level level) {
    switch (level) {
      case Level.trace:
        return Icons.all_inclusive;
      case Level.debug:
        return Icons.bug_report_outlined;
      case Level.info:
        return Icons.info_outline;
      case Level.warning:
        return Icons.warning_amber_outlined;
      case Level.error:
        return Icons.error_outline;
      default:
        return Icons.circle_outlined;
    }
  }

  Color _getLogLevelColor(Level level) {
    switch (level) {
      case Level.trace:
        return Colors.grey;
      case Level.debug:
        return Colors.blue;
      case Level.info:
        return Colors.green;
      case Level.warning:
        return Colors.orange;
      case Level.error:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

/// Update settings tab for automatic updates.
class _UpdateTab extends StatefulWidget {
  const _UpdateTab();

  @override
  State<_UpdateTab> createState() => _UpdateTabState();
}

class _UpdateTabState extends State<_UpdateTab> {
  final _log = AppLogger('settings_update');
  final _grpcClient = getIt<GrpcClient>();

  UpdateSettings? _settings;
  UpdateStatus? _status;
  bool _loading = true;
  bool _checking = false;
  bool _downloading = false;
  String? _downloadedPath;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final settings = await _grpcClient.update.getUpdateSettings(Empty());
      final status = await _grpcClient.update.getUpdateStatus(Empty());
      if (mounted) {
        setState(() {
          _settings = settings;
          _status = status;
          _loading = false;
        });
      }
    } catch (e, st) {
      _log.error('error loading update data', e, st);
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _checkForUpdates() async {
    setState(() => _checking = true);
    try {
      await _grpcClient.update.checkForUpdates(Empty());
      // Reload status to get the result
      final status = await _grpcClient.update.getUpdateStatus(Empty());
      if (mounted) {
        setState(() {
          _status = status;
          _checking = false;
        });
        if (status.hasAvailableUpdate() &&
            status.availableUpdate.updateAvailable) {
          AppToast.success(
            context,
            message:
                'Update available: ${status.availableUpdate.latestVersion}',
          );
        } else {
          AppToast.info(context, message: 'You are running the latest version');
        }
      }
    } catch (e, st) {
      _log.error('error checking for updates', e, st);
      if (mounted) {
        setState(() => _checking = false);
        // Show user-friendly message based on error
        final errorStr = e.toString().toLowerCase();
        String message;
        if (errorStr.contains('no releases found')) {
          message = 'No releases available yet';
        } else if (errorStr.contains('network') ||
            errorStr.contains('socket')) {
          message = 'Network error - check your connection';
        } else {
          message = 'Failed to check for updates';
        }
        AppToast.error(context, message: message);
      }
    }
  }

  Future<void> _downloadUpdate() async {
    setState(() => _downloading = true);
    try {
      final stream = _grpcClient.update.downloadUpdate(DownloadUpdateRequest());
      await for (final progress in stream) {
        if (mounted) {
          setState(() {
            _status = _status?..downloadProgress = progress;
          });
        }
        if (progress.state == DownloadState.DOWNLOAD_STATE_COMPLETED) {
          _downloadedPath = progress.downloadedPath;
        }
        if (progress.state == DownloadState.DOWNLOAD_STATE_ERROR) {
          throw Exception(progress.error);
        }
      }
      if (mounted) {
        setState(() => _downloading = false);
        AppToast.success(context, message: 'Download complete');
        // Reload status
        final status = await _grpcClient.update.getUpdateStatus(Empty());
        setState(() => _status = status);
      }
    } catch (e, st) {
      _log.error('error downloading update', e, st);
      if (mounted) {
        setState(() => _downloading = false);
        AppToast.error(context, message: 'Download failed: $e');
      }
    }
  }

  Future<void> _applyUpdate() async {
    if (_downloadedPath == null) return;

    try {
      final response = await _grpcClient.update.applyUpdate(
        ApplyUpdateRequest(tarballPath: _downloadedPath),
      );
      if (mounted) {
        if (response.success) {
          AppToast.success(context, message: 'Update applied! Restarting...');
          // Give the toast time to display, then restart the app
          await Future.delayed(const Duration(seconds: 1));
          await _restartApp();
        } else {
          AppToast.error(context, message: 'Update failed: ${response.error}');
        }
      }
    } catch (e, st) {
      _log.error('error applying update', e, st);
      if (mounted) {
        AppToast.error(context, message: 'Failed to apply update');
      }
    }
  }

  Future<void> _restartApp() async {
    _log.info('restarting app after update');

    // Find the app executable - check common install locations
    final homeDir = Platform.environment['HOME'] ?? '';
    final possiblePaths = [
      '$homeDir/.local/share/skeys/skeys-app',
      '$homeDir/.local/bin/skeys-app',
      '/usr/local/bin/skeys-app',
      '/usr/bin/skeys-app',
    ];

    String? appPath;
    for (final path in possiblePaths) {
      if (await File(path).exists()) {
        appPath = path;
        break;
      }
    }

    if (appPath == null) {
      _log.warning('could not find app executable for restart');
      if (mounted) {
        AppToast.info(context, message: 'Please restart the app manually');
      }
      return;
    }

    _log.info('launching new app instance', {'path': appPath});

    // Start the new app process detached
    await Process.start(appPath, [], mode: ProcessStartMode.detached);

    // Exit the current app
    exit(0);
  }

  Future<void> _updateSettings(UpdateSettings newSettings) async {
    try {
      final updated = await _grpcClient.update.setUpdateSettings(newSettings);
      if (mounted) {
        setState(() => _settings = updated);
      }
    } catch (e, st) {
      _log.error('error saving update settings', e, st);
      if (mounted) {
        AppToast.error(context, message: 'Failed to save settings');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current status card
          _buildStatusCard(context),

          const SizedBox(height: 24),

          // Update settings
          Text('Automatic Updates', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            'Configure how updates are checked and applied.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),

          // Settings toggles
          _buildSettingTile(
            context: context,
            icon: Icons.search,
            title: 'Check automatically',
            description: 'Check for updates when daemon starts',
            value: _settings?.autoCheck ?? true,
            onChanged: (v) => _updateSettings(
              UpdateSettings(
                autoCheck: v,
                autoDownload: _settings?.autoDownload ?? false,
                autoApply: _settings?.autoApply ?? false,
                includePrereleases: _settings?.includePrereleases ?? false,
                checkIntervalHours: _settings?.checkIntervalHours ?? 24,
                includePatches: _settings?.includePatches ?? true,
              ),
            ),
          ),

          const SizedBox(height: 8),

          _buildSettingTile(
            context: context,
            icon: Icons.download_outlined,
            title: 'Download automatically',
            description: 'Download updates in the background',
            value: _settings?.autoDownload ?? false,
            onChanged: (v) => _updateSettings(
              UpdateSettings(
                autoCheck: _settings?.autoCheck ?? true,
                autoDownload: v,
                autoApply: _settings?.autoApply ?? false,
                includePrereleases: _settings?.includePrereleases ?? false,
                checkIntervalHours: _settings?.checkIntervalHours ?? 24,
                includePatches: _settings?.includePatches ?? true,
              ),
            ),
          ),

          const SizedBox(height: 8),

          _buildSettingTile(
            context: context,
            icon: Icons.system_update,
            title: 'Apply automatically',
            description: 'Install updates and restart daemon',
            value: _settings?.autoApply ?? false,
            onChanged: (v) => _updateSettings(
              UpdateSettings(
                autoCheck: _settings?.autoCheck ?? true,
                autoDownload: _settings?.autoDownload ?? false,
                autoApply: v,
                includePrereleases: _settings?.includePrereleases ?? false,
                checkIntervalHours: _settings?.checkIntervalHours ?? 24,
                includePatches: _settings?.includePatches ?? true,
              ),
            ),
          ),

          const SizedBox(height: 8),

          _buildSettingTile(
            context: context,
            icon: Icons.science_outlined,
            title: 'Include prereleases',
            description: 'Get beta and preview versions',
            value: _settings?.includePrereleases ?? false,
            onChanged: (v) => _updateSettings(
              UpdateSettings(
                autoCheck: _settings?.autoCheck ?? true,
                autoDownload: _settings?.autoDownload ?? false,
                autoApply: _settings?.autoApply ?? false,
                includePrereleases: v,
                checkIntervalHours: _settings?.checkIntervalHours ?? 24,
                includePatches: _settings?.includePatches ?? true,
              ),
            ),
          ),

          const SizedBox(height: 8),

          _buildSettingTile(
            context: context,
            icon: Icons.build_outlined,
            title: 'Include patch updates',
            description: 'Notify for minor bug fixes (x.x.1 → x.x.2)',
            value: _settings?.includePatches ?? true,
            onChanged: (v) => _updateSettings(
              UpdateSettings(
                autoCheck: _settings?.autoCheck ?? true,
                autoDownload: _settings?.autoDownload ?? false,
                autoApply: _settings?.autoApply ?? false,
                includePrereleases: _settings?.includePrereleases ?? false,
                checkIntervalHours: _settings?.checkIntervalHours ?? 24,
                includePatches: v,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final hasUpdate =
        _status?.hasAvailableUpdate() == true &&
        _status!.availableUpdate.updateAvailable;
    final isDownloading =
        _downloading || _status?.state == UpdateState.UPDATE_STATE_DOWNLOADING;
    final isReady = _status?.state == UpdateState.UPDATE_STATE_READY_TO_APPLY;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: hasUpdate
              ? colorScheme.primary
              : colorScheme.outline.withValues(alpha: 0.5),
          width: hasUpdate ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
        color: hasUpdate
            ? colorScheme.primaryContainer.withValues(alpha: 0.2)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                hasUpdate ? Icons.system_update : Icons.check_circle_outline,
                color: hasUpdate ? colorScheme.primary : Colors.green,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hasUpdate ? 'Update Available' : 'Up to Date',
                      style: theme.textTheme.titleSmall,
                    ),
                    if (hasUpdate)
                      Text(
                        'Version ${_status!.availableUpdate.latestVersion}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.primary,
                        ),
                      ),
                  ],
                ),
              ),
              if (_checking)
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else if (isDownloading)
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else if (isReady)
                FilledButton(
                  onPressed: _applyUpdate,
                  child: const Text('Install'),
                )
              else if (hasUpdate)
                FilledButton.tonal(
                  onPressed: _downloadUpdate,
                  child: const Text('Download'),
                )
              else
                TextButton(
                  onPressed: _checkForUpdates,
                  child: const Text('Check Now'),
                ),
            ],
          ),
          if (isDownloading && _status?.hasDownloadProgress() == true) ...[
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: _status!.downloadProgress.totalBytes.toInt() > 0
                  ? _status!.downloadProgress.bytesDownloaded.toInt() /
                        _status!.downloadProgress.totalBytes.toInt()
                  : null,
            ),
            const SizedBox(height: 4),
            Text(
              _formatBytes(_status!.downloadProgress.bytesDownloaded.toInt()),
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSettingTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: colorScheme.onSurfaceVariant, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.bodyMedium),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

/// About tab with version cards for Flutter app and Go backend.
class _AboutTab extends StatefulWidget {
  const _AboutTab();

  @override
  State<_AboutTab> createState() => _AboutTabState();
}

class _AboutTabState extends State<_AboutTab> {
  final _log = AppLogger('settings_about');
  final _grpcClient = getIt<GrpcClient>();

  PackageInfo? _packageInfo;
  VersionInfo? _backendVersion;
  bool _loadingApp = true;
  bool _loadingBackend = true;

  @override
  void initState() {
    super.initState();
    _loadVersions();
  }

  Future<void> _loadVersions() async {
    // Load app version
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      if (mounted) {
        setState(() {
          _packageInfo = packageInfo;
          _loadingApp = false;
        });
      }
    } catch (e, st) {
      _log.error('error loading app version', e, st);
      if (mounted) {
        setState(() => _loadingApp = false);
      }
    }

    // Load backend version
    try {
      final versionInfo = await _grpcClient.version.getVersion(Empty());
      if (mounted) {
        setState(() {
          _backendVersion = versionInfo;
          _loadingBackend = false;
        });
      }
    } catch (e, st) {
      _log.error('error loading backend version', e, st);
      if (mounted) {
        setState(() => _loadingBackend = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // App header
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/images/skeys_icon.png',
                  width: 48,
                  height: 48,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SKeys',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'SSH Key Manager',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Flutter App Card
          _buildVersionCard(
            context: context,
            icon: Icons.flutter_dash,
            iconColor: const Color(0xFF02569B),
            title: 'Flutter App',
            isLoading: _loadingApp,
            rows: _packageInfo != null
                ? [
                    _VersionRow('Version', _packageInfo!.version),
                    _VersionRow('Build', _packageInfo!.buildNumber),
                    _VersionRow('Dart', _getDartVersion()),
                  ]
                : [],
          ),

          const SizedBox(height: 12),

          // Core Library Card
          _buildVersionCard(
            context: context,
            icon: Icons.library_books_outlined,
            iconColor: const Color(0xFF00ADD8),
            title: 'Core Library',
            isLoading: _loadingBackend,
            rows: _backendVersion != null
                ? [
                    _VersionRow('Version', _backendVersion!.coreVersion),
                    _VersionRow(
                      'Commit',
                      _formatCommit(_backendVersion!.coreCommit),
                    ),
                  ]
                : [],
          ),

          const SizedBox(height: 12),

          // Go Daemon Card
          _buildVersionCard(
            context: context,
            icon: Icons.dns_outlined,
            iconColor: const Color(0xFF00ADD8),
            title: 'Go Daemon',
            isLoading: _loadingBackend,
            rows: _backendVersion != null
                ? [
                    _VersionRow('Version', _backendVersion!.daemonVersion),
                    _VersionRow(
                      'Commit',
                      _formatCommit(_backendVersion!.daemonCommit),
                    ),
                    _VersionRow('Go', _backendVersion!.goVersion),
                  ]
                : [],
          ),

          const SizedBox(height: 16),

          // Tagline
          Center(
            child: Text(
              'Keep your SSH keys on track!',
              style: theme.textTheme.bodySmall?.copyWith(
                fontStyle: FontStyle.italic,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVersionCard({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required bool isLoading,
    required List<_VersionRow> rows,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (isLoading)
            const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else if (rows.isEmpty)
            Text(
              'Unable to load version info',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.error,
              ),
            )
          else
            ...rows.map(
              (row) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    SizedBox(
                      width: 70,
                      child: Text(
                        row.label,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        row.value,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _getDartVersion() {
    // Extract Dart version from Platform
    final version = Platform.version;
    // Format: "3.5.0 (stable) ..." - extract just the version number
    final match = RegExp(r'^(\d+\.\d+\.\d+)').firstMatch(version);
    return match?.group(1) ?? version.split(' ').first;
  }

  String _formatCommit(String commit) {
    // Show first 7 characters of commit hash
    if (commit.length > 7) {
      return commit.substring(0, 7);
    }
    return commit;
  }
}

class _VersionRow {
  final String label;
  final String value;
  const _VersionRow(this.label, this.value);
}

/// Backup tab.
class _BackupTab extends StatelessWidget {
  const _BackupTab();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Backup & Restore', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            'Export your SSH keys and configuration to transfer to another computer, or restore from a previous backup.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),

          // Export section
          _buildActionCard(
            context: context,
            icon: Icons.upload_file,
            title: 'Export Backup',
            description:
                'Create an encrypted backup of your SSH keys, config, and known hosts.',
            buttonLabel: 'Export',
            onPressed: () {
              Navigator.of(context).pop();
              ExportDialog.show(context);
            },
          ),

          const SizedBox(height: 16),

          // Import section
          _buildActionCard(
            context: context,
            icon: Icons.download,
            title: 'Import Backup',
            description:
                'Restore SSH keys and configuration from a backup file.',
            buttonLabel: 'Import',
            onPressed: () {
              Navigator.of(context).pop();
              ImportDialog.show(context);
            },
          ),

          const SizedBox(height: 24),

          // Security note
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.shield_outlined,
                  size: 20,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Backups are encrypted with AES-256-GCM',
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
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
    required String buttonLabel,
    required VoidCallback onPressed,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: colorScheme.onPrimaryContainer),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleSmall),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          FilledButton.tonal(onPressed: onPressed, child: Text(buttonLabel)),
        ],
      ),
    );
  }
}
