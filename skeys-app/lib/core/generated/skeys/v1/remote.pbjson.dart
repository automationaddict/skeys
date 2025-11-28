// This is a generated file - do not edit.
//
// Generated from skeys/v1/remote.proto.

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

@$core.Deprecated('Use remoteStatusDescriptor instead')
const RemoteStatus$json = {
  '1': 'RemoteStatus',
  '2': [
    {'1': 'REMOTE_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'REMOTE_STATUS_DISCONNECTED', '2': 1},
    {'1': 'REMOTE_STATUS_CONNECTING', '2': 2},
    {'1': 'REMOTE_STATUS_CONNECTED', '2': 3},
    {'1': 'REMOTE_STATUS_ERROR', '2': 4},
  ],
};

/// Descriptor for `RemoteStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List remoteStatusDescriptor = $convert.base64Decode(
    'CgxSZW1vdGVTdGF0dXMSHQoZUkVNT1RFX1NUQVRVU19VTlNQRUNJRklFRBAAEh4KGlJFTU9URV'
    '9TVEFUVVNfRElTQ09OTkVDVEVEEAESHAoYUkVNT1RFX1NUQVRVU19DT05ORUNUSU5HEAISGwoX'
    'UkVNT1RFX1NUQVRVU19DT05ORUNURUQQAxIXChNSRU1PVEVfU1RBVFVTX0VSUk9SEAQ=');

@$core.Deprecated('Use hostKeyStatusDescriptor instead')
const HostKeyStatus$json = {
  '1': 'HostKeyStatus',
  '2': [
    {'1': 'HOST_KEY_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'HOST_KEY_STATUS_VERIFIED', '2': 1},
    {'1': 'HOST_KEY_STATUS_UNKNOWN', '2': 2},
    {'1': 'HOST_KEY_STATUS_MISMATCH', '2': 3},
    {'1': 'HOST_KEY_STATUS_ADDED', '2': 4},
  ],
};

/// Descriptor for `HostKeyStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List hostKeyStatusDescriptor = $convert.base64Decode(
    'Cg1Ib3N0S2V5U3RhdHVzEh8KG0hPU1RfS0VZX1NUQVRVU19VTlNQRUNJRklFRBAAEhwKGEhPU1'
    'RfS0VZX1NUQVRVU19WRVJJRklFRBABEhsKF0hPU1RfS0VZX1NUQVRVU19VTktOT1dOEAISHAoY'
    'SE9TVF9LRVlfU1RBVFVTX01JU01BVENIEAMSGQoVSE9TVF9LRVlfU1RBVFVTX0FEREVEEAQ=');

@$core.Deprecated('Use remoteDescriptor instead')
const Remote$json = {
  '1': 'Remote',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'host', '3': 3, '4': 1, '5': 9, '10': 'host'},
    {'1': 'port', '3': 4, '4': 1, '5': 5, '10': 'port'},
    {'1': 'user', '3': 5, '4': 1, '5': 9, '10': 'user'},
    {'1': 'identity_file', '3': 6, '4': 1, '5': 9, '10': 'identityFile'},
    {'1': 'ssh_config_alias', '3': 7, '4': 1, '5': 9, '10': 'sshConfigAlias'},
    {
      '1': 'created_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'last_connected_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'lastConnectedAt'
    },
    {
      '1': 'status',
      '3': 10,
      '4': 1,
      '5': 14,
      '6': '.skeys.v1.RemoteStatus',
      '10': 'status'
    },
  ],
};

/// Descriptor for `Remote`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List remoteDescriptor = $convert.base64Decode(
    'CgZSZW1vdGUSDgoCaWQYASABKAlSAmlkEhIKBG5hbWUYAiABKAlSBG5hbWUSEgoEaG9zdBgDIA'
    'EoCVIEaG9zdBISCgRwb3J0GAQgASgFUgRwb3J0EhIKBHVzZXIYBSABKAlSBHVzZXISIwoNaWRl'
    'bnRpdHlfZmlsZRgGIAEoCVIMaWRlbnRpdHlGaWxlEigKEHNzaF9jb25maWdfYWxpYXMYByABKA'
    'lSDnNzaENvbmZpZ0FsaWFzEjkKCmNyZWF0ZWRfYXQYCCABKAsyGi5nb29nbGUucHJvdG9idWYu'
    'VGltZXN0YW1wUgljcmVhdGVkQXQSRgoRbGFzdF9jb25uZWN0ZWRfYXQYCSABKAsyGi5nb29nbG'
    'UucHJvdG9idWYuVGltZXN0YW1wUg9sYXN0Q29ubmVjdGVkQXQSLgoGc3RhdHVzGAogASgOMhYu'
    'c2tleXMudjEuUmVtb3RlU3RhdHVzUgZzdGF0dXM=');

