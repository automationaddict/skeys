// This is a generated file - do not edit.
//
// Generated from skeys/v1/system.proto.

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

@$core.Deprecated('Use serviceStateDescriptor instead')
const ServiceState$json = {
  '1': 'ServiceState',
  '2': [
    {'1': 'SERVICE_STATE_UNSPECIFIED', '2': 0},
    {'1': 'SERVICE_STATE_RUNNING', '2': 1},
    {'1': 'SERVICE_STATE_STOPPED', '2': 2},
    {'1': 'SERVICE_STATE_FAILED', '2': 3},
    {'1': 'SERVICE_STATE_NOT_FOUND', '2': 4},
    {'1': 'SERVICE_STATE_UNKNOWN', '2': 5},
  ],
};

/// Descriptor for `ServiceState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List serviceStateDescriptor = $convert.base64Decode(
    'CgxTZXJ2aWNlU3RhdGUSHQoZU0VSVklDRV9TVEFURV9VTlNQRUNJRklFRBAAEhkKFVNFUlZJQ0'
    'VfU1RBVEVfUlVOTklORxABEhkKFVNFUlZJQ0VfU1RBVEVfU1RPUFBFRBACEhgKFFNFUlZJQ0Vf'
    'U1RBVEVfRkFJTEVEEAMSGwoXU0VSVklDRV9TVEFURV9OT1RfRk9VTkQQBBIZChVTRVJWSUNFX1'
    'NUQVRFX1VOS05PV04QBQ==');

@$core.Deprecated('Use sSHComponentDescriptor instead')
const SSHComponent$json = {
  '1': 'SSHComponent',
  '2': [
    {'1': 'SSH_COMPONENT_UNSPECIFIED', '2': 0},
    {'1': 'SSH_COMPONENT_CLIENT', '2': 1},
    {'1': 'SSH_COMPONENT_SERVER', '2': 2},
  ],
};

/// Descriptor for `SSHComponent`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List sSHComponentDescriptor = $convert.base64Decode(
    'CgxTU0hDb21wb25lbnQSHQoZU1NIX0NPTVBPTkVOVF9VTlNQRUNJRklFRBAAEhgKFFNTSF9DT0'
    '1QT05FTlRfQ0xJRU5UEAESGAoUU1NIX0NPTVBPTkVOVF9TRVJWRVIQAg==');

@$core.Deprecated('Use getSSHStatusRequestDescriptor instead')
const GetSSHStatusRequest$json = {
  '1': 'GetSSHStatusRequest',
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

/// Descriptor for `GetSSHStatusRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSSHStatusRequestDescriptor = $convert.base64Decode(
    'ChNHZXRTU0hTdGF0dXNSZXF1ZXN0EigKBnRhcmdldBgBIAEoCzIQLnNrZXlzLnYxLlRhcmdldF'
    'IGdGFyZ2V0');

@$core.Deprecated('Use getSSHStatusResponseDescriptor instead')
const GetSSHStatusResponse$json = {
  '1': 'GetSSHStatusResponse',
  '2': [
    {'1': 'distribution', '3': 1, '4': 1, '5': 9, '10': 'distribution'},
    {
      '1': 'distribution_version',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'distributionVersion'
    },
    {
      '1': 'client',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.skeys.v1.SSHClientStatus',
      '10': 'client'
    },
    {
      '1': 'server',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.skeys.v1.SSHServerStatus',
      '10': 'server'
    },
  ],
};

/// Descriptor for `GetSSHStatusResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSSHStatusResponseDescriptor = $convert.base64Decode(
    'ChRHZXRTU0hTdGF0dXNSZXNwb25zZRIiCgxkaXN0cmlidXRpb24YASABKAlSDGRpc3RyaWJ1dG'
    'lvbhIxChRkaXN0cmlidXRpb25fdmVyc2lvbhgCIAEoCVITZGlzdHJpYnV0aW9uVmVyc2lvbhIx'
    'CgZjbGllbnQYAyABKAsyGS5za2V5cy52MS5TU0hDbGllbnRTdGF0dXNSBmNsaWVudBIxCgZzZX'
    'J2ZXIYBCABKAsyGS5za2V5cy52MS5TU0hTZXJ2ZXJTdGF0dXNSBnNlcnZlcg==');

