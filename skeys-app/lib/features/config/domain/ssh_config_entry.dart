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

/// Type of SSH config entry
enum SSHConfigEntryType { host, match }

/// Represents a Host or Match block in SSH config
class SSHConfigEntry extends Equatable {
  final String id;
  final SSHConfigEntryType type;
  final int position;
  final List<String> patterns;
  final SSHOptions options;

  const SSHConfigEntry({
    required this.id,
    required this.type,
    required this.position,
    required this.patterns,
    required this.options,
  });

  /// Display name for UI
  String get displayName {
    if (patterns.isEmpty) {
      return type == SSHConfigEntryType.host ? 'Host' : 'Match';
    }
    return patterns.join(', ');
  }

  /// Whether this is a wildcard/pattern entry
  bool get isWildcard =>
      patterns.any((p) => p.contains('*') || p.contains('?'));

  /// Whether this is a catch-all entry (Host *)
  bool get isCatchAll =>
      type == SSHConfigEntryType.host &&
      patterns.length == 1 &&
      patterns.first == '*';

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

/// All SSH configuration options
class SSHOptions extends Equatable {
  // Essential (always visible in basic section)
  final String? hostname;
  final String? user;
  final int? port;
  final List<String> identityFiles;
  final bool? forwardAgent;

  // Connection (progressive disclosure)
  final String? proxyJump;
  final String? proxyCommand;
  final int? serverAliveInterval;
  final int? serverAliveCountMax;

  // Security (progressive disclosure)
  final bool? identitiesOnly;
  final bool? compression;
  final String? strictHostKeyChecking;

  // Custom options
  final Map<String, String> extraOptions;

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

  /// Check if options are mostly empty (useful for UI hints)
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

  /// Count of configured advanced options (for "X configured" badge)
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

  /// Get the primary identity file (first one)
  String? get primaryIdentityFile =>
      identityFiles.isNotEmpty ? identityFiles.first : null;

  /// Get additional identity files (all except first)
  List<String> get additionalIdentityFiles =>
      identityFiles.length > 1 ? identityFiles.sublist(1) : [];

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
