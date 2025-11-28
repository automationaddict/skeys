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

import '../domain/config_entity.dart';
import '../domain/ssh_config_entry.dart';
import '../../../core/grpc/grpc_client.dart';
import '../../../core/generated/skeys/v1/config.pb.dart' as pb;
import '../../../core/generated/skeys/v1/common.pb.dart' as common;

/// Abstract repository for SSH configuration management.
abstract class ConfigRepository {
  // New unified SSH config API
  Future<List<SSHConfigEntry>> listSSHConfigEntries();
  Stream<List<SSHConfigEntry>> watchSSHConfigEntries();
  Future<SSHConfigEntry> getSSHConfigEntry(String id);
  Future<SSHConfigEntry> createSSHConfigEntry(
    SSHConfigEntry entry, {
    int? insertPosition,
  });
  Future<SSHConfigEntry> updateSSHConfigEntry(String id, SSHConfigEntry entry);
  Future<void> deleteSSHConfigEntry(String id);
  Future<List<SSHConfigEntry>> reorderSSHConfigEntries(List<String> entryIds);

  // Global directives API (options outside Host/Match blocks)
  Future<List<GlobalDirective>> listGlobalDirectives();
  Future<GlobalDirective> setGlobalDirective(String key, String value);
  Future<void> deleteGlobalDirective(String key);

  // Legacy client config (backward compatibility)
  Future<List<ConfigHostEntry>> listHostConfigs();
  Future<ConfigHostEntry> getHostConfig(String alias);
  Future<void> createHostConfig(ConfigHostEntry entry);
  Future<void> updateHostConfig(String alias, ConfigHostEntry entry);
  Future<void> deleteHostConfig(String alias);

  // Server config
  Future<ServerConfig> getServerConfig();
  Future<void> updateServerConfig(List<ServerConfigUpdate> updates);
  Future<void> restartSSHServer();
}

/// Update operation for server config
class ServerConfigUpdate {
  final String key;
  final String value;
  final bool delete;

  const ServerConfigUpdate({
    required this.key,
    required this.value,
    this.delete = false,
  });
}

/// Implementation of ConfigRepository adapting gRPC to domain.
class ConfigRepositoryImpl implements ConfigRepository {
  final GrpcClient _client;

  ConfigRepositoryImpl(this._client);

  // ============================================================
  // New unified SSH config API
  // ============================================================

  @override
  Future<List<SSHConfigEntry>> listSSHConfigEntries() async {
    final request = pb.ListSSHConfigEntriesRequest()
      ..target = (common.Target()..type = common.TargetType.TARGET_TYPE_LOCAL);

    final response = await _client.config.listSSHConfigEntries(request);
    return response.entries.map(_mapSSHConfigEntry).toList();
  }

  @override
  Stream<List<SSHConfigEntry>> watchSSHConfigEntries() {
    final request = pb.WatchSSHConfigEntriesRequest()
      ..target = (common.Target()..type = common.TargetType.TARGET_TYPE_LOCAL);

    return _client.config
        .watchSSHConfigEntries(request)
        .map((response) => response.entries.map(_mapSSHConfigEntry).toList());
  }

  @override
  Future<SSHConfigEntry> getSSHConfigEntry(String id) async {
    final request = pb.GetSSHConfigEntryRequest()
      ..target = (common.Target()..type = common.TargetType.TARGET_TYPE_LOCAL)
      ..id = id;

    final response = await _client.config.getSSHConfigEntry(request);
    return _mapSSHConfigEntry(response);
  }

  @override
  Future<SSHConfigEntry> createSSHConfigEntry(
    SSHConfigEntry entry, {
    int? insertPosition,
  }) async {
    final request = pb.CreateSSHConfigEntryRequest()
      ..target = (common.Target()..type = common.TargetType.TARGET_TYPE_LOCAL)
      ..entry = _mapToProtoSSHConfigEntry(entry)
      ..insertPosition = insertPosition ?? -1;

    final response = await _client.config.createSSHConfigEntry(request);
    return _mapSSHConfigEntry(response);
  }

  @override
  Future<SSHConfigEntry> updateSSHConfigEntry(
    String id,
    SSHConfigEntry entry,
  ) async {
    final request = pb.UpdateSSHConfigEntryRequest()
      ..target = (common.Target()..type = common.TargetType.TARGET_TYPE_LOCAL)
      ..id = id
      ..entry = _mapToProtoSSHConfigEntry(entry);

    final response = await _client.config.updateSSHConfigEntry(request);
    return _mapSSHConfigEntry(response);
  }

  @override
  Future<void> deleteSSHConfigEntry(String id) async {
    final request = pb.DeleteSSHConfigEntryRequest()
      ..target = (common.Target()..type = common.TargetType.TARGET_TYPE_LOCAL)
      ..id = id;

    await _client.config.deleteSSHConfigEntry(request);
  }

