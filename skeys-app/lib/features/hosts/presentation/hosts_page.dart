import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/hosts_bloc.dart';

/// Page for managing known_hosts and authorized_keys.
class HostsPage extends StatefulWidget {
  const HostsPage({super.key});

  @override
  State<HostsPage> createState() => _HostsPageState();
}

class _HostsPageState extends State<HostsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _authorizedKeysLoaded = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    context.read<HostsBloc>().add(const HostsLoadKnownHostsRequested());
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
        title: const Text('Host Management'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Known Hosts'),
            Tab(text: 'Authorized Keys'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              if (_tabController.index == 0) {
                context.read<HostsBloc>().add(const HostsLoadKnownHostsRequested());
              } else {
                context.read<HostsBloc>().add(const HostsLoadAuthorizedKeysRequested());
              }
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: BlocBuilder<HostsBloc, HostsState>(
        builder: (context, state) {
          return TabBarView(
            controller: _tabController,
            children: [
              _buildKnownHostsTab(context, state),
              _buildAuthorizedKeysTab(context, state),
            ],
          );
        },
      ),
    );
  }

  Widget _buildKnownHostsTab(BuildContext context, HostsState state) {
    if (state.status == HostsStatus.loading && state.knownHosts.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.knownHosts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.dns_outlined, size: 64, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 16),
            Text('No known hosts', style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton.icon(
                onPressed: () {
                  context.read<HostsBloc>().add(const HostsHashKnownHostsRequested());
                },
                icon: const Icon(Icons.tag),
                label: const Text('Hash All Hosts'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: state.knownHosts.length,
            itemBuilder: (context, index) {
              final host = state.knownHosts[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Icon(
                    host.isHashed ? Icons.tag : Icons.dns,
                    color: host.isHashed ? Colors.green : null,
                  ),
                  title: Text(
                    host.isHashed ? '[HASHED]' : host.host,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontFamily: 'monospace',
                        ),
                  ),
                  subtitle: Text(host.keyType),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () {
                      context.read<HostsBloc>().add(HostsRemoveKnownHostRequested(host.host));
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAuthorizedKeysTab(BuildContext context, HostsState state) {
    // Only load once when first viewing the tab
    if (!_authorizedKeysLoaded && state.status != HostsStatus.loading) {
      _authorizedKeysLoaded = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<HostsBloc>().add(const HostsLoadAuthorizedKeysRequested());
      });
    }

    if (state.status == HostsStatus.loading && state.authorizedKeys.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.authorizedKeys.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.key_off, size: 64, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 16),
            Text('No authorized keys', style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.authorizedKeys.length,
      itemBuilder: (context, index) {
        final key = state.authorizedKeys[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: const Icon(Icons.key),
            title: Text(key.comment.isNotEmpty ? key.comment : 'No comment'),
            subtitle: Text(key.keyType),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                context.read<HostsBloc>().add(HostsRemoveAuthorizedKeyRequested(key.publicKey));
              },
            ),
          ),
        );
      },
    );
  }
}
