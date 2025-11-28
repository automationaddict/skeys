import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:toastification/toastification.dart';
import 'package:window_manager/window_manager.dart';

import 'core/di/injection.dart';
import 'core/logging/app_logger.dart';
import 'core/router/app_router.dart';
import 'core/settings/settings_service.dart';
import 'core/single_instance.dart';
import 'core/theme/app_theme.dart';
import 'features/keys/bloc/keys_bloc.dart';
import 'features/config/bloc/config_bloc.dart';
import 'features/hosts/bloc/hosts_bloc.dart';
import 'features/agent/bloc/agent_bloc.dart';
import 'features/remote/bloc/remote_bloc.dart';
import 'features/server/bloc/server_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configure logging based on environment
  // Use JSON mode when LOG_JSON env var is set, otherwise use pretty printing
  final jsonMode = Platform.environment['LOG_JSON'] == 'true';
  final logLevel = _parseLogLevel(Platform.environment['LOG_LEVEL'] ?? 'info');

  AppLogger.configure(jsonMode: jsonMode, level: logLevel);

  final log = AppLogger('main');
  log.info('starting SKeys app', {
    'json_mode': jsonMode,
    'log_level': logLevel.name,
  });

  // Ensure only one instance can run
  if (!await SingleInstance.acquire()) {
    log.error('another instance is already running');
    exit(1);
  }

  // Initialize dependency injection
  try {
    await configureDependencies();
    log.info('dependencies configured successfully');
  } catch (e, st) {
    log.error('failed to configure dependencies', e, st);
    await SingleInstance.release();
    // Show error UI instead of crashing
    runApp(ErrorApp(error: e.toString()));
    return;
  }

  // TODO: Window manager is causing crashes - disabled temporarily
  // final settingsService = getIt<SettingsService>();
  // try {
  //   await _initializeWindow(settingsService, log);
  // } catch (e, st) {
  //   log.error('window manager init failed', e, st);
  // }

  runApp(const SKeysApp());
}

Future<void> _initializeWindow(SettingsService settings, AppLogger log) async {
  await windowManager.ensureInitialized();

  final savedWidth = settings.windowWidth;
  final savedHeight = settings.windowHeight;

  log.debug('restoring window size', {
    'width': savedWidth,
    'height': savedHeight,
  });

  final windowOptions = WindowOptions(
    size: Size(savedWidth, savedHeight),
    minimumSize: Size(
      SettingsService.minWindowWidth,
      SettingsService.minWindowHeight,
    ),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
    title: 'SKeys - SSH Key Manager',
  );

  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    // Explicitly set size after window is ready (some Linux WMs ignore WindowOptions size)
    await windowManager.setSize(Size(savedWidth, savedHeight));
    await windowManager.show();
    await windowManager.focus();
  });
}

Level _parseLogLevel(String level) {
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

class SKeysApp extends StatefulWidget {
  const SKeysApp({super.key});

  @override
  State<SKeysApp> createState() => _SKeysAppState();
}

class _SKeysAppState extends State<SKeysApp> {
  final _settingsService = getIt<SettingsService>();
  // TODO: Re-enable WindowListener once crash is fixed
  // final _log = AppLogger('app');
  // Timer? _resizeDebounce;

  // @override
  // void initState() {
  //   super.initState();
  //   windowManager.addListener(this);
  // }

  // @override
  // void dispose() {
  //   _resizeDebounce?.cancel();
  //   windowManager.removeListener(this);
  //   super.dispose();
  // }

  // @override
  // void onWindowResize() {
  //   _resizeDebounce?.cancel();
  //   _resizeDebounce = Timer(const Duration(milliseconds: 500), () async {
  //     await _saveWindowSize();
  //   });
  // }

  // @override
  // void onWindowResized() {
  //   _saveWindowSize();
  // }

  // @override
  // void onWindowClose() {
  //   _saveWindowSize();
  // }

  // Future<void> _saveWindowSize() async {
  //   final size = await windowManager.getSize();
  //   _log.debug('saving window size', {
  //     'width': size.width,
  //     'height': size.height,
  //   });
  //   await _settingsService.setWindowSize(size.width, size.height);
  // }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<KeysBloc>()),
        BlocProvider(create: (_) => getIt<ConfigBloc>()),
        BlocProvider(create: (_) => getIt<HostsBloc>()),
        BlocProvider(create: (_) => getIt<AgentBloc>()),
        BlocProvider(create: (_) => getIt<RemoteBloc>()),
        BlocProvider(create: (_) => getIt<ServerBloc>()),
      ],
      child: ToastificationWrapper(
        child: ListenableBuilder(
          listenable: _settingsService,
          builder: (context, _) {
            final textScale = _settingsService.textScale;
            return MaterialApp.router(
              title: 'SKeys - SSH Key Manager',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: ThemeMode.system,
              routerConfig: appRouter,
              builder: (context, child) {
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    textScaler: TextScaler.linear(textScale.scale),
                  ),
                  child: child!,
                );
              },
            );
          },
        ),
      ),
    );
  }
}

/// Error app shown when initialization fails
class ErrorApp extends StatelessWidget {
  final String error;

  const ErrorApp({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SKeys - Error',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Failed to Start SKeys',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  error,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Please check:\n'
                  '1. Is the skeys-daemon installed?\n'
                  '2. Is there another daemon already running?\n'
                  '3. Check the logs for more details.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
