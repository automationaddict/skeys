//
//  Generated code. Do not modify.
//  source: skeys/v1/agent.proto
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
import 'agent.pb.dart' as $0;

export 'agent.pb.dart';

@$pb.GrpcServiceName('skeys.v1.AgentService')
class AgentServiceClient extends $grpc.Client {
  static final _$getAgentStatus = $grpc.ClientMethod<$0.GetAgentStatusRequest, $0.GetAgentStatusResponse>(
      '/skeys.v1.AgentService/GetAgentStatus',
      ($0.GetAgentStatusRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.GetAgentStatusResponse.fromBuffer(value));
  static final _$listAgentKeys = $grpc.ClientMethod<$0.ListAgentKeysRequest, $0.ListAgentKeysResponse>(
      '/skeys.v1.AgentService/ListAgentKeys',
      ($0.ListAgentKeysRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.ListAgentKeysResponse.fromBuffer(value));
  static final _$addKeyToAgent = $grpc.ClientMethod<$0.AddKeyToAgentRequest, $1.Empty>(
      '/skeys.v1.AgentService/AddKeyToAgent',
      ($0.AddKeyToAgentRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.Empty.fromBuffer(value));
  static final _$removeKeyFromAgent = $grpc.ClientMethod<$0.RemoveKeyFromAgentRequest, $1.Empty>(
      '/skeys.v1.AgentService/RemoveKeyFromAgent',
      ($0.RemoveKeyFromAgentRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.Empty.fromBuffer(value));
  static final _$removeAllKeysFromAgent = $grpc.ClientMethod<$0.RemoveAllKeysFromAgentRequest, $1.Empty>(
      '/skeys.v1.AgentService/RemoveAllKeysFromAgent',
      ($0.RemoveAllKeysFromAgentRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.Empty.fromBuffer(value));
  static final _$lockAgent = $grpc.ClientMethod<$0.LockAgentRequest, $1.Empty>(
      '/skeys.v1.AgentService/LockAgent',
      ($0.LockAgentRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.Empty.fromBuffer(value));
  static final _$unlockAgent = $grpc.ClientMethod<$0.UnlockAgentRequest, $1.Empty>(
      '/skeys.v1.AgentService/UnlockAgent',
      ($0.UnlockAgentRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.Empty.fromBuffer(value));

  AgentServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$0.GetAgentStatusResponse> getAgentStatus($0.GetAgentStatusRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getAgentStatus, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListAgentKeysResponse> listAgentKeys($0.ListAgentKeysRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$listAgentKeys, request, options: options);
  }

  $grpc.ResponseFuture<$1.Empty> addKeyToAgent($0.AddKeyToAgentRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$addKeyToAgent, request, options: options);
  }

  $grpc.ResponseFuture<$1.Empty> removeKeyFromAgent($0.RemoveKeyFromAgentRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$removeKeyFromAgent, request, options: options);
  }

  $grpc.ResponseFuture<$1.Empty> removeAllKeysFromAgent($0.RemoveAllKeysFromAgentRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$removeAllKeysFromAgent, request, options: options);
  }

  $grpc.ResponseFuture<$1.Empty> lockAgent($0.LockAgentRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$lockAgent, request, options: options);
  }

  $grpc.ResponseFuture<$1.Empty> unlockAgent($0.UnlockAgentRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$unlockAgent, request, options: options);
  }
}

@$pb.GrpcServiceName('skeys.v1.AgentService')
abstract class AgentServiceBase extends $grpc.Service {
  $core.String get $name => 'skeys.v1.AgentService';

  AgentServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.GetAgentStatusRequest, $0.GetAgentStatusResponse>(
        'GetAgentStatus',
        getAgentStatus_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetAgentStatusRequest.fromBuffer(value),
        ($0.GetAgentStatusResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListAgentKeysRequest, $0.ListAgentKeysResponse>(
        'ListAgentKeys',
        listAgentKeys_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ListAgentKeysRequest.fromBuffer(value),
        ($0.ListAgentKeysResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.AddKeyToAgentRequest, $1.Empty>(
        'AddKeyToAgent',
        addKeyToAgent_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.AddKeyToAgentRequest.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RemoveKeyFromAgentRequest, $1.Empty>(
        'RemoveKeyFromAgent',
        removeKeyFromAgent_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.RemoveKeyFromAgentRequest.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RemoveAllKeysFromAgentRequest, $1.Empty>(
        'RemoveAllKeysFromAgent',
        removeAllKeysFromAgent_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.RemoveAllKeysFromAgentRequest.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.LockAgentRequest, $1.Empty>(
        'LockAgent',
        lockAgent_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.LockAgentRequest.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UnlockAgentRequest, $1.Empty>(
        'UnlockAgent',
        unlockAgent_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.UnlockAgentRequest.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
  }

  $async.Future<$0.GetAgentStatusResponse> getAgentStatus_Pre($grpc.ServiceCall call, $async.Future<$0.GetAgentStatusRequest> request) async {
    return getAgentStatus(call, await request);
  }

  $async.Future<$0.ListAgentKeysResponse> listAgentKeys_Pre($grpc.ServiceCall call, $async.Future<$0.ListAgentKeysRequest> request) async {
    return listAgentKeys(call, await request);
  }

  $async.Future<$1.Empty> addKeyToAgent_Pre($grpc.ServiceCall call, $async.Future<$0.AddKeyToAgentRequest> request) async {
    return addKeyToAgent(call, await request);
  }

  $async.Future<$1.Empty> removeKeyFromAgent_Pre($grpc.ServiceCall call, $async.Future<$0.RemoveKeyFromAgentRequest> request) async {
    return removeKeyFromAgent(call, await request);
  }

  $async.Future<$1.Empty> removeAllKeysFromAgent_Pre($grpc.ServiceCall call, $async.Future<$0.RemoveAllKeysFromAgentRequest> request) async {
    return removeAllKeysFromAgent(call, await request);
  }

  $async.Future<$1.Empty> lockAgent_Pre($grpc.ServiceCall call, $async.Future<$0.LockAgentRequest> request) async {
    return lockAgent(call, await request);
  }

  $async.Future<$1.Empty> unlockAgent_Pre($grpc.ServiceCall call, $async.Future<$0.UnlockAgentRequest> request) async {
    return unlockAgent(call, await request);
  }

  $async.Future<$0.GetAgentStatusResponse> getAgentStatus($grpc.ServiceCall call, $0.GetAgentStatusRequest request);
  $async.Future<$0.ListAgentKeysResponse> listAgentKeys($grpc.ServiceCall call, $0.ListAgentKeysRequest request);
  $async.Future<$1.Empty> addKeyToAgent($grpc.ServiceCall call, $0.AddKeyToAgentRequest request);
  $async.Future<$1.Empty> removeKeyFromAgent($grpc.ServiceCall call, $0.RemoveKeyFromAgentRequest request);
  $async.Future<$1.Empty> removeAllKeysFromAgent($grpc.ServiceCall call, $0.RemoveAllKeysFromAgentRequest request);
  $async.Future<$1.Empty> lockAgent($grpc.ServiceCall call, $0.LockAgentRequest request);
  $async.Future<$1.Empty> unlockAgent($grpc.ServiceCall call, $0.UnlockAgentRequest request);
}
