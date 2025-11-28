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

part of 'hosts_bloc.dart';

/// Status of the HostsBloc operations.
enum HostsStatus {
  /// Initial state before any operation.
  initial,

  /// A load operation is in progress.
  loading,

  /// A host scan is in progress.
  scanning,

  /// The operation completed successfully.
  success,

  /// The operation failed with an error.
  failure,
}

/// State of the hosts BLoC.
final class HostsState extends Equatable {
  /// The current status of BLoC operations.
  final HostsStatus status;

  /// List of known host entries.
  final List<KnownHostEntry> knownHosts;

  /// List of authorized key entries.
  final List<AuthorizedKeyEntry> authorizedKeys;

  /// Scanned host keys (temporary state during scan operation).
  final List<ScannedHostKey> scannedKeys;

  /// Error message if the last operation failed.
  final String? errorMessage;

  /// Creates a HostsState.
  const HostsState({
    this.status = HostsStatus.initial,
    this.knownHosts = const [],
    this.authorizedKeys = const [],
    this.scannedKeys = const [],
    this.errorMessage,
  });

  /// Creates a copy of this state with the given fields replaced.
  HostsState copyWith({
    HostsStatus? status,
    List<KnownHostEntry>? knownHosts,
    List<AuthorizedKeyEntry>? authorizedKeys,
    List<ScannedHostKey>? scannedKeys,
    String? errorMessage,
  }) {
    return HostsState(
      status: status ?? this.status,
      knownHosts: knownHosts ?? this.knownHosts,
      authorizedKeys: authorizedKeys ?? this.authorizedKeys,
      scannedKeys: scannedKeys ?? this.scannedKeys,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    knownHosts,
    authorizedKeys,
    scannedKeys,
    errorMessage,
  ];
}
