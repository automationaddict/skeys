// This is a generated file - do not edit.
//
// Generated from skeys/v1/config.proto.

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

@$core.Deprecated('Use hostConfigDescriptor instead')
const HostConfig$json = {
  '1': 'HostConfig',
  '2': [
    {'1': 'alias', '3': 1, '4': 1, '5': 9, '10': 'alias'},
    {'1': 'hostname', '3': 2, '4': 1, '5': 9, '10': 'hostname'},
    {'1': 'user', '3': 3, '4': 1, '5': 9, '10': 'user'},
    {'1': 'port', '3': 4, '4': 1, '5': 5, '10': 'port'},
    {'1': 'identity_files', '3': 5, '4': 3, '5': 9, '10': 'identityFiles'},
    {'1': 'proxy_jump', '3': 6, '4': 1, '5': 9, '10': 'proxyJump'},
    {'1': 'proxy_command', '3': 7, '4': 1, '5': 9, '10': 'proxyCommand'},
    {'1': 'forward_agent', '3': 8, '4': 1, '5': 8, '10': 'forwardAgent'},
    {'1': 'identities_only', '3': 9, '4': 1, '5': 8, '10': 'identitiesOnly'},
    {
      '1': 'strict_host_key_checking',
      '3': 10,
      '4': 1,
      '5': 9,
      '10': 'strictHostKeyChecking'
    },
    {
      '1': 'server_alive_interval',
      '3': 11,
      '4': 1,
      '5': 5,
      '10': 'serverAliveInterval'
    },
    {
      '1': 'server_alive_count_max',
      '3': 12,
      '4': 1,
      '5': 5,
      '10': 'serverAliveCountMax'
    },
    {
      '1': 'extra_options',
      '3': 13,
      '4': 3,
      '5': 11,
      '6': '.skeys.v1.HostConfig.ExtraOptionsEntry',
      '10': 'extraOptions'
    },
    {'1': 'is_pattern', '3': 14, '4': 1, '5': 8, '10': 'isPattern'},
    {'1': 'line_number', '3': 15, '4': 1, '5': 5, '10': 'lineNumber'},
  ],
  '3': [HostConfig_ExtraOptionsEntry$json],
};

@$core.Deprecated('Use hostConfigDescriptor instead')
const HostConfig_ExtraOptionsEntry$json = {
  '1': 'ExtraOptionsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `HostConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List hostConfigDescriptor = $convert.base64Decode(
    'CgpIb3N0Q29uZmlnEhQKBWFsaWFzGAEgASgJUgVhbGlhcxIaCghob3N0bmFtZRgCIAEoCVIIaG'
    '9zdG5hbWUSEgoEdXNlchgDIAEoCVIEdXNlchISCgRwb3J0GAQgASgFUgRwb3J0EiUKDmlkZW50'
    'aXR5X2ZpbGVzGAUgAygJUg1pZGVudGl0eUZpbGVzEh0KCnByb3h5X2p1bXAYBiABKAlSCXByb3'
    'h5SnVtcBIjCg1wcm94eV9jb21tYW5kGAcgASgJUgxwcm94eUNvbW1hbmQSIwoNZm9yd2FyZF9h'
    'Z2VudBgIIAEoCFIMZm9yd2FyZEFnZW50EicKD2lkZW50aXRpZXNfb25seRgJIAEoCFIOaWRlbn'
    'RpdGllc09ubHkSNwoYc3RyaWN0X2hvc3Rfa2V5X2NoZWNraW5nGAogASgJUhVzdHJpY3RIb3N0'
    'S2V5Q2hlY2tpbmcSMgoVc2VydmVyX2FsaXZlX2ludGVydmFsGAsgASgFUhNzZXJ2ZXJBbGl2ZU'
    'ludGVydmFsEjMKFnNlcnZlcl9hbGl2ZV9jb3VudF9tYXgYDCABKAVSE3NlcnZlckFsaXZlQ291'
    'bnRNYXgSSwoNZXh0cmFfb3B0aW9ucxgNIAMoCzImLnNrZXlzLnYxLkhvc3RDb25maWcuRXh0cm'
    'FPcHRpb25zRW50cnlSDGV4dHJhT3B0aW9ucxIdCgppc19wYXR0ZXJuGA4gASgIUglpc1BhdHRl'
    'cm4SHwoLbGluZV9udW1iZXIYDyABKAVSCmxpbmVOdW1iZXIaPwoRRXh0cmFPcHRpb25zRW50cn'
    'kSEAoDa2V5GAEgASgJUgNrZXkSFAoFdmFsdWUYAiABKAlSBXZhbHVlOgI4AQ==');

