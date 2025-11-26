import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../di/injection.dart';
import '../help/help_context_service.dart';
import '../help/help_panel.dart';
import '../help/help_service.dart';
import '../settings/settings_dialog.dart';
import 'daemon_status_indicator.dart';

/// Application shell with navigation rail.
class AppShell extends StatefulWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final _helpService = HelpService();
  final _helpContextService = getIt<HelpContextService>();
  bool _showHelp = false;

  @override
  Widget build(BuildContext context) {
    final baseRoute = GoRouterState.of(context).uri.path;

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            extended: false,
            minWidth: 72,
            selectedIndex: _calculateSelectedIndex(context),
            onDestinationSelected: (index) => _onItemTapped(index, context),
            labelType: NavigationRailLabelType.all,
            leading: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Icon(
                Icons.vpn_key,
                size: 32,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            trailing: Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const DaemonStatusIndicator(),
                      const SizedBox(height: 16),
                      IconButton(
                        icon: Icon(
                          _showHelp ? Icons.help : Icons.help_outline,
                          color: _showHelp
                              ? Theme.of(context).colorScheme.primary
                              : null,
                        ),
                        tooltip: 'Help',
                        onPressed: () => setState(() => _showHelp = !_showHelp),
                      ),
                      const SizedBox(height: 8),
                      IconButton(
                        icon: const Icon(Icons.settings_outlined),
                        tooltip: 'Settings',
                        onPressed: () => SettingsDialog.show(context),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.key_outlined),
                selectedIcon: Icon(Icons.key),
                label: Text('Keys'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.tune_outlined),
                selectedIcon: Icon(Icons.tune),
                label: Text('Config'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.dns_outlined),
                selectedIcon: Icon(Icons.dns),
                label: Text('Hosts'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.security_outlined),
                selectedIcon: Icon(Icons.security),
                label: Text('Agent'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.cloud_outlined),
                selectedIcon: Icon(Icons.cloud),
                label: Text('Remotes'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: widget.child),
          if (_showHelp) ...[
            ListenableBuilder(
              listenable: _helpContextService,
              builder: (context, _) {
                final currentRoute = _helpContextService.buildHelpRoute(baseRoute);
                return HelpPanel(
                  currentRoute: currentRoute,
                  helpService: _helpService,
                  onClose: () => setState(() => _showHelp = false),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/keys')) return 0;
    if (location.startsWith('/config')) return 1;
    if (location.startsWith('/hosts')) return 2;
    if (location.startsWith('/agent')) return 3;
    if (location.startsWith('/remotes')) return 4;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.goNamed('keys');
        break;
      case 1:
        context.goNamed('config');
        break;
      case 2:
        context.goNamed('hosts');
        break;
      case 3:
        context.goNamed('agent');
        break;
      case 4:
        context.goNamed('remotes');
        break;
    }
  }
}
