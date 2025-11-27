//
//  Generated code. Do not modify.
//  source: skeys/v1/agent.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use agentKeyDescriptor instead')
const AgentKey$json = {
  '1': 'AgentKey',
  '2': [
    {'1': 'fingerprint', '3': 1, '4': 1, '5': 9, '10': 'fingerprint'},
    {'1': 'comment', '3': 2, '4': 1, '5': 9, '10': 'comment'},
    {'1': 'type', '3': 3, '4': 1, '5': 9, '10': 'type'},
    {'1': 'bits', '3': 4, '4': 1, '5': 5, '10': 'bits'},
    {'1': 'has_lifetime', '3': 5, '4': 1, '5': 8, '10': 'hasLifetime'},
    {'1': 'lifetime_seconds', '3': 6, '4': 1, '5': 5, '10': 'lifetimeSeconds'},
    {'1': 'is_confirm', '3': 7, '4': 1, '5': 8, '10': 'isConfirm'},
  ],
};

/// Descriptor for `AgentKey`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List agentKeyDescriptor = $convert.base64Decode(
    'CghBZ2VudEtleRIgCgtmaW5nZXJwcmludBgBIAEoCVILZmluZ2VycHJpbnQSGAoHY29tbWVudB'
    'gCIAEoCVIHY29tbWVudBISCgR0eXBlGAMgASgJUgR0eXBlEhIKBGJpdHMYBCABKAVSBGJpdHMS'
    'IQoMaGFzX2xpZmV0aW1lGAUgASgIUgtoYXNMaWZldGltZRIpChBsaWZldGltZV9zZWNvbmRzGA'
    'YgASgFUg9saWZldGltZVNlY29uZHMSHQoKaXNfY29uZmlybRgHIAEoCFIJaXNDb25maXJt');

@$core.Deprecated('Use getAgentStatusRequestDescriptor instead')
const GetAgentStatusRequest$json = {
  '1': 'GetAgentStatusRequest',
  '2': [
    {'1': 'target', '3': 1, '4': 1, '5': 11, '6': '.skeys.v1.Target', '10': 'target'},
  ],
};

/// Descriptor for `GetAgentStatusRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAgentStatusRequestDescriptor = $convert.base64Decode(
    'ChVHZXRBZ2VudFN0YXR1c1JlcXVlc3QSKAoGdGFyZ2V0GAEgASgLMhAuc2tleXMudjEuVGFyZ2'
    'V0UgZ0YXJnZXQ=');

@$core.Deprecated('Use getAgentStatusResponseDescriptor instead')
const GetAgentStatusResponse$json = {
  '1': 'GetAgentStatusResponse',
  '2': [
    {'1': 'running', '3': 1, '4': 1, '5': 8, '10': 'running'},
    {'1': 'socket_path', '3': 2, '4': 1, '5': 9, '10': 'socketPath'},
    {'1': 'is_locked', '3': 3, '4': 1, '5': 8, '10': 'isLocked'},
    {'1': 'key_count', '3': 4, '4': 1, '5': 5, '10': 'keyCount'},
  ],
};

/// Descriptor for `GetAgentStatusResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAgentStatusResponseDescriptor = $convert.base64Decode(
    'ChZHZXRBZ2VudFN0YXR1c1Jlc3BvbnNlEhgKB3J1bm5pbmcYASABKAhSB3J1bm5pbmcSHwoLc2'
    '9ja2V0X3BhdGgYAiABKAlSCnNvY2tldFBhdGgSGwoJaXNfbG9ja2VkGAMgASgIUghpc0xvY2tl'
    'ZBIbCglrZXlfY291bnQYBCABKAVSCGtleUNvdW50');

@$core.Deprecated('Use listAgentKeysRequestDescriptor instead')
const ListAgentKeysRequest$json = {
  '1': 'ListAgentKeysRequest',
  '2': [
    {'1': 'target', '3': 1, '4': 1, '5': 11, '6': '.skeys.v1.Target', '10': 'target'},
  ],
};

/// Descriptor for `ListAgentKeysRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAgentKeysRequestDescriptor = $convert.base64Decode(
    'ChRMaXN0QWdlbnRLZXlzUmVxdWVzdBIoCgZ0YXJnZXQYASABKAsyEC5za2V5cy52MS5UYXJnZX'
    'RSBnRhcmdldA==');

@$core.Deprecated('Use listAgentKeysResponseDescriptor instead')
const ListAgentKeysResponse$json = {
  '1': 'ListAgentKeysResponse',
  '2': [
    {'1': 'keys', '3': 1, '4': 3, '5': 11, '6': '.skeys.v1.AgentKey', '10': 'keys'},
  ],
};

/// Descriptor for `ListAgentKeysResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAgentKeysResponseDescriptor = $convert.base64Decode(
    'ChVMaXN0QWdlbnRLZXlzUmVzcG9uc2USJgoEa2V5cxgBIAMoCzISLnNrZXlzLnYxLkFnZW50S2'
    'V5UgRrZXlz');

