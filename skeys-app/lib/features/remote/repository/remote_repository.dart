import '../domain/remote_entity.dart';
import '../../../core/grpc/grpc_client.dart';
import '../../../core/generated/skeys/v1/remote.pb.dart' as pb;

/// Abstract repository for remote server management.
abstract class RemoteRepository {
  Future<List<RemoteEntity>> listRemotes();
  Future<RemoteEntity> getRemote(String id);
  Future<RemoteEntity> addRemote({
    required String name,
    required String host,
    required int port,
    required String user,
    String? identityFile,
    String? sshConfigAlias,
  });
  Future<RemoteEntity> updateRemote(RemoteEntity remote);
  Future<void> deleteRemote(String id);
  Future<ConnectionEntity> connect(String remoteId, {String? passphrase});
  Future<void> disconnect(String connectionId);
  Future<List<ConnectionEntity>> listConnections();
  Stream<List<ConnectionEntity>> watchConnections();
  Future<CommandResult> executeCommand(String connectionId, String command, {int? timeout});
  Future<TestConnectionResult> testConnection({
    required String host,
    required int port,
    required String user,
    required String identityFile,
    int? timeoutSeconds,
    String? passphrase,
    bool trustHostKey = false,
  });
}

/// Implementation adapting gRPC to domain.
class RemoteRepositoryImpl implements RemoteRepository {
  final GrpcClient _client;

  RemoteRepositoryImpl(this._client);

  @override
  Future<List<RemoteEntity>> listRemotes() async {
    final response = await _client.remote.listRemotes(pb.ListRemotesRequest());
    return response.remotes.map(_mapRemote).toList();
  }

  @override
  Future<RemoteEntity> getRemote(String id) async {
    final request = pb.GetRemoteRequest()..id = id;
    final response = await _client.remote.getRemote(request);
    return _mapRemote(response);
  }

  @override
  Future<RemoteEntity> addRemote({
    required String name,
    required String host,
    required int port,
    required String user,
    String? identityFile,
    String? sshConfigAlias,
  }) async {
    final request = pb.AddRemoteRequest()
      ..name = name
      ..host = host
      ..port = port
      ..user = user;

    if (identityFile != null) request.identityFile = identityFile;
    if (sshConfigAlias != null) request.sshConfigAlias = sshConfigAlias;

    final response = await _client.remote.addRemote(request);
    return _mapRemote(response);
  }

  @override
  Future<RemoteEntity> updateRemote(RemoteEntity remote) async {
    final request = pb.UpdateRemoteRequest()
      ..id = remote.id
      ..name = remote.name
      ..host = remote.host
      ..port = remote.port
      ..user = remote.user;

    if (remote.identityFile != null) request.identityFile = remote.identityFile!;
    if (remote.sshConfigAlias != null) request.sshConfigAlias = remote.sshConfigAlias!;

    final response = await _client.remote.updateRemote(request);
    return _mapRemote(response);
  }

  @override
  Future<void> deleteRemote(String id) async {
    final request = pb.DeleteRemoteRequest()..id = id;
    await _client.remote.deleteRemote(request);
  }

  @override
  Future<ConnectionEntity> connect(String remoteId, {String? passphrase}) async {
    final request = pb.ConnectRequest()..remoteId = remoteId;
    if (passphrase != null) request.passphrase = passphrase;

    final response = await _client.remote.connect(request);
    return _mapConnection(response.connection);
  }

  @override
  Future<void> disconnect(String connectionId) async {
    final request = pb.DisconnectRequest()..connectionId = connectionId;
    await _client.remote.disconnect(request);
  }

  @override
  Future<List<ConnectionEntity>> listConnections() async {
    final response = await _client.remote.listConnections(pb.ListConnectionsRequest());
    return response.connections.map(_mapConnection).toList();
  }

  @override
  Stream<List<ConnectionEntity>> watchConnections() {
    final request = pb.WatchConnectionsRequest();
    return _client.remote.watchConnections(request).map(
      (response) => response.connections.map(_mapConnection).toList()
    );
  }

