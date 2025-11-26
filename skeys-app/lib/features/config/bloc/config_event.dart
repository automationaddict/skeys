part of 'config_bloc.dart';

sealed class ConfigEvent extends Equatable {
  const ConfigEvent();

  @override
  List<Object?> get props => [];
}

final class ConfigLoadClientHostsRequested extends ConfigEvent {
  const ConfigLoadClientHostsRequested();
}

final class ConfigAddClientHostRequested extends ConfigEvent {
  final ConfigHostEntry entry;

  const ConfigAddClientHostRequested(this.entry);

  @override
  List<Object?> get props => [entry];
}

final class ConfigUpdateClientHostRequested extends ConfigEvent {
  final ConfigHostEntry entry;

  const ConfigUpdateClientHostRequested(this.entry);

  @override
  List<Object?> get props => [entry];
}

final class ConfigDeleteClientHostRequested extends ConfigEvent {
  final String host;

  const ConfigDeleteClientHostRequested(this.host);

  @override
  List<Object?> get props => [host];
}

final class ConfigLoadServerConfigRequested extends ConfigEvent {
  const ConfigLoadServerConfigRequested();
}

final class ConfigUpdateServerOptionRequested extends ConfigEvent {
  final String key;
  final String value;

  const ConfigUpdateServerOptionRequested({
    required this.key,
    required this.value,
  });

  @override
  List<Object?> get props => [key, value];
}
