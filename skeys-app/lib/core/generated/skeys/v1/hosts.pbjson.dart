// This is a generated file - do not edit.
//
// Generated from skeys/v1/hosts.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use knownHostDescriptor instead')
const KnownHost$json = {
  '1': 'KnownHost',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'hostnames', '3': 2, '4': 3, '5': 9, '10': 'hostnames'},
    {'1': 'key_type', '3': 3, '4': 1, '5': 9, '10': 'keyType'},
    {'1': 'fingerprint', '3': 4, '4': 1, '5': 9, '10': 'fingerprint'},
    {'1': 'public_key', '3': 5, '4': 1, '5': 9, '10': 'publicKey'},
    {'1': 'is_hashed', '3': 6, '4': 1, '5': 8, '10': 'isHashed'},
    {'1': 'is_revoked', '3': 7, '4': 1, '5': 8, '10': 'isRevoked'},
    {'1': 'is_cert_authority', '3': 8, '4': 1, '5': 8, '10': 'isCertAuthority'},
    {'1': 'line_number', '3': 9, '4': 1, '5': 5, '10': 'lineNumber'},
  ],
};

/// Descriptor for `KnownHost`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List knownHostDescriptor = $convert.base64Decode(
    'CglLbm93bkhvc3QSDgoCaWQYASABKAlSAmlkEhwKCWhvc3RuYW1lcxgCIAMoCVIJaG9zdG5hbW'
    'VzEhkKCGtleV90eXBlGAMgASgJUgdrZXlUeXBlEiAKC2ZpbmdlcnByaW50GAQgASgJUgtmaW5n'
    'ZXJwcmludBIdCgpwdWJsaWNfa2V5GAUgASgJUglwdWJsaWNLZXkSGwoJaXNfaGFzaGVkGAYgAS'
    'gIUghpc0hhc2hlZBIdCgppc19yZXZva2VkGAcgASgIUglpc1Jldm9rZWQSKgoRaXNfY2VydF9h'
    'dXRob3JpdHkYCCABKAhSD2lzQ2VydEF1dGhvcml0eRIfCgtsaW5lX251bWJlchgJIAEoBVIKbG'
    'luZU51bWJlcg==');

@$core.Deprecated('Use listKnownHostsRequestDescriptor instead')
const ListKnownHostsRequest$json = {
  '1': 'ListKnownHostsRequest',
  '2': [
    {
      '1': 'target',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.skeys.v1.Target',
      '10': 'target'
    },
  ],
};

/// Descriptor for `ListKnownHostsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listKnownHostsRequestDescriptor = $convert.base64Decode(
    'ChVMaXN0S25vd25Ib3N0c1JlcXVlc3QSKAoGdGFyZ2V0GAEgASgLMhAuc2tleXMudjEuVGFyZ2'
    'V0UgZ0YXJnZXQ=');

@$core.Deprecated('Use watchKnownHostsRequestDescriptor instead')
const WatchKnownHostsRequest$json = {
  '1': 'WatchKnownHostsRequest',
  '2': [
    {
      '1': 'target',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.skeys.v1.Target',
      '10': 'target'
    },
  ],
};

/// Descriptor for `WatchKnownHostsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchKnownHostsRequestDescriptor =
    $convert.base64Decode(
        'ChZXYXRjaEtub3duSG9zdHNSZXF1ZXN0EigKBnRhcmdldBgBIAEoCzIQLnNrZXlzLnYxLlRhcm'
        'dldFIGdGFyZ2V0');

@$core.Deprecated('Use listKnownHostsResponseDescriptor instead')
const ListKnownHostsResponse$json = {
  '1': 'ListKnownHostsResponse',
  '2': [
    {
      '1': 'hosts',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.skeys.v1.KnownHost',
      '10': 'hosts'
    },
  ],
};

