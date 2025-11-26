// This is a generated file - do not edit.
//
// Generated from skeys/v1/keys.proto.

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
import 'keys.pb.dart' as $0;

export 'keys.pb.dart';

@$pb.GrpcServiceName('skeys.v1.KeyService')
class KeyServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  KeyServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.ListKeysResponse> listKeys(
    $0.ListKeysRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listKeys, request, options: options);
  }

  $grpc.ResponseFuture<$0.SSHKey> getKey(
    $0.GetKeyRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getKey, request, options: options);
  }

  $grpc.ResponseFuture<$0.SSHKey> generateKey(
    $0.GenerateKeyRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$generateKey, request, options: options);
  }

  $grpc.ResponseFuture<$1.Empty> deleteKey(
    $0.DeleteKeyRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$deleteKey, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetFingerprintResponse> getFingerprint(
    $0.GetFingerprintRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getFingerprint, request, options: options);
  }

  $grpc.ResponseFuture<$1.Empty> changePassphrase(
    $0.ChangePassphraseRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$changePassphrase, request, options: options);
  }

  $grpc.ResponseFuture<$0.PushKeyToRemoteResponse> pushKeyToRemote(
    $0.PushKeyToRemoteRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$pushKeyToRemote, request, options: options);
  }

  // method descriptors

  static final _$listKeys =
      $grpc.ClientMethod<$0.ListKeysRequest, $0.ListKeysResponse>(
          '/skeys.v1.KeyService/ListKeys',
          ($0.ListKeysRequest value) => value.writeToBuffer(),
          $0.ListKeysResponse.fromBuffer);
  static final _$getKey = $grpc.ClientMethod<$0.GetKeyRequest, $0.SSHKey>(
      '/skeys.v1.KeyService/GetKey',
      ($0.GetKeyRequest value) => value.writeToBuffer(),
      $0.SSHKey.fromBuffer);
  static final _$generateKey =
      $grpc.ClientMethod<$0.GenerateKeyRequest, $0.SSHKey>(
          '/skeys.v1.KeyService/GenerateKey',
          ($0.GenerateKeyRequest value) => value.writeToBuffer(),
          $0.SSHKey.fromBuffer);
  static final _$deleteKey = $grpc.ClientMethod<$0.DeleteKeyRequest, $1.Empty>(
      '/skeys.v1.KeyService/DeleteKey',
      ($0.DeleteKeyRequest value) => value.writeToBuffer(),
      $1.Empty.fromBuffer);
  static final _$getFingerprint =
      $grpc.ClientMethod<$0.GetFingerprintRequest, $0.GetFingerprintResponse>(
          '/skeys.v1.KeyService/GetFingerprint',
          ($0.GetFingerprintRequest value) => value.writeToBuffer(),
          $0.GetFingerprintResponse.fromBuffer);
  static final _$changePassphrase =
      $grpc.ClientMethod<$0.ChangePassphraseRequest, $1.Empty>(
          '/skeys.v1.KeyService/ChangePassphrase',
          ($0.ChangePassphraseRequest value) => value.writeToBuffer(),
          $1.Empty.fromBuffer);
  static final _$pushKeyToRemote =
      $grpc.ClientMethod<$0.PushKeyToRemoteRequest, $0.PushKeyToRemoteResponse>(
          '/skeys.v1.KeyService/PushKeyToRemote',
          ($0.PushKeyToRemoteRequest value) => value.writeToBuffer(),
          $0.PushKeyToRemoteResponse.fromBuffer);
}

@$pb.GrpcServiceName('skeys.v1.KeyService')
abstract class KeyServiceBase extends $grpc.Service {
  $core.String get $name => 'skeys.v1.KeyService';

  KeyServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.ListKeysRequest, $0.ListKeysResponse>(
        'ListKeys',
        listKeys_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ListKeysRequest.fromBuffer(value),
        ($0.ListKeysResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetKeyRequest, $0.SSHKey>(
        'GetKey',
        getKey_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetKeyRequest.fromBuffer(value),
        ($0.SSHKey value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GenerateKeyRequest, $0.SSHKey>(
        'GenerateKey',
        generateKey_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GenerateKeyRequest.fromBuffer(value),
        ($0.SSHKey value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DeleteKeyRequest, $1.Empty>(
        'DeleteKey',
        deleteKey_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.DeleteKeyRequest.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetFingerprintRequest,
            $0.GetFingerprintResponse>(
        'GetFingerprint',
        getFingerprint_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetFingerprintRequest.fromBuffer(value),
        ($0.GetFingerprintResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ChangePassphraseRequest, $1.Empty>(
        'ChangePassphrase',
        changePassphrase_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ChangePassphraseRequest.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.PushKeyToRemoteRequest,
            $0.PushKeyToRemoteResponse>(
        'PushKeyToRemote',
        pushKeyToRemote_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.PushKeyToRemoteRequest.fromBuffer(value),
        ($0.PushKeyToRemoteResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.ListKeysResponse> listKeys_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ListKeysRequest> $request) async {
    return listKeys($call, await $request);
  }

  $async.Future<$0.ListKeysResponse> listKeys(
      $grpc.ServiceCall call, $0.ListKeysRequest request);

  $async.Future<$0.SSHKey> getKey_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.GetKeyRequest> $request) async {
    return getKey($call, await $request);
  }

  $async.Future<$0.SSHKey> getKey(
      $grpc.ServiceCall call, $0.GetKeyRequest request);

  $async.Future<$0.SSHKey> generateKey_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GenerateKeyRequest> $request) async {
    return generateKey($call, await $request);
  }

  $async.Future<$0.SSHKey> generateKey(
      $grpc.ServiceCall call, $0.GenerateKeyRequest request);

  $async.Future<$1.Empty> deleteKey_Pre($grpc.ServiceCall $call,
      $async.Future<$0.DeleteKeyRequest> $request) async {
    return deleteKey($call, await $request);
  }

  $async.Future<$1.Empty> deleteKey(
      $grpc.ServiceCall call, $0.DeleteKeyRequest request);

  $async.Future<$0.GetFingerprintResponse> getFingerprint_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetFingerprintRequest> $request) async {
    return getFingerprint($call, await $request);
  }

  $async.Future<$0.GetFingerprintResponse> getFingerprint(
      $grpc.ServiceCall call, $0.GetFingerprintRequest request);

  $async.Future<$1.Empty> changePassphrase_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ChangePassphraseRequest> $request) async {
    return changePassphrase($call, await $request);
  }

  $async.Future<$1.Empty> changePassphrase(
      $grpc.ServiceCall call, $0.ChangePassphraseRequest request);

  $async.Future<$0.PushKeyToRemoteResponse> pushKeyToRemote_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.PushKeyToRemoteRequest> $request) async {
    return pushKeyToRemote($call, await $request);
  }

  $async.Future<$0.PushKeyToRemoteResponse> pushKeyToRemote(
      $grpc.ServiceCall call, $0.PushKeyToRemoteRequest request);
}
