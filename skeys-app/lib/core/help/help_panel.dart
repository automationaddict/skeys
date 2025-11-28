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
import 'package:flutter_markdown/flutter_markdown.dart';

import '../di/injection.dart';
import '../settings/settings_service.dart';
import 'help_context_service.dart';
import 'help_navigation_service.dart';
import 'help_service.dart';

/// A flyout panel for displaying context-aware help documentation.
///
/// This panel slides in from the right side of the screen and displays
/// markdown-formatted help content based on the current route and context.
/// It supports searching, topic navigation, and handling of internal links.
class HelpPanel extends StatefulWidget {
  /// The base route to derive help content from.
  final String baseRoute;

  /// Callback invoked when the user closes the help panel.
  final VoidCallback onClose;

  /// The help service used to load and search documentation.
  final HelpService helpService;

  /// Optional override route to show instead of the base route.
  /// Used when navigating to help from dialogs.
  final String? overrideRoute;

  /// Creates a HelpPanel widget.
  const HelpPanel({
    super.key,
    required this.baseRoute,
    required this.onClose,
    required this.helpService,
    this.overrideRoute,
  });

  @override
  State<HelpPanel> createState() => _HelpPanelState();
}

class _HelpPanelState extends State<HelpPanel> {
  final _searchController = TextEditingController();
  final _settingsService = getIt<SettingsService>();
  final _helpContextService = getIt<HelpContextService>();
  final _helpNavService = getIt<HelpNavigationService>();
  String _content = '';
  String _currentDocName = '';
  String _currentRoute = '';
  bool _isLoading = true;
  List<SearchResult> _searchResults = [];
  bool _isSearching = false;
  late double _panelWidth;

  /// Temporary override route (cleared when user navigates normally).
  String? _overrideRoute;

  @override
  void initState() {
    super.initState();
    _panelWidth = _settingsService.helpPanelWidth;
    _helpContextService.addListener(_onContextChanged);
    _helpNavService.addListener(_onHelpNavigationChanged);

    // Check for pending help navigation (e.g., from settings dialog)
    if (_helpNavService.pendingShowHelp &&
        _helpNavService.pendingHelpRoute != null) {
      _overrideRoute = _helpNavService.pendingHelpRoute;
      _helpNavService.clearPendingHelp();
    } else {
      _overrideRoute = widget.overrideRoute;
    }

    _updateCurrentRoute();
    _loadHelpForCurrentRoute();
  }

  void _onContextChanged() {
    // Clear override when context changes (user navigated to different page)
    _overrideRoute = null;
    _updateCurrentRoute();
    _loadHelpForCurrentRoute();
  }

  void _onHelpNavigationChanged() {
    // Check for pending help navigation
    if (_helpNavService.pendingShowHelp &&
        _helpNavService.pendingHelpRoute != null) {
      final route = _helpNavService.pendingHelpRoute!;
      _helpNavService.clearPendingHelp();

      setState(() {
        _overrideRoute = route;
      });
      _updateCurrentRoute();
      _loadHelpForCurrentRoute();
    }
  }

  void _updateCurrentRoute() {
    if (_overrideRoute != null) {
      _currentRoute = _overrideRoute!;
    } else {
      _currentRoute = _helpContextService.buildHelpRoute(widget.baseRoute);
    }
  }