/// Descriptor for `ListKnownHostsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listKnownHostsResponseDescriptor =
    $convert.base64Decode(
        'ChZMaXN0S25vd25Ib3N0c1Jlc3BvbnNlEikKBWhvc3RzGAEgAygLMhMuc2tleXMudjEuS25vd2'
        '5Ib3N0UgVob3N0cw==');

@$core.Deprecated('Use getKnownHostRequestDescriptor instead')
const GetKnownHostRequest$json = {
  '1': 'GetKnownHostRequest',
  '2': [
    {
      '1': 'target',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.skeys.v1.Target',
      '10': 'target'
    },
    {'1': 'hostname', '3': 2, '4': 1, '5': 9, '10': 'hostname'},
    {'1': 'port', '3': 3, '4': 1, '5': 5, '10': 'port'},
  ],
};

/// Descriptor for `GetKnownHostRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getKnownHostRequestDescriptor = $convert.base64Decode(
    'ChNHZXRLbm93bkhvc3RSZXF1ZXN0EigKBnRhcmdldBgBIAEoCzIQLnNrZXlzLnYxLlRhcmdldF'
    'IGdGFyZ2V0EhoKCGhvc3RuYW1lGAIgASgJUghob3N0bmFtZRISCgRwb3J0GAMgASgFUgRwb3J0');

@$core.Deprecated('Use getKnownHostResponseDescriptor instead')
const GetKnownHostResponse$json = {
  '1': 'GetKnownHostResponse',
  '2': [
    {
      '1': 'hosts',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.skeys.v1.KnownHost',
      '10': 'hosts'
    },
  ],
};

/// Descriptor for `GetKnownHostResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getKnownHostResponseDescriptor = $convert.base64Decode(
    'ChRHZXRLbm93bkhvc3RSZXNwb25zZRIpCgVob3N0cxgBIAMoCzITLnNrZXlzLnYxLktub3duSG'
    '9zdFIFaG9zdHM=');

@$core.Deprecated('Use removeKnownHostRequestDescriptor instead')
const RemoveKnownHostRequest$json = {
  '1': 'RemoveKnownHostRequest',
  '2': [
    {
      '1': 'target',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.skeys.v1.Target',
      '10': 'target'
    },
    {'1': 'hostname', '3': 2, '4': 1, '5': 9, '10': 'hostname'},
    {'1': 'port', '3': 3, '4': 1, '5': 5, '10': 'port'},
  ],
};

/// Descriptor for `RemoveKnownHostRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List removeKnownHostRequestDescriptor = $convert.base64Decode(
    'ChZSZW1vdmVLbm93bkhvc3RSZXF1ZXN0EigKBnRhcmdldBgBIAEoCzIQLnNrZXlzLnYxLlRhcm'
    'dldFIGdGFyZ2V0EhoKCGhvc3RuYW1lGAIgASgJUghob3N0bmFtZRISCgRwb3J0GAMgASgFUgRw'
    'b3J0');

@$core.Deprecated('Use hashKnownHostsRequestDescriptor instead')
const HashKnownHostsRequest$json = {
  '1': 'HashKnownHostsRequest',
  '2': [
    {
      '1': 'target',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.skeys.v1.Target',
      '10': 'target'
    },
  ],
};

/// Descriptor for `HashKnownHostsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List hashKnownHostsRequestDescriptor = $convert.base64Decode(
    'ChVIYXNoS25vd25Ib3N0c1JlcXVlc3QSKAoGdGFyZ2V0GAEgASgLMhAuc2tleXMudjEuVGFyZ2'
    'V0UgZ0YXJnZXQ=');

@$core.Deprecated('Use scanHostKeysRequestDescriptor instead')
const ScanHostKeysRequest$json = {
  '1': 'ScanHostKeysRequest',
  '2': [
    {'1': 'hostname', '3': 1, '4': 1, '5': 9, '10': 'hostname'},
    {'1': 'port', '3': 2, '4': 1, '5': 5, '10': 'port'},
    {'1': 'timeout_seconds', '3': 3, '4': 1, '5': 5, '10': 'timeoutSeconds'},
  ],
};

