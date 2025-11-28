import 'package:go_router/go_router.dart';

import '../../features/server/presentation/server_page.dart';
import '../../features/keys/presentation/keys_page.dart';
import '../../features/config/presentation/config_page.dart';
import '../../features/hosts/presentation/hosts_page.dart';
import '../../features/agent/presentation/agent_page.dart';
import '../../features/remote/presentation/remote_page.dart';
import '../shell/app_shell.dart';

/// Application router configuration.
final appRouter = GoRouter(
  initialLocation: '/server',
  routes: [
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: '/server',
          name: 'server',
          builder: (context, state) => const ServerPage(),
        ),
        GoRoute(
          path: '/keys',
          name: 'keys',
          builder: (context, state) => const KeysPage(),
        ),
        GoRoute(
          path: '/config',
          name: 'config',
          builder: (context, state) => const ConfigPage(),
        ),
        GoRoute(
          path: '/hosts',
          name: 'hosts',
          builder: (context, state) => const HostsPage(),
        ),
        GoRoute(
          path: '/agent',
          name: 'agent',
          builder: (context, state) => const AgentPage(),
        ),
        GoRoute(
          path: '/remotes',
          name: 'remotes',
          builder: (context, state) => const RemotePage(),
        ),
      ],
    ),
  ],
);
