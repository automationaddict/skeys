//
//  Generated code. Do not modify.
//  source: skeys/v1/config.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import '../../google/protobuf/empty.pb.dart' as $1;
import 'config.pb.dart' as $2;

export 'config.pb.dart';

@$pb.GrpcServiceName('skeys.v1.ConfigService')
class ConfigServiceClient extends $grpc.Client {
  static final _$listHostConfigs = $grpc.ClientMethod<$2.ListHostConfigsRequest, $2.ListHostConfigsResponse>(
      '/skeys.v1.ConfigService/ListHostConfigs',
      ($2.ListHostConfigsRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $2.ListHostConfigsResponse.fromBuffer(value));
  static final _$getHostConfig = $grpc.ClientMethod<$2.GetHostConfigRequest, $2.HostConfig>(
      '/skeys.v1.ConfigService/GetHostConfig',
      ($2.GetHostConfigRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $2.HostConfig.fromBuffer(value));
  static final _$createHostConfig = $grpc.ClientMethod<$2.CreateHostConfigRequest, $2.HostConfig>(
      '/skeys.v1.ConfigService/CreateHostConfig',
      ($2.CreateHostConfigRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $2.HostConfig.fromBuffer(value));
  static final _$updateHostConfig = $grpc.ClientMethod<$2.UpdateHostConfigRequest, $2.HostConfig>(
      '/skeys.v1.ConfigService/UpdateHostConfig',
      ($2.UpdateHostConfigRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $2.HostConfig.fromBuffer(value));
  static final _$deleteHostConfig = $grpc.ClientMethod<$2.DeleteHostConfigRequest, $1.Empty>(
      '/skeys.v1.ConfigService/DeleteHostConfig',
      ($2.DeleteHostConfigRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.Empty.fromBuffer(value));
  static final _$testConnection = $grpc.ClientMethod<$2.TestConnectionRequest, $2.TestConnectionResponse>(
      '/skeys.v1.ConfigService/TestConnection',
      ($2.TestConnectionRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $2.TestConnectionResponse.fromBuffer(value));
  static final _$getSshConfigStatus = $grpc.ClientMethod<$2.GetSshConfigStatusRequest, $2.GetSshConfigStatusResponse>(
      '/skeys.v1.ConfigService/GetSshConfigStatus',
      ($2.GetSshConfigStatusRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $2.GetSshConfigStatusResponse.fromBuffer(value));
  static final _$enableSshConfig = $grpc.ClientMethod<$2.EnableSshConfigRequest, $2.EnableSshConfigResponse>(
      '/skeys.v1.ConfigService/EnableSshConfig',
      ($2.EnableSshConfigRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $2.EnableSshConfigResponse.fromBuffer(value));
  static final _$disableSshConfig = $grpc.ClientMethod<$2.DisableSshConfigRequest, $2.DisableSshConfigResponse>(
      '/skeys.v1.ConfigService/DisableSshConfig',
      ($2.DisableSshConfigRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $2.DisableSshConfigResponse.fromBuffer(value));
  static final _$getServerConfig = $grpc.ClientMethod<$2.GetServerConfigRequest, $2.ServerConfig>(
      '/skeys.v1.ConfigService/GetServerConfig',
      ($2.GetServerConfigRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $2.ServerConfig.fromBuffer(value));
  static final _$updateServerConfig = $grpc.ClientMethod<$2.UpdateServerConfigRequest, $2.ServerConfig>(
      '/skeys.v1.ConfigService/UpdateServerConfig',
      ($2.UpdateServerConfigRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $2.ServerConfig.fromBuffer(value));
  static final _$validateServerConfig = $grpc.ClientMethod<$2.ValidateServerConfigRequest, $2.ValidateServerConfigResponse>(
      '/skeys.v1.ConfigService/ValidateServerConfig',
      ($2.ValidateServerConfigRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $2.ValidateServerConfigResponse.fromBuffer(value));
  static final _$restartSSHService = $grpc.ClientMethod<$2.RestartSSHServiceRequest, $2.RestartSSHServiceResponse>(
      '/skeys.v1.ConfigService/RestartSSHService',
      ($2.RestartSSHServiceRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $2.RestartSSHServiceResponse.fromBuffer(value));

  ConfigServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$2.ListHostConfigsResponse> listHostConfigs($2.ListHostConfigsRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$listHostConfigs, request, options: options);
  }

  $grpc.ResponseFuture<$2.HostConfig> getHostConfig($2.GetHostConfigRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getHostConfig, request, options: options);
  }

  $grpc.ResponseFuture<$2.HostConfig> createHostConfig($2.CreateHostConfigRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$createHostConfig, request, options: options);
  }

  $grpc.ResponseFuture<$2.HostConfig> updateHostConfig($2.UpdateHostConfigRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$updateHostConfig, request, options: options);
  }

  $grpc.ResponseFuture<$1.Empty> deleteHostConfig($2.DeleteHostConfigRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$deleteHostConfig, request, options: options);
  }

  $grpc.ResponseFuture<$2.TestConnectionResponse> testConnection($2.TestConnectionRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$testConnection, request, options: options);
  }

  $grpc.ResponseFuture<$2.GetSshConfigStatusResponse> getSshConfigStatus($2.GetSshConfigStatusRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getSshConfigStatus, request, options: options);
  }

  $grpc.ResponseFuture<$2.EnableSshConfigResponse> enableSshConfig($2.EnableSshConfigRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$enableSshConfig, request, options: options);
  }

  $grpc.ResponseFuture<$2.DisableSshConfigResponse> disableSshConfig($2.DisableSshConfigRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$disableSshConfig, request, options: options);
  }

  $grpc.ResponseFuture<$2.ServerConfig> getServerConfig($2.GetServerConfigRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getServerConfig, request, options: options);
  }

  $grpc.ResponseFuture<$2.ServerConfig> updateServerConfig($2.UpdateServerConfigRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$updateServerConfig, request, options: options);
  }

  $grpc.ResponseFuture<$2.ValidateServerConfigResponse> validateServerConfig($2.ValidateServerConfigRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$validateServerConfig, request, options: options);
  }

  $grpc.ResponseFuture<$2.RestartSSHServiceResponse> restartSSHService($2.RestartSSHServiceRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$restartSSHService, request, options: options);
  }
}

