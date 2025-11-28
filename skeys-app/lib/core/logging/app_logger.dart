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

import 'dart:convert';
import 'package:logger/logger.dart';

/// Application logger with JSON output support for consistent structured logging.
class AppLogger {
  final String component;
  final Logger _logger;

  static bool _jsonMode = false;
  static Level _level = Level.debug;

  AppLogger._(this.component, this._logger);

  /// Creates a new logger for a specific component.
  factory AppLogger(String component) {
    return AppLogger._(
      component,
      Logger(
        printer: _jsonMode
            ? _JsonLogPrinter(component)
            : _SimpleColorPrinter(component),
        level: _level,
        output: ConsoleOutput(),
      ),
    );
  }

  /// Configures global logging settings.
  static void configure({bool jsonMode = false, Level level = Level.debug}) {
    _jsonMode = jsonMode;
    _level = level;
  }

  /// Creates a child logger with an additional component path.
  AppLogger withComponent(String child) {
    return AppLogger('$component.$child');
  }

  void trace(String message, [Map<String, dynamic>? fields]) {
    _logger.t(_formatMessage(message, fields));
  }

  void debug(String message, [Map<String, dynamic>? fields]) {
    _logger.d(_formatMessage(message, fields));
  }

  void info(String message, [Map<String, dynamic>? fields]) {
    _logger.i(_formatMessage(message, fields));
  }

  void warning(String message, [Map<String, dynamic>? fields]) {
    _logger.w(_formatMessage(message, fields));
  }

  void error(
    String message, [
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? fields,
  ]) {
    final combinedFields = {
      ...?fields,
      if (error != null) 'error': error.toString(),
    };
    _logger.e(
      _formatMessage(message, combinedFields),
      error: error,
      stackTrace: stackTrace,
    );
  }

  String _formatMessage(String message, Map<String, dynamic>? fields) {
    if (_jsonMode) {
      return message;
    }
    if (fields == null || fields.isEmpty) {
      return '[$component] $message';
    }
    final fieldStr = fields.entries.map((e) => '${e.key}=${e.value}').join(' ');
    return '[$component] $message $fieldStr';
  }
}

/// Simple colored log printer without boxes.
class _SimpleColorPrinter extends LogPrinter {
  final String component;

  _SimpleColorPrinter(this.component);

  // ANSI color codes
  static const _reset = '\x1B[0m';
  static const _grey = '\x1B[90m';
  static const _blue = '\x1B[34m';
  static const _green = '\x1B[32m';
  static const _yellow = '\x1B[33m';
  static const _red = '\x1B[31m';

  @override
  List<String> log(LogEvent event) {
    final color = _levelColor(event.level);
    final levelStr = _levelToString(event.level).toUpperCase().padRight(5);
    final time = _formatTime(DateTime.now());

    final lines = <String>[];
    lines.add('$_grey$time$_reset $color$levelStr$_reset ${event.message}');

    if (event.error != null) {
      lines.add('$_red  Error: ${event.error}$_reset');
    }
    if (event.stackTrace != null) {
      lines.add('$_grey${event.stackTrace}$_reset');
    }

    return lines;
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}:'
        '${time.second.toString().padLeft(2, '0')}.'
        '${time.millisecond.toString().padLeft(3, '0')}';
  }

  String _levelColor(Level level) {
    switch (level) {
      case Level.trace:
        return _grey;
      case Level.debug:
        return _blue;
      case Level.info:
        return _green;
      case Level.warning:
        return _yellow;
      case Level.error:
      case Level.fatal:
        return _red;
      default:
        return _reset;
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
        return 'warn';
      case Level.error:
        return 'error';
      case Level.fatal:
        return 'fatal';
      default:
        return 'unknown';
    }
  }
}

/// JSON log printer for structured logging output.
class _JsonLogPrinter extends LogPrinter {
  final String component;

  _JsonLogPrinter(this.component);

  @override
  List<String> log(LogEvent event) {
    final level = _levelToString(event.level);
    final timestamp = DateTime.now().toIso8601String();

    final logEntry = {
      'time': timestamp,
      'level': level,
      'component': component,
      'message': event.message,
    };

    if (event.error != null) {
      logEntry['error'] = event.error.toString();
    }
    if (event.stackTrace != null) {
      logEntry['stack_trace'] = event.stackTrace.toString();
    }

    return [jsonEncode(logEntry)];
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
        return 'warn';
      case Level.error:
        return 'error';
      case Level.fatal:
        return 'fatal';
      default:
        return 'unknown';
    }
  }
}
