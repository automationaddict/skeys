//
//  Generated code. Do not modify.
//  source: skeys/v1/keys.proto
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
import 'keys.pb.dart' as $4;

export 'keys.pb.dart';

@$pb.GrpcServiceName('skeys.v1.KeyService')
class KeyServiceClient extends $grpc.Client {
  static final _$listKeys = $grpc.ClientMethod<$4.ListKeysRequest, $4.ListKeysResponse>(
      '/skeys.v1.KeyService/ListKeys',
      ($4.ListKeysRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $4.ListKeysResponse.fromBuffer(value));
  static final _$getKey = $grpc.ClientMethod<$4.GetKeyRequest, $4.SSHKey>(
      '/skeys.v1.KeyService/GetKey',
      ($4.GetKeyRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $4.SSHKey.fromBuffer(value));
  static final _$generateKey = $grpc.ClientMethod<$4.GenerateKeyRequest, $4.SSHKey>(
      '/skeys.v1.KeyService/GenerateKey',
      ($4.GenerateKeyRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $4.SSHKey.fromBuffer(value));
  static final _$deleteKey = $grpc.ClientMethod<$4.DeleteKeyRequest, $1.Empty>(
      '/skeys.v1.KeyService/DeleteKey',
      ($4.DeleteKeyRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.Empty.fromBuffer(value));
  static final _$getFingerprint = $grpc.ClientMethod<$4.GetFingerprintRequest, $4.GetFingerprintResponse>(
      '/skeys.v1.KeyService/GetFingerprint',
      ($4.GetFingerprintRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $4.GetFingerprintResponse.fromBuffer(value));
  static final _$changePassphrase = $grpc.ClientMethod<$4.ChangePassphraseRequest, $1.Empty>(
      '/skeys.v1.KeyService/ChangePassphrase',
      ($4.ChangePassphraseRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.Empty.fromBuffer(value));
  static final _$pushKeyToRemote = $grpc.ClientMethod<$4.PushKeyToRemoteRequest, $4.PushKeyToRemoteResponse>(
      '/skeys.v1.KeyService/PushKeyToRemote',
      ($4.PushKeyToRemoteRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $4.PushKeyToRemoteResponse.fromBuffer(value));
  static final _$watchKeys = $grpc.ClientMethod<$4.WatchKeysRequest, $4.ListKeysResponse>(
      '/skeys.v1.KeyService/WatchKeys',
      ($4.WatchKeysRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $4.ListKeysResponse.fromBuffer(value));

  KeyServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$4.ListKeysResponse> listKeys($4.ListKeysRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$listKeys, request, options: options);
  }

  $grpc.ResponseFuture<$4.SSHKey> getKey($4.GetKeyRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getKey, request, options: options);
  }

  $grpc.ResponseFuture<$4.SSHKey> generateKey($4.GenerateKeyRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$generateKey, request, options: options);
  }

  $grpc.ResponseFuture<$1.Empty> deleteKey($4.DeleteKeyRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$deleteKey, request, options: options);
  }

  $grpc.ResponseFuture<$4.GetFingerprintResponse> getFingerprint($4.GetFingerprintRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getFingerprint, request, options: options);
  }

  $grpc.ResponseFuture<$1.Empty> changePassphrase($4.ChangePassphraseRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$changePassphrase, request, options: options);
  }

  $grpc.ResponseFuture<$4.PushKeyToRemoteResponse> pushKeyToRemote($4.PushKeyToRemoteRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$pushKeyToRemote, request, options: options);
  }

  $grpc.ResponseStream<$4.ListKeysResponse> watchKeys($4.WatchKeysRequest request, {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$watchKeys, $async.Stream.fromIterable([request]), options: options);
  }
}

@$pb.GrpcServiceName('skeys.v1.KeyService')
abstract class KeyServiceBase extends $grpc.Service {
  $core.String get $name => 'skeys.v1.KeyService';