/// Descriptor for `ScanHostKeysRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scanHostKeysRequestDescriptor = $convert.base64Decode(
    'ChNTY2FuSG9zdEtleXNSZXF1ZXN0EhoKCGhvc3RuYW1lGAEgASgJUghob3N0bmFtZRISCgRwb3'
    'J0GAIgASgFUgRwb3J0EicKD3RpbWVvdXRfc2Vjb25kcxgDIAEoBVIOdGltZW91dFNlY29uZHM=');

@$core.Deprecated('Use scannedHostKeyDescriptor instead')
const ScannedHostKey$json = {
  '1': 'ScannedHostKey',
  '2': [
    {'1': 'hostname', '3': 1, '4': 1, '5': 9, '10': 'hostname'},
    {'1': 'port', '3': 2, '4': 1, '5': 5, '10': 'port'},
    {'1': 'key_type', '3': 3, '4': 1, '5': 9, '10': 'keyType'},
    {'1': 'public_key', '3': 4, '4': 1, '5': 9, '10': 'publicKey'},
    {'1': 'fingerprint', '3': 5, '4': 1, '5': 9, '10': 'fingerprint'},
  ],
};

/// Descriptor for `ScannedHostKey`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scannedHostKeyDescriptor = $convert.base64Decode(
    'Cg5TY2FubmVkSG9zdEtleRIaCghob3N0bmFtZRgBIAEoCVIIaG9zdG5hbWUSEgoEcG9ydBgCIA'
    'EoBVIEcG9ydBIZCghrZXlfdHlwZRgDIAEoCVIHa2V5VHlwZRIdCgpwdWJsaWNfa2V5GAQgASgJ'
    'UglwdWJsaWNLZXkSIAoLZmluZ2VycHJpbnQYBSABKAlSC2ZpbmdlcnByaW50');

@$core.Deprecated('Use scanHostKeysResponseDescriptor instead')
const ScanHostKeysResponse$json = {
  '1': 'ScanHostKeysResponse',
  '2': [
    {
      '1': 'keys',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.skeys.v1.ScannedHostKey',
      '10': 'keys'
    },
  ],
};

/// Descriptor for `ScanHostKeysResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scanHostKeysResponseDescriptor = $convert.base64Decode(
    'ChRTY2FuSG9zdEtleXNSZXNwb25zZRIsCgRrZXlzGAEgAygLMhguc2tleXMudjEuU2Nhbm5lZE'
    'hvc3RLZXlSBGtleXM=');

@$core.Deprecated('Use addKnownHostRequestDescriptor instead')
const AddKnownHostRequest$json = {
  '1': 'AddKnownHostRequest',
  '2': [
    {
      '1': 'target',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.skeys.v1.Target',
      '10': 'target'
    },
    {'1': 'hostname', '3': 2, '4': 1, '5': 9, '10': 'hostname'},
    {'1': 'port', '3': 3, '4': 1, '5': 5, '10': 'port'},
    {'1': 'key_type', '3': 4, '4': 1, '5': 9, '10': 'keyType'},
    {'1': 'public_key', '3': 5, '4': 1, '5': 9, '10': 'publicKey'},
    {'1': 'hash_hostname', '3': 6, '4': 1, '5': 8, '10': 'hashHostname'},
  ],
};

/// Descriptor for `AddKnownHostRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addKnownHostRequestDescriptor = $convert.base64Decode(
    'ChNBZGRLbm93bkhvc3RSZXF1ZXN0EigKBnRhcmdldBgBIAEoCzIQLnNrZXlzLnYxLlRhcmdldF'
    'IGdGFyZ2V0EhoKCGhvc3RuYW1lGAIgASgJUghob3N0bmFtZRISCgRwb3J0GAMgASgFUgRwb3J0'
    'EhkKCGtleV90eXBlGAQgASgJUgdrZXlUeXBlEh0KCnB1YmxpY19rZXkYBSABKAlSCXB1YmxpY0'
    'tleRIjCg1oYXNoX2hvc3RuYW1lGAYgASgIUgxoYXNoSG9zdG5hbWU=');

