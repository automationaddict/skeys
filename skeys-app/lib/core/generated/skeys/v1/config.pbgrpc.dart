// This is a generated file - do not edit.
//
// Generated from skeys/v1/config.proto.

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

  /// SSH Client Config - New unified API (~/.ssh/config)
  $grpc.ResponseFuture<$0.ListSSHConfigEntriesResponse> listSSHConfigEntries(
    $0.ListSSHConfigEntriesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listSSHConfigEntries, request, options: options);
  }

  $grpc.ResponseFuture<$0.SSHConfigEntry> getSSHConfigEntry(
    $0.GetSSHConfigEntryRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getSSHConfigEntry, request, options: options);
  }

  $grpc.ResponseFuture<$0.SSHConfigEntry> createSSHConfigEntry(
    $0.CreateSSHConfigEntryRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$createSSHConfigEntry, request, options: options);
  }

  $grpc.ResponseFuture<$0.SSHConfigEntry> updateSSHConfigEntry(
    $0.UpdateSSHConfigEntryRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateSSHConfigEntry, request, options: options);
  }

  $grpc.ResponseFuture<$1.Empty> deleteSSHConfigEntry(
    $0.DeleteSSHConfigEntryRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$deleteSSHConfigEntry, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListSSHConfigEntriesResponse> reorderSSHConfigEntries(
    $0.ReorderSSHConfigEntriesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$reorderSSHConfigEntries, request,
        options: options);
  }

  /// SSH Client Config - Global directives (options outside Host/Match blocks)
  $grpc.ResponseFuture<$0.ListGlobalDirectivesResponse> listGlobalDirectives(
    $0.ListGlobalDirectivesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listGlobalDirectives, request, options: options);
  }

  $grpc.ResponseFuture<$0.GlobalDirective> setGlobalDirective(
    $0.SetGlobalDirectiveRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$setGlobalDirective, request, options: options);
  }

  $grpc.ResponseFuture<$1.Empty> deleteGlobalDirective(
    $0.DeleteGlobalDirectiveRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$deleteGlobalDirective, request, options: options);
  }

  /// SSH Client Config - Legacy API (backward compatibility)
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

  /// Skeys SSH Agent Integration
  /// Manages the skeys managed block in ~/.ssh/config to use skeys agent for SSH
  $grpc.ResponseFuture<$0.GetSshConfigStatusResponse> getSshConfigStatus(
    $0.GetSshConfigStatusRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getSshConfigStatus, request, options: options);
  }

  $grpc.ResponseFuture<$0.EnableSshConfigResponse> enableSshConfig(
    $0.EnableSshConfigRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$enableSshConfig, request, options: options);
  }

  $grpc.ResponseFuture<$0.DisableSshConfigResponse> disableSshConfig(
    $0.DisableSshConfigRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$disableSshConfig, request, options: options);
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

  /// Config Path Discovery
  /// Auto-detect SSH config file locations across different Linux distributions
  $grpc.ResponseFuture<$0.DiscoverConfigPathsResponse> discoverConfigPaths(
    $0.DiscoverConfigPathsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$discoverConfigPaths, request, options: options);
  }

  // method descriptors

  static final _$listSSHConfigEntries = $grpc.ClientMethod<
          $0.ListSSHConfigEntriesRequest, $0.ListSSHConfigEntriesResponse>(
      '/skeys.v1.ConfigService/ListSSHConfigEntries',
      ($0.ListSSHConfigEntriesRequest value) => value.writeToBuffer(),
      $0.ListSSHConfigEntriesResponse.fromBuffer);
  static final _$getSSHConfigEntry =
      $grpc.ClientMethod<$0.GetSSHConfigEntryRequest, $0.SSHConfigEntry>(
          '/skeys.v1.ConfigService/GetSSHConfigEntry',
          ($0.GetSSHConfigEntryRequest value) => value.writeToBuffer(),
          $0.SSHConfigEntry.fromBuffer);
  static final _$createSSHConfigEntry =
      $grpc.ClientMethod<$0.CreateSSHConfigEntryRequest, $0.SSHConfigEntry>(
          '/skeys.v1.ConfigService/CreateSSHConfigEntry',
          ($0.CreateSSHConfigEntryRequest value) => value.writeToBuffer(),
          $0.SSHConfigEntry.fromBuffer);
  static final _$updateSSHConfigEntry =
      $grpc.ClientMethod<$0.UpdateSSHConfigEntryRequest, $0.SSHConfigEntry>(
          '/skeys.v1.ConfigService/UpdateSSHConfigEntry',
          ($0.UpdateSSHConfigEntryRequest value) => value.writeToBuffer(),
          $0.SSHConfigEntry.fromBuffer);
  static final _$deleteSSHConfigEntry =
      $grpc.ClientMethod<$0.DeleteSSHConfigEntryRequest, $1.Empty>(
          '/skeys.v1.ConfigService/DeleteSSHConfigEntry',
          ($0.DeleteSSHConfigEntryRequest value) => value.writeToBuffer(),
          $1.Empty.fromBuffer);
  static final _$reorderSSHConfigEntries = $grpc.ClientMethod<
          $0.ReorderSSHConfigEntriesRequest, $0.ListSSHConfigEntriesResponse>(
      '/skeys.v1.ConfigService/ReorderSSHConfigEntries',
      ($0.ReorderSSHConfigEntriesRequest value) => value.writeToBuffer(),
      $0.ListSSHConfigEntriesResponse.fromBuffer);
  static final _$listGlobalDirectives = $grpc.ClientMethod<
          $0.ListGlobalDirectivesRequest, $0.ListGlobalDirectivesResponse>(
      '/skeys.v1.ConfigService/ListGlobalDirectives',
      ($0.ListGlobalDirectivesRequest value) => value.writeToBuffer(),
      $0.ListGlobalDirectivesResponse.fromBuffer);
  static final _$setGlobalDirective =
      $grpc.ClientMethod<$0.SetGlobalDirectiveRequest, $0.GlobalDirective>(
          '/skeys.v1.ConfigService/SetGlobalDirective',
          ($0.SetGlobalDirectiveRequest value) => value.writeToBuffer(),
          $0.GlobalDirective.fromBuffer);
  static final _$deleteGlobalDirective =
      $grpc.ClientMethod<$0.DeleteGlobalDirectiveRequest, $1.Empty>(
          '/skeys.v1.ConfigService/DeleteGlobalDirective',
          ($0.DeleteGlobalDirectiveRequest value) => value.writeToBuffer(),
          $1.Empty.fromBuffer);
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
  static final _$getSshConfigStatus = $grpc.ClientMethod<
          $0.GetSshConfigStatusRequest, $0.GetSshConfigStatusResponse>(
      '/skeys.v1.ConfigService/GetSshConfigStatus',
      ($0.GetSshConfigStatusRequest value) => value.writeToBuffer(),
      $0.GetSshConfigStatusResponse.fromBuffer);
  static final _$enableSshConfig =
      $grpc.ClientMethod<$0.EnableSshConfigRequest, $0.EnableSshConfigResponse>(
          '/skeys.v1.ConfigService/EnableSshConfig',
          ($0.EnableSshConfigRequest value) => value.writeToBuffer(),
          $0.EnableSshConfigResponse.fromBuffer);
  static final _$disableSshConfig = $grpc.ClientMethod<
          $0.DisableSshConfigRequest, $0.DisableSshConfigResponse>(
      '/skeys.v1.ConfigService/DisableSshConfig',
      ($0.DisableSshConfigRequest value) => value.writeToBuffer(),
      $0.DisableSshConfigResponse.fromBuffer);
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
  static final _$discoverConfigPaths = $grpc.ClientMethod<
          $0.DiscoverConfigPathsRequest, $0.DiscoverConfigPathsResponse>(
      '/skeys.v1.ConfigService/DiscoverConfigPaths',
      ($0.DiscoverConfigPathsRequest value) => value.writeToBuffer(),
      $0.DiscoverConfigPathsResponse.fromBuffer);
}

