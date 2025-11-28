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

import 'package:equatable/equatable.dart';

/// Type of SSH config entry.
enum SSHConfigEntryType {
  /// A Host block that matches by hostname pattern.
  host,

  /// A Match block with conditional matching.
  match,
}

/// Represents a Host or Match block in SSH config.
class SSHConfigEntry extends Equatable {
  /// Unique identifier for this entry.
  final String id;

  /// The type of entry (Host or Match).
  final SSHConfigEntryType type;

  /// Position in the config file (affects matching order).
  final int position;

  /// List of patterns this entry matches.
  final List<String> patterns;

  /// The configuration options for this entry.
  final SSHOptions options;

  /// Creates an SSHConfigEntry with the given parameters.
  const SSHConfigEntry({
    required this.id,
    required this.type,
    required this.position,
    required this.patterns,
    required this.options,
  });

  /// Display name for UI (patterns joined with comma).
  String get displayName {
    if (patterns.isEmpty) {
      return type == SSHConfigEntryType.host ? 'Host' : 'Match';
    }
    return patterns.join(', ');
  }

  /// Whether this is a wildcard/pattern entry containing * or ?.
  bool get isWildcard =>
      patterns.any((p) => p.contains('*') || p.contains('?'));

  /// Whether this is a catch-all entry (Host *).
  bool get isCatchAll =>
      type == SSHConfigEntryType.host &&
      patterns.length == 1 &&
      patterns.first == '*';

  /// Creates a copy of this entry with the given fields replaced.
  SSHConfigEntry copyWith({
    String? id,
    SSHConfigEntryType? type,
    int? position,
    List<String>? patterns,
    SSHOptions? options,
  }) {
    return SSHConfigEntry(
      id: id ?? this.id,
      type: type ?? this.type,
      position: position ?? this.position,
      patterns: patterns ?? this.patterns,
      options: options ?? this.options,
    );
  }

  @override
  List<Object?> get props => [id, type, position, patterns, options];
}

/// All SSH configuration options for a Host or Match block.
class SSHOptions extends Equatable {
  /// The actual hostname to connect to.
  final String? hostname;

  /// The username for the connection.
  final String? user;

  /// The port number for the connection.
  final int? port;

  /// List of identity files (private keys) to try.
  final List<String> identityFiles;

  /// Whether to forward the SSH agent to the remote host.
  final bool? forwardAgent;

  /// Comma-separated list of hosts to jump through (ProxyJump).
  final String? proxyJump;

  /// Command to use to connect to the server (ProxyCommand).
  final String? proxyCommand;

  /// Seconds between keepalive messages sent to the server.
  final int? serverAliveInterval;

  /// Max keepalive messages sent without receiving a reply.
  final int? serverAliveCountMax;

  /// Only use explicitly configured identity files.
  final bool? identitiesOnly;

  /// Enable compression.
  final bool? compression;

  /// Host key checking policy (yes/no/ask/accept-new).
  final String? strictHostKeyChecking;

  /// Additional options not covered by dedicated fields.
  final Map<String, String> extraOptions;

  /// Creates an SSHOptions with the given parameters.
  const SSHOptions({
    this.hostname,
    this.user,
    this.port,
    this.identityFiles = const [],
    this.forwardAgent,
    this.proxyJump,
    this.proxyCommand,
    this.serverAliveInterval,
    this.serverAliveCountMax,
    this.identitiesOnly,
    this.compression,
    this.strictHostKeyChecking,
    this.extraOptions = const {},
  });

  /// Returns true if no options are configured.
  bool get isEmpty =>
      hostname == null &&
      user == null &&
      port == null &&
      identityFiles.isEmpty &&
      forwardAgent == null &&
      proxyJump == null &&
      proxyCommand == null &&
      serverAliveInterval == null &&
      serverAliveCountMax == null &&
      identitiesOnly == null &&
      compression == null &&
      strictHostKeyChecking == null &&
      extraOptions.isEmpty;

  /// Count of configured advanced options (for UI badges).
  int get advancedOptionsCount {
    var count = 0;
    if (proxyJump != null && proxyJump!.isNotEmpty) count++;
    if (proxyCommand != null && proxyCommand!.isNotEmpty) count++;
    if (serverAliveInterval != null && serverAliveInterval! > 0) count++;
    if (serverAliveCountMax != null && serverAliveCountMax! > 0) count++;
    if (identitiesOnly == true) count++;
    if (compression == true) count++;
    if (strictHostKeyChecking != null && strictHostKeyChecking!.isNotEmpty) {
      count++;
    }
    count += extraOptions.length;
    if (identityFiles.length > 1) count += identityFiles.length - 1;
    return count;
  }

  /// The primary identity file (first one), or null if none.
  String? get primaryIdentityFile =>
      identityFiles.isNotEmpty ? identityFiles.first : null;

  /// Additional identity files (all except the first).
  List<String> get additionalIdentityFiles =>
      identityFiles.length > 1 ? identityFiles.sublist(1) : [];

  /// Creates a copy of these options with the given fields replaced.
  SSHOptions copyWith({
    String? hostname,
    String? user,
    int? port,
    List<String>? identityFiles,
    bool? forwardAgent,
    String? proxyJump,
    String? proxyCommand,
    int? serverAliveInterval,
    int? serverAliveCountMax,
    bool? identitiesOnly,
    bool? compression,
    String? strictHostKeyChecking,
    Map<String, String>? extraOptions,
  }) {
    return SSHOptions(
      hostname: hostname ?? this.hostname,
      user: user ?? this.user,
      port: port ?? this.port,
      identityFiles: identityFiles ?? this.identityFiles,
      forwardAgent: forwardAgent ?? this.forwardAgent,
      proxyJump: proxyJump ?? this.proxyJump,
      proxyCommand: proxyCommand ?? this.proxyCommand,
      serverAliveInterval: serverAliveInterval ?? this.serverAliveInterval,
      serverAliveCountMax: serverAliveCountMax ?? this.serverAliveCountMax,
      identitiesOnly: identitiesOnly ?? this.identitiesOnly,
      compression: compression ?? this.compression,
      strictHostKeyChecking:
          strictHostKeyChecking ?? this.strictHostKeyChecking,
      extraOptions: extraOptions ?? this.extraOptions,
    );
  }

  @override
  List<Object?> get props => [
    hostname,
    user,
    port,
    identityFiles,
    forwardAgent,
    proxyJump,
    proxyCommand,
    serverAliveInterval,
    serverAliveCountMax,
    identitiesOnly,
    compression,
    strictHostKeyChecking,
    extraOptions,
  ];
}
