// This is a generated file - do not edit.
//
// Generated from skeys/v1/system.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'system.pb.dart' as $0;

export 'system.pb.dart';

/// SystemService provides system-level operations for SSH client and server
@$pb.GrpcServiceName('skeys.v1.SystemService')
class SystemServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  SystemServiceClient(super.channel, {super.options, super.interceptors});

  /// Get comprehensive SSH system status (client, server, configs)
  $grpc.ResponseFuture<$0.GetSSHStatusResponse> getSSHStatus(
    $0.GetSSHStatusRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getSSHStatus, request, options: options);
  }

  /// SSH Server service control (requires elevated privileges)
  $grpc.ResponseFuture<$0.GetSSHServiceStatusResponse> getSSHServiceStatus(
    $0.GetSSHServiceStatusRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getSSHServiceStatus, request, options: options);
  }

  $grpc.ResponseFuture<$0.SSHServiceControlResponse> startSSHService(
    $0.StartSSHServiceRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$startSSHService, request, options: options);
  }

  $grpc.ResponseFuture<$0.SSHServiceControlResponse> stopSSHService(
    $0.StopSSHServiceRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$stopSSHService, request, options: options);
  }

  $grpc.ResponseFuture<$0.SSHServiceControlResponse>
      restartSSHServiceWithStatus(
    $0.RestartSSHServiceWithStatusRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$restartSSHServiceWithStatus, request,
        options: options);
  }

  $grpc.ResponseFuture<$0.SSHServiceControlResponse> reloadSSHService(
    $0.ReloadSSHServiceRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$reloadSSHService, request, options: options);
  }

  $grpc.ResponseFuture<$0.SSHServiceControlResponse> enableSSHService(
    $0.EnableSSHServiceRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$enableSSHService, request, options: options);
  }

  $grpc.ResponseFuture<$0.SSHServiceControlResponse> disableSSHService(
    $0.DisableSSHServiceRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$disableSSHService, request, options: options);
  }

  /// Get installation instructions for the detected distribution
  $grpc.ResponseFuture<$0.GetInstallInstructionsResponse>
      getInstallInstructions(
    $0.GetInstallInstructionsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getInstallInstructions, request,
        options: options);
  }

  // method descriptors

  static final _$getSSHStatus =
      $grpc.ClientMethod<$0.GetSSHStatusRequest, $0.GetSSHStatusResponse>(
          '/skeys.v1.SystemService/GetSSHStatus',
          ($0.GetSSHStatusRequest value) => value.writeToBuffer(),
          $0.GetSSHStatusResponse.fromBuffer);
  static final _$getSSHServiceStatus = $grpc.ClientMethod<
          $0.GetSSHServiceStatusRequest, $0.GetSSHServiceStatusResponse>(
      '/skeys.v1.SystemService/GetSSHServiceStatus',
      ($0.GetSSHServiceStatusRequest value) => value.writeToBuffer(),
      $0.GetSSHServiceStatusResponse.fromBuffer);
  static final _$startSSHService = $grpc.ClientMethod<$0.StartSSHServiceRequest,
          $0.SSHServiceControlResponse>(
      '/skeys.v1.SystemService/StartSSHService',
      ($0.StartSSHServiceRequest value) => value.writeToBuffer(),
      $0.SSHServiceControlResponse.fromBuffer);
  static final _$stopSSHService = $grpc.ClientMethod<$0.StopSSHServiceRequest,
          $0.SSHServiceControlResponse>(
      '/skeys.v1.SystemService/StopSSHService',
      ($0.StopSSHServiceRequest value) => value.writeToBuffer(),
      $0.SSHServiceControlResponse.fromBuffer);
  static final _$restartSSHServiceWithStatus = $grpc.ClientMethod<
          $0.RestartSSHServiceWithStatusRequest, $0.SSHServiceControlResponse>(
      '/skeys.v1.SystemService/RestartSSHServiceWithStatus',
      ($0.RestartSSHServiceWithStatusRequest value) => value.writeToBuffer(),
      $0.SSHServiceControlResponse.fromBuffer);
  static final _$reloadSSHService = $grpc.ClientMethod<
          $0.ReloadSSHServiceRequest, $0.SSHServiceControlResponse>(
      '/skeys.v1.SystemService/ReloadSSHService',
      ($0.ReloadSSHServiceRequest value) => value.writeToBuffer(),
      $0.SSHServiceControlResponse.fromBuffer);
  static final _$enableSSHService = $grpc.ClientMethod<
          $0.EnableSSHServiceRequest, $0.SSHServiceControlResponse>(
      '/skeys.v1.SystemService/EnableSSHService',
      ($0.EnableSSHServiceRequest value) => value.writeToBuffer(),
      $0.SSHServiceControlResponse.fromBuffer);
  static final _$disableSSHService = $grpc.ClientMethod<
          $0.DisableSSHServiceRequest, $0.SSHServiceControlResponse>(
      '/skeys.v1.SystemService/DisableSSHService',
      ($0.DisableSSHServiceRequest value) => value.writeToBuffer(),
      $0.SSHServiceControlResponse.fromBuffer);
  static final _$getInstallInstructions = $grpc.ClientMethod<
          $0.GetInstallInstructionsRequest, $0.GetInstallInstructionsResponse>(
      '/skeys.v1.SystemService/GetInstallInstructions',
      ($0.GetInstallInstructionsRequest value) => value.writeToBuffer(),
      $0.GetInstallInstructionsResponse.fromBuffer);
}