@$core.Deprecated('Use listHostConfigsRequestDescriptor instead')
const ListHostConfigsRequest$json = {
  '1': 'ListHostConfigsRequest',
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

/// Descriptor for `ListHostConfigsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listHostConfigsRequestDescriptor =
    $convert.base64Decode(
        'ChZMaXN0SG9zdENvbmZpZ3NSZXF1ZXN0EigKBnRhcmdldBgBIAEoCzIQLnNrZXlzLnYxLlRhcm'
        'dldFIGdGFyZ2V0');

@$core.Deprecated('Use listHostConfigsResponseDescriptor instead')
const ListHostConfigsResponse$json = {
  '1': 'ListHostConfigsResponse',
  '2': [
    {
      '1': 'hosts',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.skeys.v1.HostConfig',
      '10': 'hosts'
    },
  ],
};

/// Descriptor for `ListHostConfigsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listHostConfigsResponseDescriptor =
    $convert.base64Decode(
        'ChdMaXN0SG9zdENvbmZpZ3NSZXNwb25zZRIqCgVob3N0cxgBIAMoCzIULnNrZXlzLnYxLkhvc3'
        'RDb25maWdSBWhvc3Rz');

@$core.Deprecated('Use getHostConfigRequestDescriptor instead')
const GetHostConfigRequest$json = {
  '1': 'GetHostConfigRequest',
  '2': [
    {
      '1': 'target',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.skeys.v1.Target',
      '10': 'target'
    },
    {'1': 'alias', '3': 2, '4': 1, '5': 9, '10': 'alias'},
  ],
};

/// Descriptor for `GetHostConfigRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getHostConfigRequestDescriptor = $convert.base64Decode(
    'ChRHZXRIb3N0Q29uZmlnUmVxdWVzdBIoCgZ0YXJnZXQYASABKAsyEC5za2V5cy52MS5UYXJnZX'
    'RSBnRhcmdldBIUCgVhbGlhcxgCIAEoCVIFYWxpYXM=');

@$core.Deprecated('Use createHostConfigRequestDescriptor instead')
const CreateHostConfigRequest$json = {
  '1': 'CreateHostConfigRequest',
  '2': [
    {
      '1': 'target',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.skeys.v1.Target',
      '10': 'target'
    },
    {
      '1': 'config',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.skeys.v1.HostConfig',
      '10': 'config'
    },
  ],
};

/// Descriptor for `CreateHostConfigRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createHostConfigRequestDescriptor = $convert.base64Decode(
    'ChdDcmVhdGVIb3N0Q29uZmlnUmVxdWVzdBIoCgZ0YXJnZXQYASABKAsyEC5za2V5cy52MS5UYX'
    'JnZXRSBnRhcmdldBIsCgZjb25maWcYAiABKAsyFC5za2V5cy52MS5Ib3N0Q29uZmlnUgZjb25m'
    'aWc=');

@$core.Deprecated('Use updateHostConfigRequestDescriptor instead')
const UpdateHostConfigRequest$json = {
  '1': 'UpdateHostConfigRequest',
  '2': [
    {
      '1': 'target',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.skeys.v1.Target',
      '10': 'target'
    },
    {'1': 'alias', '3': 2, '4': 1, '5': 9, '10': 'alias'},
    {
      '1': 'config',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.skeys.v1.HostConfig',
      '10': 'config'
    },
  ],
};

/// Descriptor for `UpdateHostConfigRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateHostConfigRequestDescriptor = $convert.base64Decode(
    'ChdVcGRhdGVIb3N0Q29uZmlnUmVxdWVzdBIoCgZ0YXJnZXQYASABKAsyEC5za2V5cy52MS5UYX'
    'JnZXRSBnRhcmdldBIUCgVhbGlhcxgCIAEoCVIFYWxpYXMSLAoGY29uZmlnGAMgASgLMhQuc2tl'
    'eXMudjEuSG9zdENvbmZpZ1IGY29uZmln');