@$core.Deprecated('Use authorizedKeyDescriptor instead')
const AuthorizedKey$json = {
  '1': 'AuthorizedKey',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'key_type', '3': 2, '4': 1, '5': 9, '10': 'keyType'},
    {'1': 'fingerprint', '3': 3, '4': 1, '5': 9, '10': 'fingerprint'},
    {'1': 'comment', '3': 4, '4': 1, '5': 9, '10': 'comment'},
    {'1': 'public_key', '3': 5, '4': 1, '5': 9, '10': 'publicKey'},
    {'1': 'options', '3': 6, '4': 3, '5': 9, '10': 'options'},
    {'1': 'line_number', '3': 7, '4': 1, '5': 5, '10': 'lineNumber'},
  ],
};

/// Descriptor for `AuthorizedKey`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List authorizedKeyDescriptor = $convert.base64Decode(
    'Cg1BdXRob3JpemVkS2V5Eg4KAmlkGAEgASgJUgJpZBIZCghrZXlfdHlwZRgCIAEoCVIHa2V5VH'
    'lwZRIgCgtmaW5nZXJwcmludBgDIAEoCVILZmluZ2VycHJpbnQSGAoHY29tbWVudBgEIAEoCVIH'
    'Y29tbWVudBIdCgpwdWJsaWNfa2V5GAUgASgJUglwdWJsaWNLZXkSGAoHb3B0aW9ucxgGIAMoCV'
    'IHb3B0aW9ucxIfCgtsaW5lX251bWJlchgHIAEoBVIKbGluZU51bWJlcg==');

@$core.Deprecated('Use listAuthorizedKeysRequestDescriptor instead')
const ListAuthorizedKeysRequest$json = {
  '1': 'ListAuthorizedKeysRequest',
  '2': [
    {
      '1': 'target',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.skeys.v1.Target',
      '10': 'target'
    },
    {'1': 'user', '3': 2, '4': 1, '5': 9, '10': 'user'},
  ],
};

/// Descriptor for `ListAuthorizedKeysRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAuthorizedKeysRequestDescriptor =
    $convert.base64Decode(
        'ChlMaXN0QXV0aG9yaXplZEtleXNSZXF1ZXN0EigKBnRhcmdldBgBIAEoCzIQLnNrZXlzLnYxLl'
        'RhcmdldFIGdGFyZ2V0EhIKBHVzZXIYAiABKAlSBHVzZXI=');

@$core.Deprecated('Use watchAuthorizedKeysRequestDescriptor instead')
const WatchAuthorizedKeysRequest$json = {
  '1': 'WatchAuthorizedKeysRequest',
  '2': [
    {
      '1': 'target',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.skeys.v1.Target',
      '10': 'target'
    },
    {'1': 'user', '3': 2, '4': 1, '5': 9, '10': 'user'},
  ],
};

/// Descriptor for `WatchAuthorizedKeysRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchAuthorizedKeysRequestDescriptor =
    $convert.base64Decode(
        'ChpXYXRjaEF1dGhvcml6ZWRLZXlzUmVxdWVzdBIoCgZ0YXJnZXQYASABKAsyEC5za2V5cy52MS'
        '5UYXJnZXRSBnRhcmdldBISCgR1c2VyGAIgASgJUgR1c2Vy');

@$core.Deprecated('Use listAuthorizedKeysResponseDescriptor instead')
const ListAuthorizedKeysResponse$json = {
  '1': 'ListAuthorizedKeysResponse',
  '2': [
    {
      '1': 'keys',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.skeys.v1.AuthorizedKey',
      '10': 'keys'
    },
  ],
};

