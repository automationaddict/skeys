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
      primaryColor: success ? Colors.green : Theme.of(context).colorScheme.error,
      showProgressBar: false,
      closeOnClick: true,
      pauseOnHover: true,
    );
  }
}
