// This is a generated file - do not edit.
//
// Generated from skeys/v1/update.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// DownloadState represents the state of a download
class DownloadState extends $pb.ProtobufEnum {
  static const DownloadState DOWNLOAD_STATE_UNSPECIFIED =
      DownloadState._(0, _omitEnumNames ? '' : 'DOWNLOAD_STATE_UNSPECIFIED');
  static const DownloadState DOWNLOAD_STATE_STARTING =
      DownloadState._(1, _omitEnumNames ? '' : 'DOWNLOAD_STATE_STARTING');
  static const DownloadState DOWNLOAD_STATE_DOWNLOADING =
      DownloadState._(2, _omitEnumNames ? '' : 'DOWNLOAD_STATE_DOWNLOADING');
  static const DownloadState DOWNLOAD_STATE_VERIFYING =
      DownloadState._(3, _omitEnumNames ? '' : 'DOWNLOAD_STATE_VERIFYING');
  static const DownloadState DOWNLOAD_STATE_COMPLETED =
      DownloadState._(4, _omitEnumNames ? '' : 'DOWNLOAD_STATE_COMPLETED');
  static const DownloadState DOWNLOAD_STATE_ERROR =
      DownloadState._(5, _omitEnumNames ? '' : 'DOWNLOAD_STATE_ERROR');

  static const $core.List<DownloadState> values = <DownloadState>[
    DOWNLOAD_STATE_UNSPECIFIED,
    DOWNLOAD_STATE_STARTING,
    DOWNLOAD_STATE_DOWNLOADING,
    DOWNLOAD_STATE_VERIFYING,
    DOWNLOAD_STATE_COMPLETED,
    DOWNLOAD_STATE_ERROR,
  ];

  static final $core.List<DownloadState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static DownloadState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const DownloadState._(super.value, super.name);
}

/// UpdateState represents the overall update system state
class UpdateState extends $pb.ProtobufEnum {
  static const UpdateState UPDATE_STATE_UNSPECIFIED =
      UpdateState._(0, _omitEnumNames ? '' : 'UPDATE_STATE_UNSPECIFIED');
  static const UpdateState UPDATE_STATE_IDLE =
      UpdateState._(1, _omitEnumNames ? '' : 'UPDATE_STATE_IDLE');
  static const UpdateState UPDATE_STATE_CHECKING =
      UpdateState._(2, _omitEnumNames ? '' : 'UPDATE_STATE_CHECKING');
  static const UpdateState UPDATE_STATE_UPDATE_AVAILABLE =
      UpdateState._(3, _omitEnumNames ? '' : 'UPDATE_STATE_UPDATE_AVAILABLE');
  static const UpdateState UPDATE_STATE_DOWNLOADING =
      UpdateState._(4, _omitEnumNames ? '' : 'UPDATE_STATE_DOWNLOADING');
  static const UpdateState UPDATE_STATE_READY_TO_APPLY =
      UpdateState._(5, _omitEnumNames ? '' : 'UPDATE_STATE_READY_TO_APPLY');
  static const UpdateState UPDATE_STATE_APPLYING =
      UpdateState._(6, _omitEnumNames ? '' : 'UPDATE_STATE_APPLYING');
  static const UpdateState UPDATE_STATE_ERROR =
      UpdateState._(7, _omitEnumNames ? '' : 'UPDATE_STATE_ERROR');

  static const $core.List<UpdateState> values = <UpdateState>[
    UPDATE_STATE_UNSPECIFIED,
    UPDATE_STATE_IDLE,
    UPDATE_STATE_CHECKING,
    UPDATE_STATE_UPDATE_AVAILABLE,
    UPDATE_STATE_DOWNLOADING,
    UPDATE_STATE_READY_TO_APPLY,
    UPDATE_STATE_APPLYING,
    UPDATE_STATE_ERROR,
  ];

  static final $core.List<UpdateState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 7);
  static UpdateState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const UpdateState._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