@$core.Deprecated('Use sSHClientStatusDescriptor instead')
const SSHClientStatus$json = {
  '1': 'SSHClientStatus',
  '2': [
    {'1': 'installed', '3': 1, '4': 1, '5': 8, '10': 'installed'},
    {'1': 'version', '3': 2, '4': 1, '5': 9, '10': 'version'},
    {'1': 'binary_path', '3': 3, '4': 1, '5': 9, '10': 'binaryPath'},
    {
      '1': 'system_config',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.skeys.v1.ConfigPathInfo',
      '10': 'systemConfig'
    },
    {
      '1': 'user_config',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.skeys.v1.ConfigPathInfo',
      '10': 'userConfig'
    },
  ],
};

/// Descriptor for `SSHClientStatus`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sSHClientStatusDescriptor = $convert.base64Decode(
    'Cg9TU0hDbGllbnRTdGF0dXMSHAoJaW5zdGFsbGVkGAEgASgIUglpbnN0YWxsZWQSGAoHdmVyc2'
    'lvbhgCIAEoCVIHdmVyc2lvbhIfCgtiaW5hcnlfcGF0aBgDIAEoCVIKYmluYXJ5UGF0aBI9Cg1z'
    'eXN0ZW1fY29uZmlnGAQgASgLMhguc2tleXMudjEuQ29uZmlnUGF0aEluZm9SDHN5c3RlbUNvbm'
    'ZpZxI5Cgt1c2VyX2NvbmZpZxgFIAEoCzIYLnNrZXlzLnYxLkNvbmZpZ1BhdGhJbmZvUgp1c2Vy'
    'Q29uZmln');

@$core.Deprecated('Use sSHServerStatusDescriptor instead')
const SSHServerStatus$json = {
  '1': 'SSHServerStatus',
  '2': [
    {'1': 'installed', '3': 1, '4': 1, '5': 8, '10': 'installed'},
    {'1': 'version', '3': 2, '4': 1, '5': 9, '10': 'version'},
    {'1': 'binary_path', '3': 3, '4': 1, '5': 9, '10': 'binaryPath'},
    {
      '1': 'service',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.skeys.v1.ServiceStatus',
      '10': 'service'
    },
    {
      '1': 'config',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.skeys.v1.ConfigPathInfo',
      '10': 'config'
    },
  ],
};

/// Descriptor for `SSHServerStatus`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sSHServerStatusDescriptor = $convert.base64Decode(
    'Cg9TU0hTZXJ2ZXJTdGF0dXMSHAoJaW5zdGFsbGVkGAEgASgIUglpbnN0YWxsZWQSGAoHdmVyc2'
    'lvbhgCIAEoCVIHdmVyc2lvbhIfCgtiaW5hcnlfcGF0aBgDIAEoCVIKYmluYXJ5UGF0aBIxCgdz'
    'ZXJ2aWNlGAQgASgLMhcuc2tleXMudjEuU2VydmljZVN0YXR1c1IHc2VydmljZRIwCgZjb25maW'
    'cYBSABKAsyGC5za2V5cy52MS5Db25maWdQYXRoSW5mb1IGY29uZmln');

@$core.Deprecated('Use serviceStatusDescriptor instead')
const ServiceStatus$json = {
  '1': 'ServiceStatus',
  '2': [
    {
      '1': 'state',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.skeys.v1.ServiceState',
      '10': 'state'
    },
    {'1': 'enabled', '3': 2, '4': 1, '5': 8, '10': 'enabled'},
    {'1': 'active_state', '3': 3, '4': 1, '5': 9, '10': 'activeState'},
    {'1': 'sub_state', '3': 4, '4': 1, '5': 9, '10': 'subState'},
    {'1': 'load_state', '3': 5, '4': 1, '5': 9, '10': 'loadState'},
    {'1': 'pid', '3': 6, '4': 1, '5': 3, '10': 'pid'},
    {'1': 'started_at', '3': 7, '4': 1, '5': 9, '10': 'startedAt'},
    {'1': 'service_name', '3': 8, '4': 1, '5': 9, '10': 'serviceName'},
  ],
};