@$core.Deprecated('Use connectionDescriptor instead')
const Connection$json = {
  '1': 'Connection',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'remote_id', '3': 2, '4': 1, '5': 9, '10': 'remoteId'},
    {'1': 'host', '3': 3, '4': 1, '5': 9, '10': 'host'},
    {'1': 'port', '3': 4, '4': 1, '5': 5, '10': 'port'},
    {'1': 'user', '3': 5, '4': 1, '5': 9, '10': 'user'},
    {'1': 'server_version', '3': 6, '4': 1, '5': 9, '10': 'serverVersion'},
    {
      '1': 'connected_at',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'connectedAt'
    },
    {
      '1': 'last_activity_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'lastActivityAt'
    },
  ],
};

/// Descriptor for `Connection`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List connectionDescriptor = $convert.base64Decode(
    'CgpDb25uZWN0aW9uEg4KAmlkGAEgASgJUgJpZBIbCglyZW1vdGVfaWQYAiABKAlSCHJlbW90ZU'
    'lkEhIKBGhvc3QYAyABKAlSBGhvc3QSEgoEcG9ydBgEIAEoBVIEcG9ydBISCgR1c2VyGAUgASgJ'
    'UgR1c2VyEiUKDnNlcnZlcl92ZXJzaW9uGAYgASgJUg1zZXJ2ZXJWZXJzaW9uEj0KDGNvbm5lY3'
    'RlZF9hdBgHIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSC2Nvbm5lY3RlZEF0EkQK'
    'EGxhc3RfYWN0aXZpdHlfYXQYCCABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUg5sYX'
    'N0QWN0aXZpdHlBdA==');

@$core.Deprecated('Use listRemotesRequestDescriptor instead')
const ListRemotesRequest$json = {
  '1': 'ListRemotesRequest',
};

/// Descriptor for `ListRemotesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listRemotesRequestDescriptor =
    $convert.base64Decode('ChJMaXN0UmVtb3Rlc1JlcXVlc3Q=');

@$core.Deprecated('Use listRemotesResponseDescriptor instead')
const ListRemotesResponse$json = {
  '1': 'ListRemotesResponse',
  '2': [
    {
      '1': 'remotes',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.skeys.v1.Remote',
      '10': 'remotes'
    },
  ],
};

/// Descriptor for `ListRemotesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listRemotesResponseDescriptor = $convert.base64Decode(
    'ChNMaXN0UmVtb3Rlc1Jlc3BvbnNlEioKB3JlbW90ZXMYASADKAsyEC5za2V5cy52MS5SZW1vdG'
    'VSB3JlbW90ZXM=');

@$core.Deprecated('Use getRemoteRequestDescriptor instead')
const GetRemoteRequest$json = {
  '1': 'GetRemoteRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `GetRemoteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRemoteRequestDescriptor =
    $convert.base64Decode('ChBHZXRSZW1vdGVSZXF1ZXN0Eg4KAmlkGAEgASgJUgJpZA==');

@$core.Deprecated('Use addRemoteRequestDescriptor instead')
const AddRemoteRequest$json = {
  '1': 'AddRemoteRequest',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'host', '3': 2, '4': 1, '5': 9, '10': 'host'},
    {'1': 'port', '3': 3, '4': 1, '5': 5, '10': 'port'},
    {'1': 'user', '3': 4, '4': 1, '5': 9, '10': 'user'},
    {'1': 'identity_file', '3': 5, '4': 1, '5': 9, '10': 'identityFile'},
    {'1': 'ssh_config_alias', '3': 6, '4': 1, '5': 9, '10': 'sshConfigAlias'},
  ],
};

