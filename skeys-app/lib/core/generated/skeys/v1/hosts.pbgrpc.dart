//
//  Generated code. Do not modify.
//  source: skeys/v1/hosts.proto
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
import 'hosts.pb.dart' as $3;

export 'hosts.pb.dart';

@$pb.GrpcServiceName('skeys.v1.HostsService')
class HostsServiceClient extends $grpc.Client {
  static final _$listKnownHosts = $grpc.ClientMethod<$3.ListKnownHostsRequest, $3.ListKnownHostsResponse>(
      '/skeys.v1.HostsService/ListKnownHosts',
      ($3.ListKnownHostsRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $3.ListKnownHostsResponse.fromBuffer(value));
  static final _$getKnownHost = $grpc.ClientMethod<$3.GetKnownHostRequest, $3.GetKnownHostResponse>(
      '/skeys.v1.HostsService/GetKnownHost',
      ($3.GetKnownHostRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $3.GetKnownHostResponse.fromBuffer(value));
  static final _$scanHostKeys = $grpc.ClientMethod<$3.ScanHostKeysRequest, $3.ScanHostKeysResponse>(
      '/skeys.v1.HostsService/ScanHostKeys',
      ($3.ScanHostKeysRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $3.ScanHostKeysResponse.fromBuffer(value));
  static final _$addKnownHost = $grpc.ClientMethod<$3.AddKnownHostRequest, $3.KnownHost>(
      '/skeys.v1.HostsService/AddKnownHost',
      ($3.AddKnownHostRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $3.KnownHost.fromBuffer(value));
  static final _$removeKnownHost = $grpc.ClientMethod<$3.RemoveKnownHostRequest, $1.Empty>(
      '/skeys.v1.HostsService/RemoveKnownHost',
      ($3.RemoveKnownHostRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.Empty.fromBuffer(value));
  static final _$hashKnownHosts = $grpc.ClientMethod<$3.HashKnownHostsRequest, $1.Empty>(
      '/skeys.v1.HostsService/HashKnownHosts',
      ($3.HashKnownHostsRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.Empty.fromBuffer(value));
  static final _$listAuthorizedKeys = $grpc.ClientMethod<$3.ListAuthorizedKeysRequest, $3.ListAuthorizedKeysResponse>(
      '/skeys.v1.HostsService/ListAuthorizedKeys',
      ($3.ListAuthorizedKeysRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $3.ListAuthorizedKeysResponse.fromBuffer(value));
  static final _$addAuthorizedKey = $grpc.ClientMethod<$3.AddAuthorizedKeyRequest, $3.AuthorizedKey>(
      '/skeys.v1.HostsService/AddAuthorizedKey',
      ($3.AddAuthorizedKeyRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $3.AuthorizedKey.fromBuffer(value));
  static final _$updateAuthorizedKey = $grpc.ClientMethod<$3.UpdateAuthorizedKeyRequest, $3.AuthorizedKey>(
      '/skeys.v1.HostsService/UpdateAuthorizedKey',
      ($3.UpdateAuthorizedKeyRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $3.AuthorizedKey.fromBuffer(value));
  static final _$removeAuthorizedKey = $grpc.ClientMethod<$3.RemoveAuthorizedKeyRequest, $1.Empty>(
      '/skeys.v1.HostsService/RemoveAuthorizedKey',
      ($3.RemoveAuthorizedKeyRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.Empty.fromBuffer(value));

  HostsServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$3.ListKnownHostsResponse> listKnownHosts($3.ListKnownHostsRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$listKnownHosts, request, options: options);
  }

  $grpc.ResponseFuture<$3.GetKnownHostResponse> getKnownHost($3.GetKnownHostRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getKnownHost, request, options: options);
  }

  $grpc.ResponseFuture<$3.ScanHostKeysResponse> scanHostKeys($3.ScanHostKeysRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$scanHostKeys, request, options: options);
  }

  $grpc.ResponseFuture<$3.KnownHost> addKnownHost($3.AddKnownHostRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$addKnownHost, request, options: options);
  }

  $grpc.ResponseFuture<$1.Empty> removeKnownHost($3.RemoveKnownHostRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$removeKnownHost, request, options: options);
  }

  $grpc.ResponseFuture<$1.Empty> hashKnownHosts($3.HashKnownHostsRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$hashKnownHosts, request, options: options);
  }

  $grpc.ResponseFuture<$3.ListAuthorizedKeysResponse> listAuthorizedKeys($3.ListAuthorizedKeysRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$listAuthorizedKeys, request, options: options);
  }

  $grpc.ResponseFuture<$3.AuthorizedKey> addAuthorizedKey($3.AddAuthorizedKeyRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$addAuthorizedKey, request, options: options);
  }

  $grpc.ResponseFuture<$3.AuthorizedKey> updateAuthorizedKey($3.UpdateAuthorizedKeyRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$updateAuthorizedKey, request, options: options);
  }

  $grpc.ResponseFuture<$1.Empty> removeAuthorizedKey($3.RemoveAuthorizedKeyRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$removeAuthorizedKey, request, options: options);
  }
}

@$pb.GrpcServiceName('skeys.v1.HostsService')
abstract class HostsServiceBase extends $grpc.Service {
  $core.String get $name => 'skeys.v1.HostsService';

