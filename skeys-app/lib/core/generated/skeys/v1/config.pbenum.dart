// This is a generated file - do not edit.
//
// Generated from skeys/v1/config.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// New unified SSH config entry supporting both Host and Match blocks
class SSHConfigEntryType extends $pb.ProtobufEnum {
  static const SSHConfigEntryType SSH_CONFIG_ENTRY_TYPE_UNSPECIFIED =
      SSHConfigEntryType._(
          0, _omitEnumNames ? '' : 'SSH_CONFIG_ENTRY_TYPE_UNSPECIFIED');
  static const SSHConfigEntryType SSH_CONFIG_ENTRY_TYPE_HOST =
      SSHConfigEntryType._(
          1, _omitEnumNames ? '' : 'SSH_CONFIG_ENTRY_TYPE_HOST');
  static const SSHConfigEntryType SSH_CONFIG_ENTRY_TYPE_MATCH =
      SSHConfigEntryType._(
          2, _omitEnumNames ? '' : 'SSH_CONFIG_ENTRY_TYPE_MATCH');

  static const $core.List<SSHConfigEntryType> values = <SSHConfigEntryType>[
    SSH_CONFIG_ENTRY_TYPE_UNSPECIFIED,
    SSH_CONFIG_ENTRY_TYPE_HOST,
    SSH_CONFIG_ENTRY_TYPE_MATCH,
  ];

  static final $core.List<SSHConfigEntryType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static SSHConfigEntryType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const SSHConfigEntryType._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