/// Descriptor for `AddRemoteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addRemoteRequestDescriptor = $convert.base64Decode(
    'ChBBZGRSZW1vdGVSZXF1ZXN0EhIKBG5hbWUYASABKAlSBG5hbWUSEgoEaG9zdBgCIAEoCVIEaG'
    '9zdBISCgRwb3J0GAMgASgFUgRwb3J0EhIKBHVzZXIYBCABKAlSBHVzZXISIwoNaWRlbnRpdHlf'
    'ZmlsZRgFIAEoCVIMaWRlbnRpdHlGaWxlEigKEHNzaF9jb25maWdfYWxpYXMYBiABKAlSDnNzaE'
    'NvbmZpZ0FsaWFz');

@$core.Deprecated('Use updateRemoteRequestDescriptor instead')
const UpdateRemoteRequest$json = {
  '1': 'UpdateRemoteRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'host', '3': 3, '4': 1, '5': 9, '10': 'host'},
    {'1': 'port', '3': 4, '4': 1, '5': 5, '10': 'port'},
    {'1': 'user', '3': 5, '4': 1, '5': 9, '10': 'user'},
    {'1': 'identity_file', '3': 6, '4': 1, '5': 9, '10': 'identityFile'},
    {'1': 'ssh_config_alias', '3': 7, '4': 1, '5': 9, '10': 'sshConfigAlias'},
  ],
};

/// Descriptor for `UpdateRemoteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateRemoteRequestDescriptor = $convert.base64Decode(
    'ChNVcGRhdGVSZW1vdGVSZXF1ZXN0Eg4KAmlkGAEgASgJUgJpZBISCgRuYW1lGAIgASgJUgRuYW'
    '1lEhIKBGhvc3QYAyABKAlSBGhvc3QSEgoEcG9ydBgEIAEoBVIEcG9ydBISCgR1c2VyGAUgASgJ'
    'UgR1c2VyEiMKDWlkZW50aXR5X2ZpbGUYBiABKAlSDGlkZW50aXR5RmlsZRIoChBzc2hfY29uZm'
    'lnX2FsaWFzGAcgASgJUg5zc2hDb25maWdBbGlhcw==');

@$core.Deprecated('Use deleteRemoteRequestDescriptor instead')
const DeleteRemoteRequest$json = {
  '1': 'DeleteRemoteRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `DeleteRemoteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteRemoteRequestDescriptor = $convert
    .base64Decode('ChNEZWxldGVSZW1vdGVSZXF1ZXN0Eg4KAmlkGAEgASgJUgJpZA==');

@$core.Deprecated('Use testRemoteConnectionRequestDescriptor instead')
const TestRemoteConnectionRequest$json = {
  '1': 'TestRemoteConnectionRequest',
  '2': [
    {'1': 'remote_id', '3': 1, '4': 1, '5': 9, '10': 'remoteId'},
    {'1': 'host', '3': 2, '4': 1, '5': 9, '10': 'host'},
    {'1': 'port', '3': 3, '4': 1, '5': 5, '10': 'port'},
    {'1': 'user', '3': 4, '4': 1, '5': 9, '10': 'user'},
    {'1': 'identity_file', '3': 5, '4': 1, '5': 9, '10': 'identityFile'},
    {'1': 'timeout_seconds', '3': 6, '4': 1, '5': 5, '10': 'timeoutSeconds'},
    {'1': 'passphrase', '3': 7, '4': 1, '5': 9, '10': 'passphrase'},
    {'1': 'trust_host_key', '3': 8, '4': 1, '5': 8, '10': 'trustHostKey'},
  ],
};

/// Descriptor for `TestRemoteConnectionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List testRemoteConnectionRequestDescriptor = $convert.base64Decode(
    'ChtUZXN0UmVtb3RlQ29ubmVjdGlvblJlcXVlc3QSGwoJcmVtb3RlX2lkGAEgASgJUghyZW1vdG'
    'VJZBISCgRob3N0GAIgASgJUgRob3N0EhIKBHBvcnQYAyABKAVSBHBvcnQSEgoEdXNlchgEIAEo'
    'CVIEdXNlchIjCg1pZGVudGl0eV9maWxlGAUgASgJUgxpZGVudGl0eUZpbGUSJwoPdGltZW91dF'
    '9zZWNvbmRzGAYgASgFUg50aW1lb3V0U2Vjb25kcxIeCgpwYXNzcGhyYXNlGAcgASgJUgpwYXNz'
    'cGhyYXNlEiQKDnRydXN0X2hvc3Rfa2V5GAggASgIUgx0cnVzdEhvc3RLZXk=');

