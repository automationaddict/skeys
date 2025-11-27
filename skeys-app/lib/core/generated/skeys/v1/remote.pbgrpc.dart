//
//  Generated code. Do not modify.
//  source: skeys/v1/remote.proto
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
import 'remote.pb.dart' as $5;

export 'remote.pb.dart';

@$pb.GrpcServiceName('skeys.v1.RemoteService')
class RemoteServiceClient extends $grpc.Client {
  static final _$listRemotes = $grpc.ClientMethod<$5.ListRemotesRequest, $5.ListRemotesResponse>(
      '/skeys.v1.RemoteService/ListRemotes',
      ($5.ListRemotesRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $5.ListRemotesResponse.fromBuffer(value));
  static final _$getRemote = $grpc.ClientMethod<$5.GetRemoteRequest, $5.Remote>(
      '/skeys.v1.RemoteService/GetRemote',
      ($5.GetRemoteRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $5.Remote.fromBuffer(value));
  static final _$addRemote = $grpc.ClientMethod<$5.AddRemoteRequest, $5.Remote>(
      '/skeys.v1.RemoteService/AddRemote',
      ($5.AddRemoteRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $5.Remote.fromBuffer(value));
  static final _$updateRemote = $grpc.ClientMethod<$5.UpdateRemoteRequest, $5.Remote>(
      '/skeys.v1.RemoteService/UpdateRemote',
      ($5.UpdateRemoteRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $5.Remote.fromBuffer(value));
  static final _$deleteRemote = $grpc.ClientMethod<$5.DeleteRemoteRequest, $1.Empty>(
      '/skeys.v1.RemoteService/DeleteRemote',
      ($5.DeleteRemoteRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.Empty.fromBuffer(value));
  static final _$testConnection = $grpc.ClientMethod<$5.TestRemoteConnectionRequest, $5.TestRemoteConnectionResponse>(
      '/skeys.v1.RemoteService/TestConnection',
      ($5.TestRemoteConnectionRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $5.TestRemoteConnectionResponse.fromBuffer(value));
  static final _$connect = $grpc.ClientMethod<$5.ConnectRequest, $5.ConnectResponse>(
      '/skeys.v1.RemoteService/Connect',
      ($5.ConnectRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $5.ConnectResponse.fromBuffer(value));
  static final _$disconnect = $grpc.ClientMethod<$5.DisconnectRequest, $1.Empty>(
      '/skeys.v1.RemoteService/Disconnect',
      ($5.DisconnectRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.Empty.fromBuffer(value));
  static final _$listConnections = $grpc.ClientMethod<$5.ListConnectionsRequest, $5.ListConnectionsResponse>(
      '/skeys.v1.RemoteService/ListConnections',
      ($5.ListConnectionsRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $5.ListConnectionsResponse.fromBuffer(value));
  static final _$executeCommand = $grpc.ClientMethod<$5.ExecuteCommandRequest, $5.ExecuteCommandResponse>(
      '/skeys.v1.RemoteService/ExecuteCommand',
      ($5.ExecuteCommandRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $5.ExecuteCommandResponse.fromBuffer(value));

  RemoteServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$5.ListRemotesResponse> listRemotes($5.ListRemotesRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$listRemotes, request, options: options);
  }

  $grpc.ResponseFuture<$5.Remote> getRemote($5.GetRemoteRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getRemote, request, options: options);
  }

  $grpc.ResponseFuture<$5.Remote> addRemote($5.AddRemoteRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$addRemote, request, options: options);
  }

  $grpc.ResponseFuture<$5.Remote> updateRemote($5.UpdateRemoteRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$updateRemote, request, options: options);
  }

  $grpc.ResponseFuture<$1.Empty> deleteRemote($5.DeleteRemoteRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$deleteRemote, request, options: options);
  }

  $grpc.ResponseFuture<$5.TestRemoteConnectionResponse> testConnection($5.TestRemoteConnectionRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$testConnection, request, options: options);
  }

  $grpc.ResponseFuture<$5.ConnectResponse> connect($5.ConnectRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$connect, request, options: options);
  }

  $grpc.ResponseFuture<$1.Empty> disconnect($5.DisconnectRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$disconnect, request, options: options);
  }

  $grpc.ResponseFuture<$5.ListConnectionsResponse> listConnections($5.ListConnectionsRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$listConnections, request, options: options);
  }

  $grpc.ResponseFuture<$5.ExecuteCommandResponse> executeCommand($5.ExecuteCommandRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$executeCommand, request, options: options);
  }
}

@$pb.GrpcServiceName('skeys.v1.RemoteService')
abstract class RemoteServiceBase extends $grpc.Service {
  $core.String get $name => 'skeys.v1.RemoteService';

