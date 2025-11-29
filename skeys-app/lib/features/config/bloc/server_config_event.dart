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

part of 'server_config_bloc.dart';

/// Base class for all server config-related events.
sealed class ServerConfigEvent extends Equatable {
  /// Creates a ServerConfigEvent.
  const ServerConfigEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load the SSH server configuration.
final class ServerConfigLoadRequested extends ServerConfigEvent {
  /// Creates a ServerConfigLoadRequested event.
  const ServerConfigLoadRequested();
}

/// Event to update an SSH server configuration option.
final class ServerConfigUpdateOptionRequested extends ServerConfigEvent {
  /// The option key to update.
  final String key;

  /// The value to set for the option.
  final String value;

  /// Creates a ServerConfigUpdateOptionRequested event.
  const ServerConfigUpdateOptionRequested({
    required this.key,
    required this.value,
  });

  @override
  List<Object?> get props => [key, value];
}

/// Event to restart the SSH server service to apply config changes.
final class ServerConfigRestartRequested extends ServerConfigEvent {
  /// Creates a ServerConfigRestartRequested event.
  const ServerConfigRestartRequested();
}

/// Event to clear the pending restart flag.
final class ServerConfigClearPendingRestart extends ServerConfigEvent {
  /// Creates a ServerConfigClearPendingRestart event.
  const ServerConfigClearPendingRestart();
}