/// Descriptor for `ServiceStatus`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serviceStatusDescriptor = $convert.base64Decode(
    'Cg1TZXJ2aWNlU3RhdHVzEiwKBXN0YXRlGAEgASgOMhYuc2tleXMudjEuU2VydmljZVN0YXRlUg'
    'VzdGF0ZRIYCgdlbmFibGVkGAIgASgIUgdlbmFibGVkEiEKDGFjdGl2ZV9zdGF0ZRgDIAEoCVIL'
    'YWN0aXZlU3RhdGUSGwoJc3ViX3N0YXRlGAQgASgJUghzdWJTdGF0ZRIdCgpsb2FkX3N0YXRlGA'
    'UgASgJUglsb2FkU3RhdGUSEAoDcGlkGAYgASgDUgNwaWQSHQoKc3RhcnRlZF9hdBgHIAEoCVIJ'
    'c3RhcnRlZEF0EiEKDHNlcnZpY2VfbmFtZRgIIAEoCVILc2VydmljZU5hbWU=');

@$core.Deprecated('Use getSSHServiceStatusRequestDescriptor instead')
const GetSSHServiceStatusRequest$json = {
  '1': 'GetSSHServiceStatusRequest',
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

/// Descriptor for `GetSSHServiceStatusRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSSHServiceStatusRequestDescriptor =
    $convert.base64Decode(
        'ChpHZXRTU0hTZXJ2aWNlU3RhdHVzUmVxdWVzdBIoCgZ0YXJnZXQYASABKAsyEC5za2V5cy52MS'
        '5UYXJnZXRSBnRhcmdldA==');

@$core.Deprecated('Use getSSHServiceStatusResponseDescriptor instead')
const GetSSHServiceStatusResponse$json = {
  '1': 'GetSSHServiceStatusResponse',
  '2': [
    {
      '1': 'status',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.skeys.v1.ServiceStatus',
      '10': 'status'
    },
  ],
};

/// Descriptor for `GetSSHServiceStatusResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSSHServiceStatusResponseDescriptor =
    $convert.base64Decode(
        'ChtHZXRTU0hTZXJ2aWNlU3RhdHVzUmVzcG9uc2USLwoGc3RhdHVzGAEgASgLMhcuc2tleXMudj'
        'EuU2VydmljZVN0YXR1c1IGc3RhdHVz');

@$core.Deprecated('Use startSSHServiceRequestDescriptor instead')
const StartSSHServiceRequest$json = {
  '1': 'StartSSHServiceRequest',
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

/// Descriptor for `StartSSHServiceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startSSHServiceRequestDescriptor =
    $convert.base64Decode(
        'ChZTdGFydFNTSFNlcnZpY2VSZXF1ZXN0EigKBnRhcmdldBgBIAEoCzIQLnNrZXlzLnYxLlRhcm'
        'dldFIGdGFyZ2V0');

@$core.Deprecated('Use stopSSHServiceRequestDescriptor instead')
const StopSSHServiceRequest$json = {
  '1': 'StopSSHServiceRequest',
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

/// Descriptor for `StopSSHServiceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stopSSHServiceRequestDescriptor = $convert.base64Decode(
    'ChVTdG9wU1NIU2VydmljZVJlcXVlc3QSKAoGdGFyZ2V0GAEgASgLMhAuc2tleXMudjEuVGFyZ2'
    'V0UgZ0YXJnZXQ=');

@$core.Deprecated('Use restartSSHServiceWithStatusRequestDescriptor instead')
const RestartSSHServiceWithStatusRequest$json = {
  '1': 'RestartSSHServiceWithStatusRequest',
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

/// Descriptor for `RestartSSHServiceWithStatusRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List restartSSHServiceWithStatusRequestDescriptor =
    $convert.base64Decode(
        'CiJSZXN0YXJ0U1NIU2VydmljZVdpdGhTdGF0dXNSZXF1ZXN0EigKBnRhcmdldBgBIAEoCzIQLn'
        'NrZXlzLnYxLlRhcmdldFIGdGFyZ2V0');

@$core.Deprecated('Use reloadSSHServiceRequestDescriptor instead')
const ReloadSSHServiceRequest$json = {
  '1': 'ReloadSSHServiceRequest',
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

/// Descriptor for `ReloadSSHServiceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reloadSSHServiceRequestDescriptor =
    $convert.base64Decode(
        'ChdSZWxvYWRTU0hTZXJ2aWNlUmVxdWVzdBIoCgZ0YXJnZXQYASABKAsyEC5za2V5cy52MS5UYX'
        'JnZXRSBnRhcmdldA==');

@$core.Deprecated('Use enableSSHServiceRequestDescriptor instead')
const EnableSSHServiceRequest$json = {
  '1': 'EnableSSHServiceRequest',
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

/// Descriptor for `EnableSSHServiceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List enableSSHServiceRequestDescriptor =
    $convert.base64Decode(
        'ChdFbmFibGVTU0hTZXJ2aWNlUmVxdWVzdBIoCgZ0YXJnZXQYASABKAsyEC5za2V5cy52MS5UYX'
        'JnZXRSBnRhcmdldA==');

@$core.Deprecated('Use disableSSHServiceRequestDescriptor instead')
const DisableSSHServiceRequest$json = {
  '1': 'DisableSSHServiceRequest',
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

/// Descriptor for `DisableSSHServiceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List disableSSHServiceRequestDescriptor =
    $convert.base64Decode(
        'ChhEaXNhYmxlU1NIU2VydmljZVJlcXVlc3QSKAoGdGFyZ2V0GAEgASgLMhAuc2tleXMudjEuVG'
        'FyZ2V0UgZ0YXJnZXQ=');

@$core.Deprecated('Use sSHServiceControlResponseDescriptor instead')
const SSHServiceControlResponse$json = {
  '1': 'SSHServiceControlResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    {
      '1': 'status',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.skeys.v1.ServiceStatus',
      '10': 'status'
    },
  ],
};

/// Descriptor for `SSHServiceControlResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sSHServiceControlResponseDescriptor = $convert.base64Decode(
    'ChlTU0hTZXJ2aWNlQ29udHJvbFJlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2Nlc3MSGA'
    'oHbWVzc2FnZRgCIAEoCVIHbWVzc2FnZRIvCgZzdGF0dXMYAyABKAsyFy5za2V5cy52MS5TZXJ2'
    'aWNlU3RhdHVzUgZzdGF0dXM=');

@$core.Deprecated('Use getInstallInstructionsRequestDescriptor instead')
const GetInstallInstructionsRequest$json = {
  '1': 'GetInstallInstructionsRequest',
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
      '1': 'component',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.skeys.v1.SSHComponent',
      '10': 'component'
    },
  ],
};

/// Descriptor for `GetInstallInstructionsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getInstallInstructionsRequestDescriptor =
    $convert.base64Decode(
        'Ch1HZXRJbnN0YWxsSW5zdHJ1Y3Rpb25zUmVxdWVzdBIoCgZ0YXJnZXQYASABKAsyEC5za2V5cy'
        '52MS5UYXJnZXRSBnRhcmdldBI0Cgljb21wb25lbnQYAiABKA4yFi5za2V5cy52MS5TU0hDb21w'
        'b25lbnRSCWNvbXBvbmVudA==');

@$core.Deprecated('Use getInstallInstructionsResponseDescriptor instead')
const GetInstallInstructionsResponse$json = {
  '1': 'GetInstallInstructionsResponse',
  '2': [
    {'1': 'distribution', '3': 1, '4': 1, '5': 9, '10': 'distribution'},
    {
      '1': 'component',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.skeys.v1.SSHComponent',
      '10': 'component'
    },
    {'1': 'package_name', '3': 3, '4': 1, '5': 9, '10': 'packageName'},
    {'1': 'install_command', '3': 4, '4': 1, '5': 9, '10': 'installCommand'},
    {
      '1': 'documentation_url',
      '3': 5,
      '4': 1,
      '5': 9,
      '10': 'documentationUrl'
    },
    {'1': 'steps', '3': 6, '4': 3, '5': 9, '10': 'steps'},
  ],
};

/// Descriptor for `GetInstallInstructionsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getInstallInstructionsResponseDescriptor = $convert.base64Decode(
    'Ch5HZXRJbnN0YWxsSW5zdHJ1Y3Rpb25zUmVzcG9uc2USIgoMZGlzdHJpYnV0aW9uGAEgASgJUg'
    'xkaXN0cmlidXRpb24SNAoJY29tcG9uZW50GAIgASgOMhYuc2tleXMudjEuU1NIQ29tcG9uZW50'
    'Ugljb21wb25lbnQSIQoMcGFja2FnZV9uYW1lGAMgASgJUgtwYWNrYWdlTmFtZRInCg9pbnN0YW'
    'xsX2NvbW1hbmQYBCABKAlSDmluc3RhbGxDb21tYW5kEisKEWRvY3VtZW50YXRpb25fdXJsGAUg'
    'ASgJUhBkb2N1bWVudGF0aW9uVXJsEhQKBXN0ZXBzGAYgAygJUgVzdGVwcw==');
