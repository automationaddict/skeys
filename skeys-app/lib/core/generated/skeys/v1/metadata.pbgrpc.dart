//
//  Generated code. Do not modify.
//  source: skeys/v1/metadata.proto
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
import 'metadata.pb.dart' as $5;

export 'metadata.pb.dart';

@$pb.GrpcServiceName('skeys.v1.MetadataService')
class MetadataServiceClient extends $grpc.Client {
  static final _$getKeyMetadata = $grpc.ClientMethod<$5.GetKeyMetadataRequest, $5.KeyMetadata>(
      '/skeys.v1.MetadataService/GetKeyMetadata',
      ($5.GetKeyMetadataRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $5.KeyMetadata.fromBuffer(value));
  static final _$setKeyMetadata = $grpc.ClientMethod<$5.SetKeyMetadataRequest, $1.Empty>(
      '/skeys.v1.MetadataService/SetKeyMetadata',
      ($5.SetKeyMetadataRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.Empty.fromBuffer(value));
  static final _$deleteKeyMetadata = $grpc.ClientMethod<$5.DeleteKeyMetadataRequest, $1.Empty>(
      '/skeys.v1.MetadataService/DeleteKeyMetadata',
      ($5.DeleteKeyMetadataRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.Empty.fromBuffer(value));
  static final _$listKeyMetadata = $grpc.ClientMethod<$5.ListKeyMetadataRequest, $5.ListKeyMetadataResponse>(
      '/skeys.v1.MetadataService/ListKeyMetadata',
      ($5.ListKeyMetadataRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $5.ListKeyMetadataResponse.fromBuffer(value));

  MetadataServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$5.KeyMetadata> getKeyMetadata($5.GetKeyMetadataRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getKeyMetadata, request, options: options);
  }

  $grpc.ResponseFuture<$1.Empty> setKeyMetadata($5.SetKeyMetadataRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$setKeyMetadata, request, options: options);
  }

  $grpc.ResponseFuture<$1.Empty> deleteKeyMetadata($5.DeleteKeyMetadataRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$deleteKeyMetadata, request, options: options);
  }

  $grpc.ResponseFuture<$5.ListKeyMetadataResponse> listKeyMetadata($5.ListKeyMetadataRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$listKeyMetadata, request, options: options);
  }
}

@$pb.GrpcServiceName('skeys.v1.MetadataService')
abstract class MetadataServiceBase extends $grpc.Service {
  $core.String get $name => 'skeys.v1.MetadataService';

  MetadataServiceBase() {
    $addMethod($grpc.ServiceMethod<$5.GetKeyMetadataRequest, $5.KeyMetadata>(
        'GetKeyMetadata',
        getKeyMetadata_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $5.GetKeyMetadataRequest.fromBuffer(value),
        ($5.KeyMetadata value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$5.SetKeyMetadataRequest, $1.Empty>(
        'SetKeyMetadata',
        setKeyMetadata_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $5.SetKeyMetadataRequest.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$5.DeleteKeyMetadataRequest, $1.Empty>(
        'DeleteKeyMetadata',
        deleteKeyMetadata_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $5.DeleteKeyMetadataRequest.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$5.ListKeyMetadataRequest, $5.ListKeyMetadataResponse>(
        'ListKeyMetadata',
        listKeyMetadata_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $5.ListKeyMetadataRequest.fromBuffer(value),
        ($5.ListKeyMetadataResponse value) => value.writeToBuffer()));
  }

  $async.Future<$5.KeyMetadata> getKeyMetadata_Pre($grpc.ServiceCall call, $async.Future<$5.GetKeyMetadataRequest> request) async {
    return getKeyMetadata(call, await request);
  }

  $async.Future<$1.Empty> setKeyMetadata_Pre($grpc.ServiceCall call, $async.Future<$5.SetKeyMetadataRequest> request) async {
    return setKeyMetadata(call, await request);
  }

  $async.Future<$1.Empty> deleteKeyMetadata_Pre($grpc.ServiceCall call, $async.Future<$5.DeleteKeyMetadataRequest> request) async {
    return deleteKeyMetadata(call, await request);
  }

  $async.Future<$5.ListKeyMetadataResponse> listKeyMetadata_Pre($grpc.ServiceCall call, $async.Future<$5.ListKeyMetadataRequest> request) async {
    return listKeyMetadata(call, await request);
  }

  $async.Future<$5.KeyMetadata> getKeyMetadata($grpc.ServiceCall call, $5.GetKeyMetadataRequest request);
  $async.Future<$1.Empty> setKeyMetadata($grpc.ServiceCall call, $5.SetKeyMetadataRequest request);
  $async.Future<$1.Empty> deleteKeyMetadata($grpc.ServiceCall call, $5.DeleteKeyMetadataRequest request);
  $async.Future<$5.ListKeyMetadataResponse> listKeyMetadata($grpc.ServiceCall call, $5.ListKeyMetadataRequest request);
}
