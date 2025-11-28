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
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/notifications/app_toast.dart';
import '../../bloc/config_bloc.dart';
import '../../domain/sshd_directives.dart';
import 'server_directive_dialog.dart';

/// Server config tab with expandable sections for all SSH server settings.
class ServerConfigTab extends StatefulWidget {
  /// The current config state.
  final ConfigState state;

  /// Creates a ServerConfigTab widget.
  const ServerConfigTab({super.key, required this.state});

  @override
  State<ServerConfigTab> createState() => _ServerConfigTabState();
}

class _ServerConfigTabState extends State<ServerConfigTab> {
  final Set<String> _expandedSections = {'authentication', 'network'};
  bool _showAdvanced = false;

  @override
  Widget build(BuildContext context) {
    if (widget.state.serverConfig == null) {
      return _buildEmptyState(context);
    }

    return Column(
      children: [
        // Fixed header with info and controls
        _buildHeader(context),
        // Scrollable category sections
        Expanded(
          child: CustomScrollView(
            slivers: [
              // Expandable category sections
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final category = sshdDirectiveCategories[index];
                  return _buildCategorySection(context, category);
                }, childCount: sshdDirectiveCategories.length),
              ),
              // Bottom padding
              const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.dns_outlined,
              size: 64,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Server Configuration',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Load your SSH server settings to configure sshd',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () {
              context.read<ConfigBloc>().add(
                const ConfigLoadServerConfigRequested(),
              );
            },
            icon: const Icon(Icons.download),
            label: const Text('Load Server Config'),
          ),
          const SizedBox(height: 12),
          Text(
            'Requires root/sudo access',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final pendingRestart = widget.state.serverConfigPendingRestart;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.dns, color: colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SSH Server Configuration',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        widget.state.serverConfig?.path ??
                            '/etc/ssh/sshd_config',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
                // Show advanced toggle
                FilterChip(
                  label: const Text('Advanced'),
                  selected: _showAdvanced,
                  onSelected: (value) => setState(() => _showAdvanced = value),
                  avatar: Icon(
                    _showAdvanced ? Icons.visibility : Icons.visibility_off,
                    size: 18,
                  ),
                ),
                // Restart button (only show when changes pending)
                if (pendingRestart) ...[
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    onPressed: () => _restartSSHServer(context),
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text('Restart SSH'),
                    style: FilledButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),
            // Info/warning banner
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: pendingRestart
                    ? colorScheme.errorContainer.withValues(alpha: 0.3)
                    : colorScheme.primaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    pendingRestart ? Icons.warning_amber : Icons.info_outline,
                    size: 18,
                    color: pendingRestart
                        ? colorScheme.error
                        : colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      pendingRestart
                          ? 'Configuration changed. Restart the SSH service to apply changes.'
                          : 'Changes require restarting the SSH service to take effect.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: pendingRestart
                            ? colorScheme.error
                            : colorScheme.onSurface,
                        fontWeight: pendingRestart ? FontWeight.w500 : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _restartSSHServer(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Restart SSH Server'),
        content: const Text(
          'This will restart the SSH service to apply your configuration changes. '
          'Active SSH connections may be briefly interrupted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<ConfigBloc>().add(
                const ConfigRestartSSHServerRequested(),
              );
              AppToast.success(context, message: 'SSH service restarting...');
            },
            child: const Text('Restart'),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(
    BuildContext context,
    SshdDirectiveCategory category,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isExpanded = _expandedSections.contains(category.id);

    // Filter directives based on advanced toggle
    final visibleDirectives = _showAdvanced
        ? category.directives
        : category.directives.where((d) => !d.isAdvanced).toList();

    if (visibleDirectives.isEmpty) return const SizedBox.shrink();

    // Count configured directives in this category (only visible ones)
    final configuredCount = _getConfiguredDirectivesInCategory(
      category,
      visibleDirectives,
    );

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          InkWell(
            onTap: () => setState(() {
              if (isExpanded) {
                _expandedSections.remove(category.id);
              } else {
                _expandedSections.add(category.id);
              }
            }),
            borderRadius: BorderRadius.vertical(
              top: const Radius.circular(12),
              bottom: isExpanded ? Radius.zero : const Radius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  _buildCategoryIcon(category.id, colorScheme),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          category.description,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: configuredCount > 0
                          ? colorScheme.primaryContainer
                          : colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$configuredCount / ${visibleDirectives.length}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: configuredCount > 0
                            ? colorScheme.onPrimaryContainer
                            : colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
          // Content
          if (isExpanded) ...[
            Divider(height: 1, color: colorScheme.outlineVariant),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: visibleDirectives.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                indent: 16,
                endIndent: 16,
                color: colorScheme.outlineVariant,
              ),
              itemBuilder: (context, index) {
                final directive = visibleDirectives[index];
                return _ServerDirectiveListTile(
                  directive: directive,
                  currentValue: _getCurrentValue(directive.key),
                  onEdit: () => _showEditDirectiveDialog(context, directive),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCategoryIcon(String categoryId, ColorScheme colorScheme) {
    final IconData iconData;
    switch (categoryId) {
      case 'network':
        iconData = Icons.lan;
        break;
      case 'authentication':
        iconData = Icons.lock;
        break;
      case 'publickey':
        iconData = Icons.key;
        break;
      case 'hostkeys':
        iconData = Icons.vpn_key;
        break;
      case 'crypto':
        iconData = Icons.enhanced_encryption;
        break;
      case 'access':
        iconData = Icons.people;
        break;
      case 'session':
        iconData = Icons.terminal;
        break;
      case 'forwarding':
        iconData = Icons.arrow_forward;
        break;
      case 'x11':
        iconData = Icons.desktop_windows;
        break;
      case 'sftp':
        iconData = Icons.folder_shared;
        break;
      case 'logging':
        iconData = Icons.description;
        break;
      case 'gssapi':
        iconData = Icons.security;
        break;
      case 'security':
        iconData = Icons.shield;
        break;
      case 'daemon':
        iconData = Icons.settings_applications;
        break;
      default:
        iconData = Icons.settings;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(iconData, color: colorScheme.onPrimaryContainer, size: 20),
    );
  }

  int _getConfiguredDirectivesInCategory(
    SshdDirectiveCategory category,
    List<SshdDirectiveDefinition> visibleDirectives,
  ) {
    if (widget.state.serverConfig == null) return 0;
    final configuredKeys = widget.state.serverConfig!.options
        .map((o) => o.key)
        .toSet();
    return visibleDirectives
        .where((d) => configuredKeys.contains(d.key))
        .length;
  }

  String? _getCurrentValue(String key) {
    if (widget.state.serverConfig == null) return null;
    try {
      return widget.state.serverConfig!.options
          .firstWhere((o) => o.key == key)
          .value;
    } catch (_) {
      return null;
    }
  }

  void _showEditDirectiveDialog(
    BuildContext context,
    SshdDirectiveDefinition directive,
  ) {
    final currentValue = _getCurrentValue(directive.key);
    showDialog(
      context: context,
      builder: (dialogContext) => ServerDirectiveDialog(
        directiveKey: directive.key,
        currentValue: currentValue,
        onSave: (value) {
          context.read<ConfigBloc>().add(
            ConfigUpdateServerOptionRequested(key: directive.key, value: value),
          );
        },
      ),
    );
  }
}

/// List tile for a server directive.
class _ServerDirectiveListTile extends StatelessWidget {
  final SshdDirectiveDefinition directive;
  final String? currentValue;
  final VoidCallback onEdit;

  const _ServerDirectiveListTile({
    required this.directive,
    this.currentValue,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isConfigured = currentValue != null;
    final displayValue = currentValue ?? directive.defaultValue;
    final isDefault =
        currentValue == null || currentValue == directive.defaultValue;

    return InkWell(
      onTap: onEdit,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Configured indicator
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isConfigured
                    ? colorScheme.primary
                    : colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
            const SizedBox(width: 12),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        directive.key,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (directive.isAdvanced) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.tertiaryContainer,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Advanced',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.onTertiaryContainer,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    directive.description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Value
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isDefault
                    ? colorScheme.surfaceContainerHighest
                    : colorScheme.primaryContainer.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
                border: isDefault
                    ? null
                    : Border.all(
                        color: colorScheme.primary.withValues(alpha: 0.3),
                      ),
              ),
              child: Text(
                _formatDisplayValue(displayValue),
                style: theme.textTheme.bodySmall?.copyWith(
                  fontFamily: 'monospace',
                  color: isDefault
                      ? colorScheme.onSurfaceVariant
                      : colorScheme.primary,
                  fontWeight: isDefault ? FontWeight.normal : FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right,
              color: colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDisplayValue(String value) {
    // Truncate long values
    if (value.length > 20) {
      return '${value.substring(0, 17)}...';
    }
    return value;
  }
}