/// Descriptor for `ListAuthorizedKeysResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAuthorizedKeysResponseDescriptor =
    $convert.base64Decode(
        'ChpMaXN0QXV0aG9yaXplZEtleXNSZXNwb25zZRIrCgRrZXlzGAEgAygLMhcuc2tleXMudjEuQX'
        'V0aG9yaXplZEtleVIEa2V5cw==');

@$core.Deprecated('Use addAuthorizedKeyRequestDescriptor instead')
const AddAuthorizedKeyRequest$json = {
  '1': 'AddAuthorizedKeyRequest',
  '2': [
    {
      '1': 'target',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.skeys.v1.Target',
      '10': 'target'
    },
    {'1': 'public_key', '3': 2, '4': 1, '5': 9, '10': 'publicKey'},
    {'1': 'options', '3': 3, '4': 3, '5': 9, '10': 'options'},
    {'1': 'user', '3': 4, '4': 1, '5': 9, '10': 'user'},
  ],
};

/// Descriptor for `AddAuthorizedKeyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addAuthorizedKeyRequestDescriptor = $convert.base64Decode(
    'ChdBZGRBdXRob3JpemVkS2V5UmVxdWVzdBIoCgZ0YXJnZXQYASABKAsyEC5za2V5cy52MS5UYX'
    'JnZXRSBnRhcmdldBIdCgpwdWJsaWNfa2V5GAIgASgJUglwdWJsaWNLZXkSGAoHb3B0aW9ucxgD'
    'IAMoCVIHb3B0aW9ucxISCgR1c2VyGAQgASgJUgR1c2Vy');

@$core.Deprecated('Use updateAuthorizedKeyRequestDescriptor instead')
const UpdateAuthorizedKeyRequest$json = {
  '1': 'UpdateAuthorizedKeyRequest',
  '2': [
    {
      '1': 'target',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.skeys.v1.Target',
      '10': 'target'
    },
    {'1': 'key_id', '3': 2, '4': 1, '5': 9, '10': 'keyId'},
    {'1': 'options', '3': 3, '4': 3, '5': 9, '10': 'options'},
    {'1': 'comment', '3': 4, '4': 1, '5': 9, '10': 'comment'},
  ],
};

/// Descriptor for `UpdateAuthorizedKeyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateAuthorizedKeyRequestDescriptor =
    $convert.base64Decode(
        'ChpVcGRhdGVBdXRob3JpemVkS2V5UmVxdWVzdBIoCgZ0YXJnZXQYASABKAsyEC5za2V5cy52MS'
        '5UYXJnZXRSBnRhcmdldBIVCgZrZXlfaWQYAiABKAlSBWtleUlkEhgKB29wdGlvbnMYAyADKAlS'
        'B29wdGlvbnMSGAoHY29tbWVudBgEIAEoCVIHY29tbWVudA==');

@$core.Deprecated('Use removeAuthorizedKeyRequestDescriptor instead')
const RemoveAuthorizedKeyRequest$json = {
  '1': 'RemoveAuthorizedKeyRequest',
  '2': [
    {
      '1': 'target',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.skeys.v1.Target',
      '10': 'target'
    },
    {'1': 'key_id', '3': 2, '4': 1, '5': 9, '10': 'keyId'},
    {'1': 'user', '3': 3, '4': 1, '5': 9, '10': 'user'},
  ],
};

/// Descriptor for `RemoveAuthorizedKeyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List removeAuthorizedKeyRequestDescriptor =
    $convert.base64Decode(
        'ChpSZW1vdmVBdXRob3JpemVkS2V5UmVxdWVzdBIoCgZ0YXJnZXQYASABKAsyEC5za2V5cy52MS'
        '5UYXJnZXRSBnRhcmdldBIVCgZrZXlfaWQYAiABKAlSBWtleUlkEhIKBHVzZXIYAyABKAlSBHVz'
        'ZXI=');
