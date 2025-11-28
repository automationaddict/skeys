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
import 'package:toastification/toastification.dart';

/// Helper class for showing toast notifications throughout the app.
class AppToast {
  AppToast._();

  static const Duration _defaultDuration = Duration(seconds: 3);

  /// Show a success toast
  static void success(
    BuildContext context, {
    required String message,
    String? title,
    Duration? duration,
  }) {
    toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.flat,
      title: title != null ? Text(title) : null,
      description: Text(message),
      alignment: Alignment.topRight,
      autoCloseDuration: duration ?? _defaultDuration,
      primaryColor: Colors.green,
      showProgressBar: false,
      closeOnClick: true,
      pauseOnHover: true,
    );
  }

  /// Show an error toast
  static void error(
    BuildContext context, {
    required String message,
    String? title,
    Duration? duration,
  }) {
    toastification.show(
      context: context,
      type: ToastificationType.error,
      style: ToastificationStyle.flat,
      title: title != null ? Text(title) : null,
      description: Text(message),
      alignment: Alignment.topRight,
      autoCloseDuration: duration ?? const Duration(seconds: 5),
      primaryColor: Theme.of(context).colorScheme.error,
      showProgressBar: false,
      closeOnClick: true,
      pauseOnHover: true,
    );
  }

  /// Show an info toast
  static void info(
    BuildContext context, {
    required String message,
    String? title,
    Duration? duration,
  }) {
    toastification.show(
      context: context,
      type: ToastificationType.info,
      style: ToastificationStyle.flat,
      title: title != null ? Text(title) : null,
      description: Text(message),
      alignment: Alignment.topRight,
      autoCloseDuration: duration ?? _defaultDuration,
      primaryColor: Theme.of(context).colorScheme.primary,
      showProgressBar: false,
      closeOnClick: true,
      pauseOnHover: true,
    );
  }

  /// Show a warning toast
  static void warning(
    BuildContext context, {
    required String message,
    String? title,
    Duration? duration,
  }) {
    toastification.show(
      context: context,
      type: ToastificationType.warning,
      style: ToastificationStyle.flat,
      title: title != null ? Text(title) : null,
      description: Text(message),
      alignment: Alignment.topRight,
      autoCloseDuration: duration ?? const Duration(seconds: 4),
      primaryColor: Colors.orange,
      showProgressBar: false,
      closeOnClick: true,
      pauseOnHover: true,
    );
  }

  /// Show a connection test result toast
  static void connectionResult(
    BuildContext context, {
    required bool success,
    required String message,
    String? serverVersion,
    int? latencyMs,
  }) {
    final description = StringBuffer(message);
    if (serverVersion != null && serverVersion.isNotEmpty) {
      description.write('\nServer: $serverVersion');
    }
    if (latencyMs != null) {
      description.write('\nLatency: $latencyMs ms');
    }

    toastification.show(
      context: context,
      type: success ? ToastificationType.success : ToastificationType.error,
      style: ToastificationStyle.flat,
      title: Text(success ? 'Connection Successful' : 'Connection Failed'),
      description: Text(description.toString()),
      alignment: Alignment.topRight,
      autoCloseDuration: const Duration(seconds: 5),
      primaryColor: success
          ? Colors.green
          : Theme.of(context).colorScheme.error,
      showProgressBar: false,
      closeOnClick: true,
      pauseOnHover: true,
    );
  }
}
