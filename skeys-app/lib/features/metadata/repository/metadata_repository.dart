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
    final pbMeta = pb.KeyMetadata()..keyPath = metadata.keyPath;
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
      verifiedService: meta.verifiedService.isEmpty
          ? null
          : meta.verifiedService,
      verifiedHost: meta.verifiedHost.isEmpty ? null : meta.verifiedHost,
      verifiedPort: meta.verifiedPort == 0 ? null : meta.verifiedPort,
      verifiedUser: meta.verifiedUser.isEmpty ? null : meta.verifiedUser,
    );
  }
}
