import 'package:equatable/equatable.dart';

/// SSH client config host entry.
class ConfigHostEntry extends Equatable {
  final String host;
  final String? hostname;
  final String? user;
  final int? port;
  final String? identityFile;
  final bool? forwardAgent;
  final Map<String, String> extraOptions;

  const ConfigHostEntry({
    required this.host,
    this.hostname,
    this.user,
    this.port,
    this.identityFile,
    this.forwardAgent,
    this.extraOptions = const {},
  });

  @override
  List<Object?> get props => [host, hostname, user, port, identityFile, forwardAgent, extraOptions];
}

/// SSH server config option.
class ServerConfigOption extends Equatable {
  final String key;
  final String value;
  final int lineNumber;

  const ServerConfigOption({
    required this.key,
    required this.value,
    required this.lineNumber,
  });

  @override
  List<Object?> get props => [key, value, lineNumber];
}

/// SSH server configuration.
class ServerConfig extends Equatable {
  final String path;
  final List<ServerConfigOption> options;

  const ServerConfig({
    required this.path,
    required this.options,
  });

  @override
  List<Object?> get props => [path, options];
}
