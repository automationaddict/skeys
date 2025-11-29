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

import 'package:flutter/services.dart';

/// Service for loading and searching help documentation.
class HelpService {
  final Map<String, String> _cache = {};

  /// Route name to documentation file mapping.
  /// For routes with tabs, use 'route/tab' format (e.g., 'config/client')
  static const Map<String, String> _routeToDoc = {
    'server': 'server',
    'keys': 'keys',
    'config': 'config-client', // Default to client config
    'config/client': 'config-client',
    'config/server': 'config-server',
    'hosts': 'hosts-known', // Default to known hosts
    'hosts/known': 'hosts-known',
    'hosts/authorized': 'hosts-authorized',
    'agent': 'agent',
    'remotes': 'remotes',
    'backup': 'backup',
    // Settings documentation
    'settings': 'settings-display', // Default to display
    'settings/display': 'settings-display',
    'settings/security': 'settings-security',
    'settings/backup': 'settings-backup',
    'settings/logging': 'settings-logging',
    'settings/update': 'settings-update',
    'settings/system': 'settings-system',
    'settings/about': 'settings-about',
  };

  /// Get the documentation file name for a route.
  String? getDocForRoute(String routeName) {
    return _routeToDoc[routeName];
  }

  /// Load documentation content for a given doc name.
  Future<String> loadDoc(String docName) async {
    if (_cache.containsKey(docName)) {
      return _cache[docName]!;
    }

    try {
      final content = await rootBundle.loadString('assets/docs/$docName.md');
      _cache[docName] = content;
      return content;
    } catch (e) {
      return '# Help\n\nDocumentation not available.';
    }
  }

  /// Load documentation for a route.
  Future<String> loadDocForRoute(String routeName) async {
    final docName = getDocForRoute(routeName);
    if (docName == null) {
      return '# Help\n\nNo documentation available for this screen.';
    }
    return loadDoc(docName);
  }

  /// Search documentation for a query.
  /// Returns a list of (docName, matchingLines) pairs.
  Future<List<SearchResult>> search(String query) async {
    if (query.isEmpty) return [];

    final results = <SearchResult>[];
    final queryLower = query.toLowerCase();

    for (final docName in _routeToDoc.values) {
      final content = await loadDoc(docName);
      final lines = content.split('\n');
      final matches = <SearchMatch>[];

      for (var i = 0; i < lines.length; i++) {
        if (lines[i].toLowerCase().contains(queryLower)) {
          matches.add(
            SearchMatch(
              lineNumber: i + 1,
              line: lines[i],
              context: _getContext(lines, i),
            ),
          );
        }
      }

      if (matches.isNotEmpty) {
        results.add(
          SearchResult(
            docName: docName,
            title: _getTitleFromDoc(content),
            matches: matches,
          ),
        );
      }
    }

    return results;
  }

  String _getContext(List<String> lines, int index) {
    final start = (index - 1).clamp(0, lines.length - 1);
    final end = (index + 2).clamp(0, lines.length);
    return lines.sublist(start, end).join('\n');
  }

  String _getTitleFromDoc(String content) {
    final lines = content.split('\n');
    for (final line in lines) {
      if (line.startsWith('# ')) {
        return line.substring(2).trim();
      }
    }
    return 'Help';
  }

  /// Get all available documentation topics.
  List<String> get availableTopics => _routeToDoc.values.toList();

  /// Clear the cache.
  void clearCache() {
    _cache.clear();
  }
}

/// A search result for a single document.
///
/// Contains metadata about the document and all matching lines found
/// within it when searching help documentation.
class SearchResult {
  /// The name of the documentation file (without extension).
  final String docName;

  /// The title of the documentation (extracted from the first heading).
  final String title;

  /// All matching lines found within this document.
  final List<SearchMatch> matches;

  /// Creates a SearchResult with the given document info and matches.
  SearchResult({
    required this.docName,
    required this.title,
    required this.matches,
  });
}

/// A single match within a document.
///
/// Represents one line that matched the search query, along with
/// surrounding context for display purposes.
class SearchMatch {
  /// The 1-based line number where the match was found.
  final int lineNumber;

  /// The full text of the matching line.
  final String line;

  /// Surrounding lines for context display.
  final String context;

  /// Creates a SearchMatch with the given line info and context.
  SearchMatch({
    required this.lineNumber,
    required this.line,
    required this.context,
  });
}
