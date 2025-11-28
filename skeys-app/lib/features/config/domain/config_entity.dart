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

/// Global SSH client config directive (outside Host/Match blocks).
class GlobalDirective extends Equatable {
  /// The directive key name.
  final String key;

  /// The directive value.
  final String value;

  /// Creates a GlobalDirective with the given key and value.
  const GlobalDirective({required this.key, required this.value});

  @override
  List<Object?> get props => [key, value];
}

/// SSH client config host entry.
class ConfigHostEntry extends Equatable {
  /// The host pattern for this entry.
  final String host;

  /// The actual hostname to connect to.
  final String? hostname;

  /// The username for the connection.
  final String? user;

  /// The port number for the connection.
  final int? port;

  /// The path to the identity file (private key).
  final String? identityFile;

  /// Whether to forward the SSH agent to the remote host.
  final bool? forwardAgent;

  /// Additional options not covered by dedicated fields.
  final Map<String, String> extraOptions;

  /// Creates a ConfigHostEntry with the given parameters.
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
  List<Object?> get props => [
    host,
    hostname,
    user,
    port,
    identityFile,
    forwardAgent,
    extraOptions,
  ];
}

/// SSH server config option from sshd_config.
class ServerConfigOption extends Equatable {
  /// The option key name.
  final String key;

  /// The option value.
  final String value;

  /// The line number in the config file where this option appears.
  final int lineNumber;

  /// Creates a ServerConfigOption with the given parameters.
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
  /// The path to the sshd_config file.
  final String path;

  /// The list of configuration options.
  final List<ServerConfigOption> options;

  /// Creates a ServerConfig with the given path and options.
  const ServerConfig({required this.path, required this.options});

  @override
  List<Object?> get props => [path, options];
}