  @override
  void didUpdateWidget(HelpPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.baseRoute != widget.baseRoute) {
      // Clear override when base route changes
      _overrideRoute = null;
      _updateCurrentRoute();
      _loadHelpForCurrentRoute();
    }
    if (oldWidget.overrideRoute != widget.overrideRoute &&
        widget.overrideRoute != null) {
      _overrideRoute = widget.overrideRoute;
      _updateCurrentRoute();
      _loadHelpForCurrentRoute();
    }
  }

  Future<void> _loadHelpForCurrentRoute() async {
    setState(() {
      _isLoading = true;
      _searchResults = [];
      _isSearching = false;
    });

    final routeName = _extractRouteName(_currentRoute);
    final docName = widget.helpService.getDocForRoute(routeName) ?? routeName;
    final content = await widget.helpService.loadDocForRoute(routeName);

    if (mounted) {
      setState(() {
        _content = content;
        _currentDocName = docName;
        _isLoading = false;
      });
    }
  }

  String _extractRouteName(String route) {
    final path = route.startsWith('/') ? route.substring(1) : route;
    // Return the full path to support routes with context (e.g., 'config/client')
    return path.isEmpty ? 'keys' : path;
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() => _isSearching = true);

    final results = await widget.helpService.search(query);

    setState(() {
      _searchResults = results;
    });
  }

  Future<void> _navigateToDoc(String docName) async {
    setState(() => _isLoading = true);

    final content = await widget.helpService.loadDoc(docName);

    setState(() {
      _content = content;
      _currentDocName = docName;
      _searchResults = [];
      _isSearching = false;
      _searchController.clear();
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _helpContextService.removeListener(_onContextChanged);
    _helpNavService.removeListener(_onHelpNavigationChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Resize handle
        MouseRegion(
          cursor: SystemMouseCursors.resizeLeft,
          child: GestureDetector(
            onHorizontalDragUpdate: (details) {
              setState(() {
                _panelWidth = (_panelWidth - details.delta.dx).clamp(
                  SettingsService.minHelpPanelWidth,
                  SettingsService.maxHelpPanelWidth,
                );
              });
            },
            onHorizontalDragEnd: (_) {
              // Save the width when drag ends
              _settingsService.setHelpPanelWidth(_panelWidth);
            },
            child: Container(
              width: 8,
              color: Colors.transparent,
              child: Center(
                child: Container(
                  width: 4,
                  height: 40,
                  decoration: BoxDecoration(
                    color: colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
        ),
        // Main panel
        Container(
          width: _panelWidth,
          decoration: BoxDecoration(
            color: colorScheme.surface,
            border: Border(left: BorderSide(color: colorScheme.outlineVariant)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(-2, 0),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildHeader(theme, colorScheme),
              _buildSearchBar(theme, colorScheme),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _isSearching && _searchResults.isNotEmpty
                    ? _buildSearchResults(theme, colorScheme)
                    : _buildMarkdownContent(theme, colorScheme),
              ),
              _buildTopicSelector(theme, colorScheme),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        border: Border(bottom: BorderSide(color: colorScheme.outlineVariant)),
      ),
      child: Row(
        children: [
          Icon(Icons.help_outline, color: colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Help',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: widget.onClose,
            tooltip: 'Close Help',
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(ThemeData theme, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search documentation...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _performSearch('');
                  },
                )
              : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          filled: true,
          fillColor: colorScheme.surfaceContainerLow,
        ),
        onChanged: _performSearch,
      ),
    );
  }

  Widget _buildSearchResults(ThemeData theme, ColorScheme colorScheme) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final result = _searchResults[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: InkWell(
            onTap: () => _navigateToDoc(result.docName),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _getIconForDoc(result.docName),
                        size: 18,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        result.title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${result.matches.length} match${result.matches.length == 1 ? '' : 'es'}',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (result.matches.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      result.matches.first.line.trim(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMarkdownContent(ThemeData theme, ColorScheme colorScheme) {
    return Markdown(
      data: _content,
      selectable: true,
      padding: const EdgeInsets.all(16),
      styleSheet: MarkdownStyleSheet(
        h1: theme.textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: colorScheme.primary,
        ),
        h2: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
        h3: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
        p: theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurface,
          height: 1.5,
        ),
        code: theme.textTheme.bodySmall?.copyWith(
          fontFamily: 'monospace',
          backgroundColor: colorScheme.surfaceContainerHighest,
          color: colorScheme.onSurface,
        ),
        codeblockDecoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        blockquote: theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
          fontStyle: FontStyle.italic,
        ),
        listBullet: theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.primary,
        ),
        tableHead: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        tableBorder: TableBorder.all(
          color: colorScheme.outlineVariant,
          width: 1,
        ),
        tableHeadAlign: TextAlign.left,
        horizontalRuleDecoration: BoxDecoration(
          border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
        ),
      ),
      onTapLink: (text, href, title) => _handleLinkTap(href),
    );
  }

  void _handleLinkTap(String? href) {
    if (href == null) return;

    // Handle skeys:// URLs
    if (href.startsWith('skeys://')) {
      final action = HelpNavigationService.parseLink(href);
      if (action == null) return;

      switch (action) {
        case OpenSettingsAction(:final tabIndex):
          // Request settings to be opened via the navigation service
          // The AppShell will handle this after the help panel closes
          _helpNavService.requestOpenSettings(tabIndex);
          widget.onClose();
        case ShowHelpAction(:final route):
          // Navigate to the help route
          setState(() {
            _overrideRoute = route;
          });
          _updateCurrentRoute();
          _loadHelpForCurrentRoute();
      }
    }
    // External URLs are ignored for now - could add url_launcher later if needed
  }

  Widget _buildTopicSelector(ThemeData theme, ColorScheme colorScheme) {
    final topics = widget.helpService.availableTopics;
    // Height for approximately 3.5 chip rows (each chip ~32px + 8px spacing)
    const chipRowHeight = 40.0;
    const visibleRows = 3.5;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Topics',
            style: theme.textTheme.labelMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: chipRowHeight * visibleRows,
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: topics.map((topic) {
                  final isSelected = topic == _currentDocName;
                  return FilterChip(
                    label: Text(_capitalizeFirst(topic)),
                    selected: isSelected,
                    onSelected: (_) => _navigateToDoc(topic),
                    avatar: Icon(_getIconForDoc(topic), size: 16),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForDoc(String docName) {
    switch (docName) {
      case 'keys':
        return Icons.key;
      case 'config':
      case 'config-client':
        return Icons.tune;
      case 'config-server':
        return Icons.settings;
      case 'hosts':
        return Icons.dns;
      case 'agent':
        return Icons.security;
      case 'remotes':
        return Icons.cloud;
      case 'backup':
        return Icons.backup;
      case 'settings-display':
        return Icons.text_fields;
      case 'settings-security':
        return Icons.shield;
      case 'settings-backup':
        return Icons.backup;
      case 'settings-logging':
        return Icons.article;
      case 'settings-about':
        return Icons.info;
      default:
        return Icons.help_outline;
    }
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
