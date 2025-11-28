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

part of 'config_bloc.dart';

enum ConfigStatus { initial, loading, success, failure }

final class ConfigState extends Equatable {
  final ConfigStatus status;

  // New unified SSH config entries
  final List<SSHConfigEntry> sshEntries;

  // Global directives (options outside Host/Match blocks)
  final List<GlobalDirective> globalDirectives;

  // Legacy client hosts (backward compatibility)
  final List<ConfigHostEntry> clientHosts;

  // Server config
  final ServerConfig? serverConfig;

  // Server config has been modified and needs SSH service restart
  final bool serverConfigPendingRestart;

  // Error handling
  final String? errorMessage;

  const ConfigState({
    this.status = ConfigStatus.initial,
    this.sshEntries = const [],
    this.globalDirectives = const [],
    this.clientHosts = const [],
    this.serverConfig,
    this.serverConfigPendingRestart = false,
    this.errorMessage,
  });

  ConfigState copyWith({
    ConfigStatus? status,
    List<SSHConfigEntry>? sshEntries,
    List<GlobalDirective>? globalDirectives,
    List<ConfigHostEntry>? clientHosts,
    ServerConfig? serverConfig,
    bool? serverConfigPendingRestart,
    String? errorMessage,
  }) {
    return ConfigState(
      status: status ?? this.status,
      sshEntries: sshEntries ?? this.sshEntries,
      globalDirectives: globalDirectives ?? this.globalDirectives,
      clientHosts: clientHosts ?? this.clientHosts,
      serverConfig: serverConfig ?? this.serverConfig,
      serverConfigPendingRestart:
          serverConfigPendingRestart ?? this.serverConfigPendingRestart,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    sshEntries,
    globalDirectives,
    clientHosts,
    serverConfig,
    serverConfigPendingRestart,
    errorMessage,
  ];
}