@$pb.GrpcServiceName('skeys.v1.SystemService')
abstract class SystemServiceBase extends $grpc.Service {
  $core.String get $name => 'skeys.v1.SystemService';

  SystemServiceBase() {
    $addMethod(
        $grpc.ServiceMethod<$0.GetSSHStatusRequest, $0.GetSSHStatusResponse>(
            'GetSSHStatus',
            getSSHStatus_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetSSHStatusRequest.fromBuffer(value),
            ($0.GetSSHStatusResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetSSHServiceStatusRequest,
            $0.GetSSHServiceStatusResponse>(
        'GetSSHServiceStatus',
        getSSHServiceStatus_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetSSHServiceStatusRequest.fromBuffer(value),
        ($0.GetSSHServiceStatusResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.StartSSHServiceRequest,
            $0.SSHServiceControlResponse>(
        'StartSSHService',
        startSSHService_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.StartSSHServiceRequest.fromBuffer(value),
        ($0.SSHServiceControlResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.StopSSHServiceRequest,
            $0.SSHServiceControlResponse>(
        'StopSSHService',
        stopSSHService_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.StopSSHServiceRequest.fromBuffer(value),
        ($0.SSHServiceControlResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RestartSSHServiceWithStatusRequest,
            $0.SSHServiceControlResponse>(
        'RestartSSHServiceWithStatus',
        restartSSHServiceWithStatus_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.RestartSSHServiceWithStatusRequest.fromBuffer(value),
        ($0.SSHServiceControlResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ReloadSSHServiceRequest,
            $0.SSHServiceControlResponse>(
        'ReloadSSHService',
        reloadSSHService_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ReloadSSHServiceRequest.fromBuffer(value),
        ($0.SSHServiceControlResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.EnableSSHServiceRequest,
            $0.SSHServiceControlResponse>(
        'EnableSSHService',
        enableSSHService_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.EnableSSHServiceRequest.fromBuffer(value),
        ($0.SSHServiceControlResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DisableSSHServiceRequest,
            $0.SSHServiceControlResponse>(
        'DisableSSHService',
        disableSSHService_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.DisableSSHServiceRequest.fromBuffer(value),
        ($0.SSHServiceControlResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetInstallInstructionsRequest,
            $0.GetInstallInstructionsResponse>(
        'GetInstallInstructions',
        getInstallInstructions_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetInstallInstructionsRequest.fromBuffer(value),
        ($0.GetInstallInstructionsResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.GetSSHStatusResponse> getSSHStatus_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetSSHStatusRequest> $request) async {
    return getSSHStatus($call, await $request);
  }

  $async.Future<$0.GetSSHStatusResponse> getSSHStatus(
      $grpc.ServiceCall call, $0.GetSSHStatusRequest request);

  $async.Future<$0.GetSSHServiceStatusResponse> getSSHServiceStatus_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetSSHServiceStatusRequest> $request) async {
    return getSSHServiceStatus($call, await $request);
  }

  $async.Future<$0.GetSSHServiceStatusResponse> getSSHServiceStatus(
      $grpc.ServiceCall call, $0.GetSSHServiceStatusRequest request);

  $async.Future<$0.SSHServiceControlResponse> startSSHService_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.StartSSHServiceRequest> $request) async {
    return startSSHService($call, await $request);
  }

  $async.Future<$0.SSHServiceControlResponse> startSSHService(
      $grpc.ServiceCall call, $0.StartSSHServiceRequest request);

  $async.Future<$0.SSHServiceControlResponse> stopSSHService_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.StopSSHServiceRequest> $request) async {
    return stopSSHService($call, await $request);
  }

  $async.Future<$0.SSHServiceControlResponse> stopSSHService(
      $grpc.ServiceCall call, $0.StopSSHServiceRequest request);

  $async.Future<$0.SSHServiceControlResponse> restartSSHServiceWithStatus_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.RestartSSHServiceWithStatusRequest> $request) async {
    return restartSSHServiceWithStatus($call, await $request);
  }

  $async.Future<$0.SSHServiceControlResponse> restartSSHServiceWithStatus(
      $grpc.ServiceCall call, $0.RestartSSHServiceWithStatusRequest request);

  $async.Future<$0.SSHServiceControlResponse> reloadSSHService_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ReloadSSHServiceRequest> $request) async {
    return reloadSSHService($call, await $request);
  }

  $async.Future<$0.SSHServiceControlResponse> reloadSSHService(
      $grpc.ServiceCall call, $0.ReloadSSHServiceRequest request);

  $async.Future<$0.SSHServiceControlResponse> enableSSHService_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.EnableSSHServiceRequest> $request) async {
    return enableSSHService($call, await $request);
  }

  $async.Future<$0.SSHServiceControlResponse> enableSSHService(
      $grpc.ServiceCall call, $0.EnableSSHServiceRequest request);

  $async.Future<$0.SSHServiceControlResponse> disableSSHService_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.DisableSSHServiceRequest> $request) async {
    return disableSSHService($call, await $request);
  }

  $async.Future<$0.SSHServiceControlResponse> disableSSHService(
      $grpc.ServiceCall call, $0.DisableSSHServiceRequest request);

  $async.Future<$0.GetInstallInstructionsResponse> getInstallInstructions_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetInstallInstructionsRequest> $request) async {
    return getInstallInstructions($call, await $request);
  }

  $async.Future<$0.GetInstallInstructionsResponse> getInstallInstructions(
      $grpc.ServiceCall call, $0.GetInstallInstructionsRequest request);
}