  @override
  Future<List<SSHConfigEntry>> reorderSSHConfigEntries(
    List<String> entryIds,
  ) async {
    final request = pb.ReorderSSHConfigEntriesRequest()
      ..target = (common.Target()..type = common.TargetType.TARGET_TYPE_LOCAL)
      ..entryIds.addAll(entryIds);

    final response = await _client.config.reorderSSHConfigEntries(request);
    return response.entries.map(_mapSSHConfigEntry).toList();
  }

  // ============================================================
  // Global directives API
  // ============================================================

  @override
  Future<List<GlobalDirective>> listGlobalDirectives() async {
    final request = pb.ListGlobalDirectivesRequest()
      ..target = (common.Target()..type = common.TargetType.TARGET_TYPE_LOCAL);

    final response = await _client.config.listGlobalDirectives(request);
    return response.directives
        .map((d) => GlobalDirective(key: d.key, value: d.value))
        .toList();
  }

  @override
  Future<GlobalDirective> setGlobalDirective(String key, String value) async {
    final request = pb.SetGlobalDirectiveRequest()
      ..target = (common.Target()..type = common.TargetType.TARGET_TYPE_LOCAL)
      ..key = key
      ..value = value;

    final response = await _client.config.setGlobalDirective(request);
    return GlobalDirective(key: response.key, value: response.value);
  }

  @override
  Future<void> deleteGlobalDirective(String key) async {
    final request = pb.DeleteGlobalDirectiveRequest()
      ..target = (common.Target()..type = common.TargetType.TARGET_TYPE_LOCAL)
      ..key = key;

    await _client.config.deleteGlobalDirective(request);
  }

  // ============================================================
  // Legacy client config API (backward compatibility)
  // ============================================================

  @override
  Future<List<ConfigHostEntry>> listHostConfigs() async {
    final request = pb.ListHostConfigsRequest()
      ..target = (common.Target()..type = common.TargetType.TARGET_TYPE_LOCAL);

    final response = await _client.config.listHostConfigs(request);
    return response.hosts.map(_mapHostEntry).toList();
  }

  @override
  Future<ConfigHostEntry> getHostConfig(String alias) async {
    final request = pb.GetHostConfigRequest()
      ..target = (common.Target()..type = common.TargetType.TARGET_TYPE_LOCAL)
      ..alias = alias;

    final response = await _client.config.getHostConfig(request);
    return _mapHostEntry(response);
  }

  @override
  Future<void> createHostConfig(ConfigHostEntry entry) async {
    final request = pb.CreateHostConfigRequest()
      ..target = (common.Target()..type = common.TargetType.TARGET_TYPE_LOCAL)
      ..config = _mapToProtoHostConfig(entry);

    await _client.config.createHostConfig(request);
  }

  @override
  Future<void> updateHostConfig(String alias, ConfigHostEntry entry) async {
    final request = pb.UpdateHostConfigRequest()
      ..target = (common.Target()..type = common.TargetType.TARGET_TYPE_LOCAL)
      ..alias = alias
      ..config = _mapToProtoHostConfig(entry);

    await _client.config.updateHostConfig(request);
  }

  @override
  Future<void> deleteHostConfig(String alias) async {
    final request = pb.DeleteHostConfigRequest()
      ..target = (common.Target()..type = common.TargetType.TARGET_TYPE_LOCAL)
      ..alias = alias;

    await _client.config.deleteHostConfig(request);
  }

  @override
  Future<ServerConfig> getServerConfig() async {
    final request = pb.GetServerConfigRequest()
      ..target = (common.Target()..type = common.TargetType.TARGET_TYPE_LOCAL);

    final response = await _client.config.getServerConfig(request);
    return ServerConfig(
      path: '/etc/ssh/sshd_config',
      options: response.directives
          .map(
            (d) => ServerConfigOption(
              key: d.key,
              value: d.value,
              lineNumber: d.lineNumber,
            ),
          )
          .toList(),
    );
  }

  @override
  Future<void> updateServerConfig(List<ServerConfigUpdate> updates) async {
    final request = pb.UpdateServerConfigRequest()
      ..target = (common.Target()..type = common.TargetType.TARGET_TYPE_LOCAL);

    for (final update in updates) {
      request.updates.add(
        pb.ServerConfigUpdate()
          ..key = update.key
          ..value = update.value
          ..delete = update.delete,
      );
    }

    await _client.config.updateServerConfig(request);
  }

  @override
  Future<void> restartSSHServer() async {
    final request = pb.RestartSSHServiceRequest()
      ..target = (common.Target()..type = common.TargetType.TARGET_TYPE_LOCAL);

    await _client.config.restartSSHService(request);
  }

