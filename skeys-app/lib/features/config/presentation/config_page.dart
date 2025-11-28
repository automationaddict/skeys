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

import '../../../core/di/injection.dart';
import '../../../core/help/help_context_service.dart';
import '../bloc/config_bloc.dart';
import '../domain/config_entity.dart';
import '../domain/ssh_config_entry.dart';
import 'widgets/global_directive_dialog.dart';
import 'widgets/server_config_tab.dart';
import 'widgets/ssh_config_dialog.dart';

/// Page for SSH configuration management.
///
/// Displays client SSH config (Host entries and global directives) and server
/// SSH config (sshd_config options) in a tabbed interface.
class ConfigPage extends StatefulWidget {
  /// Creates a ConfigPage widget.
  const ConfigPage({super.key});

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _helpContextService = getIt<HelpContextService>();

  static const _tabContexts = ['client', 'server'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);
    // Set initial context
    _helpContextService.setContextSuffix(_tabContexts[0]);
    // Load global directives (watch is auto-started by BLoC singleton)
    context.read<ConfigBloc>().add(const ConfigLoadGlobalDirectivesRequested());
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) {
      _helpContextService.setContextSuffix(_tabContexts[_tabController.index]);
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    _helpContextService.clearContext();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SSH Configuration'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Client Config'),
            Tab(text: 'Server Config'),
          ],
        ),
      ),
      body: BlocBuilder<ConfigBloc, ConfigState>(
        builder: (context, state) {
          return TabBarView(
            controller: _tabController,
            children: [
              _ClientConfigTab(state: state),
              ServerConfigTab(state: state),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEntryDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Host'),
      ),
    );
  }

  void _showAddEntryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => SSHConfigDialog(
        onSave: (entry) {
          context.read<ConfigBloc>().add(ConfigCreateSSHEntryRequested(entry));
        },
      ),
    );
  }
}

/// Client config tab with Global Settings section and reorderable SSH config entries.
class _ClientConfigTab extends StatefulWidget {
  final ConfigState state;

  const _ClientConfigTab({required this.state});

  @override
  State<_ClientConfigTab> createState() => _ClientConfigTabState();
}

class _ClientConfigTabState extends State<_ClientConfigTab> {
  List<SSHConfigEntry>? _localEntries;
  bool _globalSettingsExpanded = true;

  @override
  void didUpdateWidget(_ClientConfigTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reset local entries when state changes (e.g., after reorder completes)
    if (widget.state.sshEntries != oldWidget.state.sshEntries) {
      _localEntries = null;
    }
  }

  List<SSHConfigEntry> get _entries => _localEntries ?? widget.state.sshEntries;

