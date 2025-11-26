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

/// Service for managing application settings with persistence.
class SettingsService extends ChangeNotifier {
  static const _logLevelKey = 'log_level';
  static const _textScaleKey = 'text_scale';
  static const _windowWidthKey = 'window_width';
  static const _windowHeightKey = 'window_height';
  static const _helpPanelWidthKey = 'help_panel_width';

  // Default window size
  static const defaultWindowWidth = 1200.0;
  static const defaultWindowHeight = 800.0;
  static const minWindowWidth = 800.0;
  static const minWindowHeight = 600.0;

  // Default help panel width
  static const defaultHelpPanelWidth = 400.0;
  static const minHelpPanelWidth = 280.0;
  static const maxHelpPanelWidth = 600.0;

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
}
