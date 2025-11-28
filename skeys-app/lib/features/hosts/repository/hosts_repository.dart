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

import '../domain/host_entity.dart';
import '../../../core/grpc/grpc_client.dart';
import '../../../core/generated/skeys/v1/hosts.pb.dart' as pb;
import '../../../core/generated/skeys/v1/common.pb.dart' as common;

/// Abstract repository for host management.
abstract class HostsRepository {
  // Known hosts
  Future<List<KnownHostEntry>> listKnownHosts();
  Stream<List<KnownHostEntry>> watchKnownHosts();
  Future<void> removeKnownHost(String hostname, {int port = 22});
  Future<void> hashKnownHosts();
  Future<List<ScannedHostKey>> scanHostKeys(
    String hostname, {
    int port = 22,
    int timeout = 10,
  });
  Future<KnownHostEntry> addKnownHost(
    String hostname,
    String keyType,
    String publicKey, {
    int port = 22,
    bool hashHostname = false,
  });

  // Authorized keys
  Future<List<AuthorizedKeyEntry>> listAuthorizedKeys({String? user});
  Stream<List<AuthorizedKeyEntry>> watchAuthorizedKeys({String? user});
  Future<void> addAuthorizedKey(
    String publicKey, {
    List<String>? options,
    String? user,
  });
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
    return response.hosts
        .map(
          (h) => KnownHostEntry(
            host: h.hostnames.isNotEmpty ? h.hostnames.first : '',
            keyType: h.keyType,
            publicKey: h.publicKey,
            isHashed: h.isHashed,
          ),
        )
        .toList();
  }

  @override
  Stream<List<KnownHostEntry>> watchKnownHosts() {
    final request = pb.WatchKnownHostsRequest()
      ..target = (common.Target()..type = common.TargetType.TARGET_TYPE_LOCAL);

    return _client.hosts
        .watchKnownHosts(request)
        .map(
          (response) => response.hosts
              .map(
                (h) => KnownHostEntry(
                  host: h.hostnames.isNotEmpty ? h.hostnames.first : '',
                  keyType: h.keyType,
                  publicKey: h.publicKey,
                  isHashed: h.isHashed,
                ),
              )
              .toList(),
        );
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
  Future<List<ScannedHostKey>> scanHostKeys(
    String hostname, {
    int port = 22,
    int timeout = 10,
  }) async {
    final request = pb.ScanHostKeysRequest()
      ..hostname = hostname
      ..port = port
      ..timeoutSeconds = timeout;

    final response = await _client.hosts.scanHostKeys(request);
    return response.keys
        .map(
          (k) => ScannedHostKey(
            hostname: k.hostname,
            port: k.port,
            keyType: k.keyType,
            publicKey: k.publicKey,
            fingerprint: k.fingerprint,
          ),
        )
        .toList();
  }

  @override
  Future<KnownHostEntry> addKnownHost(
    String hostname,
    String keyType,
    String publicKey, {
    int port = 22,
    bool hashHostname = false,
  }) async {
    final request = pb.AddKnownHostRequest()
      ..target = (common.Target()..type = common.TargetType.TARGET_TYPE_LOCAL)
      ..hostname = hostname
      ..port = port
      ..keyType = keyType
      ..publicKey = publicKey
      ..hashHostname = hashHostname;

    final response = await _client.hosts.addKnownHost(request);
    return KnownHostEntry(
      host: response.hostnames.isNotEmpty ? response.hostnames.first : hostname,
      keyType: response.keyType,
      publicKey: response.publicKey,
      isHashed: response.isHashed,
    );
  }

  @override
  Future<List<AuthorizedKeyEntry>> listAuthorizedKeys({String? user}) async {
    final request = pb.ListAuthorizedKeysRequest()
      ..target = (common.Target()..type = common.TargetType.TARGET_TYPE_LOCAL);
    if (user != null) request.user = user;

    final response = await _client.hosts.listAuthorizedKeys(request);
    return response.keys
        .map(
          (k) => AuthorizedKeyEntry(
            keyType: k.keyType,
            publicKey: k.publicKey,
            comment: k.comment,
            options: List.from(k.options),
          ),
        )
        .toList();
  }

  @override
  Stream<List<AuthorizedKeyEntry>> watchAuthorizedKeys({String? user}) {
    final request = pb.WatchAuthorizedKeysRequest()
      ..target = (common.Target()..type = common.TargetType.TARGET_TYPE_LOCAL);
    if (user != null) request.user = user;

    return _client.hosts
        .watchAuthorizedKeys(request)
        .map(
          (response) => response.keys
              .map(
                (k) => AuthorizedKeyEntry(
                  keyType: k.keyType,
                  publicKey: k.publicKey,
                  comment: k.comment,
                  options: List.from(k.options),
                ),
              )
              .toList(),
        );
  }

  @override
  Future<void> addAuthorizedKey(
    String publicKey, {
    List<String>? options,
    String? user,
  }) async {
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
