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

import '../domain/agent_entity.dart';
import '../../../core/grpc/grpc_client.dart';
import '../../../core/generated/skeys/v1/agent.pb.dart' as pb;
import '../../../core/generated/skeys/v1/common.pb.dart' as common;
import '../../../core/generated/google/protobuf/duration.pb.dart'
    as pb_duration;

/// Combined status and keys from agent watch stream.
class AgentWatchState {
  final AgentStatus status;
  final List<AgentKeyEntry> keys;

  AgentWatchState({required this.status, required this.keys});
}

/// Abstract repository for SSH agent operations.
abstract class AgentRepository {
  Future<AgentStatus> getStatus();
  Future<List<AgentKeyEntry>> listKeys();
  Future<void> addKey(
    String keyPath, {
    String? passphrase,
    Duration? lifetime,
    bool confirm = false,
  });
  Future<void> removeKey(String fingerprint);
  Future<void> removeAllKeys();
  Future<void> lock(String passphrase);
  Future<void> unlock(String passphrase);

  /// Returns a stream of agent status and key updates.
  /// The stream emits whenever status or keys change on the server.
  Stream<AgentWatchState> watchAgent();
}

/// Implementation adapting gRPC to domain.
class AgentRepositoryImpl implements AgentRepository {
  final GrpcClient _client;

  AgentRepositoryImpl(this._client);

  @override
  Future<AgentStatus> getStatus() async {
    final request = pb.GetAgentStatusRequest()
      ..target = (common.Target()..type = common.TargetType.TARGET_TYPE_LOCAL);

    final response = await _client.agent.getAgentStatus(request);
    return AgentStatus(
      isRunning: response.running,
      socketPath: response.socketPath,
      isLocked: response.isLocked,
      keyCount: response.keyCount,
    );
  }

  @override
  Future<List<AgentKeyEntry>> listKeys() async {
    final request = pb.ListAgentKeysRequest()
      ..target = (common.Target()..type = common.TargetType.TARGET_TYPE_LOCAL);

    final response = await _client.agent.listAgentKeys(request);
    return response.keys
        .map(
          (k) => AgentKeyEntry(
            fingerprint: k.fingerprint,
            comment: k.comment,
            type: k.type,
            bits: k.bits,
            hasLifetime: k.hasLifetime,
            lifetimeSeconds: k.lifetimeSeconds,
            requiresConfirmation: k.isConfirm,
          ),
        )
        .toList();
  }

  @override
  Future<void> addKey(
    String keyPath, {
    String? passphrase,
    Duration? lifetime,
    bool confirm = false,
  }) async {
    final request = pb.AddKeyToAgentRequest()
      ..target = (common.Target()..type = common.TargetType.TARGET_TYPE_LOCAL)
      ..keyPath = keyPath
      ..confirm = confirm;

    if (passphrase != null) {
      request.passphrase = passphrase;
    }
    if (lifetime != null) {
      request.lifetime = pb_duration.Duration.fromDart(lifetime);
    }

    await _client.agent.addKeyToAgent(request);
  }

  @override
  Future<void> removeKey(String fingerprint) async {
    final request = pb.RemoveKeyFromAgentRequest()
      ..target = (common.Target()..type = common.TargetType.TARGET_TYPE_LOCAL)
      ..fingerprint = fingerprint;

    await _client.agent.removeKeyFromAgent(request);
  }

  @override
  Future<void> removeAllKeys() async {
    final request = pb.RemoveAllKeysFromAgentRequest()
      ..target = (common.Target()..type = common.TargetType.TARGET_TYPE_LOCAL);

    await _client.agent.removeAllKeysFromAgent(request);
  }

  @override
  Future<void> lock(String passphrase) async {
    final request = pb.LockAgentRequest()
      ..target = (common.Target()..type = common.TargetType.TARGET_TYPE_LOCAL)
      ..passphrase = passphrase;

    await _client.agent.lockAgent(request);
  }

  @override
  Future<void> unlock(String passphrase) async {
    final request = pb.UnlockAgentRequest()
      ..target = (common.Target()..type = common.TargetType.TARGET_TYPE_LOCAL)
      ..passphrase = passphrase;

    await _client.agent.unlockAgent(request);
  }

  @override
  Stream<AgentWatchState> watchAgent() {
    final request = pb.WatchAgentRequest()
      ..target = (common.Target()..type = common.TargetType.TARGET_TYPE_LOCAL);

    return _client.agent.watchAgent(request).map((response) {
      final status = AgentStatus(
        isRunning: response.running,
        socketPath: response.socketPath,
        isLocked: response.isLocked,
        keyCount: response.keys.length,
      );

      final keys = response.keys
          .map(
            (k) => AgentKeyEntry(
              fingerprint: k.fingerprint,
              comment: k.comment,
              type: k.type,
              bits: k.bits,
              hasLifetime: k.hasLifetime,
              lifetimeSeconds: k.lifetimeSeconds,
              requiresConfirmation: k.isConfirm,
            ),
          )
          .toList();

      return AgentWatchState(status: status, keys: keys);
    });
  }
}