  @override
  Widget build(BuildContext context) {
    if (widget.state.status == ConfigStatus.loading &&
        widget.state.sshEntries.isEmpty &&
        widget.state.globalDirectives.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return CustomScrollView(
      slivers: [
        // Global Settings Section
        SliverToBoxAdapter(child: _buildGlobalSettingsSection(context)),
        // Host Configurations Section Header
        SliverToBoxAdapter(child: _buildHostConfigurationsHeader(context)),
        // Host Configurations List
        if (_entries.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: _buildEmptyHostsState(context),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverReorderableList(
              itemCount: _entries.length,
              onReorder: _onReorder,
              proxyDecorator: _proxyDecorator,
              itemBuilder: (context, index) {
                final entry = _entries[index];
                return ReorderableDragStartListener(
                  key: ValueKey(entry.id),
                  index: index,
                  child: _SSHConfigEntryCard(
                    entry: entry,
                    onEdit: () => _showEditEntryDialog(context, entry),
                    onDelete: () => _showDeleteConfirmation(context, entry),
                  ),
                );
              },
            ),
          ),
        // Bottom padding
        const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
      ],
    );
  }

  Widget _buildGlobalSettingsSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          InkWell(
            onTap: () => setState(
              () => _globalSettingsExpanded = !_globalSettingsExpanded,
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.settings, color: colorScheme.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Global Settings',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Options that apply to all SSH connections',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => _showAddGlobalDirectiveDialog(context),
                    tooltip: 'Add directive',
                  ),
                  Icon(
                    _globalSettingsExpanded
                        ? Icons.expand_less
                        : Icons.expand_more,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
          // Content
          if (_globalSettingsExpanded) ...[
            Divider(height: 1, color: colorScheme.outlineVariant),
            if (widget.state.globalDirectives.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    'No global directives configured',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.outline,
                    ),
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: widget.state.globalDirectives.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                  color: colorScheme.outlineVariant,
                ),
                itemBuilder: (context, index) {
                  final directive = widget.state.globalDirectives[index];
                  return _GlobalDirectiveListTile(
                    directive: directive,
                    onEdit: () =>
                        _showEditGlobalDirectiveDialog(context, directive),
                    onDelete: () => _showDeleteGlobalDirectiveConfirmation(
                      context,
                      directive,
                    ),
                  );
                },
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildHostConfigurationsHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Row(
        children: [
          Icon(Icons.dns, color: colorScheme.primary, size: 20),
          const SizedBox(width: 8),
          Text(
            'Host Configurations',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '(${_entries.length})',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const Spacer(),
          Tooltip(
            message: 'SSH config uses "first match wins" - drag to reorder',
            child: Icon(
              Icons.info_outline,
              size: 18,
              color: colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyHostsState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.dns_outlined, size: 48, color: colorScheme.outline),
          const SizedBox(height: 16),
          Text('No SSH hosts configured', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            'Click "Add Host" to create a new host configuration',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }

  Widget _proxyDecorator(Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final elevation = Tween<double>(begin: 0, end: 8).evaluate(animation);
        return Material(
          elevation: elevation,
          borderRadius: BorderRadius.circular(12),
          child: child,
        );
      },
      child: child,
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    // Adjust for the removal
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    // Update local state immediately for smooth UX
    setState(() {
      _localEntries = List.from(_entries);
      final item = _localEntries!.removeAt(oldIndex);
      _localEntries!.insert(newIndex, item);
    });

    // Send reorder request to backend
    final entryIds = _localEntries!.map((e) => e.id).toList();
    context.read<ConfigBloc>().add(ConfigReorderSSHEntriesRequested(entryIds));
  }

  void _showAddGlobalDirectiveDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => GlobalDirectiveDialog(
        onSave: (key, value) {
          context.read<ConfigBloc>().add(
            ConfigSetGlobalDirectiveRequested(key: key, value: value),
          );
        },
      ),
    );
  }

  void _showEditGlobalDirectiveDialog(
    BuildContext context,
    GlobalDirective directive,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => GlobalDirectiveDialog(
        directive: directive,
        onSave: (key, value) {
          context.read<ConfigBloc>().add(
            ConfigSetGlobalDirectiveRequested(key: key, value: value),
          );
        },
      ),
    );
  }

  void _showDeleteGlobalDirectiveConfirmation(
    BuildContext context,
    GlobalDirective directive,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Directive'),
        content: Text(
          'Are you sure you want to delete "${directive.key}"?\n\n'
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<ConfigBloc>().add(
                ConfigDeleteGlobalDirectiveRequested(directive.key),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showEditEntryDialog(BuildContext context, SSHConfigEntry entry) {
    showDialog(
      context: context,
      builder: (dialogContext) => SSHConfigDialog(
        entry: entry,
        onSave: (updatedEntry) {
          context.read<ConfigBloc>().add(
            ConfigUpdateSSHEntryRequested(id: entry.id, entry: updatedEntry),
          );
        },
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, SSHConfigEntry entry) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Entry'),
        content: Text(
          'Are you sure you want to delete "${entry.displayName}"?\n\n'
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<ConfigBloc>().add(
                ConfigDeleteSSHEntryRequested(entry.id),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

/// List tile for displaying a global directive.
class _GlobalDirectiveListTile extends StatelessWidget {
  final GlobalDirective directive;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _GlobalDirectiveListTile({
    required this.directive,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListTile(
      onTap: onEdit,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          _getDirectiveIcon(directive.key),
          color: colorScheme.primary,
          size: 18,
        ),
      ),
      title: Text(
        directive.key,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        directive.value,
        style: theme.textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
          fontFamily: 'monospace',
        ),
      ),
      trailing: PopupMenuButton<String>(
        onSelected: (value) {
          if (value == 'edit') {
            onEdit();
          } else if (value == 'delete') {
            onDelete();
          }
        },
        itemBuilder: (context) => [
          const PopupMenuItem(value: 'edit', child: Text('Edit')),
          const PopupMenuItem(value: 'delete', child: Text('Delete')),
        ],
      ),
    );
  }

  IconData _getDirectiveIcon(String key) {
    final lowerKey = key.toLowerCase();
    if (lowerKey.contains('hash') || lowerKey.contains('known')) {
      return Icons.tag;
    }
    if (lowerKey.contains('identity') || lowerKey.contains('key')) {
      return Icons.vpn_key;
    }
    if (lowerKey.contains('forward') || lowerKey.contains('agent')) {
      return Icons.forward;
    }
    if (lowerKey.contains('connect') || lowerKey.contains('timeout')) {
      return Icons.timer;
    }
    if (lowerKey.contains('compression')) {
      return Icons.compress;
    }
    if (lowerKey.contains('alive') || lowerKey.contains('keep')) {
      return Icons.favorite;
    }
    if (lowerKey.contains('batch') || lowerKey.contains('password')) {
      return Icons.password;
    }
    return Icons.tune;
  }
}

/// Card widget for displaying an SSH config entry.
class _SSHConfigEntryCard extends StatelessWidget {
  final SSHConfigEntry entry;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _SSHConfigEntryCard({
    required this.entry,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onEdit,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Drag handle (parent ReorderableDragStartListener handles actual dragging)
              Icon(Icons.drag_handle, color: colorScheme.outline),
              const SizedBox(width: 12),
              // Entry type icon
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getTypeColor(colorScheme).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getTypeIcon(),
                  color: _getTypeColor(colorScheme),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              // Entry details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          entry.displayName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (entry.isWildcard) ...[
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
                              'Pattern',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: colorScheme.onTertiaryContainer,
                              ),
                            ),
                          ),
                        ],
                        if (entry.isCatchAll) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.secondaryContainer,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Default',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: colorScheme.onSecondaryContainer,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _buildSubtitle(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (entry.options.advancedOptionsCount > 0) ...[
                      const SizedBox(height: 4),
                      Text(
                        '${entry.options.advancedOptionsCount} advanced option${entry.options.advancedOptionsCount > 1 ? 's' : ''}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              // Actions
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    onEdit();
                  } else if (value == 'delete') {
                    onDelete();
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Text('Edit')),
                  const PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getTypeIcon() {
    if (entry.isCatchAll) return Icons.public;
    if (entry.isWildcard) return Icons.pattern;
    if (entry.type == SSHConfigEntryType.match) return Icons.filter_alt;
    return Icons.dns;
  }

  Color _getTypeColor(ColorScheme colorScheme) {
    if (entry.isCatchAll) return colorScheme.secondary;
    if (entry.isWildcard) return colorScheme.tertiary;
    if (entry.type == SSHConfigEntryType.match) return colorScheme.primary;
    return colorScheme.primary;
  }

  String _buildSubtitle() {
    final parts = <String>[];

    if (entry.options.user != null) {
      parts.add(entry.options.user!);
    }

    if (entry.options.hostname != null) {
      if (parts.isNotEmpty) {
        parts.add('@${entry.options.hostname}');
      } else {
        parts.add(entry.options.hostname!);
      }
    }

    if (entry.options.port != null) {
      parts.add(':${entry.options.port}');
    }

    if (entry.options.primaryIdentityFile != null) {
      final keyName = entry.options.primaryIdentityFile!.split('/').last;
      if (parts.isNotEmpty) {
        parts.add(' • $keyName');
      } else {
        parts.add(keyName);
      }
    }

    if (parts.isEmpty) {
      return entry.type == SSHConfigEntryType.match
          ? 'Match block'
          : 'Host entry';
    }

    return parts.join('');
  }
}
