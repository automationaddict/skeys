// This is a generated file - do not edit.
//
// Generated from skeys/v1/remote.proto.

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

import 'remote.pb.dart' as $0;

export 'remote.pb.dart';

@$pb.GrpcServiceName('skeys.v1.RemoteService')
class RemoteServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  RemoteServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.ListRemotesResponse> listRemotes(
    $0.ListRemotesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listRemotes, request, options: options);
  }

  $grpc.ResponseFuture<$0.Remote> getRemote(
    $0.GetRemoteRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getRemote, request, options: options);
  }

  $grpc.ResponseFuture<$0.Remote> addRemote(
    $0.AddRemoteRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$addRemote, request, options: options);
  }

  $grpc.ResponseFuture<$0.Remote> updateRemote(
    $0.UpdateRemoteRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateRemote, request, options: options);
  }

  $grpc.ResponseFuture<$1.Empty> deleteRemote(
    $0.DeleteRemoteRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$deleteRemote, request, options: options);
  }

  $grpc.ResponseFuture<$0.TestRemoteConnectionResponse> testConnection(
    $0.TestRemoteConnectionRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$testConnection, request, options: options);
  }

  $grpc.ResponseFuture<$0.ConnectResponse> connect(
    $0.ConnectRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$connect, request, options: options);
  }

  $grpc.ResponseFuture<$1.Empty> disconnect(
    $0.DisconnectRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$disconnect, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListConnectionsResponse> listConnections(
    $0.ListConnectionsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listConnections, request, options: options);
  }

  $grpc.ResponseFuture<$0.ExecuteCommandResponse> executeCommand(
    $0.ExecuteCommandRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$executeCommand, request, options: options);
  }

  // method descriptors

  static final _$listRemotes =
      $grpc.ClientMethod<$0.ListRemotesRequest, $0.ListRemotesResponse>(
          '/skeys.v1.RemoteService/ListRemotes',
          ($0.ListRemotesRequest value) => value.writeToBuffer(),
          $0.ListRemotesResponse.fromBuffer);
  static final _$getRemote = $grpc.ClientMethod<$0.GetRemoteRequest, $0.Remote>(
      '/skeys.v1.RemoteService/GetRemote',
      ($0.GetRemoteRequest value) => value.writeToBuffer(),
      $0.Remote.fromBuffer);
  static final _$addRemote = $grpc.ClientMethod<$0.AddRemoteRequest, $0.Remote>(
      '/skeys.v1.RemoteService/AddRemote',
      ($0.AddRemoteRequest value) => value.writeToBuffer(),
      $0.Remote.fromBuffer);
  static final _$updateRemote =
      $grpc.ClientMethod<$0.UpdateRemoteRequest, $0.Remote>(
          '/skeys.v1.RemoteService/UpdateRemote',
          ($0.UpdateRemoteRequest value) => value.writeToBuffer(),
          $0.Remote.fromBuffer);
  static final _$deleteRemote =
      $grpc.ClientMethod<$0.DeleteRemoteRequest, $1.Empty>(
          '/skeys.v1.RemoteService/DeleteRemote',
          ($0.DeleteRemoteRequest value) => value.writeToBuffer(),
          $1.Empty.fromBuffer);
  static final _$testConnection = $grpc.ClientMethod<
          $0.TestRemoteConnectionRequest, $0.TestRemoteConnectionResponse>(
      '/skeys.v1.RemoteService/TestConnection',
      ($0.TestRemoteConnectionRequest value) => value.writeToBuffer(),
      $0.TestRemoteConnectionResponse.fromBuffer);
  static final _$connect =
      $grpc.ClientMethod<$0.ConnectRequest, $0.ConnectResponse>(
          '/skeys.v1.RemoteService/Connect',
          ($0.ConnectRequest value) => value.writeToBuffer(),
          $0.ConnectResponse.fromBuffer);
  static final _$disconnect =
      $grpc.ClientMethod<$0.DisconnectRequest, $1.Empty>(
          '/skeys.v1.RemoteService/Disconnect',
          ($0.DisconnectRequest value) => value.writeToBuffer(),
          $1.Empty.fromBuffer);
  static final _$listConnections =
      $grpc.ClientMethod<$0.ListConnectionsRequest, $0.ListConnectionsResponse>(
          '/skeys.v1.RemoteService/ListConnections',
          ($0.ListConnectionsRequest value) => value.writeToBuffer(),
          $0.ListConnectionsResponse.fromBuffer);
  static final _$executeCommand =
      $grpc.ClientMethod<$0.ExecuteCommandRequest, $0.ExecuteCommandResponse>(
          '/skeys.v1.RemoteService/ExecuteCommand',
          ($0.ExecuteCommandRequest value) => value.writeToBuffer(),
          $0.ExecuteCommandResponse.fromBuffer);
}

@$pb.GrpcServiceName('skeys.v1.RemoteService')
abstract class RemoteServiceBase extends $grpc.Service {
  $core.String get $name => 'skeys.v1.RemoteService';

