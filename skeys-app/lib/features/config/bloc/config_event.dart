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

/// Base class for all SSH config-related events.
sealed class ConfigEvent extends Equatable {
  /// Creates a ConfigEvent.
  const ConfigEvent();

  @override
  List<Object?> get props => [];
}

// ============================================================
// New unified SSH config API events
// ============================================================

/// Event to load all SSH config entries (Host and Match blocks).
final class ConfigLoadSSHEntriesRequested extends ConfigEvent {
  /// Creates a ConfigLoadSSHEntriesRequested event.
  const ConfigLoadSSHEntriesRequested();
}

/// Event to watch SSH config entries for changes via streaming.
final class ConfigWatchSSHEntriesRequested extends ConfigEvent {
  /// Creates a ConfigWatchSSHEntriesRequested event.
  const ConfigWatchSSHEntriesRequested();
}

/// Event to create a new SSH config entry.
final class ConfigCreateSSHEntryRequested extends ConfigEvent {
  /// The entry to create.
  final SSHConfigEntry entry;

  /// Optional position to insert the entry at.
  final int? insertPosition;

  /// Creates a ConfigCreateSSHEntryRequested event.
  const ConfigCreateSSHEntryRequested(this.entry, {this.insertPosition});

  @override
  List<Object?> get props => [entry, insertPosition];
}

/// Event to update an existing SSH config entry.
final class ConfigUpdateSSHEntryRequested extends ConfigEvent {
  /// The ID of the entry to update.
  final String id;

  /// The updated entry data.
  final SSHConfigEntry entry;

  /// Creates a ConfigUpdateSSHEntryRequested event.
  const ConfigUpdateSSHEntryRequested({required this.id, required this.entry});

  @override
  List<Object?> get props => [id, entry];
}

/// Event to delete an SSH config entry.
final class ConfigDeleteSSHEntryRequested extends ConfigEvent {
  /// The ID of the entry to delete.
  final String id;

  /// Creates a ConfigDeleteSSHEntryRequested event.
  const ConfigDeleteSSHEntryRequested(this.id);

  @override
  List<Object?> get props => [id];
}

/// Event to reorder SSH config entries (for drag and drop).
final class ConfigReorderSSHEntriesRequested extends ConfigEvent {
  /// The ordered list of entry IDs in the new order.
  final List<String> entryIds;

  /// Creates a ConfigReorderSSHEntriesRequested event.
  const ConfigReorderSSHEntriesRequested(this.entryIds);

  @override
  List<Object?> get props => [entryIds];
}

// ============================================================
// Global directives events (options outside Host/Match blocks)
// ============================================================

/// Event to load all global directives.
final class ConfigLoadGlobalDirectivesRequested extends ConfigEvent {
  /// Creates a ConfigLoadGlobalDirectivesRequested event.
  const ConfigLoadGlobalDirectivesRequested();
}

/// Event to set a global directive value.
final class ConfigSetGlobalDirectiveRequested extends ConfigEvent {
  /// The directive key to set.
  final String key;

  /// The value to set for the directive.
  final String value;

  /// Creates a ConfigSetGlobalDirectiveRequested event.
  const ConfigSetGlobalDirectiveRequested({
    required this.key,
    required this.value,
  });

  @override
  List<Object?> get props => [key, value];
}

/// Event to delete a global directive.
final class ConfigDeleteGlobalDirectiveRequested extends ConfigEvent {
  /// The directive key to delete.
  final String key;

  /// Creates a ConfigDeleteGlobalDirectiveRequested event.
  const ConfigDeleteGlobalDirectiveRequested(this.key);

  @override
  List<Object?> get props => [key];
}

// ============================================================
// Legacy client host events (backward compatibility)
// ============================================================

/// Event to load client host entries (legacy).
final class ConfigLoadClientHostsRequested extends ConfigEvent {
  /// Creates a ConfigLoadClientHostsRequested event.
  const ConfigLoadClientHostsRequested();
}

/// Event to add a client host entry (legacy).
final class ConfigAddClientHostRequested extends ConfigEvent {
  /// The host entry to add.
  final ConfigHostEntry entry;

  /// Creates a ConfigAddClientHostRequested event.
  const ConfigAddClientHostRequested(this.entry);

  @override
  List<Object?> get props => [entry];
}

/// Event to update a client host entry (legacy).
final class ConfigUpdateClientHostRequested extends ConfigEvent {
  /// The updated host entry.
  final ConfigHostEntry entry;

  /// Creates a ConfigUpdateClientHostRequested event.
  const ConfigUpdateClientHostRequested(this.entry);

  @override
  List<Object?> get props => [entry];
}

/// Event to delete a client host entry (legacy).
final class ConfigDeleteClientHostRequested extends ConfigEvent {
  /// The host pattern to delete.
  final String host;

  /// Creates a ConfigDeleteClientHostRequested event.
  const ConfigDeleteClientHostRequested(this.host);

  @override
  List<Object?> get props => [host];
}

// ============================================================
// Server config events
// ============================================================

/// Event to load the SSH server configuration.
final class ConfigLoadServerConfigRequested extends ConfigEvent {
  /// Creates a ConfigLoadServerConfigRequested event.
  const ConfigLoadServerConfigRequested();
}

/// Event to update an SSH server configuration option.
final class ConfigUpdateServerOptionRequested extends ConfigEvent {
  /// The option key to update.
  final String key;

  /// The value to set for the option.
  final String value;

  /// Creates a ConfigUpdateServerOptionRequested event.
  const ConfigUpdateServerOptionRequested({
    required this.key,
    required this.value,
  });

  @override
  List<Object?> get props => [key, value];
}

/// Event to restart the SSH server service to apply config changes.
final class ConfigRestartSSHServerRequested extends ConfigEvent {
  /// Creates a ConfigRestartSSHServerRequested event.
  const ConfigRestartSSHServerRequested();
}
