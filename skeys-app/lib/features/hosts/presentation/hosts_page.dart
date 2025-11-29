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
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injection.dart';
import '../../../core/help/help_context_service.dart';
import '../../../core/help/help_panel.dart';
import '../../../core/help/help_service.dart';
import '../../../core/notifications/app_toast.dart';
import '../../../core/widgets/app_bar_with_help.dart';
import '../bloc/hosts_bloc.dart';
import '../domain/host_entity.dart';

/// Page for managing known_hosts and authorized_keys.
class HostsPage extends StatefulWidget {
  /// Creates a HostsPage widget.
  const HostsPage({super.key});

  @override
  State<HostsPage> createState() => _HostsPageState();
}

class _HostsPageState extends State<HostsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _helpContextService = getIt<HelpContextService>();
  final _helpService = HelpService();
  bool _showHelp = false;

  static const _tabContexts = ['known', 'authorized'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);
    // Set initial context (watch is auto-started by BLoC singleton)
    _helpContextService.setContextSuffix(_tabContexts[0]);
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) {
      _helpContextService.setContextSuffix(_tabContexts[_tabController.index]);
      setState(() {}); // Rebuild to update FAB visibility
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    _helpContextService.clearContext();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.f1): () {
          setState(() => _showHelp = !_showHelp);
        },
      },
      child: Scaffold(
        appBar: AppBarWithHelp(
          title: 'Host Management',
          helpRoute: 'hosts',
          onHelpPressed: () => setState(() => _showHelp = !_showHelp),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Known Hosts'),
              Tab(text: 'Authorized Keys'),
            ],
          ),
        ),
        body: Row(
          children: [
            Expanded(
              child: BlocBuilder<HostsBloc, HostsState>(
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
            ),
            if (_showHelp)
              HelpPanel(
                baseRoute: '/hosts',
                helpService: _helpService,
                onClose: () => setState(() => _showHelp = false),
              ),
          ],
        ),
        floatingActionButton: _tabController.index == 0
            ? FloatingActionButton.extended(
                onPressed: () => _showScanHostDialog(context),
                icon: const Icon(Icons.add),
                label: const Text('Add Host'),
              )
            : null,
      ),
    );
  }

  void _showScanHostDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<HostsBloc>(),
        child: const _ScanHostDialog(),
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
            Icon(
              Icons.dns_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'No known hosts',
              style: Theme.of(context).textTheme.titleLarge,
            ),
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
                  context.read<HostsBloc>().add(
                    const HostsHashKnownHostsRequested(),
                  );
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
              return _KnownHostCard(
                host: host,
                onDelete: () {
                  context.read<HostsBloc>().add(
                    HostsRemoveKnownHostRequested(host.host),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAuthorizedKeysTab(BuildContext context, HostsState state) {
    if (state.status == HostsStatus.loading && state.authorizedKeys.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.authorizedKeys.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.key_off,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'No authorized keys',
              style: Theme.of(context).textTheme.titleLarge,
            ),
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
                context.read<HostsBloc>().add(
                  HostsRemoveAuthorizedKeyRequested(key.publicKey),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _ScanHostDialog extends StatefulWidget {
  const _ScanHostDialog();

  @override
  State<_ScanHostDialog> createState() => _ScanHostDialogState();
}

class _ScanHostDialogState extends State<_ScanHostDialog> {
  final _hostnameController = TextEditingController();
  final _portController = TextEditingController(text: '22');
  bool _hashHostname = false;

  @override
  void dispose() {
    _hostnameController.dispose();
    _portController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HostsBloc, HostsState>(
      builder: (context, state) {
        return AlertDialog(
          title: const Text('Add Known Host'),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _hostnameController,
                  decoration: const InputDecoration(
                    labelText: 'Hostname',
                    hintText: 'e.g., github.com',
                    border: OutlineInputBorder(),
                  ),
                  enabled: state.status != HostsStatus.scanning,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _portController,
                  decoration: const InputDecoration(
                    labelText: 'Port',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  enabled: state.status != HostsStatus.scanning,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: state.status == HostsStatus.scanning
                            ? null
                            : () => _scanHost(context),
                        icon: state.status == HostsStatus.scanning
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.search),
                        label: Text(
                          state.status == HostsStatus.scanning
                              ? 'Scanning...'
                              : 'Scan Host',
                        ),
                      ),
                    ),
                  ],
                ),
                if (state.scannedKeys.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Text(
                    'Found ${state.scannedKeys.length} key(s):',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  ...state.scannedKeys.map(
                    (key) => _ScannedKeyTile(
                      hostKey: key,
                      hashHostname: _hashHostname,
                      onAdd: () => _addKey(context, key),
                    ),
                  ),
                  const SizedBox(height: 8),
                  CheckboxListTile(
                    title: const Text('Hash hostname'),
                    subtitle: const Text('Hide hostname in known_hosts'),
                    value: _hashHostname,
                    onChanged: (value) =>
                        setState(() => _hashHostname = value ?? false),
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
                if (state.status == HostsStatus.failure &&
                    state.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      state.errorMessage!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.read<HostsBloc>().add(
                  const HostsClearScannedKeysRequested(),
                );
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            if (state.scannedKeys.isNotEmpty)
              FilledButton(
                onPressed: () => _addAllKeys(context, state.scannedKeys),
                child: const Text('Add All Keys'),
              ),
          ],
        );
      },
    );
  }

  void _scanHost(BuildContext context) {
    final hostname = _hostnameController.text.trim();
    if (hostname.isEmpty) return;

    final port = int.tryParse(_portController.text) ?? 22;
    context.read<HostsBloc>().add(
      HostsScanHostKeysRequested(hostname, port: port),
    );
  }

  void _addKey(BuildContext context, ScannedHostKey key) {
    context.read<HostsBloc>().add(
      HostsAddKnownHostRequested(
        hostname: key.hostname,
        keyType: key.keyType,
        publicKey: key.publicKey,
        port: key.port,
        hashHostname: _hashHostname,
      ),
    );
    Navigator.of(context).pop();
  }

  void _addAllKeys(BuildContext context, List<ScannedHostKey> keys) {
    for (final key in keys) {
      context.read<HostsBloc>().add(
        HostsAddKnownHostRequested(
          hostname: key.hostname,
          keyType: key.keyType,
          publicKey: key.publicKey,
          port: key.port,
          hashHostname: _hashHostname,
        ),
      );
    }
    Navigator.of(context).pop();
  }
}

class _ScannedKeyTile extends StatelessWidget {
  final ScannedHostKey hostKey;
  final bool hashHostname;
  final VoidCallback onAdd;

  const _ScannedKeyTile({
    required this.hostKey,
    required this.hashHostname,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const Icon(Icons.vpn_key),
        title: Text(hostKey.keyType),
        subtitle: Text(
          hostKey.fingerprint.isNotEmpty
              ? hostKey.fingerprint
              : 'No fingerprint',
          style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.add_circle_outline),
          onPressed: onAdd,
          tooltip: 'Add this key',
        ),
      ),
    );
  }
}

/// Expandable card for known host entries with public key display.
class _KnownHostCard extends StatefulWidget {
  final KnownHostEntry host;
  final VoidCallback onDelete;

  const _KnownHostCard({required this.host, required this.onDelete});

  @override
  State<_KnownHostCard> createState() => _KnownHostCardState();
}

class _KnownHostCardState extends State<_KnownHostCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              widget.host.isHashed ? Icons.tag : Icons.dns,
              color: widget.host.isHashed ? Colors.green : null,
            ),
            title: Text(
              widget.host.isHashed ? '[HASHED]' : widget.host.host,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontFamily: 'monospace',
              ),
            ),
            subtitle: Text(widget.host.keyType),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(Icons.expand_more),
                  ),
                  onPressed: () => setState(() => _isExpanded = !_isExpanded),
                  tooltip: _isExpanded ? 'Hide key' : 'Show key',
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: widget.onDelete,
                  tooltip: 'Remove host',
                ),
              ],
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'Public Key',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.copy, size: 18),
                        onPressed: () => _copyPublicKey(context),
                        tooltip: 'Copy public key',
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SelectableText(
                      widget.host.publicKey,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontFamily: 'monospace',
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }

  void _copyPublicKey(BuildContext context) {
    final fullKey = '${widget.host.keyType} ${widget.host.publicKey}';
    Clipboard.setData(ClipboardData(text: fullKey));
    AppToast.success(context, message: 'Public key copied to clipboard');
  }
}
