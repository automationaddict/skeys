import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../di/injection.dart';
import '../generated/skeys/v1/config.pb.dart';
import '../grpc/grpc_client.dart';
import '../help/help_navigation_service.dart';
import '../help/help_panel.dart';
import '../help/help_service.dart';
import '../logging/app_logger.dart';
import '../settings/settings_dialog.dart';
import '../settings/settings_service.dart';
import '../ssh_config/ssh_config_dialog.dart';
import 'daemon_status_indicator.dart';

/// Application shell with navigation rail.
class AppShell extends StatefulWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final _log = AppLogger('app_shell');
  final _helpService = HelpService();
  final _settingsService = getIt<SettingsService>();
  final _grpcClient = getIt<GrpcClient>();
  final _helpNavService = getIt<HelpNavigationService>();
  bool _showHelp = false;
  bool _checkedSshConfig = false;

  @override
  void initState() {
    super.initState();
    // Listen for help navigation requests
    _helpNavService.addListener(_onHelpNavigationChanged);

    // Check SSH config on first run after frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkSshConfigPrompt();
    });
  }

  @override
  void dispose() {
    _helpNavService.removeListener(_onHelpNavigationChanged);
    super.dispose();
  }

  void _onHelpNavigationChanged() {
    // Handle pending help request - just show the help panel
    // The help panel itself listens for the specific route
    if (_helpNavService.pendingShowHelp) {
      setState(() {
        _showHelp = true;
      });
      // Note: The help panel will pick up the pending route and navigate to it
    }

    // Handle pending settings request
    if (_helpNavService.pendingOpenSettings) {
      final tabIndex = _helpNavService.pendingSettingsTab;
      _helpNavService.clearPendingSettings();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          SettingsDialog.show(context, initialTab: tabIndex);
        }
      });
    }
  }

  Future<void> _checkSshConfigPrompt() async {
    // Only check once per app session
    if (_checkedSshConfig) return;
    _checkedSshConfig = true;

    // Skip if we've already shown the prompt
    if (_settingsService.sshConfigPromptShown) {
      _log.debug('SSH config prompt already shown, skipping');
      return;
    }

    try {
      // Check if SSH config is already enabled
      final status = await _grpcClient.config.getSshConfigStatus(
        GetSshConfigStatusRequest(),
      );

      if (status.enabled) {
        _log.debug('SSH config already enabled, marking prompt as shown');
        await _settingsService.setSshConfigPromptShown(true);
        return;
      }

      // Show the dialog
      _log.info('showing SSH config setup dialog');
      if (!mounted) return;

      final enabled = await SshConfigDialog.show(context, _grpcClient);

      // Mark as shown regardless of choice
      await _settingsService.setSshConfigPromptShown(true);
      _log.info('SSH config prompt completed', {'enabled': enabled});
    } catch (e, st) {
      _log.error('error checking SSH config status', e, st);
      // Don't block the app on error, just log it
    }
  }

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
            HelpPanel(
              baseRoute: baseRoute,
              helpService: _helpService,
              onClose: () => setState(() => _showHelp = false),
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
