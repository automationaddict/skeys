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

/// Service for navigating to help topics and handling skeys:// links.
/// This allows dialogs to request help be shown after they close.
class HelpNavigationService extends ChangeNotifier {
  String? _pendingHelpRoute;
  bool _pendingShowHelp = false;
  bool _pendingOpenSettings = false;
  int _pendingSettingsTab = 0;

  /// Get the pending help route to navigate to.
  String? get pendingHelpRoute => _pendingHelpRoute;

  /// Check if help should be shown.
  bool get pendingShowHelp => _pendingShowHelp;

  /// Check if settings dialog should be opened.
  bool get pendingOpenSettings => _pendingOpenSettings;

  /// Get the settings tab to open.
  int get pendingSettingsTab => _pendingSettingsTab;

  /// Request help to be shown for a specific route.
  /// The app shell will pick this up and show the help panel.
  void requestHelp(String route) {
    _pendingHelpRoute = route;
    _pendingShowHelp = true;
    notifyListeners();
  }

  /// Request the settings dialog to be opened at a specific tab.
  void requestOpenSettings(int tabIndex) {
    _pendingOpenSettings = true;
    _pendingSettingsTab = tabIndex;
    notifyListeners();
  }

  /// Clear the pending help request after it's been handled.
  void clearPendingHelp() {
    _pendingHelpRoute = null;
    _pendingShowHelp = false;
    notifyListeners();
  }

  /// Clear the pending settings request after it's been handled.
  void clearPendingSettings() {
    _pendingOpenSettings = false;
    _pendingSettingsTab = 0;
    notifyListeners();
  }

  /// Parse a skeys:// URL and return the action to take.
  static SkeysLinkAction? parseLink(String url) {
    if (!url.startsWith('skeys://')) return null;

    final path = url.substring('skeys://'.length);
    final parts = path.split('/');

    if (parts.isEmpty) return null;

    switch (parts[0]) {
      case 'settings':
        // skeys://settings/display -> open settings at display tab
        final tabName = parts.length > 1 ? parts[1] : 'display';
        final tabIndex = _settingsTabIndex(tabName);
        return SkeysLinkAction.openSettings(tabIndex);
      case 'help':
        // skeys://help/keys -> show help for keys
        final route = parts.length > 1 ? parts.sublist(1).join('/') : 'keys';
        return SkeysLinkAction.showHelp(route);
      default:
        return null;
    }
  }

  static int _settingsTabIndex(String tabName) {
    switch (tabName) {
      case 'display':
        return 0;
      case 'security':
        return 1;
      case 'backup':
        return 2;
      case 'logging':
        return 3;
      case 'about':
        return 4;
      default:
        return 0;
    }
  }
}

/// An action to take from a skeys:// link.
sealed class SkeysLinkAction {
  const SkeysLinkAction();

  factory SkeysLinkAction.openSettings(int tabIndex) = OpenSettingsAction;
  factory SkeysLinkAction.showHelp(String route) = ShowHelpAction;
}

class OpenSettingsAction extends SkeysLinkAction {
  final int tabIndex;
  const OpenSettingsAction(this.tabIndex);
}

class ShowHelpAction extends SkeysLinkAction {
  final String route;
  const ShowHelpAction(this.route);
}
