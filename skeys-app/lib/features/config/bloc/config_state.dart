part of 'config_bloc.dart';

enum ConfigStatus {
  initial,
  loading,
  success,
  failure,
}

final class ConfigState extends Equatable {
  final ConfigStatus status;
  final List<ConfigHostEntry> clientHosts;
  final ServerConfig? serverConfig;
  final String? errorMessage;

  const ConfigState({
    this.status = ConfigStatus.initial,
    this.clientHosts = const [],
    this.serverConfig,
    this.errorMessage,
  });

  ConfigState copyWith({
    ConfigStatus? status,
    List<ConfigHostEntry>? clientHosts,
    ServerConfig? serverConfig,
    String? errorMessage,
  }) {
    return ConfigState(
      status: status ?? this.status,
      clientHosts: clientHosts ?? this.clientHosts,
      serverConfig: serverConfig ?? this.serverConfig,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, clientHosts, serverConfig, errorMessage];
}