@$core.Deprecated('Use deleteHostConfigRequestDescriptor instead')
const DeleteHostConfigRequest$json = {
  '1': 'DeleteHostConfigRequest',
  '2': [
    {
      '1': 'target',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.skeys.v1.Target',
      '10': 'target'
    },
    {'1': 'alias', '3': 2, '4': 1, '5': 9, '10': 'alias'},
  ],
};

/// Descriptor for `DeleteHostConfigRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteHostConfigRequestDescriptor =
    $convert.base64Decode(
        'ChdEZWxldGVIb3N0Q29uZmlnUmVxdWVzdBIoCgZ0YXJnZXQYASABKAsyEC5za2V5cy52MS5UYX'
        'JnZXRSBnRhcmdldBIUCgVhbGlhcxgCIAEoCVIFYWxpYXM=');

@$core.Deprecated('Use testConnectionRequestDescriptor instead')
const TestConnectionRequest$json = {
  '1': 'TestConnectionRequest',
  '2': [
    {
      '1': 'target',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.skeys.v1.Target',
      '10': 'target'
    },
    {'1': 'alias', '3': 2, '4': 1, '5': 9, '10': 'alias'},
    {'1': 'timeout_seconds', '3': 3, '4': 1, '5': 5, '10': 'timeoutSeconds'},
  ],
};

/// Descriptor for `TestConnectionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List testConnectionRequestDescriptor = $convert.base64Decode(
    'ChVUZXN0Q29ubmVjdGlvblJlcXVlc3QSKAoGdGFyZ2V0GAEgASgLMhAuc2tleXMudjEuVGFyZ2'
    'V0UgZ0YXJnZXQSFAoFYWxpYXMYAiABKAlSBWFsaWFzEicKD3RpbWVvdXRfc2Vjb25kcxgDIAEo'
    'BVIOdGltZW91dFNlY29uZHM=');

@$core.Deprecated('Use testConnectionResponseDescriptor instead')
const TestConnectionResponse$json = {
  '1': 'TestConnectionResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    {'1': 'server_version', '3': 3, '4': 1, '5': 9, '10': 'serverVersion'},
    {'1': 'latency_ms', '3': 4, '4': 1, '5': 5, '10': 'latencyMs'},
  ],
};

/// Descriptor for `TestConnectionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List testConnectionResponseDescriptor = $convert.base64Decode(
    'ChZUZXN0Q29ubmVjdGlvblJlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2Nlc3MSGAoHbW'
    'Vzc2FnZRgCIAEoCVIHbWVzc2FnZRIlCg5zZXJ2ZXJfdmVyc2lvbhgDIAEoCVINc2VydmVyVmVy'
    'c2lvbhIdCgpsYXRlbmN5X21zGAQgASgFUglsYXRlbmN5TXM=');

@$core.Deprecated('Use serverConfigDescriptor instead')
const ServerConfig$json = {
  '1': 'ServerConfig',
  '2': [
    {
      '1': 'directives',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.skeys.v1.ServerConfigDirective',
      '10': 'directives'
    },
    {'1': 'raw_content', '3': 2, '4': 1, '5': 9, '10': 'rawContent'},
  ],
};

/// Descriptor for `ServerConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serverConfigDescriptor = $convert.base64Decode(
    'CgxTZXJ2ZXJDb25maWcSPwoKZGlyZWN0aXZlcxgBIAMoCzIfLnNrZXlzLnYxLlNlcnZlckNvbm'
    'ZpZ0RpcmVjdGl2ZVIKZGlyZWN0aXZlcxIfCgtyYXdfY29udGVudBgCIAEoCVIKcmF3Q29udGVu'
    'dA==');

@$core.Deprecated('Use serverConfigDirectiveDescriptor instead')
const ServerConfigDirective$json = {
  '1': 'ServerConfigDirective',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
    {'1': 'line_number', '3': 3, '4': 1, '5': 5, '10': 'lineNumber'},
    {'1': 'is_commented', '3': 4, '4': 1, '5': 8, '10': 'isCommented'},
    {'1': 'match_block', '3': 5, '4': 1, '5': 9, '10': 'matchBlock'},
  ],
};

