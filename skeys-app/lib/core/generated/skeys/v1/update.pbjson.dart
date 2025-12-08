// This is a generated file - do not edit.
//
// Generated from skeys/v1/update.proto.

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

@$core.Deprecated('Use downloadStateDescriptor instead')
const DownloadState$json = {
  '1': 'DownloadState',
  '2': [
    {'1': 'DOWNLOAD_STATE_UNSPECIFIED', '2': 0},
    {'1': 'DOWNLOAD_STATE_STARTING', '2': 1},
    {'1': 'DOWNLOAD_STATE_DOWNLOADING', '2': 2},
    {'1': 'DOWNLOAD_STATE_VERIFYING', '2': 3},
    {'1': 'DOWNLOAD_STATE_COMPLETED', '2': 4},
    {'1': 'DOWNLOAD_STATE_ERROR', '2': 5},
  ],
};

/// Descriptor for `DownloadState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List downloadStateDescriptor = $convert.base64Decode(
    'Cg1Eb3dubG9hZFN0YXRlEh4KGkRPV05MT0FEX1NUQVRFX1VOU1BFQ0lGSUVEEAASGwoXRE9XTk'
    'xPQURfU1RBVEVfU1RBUlRJTkcQARIeChpET1dOTE9BRF9TVEFURV9ET1dOTE9BRElORxACEhwK'
    'GERPV05MT0FEX1NUQVRFX1ZFUklGWUlORxADEhwKGERPV05MT0FEX1NUQVRFX0NPTVBMRVRFRB'
    'AEEhgKFERPV05MT0FEX1NUQVRFX0VSUk9SEAU=');

@$core.Deprecated('Use updateStateDescriptor instead')
const UpdateState$json = {
  '1': 'UpdateState',
  '2': [
    {'1': 'UPDATE_STATE_UNSPECIFIED', '2': 0},
    {'1': 'UPDATE_STATE_IDLE', '2': 1},
    {'1': 'UPDATE_STATE_CHECKING', '2': 2},
    {'1': 'UPDATE_STATE_UPDATE_AVAILABLE', '2': 3},
    {'1': 'UPDATE_STATE_DOWNLOADING', '2': 4},
    {'1': 'UPDATE_STATE_READY_TO_APPLY', '2': 5},
    {'1': 'UPDATE_STATE_APPLYING', '2': 6},
    {'1': 'UPDATE_STATE_ERROR', '2': 7},
  ],
};

/// Descriptor for `UpdateState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List updateStateDescriptor = $convert.base64Decode(
    'CgtVcGRhdGVTdGF0ZRIcChhVUERBVEVfU1RBVEVfVU5TUEVDSUZJRUQQABIVChFVUERBVEVfU1'
    'RBVEVfSURMRRABEhkKFVVQREFURV9TVEFURV9DSEVDS0lORxACEiEKHVVQREFURV9TVEFURV9V'
    'UERBVEVfQVZBSUxBQkxFEAMSHAoYVVBEQVRFX1NUQVRFX0RPV05MT0FESU5HEAQSHwobVVBEQV'
    'RFX1NUQVRFX1JFQURZX1RPX0FQUExZEAUSGQoVVVBEQVRFX1NUQVRFX0FQUExZSU5HEAYSFgoS'
    'VVBEQVRFX1NUQVRFX0VSUk9SEAc=');

@$core.Deprecated('Use updateInfoDescriptor instead')
const UpdateInfo$json = {
  '1': 'UpdateInfo',
  '2': [
    {'1': 'update_available', '3': 1, '4': 1, '5': 8, '10': 'updateAvailable'},
    {'1': 'current_version', '3': 2, '4': 1, '5': 9, '10': 'currentVersion'},
    {'1': 'latest_version', '3': 3, '4': 1, '5': 9, '10': 'latestVersion'},
    {'1': 'release_url', '3': 4, '4': 1, '5': 9, '10': 'releaseUrl'},
    {'1': 'release_notes', '3': 5, '4': 1, '5': 9, '10': 'releaseNotes'},
    {'1': 'download_size', '3': 6, '4': 1, '5': 3, '10': 'downloadSize'},
    {
      '1': 'published_at',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'publishedAt'
    },
    {'1': 'prerelease', '3': 8, '4': 1, '5': 8, '10': 'prerelease'},
  ],
};