@$core.Deprecated('Use hostKeyInfoDescriptor instead')
const HostKeyInfo$json = {
  '1': 'HostKeyInfo',
  '2': [
    {'1': 'hostname', '3': 1, '4': 1, '5': 9, '10': 'hostname'},
    {'1': 'port', '3': 2, '4': 1, '5': 5, '10': 'port'},
    {'1': 'key_type', '3': 3, '4': 1, '5': 9, '10': 'keyType'},
    {'1': 'fingerprint', '3': 4, '4': 1, '5': 9, '10': 'fingerprint'},
    {'1': 'public_key', '3': 5, '4': 1, '5': 9, '10': 'publicKey'},
  ],
};

/// Descriptor for `HostKeyInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List hostKeyInfoDescriptor = $convert.base64Decode(
    'CgtIb3N0S2V5SW5mbxIaCghob3N0bmFtZRgBIAEoCVIIaG9zdG5hbWUSEgoEcG9ydBgCIAEoBV'
    'IEcG9ydBIZCghrZXlfdHlwZRgDIAEoCVIHa2V5VHlwZRIgCgtmaW5nZXJwcmludBgEIAEoCVIL'
    'ZmluZ2VycHJpbnQSHQoKcHVibGljX2tleRgFIAEoCVIJcHVibGljS2V5');

@$core.Deprecated('Use testRemoteConnectionResponseDescriptor instead')
const TestRemoteConnectionResponse$json = {
  '1': 'TestRemoteConnectionResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    {'1': 'server_version', '3': 3, '4': 1, '5': 9, '10': 'serverVersion'},
    {'1': 'latency_ms', '3': 4, '4': 1, '5': 5, '10': 'latencyMs'},
    {
      '1': 'host_key_status',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.skeys.v1.HostKeyStatus',
      '10': 'hostKeyStatus'
    },
    {
      '1': 'host_key_info',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.skeys.v1.HostKeyInfo',
      '10': 'hostKeyInfo'
    },
  ],
};

/// Descriptor for `TestRemoteConnectionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List testRemoteConnectionResponseDescriptor = $convert.base64Decode(
    'ChxUZXN0UmVtb3RlQ29ubmVjdGlvblJlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2Nlc3'
    'MSGAoHbWVzc2FnZRgCIAEoCVIHbWVzc2FnZRIlCg5zZXJ2ZXJfdmVyc2lvbhgDIAEoCVINc2Vy'
    'dmVyVmVyc2lvbhIdCgpsYXRlbmN5X21zGAQgASgFUglsYXRlbmN5TXMSPwoPaG9zdF9rZXlfc3'
    'RhdHVzGAUgASgOMhcuc2tleXMudjEuSG9zdEtleVN0YXR1c1INaG9zdEtleVN0YXR1cxI5Cg1o'
    'b3N0X2tleV9pbmZvGAYgASgLMhUuc2tleXMudjEuSG9zdEtleUluZm9SC2hvc3RLZXlJbmZv');

@$core.Deprecated('Use connectRequestDescriptor instead')
const ConnectRequest$json = {
  '1': 'ConnectRequest',
  '2': [
    {'1': 'remote_id', '3': 1, '4': 1, '5': 9, '10': 'remoteId'},
    {'1': 'passphrase', '3': 2, '4': 1, '5': 9, '10': 'passphrase'},
  ],
};

/// Descriptor for `ConnectRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List connectRequestDescriptor = $convert.base64Decode(
    'Cg5Db25uZWN0UmVxdWVzdBIbCglyZW1vdGVfaWQYASABKAlSCHJlbW90ZUlkEh4KCnBhc3NwaH'
    'Jhc2UYAiABKAlSCnBhc3NwaHJhc2U=');

@$core.Deprecated('Use connectResponseDescriptor instead')
const ConnectResponse$json = {
  '1': 'ConnectResponse',
  '2': [
    {
      '1': 'connection',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.skeys.v1.Connection',
      '10': 'connection'
    },
  ],
};