/// Descriptor for `ServerConfigDirective`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serverConfigDirectiveDescriptor = $convert.base64Decode(
    'ChVTZXJ2ZXJDb25maWdEaXJlY3RpdmUSEAoDa2V5GAEgASgJUgNrZXkSFAoFdmFsdWUYAiABKA'
    'lSBXZhbHVlEh8KC2xpbmVfbnVtYmVyGAMgASgFUgpsaW5lTnVtYmVyEiEKDGlzX2NvbW1lbnRl'
    'ZBgEIAEoCFILaXNDb21tZW50ZWQSHwoLbWF0Y2hfYmxvY2sYBSABKAlSCm1hdGNoQmxvY2s=');

@$core.Deprecated('Use getServerConfigRequestDescriptor instead')
const GetServerConfigRequest$json = {
  '1': 'GetServerConfigRequest',
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

/// Descriptor for `GetServerConfigRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getServerConfigRequestDescriptor =
    $convert.base64Decode(
        'ChZHZXRTZXJ2ZXJDb25maWdSZXF1ZXN0EigKBnRhcmdldBgBIAEoCzIQLnNrZXlzLnYxLlRhcm'
        'dldFIGdGFyZ2V0');

@$core.Deprecated('Use updateServerConfigRequestDescriptor instead')
const UpdateServerConfigRequest$json = {
  '1': 'UpdateServerConfigRequest',
  '2': [
    {
      '1': 'target',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.skeys.v1.Target',
      '10': 'target'
    },
    {
      '1': 'updates',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.skeys.v1.ServerConfigUpdate',
      '10': 'updates'
    },
  ],
};

/// Descriptor for `UpdateServerConfigRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateServerConfigRequestDescriptor = $convert.base64Decode(
    'ChlVcGRhdGVTZXJ2ZXJDb25maWdSZXF1ZXN0EigKBnRhcmdldBgBIAEoCzIQLnNrZXlzLnYxLl'
    'RhcmdldFIGdGFyZ2V0EjYKB3VwZGF0ZXMYAiADKAsyHC5za2V5cy52MS5TZXJ2ZXJDb25maWdV'
    'cGRhdGVSB3VwZGF0ZXM=');

@$core.Deprecated('Use serverConfigUpdateDescriptor instead')
const ServerConfigUpdate$json = {
  '1': 'ServerConfigUpdate',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
    {'1': 'delete', '3': 3, '4': 1, '5': 8, '10': 'delete'},
  ],
};

/// Descriptor for `ServerConfigUpdate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serverConfigUpdateDescriptor = $convert.base64Decode(
    'ChJTZXJ2ZXJDb25maWdVcGRhdGUSEAoDa2V5GAEgASgJUgNrZXkSFAoFdmFsdWUYAiABKAlSBX'
    'ZhbHVlEhYKBmRlbGV0ZRgDIAEoCFIGZGVsZXRl');

@$core.Deprecated('Use validateServerConfigRequestDescriptor instead')
const ValidateServerConfigRequest$json = {
  '1': 'ValidateServerConfigRequest',
  '2': [
    {
      '1': 'target',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.skeys.v1.Target',
      '10': 'target'
    },
    {'1': 'content', '3': 2, '4': 1, '5': 9, '10': 'content'},
  ],
};

/// Descriptor for `ValidateServerConfigRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List validateServerConfigRequestDescriptor =
    $convert.base64Decode(
        'ChtWYWxpZGF0ZVNlcnZlckNvbmZpZ1JlcXVlc3QSKAoGdGFyZ2V0GAEgASgLMhAuc2tleXMudj'
        'EuVGFyZ2V0UgZ0YXJnZXQSGAoHY29udGVudBgCIAEoCVIHY29udGVudA==');

@$core.Deprecated('Use validateServerConfigResponseDescriptor instead')
const ValidateServerConfigResponse$json = {
  '1': 'ValidateServerConfigResponse',
  '2': [
    {'1': 'valid', '3': 1, '4': 1, '5': 8, '10': 'valid'},
    {'1': 'error_message', '3': 2, '4': 1, '5': 9, '10': 'errorMessage'},
  ],
};

/// Descriptor for `ValidateServerConfigResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List validateServerConfigResponseDescriptor =
    $convert.base64Decode(
        'ChxWYWxpZGF0ZVNlcnZlckNvbmZpZ1Jlc3BvbnNlEhQKBXZhbGlkGAEgASgIUgV2YWxpZBIjCg'
        '1lcnJvcl9tZXNzYWdlGAIgASgJUgxlcnJvck1lc3NhZ2U=');