  @override
  Future<CommandResult> executeCommand(String connectionId, String command, {int? timeout}) async {
    final request = pb.ExecuteCommandRequest()
      ..connectionId = connectionId
      ..command = command;

    if (timeout != null) request.timeoutSeconds = timeout;

    final response = await _client.remote.executeCommand(request);
    return CommandResult(
      exitCode: response.exitCode,
      stdout: response.stdout,
      stderr: response.stderr,
    );
  }

  @override
  Future<TestConnectionResult> testConnection({
    required String host,
    required int port,
    required String user,
    required String identityFile,
    int? timeoutSeconds,
    String? passphrase,
    bool trustHostKey = false,
  }) async {
    final request = pb.TestRemoteConnectionRequest()
      ..host = host
      ..port = port
      ..user = user
      ..identityFile = identityFile
      ..trustHostKey = trustHostKey;

    if (timeoutSeconds != null) request.timeoutSeconds = timeoutSeconds;
    if (passphrase != null) request.passphrase = passphrase;

    final response = await _client.remote.testConnection(request);
    return TestConnectionResult(
      success: response.success,
      message: response.message,
      serverVersion: response.serverVersion.isEmpty ? null : response.serverVersion,
      latencyMs: response.latencyMs > 0 ? response.latencyMs : null,
      hostKeyStatus: _mapHostKeyStatus(response.hostKeyStatus),
      hostKeyInfo: response.hasHostKeyInfo() ? _mapHostKeyInfo(response.hostKeyInfo) : null,
    );
  }

  HostKeyVerificationStatus _mapHostKeyStatus(pb.HostKeyStatus status) {
    switch (status) {
      case pb.HostKeyStatus.HOST_KEY_STATUS_VERIFIED:
        return HostKeyVerificationStatus.verified;
      case pb.HostKeyStatus.HOST_KEY_STATUS_UNKNOWN:
        return HostKeyVerificationStatus.unknown;
      case pb.HostKeyStatus.HOST_KEY_STATUS_MISMATCH:
        return HostKeyVerificationStatus.mismatch;
      case pb.HostKeyStatus.HOST_KEY_STATUS_ADDED:
        return HostKeyVerificationStatus.added;
      default:
        return HostKeyVerificationStatus.unspecified;
    }
  }

  HostKeyInfo _mapHostKeyInfo(pb.HostKeyInfo info) {
    return HostKeyInfo(
      hostname: info.hostname,
      port: info.port,
      keyType: info.keyType,
      fingerprint: info.fingerprint,
      publicKey: info.publicKey,
    );
  }

  RemoteEntity _mapRemote(pb.Remote remote) {
    return RemoteEntity(
      id: remote.id,
      name: remote.name,
      host: remote.host,
      port: remote.port,
      user: remote.user,
      identityFile: remote.identityFile.isEmpty ? null : remote.identityFile,
      sshConfigAlias: remote.sshConfigAlias.isEmpty ? null : remote.sshConfigAlias,
      createdAt: remote.createdAt.toDateTime(),
      lastConnectedAt: remote.hasLastConnectedAt() ? remote.lastConnectedAt.toDateTime() : null,
      status: _mapStatus(remote.status),
    );
  }

  RemoteStatus _mapStatus(pb.RemoteStatus status) {
    switch (status) {
      case pb.RemoteStatus.REMOTE_STATUS_CONNECTED:
        return RemoteStatus.connected;
      case pb.RemoteStatus.REMOTE_STATUS_CONNECTING:
        return RemoteStatus.connecting;
      case pb.RemoteStatus.REMOTE_STATUS_ERROR:
        return RemoteStatus.error;
      default:
        return RemoteStatus.disconnected;
    }
  }

  ConnectionEntity _mapConnection(pb.Connection conn) {
    return ConnectionEntity(
      id: conn.id,
      remoteId: conn.remoteId,
      host: conn.host,
      port: conn.port,
      user: conn.user,
      serverVersion: conn.serverVersion,
      connectedAt: conn.connectedAt.toDateTime(),
      lastActivityAt: conn.lastActivityAt.toDateTime(),
    );
  }
}
