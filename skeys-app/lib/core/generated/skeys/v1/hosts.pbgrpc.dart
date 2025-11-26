// This is a generated file - do not edit.
//
// Generated from skeys/v1/hosts.proto.

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
import 'hosts.pb.dart' as $0;

export 'hosts.pb.dart';

@$pb.GrpcServiceName('skeys.v1.HostsService')
class HostsServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  HostsServiceClient(super.channel, {super.options, super.interceptors});

  /// Known Hosts
  $grpc.ResponseFuture<$0.ListKnownHostsResponse> listKnownHosts(
    $0.ListKnownHostsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listKnownHosts, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetKnownHostResponse> getKnownHost(
    $0.GetKnownHostRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getKnownHost, request, options: options);
  }

  $grpc.ResponseFuture<$1.Empty> removeKnownHost(
    $0.RemoveKnownHostRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$removeKnownHost, request, options: options);
  }

  $grpc.ResponseFuture<$1.Empty> hashKnownHosts(
    $0.HashKnownHostsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$hashKnownHosts, request, options: options);
  }

  /// Authorized Keys
  $grpc.ResponseFuture<$0.ListAuthorizedKeysResponse> listAuthorizedKeys(
    $0.ListAuthorizedKeysRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listAuthorizedKeys, request, options: options);
  }

  $grpc.ResponseFuture<$0.AuthorizedKey> addAuthorizedKey(
    $0.AddAuthorizedKeyRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$addAuthorizedKey, request, options: options);
  }

  $grpc.ResponseFuture<$0.AuthorizedKey> updateAuthorizedKey(
    $0.UpdateAuthorizedKeyRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateAuthorizedKey, request, options: options);
  }

  $grpc.ResponseFuture<$1.Empty> removeAuthorizedKey(
    $0.RemoveAuthorizedKeyRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$removeAuthorizedKey, request, options: options);
  }

  // method descriptors

  static final _$listKnownHosts =
      $grpc.ClientMethod<$0.ListKnownHostsRequest, $0.ListKnownHostsResponse>(
          '/skeys.v1.HostsService/ListKnownHosts',
          ($0.ListKnownHostsRequest value) => value.writeToBuffer(),
          $0.ListKnownHostsResponse.fromBuffer);
  static final _$getKnownHost =
      $grpc.ClientMethod<$0.GetKnownHostRequest, $0.GetKnownHostResponse>(
          '/skeys.v1.HostsService/GetKnownHost',
          ($0.GetKnownHostRequest value) => value.writeToBuffer(),
          $0.GetKnownHostResponse.fromBuffer);
  static final _$removeKnownHost =
      $grpc.ClientMethod<$0.RemoveKnownHostRequest, $1.Empty>(
          '/skeys.v1.HostsService/RemoveKnownHost',
          ($0.RemoveKnownHostRequest value) => value.writeToBuffer(),
          $1.Empty.fromBuffer);
  static final _$hashKnownHosts =
      $grpc.ClientMethod<$0.HashKnownHostsRequest, $1.Empty>(
          '/skeys.v1.HostsService/HashKnownHosts',
          ($0.HashKnownHostsRequest value) => value.writeToBuffer(),
          $1.Empty.fromBuffer);
  static final _$listAuthorizedKeys = $grpc.ClientMethod<
          $0.ListAuthorizedKeysRequest, $0.ListAuthorizedKeysResponse>(
      '/skeys.v1.HostsService/ListAuthorizedKeys',
      ($0.ListAuthorizedKeysRequest value) => value.writeToBuffer(),
      $0.ListAuthorizedKeysResponse.fromBuffer);
  static final _$addAuthorizedKey =
      $grpc.ClientMethod<$0.AddAuthorizedKeyRequest, $0.AuthorizedKey>(
          '/skeys.v1.HostsService/AddAuthorizedKey',
          ($0.AddAuthorizedKeyRequest value) => value.writeToBuffer(),
          $0.AuthorizedKey.fromBuffer);
  static final _$updateAuthorizedKey =
      $grpc.ClientMethod<$0.UpdateAuthorizedKeyRequest, $0.AuthorizedKey>(
          '/skeys.v1.HostsService/UpdateAuthorizedKey',
          ($0.UpdateAuthorizedKeyRequest value) => value.writeToBuffer(),
          $0.AuthorizedKey.fromBuffer);
  static final _$removeAuthorizedKey =
      $grpc.ClientMethod<$0.RemoveAuthorizedKeyRequest, $1.Empty>(
          '/skeys.v1.HostsService/RemoveAuthorizedKey',
          ($0.RemoveAuthorizedKeyRequest value) => value.writeToBuffer(),
          $1.Empty.fromBuffer);
}

