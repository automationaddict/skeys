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
