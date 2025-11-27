//
//  Generated code. Do not modify.
//  source: skeys/v1/common.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class TargetType extends $pb.ProtobufEnum {
  static const TargetType TARGET_TYPE_UNSPECIFIED = TargetType._(0, _omitEnumNames ? '' : 'TARGET_TYPE_UNSPECIFIED');
  static const TargetType TARGET_TYPE_LOCAL = TargetType._(1, _omitEnumNames ? '' : 'TARGET_TYPE_LOCAL');
  static const TargetType TARGET_TYPE_REMOTE = TargetType._(2, _omitEnumNames ? '' : 'TARGET_TYPE_REMOTE');

  static const $core.List<TargetType> values = <TargetType> [
    TARGET_TYPE_UNSPECIFIED,
    TARGET_TYPE_LOCAL,
    TARGET_TYPE_REMOTE,
  ];

  static final $core.Map<$core.int, TargetType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static TargetType? valueOf($core.int value) => _byValue[value];

  const TargetType._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
