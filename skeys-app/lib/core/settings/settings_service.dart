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
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../logging/app_logger.dart';

/// Text scale options matching M3 accessibility guidelines.
enum TextScale {
  small(0.85, 'Small'),
  normal(1.0, 'Normal'),
  large(1.15, 'Large'),
  extraLarge(1.3, 'Extra Large');

  final double scale;
  final String label;
  const TextScale(this.scale, this.label);
}

/// Theme mode options for the app.
enum AppThemeMode {
  system('System', 'Follow system preference'),
  light('Light', 'Always use light theme'),
  dark('Dark', 'Always use dark theme');

  final String label;
  final String description;
  const AppThemeMode(this.label, this.description);

  ThemeMode toThemeMode() {
    switch (this) {
      case AppThemeMode.system:
        return ThemeMode.system;
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
    }
  }
}

/// Service for managing application settings with persistence.
class SettingsService extends ChangeNotifier {
  static const _logLevelKey = 'log_level';
  static const _textScaleKey = 'text_scale';
  static const _themeModeKey = 'theme_mode';
  static const _windowWidthKey = 'window_width';
  static const _windowHeightKey = 'window_height';
  static const _helpPanelWidthKey = 'help_panel_width';
  static const _keyExpirationWarningDaysKey = 'key_expiration_warning_days';
  static const _keyExpirationCriticalDaysKey = 'key_expiration_critical_days';
  static const _agentKeyTimeoutMinutesKey = 'agent_key_timeout_minutes';
  static const _sshConfigPromptShownKey = 'ssh_config_prompt_shown';

  // Default window size
  static const defaultWindowWidth = 1200.0;
  static const defaultWindowHeight = 800.0;
  static const minWindowWidth = 800.0;
  static const minWindowHeight = 600.0;

  // Default help panel width
  static const defaultHelpPanelWidth = 400.0;
  static const minHelpPanelWidth = 280.0;
  static const maxHelpPanelWidth = 600.0;

  // Default key expiration thresholds (in days)
  static const defaultKeyExpirationWarningDays = 90;
  static const defaultKeyExpirationCriticalDays = 180;

  // Default agent key timeout (in minutes, 0 = no timeout)
  static const defaultAgentKeyTimeoutMinutes = 0;

  final SharedPreferences _prefs;
  final AppLogger _log = AppLogger('settings');

  SettingsService._(this._prefs);

  /// Initialize the settings service.
  static Future<SettingsService> init() async {
    final prefs = await SharedPreferences.getInstance();
    final service = SettingsService._(prefs);
    service._log.debug('settings service initialized');
    return service;
  }

  /// Get the current log level.
  Level get logLevel {
    final levelStr = _prefs.getString(_logLevelKey) ?? 'info';
    return _parseLevel(levelStr);
  }

  /// Set the log level and persist it.
  Future<void> setLogLevel(Level level) async {
    final levelStr = _levelToString(level);
    await _prefs.setString(_logLevelKey, levelStr);
    AppLogger.configure(level: level);
    _log.info('log level changed', {'level': levelStr});
  }

  /// Get the current text scale.
  TextScale get textScale {
    final scaleStr = _prefs.getString(_textScaleKey) ?? 'normal';
    return TextScale.values.firstWhere(
      (s) => s.name == scaleStr,
      orElse: () => TextScale.normal,
    );
  }

  /// Set the text scale and persist it.
  Future<void> setTextScale(TextScale scale) async {
    await _prefs.setString(_textScaleKey, scale.name);
    _log.info('text scale changed', {'scale': scale.name});
    notifyListeners();
  }

  /// Get the current theme mode.
  AppThemeMode get themeMode {
    final modeStr = _prefs.getString(_themeModeKey) ?? 'system';
    return AppThemeMode.values.firstWhere(
      (m) => m.name == modeStr,
      orElse: () => AppThemeMode.system,
    );
  }

  /// Set the theme mode and persist it.
  Future<void> setThemeMode(AppThemeMode mode) async {
    await _prefs.setString(_themeModeKey, mode.name);
    _log.info('theme mode changed', {'mode': mode.name});
    notifyListeners();
  }

  Level _parseLevel(String level) {
    switch (level.toLowerCase()) {
      case 'trace':
        return Level.trace;
      case 'debug':
        return Level.debug;
      case 'info':
        return Level.info;
      case 'warning':
      case 'warn':
        return Level.warning;
      case 'error':
        return Level.error;
      default:
        return Level.info;
    }
  }

