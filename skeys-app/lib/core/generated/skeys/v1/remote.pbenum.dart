// This is a generated file - do not edit.
//
// Generated from skeys/v1/remote.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class RemoteStatus extends $pb.ProtobufEnum {
  static const RemoteStatus REMOTE_STATUS_UNSPECIFIED =
      RemoteStatus._(0, _omitEnumNames ? '' : 'REMOTE_STATUS_UNSPECIFIED');
  static const RemoteStatus REMOTE_STATUS_DISCONNECTED =
      RemoteStatus._(1, _omitEnumNames ? '' : 'REMOTE_STATUS_DISCONNECTED');
  static const RemoteStatus REMOTE_STATUS_CONNECTING =
      RemoteStatus._(2, _omitEnumNames ? '' : 'REMOTE_STATUS_CONNECTING');
  static const RemoteStatus REMOTE_STATUS_CONNECTED =
      RemoteStatus._(3, _omitEnumNames ? '' : 'REMOTE_STATUS_CONNECTED');
  static const RemoteStatus REMOTE_STATUS_ERROR =
      RemoteStatus._(4, _omitEnumNames ? '' : 'REMOTE_STATUS_ERROR');

  static const $core.List<RemoteStatus> values = <RemoteStatus>[
    REMOTE_STATUS_UNSPECIFIED,
    REMOTE_STATUS_DISCONNECTED,
    REMOTE_STATUS_CONNECTING,
    REMOTE_STATUS_CONNECTED,
    REMOTE_STATUS_ERROR,
  ];

  static final $core.List<RemoteStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static RemoteStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const RemoteStatus._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
