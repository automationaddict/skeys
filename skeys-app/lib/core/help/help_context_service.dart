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

import 'package:flutter/foundation.dart';

/// Service for managing the current help context and visibility.
/// Pages can update this to provide more specific help context (e.g., tabs).
class HelpContextService extends ChangeNotifier {
  String? _contextSuffix;
  bool _isHelpVisible = false;

  /// Get the current context suffix (e.g., 'client' for config/client).
  String? get contextSuffix => _contextSuffix;

  /// Get whether the help panel is currently visible.
  bool get isHelpVisible => _isHelpVisible;

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
    final route = baseRoute.startsWith('/')
        ? baseRoute.substring(1)
        : baseRoute;
    if (_contextSuffix != null && _contextSuffix!.isNotEmpty) {
      return '$route/$_contextSuffix';
    }
    return route;
  }

  /// Show the help panel.
  void showHelp() {
    if (!_isHelpVisible) {
      _isHelpVisible = true;
      notifyListeners();
    }
  }

  /// Hide the help panel.
  void hideHelp() {
    if (_isHelpVisible) {
      _isHelpVisible = false;
      notifyListeners();
    }
  }

  /// Toggle the help panel visibility.
  void toggleHelp() {
    _isHelpVisible = !_isHelpVisible;
    notifyListeners();
  }
}