  ConfigHostEntry _mapHostEntry(pb.HostConfig host) {
    return ConfigHostEntry(
      host: host.alias,
      hostname: host.hostname.isEmpty ? null : host.hostname,
      user: host.user.isEmpty ? null : host.user,
      port: host.port == 0 ? null : host.port,
      identityFile: host.identityFiles.isEmpty
          ? null
          : host.identityFiles.first,
      forwardAgent: host.forwardAgent,
      extraOptions: Map.from(host.extraOptions),
    );
  }

  pb.HostConfig _mapToProtoHostConfig(ConfigHostEntry entry) {
    final config = pb.HostConfig()..alias = entry.host;
    if (entry.hostname != null) config.hostname = entry.hostname!;
    if (entry.user != null) config.user = entry.user!;
    if (entry.port != null) config.port = entry.port!;
    if (entry.identityFile != null) {
      config.identityFiles.add(entry.identityFile!);
    }
    if (entry.forwardAgent != null) config.forwardAgent = entry.forwardAgent!;
    config.extraOptions.addAll(entry.extraOptions);
    return config;
  }

  // ============================================================
  // SSHConfigEntry mapping functions
  // ============================================================

  SSHConfigEntry _mapSSHConfigEntry(pb.SSHConfigEntry entry) {
    return SSHConfigEntry(
      id: entry.id,
      type: _mapEntryType(entry.type),
      position: entry.position,
      patterns: entry.patterns.toList(),
      options: _mapSSHOptions(entry.options),
    );
  }

  SSHConfigEntryType _mapEntryType(pb.SSHConfigEntryType type) {
    switch (type) {
      case pb.SSHConfigEntryType.SSH_CONFIG_ENTRY_TYPE_MATCH:
        return SSHConfigEntryType.match;
      case pb.SSHConfigEntryType.SSH_CONFIG_ENTRY_TYPE_HOST:
      default:
        return SSHConfigEntryType.host;
    }
  }

  SSHOptions _mapSSHOptions(pb.SSHOptions options) {
    return SSHOptions(
      hostname: options.hostname.isEmpty ? null : options.hostname,
      user: options.user.isEmpty ? null : options.user,
      port: options.port == 0 ? null : options.port,
      identityFiles: options.identityFiles.toList(),
      forwardAgent: options.forwardAgent ? true : null,
      proxyJump: options.proxyJump.isEmpty ? null : options.proxyJump,
      proxyCommand: options.proxyCommand.isEmpty ? null : options.proxyCommand,
      serverAliveInterval: options.serverAliveInterval == 0
          ? null
          : options.serverAliveInterval,
      serverAliveCountMax: options.serverAliveCountMax == 0
          ? null
          : options.serverAliveCountMax,
      identitiesOnly: options.identitiesOnly ? true : null,
      compression: options.compression ? true : null,
      strictHostKeyChecking: options.strictHostKeyChecking.isEmpty
          ? null
          : options.strictHostKeyChecking,
      extraOptions: Map.from(options.extraOptions),
    );
  }

  pb.SSHConfigEntry _mapToProtoSSHConfigEntry(SSHConfigEntry entry) {
    return pb.SSHConfigEntry()
      ..id = entry.id
      ..type = _mapToProtoEntryType(entry.type)
      ..position = entry.position
      ..patterns.addAll(entry.patterns)
      ..options = _mapToProtoSSHOptions(entry.options);
  }

  pb.SSHConfigEntryType _mapToProtoEntryType(SSHConfigEntryType type) {
    switch (type) {
      case SSHConfigEntryType.match:
        return pb.SSHConfigEntryType.SSH_CONFIG_ENTRY_TYPE_MATCH;
      case SSHConfigEntryType.host:
        return pb.SSHConfigEntryType.SSH_CONFIG_ENTRY_TYPE_HOST;
    }
  }

  pb.SSHOptions _mapToProtoSSHOptions(SSHOptions options) {
    final proto = pb.SSHOptions();
    if (options.hostname != null) proto.hostname = options.hostname!;
    if (options.user != null) proto.user = options.user!;
    if (options.port != null) proto.port = options.port!;
    proto.identityFiles.addAll(options.identityFiles);
    if (options.forwardAgent == true) proto.forwardAgent = true;
    if (options.proxyJump != null) proto.proxyJump = options.proxyJump!;
    if (options.proxyCommand != null) {
      proto.proxyCommand = options.proxyCommand!;
    }
    if (options.serverAliveInterval != null) {
      proto.serverAliveInterval = options.serverAliveInterval!;
    }
    if (options.serverAliveCountMax != null) {
      proto.serverAliveCountMax = options.serverAliveCountMax!;
    }
    if (options.identitiesOnly == true) proto.identitiesOnly = true;
    if (options.compression == true) proto.compression = true;
    if (options.strictHostKeyChecking != null) {
      proto.strictHostKeyChecking = options.strictHostKeyChecking!;
    }
    proto.extraOptions.addAll(options.extraOptions);
    return proto;
  }
}
