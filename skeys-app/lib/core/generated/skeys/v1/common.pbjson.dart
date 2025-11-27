//
//  Generated code. Do not modify.
//  source: skeys/v1/common.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use targetTypeDescriptor instead')
const TargetType$json = {
  '1': 'TargetType',
  '2': [
    {'1': 'TARGET_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'TARGET_TYPE_LOCAL', '2': 1},
    {'1': 'TARGET_TYPE_REMOTE', '2': 2},
  ],
};

/// Descriptor for `TargetType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List targetTypeDescriptor = $convert.base64Decode(
    'CgpUYXJnZXRUeXBlEhsKF1RBUkdFVF9UWVBFX1VOU1BFQ0lGSUVEEAASFQoRVEFSR0VUX1RZUE'
    'VfTE9DQUwQARIWChJUQVJHRVRfVFlQRV9SRU1PVEUQAg==');

@$core.Deprecated('Use targetDescriptor instead')
const Target$json = {
  '1': 'Target',
  '2': [
    {'1': 'type', '3': 1, '4': 1, '5': 14, '6': '.skeys.v1.TargetType', '10': 'type'},
    {'1': 'remote_id', '3': 2, '4': 1, '5': 9, '10': 'remoteId'},
  ],
};

/// Descriptor for `Target`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List targetDescriptor = $convert.base64Decode(
    'CgZUYXJnZXQSKAoEdHlwZRgBIAEoDjIULnNrZXlzLnYxLlRhcmdldFR5cGVSBHR5cGUSGwoJcm'
    'Vtb3RlX2lkGAIgASgJUghyZW1vdGVJZA==');

