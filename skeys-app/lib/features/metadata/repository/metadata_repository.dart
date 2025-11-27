import '../domain/key_metadata_entity.dart';
import '../../../core/grpc/grpc_client.dart';
import '../../../core/generated/skeys/v1/metadata.pb.dart' as pb;

/// Abstract repository for key metadata management.
abstract class MetadataRepository {
  Future<KeyMetadataEntity?> getKeyMetadata(String keyPath);
  Future<void> setKeyMetadata(KeyMetadataEntity metadata);
  Future<void> deleteKeyMetadata(String keyPath);
  Future<List<KeyMetadataEntity>> listKeyMetadata();
}

/// Implementation adapting gRPC to domain.
class MetadataRepositoryImpl implements MetadataRepository {
  final GrpcClient _client;

  MetadataRepositoryImpl(this._client);

  @override
  Future<KeyMetadataEntity?> getKeyMetadata(String keyPath) async {
    try {
      final request = pb.GetKeyMetadataRequest()..keyPath = keyPath;
      final response = await _client.metadata.getKeyMetadata(request);
      return _toEntity(response);
    } catch (e) {
      // Return null if not found
      return null;
    }
  }

  @override
  Future<void> setKeyMetadata(KeyMetadataEntity metadata) async {
    final pbMeta = pb.KeyMetadata()
      ..keyPath = metadata.keyPath;
    if (metadata.verifiedService != null) {
      pbMeta.verifiedService = metadata.verifiedService!;
    }
    if (metadata.verifiedHost != null) {
      pbMeta.verifiedHost = metadata.verifiedHost!;
    }
    if (metadata.verifiedPort != null) {
      pbMeta.verifiedPort = metadata.verifiedPort!;
    }
    if (metadata.verifiedUser != null) {
      pbMeta.verifiedUser = metadata.verifiedUser!;
    }

    final request = pb.SetKeyMetadataRequest()..metadata = pbMeta;
    await _client.metadata.setKeyMetadata(request);
  }

  @override
  Future<void> deleteKeyMetadata(String keyPath) async {
    final request = pb.DeleteKeyMetadataRequest()..keyPath = keyPath;
    await _client.metadata.deleteKeyMetadata(request);
  }

  @override
  Future<List<KeyMetadataEntity>> listKeyMetadata() async {
    final request = pb.ListKeyMetadataRequest();
    final response = await _client.metadata.listKeyMetadata(request);
    return response.metadata.map(_toEntity).toList();
  }

  KeyMetadataEntity _toEntity(pb.KeyMetadata meta) {
    return KeyMetadataEntity(
      keyPath: meta.keyPath,
      verifiedService: meta.verifiedService.isEmpty ? null : meta.verifiedService,
      verifiedHost: meta.verifiedHost.isEmpty ? null : meta.verifiedHost,
      verifiedPort: meta.verifiedPort == 0 ? null : meta.verifiedPort,
      verifiedUser: meta.verifiedUser.isEmpty ? null : meta.verifiedUser,
    );
  }
}
