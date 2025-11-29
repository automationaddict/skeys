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

/// A node in the help documentation tree.
///
/// Represents either a documentation page (when docName is not null) or
/// a category grouping (when docName is null and children are present).
class HelpTreeNode {
  /// Unique identifier for this node.
  final String id;

  /// Display title for the node.
  final String title;

  /// The documentation file name (without extension) to load.
  /// Null for category nodes that only group other nodes.
  final String? docName;

  /// Icon to display for this node.
  final IconData icon;

  /// Child nodes under this node.
  final List<HelpTreeNode> children;

  /// Creates a help tree node.
  const HelpTreeNode({
    required this.id,
    required this.title,
    this.docName,
    required this.icon,
    this.children = const [],
  });

  /// Whether this node is a leaf (has no children).
  bool get isLeaf => children.isEmpty;

  /// Whether this node is a category (has children but no doc).
  bool get isCategory => children.isNotEmpty && docName == null;
}

/// Service for managing the help documentation tree hierarchy.
///
/// Provides a static tree structure organizing all help documentation
/// into a hierarchical navigation system.
class HelpTreeService {
  /// The root node of the help documentation tree.
  static final HelpTreeNode rootNode = HelpTreeNode(
    id: 'root',
    title: 'Documentation',
    docName: null,
    icon: Icons.menu_book,
    children: [
      HelpTreeNode(
        id: 'index',
        title: 'Welcome',
        docName: 'index',
        icon: Icons.home,
      ),
      HelpTreeNode(
        id: 'getting-started',
        title: 'Getting Started',
        docName: null,
        icon: Icons.school,
        children: [
          HelpTreeNode(
            id: 'quick-start',
            title: 'Quick Start',
            docName: 'quick-start',
            icon: Icons.rocket_launch,
          ),
          HelpTreeNode(
            id: 'install',
            title: 'Installation',
            docName: 'install',
            icon: Icons.download,
          ),
          HelpTreeNode(
            id: 'ssh-overview',
            title: 'SSH Overview',
            docName: 'ssh-overview',
            icon: Icons.info_outline,
          ),
          HelpTreeNode(
            id: 'faq',
            title: 'FAQ',
            docName: 'faq',
            icon: Icons.help_outline,
          ),
          HelpTreeNode(
            id: 'troubleshooting',
            title: 'Troubleshooting',
            docName: 'troubleshooting',
            icon: Icons.build,
          ),
          HelpTreeNode(
            id: 'glossary',
            title: 'Glossary',
            docName: 'glossary',
            icon: Icons.menu_book,
          ),
        ],
      ),
      HelpTreeNode(
        id: 'server',
        title: 'SSH Server Status',
        docName: 'server',
        icon: Icons.dns,
      ),
      HelpTreeNode(
        id: 'keys',
        title: 'SSH Keys',
        docName: 'keys',
        icon: Icons.key,
      ),
      HelpTreeNode(
        id: 'configuration',
        title: 'Configuration',
        docName: null,
        icon: Icons.tune,
        children: [
          HelpTreeNode(
            id: 'config-client',
            title: 'Client Config',
            docName: 'config-client',
            icon: Icons.computer,
          ),
          HelpTreeNode(
            id: 'config-server',
            title: 'Server Config',
            docName: 'config-server',
            icon: Icons.settings,
          ),
        ],
      ),
      HelpTreeNode(
        id: 'hosts',
        title: 'Hosts',
        docName: null,
        icon: Icons.dns,
        children: [
          HelpTreeNode(
            id: 'hosts-known',
            title: 'Known Hosts',
            docName: 'hosts-known',
            icon: Icons.verified_user,
          ),
          HelpTreeNode(
            id: 'hosts-authorized',
            title: 'Authorized Keys',
            docName: 'hosts-authorized',
            icon: Icons.vpn_key,
          ),
        ],
      ),
      HelpTreeNode(
        id: 'agent',
        title: 'SSH Agent',
        docName: 'agent',
        icon: Icons.security,
      ),
      HelpTreeNode(
        id: 'remotes',
        title: 'Remote Servers',
        docName: 'remotes',
        icon: Icons.cloud,
      ),
      HelpTreeNode(
        id: 'backup',
        title: 'Backup & Restore',
        docName: 'backup',
        icon: Icons.backup,
      ),
      HelpTreeNode(
        id: 'settings',
        title: 'Settings',
        docName: null,
        icon: Icons.settings,
        children: [
          HelpTreeNode(
            id: 'settings-display',
            title: 'Display',
            docName: 'settings-display',
            icon: Icons.palette,
          ),
          HelpTreeNode(
            id: 'settings-security',
            title: 'Security',
            docName: 'settings-security',
            icon: Icons.shield,
          ),
          HelpTreeNode(
            id: 'settings-backup',
            title: 'Backup',
            docName: 'settings-backup',
            icon: Icons.backup,
          ),
          HelpTreeNode(
            id: 'settings-logging',
            title: 'Logging',
            docName: 'settings-logging',
            icon: Icons.article,
          ),
          HelpTreeNode(
            id: 'settings-update',
            title: 'Updates',
            docName: 'settings-update',
            icon: Icons.system_update,
          ),
          HelpTreeNode(
            id: 'settings-system',
            title: 'System',
            docName: 'settings-system',
            icon: Icons.computer,
          ),
          HelpTreeNode(
            id: 'settings-about',
            title: 'About',
            docName: 'settings-about',
            icon: Icons.info,
          ),
        ],
      ),
    ],
  );

  /// Get all leaf nodes (nodes with documentation) in a flat list.
  static List<HelpTreeNode> get allLeafNodes {
    final leaves = <HelpTreeNode>[];
    _collectLeaves(rootNode, leaves);
    return leaves;
  }

  static void _collectLeaves(HelpTreeNode node, List<HelpTreeNode> leaves) {
    if (node.docName != null) {
      leaves.add(node);
    }
    for (final child in node.children) {
      _collectLeaves(child, leaves);
    }
  }

  /// Find a node by its document name.
  /// Returns null if no node with that docName exists.
  static HelpTreeNode? findNodeByDocName(String docName) {
    return _findNodeByDocName(rootNode, docName);
  }

  static HelpTreeNode? _findNodeByDocName(HelpTreeNode node, String docName) {
    if (node.docName == docName) {
      return node;
    }
    for (final child in node.children) {
      final result = _findNodeByDocName(child, docName);
      if (result != null) {
        return result;
      }
    }
    return null;
  }

  /// Get the path from root to a specific node.
  /// Returns a list of nodes from root to the target node (inclusive).
  /// Returns empty list if node is not found.
  static List<HelpTreeNode> getPathToNode(HelpTreeNode targetNode) {
    final path = <HelpTreeNode>[];
    if (_findPath(rootNode, targetNode, path)) {
      return path;
    }
    return [];
  }

  static bool _findPath(
    HelpTreeNode current,
    HelpTreeNode target,
    List<HelpTreeNode> path,
  ) {
    path.add(current);

    if (current.id == target.id) {
      return true;
    }

    for (final child in current.children) {
      if (_findPath(child, target, path)) {
        return true;
      }
    }

    path.removeLast();
    return false;
  }
}
