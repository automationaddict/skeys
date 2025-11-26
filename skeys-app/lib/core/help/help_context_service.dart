import 'package:flutter/foundation.dart';

/// Service for managing the current help context.
/// Pages can update this to provide more specific help context (e.g., tabs).
class HelpContextService extends ChangeNotifier {
  String? _contextSuffix;

  /// Get the current context suffix (e.g., 'client' for config/client).
  String? get contextSuffix => _contextSuffix;

  /// Set a context suffix to append to the current route.
  /// For example, setting 'client' when on /config will result in 'config/client'.
  void setContextSuffix(String? suffix) {
    if (_contextSuffix != suffix) {
      _contextSuffix = suffix;
      notifyListeners();
    }
  }

  /// Clear the context suffix.
  void clearContext() {
    setContextSuffix(null);
  }

  /// Build the full help route from a base route and the current context.
  String buildHelpRoute(String baseRoute) {
    final route = baseRoute.startsWith('/') ? baseRoute.substring(1) : baseRoute;
    if (_contextSuffix != null && _contextSuffix!.isNotEmpty) {
      return '$route/$_contextSuffix';
    }
    return route;
  }
}