  RemoteServiceBase() {
    $addMethod($grpc.ServiceMethod<$5.ListRemotesRequest, $5.ListRemotesResponse>(
        'ListRemotes',
        listRemotes_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $5.ListRemotesRequest.fromBuffer(value),
        ($5.ListRemotesResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$5.GetRemoteRequest, $5.Remote>(
        'GetRemote',
        getRemote_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $5.GetRemoteRequest.fromBuffer(value),
        ($5.Remote value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$5.AddRemoteRequest, $5.Remote>(
        'AddRemote',
        addRemote_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $5.AddRemoteRequest.fromBuffer(value),
        ($5.Remote value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$5.UpdateRemoteRequest, $5.Remote>(
        'UpdateRemote',
        updateRemote_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $5.UpdateRemoteRequest.fromBuffer(value),
        ($5.Remote value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$5.DeleteRemoteRequest, $1.Empty>(
        'DeleteRemote',
        deleteRemote_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $5.DeleteRemoteRequest.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$5.TestRemoteConnectionRequest, $5.TestRemoteConnectionResponse>(
        'TestConnection',
        testConnection_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $5.TestRemoteConnectionRequest.fromBuffer(value),
        ($5.TestRemoteConnectionResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$5.ConnectRequest, $5.ConnectResponse>(
        'Connect',
        connect_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $5.ConnectRequest.fromBuffer(value),
        ($5.ConnectResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$5.DisconnectRequest, $1.Empty>(
        'Disconnect',
        disconnect_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $5.DisconnectRequest.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$5.ListConnectionsRequest, $5.ListConnectionsResponse>(
        'ListConnections',
        listConnections_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $5.ListConnectionsRequest.fromBuffer(value),
        ($5.ListConnectionsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$5.ExecuteCommandRequest, $5.ExecuteCommandResponse>(
        'ExecuteCommand',
        executeCommand_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $5.ExecuteCommandRequest.fromBuffer(value),
        ($5.ExecuteCommandResponse value) => value.writeToBuffer()));
  }

  $async.Future<$5.ListRemotesResponse> listRemotes_Pre($grpc.ServiceCall call, $async.Future<$5.ListRemotesRequest> request) async {
    return listRemotes(call, await request);
  }

  $async.Future<$5.Remote> getRemote_Pre($grpc.ServiceCall call, $async.Future<$5.GetRemoteRequest> request) async {
    return getRemote(call, await request);
  }

  $async.Future<$5.Remote> addRemote_Pre($grpc.ServiceCall call, $async.Future<$5.AddRemoteRequest> request) async {
    return addRemote(call, await request);
  }

  $async.Future<$5.Remote> updateRemote_Pre($grpc.ServiceCall call, $async.Future<$5.UpdateRemoteRequest> request) async {
    return updateRemote(call, await request);
  }

  $async.Future<$1.Empty> deleteRemote_Pre($grpc.ServiceCall call, $async.Future<$5.DeleteRemoteRequest> request) async {
    return deleteRemote(call, await request);
  }

  $async.Future<$5.TestRemoteConnectionResponse> testConnection_Pre($grpc.ServiceCall call, $async.Future<$5.TestRemoteConnectionRequest> request) async {
    return testConnection(call, await request);
  }

  $async.Future<$5.ConnectResponse> connect_Pre($grpc.ServiceCall call, $async.Future<$5.ConnectRequest> request) async {
    return connect(call, await request);
  }

  $async.Future<$1.Empty> disconnect_Pre($grpc.ServiceCall call, $async.Future<$5.DisconnectRequest> request) async {
    return disconnect(call, await request);
  }

  $async.Future<$5.ListConnectionsResponse> listConnections_Pre($grpc.ServiceCall call, $async.Future<$5.ListConnectionsRequest> request) async {
    return listConnections(call, await request);
  }

  $async.Future<$5.ExecuteCommandResponse> executeCommand_Pre($grpc.ServiceCall call, $async.Future<$5.ExecuteCommandRequest> request) async {
    return executeCommand(call, await request);
  }

  $async.Future<$5.ListRemotesResponse> listRemotes($grpc.ServiceCall call, $5.ListRemotesRequest request);
  $async.Future<$5.Remote> getRemote($grpc.ServiceCall call, $5.GetRemoteRequest request);
  $async.Future<$5.Remote> addRemote($grpc.ServiceCall call, $5.AddRemoteRequest request);
  $async.Future<$5.Remote> updateRemote($grpc.ServiceCall call, $5.UpdateRemoteRequest request);
  $async.Future<$1.Empty> deleteRemote($grpc.ServiceCall call, $5.DeleteRemoteRequest request);
  $async.Future<$5.TestRemoteConnectionResponse> testConnection($grpc.ServiceCall call, $5.TestRemoteConnectionRequest request);
  $async.Future<$5.ConnectResponse> connect($grpc.ServiceCall call, $5.ConnectRequest request);
  $async.Future<$1.Empty> disconnect($grpc.ServiceCall call, $5.DisconnectRequest request);
  $async.Future<$5.ListConnectionsResponse> listConnections($grpc.ServiceCall call, $5.ListConnectionsRequest request);
  $async.Future<$5.ExecuteCommandResponse> executeCommand($grpc.ServiceCall call, $5.ExecuteCommandRequest request);
}
