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

import 'package:get_it/get_it.dart';

import '../backend/backend_launcher.dart';
import '../backend/daemon_status_service.dart';
import '../grpc/grpc_client.dart';
import '../help/help_context_service.dart';
import '../help/help_navigation_service.dart';
import '../logging/app_logger.dart';
import '../settings/settings_service.dart';
import '../update/update_service.dart';
import '../../features/keys/bloc/keys_bloc.dart';
import '../../features/keys/repository/keys_repository.dart';
import '../../features/config/bloc/config_bloc.dart';
import '../../features/config/repository/config_repository.dart';
import '../../features/hosts/bloc/hosts_bloc.dart';
import '../../features/hosts/repository/hosts_repository.dart';
import '../../features/agent/bloc/agent_bloc.dart';
import '../../features/agent/repository/agent_repository.dart';
import '../../features/remote/bloc/remote_bloc.dart';
import '../../features/remote/repository/remote_repository.dart';
import '../../features/metadata/repository/metadata_repository.dart';
import '../../features/server/bloc/server_bloc.dart';
import '../../features/server/repository/server_repository.dart';

final getIt = GetIt.instance;

final _log = AppLogger('di');

Future<void> configureDependencies() async {
  _log.info('configuring dependencies');

  // Settings service (initialize first to get persisted log level)
  _log.debug('initializing settings service');
  final settingsService = await SettingsService.init();
  getIt.registerSingleton<SettingsService>(settingsService);

  // Help context service (for tab-aware help)
  _log.debug('creating help context service');
  final helpContextService = HelpContextService();
  getIt.registerSingleton<HelpContextService>(helpContextService);

  // Help navigation service (for dialog-to-help communication)
  _log.debug('creating help navigation service');
  final helpNavigationService = HelpNavigationService();
  getIt.registerSingleton<HelpNavigationService>(helpNavigationService);

  // Apply persisted log level
  AppLogger.configure(level: settingsService.logLevel);
  _log.info('applied persisted log level', {
    'level': settingsService.logLevel.name,
  });

  // Backend launcher
  _log.debug('creating backend launcher');
  final backendLauncher = BackendLauncher();

  try {
    await backendLauncher.start();
    _log.info('backend launcher started successfully');
  } catch (e, st) {
    _log.error('failed to start backend launcher', e, st);
    rethrow;
  }

  getIt.registerSingleton<BackendLauncher>(backendLauncher);

  // gRPC client
  _log.debug('creating gRPC client', {
    'socket_path': backendLauncher.socketPath,
  });
  final grpcClient = GrpcClient(backendLauncher.socketPath);

  try {
    await grpcClient.connect();
    _log.info('gRPC client connected successfully');
  } catch (e, st) {
    _log.error('failed to connect gRPC client', e, st);
    rethrow;
  }

  getIt.registerSingleton<GrpcClient>(grpcClient);

  // Daemon status service (monitors connection health)
  _log.debug('creating daemon status service');
  final daemonStatusService = DaemonStatusService();
  getIt.registerSingleton<DaemonStatusService>(daemonStatusService);

  // Update service (monitors for available updates)
  _log.debug('creating update service');
  final updateService = UpdateService(grpcClient: grpcClient);
  getIt.registerSingleton<UpdateService>(updateService);
  // Initialize in the background (don't block startup)
  updateService.initialize();

  // Repositories (Adapter Pattern - adapts gRPC to domain interfaces)
  _log.debug('registering repositories');
  getIt.registerLazySingleton<KeysRepository>(
    () => KeysRepositoryImpl(grpcClient),
  );
  getIt.registerLazySingleton<ConfigRepository>(
    () => ConfigRepositoryImpl(grpcClient),
  );
  getIt.registerLazySingleton<HostsRepository>(
    () => HostsRepositoryImpl(grpcClient),
  );
  getIt.registerLazySingleton<AgentRepository>(
    () => AgentRepositoryImpl(grpcClient),
  );

  getIt.registerLazySingleton<RemoteRepository>(
    () => RemoteRepositoryImpl(grpcClient),
  );
  getIt.registerLazySingleton<MetadataRepository>(
    () => MetadataRepositoryImpl(grpcClient),
  );
  getIt.registerLazySingleton<ServerRepository>(
    () => ServerRepositoryImpl(grpcClient),
  );

  // BLoCs (singletons that auto-start watching)
  _log.debug('registering BLoCs as singletons');
  getIt.registerLazySingleton<KeysBloc>(
    () => KeysBloc(getIt<KeysRepository>(), getIt<RemoteRepository>()),
  );
  getIt.registerLazySingleton<ConfigBloc>(
    () => ConfigBloc(getIt<ConfigRepository>()),
  );
  getIt.registerLazySingleton<HostsBloc>(
    () => HostsBloc(getIt<HostsRepository>()),
  );
  getIt.registerLazySingleton<AgentBloc>(
    () => AgentBloc(getIt<AgentRepository>()),
  );
  getIt.registerLazySingleton<RemoteBloc>(
    () => RemoteBloc(getIt<RemoteRepository>()),
  );
  getIt.registerLazySingleton<ServerBloc>(
    () => ServerBloc(getIt<ServerRepository>()),
  );

  _log.info('dependency injection configured successfully');
}

Future<void> disposeDependencies() async {
  _log.info('disposing dependencies');

  try {
    getIt<UpdateService>().dispose();
    _log.debug('update service disposed');
  } catch (e, st) {
    _log.error('error disposing update service', e, st);
  }

  try {
    await getIt<GrpcClient>().disconnect();
    _log.debug('gRPC client disconnected');
  } catch (e, st) {
    _log.error('error disconnecting gRPC client', e, st);
  }

  try {
    await getIt<BackendLauncher>().stop();
    _log.debug('backend launcher stopped');
  } catch (e, st) {
    _log.error('error stopping backend launcher', e, st);
  }

  _log.info('dependencies disposed');
}