@$core.Deprecated('Use restartSSHServiceRequestDescriptor instead')
const RestartSSHServiceRequest$json = {
  '1': 'RestartSSHServiceRequest',
  '2': [
    {
      '1': 'target',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.skeys.v1.Target',
      '10': 'target'
    },
    {'1': 'reload_only', '3': 2, '4': 1, '5': 8, '10': 'reloadOnly'},
  ],
};

/// Descriptor for `RestartSSHServiceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List restartSSHServiceRequestDescriptor =
    $convert.base64Decode(
        'ChhSZXN0YXJ0U1NIU2VydmljZVJlcXVlc3QSKAoGdGFyZ2V0GAEgASgLMhAuc2tleXMudjEuVG'
        'FyZ2V0UgZ0YXJnZXQSHwoLcmVsb2FkX29ubHkYAiABKAhSCnJlbG9hZE9ubHk=');

@$core.Deprecated('Use restartSSHServiceResponseDescriptor instead')
const RestartSSHServiceResponse$json = {
  '1': 'RestartSSHServiceResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `RestartSSHServiceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List restartSSHServiceResponseDescriptor =
    $convert.base64Decode(
        'ChlSZXN0YXJ0U1NIU2VydmljZVJlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2Nlc3MSGA'
        'oHbWVzc2FnZRgCIAEoCVIHbWVzc2FnZQ==');

@$core.Deprecated('Use getSshConfigStatusRequestDescriptor instead')
const GetSshConfigStatusRequest$json = {
  '1': 'GetSshConfigStatusRequest',
};

/// Descriptor for `GetSshConfigStatusRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSshConfigStatusRequestDescriptor =
    $convert.base64Decode('ChlHZXRTc2hDb25maWdTdGF0dXNSZXF1ZXN0');

@$core.Deprecated('Use getSshConfigStatusResponseDescriptor instead')
const GetSshConfigStatusResponse$json = {
  '1': 'GetSshConfigStatusResponse',
  '2': [
    {'1': 'enabled', '3': 1, '4': 1, '5': 8, '10': 'enabled'},
    {'1': 'agent_socket', '3': 2, '4': 1, '5': 9, '10': 'agentSocket'},
  ],
};

/// Descriptor for `GetSshConfigStatusResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSshConfigStatusResponseDescriptor =
    $convert.base64Decode(
        'ChpHZXRTc2hDb25maWdTdGF0dXNSZXNwb25zZRIYCgdlbmFibGVkGAEgASgIUgdlbmFibGVkEi'
        'EKDGFnZW50X3NvY2tldBgCIAEoCVILYWdlbnRTb2NrZXQ=');

@$core.Deprecated('Use enableSshConfigRequestDescriptor instead')
const EnableSshConfigRequest$json = {
  '1': 'EnableSshConfigRequest',
};

/// Descriptor for `EnableSshConfigRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List enableSshConfigRequestDescriptor =
    $convert.base64Decode('ChZFbmFibGVTc2hDb25maWdSZXF1ZXN0');

@$core.Deprecated('Use enableSshConfigResponseDescriptor instead')
const EnableSshConfigResponse$json = {
  '1': 'EnableSshConfigResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `EnableSshConfigResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List enableSshConfigResponseDescriptor =
    $convert.base64Decode(
        'ChdFbmFibGVTc2hDb25maWdSZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZXNzEhgKB2'
        '1lc3NhZ2UYAiABKAlSB21lc3NhZ2U=');

@$core.Deprecated('Use disableSshConfigRequestDescriptor instead')
const DisableSshConfigRequest$json = {
  '1': 'DisableSshConfigRequest',
};

/// Descriptor for `DisableSshConfigRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List disableSshConfigRequestDescriptor =
    $convert.base64Decode('ChdEaXNhYmxlU3NoQ29uZmlnUmVxdWVzdA==');

@$core.Deprecated('Use disableSshConfigResponseDescriptor instead')
const DisableSshConfigResponse$json = {
  '1': 'DisableSshConfigResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `DisableSshConfigResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List disableSshConfigResponseDescriptor =
    $convert.base64Decode(
        'ChhEaXNhYmxlU3NoQ29uZmlnUmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2VzcxIYCg'
        'dtZXNzYWdlGAIgASgJUgdtZXNzYWdl');
