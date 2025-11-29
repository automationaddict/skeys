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

import '../help_tree_service.dart';

/// An interactive tree view for navigating help documentation.
///
/// Displays a hierarchical tree of help topics with expand/collapse
/// functionality and selection highlighting.
class HelpTreeView extends StatelessWidget {
  /// The root node of the tree to display.
  final HelpTreeNode rootNode;

  /// The currently selected document name.
  final String? selectedDocName;

  /// Set of node IDs that are currently expanded.
  final Set<String> expandedNodes;

  /// Callback invoked when a node with documentation is selected.
  final ValueChanged<String> onNodeSelected;

  /// Callback invoked when the expansion state changes.
  final ValueChanged<Set<String>> onExpandedChanged;

  /// Creates a help tree view.
  const HelpTreeView({
    super.key,
    required this.rootNode,
    required this.selectedDocName,
    required this.expandedNodes,
    required this.onNodeSelected,
    required this.onExpandedChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: _buildChildren(rootNode.children, 0, context),
    );
  }

  List<Widget> _buildChildren(
    List<HelpTreeNode> nodes,
    int depth,
    BuildContext context,
  ) {
    final widgets = <Widget>[];
    for (final node in nodes) {
      widgets.add(_buildNode(node, depth, context));
      // Show children if expanded
      if (expandedNodes.contains(node.id) && node.children.isNotEmpty) {
        widgets.addAll(_buildChildren(node.children, depth + 1, context));
      }
    }
    return widgets;
  }

  Widget _buildNode(HelpTreeNode node, int depth, BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = node.docName != null && node.docName == selectedDocName;
    final isExpanded = expandedNodes.contains(node.id);
    final hasChildren = node.children.isNotEmpty;

    return InkWell(
      onTap: () {
        if (hasChildren) {
          // Toggle expansion
          final newExpanded = Set<String>.from(expandedNodes);
          if (isExpanded) {
            newExpanded.remove(node.id);
          } else {
            newExpanded.add(node.id);
          }
          onExpandedChanged(newExpanded);
        }

        // Navigate to doc if available
        if (node.docName != null) {
          onNodeSelected(node.docName!);
        }
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.only(
          left: 8.0 + (depth * 16.0),
          right: 8.0,
          top: 8.0,
          bottom: 8.0,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primaryContainer.withValues(alpha: 0.5)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            // Expand/collapse icon for nodes with children
            if (hasChildren)
              Icon(
                isExpanded ? Icons.expand_more : Icons.chevron_right,
                size: 20,
                color: colorScheme.onSurfaceVariant,
              )
            else
              const SizedBox(width: 20),
            const SizedBox(width: 4),
            // Node icon
            Icon(
              node.icon,
              size: 18,
              color: isSelected ? colorScheme.primary : colorScheme.onSurface,
            ),
            const SizedBox(width: 8),
            // Node title
            Expanded(
              child: Text(
                node.title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
