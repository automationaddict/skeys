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

part of 'server_bloc.dart';

/// Base class for all server events.
sealed class ServerEvent extends Equatable {
  const ServerEvent();

  @override
  List<Object?> get props => [];
}

/// Subscribe to SSH status updates via streaming.
final class ServerWatchRequested extends ServerEvent {
  const ServerWatchRequested();
}

/// Start the SSH server service.
final class ServerStartRequested extends ServerEvent {
  const ServerStartRequested();
}

/// Stop the SSH server service.
final class ServerStopRequested extends ServerEvent {
  const ServerStopRequested();
}

/// Restart the SSH server service.
final class ServerRestartRequested extends ServerEvent {
  const ServerRestartRequested();
}

/// Enable SSH service auto-start on boot.
final class ServerEnableRequested extends ServerEvent {
  const ServerEnableRequested();
}

/// Disable SSH service auto-start on boot.
final class ServerDisableRequested extends ServerEvent {
  const ServerDisableRequested();
}

/// Clear the action result (after showing toast).
final class ServerActionResultCleared extends ServerEvent {
  const ServerActionResultCleared();
}