@$core.Deprecated('Use addKeyToAgentRequestDescriptor instead')
const AddKeyToAgentRequest$json = {
  '1': 'AddKeyToAgentRequest',
  '2': [
    {'1': 'target', '3': 1, '4': 1, '5': 11, '6': '.skeys.v1.Target', '10': 'target'},
    {'1': 'key_path', '3': 2, '4': 1, '5': 9, '10': 'keyPath'},
    {'1': 'passphrase', '3': 3, '4': 1, '5': 9, '10': 'passphrase'},
    {'1': 'lifetime', '3': 4, '4': 1, '5': 11, '6': '.google.protobuf.Duration', '10': 'lifetime'},
    {'1': 'confirm', '3': 5, '4': 1, '5': 8, '10': 'confirm'},
  ],
};

/// Descriptor for `AddKeyToAgentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addKeyToAgentRequestDescriptor = $convert.base64Decode(
    'ChRBZGRLZXlUb0FnZW50UmVxdWVzdBIoCgZ0YXJnZXQYASABKAsyEC5za2V5cy52MS5UYXJnZX'
    'RSBnRhcmdldBIZCghrZXlfcGF0aBgCIAEoCVIHa2V5UGF0aBIeCgpwYXNzcGhyYXNlGAMgASgJ'
    'UgpwYXNzcGhyYXNlEjUKCGxpZmV0aW1lGAQgASgLMhkuZ29vZ2xlLnByb3RvYnVmLkR1cmF0aW'
    '9uUghsaWZldGltZRIYCgdjb25maXJtGAUgASgIUgdjb25maXJt');

@$core.Deprecated('Use removeKeyFromAgentRequestDescriptor instead')
const RemoveKeyFromAgentRequest$json = {
  '1': 'RemoveKeyFromAgentRequest',
  '2': [
    {'1': 'target', '3': 1, '4': 1, '5': 11, '6': '.skeys.v1.Target', '10': 'target'},
    {'1': 'fingerprint', '3': 2, '4': 1, '5': 9, '10': 'fingerprint'},
  ],
};

/// Descriptor for `RemoveKeyFromAgentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List removeKeyFromAgentRequestDescriptor = $convert.base64Decode(
    'ChlSZW1vdmVLZXlGcm9tQWdlbnRSZXF1ZXN0EigKBnRhcmdldBgBIAEoCzIQLnNrZXlzLnYxLl'
    'RhcmdldFIGdGFyZ2V0EiAKC2ZpbmdlcnByaW50GAIgASgJUgtmaW5nZXJwcmludA==');

@$core.Deprecated('Use removeAllKeysFromAgentRequestDescriptor instead')
const RemoveAllKeysFromAgentRequest$json = {
  '1': 'RemoveAllKeysFromAgentRequest',
  '2': [
    {'1': 'target', '3': 1, '4': 1, '5': 11, '6': '.skeys.v1.Target', '10': 'target'},
  ],
};

/// Descriptor for `RemoveAllKeysFromAgentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List removeAllKeysFromAgentRequestDescriptor = $convert.base64Decode(
    'Ch1SZW1vdmVBbGxLZXlzRnJvbUFnZW50UmVxdWVzdBIoCgZ0YXJnZXQYASABKAsyEC5za2V5cy'
    '52MS5UYXJnZXRSBnRhcmdldA==');

@$core.Deprecated('Use lockAgentRequestDescriptor instead')
const LockAgentRequest$json = {
  '1': 'LockAgentRequest',
  '2': [
    {'1': 'target', '3': 1, '4': 1, '5': 11, '6': '.skeys.v1.Target', '10': 'target'},
    {'1': 'passphrase', '3': 2, '4': 1, '5': 9, '10': 'passphrase'},
  ],
};

/// Descriptor for `LockAgentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List lockAgentRequestDescriptor = $convert.base64Decode(
    'ChBMb2NrQWdlbnRSZXF1ZXN0EigKBnRhcmdldBgBIAEoCzIQLnNrZXlzLnYxLlRhcmdldFIGdG'
    'FyZ2V0Eh4KCnBhc3NwaHJhc2UYAiABKAlSCnBhc3NwaHJhc2U=');

@$core.Deprecated('Use unlockAgentRequestDescriptor instead')
const UnlockAgentRequest$json = {
  '1': 'UnlockAgentRequest',
  '2': [
    {'1': 'target', '3': 1, '4': 1, '5': 11, '6': '.skeys.v1.Target', '10': 'target'},
    {'1': 'passphrase', '3': 2, '4': 1, '5': 9, '10': 'passphrase'},
  ],
};

/// Descriptor for `UnlockAgentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List unlockAgentRequestDescriptor = $convert.base64Decode(
    'ChJVbmxvY2tBZ2VudFJlcXVlc3QSKAoGdGFyZ2V0GAEgASgLMhAuc2tleXMudjEuVGFyZ2V0Ug'
    'Z0YXJnZXQSHgoKcGFzc3BocmFzZRgCIAEoCVIKcGFzc3BocmFzZQ==');

