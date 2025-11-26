// This is a generated file - do not edit.
//
// Generated from skeys/v1/config.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import '../../google/protobuf/empty.pb.dart' as $1;
import 'config.pb.dart' as $0;

export 'config.pb.dart';

@$pb.GrpcServiceName('skeys.v1.ConfigService')
class ConfigServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  ConfigServiceClient(super.channel, {super.options, super.interceptors});

  /// SSH Client Config (~/.ssh/config)
  $grpc.ResponseFuture<$0.ListHostConfigsResponse> listHostConfigs(
    $0.ListHostConfigsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listHostConfigs, request, options: options);
  }

  $grpc.ResponseFuture<$0.HostConfig> getHostConfig(
    $0.GetHostConfigRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getHostConfig, request, options: options);
  }

  $grpc.ResponseFuture<$0.HostConfig> createHostConfig(
    $0.CreateHostConfigRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$createHostConfig, request, options: options);
  }

  $grpc.ResponseFuture<$0.HostConfig> updateHostConfig(
    $0.UpdateHostConfigRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateHostConfig, request, options: options);
  }

  $grpc.ResponseFuture<$1.Empty> deleteHostConfig(
    $0.DeleteHostConfigRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$deleteHostConfig, request, options: options);
  }

  $grpc.ResponseFuture<$0.TestConnectionResponse> testConnection(
    $0.TestConnectionRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$testConnection, request, options: options);
  }

  /// SSH Server Config (/etc/ssh/sshd_config)
  $grpc.ResponseFuture<$0.ServerConfig> getServerConfig(
    $0.GetServerConfigRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getServerConfig, request, options: options);
  }

  $grpc.ResponseFuture<$0.ServerConfig> updateServerConfig(
    $0.UpdateServerConfigRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateServerConfig, request, options: options);
  }

  $grpc.ResponseFuture<$0.ValidateServerConfigResponse> validateServerConfig(
    $0.ValidateServerConfigRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$validateServerConfig, request, options: options);
  }

  $grpc.ResponseFuture<$0.RestartSSHServiceResponse> restartSSHService(
    $0.RestartSSHServiceRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$restartSSHService, request, options: options);
  }

  // method descriptors

  static final _$listHostConfigs =
      $grpc.ClientMethod<$0.ListHostConfigsRequest, $0.ListHostConfigsResponse>(
          '/skeys.v1.ConfigService/ListHostConfigs',
          ($0.ListHostConfigsRequest value) => value.writeToBuffer(),
          $0.ListHostConfigsResponse.fromBuffer);
  static final _$getHostConfig =
      $grpc.ClientMethod<$0.GetHostConfigRequest, $0.HostConfig>(
          '/skeys.v1.ConfigService/GetHostConfig',
          ($0.GetHostConfigRequest value) => value.writeToBuffer(),
          $0.HostConfig.fromBuffer);
  static final _$createHostConfig =
      $grpc.ClientMethod<$0.CreateHostConfigRequest, $0.HostConfig>(
          '/skeys.v1.ConfigService/CreateHostConfig',
          ($0.CreateHostConfigRequest value) => value.writeToBuffer(),
          $0.HostConfig.fromBuffer);
  static final _$updateHostConfig =
      $grpc.ClientMethod<$0.UpdateHostConfigRequest, $0.HostConfig>(
          '/skeys.v1.ConfigService/UpdateHostConfig',
          ($0.UpdateHostConfigRequest value) => value.writeToBuffer(),
          $0.HostConfig.fromBuffer);
  static final _$deleteHostConfig =
      $grpc.ClientMethod<$0.DeleteHostConfigRequest, $1.Empty>(
          '/skeys.v1.ConfigService/DeleteHostConfig',
          ($0.DeleteHostConfigRequest value) => value.writeToBuffer(),
          $1.Empty.fromBuffer);
  static final _$testConnection =
      $grpc.ClientMethod<$0.TestConnectionRequest, $0.TestConnectionResponse>(
          '/skeys.v1.ConfigService/TestConnection',
          ($0.TestConnectionRequest value) => value.writeToBuffer(),
          $0.TestConnectionResponse.fromBuffer);
  static final _$getServerConfig =
      $grpc.ClientMethod<$0.GetServerConfigRequest, $0.ServerConfig>(
          '/skeys.v1.ConfigService/GetServerConfig',
          ($0.GetServerConfigRequest value) => value.writeToBuffer(),
          $0.ServerConfig.fromBuffer);
  static final _$updateServerConfig =
      $grpc.ClientMethod<$0.UpdateServerConfigRequest, $0.ServerConfig>(
          '/skeys.v1.ConfigService/UpdateServerConfig',
          ($0.UpdateServerConfigRequest value) => value.writeToBuffer(),
          $0.ServerConfig.fromBuffer);
  static final _$validateServerConfig = $grpc.ClientMethod<
          $0.ValidateServerConfigRequest, $0.ValidateServerConfigResponse>(
      '/skeys.v1.ConfigService/ValidateServerConfig',
      ($0.ValidateServerConfigRequest value) => value.writeToBuffer(),
      $0.ValidateServerConfigResponse.fromBuffer);
  static final _$restartSSHService = $grpc.ClientMethod<
          $0.RestartSSHServiceRequest, $0.RestartSSHServiceResponse>(
      '/skeys.v1.ConfigService/RestartSSHService',
      ($0.RestartSSHServiceRequest value) => value.writeToBuffer(),
      $0.RestartSSHServiceResponse.fromBuffer);
}

