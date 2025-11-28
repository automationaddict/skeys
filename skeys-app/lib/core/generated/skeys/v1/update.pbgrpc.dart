// This is a generated file - do not edit.
//
// Generated from skeys/v1/update.proto.

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
import '../../google/protobuf/empty.pb.dart' as $0;

import 'update.pb.dart' as $1;

export 'update.pb.dart';

/// UpdateService provides automatic update functionality
@$pb.GrpcServiceName('skeys.v1.UpdateService')
class UpdateServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  UpdateServiceClient(super.channel, {super.options, super.interceptors});

  /// CheckForUpdates checks GitHub for a newer version
  $grpc.ResponseFuture<$1.UpdateInfo> checkForUpdates(
    $0.Empty request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$checkForUpdates, request, options: options);
  }

  /// DownloadUpdate downloads the latest release tarball
  $grpc.ResponseStream<$1.DownloadProgress> downloadUpdate(
    $1.DownloadUpdateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(
        _$downloadUpdate, $async.Stream.fromIterable([request]),
        options: options);
  }

  /// ApplyUpdate extracts and applies a downloaded update
  $grpc.ResponseFuture<$1.ApplyUpdateResponse> applyUpdate(
    $1.ApplyUpdateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$applyUpdate, request, options: options);
  }

  /// GetUpdateSettings returns the current update configuration
  $grpc.ResponseFuture<$1.UpdateSettings> getUpdateSettings(
    $0.Empty request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getUpdateSettings, request, options: options);
  }

  /// SetUpdateSettings updates the update configuration
  $grpc.ResponseFuture<$1.UpdateSettings> setUpdateSettings(
    $1.UpdateSettings request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$setUpdateSettings, request, options: options);
  }

  /// GetUpdateStatus returns the current update state (checking, downloading, ready, etc.)
  $grpc.ResponseFuture<$1.UpdateStatus> getUpdateStatus(
    $0.Empty request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getUpdateStatus, request, options: options);
  }

  // method descriptors

  static final _$checkForUpdates = $grpc.ClientMethod<$0.Empty, $1.UpdateInfo>(
      '/skeys.v1.UpdateService/CheckForUpdates',
      ($0.Empty value) => value.writeToBuffer(),
      $1.UpdateInfo.fromBuffer);
  static final _$downloadUpdate =
      $grpc.ClientMethod<$1.DownloadUpdateRequest, $1.DownloadProgress>(
          '/skeys.v1.UpdateService/DownloadUpdate',
          ($1.DownloadUpdateRequest value) => value.writeToBuffer(),
          $1.DownloadProgress.fromBuffer);
  static final _$applyUpdate =
      $grpc.ClientMethod<$1.ApplyUpdateRequest, $1.ApplyUpdateResponse>(
          '/skeys.v1.UpdateService/ApplyUpdate',
          ($1.ApplyUpdateRequest value) => value.writeToBuffer(),
          $1.ApplyUpdateResponse.fromBuffer);
  static final _$getUpdateSettings =
      $grpc.ClientMethod<$0.Empty, $1.UpdateSettings>(
          '/skeys.v1.UpdateService/GetUpdateSettings',
          ($0.Empty value) => value.writeToBuffer(),
          $1.UpdateSettings.fromBuffer);
  static final _$setUpdateSettings =
      $grpc.ClientMethod<$1.UpdateSettings, $1.UpdateSettings>(
          '/skeys.v1.UpdateService/SetUpdateSettings',
          ($1.UpdateSettings value) => value.writeToBuffer(),
          $1.UpdateSettings.fromBuffer);
  static final _$getUpdateStatus =
      $grpc.ClientMethod<$0.Empty, $1.UpdateStatus>(
          '/skeys.v1.UpdateService/GetUpdateStatus',
          ($0.Empty value) => value.writeToBuffer(),
          $1.UpdateStatus.fromBuffer);
}

@$pb.GrpcServiceName('skeys.v1.UpdateService')
abstract class UpdateServiceBase extends $grpc.Service {
  $core.String get $name => 'skeys.v1.UpdateService';

  UpdateServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.Empty, $1.UpdateInfo>(
        'CheckForUpdates',
        checkForUpdates_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($1.UpdateInfo value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$1.DownloadUpdateRequest, $1.DownloadProgress>(
            'DownloadUpdate',
            downloadUpdate_Pre,
            false,
            true,
            ($core.List<$core.int> value) =>
                $1.DownloadUpdateRequest.fromBuffer(value),
            ($1.DownloadProgress value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$1.ApplyUpdateRequest, $1.ApplyUpdateResponse>(
            'ApplyUpdate',
            applyUpdate_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $1.ApplyUpdateRequest.fromBuffer(value),
            ($1.ApplyUpdateResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $1.UpdateSettings>(
        'GetUpdateSettings',
        getUpdateSettings_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($1.UpdateSettings value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.UpdateSettings, $1.UpdateSettings>(
        'SetUpdateSettings',
        setUpdateSettings_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.UpdateSettings.fromBuffer(value),
        ($1.UpdateSettings value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $1.UpdateStatus>(
        'GetUpdateStatus',
        getUpdateStatus_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($1.UpdateStatus value) => value.writeToBuffer()));
  }

  $async.Future<$1.UpdateInfo> checkForUpdates_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.Empty> $request) async {
    return checkForUpdates($call, await $request);
  }

  $async.Future<$1.UpdateInfo> checkForUpdates(
      $grpc.ServiceCall call, $0.Empty request);

  $async.Stream<$1.DownloadProgress> downloadUpdate_Pre($grpc.ServiceCall $call,
      $async.Future<$1.DownloadUpdateRequest> $request) async* {
    yield* downloadUpdate($call, await $request);
  }

  $async.Stream<$1.DownloadProgress> downloadUpdate(
      $grpc.ServiceCall call, $1.DownloadUpdateRequest request);

  $async.Future<$1.ApplyUpdateResponse> applyUpdate_Pre($grpc.ServiceCall $call,
      $async.Future<$1.ApplyUpdateRequest> $request) async {
    return applyUpdate($call, await $request);
  }

  $async.Future<$1.ApplyUpdateResponse> applyUpdate(
      $grpc.ServiceCall call, $1.ApplyUpdateRequest request);

  $async.Future<$1.UpdateSettings> getUpdateSettings_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.Empty> $request) async {
    return getUpdateSettings($call, await $request);
  }

  $async.Future<$1.UpdateSettings> getUpdateSettings(
      $grpc.ServiceCall call, $0.Empty request);

  $async.Future<$1.UpdateSettings> setUpdateSettings_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$1.UpdateSettings> $request) async {
    return setUpdateSettings($call, await $request);
  }

  $async.Future<$1.UpdateSettings> setUpdateSettings(
      $grpc.ServiceCall call, $1.UpdateSettings request);

  $async.Future<$1.UpdateStatus> getUpdateStatus_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.Empty> $request) async {
    return getUpdateStatus($call, await $request);
  }

  $async.Future<$1.UpdateStatus> getUpdateStatus(
      $grpc.ServiceCall call, $0.Empty request);
}