@$pb.GrpcServiceName('skeys.v1.ConfigService')
abstract class ConfigServiceBase extends $grpc.Service {
  $core.String get $name => 'skeys.v1.ConfigService';

  ConfigServiceBase() {
    $addMethod($grpc.ServiceMethod<$2.ListHostConfigsRequest, $2.ListHostConfigsResponse>(
        'ListHostConfigs',
        listHostConfigs_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $2.ListHostConfigsRequest.fromBuffer(value),
        ($2.ListHostConfigsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$2.GetHostConfigRequest, $2.HostConfig>(
        'GetHostConfig',
        getHostConfig_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $2.GetHostConfigRequest.fromBuffer(value),
        ($2.HostConfig value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$2.CreateHostConfigRequest, $2.HostConfig>(
        'CreateHostConfig',
        createHostConfig_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $2.CreateHostConfigRequest.fromBuffer(value),
        ($2.HostConfig value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$2.UpdateHostConfigRequest, $2.HostConfig>(
        'UpdateHostConfig',
        updateHostConfig_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $2.UpdateHostConfigRequest.fromBuffer(value),
        ($2.HostConfig value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$2.DeleteHostConfigRequest, $1.Empty>(
        'DeleteHostConfig',
        deleteHostConfig_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $2.DeleteHostConfigRequest.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$2.TestConnectionRequest, $2.TestConnectionResponse>(
        'TestConnection',
        testConnection_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $2.TestConnectionRequest.fromBuffer(value),
        ($2.TestConnectionResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$2.GetSshConfigStatusRequest, $2.GetSshConfigStatusResponse>(
        'GetSshConfigStatus',
        getSshConfigStatus_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $2.GetSshConfigStatusRequest.fromBuffer(value),
        ($2.GetSshConfigStatusResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$2.EnableSshConfigRequest, $2.EnableSshConfigResponse>(
        'EnableSshConfig',
        enableSshConfig_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $2.EnableSshConfigRequest.fromBuffer(value),
        ($2.EnableSshConfigResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$2.DisableSshConfigRequest, $2.DisableSshConfigResponse>(
        'DisableSshConfig',
        disableSshConfig_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $2.DisableSshConfigRequest.fromBuffer(value),
        ($2.DisableSshConfigResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$2.GetServerConfigRequest, $2.ServerConfig>(
        'GetServerConfig',
        getServerConfig_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $2.GetServerConfigRequest.fromBuffer(value),
        ($2.ServerConfig value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$2.UpdateServerConfigRequest, $2.ServerConfig>(
        'UpdateServerConfig',
        updateServerConfig_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $2.UpdateServerConfigRequest.fromBuffer(value),
        ($2.ServerConfig value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$2.ValidateServerConfigRequest, $2.ValidateServerConfigResponse>(
        'ValidateServerConfig',
        validateServerConfig_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $2.ValidateServerConfigRequest.fromBuffer(value),
        ($2.ValidateServerConfigResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$2.RestartSSHServiceRequest, $2.RestartSSHServiceResponse>(
        'RestartSSHService',
        restartSSHService_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $2.RestartSSHServiceRequest.fromBuffer(value),
        ($2.RestartSSHServiceResponse value) => value.writeToBuffer()));
  }

  $async.Future<$2.ListHostConfigsResponse> listHostConfigs_Pre($grpc.ServiceCall call, $async.Future<$2.ListHostConfigsRequest> request) async {
    return listHostConfigs(call, await request);
  }

  $async.Future<$2.HostConfig> getHostConfig_Pre($grpc.ServiceCall call, $async.Future<$2.GetHostConfigRequest> request) async {
    return getHostConfig(call, await request);
  }

  $async.Future<$2.HostConfig> createHostConfig_Pre($grpc.ServiceCall call, $async.Future<$2.CreateHostConfigRequest> request) async {
    return createHostConfig(call, await request);
  }

  $async.Future<$2.HostConfig> updateHostConfig_Pre($grpc.ServiceCall call, $async.Future<$2.UpdateHostConfigRequest> request) async {
    return updateHostConfig(call, await request);
  }

  $async.Future<$1.Empty> deleteHostConfig_Pre($grpc.ServiceCall call, $async.Future<$2.DeleteHostConfigRequest> request) async {
    return deleteHostConfig(call, await request);
  }

  $async.Future<$2.TestConnectionResponse> testConnection_Pre($grpc.ServiceCall call, $async.Future<$2.TestConnectionRequest> request) async {
    return testConnection(call, await request);
  }

  $async.Future<$2.GetSshConfigStatusResponse> getSshConfigStatus_Pre($grpc.ServiceCall call, $async.Future<$2.GetSshConfigStatusRequest> request) async {
    return getSshConfigStatus(call, await request);
  }

  $async.Future<$2.EnableSshConfigResponse> enableSshConfig_Pre($grpc.ServiceCall call, $async.Future<$2.EnableSshConfigRequest> request) async {
    return enableSshConfig(call, await request);
  }

  $async.Future<$2.DisableSshConfigResponse> disableSshConfig_Pre($grpc.ServiceCall call, $async.Future<$2.DisableSshConfigRequest> request) async {
    return disableSshConfig(call, await request);
  }

  $async.Future<$2.ServerConfig> getServerConfig_Pre($grpc.ServiceCall call, $async.Future<$2.GetServerConfigRequest> request) async {
    return getServerConfig(call, await request);
  }

  $async.Future<$2.ServerConfig> updateServerConfig_Pre($grpc.ServiceCall call, $async.Future<$2.UpdateServerConfigRequest> request) async {
    return updateServerConfig(call, await request);
  }

  $async.Future<$2.ValidateServerConfigResponse> validateServerConfig_Pre($grpc.ServiceCall call, $async.Future<$2.ValidateServerConfigRequest> request) async {
    return validateServerConfig(call, await request);
  }

  $async.Future<$2.RestartSSHServiceResponse> restartSSHService_Pre($grpc.ServiceCall call, $async.Future<$2.RestartSSHServiceRequest> request) async {
    return restartSSHService(call, await request);
  }

  $async.Future<$2.ListHostConfigsResponse> listHostConfigs($grpc.ServiceCall call, $2.ListHostConfigsRequest request);
  $async.Future<$2.HostConfig> getHostConfig($grpc.ServiceCall call, $2.GetHostConfigRequest request);
  $async.Future<$2.HostConfig> createHostConfig($grpc.ServiceCall call, $2.CreateHostConfigRequest request);
  $async.Future<$2.HostConfig> updateHostConfig($grpc.ServiceCall call, $2.UpdateHostConfigRequest request);
  $async.Future<$1.Empty> deleteHostConfig($grpc.ServiceCall call, $2.DeleteHostConfigRequest request);
  $async.Future<$2.TestConnectionResponse> testConnection($grpc.ServiceCall call, $2.TestConnectionRequest request);
  $async.Future<$2.GetSshConfigStatusResponse> getSshConfigStatus($grpc.ServiceCall call, $2.GetSshConfigStatusRequest request);
  $async.Future<$2.EnableSshConfigResponse> enableSshConfig($grpc.ServiceCall call, $2.EnableSshConfigRequest request);
  $async.Future<$2.DisableSshConfigResponse> disableSshConfig($grpc.ServiceCall call, $2.DisableSshConfigRequest request);
  $async.Future<$2.ServerConfig> getServerConfig($grpc.ServiceCall call, $2.GetServerConfigRequest request);
  $async.Future<$2.ServerConfig> updateServerConfig($grpc.ServiceCall call, $2.UpdateServerConfigRequest request);
  $async.Future<$2.ValidateServerConfigResponse> validateServerConfig($grpc.ServiceCall call, $2.ValidateServerConfigRequest request);
  $async.Future<$2.RestartSSHServiceResponse> restartSSHService($grpc.ServiceCall call, $2.RestartSSHServiceRequest request);
}