  KeyServiceBase() {
    $addMethod($grpc.ServiceMethod<$4.ListKeysRequest, $4.ListKeysResponse>(
        'ListKeys',
        listKeys_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $4.ListKeysRequest.fromBuffer(value),
        ($4.ListKeysResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$4.GetKeyRequest, $4.SSHKey>(
        'GetKey',
        getKey_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $4.GetKeyRequest.fromBuffer(value),
        ($4.SSHKey value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$4.GenerateKeyRequest, $4.SSHKey>(
        'GenerateKey',
        generateKey_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $4.GenerateKeyRequest.fromBuffer(value),
        ($4.SSHKey value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$4.DeleteKeyRequest, $1.Empty>(
        'DeleteKey',
        deleteKey_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $4.DeleteKeyRequest.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$4.GetFingerprintRequest, $4.GetFingerprintResponse>(
        'GetFingerprint',
        getFingerprint_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $4.GetFingerprintRequest.fromBuffer(value),
        ($4.GetFingerprintResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$4.ChangePassphraseRequest, $1.Empty>(
        'ChangePassphrase',
        changePassphrase_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $4.ChangePassphraseRequest.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$4.PushKeyToRemoteRequest, $4.PushKeyToRemoteResponse>(
        'PushKeyToRemote',
        pushKeyToRemote_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $4.PushKeyToRemoteRequest.fromBuffer(value),
        ($4.PushKeyToRemoteResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$4.WatchKeysRequest, $4.ListKeysResponse>(
        'WatchKeys',
        watchKeys_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $4.WatchKeysRequest.fromBuffer(value),
        ($4.ListKeysResponse value) => value.writeToBuffer()));
  }

  $async.Future<$4.ListKeysResponse> listKeys_Pre($grpc.ServiceCall call, $async.Future<$4.ListKeysRequest> request) async {
    return listKeys(call, await request);
  }

  $async.Future<$4.SSHKey> getKey_Pre($grpc.ServiceCall call, $async.Future<$4.GetKeyRequest> request) async {
    return getKey(call, await request);
  }

  $async.Future<$4.SSHKey> generateKey_Pre($grpc.ServiceCall call, $async.Future<$4.GenerateKeyRequest> request) async {
    return generateKey(call, await request);
  }

  $async.Future<$1.Empty> deleteKey_Pre($grpc.ServiceCall call, $async.Future<$4.DeleteKeyRequest> request) async {
    return deleteKey(call, await request);
  }

  $async.Future<$4.GetFingerprintResponse> getFingerprint_Pre($grpc.ServiceCall call, $async.Future<$4.GetFingerprintRequest> request) async {
    return getFingerprint(call, await request);
  }

  $async.Future<$1.Empty> changePassphrase_Pre($grpc.ServiceCall call, $async.Future<$4.ChangePassphraseRequest> request) async {
    return changePassphrase(call, await request);
  }

  $async.Future<$4.PushKeyToRemoteResponse> pushKeyToRemote_Pre($grpc.ServiceCall call, $async.Future<$4.PushKeyToRemoteRequest> request) async {
    return pushKeyToRemote(call, await request);
  }

  $async.Stream<$4.ListKeysResponse> watchKeys_Pre($grpc.ServiceCall call, $async.Future<$4.WatchKeysRequest> request) async* {
    yield* watchKeys(call, await request);
  }

  $async.Future<$4.ListKeysResponse> listKeys($grpc.ServiceCall call, $4.ListKeysRequest request);
  $async.Future<$4.SSHKey> getKey($grpc.ServiceCall call, $4.GetKeyRequest request);
  $async.Future<$4.SSHKey> generateKey($grpc.ServiceCall call, $4.GenerateKeyRequest request);
  $async.Future<$1.Empty> deleteKey($grpc.ServiceCall call, $4.DeleteKeyRequest request);
  $async.Future<$4.GetFingerprintResponse> getFingerprint($grpc.ServiceCall call, $4.GetFingerprintRequest request);
  $async.Future<$1.Empty> changePassphrase($grpc.ServiceCall call, $4.ChangePassphraseRequest request);
  $async.Future<$4.PushKeyToRemoteResponse> pushKeyToRemote($grpc.ServiceCall call, $4.PushKeyToRemoteRequest request);
  $async.Stream<$4.ListKeysResponse> watchKeys($grpc.ServiceCall call, $4.WatchKeysRequest request);
}
