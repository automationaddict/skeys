//
//  Generated code. Do not modify.
//  source: skeys/v1/metadata.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use keyMetadataDescriptor instead')
const KeyMetadata$json = {
  '1': 'KeyMetadata',
  '2': [
    {'1': 'key_path', '3': 1, '4': 1, '5': 9, '10': 'keyPath'},
    {'1': 'verified_service', '3': 2, '4': 1, '5': 9, '10': 'verifiedService'},
    {'1': 'verified_host', '3': 3, '4': 1, '5': 9, '10': 'verifiedHost'},
    {'1': 'verified_port', '3': 4, '4': 1, '5': 5, '10': 'verifiedPort'},
    {'1': 'verified_user', '3': 5, '4': 1, '5': 9, '10': 'verifiedUser'},
  ],
};

/// Descriptor for `KeyMetadata`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List keyMetadataDescriptor = $convert.base64Decode(
    'CgtLZXlNZXRhZGF0YRIZCghrZXlfcGF0aBgBIAEoCVIHa2V5UGF0aBIpChB2ZXJpZmllZF9zZX'
    'J2aWNlGAIgASgJUg92ZXJpZmllZFNlcnZpY2USIwoNdmVyaWZpZWRfaG9zdBgDIAEoCVIMdmVy'
    'aWZpZWRIb3N0EiMKDXZlcmlmaWVkX3BvcnQYBCABKAVSDHZlcmlmaWVkUG9ydBIjCg12ZXJpZm'
    'llZF91c2VyGAUgASgJUgx2ZXJpZmllZFVzZXI=');

@$core.Deprecated('Use getKeyMetadataRequestDescriptor instead')
const GetKeyMetadataRequest$json = {
  '1': 'GetKeyMetadataRequest',
  '2': [
    {'1': 'key_path', '3': 1, '4': 1, '5': 9, '10': 'keyPath'},
  ],
};

/// Descriptor for `GetKeyMetadataRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getKeyMetadataRequestDescriptor = $convert.base64Decode(
    'ChVHZXRLZXlNZXRhZGF0YVJlcXVlc3QSGQoIa2V5X3BhdGgYASABKAlSB2tleVBhdGg=');

@$core.Deprecated('Use setKeyMetadataRequestDescriptor instead')
const SetKeyMetadataRequest$json = {
  '1': 'SetKeyMetadataRequest',
  '2': [
    {'1': 'metadata', '3': 1, '4': 1, '5': 11, '6': '.skeys.v1.KeyMetadata', '10': 'metadata'},
  ],
};

/// Descriptor for `SetKeyMetadataRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setKeyMetadataRequestDescriptor = $convert.base64Decode(
    'ChVTZXRLZXlNZXRhZGF0YVJlcXVlc3QSMQoIbWV0YWRhdGEYASABKAsyFS5za2V5cy52MS5LZX'
    'lNZXRhZGF0YVIIbWV0YWRhdGE=');

@$core.Deprecated('Use deleteKeyMetadataRequestDescriptor instead')
const DeleteKeyMetadataRequest$json = {
  '1': 'DeleteKeyMetadataRequest',
  '2': [
    {'1': 'key_path', '3': 1, '4': 1, '5': 9, '10': 'keyPath'},
  ],
};

/// Descriptor for `DeleteKeyMetadataRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteKeyMetadataRequestDescriptor = $convert.base64Decode(
    'ChhEZWxldGVLZXlNZXRhZGF0YVJlcXVlc3QSGQoIa2V5X3BhdGgYASABKAlSB2tleVBhdGg=');

@$core.Deprecated('Use listKeyMetadataRequestDescriptor instead')
const ListKeyMetadataRequest$json = {
  '1': 'ListKeyMetadataRequest',
};

/// Descriptor for `ListKeyMetadataRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listKeyMetadataRequestDescriptor = $convert.base64Decode(
    'ChZMaXN0S2V5TWV0YWRhdGFSZXF1ZXN0');

@$core.Deprecated('Use listKeyMetadataResponseDescriptor instead')
const ListKeyMetadataResponse$json = {
  '1': 'ListKeyMetadataResponse',
  '2': [
    {'1': 'metadata', '3': 1, '4': 3, '5': 11, '6': '.skeys.v1.KeyMetadata', '10': 'metadata'},
  ],
};

/// Descriptor for `ListKeyMetadataResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listKeyMetadataResponseDescriptor = $convert.base64Decode(
    'ChdMaXN0S2V5TWV0YWRhdGFSZXNwb25zZRIxCghtZXRhZGF0YRgBIAMoCzIVLnNrZXlzLnYxLk'
    'tleU1ldGFkYXRhUghtZXRhZGF0YQ==');

