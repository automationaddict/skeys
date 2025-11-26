// This is a generated file - do not edit.
//
// Generated from skeys/v1/common.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class TargetType extends $pb.ProtobufEnum {
  static const TargetType TARGET_TYPE_UNSPECIFIED =
      TargetType._(0, _omitEnumNames ? '' : 'TARGET_TYPE_UNSPECIFIED');
  static const TargetType TARGET_TYPE_LOCAL =
      TargetType._(1, _omitEnumNames ? '' : 'TARGET_TYPE_LOCAL');
  static const TargetType TARGET_TYPE_REMOTE =
      TargetType._(2, _omitEnumNames ? '' : 'TARGET_TYPE_REMOTE');

  static const $core.List<TargetType> values = <TargetType>[
    TARGET_TYPE_UNSPECIFIED,
    TARGET_TYPE_LOCAL,
    TARGET_TYPE_REMOTE,
  ];

  static final $core.List<TargetType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static TargetType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const TargetType._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
