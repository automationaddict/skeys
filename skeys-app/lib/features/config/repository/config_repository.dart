import '../domain/config_entity.dart';
import '../../../core/grpc/grpc_client.dart';
import '../../../core/generated/skeys/v1/config.pb.dart' as pb;
import '../../../core/generated/skeys/v1/common.pb.dart' as common;

/// Abstract repository for SSH configuration management.
abstract class ConfigRepository {
  // Client config
  Future<List<ConfigHostEntry>> listHostConfigs();
  Future<ConfigHostEntry> getHostConfig(String alias);
  Future<void> createHostConfig(ConfigHostEntry entry);
  Future<void> updateHostConfig(String alias, ConfigHostEntry entry);
  Future<void> deleteHostConfig(String alias);

  // Server config
  Future<ServerConfig> getServerConfig();
  Future<void> updateServerConfig(List<ServerConfigUpdate> updates);
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
      options: response.directives.map((d) => ServerConfigOption(
        key: d.key,
        value: d.value,
        lineNumber: d.lineNumber,
      )).toList(),
    );
  }

  @override
  Future<void> updateServerConfig(List<ServerConfigUpdate> updates) async {
    final request = pb.UpdateServerConfigRequest()
      ..target = (common.Target()..type = common.TargetType.TARGET_TYPE_LOCAL);

    for (final update in updates) {
      request.updates.add(pb.ServerConfigUpdate()
        ..key = update.key
        ..value = update.value
        ..delete = update.delete);
    }

    await _client.config.updateServerConfig(request);
  }

  ConfigHostEntry _mapHostEntry(pb.HostConfig host) {
    return ConfigHostEntry(
      host: host.alias,
      hostname: host.hostname.isEmpty ? null : host.hostname,
      user: host.user.isEmpty ? null : host.user,
      port: host.port == 0 ? null : host.port,
      identityFile: host.identityFiles.isEmpty ? null : host.identityFiles.first,
      forwardAgent: host.forwardAgent,
      extraOptions: Map.from(host.extraOptions),
    );
  }

  pb.HostConfig _mapToProtoHostConfig(ConfigHostEntry entry) {
    final config = pb.HostConfig()..alias = entry.host;
    if (entry.hostname != null) config.hostname = entry.hostname!;
    if (entry.user != null) config.user = entry.user!;
    if (entry.port != null) config.port = entry.port!;
    if (entry.identityFile != null) config.identityFiles.add(entry.identityFile!);
    if (entry.forwardAgent != null) config.forwardAgent = entry.forwardAgent!;
    config.extraOptions.addAll(entry.extraOptions);
    return config;
  }
}
