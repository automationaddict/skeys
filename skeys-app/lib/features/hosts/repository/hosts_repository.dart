import '../domain/host_entity.dart';
import '../../../core/grpc/grpc_client.dart';
import '../../../core/generated/skeys/v1/hosts.pb.dart' as pb;
import '../../../core/generated/skeys/v1/common.pb.dart' as common;

/// Abstract repository for host management.
abstract class HostsRepository {
  // Known hosts
  Future<List<KnownHostEntry>> listKnownHosts();
  Future<void> removeKnownHost(String hostname, {int port = 22});
  Future<void> hashKnownHosts();

  // Authorized keys
  Future<List<AuthorizedKeyEntry>> listAuthorizedKeys({String? user});
  Future<void> addAuthorizedKey(String publicKey, {List<String>? options, String? user});
  Future<void> removeAuthorizedKey(String keyId, {String? user});
}

/// Implementation adapting gRPC to domain.
class HostsRepositoryImpl implements HostsRepository {
  final GrpcClient _client;

  HostsRepositoryImpl(this._client);

  @override
  Future<List<KnownHostEntry>> listKnownHosts() async {
    final request = pb.ListKnownHostsRequest()
      ..target = (common.Target()..type = common.TargetType.TARGET_TYPE_LOCAL);

    final response = await _client.hosts.listKnownHosts(request);
    return response.hosts.map((h) => KnownHostEntry(
      host: h.hostnames.isNotEmpty ? h.hostnames.first : '',
      keyType: h.keyType,
      publicKey: h.publicKey,
      isHashed: h.isHashed,
    )).toList();
  }

  @override
  Future<void> removeKnownHost(String hostname, {int port = 22}) async {
    final request = pb.RemoveKnownHostRequest()
      ..target = (common.Target()..type = common.TargetType.TARGET_TYPE_LOCAL)
      ..hostname = hostname
      ..port = port;

    await _client.hosts.removeKnownHost(request);
  }

  @override
  Future<void> hashKnownHosts() async {
    final request = pb.HashKnownHostsRequest()
      ..target = (common.Target()..type = common.TargetType.TARGET_TYPE_LOCAL);

    await _client.hosts.hashKnownHosts(request);
  }

  @override
  Future<List<AuthorizedKeyEntry>> listAuthorizedKeys({String? user}) async {
    final request = pb.ListAuthorizedKeysRequest()
      ..target = (common.Target()..type = common.TargetType.TARGET_TYPE_LOCAL);
    if (user != null) request.user = user;

    final response = await _client.hosts.listAuthorizedKeys(request);
    return response.keys.map((k) => AuthorizedKeyEntry(
      keyType: k.keyType,
      publicKey: k.publicKey,
      comment: k.comment,
      options: List.from(k.options),
    )).toList();
  }

  @override
  Future<void> addAuthorizedKey(String publicKey, {List<String>? options, String? user}) async {
    final request = pb.AddAuthorizedKeyRequest()
      ..target = (common.Target()..type = common.TargetType.TARGET_TYPE_LOCAL)
      ..publicKey = publicKey;
    if (options != null) request.options.addAll(options);
    if (user != null) request.user = user;

    await _client.hosts.addAuthorizedKey(request);
  }

  @override
  Future<void> removeAuthorizedKey(String keyId, {String? user}) async {
    final request = pb.RemoveAuthorizedKeyRequest()
      ..target = (common.Target()..type = common.TargetType.TARGET_TYPE_LOCAL)
      ..keyId = keyId;
    if (user != null) request.user = user;

    await _client.hosts.removeAuthorizedKey(request);
  }
}
