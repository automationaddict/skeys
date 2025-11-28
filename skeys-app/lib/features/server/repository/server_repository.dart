import '../../../core/generated/skeys/v1/common.pb.dart' as common;
import '../../../core/generated/skeys/v1/config.pb.dart' as config;
import '../../../core/generated/skeys/v1/system.pb.dart' as pb;
import '../../../core/grpc/grpc_client.dart';
import '../domain/server_entity.dart';

/// SSH Component type for install instructions.
enum SSHComponent { client, server }

/// Install instructions response.
class InstallInstructions {
  final String distribution;
  final SSHComponent component;
  final String packageName;
  final String installCommand;
  final String documentationUrl;
  final List<String> steps;

  const InstallInstructions({
    required this.distribution,
    required this.component,
    required this.packageName,
    required this.installCommand,
    required this.documentationUrl,
    required this.steps,
  });
}

/// Service control response.
class ServiceControlResult {
  final bool success;
  final String message;
  final ServiceStatus? status;

  const ServiceControlResult({
    required this.success,
    required this.message,
    this.status,
  });
}

/// Repository for SSH system/server operations.
abstract class ServerRepository {
  /// Get comprehensive SSH system status.
  Future<SSHSystemStatus> getSSHStatus();

  /// Watch for SSH status changes via streaming.
  Stream<SSHSystemStatus> watchSSHStatus();

  /// Start the SSH server service.
  Future<ServiceControlResult> startService();

  /// Stop the SSH server service.
  Future<ServiceControlResult> stopService();

  /// Restart the SSH server service.
  Future<ServiceControlResult> restartService();

  /// Enable SSH service auto-start on boot.
  Future<ServiceControlResult> enableService();

  /// Disable SSH service auto-start on boot.
  Future<ServiceControlResult> disableService();

  /// Get install instructions for a component.
  Future<InstallInstructions> getInstallInstructions(SSHComponent component);
}

/// Implementation of ServerRepository using gRPC.
class ServerRepositoryImpl implements ServerRepository {
  final GrpcClient _client;

  ServerRepositoryImpl(this._client);

  @override
  Future<SSHSystemStatus> getSSHStatus() async {
    final response = await _client.system.getSSHStatus(pb.GetSSHStatusRequest());
    return _mapToEntity(response);
  }

  @override
  Stream<SSHSystemStatus> watchSSHStatus() {
    final request = pb.WatchSSHStatusRequest()
      ..target = (common.Target()..type = common.TargetType.TARGET_TYPE_LOCAL);

    return _client.system.watchSSHStatus(request).map(_mapToEntity);
  }

  @override
  Future<ServiceControlResult> startService() async {
    final response = await _client.system.startSSHService(pb.StartSSHServiceRequest());
    return _mapServiceControlResult(response);
  }

  @override
  Future<ServiceControlResult> stopService() async {
    final response = await _client.system.stopSSHService(pb.StopSSHServiceRequest());
    return _mapServiceControlResult(response);
  }

  @override
  Future<ServiceControlResult> restartService() async {
    final response = await _client.system.restartSSHServiceWithStatus(
      pb.RestartSSHServiceWithStatusRequest(),
    );
    return _mapServiceControlResult(response);
  }

  @override
  Future<ServiceControlResult> enableService() async {
    final response = await _client.system.enableSSHService(pb.EnableSSHServiceRequest());
    return _mapServiceControlResult(response);
  }

  @override
  Future<ServiceControlResult> disableService() async {
    final response = await _client.system.disableSSHService(pb.DisableSSHServiceRequest());
    return _mapServiceControlResult(response);
  }

  @override
  Future<InstallInstructions> getInstallInstructions(SSHComponent component) async {
    final pbComponent = component == SSHComponent.server
        ? pb.SSHComponent.SSH_COMPONENT_SERVER
        : pb.SSHComponent.SSH_COMPONENT_CLIENT;

    final response = await _client.system.getInstallInstructions(
      pb.GetInstallInstructionsRequest()..component = pbComponent,
    );

    return InstallInstructions(
      distribution: response.distribution,
      component: component,
      packageName: response.packageName,
      installCommand: response.installCommand,
      documentationUrl: response.documentationUrl,
      steps: response.steps.toList(),
    );
  }

  SSHSystemStatus _mapToEntity(pb.GetSSHStatusResponse response) {
    return SSHSystemStatus(
      distribution: response.distribution,
      distributionVersion: response.distributionVersion,
      client: _mapClientStatus(response.client),
      server: _mapServerStatus(response.server),
    );
  }

  SSHClientStatus _mapClientStatus(pb.SSHClientStatus client) {
    return SSHClientStatus(
      installed: client.installed,
      version: client.version,
      binaryPath: client.binaryPath,
      systemConfig: _mapConfigPathInfo(client.systemConfig),
      userConfig: _mapConfigPathInfo(client.userConfig),
    );
  }

  SSHServerStatus _mapServerStatus(pb.SSHServerStatus server) {
    return SSHServerStatus(
      installed: server.installed,
      version: server.version,
      binaryPath: server.binaryPath,
      service: _mapServiceStatus(server.service),
      config: _mapConfigPathInfo(server.config),
    );
  }

  ConfigPathInfo _mapConfigPathInfo(config.ConfigPathInfo info) {
    return ConfigPathInfo(
      path: info.path,
      exists: info.exists,
      readable: info.readable,
      writable: info.writable,
      includeDir: info.includeDir,
    );
  }

  ServiceStatus _mapServiceStatus(pb.ServiceStatus service) {
    return ServiceStatus(
      state: _mapServiceState(service.state),
      enabled: service.enabled,
      activeState: service.activeState,
      subState: service.subState,
      loadState: service.loadState,
      pid: service.pid.toInt(),
      startedAt: service.startedAt,
      serviceName: service.serviceName,
    );
  }

  ServiceState _mapServiceState(pb.ServiceState state) {
    switch (state) {
      case pb.ServiceState.SERVICE_STATE_RUNNING:
        return ServiceState.running;
      case pb.ServiceState.SERVICE_STATE_STOPPED:
        return ServiceState.stopped;
      case pb.ServiceState.SERVICE_STATE_FAILED:
        return ServiceState.failed;
      case pb.ServiceState.SERVICE_STATE_NOT_FOUND:
        return ServiceState.notFound;
      case pb.ServiceState.SERVICE_STATE_UNKNOWN:
        return ServiceState.unknown;
      default:
        return ServiceState.unspecified;
    }
  }

  ServiceControlResult _mapServiceControlResult(pb.SSHServiceControlResponse response) {
    return ServiceControlResult(
      success: response.success,
      message: response.message,
      status: response.hasStatus() ? _mapServiceStatus(response.status) : null,
    );
  }
}