/// Descriptor for `ConnectResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List connectResponseDescriptor = $convert.base64Decode(
    'Cg9Db25uZWN0UmVzcG9uc2USNAoKY29ubmVjdGlvbhgBIAEoCzIULnNrZXlzLnYxLkNvbm5lY3'
    'Rpb25SCmNvbm5lY3Rpb24=');

@$core.Deprecated('Use disconnectRequestDescriptor instead')
const DisconnectRequest$json = {
  '1': 'DisconnectRequest',
  '2': [
    {'1': 'connection_id', '3': 1, '4': 1, '5': 9, '10': 'connectionId'},
  ],
};

/// Descriptor for `DisconnectRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List disconnectRequestDescriptor = $convert.base64Decode(
    'ChFEaXNjb25uZWN0UmVxdWVzdBIjCg1jb25uZWN0aW9uX2lkGAEgASgJUgxjb25uZWN0aW9uSW'
    'Q=');

@$core.Deprecated('Use listConnectionsRequestDescriptor instead')
const ListConnectionsRequest$json = {
  '1': 'ListConnectionsRequest',
};

/// Descriptor for `ListConnectionsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listConnectionsRequestDescriptor =
    $convert.base64Decode('ChZMaXN0Q29ubmVjdGlvbnNSZXF1ZXN0');

@$core.Deprecated('Use watchConnectionsRequestDescriptor instead')
const WatchConnectionsRequest$json = {
  '1': 'WatchConnectionsRequest',
};

/// Descriptor for `WatchConnectionsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchConnectionsRequestDescriptor =
    $convert.base64Decode('ChdXYXRjaENvbm5lY3Rpb25zUmVxdWVzdA==');

@$core.Deprecated('Use listConnectionsResponseDescriptor instead')
const ListConnectionsResponse$json = {
  '1': 'ListConnectionsResponse',
  '2': [
    {
      '1': 'connections',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.skeys.v1.Connection',
      '10': 'connections'
    },
  ],
};

/// Descriptor for `ListConnectionsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listConnectionsResponseDescriptor =
    $convert.base64Decode(
        'ChdMaXN0Q29ubmVjdGlvbnNSZXNwb25zZRI2Cgtjb25uZWN0aW9ucxgBIAMoCzIULnNrZXlzLn'
        'YxLkNvbm5lY3Rpb25SC2Nvbm5lY3Rpb25z');

@$core.Deprecated('Use executeCommandRequestDescriptor instead')
const ExecuteCommandRequest$json = {
  '1': 'ExecuteCommandRequest',
  '2': [
    {'1': 'connection_id', '3': 1, '4': 1, '5': 9, '10': 'connectionId'},
    {'1': 'command', '3': 2, '4': 1, '5': 9, '10': 'command'},
    {'1': 'timeout_seconds', '3': 3, '4': 1, '5': 5, '10': 'timeoutSeconds'},
  ],
};

/// Descriptor for `ExecuteCommandRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List executeCommandRequestDescriptor = $convert.base64Decode(
    'ChVFeGVjdXRlQ29tbWFuZFJlcXVlc3QSIwoNY29ubmVjdGlvbl9pZBgBIAEoCVIMY29ubmVjdG'
    'lvbklkEhgKB2NvbW1hbmQYAiABKAlSB2NvbW1hbmQSJwoPdGltZW91dF9zZWNvbmRzGAMgASgF'
    'Ug50aW1lb3V0U2Vjb25kcw==');

@$core.Deprecated('Use executeCommandResponseDescriptor instead')
const ExecuteCommandResponse$json = {
  '1': 'ExecuteCommandResponse',
  '2': [
    {'1': 'exit_code', '3': 1, '4': 1, '5': 5, '10': 'exitCode'},
    {'1': 'stdout', '3': 2, '4': 1, '5': 9, '10': 'stdout'},
    {'1': 'stderr', '3': 3, '4': 1, '5': 9, '10': 'stderr'},
  ],
};

/// Descriptor for `ExecuteCommandResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List executeCommandResponseDescriptor =
    $convert.base64Decode(
        'ChZFeGVjdXRlQ29tbWFuZFJlc3BvbnNlEhsKCWV4aXRfY29kZRgBIAEoBVIIZXhpdENvZGUSFg'
        'oGc3Rkb3V0GAIgASgJUgZzdGRvdXQSFgoGc3RkZXJyGAMgASgJUgZzdGRlcnI=');
