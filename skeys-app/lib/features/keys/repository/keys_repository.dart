import '../domain/key_entity.dart';
import '../../../core/grpc/grpc_client.dart';
import '../../../core/generated/skeys/v1/keys.pb.dart' as pb;
import '../../../core/generated/skeys/v1/common.pb.dart' as common;

/// Abstract repository interface for SSH key operations.
///
/// This follows the Adapter Pattern - the implementation adapts
/// the gRPC interface to the domain interface.
abstract class KeysRepository {
  Future<List<KeyEntity>> listKeys();
  Future<KeyEntity> getKey(String keyId);
  Future<KeyEntity> generateKey({
    required String name,
    required KeyType type,
    int? bits,
    String? comment,
    String? passphrase,
    bool addToAgent = false,
  });
  Future<void> deleteKey(String keyId);
  Future<void> changePassphrase(String keyId, String oldPassphrase, String newPassphrase);
  Future<String> getFingerprint(String keyId);

  /// Returns a stream of key list updates.
  /// The stream emits the full list whenever keys change on the server.
  Stream<List<KeyEntity>> watchKeys();
}

/// Implementation of KeysRepository that adapts gRPC to domain interface.
class KeysRepositoryImpl implements KeysRepository {
  final GrpcClient _client;

  KeysRepositoryImpl(this._client);

  @override
  Future<List<KeyEntity>> listKeys() async {
    final request = pb.ListKeysRequest()
      ..target = (common.Target()..type = common.TargetType.TARGET_TYPE_LOCAL);

    final response = await _client.keys.listKeys(request);
    return response.keys.map(_mapToEntity).toList();
  }

  @override
  Future<KeyEntity> getKey(String keyId) async {
    final request = pb.GetKeyRequest()
      ..target = (common.Target()..type = common.TargetType.TARGET_TYPE_LOCAL)
      ..keyId = keyId;

    final response = await _client.keys.getKey(request);
    return _mapToEntity(response);
  }

  @override
  Future<KeyEntity> generateKey({
    required String name,
    required KeyType type,
    int? bits,
    String? comment,
    String? passphrase,
    bool addToAgent = false,
  }) async {
    final request = pb.GenerateKeyRequest()
      ..target = (common.Target()..type = common.TargetType.TARGET_TYPE_LOCAL)
      ..name = name
      ..type = _mapKeyType(type)
      ..addToAgent = addToAgent;

    if (bits != null) request.bits = bits;
    if (comment != null) request.comment = comment;
    if (passphrase != null) request.passphrase = passphrase;

    final response = await _client.keys.generateKey(request);
    return _mapToEntity(response);
  }

  @override
  Future<void> deleteKey(String keyId) async {
    final request = pb.DeleteKeyRequest()
      ..target = (common.Target()..type = common.TargetType.TARGET_TYPE_LOCAL)
      ..keyId = keyId;

    await _client.keys.deleteKey(request);
  }

  @override
  Future<void> changePassphrase(
    String keyId,
    String oldPassphrase,
    String newPassphrase,
  ) async {
    final request = pb.ChangePassphraseRequest()
      ..target = (common.Target()..type = common.TargetType.TARGET_TYPE_LOCAL)
      ..keyId = keyId
      ..oldPassphrase = oldPassphrase
      ..newPassphrase = newPassphrase;

    await _client.keys.changePassphrase(request);
  }

  @override
  Future<String> getFingerprint(String keyId) async {
    final request = pb.GetFingerprintRequest()
      ..target = (common.Target()..type = common.TargetType.TARGET_TYPE_LOCAL)
      ..keyId = keyId
      ..algorithm = pb.FingerprintAlgorithm.FINGERPRINT_ALGORITHM_SHA256;

    final response = await _client.keys.getFingerprint(request);
    return response.fingerprint;
  }

  @override
  Stream<List<KeyEntity>> watchKeys() {
    final request = pb.WatchKeysRequest()
      ..target = (common.Target()..type = common.TargetType.TARGET_TYPE_LOCAL);

    return _client.keys.watchKeys(request).map(
      (response) => response.keys.map(_mapToEntity).toList(),
    );
  }

  KeyEntity _mapToEntity(pb.SSHKey key) {
    return KeyEntity(
      path: key.privateKeyPath,
      name: key.name,
      type: _mapKeyTypeFromProto(key.type),
      bits: key.bits,
      fingerprint: key.fingerprintSha256,
      publicKey: key.publicKey,
      comment: key.comment,
      createdAt: key.hasCreatedAt() ? key.createdAt.toDateTime() : DateTime.now(),
      modifiedAt: key.hasModifiedAt() ? key.modifiedAt.toDateTime() : DateTime.now(),
      hasPassphrase: key.hasPassphrase,
      isInAgent: key.inAgent,
    );
  }

  KeyType _mapKeyTypeFromProto(pb.KeyType type) {
    switch (type) {
      case pb.KeyType.KEY_TYPE_RSA:
        return KeyType.rsa;
      case pb.KeyType.KEY_TYPE_ED25519:
        return KeyType.ed25519;
      case pb.KeyType.KEY_TYPE_ECDSA:
        return KeyType.ecdsa;
      case pb.KeyType.KEY_TYPE_ED25519_SK:
        return KeyType.ed25519Sk;
      case pb.KeyType.KEY_TYPE_ECDSA_SK:
        return KeyType.ecdsaSk;
      default:
        return KeyType.unknown;
    }
  }

  pb.KeyType _mapKeyType(KeyType type) {
    switch (type) {
      case KeyType.rsa:
        return pb.KeyType.KEY_TYPE_RSA;
      case KeyType.ed25519:
        return pb.KeyType.KEY_TYPE_ED25519;
      case KeyType.ecdsa:
        return pb.KeyType.KEY_TYPE_ECDSA;
      case KeyType.ed25519Sk:
        return pb.KeyType.KEY_TYPE_ED25519_SK;
      case KeyType.ecdsaSk:
        return pb.KeyType.KEY_TYPE_ECDSA_SK;
      case KeyType.unknown:
        return pb.KeyType.KEY_TYPE_UNSPECIFIED;
    }
  }
}
