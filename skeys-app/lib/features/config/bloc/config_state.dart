part of 'config_bloc.dart';

enum ConfigStatus {
  initial,
  loading,
  success,
  failure,
}

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
      serverConfigPendingRestart: serverConfigPendingRestart ?? this.serverConfigPendingRestart,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, sshEntries, globalDirectives, clientHosts, serverConfig, serverConfigPendingRestart, errorMessage];
}
