//
//  Generated code. Do not modify.
//  source: skeys/v1/remote.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class RemoteStatus extends $pb.ProtobufEnum {
  static const RemoteStatus REMOTE_STATUS_UNSPECIFIED = RemoteStatus._(0, _omitEnumNames ? '' : 'REMOTE_STATUS_UNSPECIFIED');
  static const RemoteStatus REMOTE_STATUS_DISCONNECTED = RemoteStatus._(1, _omitEnumNames ? '' : 'REMOTE_STATUS_DISCONNECTED');
  static const RemoteStatus REMOTE_STATUS_CONNECTING = RemoteStatus._(2, _omitEnumNames ? '' : 'REMOTE_STATUS_CONNECTING');
  static const RemoteStatus REMOTE_STATUS_CONNECTED = RemoteStatus._(3, _omitEnumNames ? '' : 'REMOTE_STATUS_CONNECTED');
  static const RemoteStatus REMOTE_STATUS_ERROR = RemoteStatus._(4, _omitEnumNames ? '' : 'REMOTE_STATUS_ERROR');

  static const $core.List<RemoteStatus> values = <RemoteStatus> [
    REMOTE_STATUS_UNSPECIFIED,
    REMOTE_STATUS_DISCONNECTED,
    REMOTE_STATUS_CONNECTING,
    REMOTE_STATUS_CONNECTED,
    REMOTE_STATUS_ERROR,
  ];

  static final $core.Map<$core.int, RemoteStatus> _byValue = $pb.ProtobufEnum.initByValue(values);
  static RemoteStatus? valueOf($core.int value) => _byValue[value];

  const RemoteStatus._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