  String _levelToString(Level level) {
    switch (level) {
      case Level.trace:
        return 'trace';
      case Level.debug:
        return 'debug';
      case Level.info:
        return 'info';
      case Level.warning:
        return 'warning';
      case Level.error:
        return 'error';
      default:
        return 'info';
    }
  }

  /// Get the saved window width.
  double get windowWidth {
    return _prefs.getDouble(_windowWidthKey) ?? defaultWindowWidth;
  }

  /// Get the saved window height.
  double get windowHeight {
    return _prefs.getDouble(_windowHeightKey) ?? defaultWindowHeight;
  }

  /// Save the window size.
  Future<void> setWindowSize(double width, double height) async {
    // Clamp to minimum size
    final clampedWidth = width.clamp(minWindowWidth, double.infinity);
    final clampedHeight = height.clamp(minWindowHeight, double.infinity);

    await _prefs.setDouble(_windowWidthKey, clampedWidth);
    await _prefs.setDouble(_windowHeightKey, clampedHeight);
    _log.debug('window size saved', {
      'width': clampedWidth,
      'height': clampedHeight,
    });
  }

  /// Get the saved help panel width.
  double get helpPanelWidth {
    return _prefs.getDouble(_helpPanelWidthKey) ?? defaultHelpPanelWidth;
  }

  /// Save the help panel width.
  Future<void> setHelpPanelWidth(double width) async {
    final clampedWidth = width.clamp(minHelpPanelWidth, maxHelpPanelWidth);
    await _prefs.setDouble(_helpPanelWidthKey, clampedWidth);
    _log.debug('help panel width saved', {'width': clampedWidth});
  }

  /// Get the key expiration warning threshold (in days).
  int get keyExpirationWarningDays {
    return _prefs.getInt(_keyExpirationWarningDaysKey) ??
        defaultKeyExpirationWarningDays;
  }

  /// Set the key expiration warning threshold (in days).
  Future<void> setKeyExpirationWarningDays(int days) async {
    await _prefs.setInt(_keyExpirationWarningDaysKey, days);
    _log.info('key expiration warning days changed', {'days': days});
    notifyListeners();
  }

  /// Get the key expiration critical threshold (in days).
  int get keyExpirationCriticalDays {
    return _prefs.getInt(_keyExpirationCriticalDaysKey) ??
        defaultKeyExpirationCriticalDays;
  }

  /// Set the key expiration critical threshold (in days).
  Future<void> setKeyExpirationCriticalDays(int days) async {
    await _prefs.setInt(_keyExpirationCriticalDaysKey, days);
    _log.info('key expiration critical days changed', {'days': days});
    notifyListeners();
  }

  /// Check the expiration status of a key based on its age.
  /// Returns 'ok', 'warning', or 'critical'.
  KeyExpirationStatus getKeyExpirationStatus(DateTime keyDate) {
    final now = DateTime.now();
    final age = now.difference(keyDate).inDays;

    if (age >= keyExpirationCriticalDays) {
      return KeyExpirationStatus.critical;
    } else if (age >= keyExpirationWarningDays) {
      return KeyExpirationStatus.warning;
    }
    return KeyExpirationStatus.ok;
  }

  /// Get the agent key timeout (in minutes). 0 means no timeout.
  int get agentKeyTimeoutMinutes {
    return _prefs.getInt(_agentKeyTimeoutMinutesKey) ??
        defaultAgentKeyTimeoutMinutes;
  }

  /// Set the agent key timeout (in minutes). 0 means no timeout.
  Future<void> setAgentKeyTimeoutMinutes(int minutes) async {
    await _prefs.setInt(_agentKeyTimeoutMinutesKey, minutes);
    _log.info('agent key timeout changed', {'minutes': minutes});
    notifyListeners();
  }

  /// Check if the SSH config prompt has been shown to the user.
  bool get sshConfigPromptShown {
    return _prefs.getBool(_sshConfigPromptShownKey) ?? false;
  }

  /// Mark the SSH config prompt as shown.
  Future<void> setSshConfigPromptShown(bool shown) async {
    await _prefs.setBool(_sshConfigPromptShownKey, shown);
    _log.info('SSH config prompt shown', {'shown': shown});
  }
}

/// Key expiration status levels.
enum KeyExpirationStatus { ok, warning, critical }