@$pb.GrpcServiceName('skeys.v1.ConfigService')
abstract class ConfigServiceBase extends $grpc.Service {
  $core.String get $name => 'skeys.v1.ConfigService';

  ConfigServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.ListSSHConfigEntriesRequest,
            $0.ListSSHConfigEntriesResponse>(
        'ListSSHConfigEntries',
        listSSHConfigEntries_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ListSSHConfigEntriesRequest.fromBuffer(value),
        ($0.ListSSHConfigEntriesResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.GetSSHConfigEntryRequest, $0.SSHConfigEntry>(
            'GetSSHConfigEntry',
            getSSHConfigEntry_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetSSHConfigEntryRequest.fromBuffer(value),
            ($0.SSHConfigEntry value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.CreateSSHConfigEntryRequest, $0.SSHConfigEntry>(
            'CreateSSHConfigEntry',
            createSSHConfigEntry_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.CreateSSHConfigEntryRequest.fromBuffer(value),
            ($0.SSHConfigEntry value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.UpdateSSHConfigEntryRequest, $0.SSHConfigEntry>(
            'UpdateSSHConfigEntry',
            updateSSHConfigEntry_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.UpdateSSHConfigEntryRequest.fromBuffer(value),
            ($0.SSHConfigEntry value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DeleteSSHConfigEntryRequest, $1.Empty>(
        'DeleteSSHConfigEntry',
        deleteSSHConfigEntry_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.DeleteSSHConfigEntryRequest.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ReorderSSHConfigEntriesRequest,
            $0.ListSSHConfigEntriesResponse>(
        'ReorderSSHConfigEntries',
        reorderSSHConfigEntries_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ReorderSSHConfigEntriesRequest.fromBuffer(value),
        ($0.ListSSHConfigEntriesResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListGlobalDirectivesRequest,
            $0.ListGlobalDirectivesResponse>(
        'ListGlobalDirectives',
        listGlobalDirectives_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ListGlobalDirectivesRequest.fromBuffer(value),
        ($0.ListGlobalDirectivesResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.SetGlobalDirectiveRequest, $0.GlobalDirective>(
            'SetGlobalDirective',
            setGlobalDirective_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.SetGlobalDirectiveRequest.fromBuffer(value),
            ($0.GlobalDirective value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DeleteGlobalDirectiveRequest, $1.Empty>(
        'DeleteGlobalDirective',
        deleteGlobalDirective_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.DeleteGlobalDirectiveRequest.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
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
    $addMethod($grpc.ServiceMethod<$0.GetSshConfigStatusRequest,
            $0.GetSshConfigStatusResponse>(
        'GetSshConfigStatus',
        getSshConfigStatus_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetSshConfigStatusRequest.fromBuffer(value),
        ($0.GetSshConfigStatusResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.EnableSshConfigRequest,
            $0.EnableSshConfigResponse>(
        'EnableSshConfig',
        enableSshConfig_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.EnableSshConfigRequest.fromBuffer(value),
        ($0.EnableSshConfigResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DisableSshConfigRequest,
            $0.DisableSshConfigResponse>(
        'DisableSshConfig',
        disableSshConfig_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.DisableSshConfigRequest.fromBuffer(value),
        ($0.DisableSshConfigResponse value) => value.writeToBuffer()));
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
    $addMethod($grpc.ServiceMethod<$0.DiscoverConfigPathsRequest,
            $0.DiscoverConfigPathsResponse>(
        'DiscoverConfigPaths',
        discoverConfigPaths_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.DiscoverConfigPathsRequest.fromBuffer(value),
        ($0.DiscoverConfigPathsResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.ListSSHConfigEntriesResponse> listSSHConfigEntries_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListSSHConfigEntriesRequest> $request) async {
    return listSSHConfigEntries($call, await $request);
  }

  $async.Future<$0.ListSSHConfigEntriesResponse> listSSHConfigEntries(
      $grpc.ServiceCall call, $0.ListSSHConfigEntriesRequest request);

  $async.Future<$0.SSHConfigEntry> getSSHConfigEntry_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetSSHConfigEntryRequest> $request) async {
    return getSSHConfigEntry($call, await $request);
  }

  $async.Future<$0.SSHConfigEntry> getSSHConfigEntry(
      $grpc.ServiceCall call, $0.GetSSHConfigEntryRequest request);

  $async.Future<$0.SSHConfigEntry> createSSHConfigEntry_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CreateSSHConfigEntryRequest> $request) async {
    return createSSHConfigEntry($call, await $request);
  }

  $async.Future<$0.SSHConfigEntry> createSSHConfigEntry(
      $grpc.ServiceCall call, $0.CreateSSHConfigEntryRequest request);

  $async.Future<$0.SSHConfigEntry> updateSSHConfigEntry_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.UpdateSSHConfigEntryRequest> $request) async {
    return updateSSHConfigEntry($call, await $request);
  }

  $async.Future<$0.SSHConfigEntry> updateSSHConfigEntry(
      $grpc.ServiceCall call, $0.UpdateSSHConfigEntryRequest request);

  $async.Future<$1.Empty> deleteSSHConfigEntry_Pre($grpc.ServiceCall $call,
      $async.Future<$0.DeleteSSHConfigEntryRequest> $request) async {
    return deleteSSHConfigEntry($call, await $request);
  }

  $async.Future<$1.Empty> deleteSSHConfigEntry(
      $grpc.ServiceCall call, $0.DeleteSSHConfigEntryRequest request);

  $async.Future<$0.ListSSHConfigEntriesResponse> reorderSSHConfigEntries_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ReorderSSHConfigEntriesRequest> $request) async {
    return reorderSSHConfigEntries($call, await $request);
  }

  $async.Future<$0.ListSSHConfigEntriesResponse> reorderSSHConfigEntries(
      $grpc.ServiceCall call, $0.ReorderSSHConfigEntriesRequest request);

  $async.Future<$0.ListGlobalDirectivesResponse> listGlobalDirectives_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListGlobalDirectivesRequest> $request) async {
    return listGlobalDirectives($call, await $request);
  }

  $async.Future<$0.ListGlobalDirectivesResponse> listGlobalDirectives(
      $grpc.ServiceCall call, $0.ListGlobalDirectivesRequest request);

  $async.Future<$0.GlobalDirective> setGlobalDirective_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SetGlobalDirectiveRequest> $request) async {
    return setGlobalDirective($call, await $request);
  }

  $async.Future<$0.GlobalDirective> setGlobalDirective(
      $grpc.ServiceCall call, $0.SetGlobalDirectiveRequest request);

  $async.Future<$1.Empty> deleteGlobalDirective_Pre($grpc.ServiceCall $call,
      $async.Future<$0.DeleteGlobalDirectiveRequest> $request) async {
    return deleteGlobalDirective($call, await $request);
  }

  $async.Future<$1.Empty> deleteGlobalDirective(
      $grpc.ServiceCall call, $0.DeleteGlobalDirectiveRequest request);

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

  $async.Future<$0.GetSshConfigStatusResponse> getSshConfigStatus_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetSshConfigStatusRequest> $request) async {
    return getSshConfigStatus($call, await $request);
  }

  $async.Future<$0.GetSshConfigStatusResponse> getSshConfigStatus(
      $grpc.ServiceCall call, $0.GetSshConfigStatusRequest request);

  $async.Future<$0.EnableSshConfigResponse> enableSshConfig_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.EnableSshConfigRequest> $request) async {
    return enableSshConfig($call, await $request);
  }

  $async.Future<$0.EnableSshConfigResponse> enableSshConfig(
      $grpc.ServiceCall call, $0.EnableSshConfigRequest request);

  $async.Future<$0.DisableSshConfigResponse> disableSshConfig_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.DisableSshConfigRequest> $request) async {
    return disableSshConfig($call, await $request);
  }

  $async.Future<$0.DisableSshConfigResponse> disableSshConfig(
      $grpc.ServiceCall call, $0.DisableSshConfigRequest request);

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

  $async.Future<$0.DiscoverConfigPathsResponse> discoverConfigPaths_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.DiscoverConfigPathsRequest> $request) async {
    return discoverConfigPaths($call, await $request);
  }

  $async.Future<$0.DiscoverConfigPathsResponse> discoverConfigPaths(
      $grpc.ServiceCall call, $0.DiscoverConfigPathsRequest request);
}