/// Descriptor for `UpdateInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateInfoDescriptor = $convert.base64Decode(
    'CgpVcGRhdGVJbmZvEikKEHVwZGF0ZV9hdmFpbGFibGUYASABKAhSD3VwZGF0ZUF2YWlsYWJsZR'
    'InCg9jdXJyZW50X3ZlcnNpb24YAiABKAlSDmN1cnJlbnRWZXJzaW9uEiUKDmxhdGVzdF92ZXJz'
    'aW9uGAMgASgJUg1sYXRlc3RWZXJzaW9uEh8KC3JlbGVhc2VfdXJsGAQgASgJUgpyZWxlYXNlVX'
    'JsEiMKDXJlbGVhc2Vfbm90ZXMYBSABKAlSDHJlbGVhc2VOb3RlcxIjCg1kb3dubG9hZF9zaXpl'
    'GAYgASgDUgxkb3dubG9hZFNpemUSPQoMcHVibGlzaGVkX2F0GAcgASgLMhouZ29vZ2xlLnByb3'
    'RvYnVmLlRpbWVzdGFtcFILcHVibGlzaGVkQXQSHgoKcHJlcmVsZWFzZRgIIAEoCFIKcHJlcmVs'
    'ZWFzZQ==');

@$core.Deprecated('Use downloadUpdateRequestDescriptor instead')
const DownloadUpdateRequest$json = {
  '1': 'DownloadUpdateRequest',
  '2': [
    {'1': 'version', '3': 1, '4': 1, '5': 9, '10': 'version'},
  ],
};

/// Descriptor for `DownloadUpdateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List downloadUpdateRequestDescriptor =
    $convert.base64Decode(
        'ChVEb3dubG9hZFVwZGF0ZVJlcXVlc3QSGAoHdmVyc2lvbhgBIAEoCVIHdmVyc2lvbg==');

@$core.Deprecated('Use downloadProgressDescriptor instead')
const DownloadProgress$json = {
  '1': 'DownloadProgress',
  '2': [
    {
      '1': 'state',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.skeys.v1.DownloadState',
      '10': 'state'
    },
    {'1': 'bytes_downloaded', '3': 2, '4': 1, '5': 3, '10': 'bytesDownloaded'},
    {'1': 'total_bytes', '3': 3, '4': 1, '5': 3, '10': 'totalBytes'},
    {'1': 'bytes_per_second', '3': 4, '4': 1, '5': 3, '10': 'bytesPerSecond'},
    {'1': 'error', '3': 5, '4': 1, '5': 9, '10': 'error'},
    {'1': 'downloaded_path', '3': 6, '4': 1, '5': 9, '10': 'downloadedPath'},
  ],
};

/// Descriptor for `DownloadProgress`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List downloadProgressDescriptor = $convert.base64Decode(
    'ChBEb3dubG9hZFByb2dyZXNzEi0KBXN0YXRlGAEgASgOMhcuc2tleXMudjEuRG93bmxvYWRTdG'
    'F0ZVIFc3RhdGUSKQoQYnl0ZXNfZG93bmxvYWRlZBgCIAEoA1IPYnl0ZXNEb3dubG9hZGVkEh8K'
    'C3RvdGFsX2J5dGVzGAMgASgDUgp0b3RhbEJ5dGVzEigKEGJ5dGVzX3Blcl9zZWNvbmQYBCABKA'
    'NSDmJ5dGVzUGVyU2Vjb25kEhQKBWVycm9yGAUgASgJUgVlcnJvchInCg9kb3dubG9hZGVkX3Bh'
    'dGgYBiABKAlSDmRvd25sb2FkZWRQYXRo');

@$core.Deprecated('Use applyUpdateRequestDescriptor instead')
const ApplyUpdateRequest$json = {
  '1': 'ApplyUpdateRequest',
  '2': [
    {'1': 'tarball_path', '3': 1, '4': 1, '5': 9, '10': 'tarballPath'},
    {'1': 'force', '3': 2, '4': 1, '5': 8, '10': 'force'},
  ],
};

/// Descriptor for `ApplyUpdateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List applyUpdateRequestDescriptor = $convert.base64Decode(
    'ChJBcHBseVVwZGF0ZVJlcXVlc3QSIQoMdGFyYmFsbF9wYXRoGAEgASgJUgt0YXJiYWxsUGF0aB'
    'IUCgVmb3JjZRgCIAEoCFIFZm9yY2U=');