  RemoteServiceBase() {
    $addMethod(
        $grpc.ServiceMethod<$0.ListRemotesRequest, $0.ListRemotesResponse>(
            'ListRemotes',
            listRemotes_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ListRemotesRequest.fromBuffer(value),
            ($0.ListRemotesResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetRemoteRequest, $0.Remote>(
        'GetRemote',
        getRemote_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetRemoteRequest.fromBuffer(value),
        ($0.Remote value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.AddRemoteRequest, $0.Remote>(
        'AddRemote',
        addRemote_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.AddRemoteRequest.fromBuffer(value),
        ($0.Remote value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UpdateRemoteRequest, $0.Remote>(
        'UpdateRemote',
        updateRemote_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.UpdateRemoteRequest.fromBuffer(value),
        ($0.Remote value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DeleteRemoteRequest, $1.Empty>(
        'DeleteRemote',
        deleteRemote_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.DeleteRemoteRequest.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.TestRemoteConnectionRequest,
            $0.TestRemoteConnectionResponse>(
        'TestConnection',
        testConnection_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.TestRemoteConnectionRequest.fromBuffer(value),
        ($0.TestRemoteConnectionResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ConnectRequest, $0.ConnectResponse>(
        'Connect',
        connect_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ConnectRequest.fromBuffer(value),
        ($0.ConnectResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DisconnectRequest, $1.Empty>(
        'Disconnect',
        disconnect_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.DisconnectRequest.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListConnectionsRequest,
            $0.ListConnectionsResponse>(
        'ListConnections',
        listConnections_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ListConnectionsRequest.fromBuffer(value),
        ($0.ListConnectionsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ExecuteCommandRequest,
            $0.ExecuteCommandResponse>(
        'ExecuteCommand',
        executeCommand_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ExecuteCommandRequest.fromBuffer(value),
        ($0.ExecuteCommandResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.ListRemotesResponse> listRemotes_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ListRemotesRequest> $request) async {
    return listRemotes($call, await $request);
  }

  $async.Future<$0.ListRemotesResponse> listRemotes(
      $grpc.ServiceCall call, $0.ListRemotesRequest request);

  $async.Future<$0.Remote> getRemote_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetRemoteRequest> $request) async {
    return getRemote($call, await $request);
  }

  $async.Future<$0.Remote> getRemote(
      $grpc.ServiceCall call, $0.GetRemoteRequest request);

  $async.Future<$0.Remote> addRemote_Pre($grpc.ServiceCall $call,
      $async.Future<$0.AddRemoteRequest> $request) async {
    return addRemote($call, await $request);
  }

  $async.Future<$0.Remote> addRemote(
      $grpc.ServiceCall call, $0.AddRemoteRequest request);

  $async.Future<$0.Remote> updateRemote_Pre($grpc.ServiceCall $call,
      $async.Future<$0.UpdateRemoteRequest> $request) async {
    return updateRemote($call, await $request);
  }

  $async.Future<$0.Remote> updateRemote(
      $grpc.ServiceCall call, $0.UpdateRemoteRequest request);

  $async.Future<$1.Empty> deleteRemote_Pre($grpc.ServiceCall $call,
      $async.Future<$0.DeleteRemoteRequest> $request) async {
    return deleteRemote($call, await $request);
  }

  $async.Future<$1.Empty> deleteRemote(
      $grpc.ServiceCall call, $0.DeleteRemoteRequest request);

  $async.Future<$0.TestRemoteConnectionResponse> testConnection_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.TestRemoteConnectionRequest> $request) async {
    return testConnection($call, await $request);
  }

  $async.Future<$0.TestRemoteConnectionResponse> testConnection(
      $grpc.ServiceCall call, $0.TestRemoteConnectionRequest request);

  $async.Future<$0.ConnectResponse> connect_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ConnectRequest> $request) async {
    return connect($call, await $request);
  }

  $async.Future<$0.ConnectResponse> connect(
      $grpc.ServiceCall call, $0.ConnectRequest request);

  $async.Future<$1.Empty> disconnect_Pre($grpc.ServiceCall $call,
      $async.Future<$0.DisconnectRequest> $request) async {
    return disconnect($call, await $request);
  }

  $async.Future<$1.Empty> disconnect(
      $grpc.ServiceCall call, $0.DisconnectRequest request);

  $async.Future<$0.ListConnectionsResponse> listConnections_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListConnectionsRequest> $request) async {
    return listConnections($call, await $request);
  }

  $async.Future<$0.ListConnectionsResponse> listConnections(
      $grpc.ServiceCall call, $0.ListConnectionsRequest request);

  $async.Future<$0.ExecuteCommandResponse> executeCommand_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ExecuteCommandRequest> $request) async {
    return executeCommand($call, await $request);
  }

  $async.Future<$0.ExecuteCommandResponse> executeCommand(
      $grpc.ServiceCall call, $0.ExecuteCommandRequest request);
}
