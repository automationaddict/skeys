// This is a generated file - do not edit.
//
// Generated from skeys/v1/system.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class ServiceState extends $pb.ProtobufEnum {
  static const ServiceState SERVICE_STATE_UNSPECIFIED =
      ServiceState._(0, _omitEnumNames ? '' : 'SERVICE_STATE_UNSPECIFIED');
  static const ServiceState SERVICE_STATE_RUNNING =
      ServiceState._(1, _omitEnumNames ? '' : 'SERVICE_STATE_RUNNING');
  static const ServiceState SERVICE_STATE_STOPPED =
      ServiceState._(2, _omitEnumNames ? '' : 'SERVICE_STATE_STOPPED');
  static const ServiceState SERVICE_STATE_FAILED =
      ServiceState._(3, _omitEnumNames ? '' : 'SERVICE_STATE_FAILED');
  static const ServiceState SERVICE_STATE_NOT_FOUND =
      ServiceState._(4, _omitEnumNames ? '' : 'SERVICE_STATE_NOT_FOUND');
  static const ServiceState SERVICE_STATE_UNKNOWN =
      ServiceState._(5, _omitEnumNames ? '' : 'SERVICE_STATE_UNKNOWN');

  static const $core.List<ServiceState> values = <ServiceState>[
    SERVICE_STATE_UNSPECIFIED,
    SERVICE_STATE_RUNNING,
    SERVICE_STATE_STOPPED,
    SERVICE_STATE_FAILED,
    SERVICE_STATE_NOT_FOUND,
    SERVICE_STATE_UNKNOWN,
  ];

  static final $core.List<ServiceState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static ServiceState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ServiceState._(super.value, super.name);
}

class SSHComponent extends $pb.ProtobufEnum {
  static const SSHComponent SSH_COMPONENT_UNSPECIFIED =
      SSHComponent._(0, _omitEnumNames ? '' : 'SSH_COMPONENT_UNSPECIFIED');
  static const SSHComponent SSH_COMPONENT_CLIENT =
      SSHComponent._(1, _omitEnumNames ? '' : 'SSH_COMPONENT_CLIENT');
  static const SSHComponent SSH_COMPONENT_SERVER =
      SSHComponent._(2, _omitEnumNames ? '' : 'SSH_COMPONENT_SERVER');

  static const $core.List<SSHComponent> values = <SSHComponent>[
    SSH_COMPONENT_UNSPECIFIED,
    SSH_COMPONENT_CLIENT,
    SSH_COMPONENT_SERVER,
  ];

  static final $core.List<SSHComponent?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static SSHComponent? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const SSHComponent._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
