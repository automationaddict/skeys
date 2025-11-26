import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/config_bloc.dart';

/// Page for SSH configuration management.
class ConfigPage extends StatefulWidget {
  const ConfigPage({super.key});

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    context.read<ConfigBloc>().add(const ConfigLoadClientHostsRequested());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SSH Configuration'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Client Config'),
            Tab(text: 'Server Config'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              if (_tabController.index == 0) {
                context.read<ConfigBloc>().add(const ConfigLoadClientHostsRequested());
              } else {
                context.read<ConfigBloc>().add(const ConfigLoadServerConfigRequested());
              }
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: BlocBuilder<ConfigBloc, ConfigState>(
        builder: (context, state) {
          return TabBarView(
            controller: _tabController,
            children: [
              _buildClientConfigTab(context, state),
              _buildServerConfigTab(context, state),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Add host dialog
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Host'),
      ),
    );
  }

  Widget _buildClientConfigTab(BuildContext context, ConfigState state) {
    if (state.status == ConfigStatus.loading && state.clientHosts.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.clientHosts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.dns_outlined, size: 64, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 16),
            Text('No SSH hosts configured', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Add a host configuration to get started',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.clientHosts.length,
      itemBuilder: (context, index) {
        final host = state.clientHosts[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: const Icon(Icons.dns),
            title: Text(host.host),
            subtitle: Text(
              [
                if (host.user != null) host.user,
                if (host.hostname != null) '@${host.hostname}',
                if (host.port != null) ':${host.port}',
              ].join(''),
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'delete') {
                  context.read<ConfigBloc>().add(ConfigDeleteClientHostRequested(host.host));
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'edit', child: Text('Edit')),
                const PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildServerConfigTab(BuildContext context, ConfigState state) {
    if (state.serverConfig == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.settings, size: 64, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 16),
            Text('Server config not loaded', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<ConfigBloc>().add(const ConfigLoadServerConfigRequested());
              },
              child: const Text('Load Server Config'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.serverConfig!.options.length,
      itemBuilder: (context, index) {
        final option = state.serverConfig!.options[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            title: Text(option.key),
            subtitle: Text(option.value),
            trailing: Text('Line ${option.lineNumber}'),
          ),
        );
      },
    );
  }
}
