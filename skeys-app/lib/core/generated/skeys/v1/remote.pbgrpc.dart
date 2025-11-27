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
import 'remote.pb.dart' as $6;

export 'remote.pb.dart';

@$pb.GrpcServiceName('skeys.v1.RemoteService')
class RemoteServiceClient extends $grpc.Client {
  static final _$listRemotes = $grpc.ClientMethod<$6.ListRemotesRequest, $6.ListRemotesResponse>(
      '/skeys.v1.RemoteService/ListRemotes',
      ($6.ListRemotesRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $6.ListRemotesResponse.fromBuffer(value));
  static final _$getRemote = $grpc.ClientMethod<$6.GetRemoteRequest, $6.Remote>(
      '/skeys.v1.RemoteService/GetRemote',
      ($6.GetRemoteRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $6.Remote.fromBuffer(value));
  static final _$addRemote = $grpc.ClientMethod<$6.AddRemoteRequest, $6.Remote>(
      '/skeys.v1.RemoteService/AddRemote',
      ($6.AddRemoteRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $6.Remote.fromBuffer(value));
  static final _$updateRemote = $grpc.ClientMethod<$6.UpdateRemoteRequest, $6.Remote>(
      '/skeys.v1.RemoteService/UpdateRemote',
      ($6.UpdateRemoteRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $6.Remote.fromBuffer(value));
  static final _$deleteRemote = $grpc.ClientMethod<$6.DeleteRemoteRequest, $1.Empty>(
      '/skeys.v1.RemoteService/DeleteRemote',
      ($6.DeleteRemoteRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.Empty.fromBuffer(value));
  static final _$testConnection = $grpc.ClientMethod<$6.TestRemoteConnectionRequest, $6.TestRemoteConnectionResponse>(
      '/skeys.v1.RemoteService/TestConnection',
      ($6.TestRemoteConnectionRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $6.TestRemoteConnectionResponse.fromBuffer(value));
  static final _$connect = $grpc.ClientMethod<$6.ConnectRequest, $6.ConnectResponse>(
      '/skeys.v1.RemoteService/Connect',
      ($6.ConnectRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $6.ConnectResponse.fromBuffer(value));
  static final _$disconnect = $grpc.ClientMethod<$6.DisconnectRequest, $1.Empty>(
      '/skeys.v1.RemoteService/Disconnect',
      ($6.DisconnectRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.Empty.fromBuffer(value));
  static final _$listConnections = $grpc.ClientMethod<$6.ListConnectionsRequest, $6.ListConnectionsResponse>(
      '/skeys.v1.RemoteService/ListConnections',
      ($6.ListConnectionsRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $6.ListConnectionsResponse.fromBuffer(value));
  static final _$executeCommand = $grpc.ClientMethod<$6.ExecuteCommandRequest, $6.ExecuteCommandResponse>(
      '/skeys.v1.RemoteService/ExecuteCommand',
      ($6.ExecuteCommandRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $6.ExecuteCommandResponse.fromBuffer(value));

  RemoteServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$6.ListRemotesResponse> listRemotes($6.ListRemotesRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$listRemotes, request, options: options);
  }

  $grpc.ResponseFuture<$6.Remote> getRemote($6.GetRemoteRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getRemote, request, options: options);
  }

  $grpc.ResponseFuture<$6.Remote> addRemote($6.AddRemoteRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$addRemote, request, options: options);
  }

  $grpc.ResponseFuture<$6.Remote> updateRemote($6.UpdateRemoteRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$updateRemote, request, options: options);
  }

  $grpc.ResponseFuture<$1.Empty> deleteRemote($6.DeleteRemoteRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$deleteRemote, request, options: options);
  }

  $grpc.ResponseFuture<$6.TestRemoteConnectionResponse> testConnection($6.TestRemoteConnectionRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$testConnection, request, options: options);
  }

  $grpc.ResponseFuture<$6.ConnectResponse> connect($6.ConnectRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$connect, request, options: options);
  }

  $grpc.ResponseFuture<$1.Empty> disconnect($6.DisconnectRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$disconnect, request, options: options);
  }

  $grpc.ResponseFuture<$6.ListConnectionsResponse> listConnections($6.ListConnectionsRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$listConnections, request, options: options);
  }

  $grpc.ResponseFuture<$6.ExecuteCommandResponse> executeCommand($6.ExecuteCommandRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$executeCommand, request, options: options);
  }
}

@$pb.GrpcServiceName('skeys.v1.RemoteService')
abstract class RemoteServiceBase extends $grpc.Service {
  $core.String get $name => 'skeys.v1.RemoteService';

