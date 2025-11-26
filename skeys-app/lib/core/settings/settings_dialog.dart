import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../backup/export_dialog.dart';
import '../backup/import_dialog.dart';
import '../di/injection.dart';
import 'settings_service.dart';

/// Settings dialog with tabbed interface.
class SettingsDialog extends StatefulWidget {
  const SettingsDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => const SettingsDialog(),
    );
  }

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 500,
          maxHeight: 400,
        ),
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
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            // Tabs
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(
                  icon: Icon(Icons.text_fields_outlined),
                  text: 'Display',
                ),
                Tab(
                  icon: Icon(Icons.backup_outlined),
                  text: 'Backup',
                ),
                Tab(
                  icon: Icon(Icons.article_outlined),
                  text: 'Logging',
                ),
                Tab(
                  icon: Icon(Icons.info_outline),
                  text: 'About',
                ),
              ],
            ),
            // Tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  _DisplayTab(),
                  _BackupTab(),
                  _LoggingTab(),
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

  @override
  void initState() {
    super.initState();
    _selectedScale = getIt<SettingsService>().textScale;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Text Size',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Adjust the text size throughout the application for better readability.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 16),
          ...TextScale.values.map((scale) => _buildTextScaleOption(scale)),
          const SizedBox(height: 24),
          // Preview
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Preview',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sample text at ${_selectedScale.label.toLowerCase()} size',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 14 * _selectedScale.scale,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextScaleOption(TextScale scale) {
    return RadioListTile<TextScale>(
      value: scale,
      groupValue: _selectedScale,
      onChanged: (value) async {
        if (value != null) {
          setState(() => _selectedScale = value);
          await getIt<SettingsService>().setTextScale(value);
        }
      },
      title: Text(scale.label),
      subtitle: Text(
        '${(scale.scale * 100).round()}%',
        style: Theme.of(context).textTheme.bodySmall,
      ),
      dense: true,
      contentPadding: EdgeInsets.zero,
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Log Level',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Controls the verbosity of application logs. Higher levels show more detail.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 16),
          ...Level.values
              .where((l) => l != Level.off && l != Level.all && l != Level.fatal)
              .map((level) => _buildLogLevelOption(level)),
        ],
      ),
    );
  }

  Widget _buildLogLevelOption(Level level) {
    final isSelected = _selectedLevel == level;
    final description = _getLogLevelDescription(level);

    return RadioListTile<Level>(
      value: level,
      groupValue: _selectedLevel,
      onChanged: (value) async {
        if (value != null) {
          setState(() => _selectedLevel = value);
          await getIt<SettingsService>().setLogLevel(value);
        }
      },
      title: Text(_getLevelName(level)),
      subtitle: Text(
        description,
        style: Theme.of(context).textTheme.bodySmall,
      ),
      dense: true,
      contentPadding: EdgeInsets.zero,
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
}

/// About tab.
class _AboutTab extends StatelessWidget {
  const _AboutTab();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.vpn_key,
                size: 48,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SKeys',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Text(
                    'SSH Key Manager',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildInfoRow(context, 'Version', '1.0.0'),
          _buildInfoRow(context, 'Flutter', 'SDK ${_getFlutterVersion()}'),
          const Spacer(),
          Text(
            'Keep your SSH keys on track!',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          Text(value),
        ],
      ),
    );
  }

  String _getFlutterVersion() {
    // This would ideally come from package_info_plus
    return '3.x';
  }
}

/// Backup tab.
class _BackupTab extends StatelessWidget {
  const _BackupTab();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Backup & Restore',
            style: theme.textTheme.titleMedium,
          ),
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
            description: 'Create an encrypted backup of your SSH keys, config, and known hosts.',
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
            description: 'Restore SSH keys and configuration from a backup file.',
            buttonLabel: 'Import',
            onPressed: () {
              Navigator.of(context).pop();
              ImportDialog.show(context);
            },
          ),

          const Spacer(),

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
                Text(
                  title,
                  style: theme.textTheme.titleSmall,
                ),
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
          FilledButton.tonal(
            onPressed: onPressed,
            child: Text(buttonLabel),
          ),
        ],
      ),
    );
  }
}
