// This is a generated file - do not edit.
//
// Generated from skeys/v1/metadata.proto.

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

import 'metadata.pb.dart' as $0;

export 'metadata.pb.dart';

/// MetadataService manages persistent metadata about SSH keys
@$pb.GrpcServiceName('skeys.v1.MetadataService')
class MetadataServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  MetadataServiceClient(super.channel, {super.options, super.interceptors});

  /// GetKeyMetadata retrieves metadata for a specific key
  $grpc.ResponseFuture<$0.KeyMetadata> getKeyMetadata(
    $0.GetKeyMetadataRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getKeyMetadata, request, options: options);
  }

  /// SetKeyMetadata stores metadata for a key
  $grpc.ResponseFuture<$1.Empty> setKeyMetadata(
    $0.SetKeyMetadataRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$setKeyMetadata, request, options: options);
  }

  /// DeleteKeyMetadata removes metadata for a key
  $grpc.ResponseFuture<$1.Empty> deleteKeyMetadata(
    $0.DeleteKeyMetadataRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$deleteKeyMetadata, request, options: options);
  }

  /// ListKeyMetadata returns all stored key metadata
  $grpc.ResponseFuture<$0.ListKeyMetadataResponse> listKeyMetadata(
    $0.ListKeyMetadataRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listKeyMetadata, request, options: options);
  }

  // method descriptors

  static final _$getKeyMetadata =
      $grpc.ClientMethod<$0.GetKeyMetadataRequest, $0.KeyMetadata>(
          '/skeys.v1.MetadataService/GetKeyMetadata',
          ($0.GetKeyMetadataRequest value) => value.writeToBuffer(),
          $0.KeyMetadata.fromBuffer);
  static final _$setKeyMetadata =
      $grpc.ClientMethod<$0.SetKeyMetadataRequest, $1.Empty>(
          '/skeys.v1.MetadataService/SetKeyMetadata',
          ($0.SetKeyMetadataRequest value) => value.writeToBuffer(),
          $1.Empty.fromBuffer);
  static final _$deleteKeyMetadata =
      $grpc.ClientMethod<$0.DeleteKeyMetadataRequest, $1.Empty>(
          '/skeys.v1.MetadataService/DeleteKeyMetadata',
          ($0.DeleteKeyMetadataRequest value) => value.writeToBuffer(),
          $1.Empty.fromBuffer);
  static final _$listKeyMetadata =
      $grpc.ClientMethod<$0.ListKeyMetadataRequest, $0.ListKeyMetadataResponse>(
          '/skeys.v1.MetadataService/ListKeyMetadata',
          ($0.ListKeyMetadataRequest value) => value.writeToBuffer(),
          $0.ListKeyMetadataResponse.fromBuffer);
}

@$pb.GrpcServiceName('skeys.v1.MetadataService')
abstract class MetadataServiceBase extends $grpc.Service {
  $core.String get $name => 'skeys.v1.MetadataService';

  MetadataServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.GetKeyMetadataRequest, $0.KeyMetadata>(
        'GetKeyMetadata',
        getKeyMetadata_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetKeyMetadataRequest.fromBuffer(value),
        ($0.KeyMetadata value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SetKeyMetadataRequest, $1.Empty>(
        'SetKeyMetadata',
        setKeyMetadata_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SetKeyMetadataRequest.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DeleteKeyMetadataRequest, $1.Empty>(
        'DeleteKeyMetadata',
        deleteKeyMetadata_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.DeleteKeyMetadataRequest.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListKeyMetadataRequest,
            $0.ListKeyMetadataResponse>(
        'ListKeyMetadata',
        listKeyMetadata_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ListKeyMetadataRequest.fromBuffer(value),
        ($0.ListKeyMetadataResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.KeyMetadata> getKeyMetadata_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetKeyMetadataRequest> $request) async {
    return getKeyMetadata($call, await $request);
  }

  $async.Future<$0.KeyMetadata> getKeyMetadata(
      $grpc.ServiceCall call, $0.GetKeyMetadataRequest request);

  $async.Future<$1.Empty> setKeyMetadata_Pre($grpc.ServiceCall $call,
      $async.Future<$0.SetKeyMetadataRequest> $request) async {
    return setKeyMetadata($call, await $request);
  }

  $async.Future<$1.Empty> setKeyMetadata(
      $grpc.ServiceCall call, $0.SetKeyMetadataRequest request);

  $async.Future<$1.Empty> deleteKeyMetadata_Pre($grpc.ServiceCall $call,
      $async.Future<$0.DeleteKeyMetadataRequest> $request) async {
    return deleteKeyMetadata($call, await $request);
  }

  $async.Future<$1.Empty> deleteKeyMetadata(
      $grpc.ServiceCall call, $0.DeleteKeyMetadataRequest request);

  $async.Future<$0.ListKeyMetadataResponse> listKeyMetadata_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListKeyMetadataRequest> $request) async {
    return listKeyMetadata($call, await $request);
  }

  $async.Future<$0.ListKeyMetadataResponse> listKeyMetadata(
      $grpc.ServiceCall call, $0.ListKeyMetadataRequest request);
}