  HostsServiceBase() {
    $addMethod($grpc.ServiceMethod<$3.ListKnownHostsRequest, $3.ListKnownHostsResponse>(
        'ListKnownHosts',
        listKnownHosts_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $3.ListKnownHostsRequest.fromBuffer(value),
        ($3.ListKnownHostsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$3.GetKnownHostRequest, $3.GetKnownHostResponse>(
        'GetKnownHost',
        getKnownHost_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $3.GetKnownHostRequest.fromBuffer(value),
        ($3.GetKnownHostResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$3.ScanHostKeysRequest, $3.ScanHostKeysResponse>(
        'ScanHostKeys',
        scanHostKeys_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $3.ScanHostKeysRequest.fromBuffer(value),
        ($3.ScanHostKeysResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$3.AddKnownHostRequest, $3.KnownHost>(
        'AddKnownHost',
        addKnownHost_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $3.AddKnownHostRequest.fromBuffer(value),
        ($3.KnownHost value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$3.RemoveKnownHostRequest, $1.Empty>(
        'RemoveKnownHost',
        removeKnownHost_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $3.RemoveKnownHostRequest.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$3.HashKnownHostsRequest, $1.Empty>(
        'HashKnownHosts',
        hashKnownHosts_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $3.HashKnownHostsRequest.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$3.ListAuthorizedKeysRequest, $3.ListAuthorizedKeysResponse>(
        'ListAuthorizedKeys',
        listAuthorizedKeys_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $3.ListAuthorizedKeysRequest.fromBuffer(value),
        ($3.ListAuthorizedKeysResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$3.AddAuthorizedKeyRequest, $3.AuthorizedKey>(
        'AddAuthorizedKey',
        addAuthorizedKey_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $3.AddAuthorizedKeyRequest.fromBuffer(value),
        ($3.AuthorizedKey value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$3.UpdateAuthorizedKeyRequest, $3.AuthorizedKey>(
        'UpdateAuthorizedKey',
        updateAuthorizedKey_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $3.UpdateAuthorizedKeyRequest.fromBuffer(value),
        ($3.AuthorizedKey value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$3.RemoveAuthorizedKeyRequest, $1.Empty>(
        'RemoveAuthorizedKey',
        removeAuthorizedKey_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $3.RemoveAuthorizedKeyRequest.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
  }

  $async.Future<$3.ListKnownHostsResponse> listKnownHosts_Pre($grpc.ServiceCall call, $async.Future<$3.ListKnownHostsRequest> request) async {
    return listKnownHosts(call, await request);
  }

  $async.Future<$3.GetKnownHostResponse> getKnownHost_Pre($grpc.ServiceCall call, $async.Future<$3.GetKnownHostRequest> request) async {
    return getKnownHost(call, await request);
  }

  $async.Future<$3.ScanHostKeysResponse> scanHostKeys_Pre($grpc.ServiceCall call, $async.Future<$3.ScanHostKeysRequest> request) async {
    return scanHostKeys(call, await request);
  }

  $async.Future<$3.KnownHost> addKnownHost_Pre($grpc.ServiceCall call, $async.Future<$3.AddKnownHostRequest> request) async {
    return addKnownHost(call, await request);
  }

  $async.Future<$1.Empty> removeKnownHost_Pre($grpc.ServiceCall call, $async.Future<$3.RemoveKnownHostRequest> request) async {
    return removeKnownHost(call, await request);
  }

  $async.Future<$1.Empty> hashKnownHosts_Pre($grpc.ServiceCall call, $async.Future<$3.HashKnownHostsRequest> request) async {
    return hashKnownHosts(call, await request);
  }

  $async.Future<$3.ListAuthorizedKeysResponse> listAuthorizedKeys_Pre($grpc.ServiceCall call, $async.Future<$3.ListAuthorizedKeysRequest> request) async {
    return listAuthorizedKeys(call, await request);
  }

  $async.Future<$3.AuthorizedKey> addAuthorizedKey_Pre($grpc.ServiceCall call, $async.Future<$3.AddAuthorizedKeyRequest> request) async {
    return addAuthorizedKey(call, await request);
  }

  $async.Future<$3.AuthorizedKey> updateAuthorizedKey_Pre($grpc.ServiceCall call, $async.Future<$3.UpdateAuthorizedKeyRequest> request) async {
    return updateAuthorizedKey(call, await request);
  }

  $async.Future<$1.Empty> removeAuthorizedKey_Pre($grpc.ServiceCall call, $async.Future<$3.RemoveAuthorizedKeyRequest> request) async {
    return removeAuthorizedKey(call, await request);
  }

  $async.Future<$3.ListKnownHostsResponse> listKnownHosts($grpc.ServiceCall call, $3.ListKnownHostsRequest request);
  $async.Future<$3.GetKnownHostResponse> getKnownHost($grpc.ServiceCall call, $3.GetKnownHostRequest request);
  $async.Future<$3.ScanHostKeysResponse> scanHostKeys($grpc.ServiceCall call, $3.ScanHostKeysRequest request);
  $async.Future<$3.KnownHost> addKnownHost($grpc.ServiceCall call, $3.AddKnownHostRequest request);
  $async.Future<$1.Empty> removeKnownHost($grpc.ServiceCall call, $3.RemoveKnownHostRequest request);
  $async.Future<$1.Empty> hashKnownHosts($grpc.ServiceCall call, $3.HashKnownHostsRequest request);
  $async.Future<$3.ListAuthorizedKeysResponse> listAuthorizedKeys($grpc.ServiceCall call, $3.ListAuthorizedKeysRequest request);
  $async.Future<$3.AuthorizedKey> addAuthorizedKey($grpc.ServiceCall call, $3.AddAuthorizedKeyRequest request);
  $async.Future<$3.AuthorizedKey> updateAuthorizedKey($grpc.ServiceCall call, $3.UpdateAuthorizedKeyRequest request);
  $async.Future<$1.Empty> removeAuthorizedKey($grpc.ServiceCall call, $3.RemoveAuthorizedKeyRequest request);
}
