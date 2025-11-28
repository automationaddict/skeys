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

// Re-export entities for convenience
export 'package:skeys_app/features/keys/domain/key_entity.dart';
export 'package:skeys_app/features/hosts/domain/host_entity.dart';
export 'package:skeys_app/features/agent/domain/agent_entity.dart';
export 'package:skeys_app/features/remote/domain/remote_entity.dart';
export 'package:skeys_app/features/config/domain/config_entity.dart';
export 'package:skeys_app/features/config/domain/ssh_config_entry.dart';

import 'package:skeys_app/features/keys/domain/key_entity.dart';
import 'package:skeys_app/features/hosts/domain/host_entity.dart';
import 'package:skeys_app/features/agent/domain/agent_entity.dart';
import 'package:skeys_app/features/remote/domain/remote_entity.dart';
import 'package:skeys_app/features/config/domain/config_entity.dart';
import 'package:skeys_app/features/config/domain/ssh_config_entry.dart';

/// Test data factory for creating test entities.
class TestDataFactory {
  /// Creates a sample KeyEntity for testing.
  static KeyEntity createKeyEntity({
    String path = '/home/user/.ssh/id_ed25519',
    String name = 'id_ed25519',
    KeyType type = KeyType.ed25519,
    int bits = 256,
    String fingerprint = 'SHA256:abc123def456',
    String publicKey = 'ssh-ed25519 AAAAC3NzaC1... test@example.com',
    String comment = 'test@example.com',
    DateTime? createdAt,
    DateTime? modifiedAt,
    bool hasPassphrase = false,
    bool isInAgent = false,
  }) {
    return KeyEntity(
      path: path,
      name: name,
      type: type,
      bits: bits,
      fingerprint: fingerprint,
      publicKey: publicKey,
      comment: comment,
      createdAt: createdAt ?? DateTime(2024, 1, 1),
      modifiedAt: modifiedAt ?? DateTime(2024, 1, 1),
      hasPassphrase: hasPassphrase,
      isInAgent: isInAgent,
    );
  }

  /// Creates a list of sample KeyEntities for testing.
  static List<KeyEntity> createKeyEntityList({int count = 3}) {
    return List.generate(
      count,
      (i) => createKeyEntity(
        path: '/home/user/.ssh/key_$i',
        name: 'key_$i',
        fingerprint: 'SHA256:fingerprint$i',
      ),
    );
  }

  /// Creates a sample KnownHostEntry for testing.
  static KnownHostEntry createKnownHostEntry({
    String host = 'github.com',
    String keyType = 'ssh-ed25519',
    String publicKey = 'AAAAC3Nza...',
    bool isHashed = false,
  }) {
    return KnownHostEntry(
      host: host,
      keyType: keyType,
      publicKey: publicKey,
      isHashed: isHashed,
    );
  }

  /// Creates a sample AuthorizedKeyEntry for testing.
  static AuthorizedKeyEntry createAuthorizedKeyEntry({
    String keyType = 'ssh-ed25519',
    String publicKey = 'AAAAC3NzaC1...',
    String comment = 'test@example.com',
    List<String> options = const [],
  }) {
    return AuthorizedKeyEntry(
      keyType: keyType,
      publicKey: publicKey,
      comment: comment,
      options: options,
    );
  }

  /// Creates a sample ScannedHostKey for testing.
  static ScannedHostKey createScannedHostKey({
    String hostname = 'github.com',
    int port = 22,
    String keyType = 'ssh-ed25519',
    String publicKey = 'AAAAC3NzaC1...',
    String fingerprint = 'SHA256:abc123',
  }) {
    return ScannedHostKey(
      hostname: hostname,
      port: port,
      keyType: keyType,
      publicKey: publicKey,
      fingerprint: fingerprint,
    );
  }

