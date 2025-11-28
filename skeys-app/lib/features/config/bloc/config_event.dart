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

sealed class ConfigEvent extends Equatable {
  const ConfigEvent();

  @override
  List<Object?> get props => [];
}

// ============================================================
// New unified SSH config API events
// ============================================================

/// Load all SSH config entries (Host and Match blocks)
final class ConfigLoadSSHEntriesRequested extends ConfigEvent {
  const ConfigLoadSSHEntriesRequested();
}

/// Watch SSH config entries for changes (streaming)
final class ConfigWatchSSHEntriesRequested extends ConfigEvent {
  const ConfigWatchSSHEntriesRequested();
}

/// Create a new SSH config entry
final class ConfigCreateSSHEntryRequested extends ConfigEvent {
  final SSHConfigEntry entry;
  final int? insertPosition;

  const ConfigCreateSSHEntryRequested(this.entry, {this.insertPosition});

  @override
  List<Object?> get props => [entry, insertPosition];
}

/// Update an existing SSH config entry
final class ConfigUpdateSSHEntryRequested extends ConfigEvent {
  final String id;
  final SSHConfigEntry entry;

  const ConfigUpdateSSHEntryRequested({required this.id, required this.entry});

  @override
  List<Object?> get props => [id, entry];
}

/// Delete an SSH config entry
final class ConfigDeleteSSHEntryRequested extends ConfigEvent {
  final String id;

  const ConfigDeleteSSHEntryRequested(this.id);

  @override
  List<Object?> get props => [id];
}

/// Reorder SSH config entries (drag and drop)
final class ConfigReorderSSHEntriesRequested extends ConfigEvent {
  final List<String> entryIds;

  const ConfigReorderSSHEntriesRequested(this.entryIds);

  @override
  List<Object?> get props => [entryIds];
}

// ============================================================
// Global directives events (options outside Host/Match blocks)
// ============================================================

/// Load all global directives
final class ConfigLoadGlobalDirectivesRequested extends ConfigEvent {
  const ConfigLoadGlobalDirectivesRequested();
}

/// Set a global directive value
final class ConfigSetGlobalDirectiveRequested extends ConfigEvent {
  final String key;
  final String value;

  const ConfigSetGlobalDirectiveRequested({
    required this.key,
    required this.value,
  });

  @override
  List<Object?> get props => [key, value];
}

/// Delete a global directive
final class ConfigDeleteGlobalDirectiveRequested extends ConfigEvent {
  final String key;

  const ConfigDeleteGlobalDirectiveRequested(this.key);

  @override
  List<Object?> get props => [key];
}

// ============================================================
// Legacy client host events (backward compatibility)
// ============================================================

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

// ============================================================
// Server config events
// ============================================================

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

/// Restart the SSH server service to apply config changes
final class ConfigRestartSSHServerRequested extends ConfigEvent {
  const ConfigRestartSSHServerRequested();
}
