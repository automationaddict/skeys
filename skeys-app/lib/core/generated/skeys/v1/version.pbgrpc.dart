// This is a generated file - do not edit.
//
// Generated from skeys/v1/version.proto.

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
import '../../google/protobuf/empty.pb.dart' as $0;

import 'version.pb.dart' as $1;

export 'version.pb.dart';

/// VersionService provides version information about the daemon
@$pb.GrpcServiceName('skeys.v1.VersionService')
class VersionServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  VersionServiceClient(super.channel, {super.options, super.interceptors});

  /// GetVersion returns version information about the daemon and Go runtime
  $grpc.ResponseFuture<$1.VersionInfo> getVersion(
    $0.Empty request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getVersion, request, options: options);
  }

  // method descriptors

  static final _$getVersion = $grpc.ClientMethod<$0.Empty, $1.VersionInfo>(
      '/skeys.v1.VersionService/GetVersion',
      ($0.Empty value) => value.writeToBuffer(),
      $1.VersionInfo.fromBuffer);
}

@$pb.GrpcServiceName('skeys.v1.VersionService')
abstract class VersionServiceBase extends $grpc.Service {
  $core.String get $name => 'skeys.v1.VersionService';

  VersionServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.Empty, $1.VersionInfo>(
        'GetVersion',
        getVersion_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($1.VersionInfo value) => value.writeToBuffer()));
  }

  $async.Future<$1.VersionInfo> getVersion_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.Empty> $request) async {
    return getVersion($call, await $request);
  }

  $async.Future<$1.VersionInfo> getVersion(
      $grpc.ServiceCall call, $0.Empty request);
}