@$pb.GrpcServiceName('skeys.v1.HostsService')
abstract class HostsServiceBase extends $grpc.Service {
  $core.String get $name => 'skeys.v1.HostsService';

  HostsServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.ListKnownHostsRequest,
            $0.ListKnownHostsResponse>(
        'ListKnownHosts',
        listKnownHosts_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ListKnownHostsRequest.fromBuffer(value),
        ($0.ListKnownHostsResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.GetKnownHostRequest, $0.GetKnownHostResponse>(
            'GetKnownHost',
            getKnownHost_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetKnownHostRequest.fromBuffer(value),
            ($0.GetKnownHostResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RemoveKnownHostRequest, $1.Empty>(
        'RemoveKnownHost',
        removeKnownHost_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.RemoveKnownHostRequest.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.HashKnownHostsRequest, $1.Empty>(
        'HashKnownHosts',
        hashKnownHosts_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.HashKnownHostsRequest.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListAuthorizedKeysRequest,
            $0.ListAuthorizedKeysResponse>(
        'ListAuthorizedKeys',
        listAuthorizedKeys_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ListAuthorizedKeysRequest.fromBuffer(value),
        ($0.ListAuthorizedKeysResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.AddAuthorizedKeyRequest, $0.AuthorizedKey>(
            'AddAuthorizedKey',
            addAuthorizedKey_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.AddAuthorizedKeyRequest.fromBuffer(value),
            ($0.AuthorizedKey value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.UpdateAuthorizedKeyRequest, $0.AuthorizedKey>(
            'UpdateAuthorizedKey',
            updateAuthorizedKey_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.UpdateAuthorizedKeyRequest.fromBuffer(value),
            ($0.AuthorizedKey value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RemoveAuthorizedKeyRequest, $1.Empty>(
        'RemoveAuthorizedKey',
        removeAuthorizedKey_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.RemoveAuthorizedKeyRequest.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
  }

  $async.Future<$0.ListKnownHostsResponse> listKnownHosts_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListKnownHostsRequest> $request) async {
    return listKnownHosts($call, await $request);
  }

  $async.Future<$0.ListKnownHostsResponse> listKnownHosts(
      $grpc.ServiceCall call, $0.ListKnownHostsRequest request);

  $async.Future<$0.GetKnownHostResponse> getKnownHost_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetKnownHostRequest> $request) async {
    return getKnownHost($call, await $request);
  }

  $async.Future<$0.GetKnownHostResponse> getKnownHost(
      $grpc.ServiceCall call, $0.GetKnownHostRequest request);

  $async.Future<$1.Empty> removeKnownHost_Pre($grpc.ServiceCall $call,
      $async.Future<$0.RemoveKnownHostRequest> $request) async {
    return removeKnownHost($call, await $request);
  }

  $async.Future<$1.Empty> removeKnownHost(
      $grpc.ServiceCall call, $0.RemoveKnownHostRequest request);

  $async.Future<$1.Empty> hashKnownHosts_Pre($grpc.ServiceCall $call,
      $async.Future<$0.HashKnownHostsRequest> $request) async {
    return hashKnownHosts($call, await $request);
  }

  $async.Future<$1.Empty> hashKnownHosts(
      $grpc.ServiceCall call, $0.HashKnownHostsRequest request);

  $async.Future<$0.ListAuthorizedKeysResponse> listAuthorizedKeys_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListAuthorizedKeysRequest> $request) async {
    return listAuthorizedKeys($call, await $request);
  }

  $async.Future<$0.ListAuthorizedKeysResponse> listAuthorizedKeys(
      $grpc.ServiceCall call, $0.ListAuthorizedKeysRequest request);

  $async.Future<$0.AuthorizedKey> addAuthorizedKey_Pre($grpc.ServiceCall $call,
      $async.Future<$0.AddAuthorizedKeyRequest> $request) async {
    return addAuthorizedKey($call, await $request);
  }

  $async.Future<$0.AuthorizedKey> addAuthorizedKey(
      $grpc.ServiceCall call, $0.AddAuthorizedKeyRequest request);

  $async.Future<$0.AuthorizedKey> updateAuthorizedKey_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.UpdateAuthorizedKeyRequest> $request) async {
    return updateAuthorizedKey($call, await $request);
  }

  $async.Future<$0.AuthorizedKey> updateAuthorizedKey(
      $grpc.ServiceCall call, $0.UpdateAuthorizedKeyRequest request);

  $async.Future<$1.Empty> removeAuthorizedKey_Pre($grpc.ServiceCall $call,
      $async.Future<$0.RemoveAuthorizedKeyRequest> $request) async {
    return removeAuthorizedKey($call, await $request);
  }

  $async.Future<$1.Empty> removeAuthorizedKey(
      $grpc.ServiceCall call, $0.RemoveAuthorizedKeyRequest request);
}