@$core.Deprecated('Use applyUpdateResponseDescriptor instead')
const ApplyUpdateResponse$json = {
  '1': 'ApplyUpdateResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'error', '3': 2, '4': 1, '5': 9, '10': 'error'},
    {'1': 'restart_required', '3': 3, '4': 1, '5': 8, '10': 'restartRequired'},
    {'1': 'new_version', '3': 4, '4': 1, '5': 9, '10': 'newVersion'},
  ],
};

/// Descriptor for `ApplyUpdateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List applyUpdateResponseDescriptor = $convert.base64Decode(
    'ChNBcHBseVVwZGF0ZVJlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2Nlc3MSFAoFZXJyb3'
    'IYAiABKAlSBWVycm9yEikKEHJlc3RhcnRfcmVxdWlyZWQYAyABKAhSD3Jlc3RhcnRSZXF1aXJl'
    'ZBIfCgtuZXdfdmVyc2lvbhgEIAEoCVIKbmV3VmVyc2lvbg==');

@$core.Deprecated('Use updateSettingsDescriptor instead')
const UpdateSettings$json = {
  '1': 'UpdateSettings',
  '2': [
    {'1': 'auto_check', '3': 1, '4': 1, '5': 8, '10': 'autoCheck'},
    {'1': 'auto_download', '3': 2, '4': 1, '5': 8, '10': 'autoDownload'},
    {'1': 'auto_apply', '3': 3, '4': 1, '5': 8, '10': 'autoApply'},
    {
      '1': 'include_prereleases',
      '3': 4,
      '4': 1,
      '5': 8,
      '10': 'includePrereleases'
    },
    {
      '1': 'check_interval_hours',
      '3': 5,
      '4': 1,
      '5': 5,
      '10': 'checkIntervalHours'
    },
    {'1': 'include_patches', '3': 6, '4': 1, '5': 8, '10': 'includePatches'},
  ],
};

/// Descriptor for `UpdateSettings`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateSettingsDescriptor = $convert.base64Decode(
    'Cg5VcGRhdGVTZXR0aW5ncxIdCgphdXRvX2NoZWNrGAEgASgIUglhdXRvQ2hlY2sSIwoNYXV0b1'
    '9kb3dubG9hZBgCIAEoCFIMYXV0b0Rvd25sb2FkEh0KCmF1dG9fYXBwbHkYAyABKAhSCWF1dG9B'
    'cHBseRIvChNpbmNsdWRlX3ByZXJlbGVhc2VzGAQgASgIUhJpbmNsdWRlUHJlcmVsZWFzZXMSMA'
    'oUY2hlY2tfaW50ZXJ2YWxfaG91cnMYBSABKAVSEmNoZWNrSW50ZXJ2YWxIb3VycxInCg9pbmNs'
    'dWRlX3BhdGNoZXMYBiABKAhSDmluY2x1ZGVQYXRjaGVz');

@$core.Deprecated('Use updateStatusDescriptor instead')
const UpdateStatus$json = {
  '1': 'UpdateStatus',
  '2': [
    {
      '1': 'state',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.skeys.v1.UpdateState',
      '10': 'state'
    },
    {
      '1': 'available_update',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.skeys.v1.UpdateInfo',
      '10': 'availableUpdate'
    },
    {
      '1': 'download_progress',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.skeys.v1.DownloadProgress',
      '10': 'downloadProgress'
    },
    {
      '1': 'last_check',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'lastCheck'
    },
    {'1': 'error', '3': 5, '4': 1, '5': 9, '10': 'error'},
  ],
};

/// Descriptor for `UpdateStatus`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateStatusDescriptor = $convert.base64Decode(
    'CgxVcGRhdGVTdGF0dXMSKwoFc3RhdGUYASABKA4yFS5za2V5cy52MS5VcGRhdGVTdGF0ZVIFc3'
    'RhdGUSPwoQYXZhaWxhYmxlX3VwZGF0ZRgCIAEoCzIULnNrZXlzLnYxLlVwZGF0ZUluZm9SD2F2'
    'YWlsYWJsZVVwZGF0ZRJHChFkb3dubG9hZF9wcm9ncmVzcxgDIAEoCzIaLnNrZXlzLnYxLkRvd2'
    '5sb2FkUHJvZ3Jlc3NSEGRvd25sb2FkUHJvZ3Jlc3MSOQoKbGFzdF9jaGVjaxgEIAEoCzIaLmdv'
    'b2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCWxhc3RDaGVjaxIUCgVlcnJvchgFIAEoCVIFZXJyb3'
    'I=');