  /// Creates a sample AgentKeyEntry for testing.
  static AgentKeyEntry createAgentKeyEntry({
    String fingerprint = 'SHA256:abc123',
    String comment = 'test@example.com',
    String type = 'ssh-ed25519',
    int bits = 256,
    bool hasLifetime = false,
    int lifetimeSeconds = 0,
    bool requiresConfirmation = false,
  }) {
    return AgentKeyEntry(
      fingerprint: fingerprint,
      comment: comment,
      type: type,
      bits: bits,
      hasLifetime: hasLifetime,
      lifetimeSeconds: lifetimeSeconds,
      requiresConfirmation: requiresConfirmation,
    );
  }

  /// Creates a sample AgentStatus for testing.
  static AgentStatus createAgentStatus({
    bool isRunning = true,
    String socketPath = '/tmp/ssh-agent.sock',
    bool isLocked = false,
    int keyCount = 0,
  }) {
    return AgentStatus(
      isRunning: isRunning,
      socketPath: socketPath,
      isLocked: isLocked,
      keyCount: keyCount,
    );
  }

  /// Creates a sample TestConnectionResult for testing.
  static TestConnectionResult createTestConnectionResult({
    bool success = true,
    String message = 'Connection successful',
    String? serverVersion = 'OpenSSH_8.9',
    int? latencyMs = 42,
    HostKeyVerificationStatus hostKeyStatus =
        HostKeyVerificationStatus.verified,
    HostKeyInfo? hostKeyInfo,
  }) {
    return TestConnectionResult(
      success: success,
      message: message,
      serverVersion: serverVersion,
      latencyMs: latencyMs,
      hostKeyStatus: hostKeyStatus,
      hostKeyInfo: hostKeyInfo,
    );
  }

  /// Creates a sample RemoteEntity for testing.
  static RemoteEntity createRemoteEntity({
    String id = 'remote-1',
    String name = 'Test Server',
    String host = 'example.com',
    int port = 22,
    String user = 'admin',
    String? identityFile,
    String? sshConfigAlias,
    DateTime? createdAt,
    DateTime? lastConnectedAt,
    RemoteStatus status = RemoteStatus.disconnected,
  }) {
    return RemoteEntity(
      id: id,
      name: name,
      host: host,
      port: port,
      user: user,
      identityFile: identityFile,
      sshConfigAlias: sshConfigAlias,
      createdAt: createdAt ?? DateTime(2024, 1, 1),
      lastConnectedAt: lastConnectedAt,
      status: status,
    );
  }

  /// Creates a sample SSHConfigEntry for testing.
  static SSHConfigEntry createSSHConfigEntry({
    String id = 'entry-1',
    SSHConfigEntryType type = SSHConfigEntryType.host,
    int position = 0,
    List<String> patterns = const ['github.com'],
    SSHOptions? options,
  }) {
    return SSHConfigEntry(
      id: id,
      type: type,
      position: position,
      patterns: patterns,
      options: options ?? const SSHOptions(),
    );
  }

  /// Creates a sample ConfigHostEntry for testing.
  static ConfigHostEntry createConfigHostEntry({
    String host = 'github',
    String? hostname = 'github.com',
    String? user = 'git',
    int? port = 22,
    String? identityFile = '~/.ssh/github',
    bool? forwardAgent = false,
    Map<String, String> extraOptions = const {},
  }) {
    return ConfigHostEntry(
      host: host,
      hostname: hostname,
      user: user,
      port: port,
      identityFile: identityFile,
      forwardAgent: forwardAgent,
      extraOptions: extraOptions,
    );
  }

  /// Creates a sample GlobalDirective for testing.
  static GlobalDirective createGlobalDirective({
    String key = 'AddKeysToAgent',
    String value = 'yes',
  }) {
    return GlobalDirective(key: key, value: value);
  }

  /// Creates a sample ServerConfig for testing.
  static ServerConfig createServerConfig({
    String path = '/etc/ssh/sshd_config',
    List<ServerConfigOption>? options,
  }) {
    return ServerConfig(
      path: path,
      options: options ??
          [
            const ServerConfigOption(
              key: 'Port',
              value: '22',
              lineNumber: 1,
            ),
            const ServerConfigOption(
              key: 'PermitRootLogin',
              value: 'no',
              lineNumber: 5,
            ),
          ],
    );
  }
}
