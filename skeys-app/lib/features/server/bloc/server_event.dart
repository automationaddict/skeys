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