@$pb.GrpcServiceName('skeys.v1.ConfigService')
abstract class ConfigServiceBase extends $grpc.Service {
  $core.String get $name => 'skeys.v1.ConfigService';

  ConfigServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.ListHostConfigsRequest,
            $0.ListHostConfigsResponse>(
        'ListHostConfigs',
        listHostConfigs_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ListHostConfigsRequest.fromBuffer(value),
        ($0.ListHostConfigsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetHostConfigRequest, $0.HostConfig>(
        'GetHostConfig',
        getHostConfig_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetHostConfigRequest.fromBuffer(value),
        ($0.HostConfig value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CreateHostConfigRequest, $0.HostConfig>(
        'CreateHostConfig',
        createHostConfig_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CreateHostConfigRequest.fromBuffer(value),
        ($0.HostConfig value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UpdateHostConfigRequest, $0.HostConfig>(
        'UpdateHostConfig',
        updateHostConfig_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.UpdateHostConfigRequest.fromBuffer(value),
        ($0.HostConfig value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DeleteHostConfigRequest, $1.Empty>(
        'DeleteHostConfig',
        deleteHostConfig_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.DeleteHostConfigRequest.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.TestConnectionRequest,
            $0.TestConnectionResponse>(
        'TestConnection',
        testConnection_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.TestConnectionRequest.fromBuffer(value),
        ($0.TestConnectionResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetServerConfigRequest, $0.ServerConfig>(
        'GetServerConfig',
        getServerConfig_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetServerConfigRequest.fromBuffer(value),
        ($0.ServerConfig value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.UpdateServerConfigRequest, $0.ServerConfig>(
            'UpdateServerConfig',
            updateServerConfig_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.UpdateServerConfigRequest.fromBuffer(value),
            ($0.ServerConfig value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ValidateServerConfigRequest,
            $0.ValidateServerConfigResponse>(
        'ValidateServerConfig',
        validateServerConfig_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ValidateServerConfigRequest.fromBuffer(value),
        ($0.ValidateServerConfigResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RestartSSHServiceRequest,
            $0.RestartSSHServiceResponse>(
        'RestartSSHService',
        restartSSHService_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.RestartSSHServiceRequest.fromBuffer(value),
        ($0.RestartSSHServiceResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.ListHostConfigsResponse> listHostConfigs_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListHostConfigsRequest> $request) async {
    return listHostConfigs($call, await $request);
  }

  $async.Future<$0.ListHostConfigsResponse> listHostConfigs(
      $grpc.ServiceCall call, $0.ListHostConfigsRequest request);

  $async.Future<$0.HostConfig> getHostConfig_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetHostConfigRequest> $request) async {
    return getHostConfig($call, await $request);
  }

  $async.Future<$0.HostConfig> getHostConfig(
      $grpc.ServiceCall call, $0.GetHostConfigRequest request);

  $async.Future<$0.HostConfig> createHostConfig_Pre($grpc.ServiceCall $call,
      $async.Future<$0.CreateHostConfigRequest> $request) async {
    return createHostConfig($call, await $request);
  }

  $async.Future<$0.HostConfig> createHostConfig(
      $grpc.ServiceCall call, $0.CreateHostConfigRequest request);

  $async.Future<$0.HostConfig> updateHostConfig_Pre($grpc.ServiceCall $call,
      $async.Future<$0.UpdateHostConfigRequest> $request) async {
    return updateHostConfig($call, await $request);
  }

  $async.Future<$0.HostConfig> updateHostConfig(
      $grpc.ServiceCall call, $0.UpdateHostConfigRequest request);

  $async.Future<$1.Empty> deleteHostConfig_Pre($grpc.ServiceCall $call,
      $async.Future<$0.DeleteHostConfigRequest> $request) async {
    return deleteHostConfig($call, await $request);
  }

  $async.Future<$1.Empty> deleteHostConfig(
      $grpc.ServiceCall call, $0.DeleteHostConfigRequest request);

  $async.Future<$0.TestConnectionResponse> testConnection_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.TestConnectionRequest> $request) async {
    return testConnection($call, await $request);
  }

  $async.Future<$0.TestConnectionResponse> testConnection(
      $grpc.ServiceCall call, $0.TestConnectionRequest request);

  $async.Future<$0.ServerConfig> getServerConfig_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetServerConfigRequest> $request) async {
    return getServerConfig($call, await $request);
  }

  $async.Future<$0.ServerConfig> getServerConfig(
      $grpc.ServiceCall call, $0.GetServerConfigRequest request);

  $async.Future<$0.ServerConfig> updateServerConfig_Pre($grpc.ServiceCall $call,
      $async.Future<$0.UpdateServerConfigRequest> $request) async {
    return updateServerConfig($call, await $request);
  }

  $async.Future<$0.ServerConfig> updateServerConfig(
      $grpc.ServiceCall call, $0.UpdateServerConfigRequest request);

  $async.Future<$0.ValidateServerConfigResponse> validateServerConfig_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ValidateServerConfigRequest> $request) async {
    return validateServerConfig($call, await $request);
  }

  $async.Future<$0.ValidateServerConfigResponse> validateServerConfig(
      $grpc.ServiceCall call, $0.ValidateServerConfigRequest request);

  $async.Future<$0.RestartSSHServiceResponse> restartSSHService_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.RestartSSHServiceRequest> $request) async {
    return restartSSHService($call, await $request);
  }

  $async.Future<$0.RestartSSHServiceResponse> restartSSHService(
      $grpc.ServiceCall call, $0.RestartSSHServiceRequest request);
}
