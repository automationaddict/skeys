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

import 'help_navigation_service.dart';
import 'help_service.dart';
import 'help_tree_service.dart';
import 'widgets/help_tree_view.dart';

/// A comprehensive help dialog showing all application documentation.
///
/// This dialog provides a tree-based navigation interface for browsing
/// all available help documentation. It includes search functionality
/// and displays markdown-formatted content.
class ComprehensiveHelpDialog extends StatefulWidget {
  /// Optional initial document to display.
  final String? initialDocName;

  /// Creates a comprehensive help dialog.
  const ComprehensiveHelpDialog({super.key, this.initialDocName});

  @override
  State<ComprehensiveHelpDialog> createState() =>
      _ComprehensiveHelpDialogState();
}

class _ComprehensiveHelpDialogState extends State<ComprehensiveHelpDialog> {
  final _helpService = HelpService();
  final _searchController = TextEditingController();
  late String _currentDocName;
  String _content = '';
  bool _isLoading = true;
  String _searchQuery = '';
  List<SearchResult> _searchResults = [];
  final Set<String> _expandedNodes = {};

  @override
  void initState() {
    super.initState();
    // Set initial doc or default to first leaf node
    _currentDocName =
        widget.initialDocName ??
        HelpTreeService.allLeafNodes.firstOrNull?.docName ??
        'keys';
    _loadDoc(_currentDocName);

    // Listen to search controller to update clear button visibility
    _searchController.addListener(() {
      setState(() {});
    });

    // Expand nodes in path to initial doc
    final node = HelpTreeService.findNodeByDocName(_currentDocName);
    if (node != null) {
      final path = HelpTreeService.getPathToNode(node);
      for (final pathNode in path) {
        if (pathNode.children.isNotEmpty) {
          _expandedNodes.add(pathNode.id);
        }
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadDoc(String docName) async {
    setState(() {
      _isLoading = true;
      _currentDocName = docName;
    });

    final content = await _helpService.loadDoc(docName);

    if (mounted) {
      setState(() {
        _content = content;
        _isLoading = false;
      });
    }
  }

  Future<void> _performSearch(String query) async {
    setState(() {
      _searchQuery = query;
    });

    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    final results = await _helpService.search(query);

    if (mounted) {
      setState(() {
        _searchResults = results;
      });
    }
  }

  void _handleLinkTap(String? href) {
    if (href == null) return;

    // Handle skeys:// URLs
    if (href.startsWith('skeys://')) {
      final action = HelpNavigationService.parseLink(href);
      if (action == null) return;

      switch (action) {
        case ShowHelpAction(:final route):
          // Navigate within dialog
          final docName = _helpService.getDocForRoute(route);
          if (docName != null) {
            _loadDoc(docName);
            // Expand path to this node
            final node = HelpTreeService.findNodeByDocName(docName);
            if (node != null) {
              final path = HelpTreeService.getPathToNode(node);
              setState(() {
                for (final pathNode in path) {
                  if (pathNode.children.isNotEmpty) {
                    _expandedNodes.add(pathNode.id);
                  }
                }
              });
            }
          }
        case OpenSettingsAction():
          // Close dialog - settings will be handled by shell
          Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final screenSize = MediaQuery.of(context).size;

    // Use 80% of screen on desktop, 90% on mobile
    final dialogWidth = screenSize.width > 900
        ? screenSize.width * 0.8
        : screenSize.width * 0.9;
    final dialogHeight = screenSize.height * 0.8;

    return Dialog(
      child: SizedBox(
        width: dialogWidth,
        height: dialogHeight,
        child: Column(
          children: [
            _buildHeader(theme, colorScheme),
            _buildSearchBar(theme, colorScheme),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTreePanel(theme, colorScheme),
                  const VerticalDivider(width: 1),
                  _buildContentPanel(theme, colorScheme),
                ],
              ),
            ),
          ],
        ),
      ),
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
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
            tooltip: 'Close',
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
          hintText: 'Search all documentation...',
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

  Widget _buildTreePanel(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      width: 200,
      decoration: BoxDecoration(color: colorScheme.surface),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              'Topics',
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: HelpTreeView(
              rootNode: HelpTreeService.rootNode,
              selectedDocName: _currentDocName,
              expandedNodes: _expandedNodes,
              onNodeSelected: (docName) => _loadDoc(docName),
              onExpandedChanged: (expanded) {
                setState(() {
                  _expandedNodes.clear();
                  _expandedNodes.addAll(expanded);
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentPanel(ThemeData theme, ColorScheme colorScheme) {
    return Expanded(
      child: Container(
        color: colorScheme.surface,
        child: _searchQuery.isNotEmpty && _searchResults.isNotEmpty
            ? _buildSearchResults(theme, colorScheme)
            : _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _buildMarkdownContent(theme, colorScheme),
      ),
    );
  }

  Widget _buildSearchResults(ThemeData theme, ColorScheme colorScheme) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final result = _searchResults[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () {
              _searchController.clear();
              _loadDoc(result.docName);
              _performSearch('');
            },
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
                      Expanded(
                        child: Text(
                          result.title,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
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

  IconData _getIconForDoc(String docName) {
    final node = HelpTreeService.findNodeByDocName(docName);
    return node?.icon ?? Icons.help_outline;
  }
}
