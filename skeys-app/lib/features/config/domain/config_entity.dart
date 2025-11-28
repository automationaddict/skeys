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
  final String key;
  final String value;

  const GlobalDirective({required this.key, required this.value});

  @override
  List<Object?> get props => [key, value];
}

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

  const ServerConfig({required this.path, required this.options});

  @override
  List<Object?> get props => [path, options];
}