  RemoteServiceBase() {
    $addMethod($grpc.ServiceMethod<$6.ListRemotesRequest, $6.ListRemotesResponse>(
        'ListRemotes',
        listRemotes_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $6.ListRemotesRequest.fromBuffer(value),
        ($6.ListRemotesResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$6.GetRemoteRequest, $6.Remote>(
        'GetRemote',
        getRemote_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $6.GetRemoteRequest.fromBuffer(value),
        ($6.Remote value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$6.AddRemoteRequest, $6.Remote>(
        'AddRemote',
        addRemote_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $6.AddRemoteRequest.fromBuffer(value),
        ($6.Remote value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$6.UpdateRemoteRequest, $6.Remote>(
        'UpdateRemote',
        updateRemote_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $6.UpdateRemoteRequest.fromBuffer(value),
        ($6.Remote value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$6.DeleteRemoteRequest, $1.Empty>(
        'DeleteRemote',
        deleteRemote_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $6.DeleteRemoteRequest.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$6.TestRemoteConnectionRequest, $6.TestRemoteConnectionResponse>(
        'TestConnection',
        testConnection_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $6.TestRemoteConnectionRequest.fromBuffer(value),
        ($6.TestRemoteConnectionResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$6.ConnectRequest, $6.ConnectResponse>(
        'Connect',
        connect_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $6.ConnectRequest.fromBuffer(value),
        ($6.ConnectResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$6.DisconnectRequest, $1.Empty>(
        'Disconnect',
        disconnect_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $6.DisconnectRequest.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$6.ListConnectionsRequest, $6.ListConnectionsResponse>(
        'ListConnections',
        listConnections_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $6.ListConnectionsRequest.fromBuffer(value),
        ($6.ListConnectionsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$6.ExecuteCommandRequest, $6.ExecuteCommandResponse>(
        'ExecuteCommand',
        executeCommand_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $6.ExecuteCommandRequest.fromBuffer(value),
        ($6.ExecuteCommandResponse value) => value.writeToBuffer()));
  }

  $async.Future<$6.ListRemotesResponse> listRemotes_Pre($grpc.ServiceCall call, $async.Future<$6.ListRemotesRequest> request) async {
    return listRemotes(call, await request);
  }

  $async.Future<$6.Remote> getRemote_Pre($grpc.ServiceCall call, $async.Future<$6.GetRemoteRequest> request) async {
    return getRemote(call, await request);
  }

  $async.Future<$6.Remote> addRemote_Pre($grpc.ServiceCall call, $async.Future<$6.AddRemoteRequest> request) async {
    return addRemote(call, await request);
  }

  $async.Future<$6.Remote> updateRemote_Pre($grpc.ServiceCall call, $async.Future<$6.UpdateRemoteRequest> request) async {
    return updateRemote(call, await request);
  }

  $async.Future<$1.Empty> deleteRemote_Pre($grpc.ServiceCall call, $async.Future<$6.DeleteRemoteRequest> request) async {
    return deleteRemote(call, await request);
  }

  $async.Future<$6.TestRemoteConnectionResponse> testConnection_Pre($grpc.ServiceCall call, $async.Future<$6.TestRemoteConnectionRequest> request) async {
    return testConnection(call, await request);
  }

  $async.Future<$6.ConnectResponse> connect_Pre($grpc.ServiceCall call, $async.Future<$6.ConnectRequest> request) async {
    return connect(call, await request);
  }

  $async.Future<$1.Empty> disconnect_Pre($grpc.ServiceCall call, $async.Future<$6.DisconnectRequest> request) async {
    return disconnect(call, await request);
  }

  $async.Future<$6.ListConnectionsResponse> listConnections_Pre($grpc.ServiceCall call, $async.Future<$6.ListConnectionsRequest> request) async {
    return listConnections(call, await request);
  }

  $async.Future<$6.ExecuteCommandResponse> executeCommand_Pre($grpc.ServiceCall call, $async.Future<$6.ExecuteCommandRequest> request) async {
    return executeCommand(call, await request);
  }

  $async.Future<$6.ListRemotesResponse> listRemotes($grpc.ServiceCall call, $6.ListRemotesRequest request);
  $async.Future<$6.Remote> getRemote($grpc.ServiceCall call, $6.GetRemoteRequest request);
  $async.Future<$6.Remote> addRemote($grpc.ServiceCall call, $6.AddRemoteRequest request);
  $async.Future<$6.Remote> updateRemote($grpc.ServiceCall call, $6.UpdateRemoteRequest request);
  $async.Future<$1.Empty> deleteRemote($grpc.ServiceCall call, $6.DeleteRemoteRequest request);
  $async.Future<$6.TestRemoteConnectionResponse> testConnection($grpc.ServiceCall call, $6.TestRemoteConnectionRequest request);
  $async.Future<$6.ConnectResponse> connect($grpc.ServiceCall call, $6.ConnectRequest request);
  $async.Future<$1.Empty> disconnect($grpc.ServiceCall call, $6.DisconnectRequest request);
  $async.Future<$6.ListConnectionsResponse> listConnections($grpc.ServiceCall call, $6.ListConnectionsRequest request);
  $async.Future<$6.ExecuteCommandResponse> executeCommand($grpc.ServiceCall call, $6.ExecuteCommandRequest request);
}
