//
//  Generated code. Do not modify.
//  source: skeys/v1/version.proto
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
import 'version.pb.dart' as $7;

export 'version.pb.dart';

@$pb.GrpcServiceName('skeys.v1.VersionService')
class VersionServiceClient extends $grpc.Client {
  static final _$getVersion = $grpc.ClientMethod<$1.Empty, $7.VersionInfo>(
      '/skeys.v1.VersionService/GetVersion',
      ($1.Empty value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $7.VersionInfo.fromBuffer(value));

  VersionServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$7.VersionInfo> getVersion($1.Empty request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getVersion, request, options: options);
  }
}

@$pb.GrpcServiceName('skeys.v1.VersionService')
abstract class VersionServiceBase extends $grpc.Service {
  $core.String get $name => 'skeys.v1.VersionService';

  VersionServiceBase() {
    $addMethod($grpc.ServiceMethod<$1.Empty, $7.VersionInfo>(
        'GetVersion',
        getVersion_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.Empty.fromBuffer(value),
        ($7.VersionInfo value) => value.writeToBuffer()));
  }

  $async.Future<$7.VersionInfo> getVersion_Pre($grpc.ServiceCall call, $async.Future<$1.Empty> request) async {
    return getVersion(call, await request);
  }

  $async.Future<$7.VersionInfo> getVersion($grpc.ServiceCall call, $1.Empty request);
}
