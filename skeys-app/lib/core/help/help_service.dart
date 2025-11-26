import 'package:flutter/services.dart';

/// Service for loading and searching help documentation.
class HelpService {
  final Map<String, String> _cache = {};

  /// Route name to documentation file mapping.
  /// For routes with tabs, use 'route/tab' format (e.g., 'config/client')
  static const Map<String, String> _routeToDoc = {
    'keys': 'keys',
    'config': 'config-client', // Default to client config
    'config/client': 'config-client',
    'config/server': 'config-server',
    'hosts': 'hosts',
    'agent': 'agent',
    'remotes': 'remotes',
    'backup': 'backup',
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
          matches.add(SearchMatch(
            lineNumber: i + 1,
            line: lines[i],
            context: _getContext(lines, i),
          ));
        }
      }

      if (matches.isNotEmpty) {
        results.add(SearchResult(
          docName: docName,
          title: _getTitleFromDoc(content),
          matches: matches,
        ));
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
class SearchResult {
  final String docName;
  final String title;
  final List<SearchMatch> matches;

  SearchResult({
    required this.docName,
    required this.title,
    required this.matches,
  });
}

/// A single match within a document.
class SearchMatch {
  final int lineNumber;
  final String line;
  final String context;

  SearchMatch({
    required this.lineNumber,
    required this.line,
    required this.context,
  });
}
