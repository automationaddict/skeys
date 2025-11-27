//
//  Generated code. Do not modify.
//  source: skeys/v1/keys.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use keyTypeDescriptor instead')
const KeyType$json = {
  '1': 'KeyType',
  '2': [
    {'1': 'KEY_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'KEY_TYPE_RSA', '2': 1},
    {'1': 'KEY_TYPE_ED25519', '2': 2},
    {'1': 'KEY_TYPE_ECDSA', '2': 3},
    {'1': 'KEY_TYPE_ED25519_SK', '2': 4},
    {'1': 'KEY_TYPE_ECDSA_SK', '2': 5},
  ],
};

/// Descriptor for `KeyType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List keyTypeDescriptor = $convert.base64Decode(
    'CgdLZXlUeXBlEhgKFEtFWV9UWVBFX1VOU1BFQ0lGSUVEEAASEAoMS0VZX1RZUEVfUlNBEAESFA'
    'oQS0VZX1RZUEVfRUQyNTUxORACEhIKDktFWV9UWVBFX0VDRFNBEAMSFwoTS0VZX1RZUEVfRUQy'
    'NTUxOV9TSxAEEhUKEUtFWV9UWVBFX0VDRFNBX1NLEAU=');

@$core.Deprecated('Use fingerprintAlgorithmDescriptor instead')
const FingerprintAlgorithm$json = {
  '1': 'FingerprintAlgorithm',
  '2': [
    {'1': 'FINGERPRINT_ALGORITHM_UNSPECIFIED', '2': 0},
    {'1': 'FINGERPRINT_ALGORITHM_SHA256', '2': 1},
    {'1': 'FINGERPRINT_ALGORITHM_MD5', '2': 2},
  ],
};

/// Descriptor for `FingerprintAlgorithm`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List fingerprintAlgorithmDescriptor = $convert.base64Decode(
    'ChRGaW5nZXJwcmludEFsZ29yaXRobRIlCiFGSU5HRVJQUklOVF9BTEdPUklUSE1fVU5TUEVDSU'
    'ZJRUQQABIgChxGSU5HRVJQUklOVF9BTEdPUklUSE1fU0hBMjU2EAESHQoZRklOR0VSUFJJTlRf'
    'QUxHT1JJVEhNX01ENRAC');

@$core.Deprecated('Use sSHKeyDescriptor instead')
const SSHKey$json = {
  '1': 'SSHKey',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'private_key_path', '3': 3, '4': 1, '5': 9, '10': 'privateKeyPath'},
    {'1': 'public_key_path', '3': 4, '4': 1, '5': 9, '10': 'publicKeyPath'},
    {'1': 'type', '3': 5, '4': 1, '5': 14, '6': '.skeys.v1.KeyType', '10': 'type'},
    {'1': 'bits', '3': 6, '4': 1, '5': 5, '10': 'bits'},
    {'1': 'comment', '3': 7, '4': 1, '5': 9, '10': 'comment'},
    {'1': 'fingerprint_sha256', '3': 8, '4': 1, '5': 9, '10': 'fingerprintSha256'},
    {'1': 'fingerprint_md5', '3': 9, '4': 1, '5': 9, '10': 'fingerprintMd5'},
    {'1': 'public_key', '3': 10, '4': 1, '5': 9, '10': 'publicKey'},
    {'1': 'has_passphrase', '3': 11, '4': 1, '5': 8, '10': 'hasPassphrase'},
    {'1': 'in_agent', '3': 12, '4': 1, '5': 8, '10': 'inAgent'},
    {'1': 'created_at', '3': 13, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'createdAt'},
    {'1': 'modified_at', '3': 14, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'modifiedAt'},
  ],
};

/// Descriptor for `SSHKey`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sSHKeyDescriptor = $convert.base64Decode(
    'CgZTU0hLZXkSDgoCaWQYASABKAlSAmlkEhIKBG5hbWUYAiABKAlSBG5hbWUSKAoQcHJpdmF0ZV'
    '9rZXlfcGF0aBgDIAEoCVIOcHJpdmF0ZUtleVBhdGgSJgoPcHVibGljX2tleV9wYXRoGAQgASgJ'
    'Ug1wdWJsaWNLZXlQYXRoEiUKBHR5cGUYBSABKA4yES5za2V5cy52MS5LZXlUeXBlUgR0eXBlEh'
    'IKBGJpdHMYBiABKAVSBGJpdHMSGAoHY29tbWVudBgHIAEoCVIHY29tbWVudBItChJmaW5nZXJw'
    'cmludF9zaGEyNTYYCCABKAlSEWZpbmdlcnByaW50U2hhMjU2EicKD2ZpbmdlcnByaW50X21kNR'
    'gJIAEoCVIOZmluZ2VycHJpbnRNZDUSHQoKcHVibGljX2tleRgKIAEoCVIJcHVibGljS2V5EiUK'
    'Dmhhc19wYXNzcGhyYXNlGAsgASgIUg1oYXNQYXNzcGhyYXNlEhkKCGluX2FnZW50GAwgASgIUg'
    'dpbkFnZW50EjkKCmNyZWF0ZWRfYXQYDSABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1w'
    'UgljcmVhdGVkQXQSOwoLbW9kaWZpZWRfYXQYDiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZX'
    'N0YW1wUgptb2RpZmllZEF0');

@$core.Deprecated('Use listKeysRequestDescriptor instead')
const ListKeysRequest$json = {
  '1': 'ListKeysRequest',
  '2': [
    {'1': 'target', '3': 1, '4': 1, '5': 11, '6': '.skeys.v1.Target', '10': 'target'},
  ],
};

/// Descriptor for `ListKeysRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listKeysRequestDescriptor = $convert.base64Decode(
    'Cg9MaXN0S2V5c1JlcXVlc3QSKAoGdGFyZ2V0GAEgASgLMhAuc2tleXMudjEuVGFyZ2V0UgZ0YX'
    'JnZXQ=');

@$core.Deprecated('Use listKeysResponseDescriptor instead')
const ListKeysResponse$json = {
  '1': 'ListKeysResponse',
  '2': [
    {'1': 'keys', '3': 1, '4': 3, '5': 11, '6': '.skeys.v1.SSHKey', '10': 'keys'},
  ],
};

/// Descriptor for `ListKeysResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listKeysResponseDescriptor = $convert.base64Decode(
    'ChBMaXN0S2V5c1Jlc3BvbnNlEiQKBGtleXMYASADKAsyEC5za2V5cy52MS5TU0hLZXlSBGtleX'
    'M=');

@$core.Deprecated('Use getKeyRequestDescriptor instead')
const GetKeyRequest$json = {
  '1': 'GetKeyRequest',
  '2': [
    {'1': 'target', '3': 1, '4': 1, '5': 11, '6': '.skeys.v1.Target', '10': 'target'},
    {'1': 'key_id', '3': 2, '4': 1, '5': 9, '10': 'keyId'},
  ],
};

/// Descriptor for `GetKeyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getKeyRequestDescriptor = $convert.base64Decode(
    'Cg1HZXRLZXlSZXF1ZXN0EigKBnRhcmdldBgBIAEoCzIQLnNrZXlzLnYxLlRhcmdldFIGdGFyZ2'
    'V0EhUKBmtleV9pZBgCIAEoCVIFa2V5SWQ=');

@$core.Deprecated('Use generateKeyRequestDescriptor instead')
const GenerateKeyRequest$json = {
  '1': 'GenerateKeyRequest',
  '2': [
    {'1': 'target', '3': 1, '4': 1, '5': 11, '6': '.skeys.v1.Target', '10': 'target'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'type', '3': 3, '4': 1, '5': 14, '6': '.skeys.v1.KeyType', '10': 'type'},
    {'1': 'bits', '3': 4, '4': 1, '5': 5, '10': 'bits'},
    {'1': 'comment', '3': 5, '4': 1, '5': 9, '10': 'comment'},
    {'1': 'passphrase', '3': 6, '4': 1, '5': 9, '10': 'passphrase'},
    {'1': 'add_to_agent', '3': 7, '4': 1, '5': 8, '10': 'addToAgent'},
  ],
};

/// Descriptor for `GenerateKeyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List generateKeyRequestDescriptor = $convert.base64Decode(
    'ChJHZW5lcmF0ZUtleVJlcXVlc3QSKAoGdGFyZ2V0GAEgASgLMhAuc2tleXMudjEuVGFyZ2V0Ug'
    'Z0YXJnZXQSEgoEbmFtZRgCIAEoCVIEbmFtZRIlCgR0eXBlGAMgASgOMhEuc2tleXMudjEuS2V5'
    'VHlwZVIEdHlwZRISCgRiaXRzGAQgASgFUgRiaXRzEhgKB2NvbW1lbnQYBSABKAlSB2NvbW1lbn'
    'QSHgoKcGFzc3BocmFzZRgGIAEoCVIKcGFzc3BocmFzZRIgCgxhZGRfdG9fYWdlbnQYByABKAhS'
    'CmFkZFRvQWdlbnQ=');

@$core.Deprecated('Use deleteKeyRequestDescriptor instead')
const DeleteKeyRequest$json = {
  '1': 'DeleteKeyRequest',
  '2': [
    {'1': 'target', '3': 1, '4': 1, '5': 11, '6': '.skeys.v1.Target', '10': 'target'},
    {'1': 'key_id', '3': 2, '4': 1, '5': 9, '10': 'keyId'},
  ],
};

/// Descriptor for `DeleteKeyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteKeyRequestDescriptor = $convert.base64Decode(
    'ChBEZWxldGVLZXlSZXF1ZXN0EigKBnRhcmdldBgBIAEoCzIQLnNrZXlzLnYxLlRhcmdldFIGdG'
    'FyZ2V0EhUKBmtleV9pZBgCIAEoCVIFa2V5SWQ=');

@$core.Deprecated('Use getFingerprintRequestDescriptor instead')
const GetFingerprintRequest$json = {
  '1': 'GetFingerprintRequest',
  '2': [
    {'1': 'target', '3': 1, '4': 1, '5': 11, '6': '.skeys.v1.Target', '10': 'target'},
    {'1': 'key_id', '3': 2, '4': 1, '5': 9, '10': 'keyId'},
    {'1': 'algorithm', '3': 3, '4': 1, '5': 14, '6': '.skeys.v1.FingerprintAlgorithm', '10': 'algorithm'},
  ],
};

/// Descriptor for `GetFingerprintRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getFingerprintRequestDescriptor = $convert.base64Decode(
    'ChVHZXRGaW5nZXJwcmludFJlcXVlc3QSKAoGdGFyZ2V0GAEgASgLMhAuc2tleXMudjEuVGFyZ2'
    'V0UgZ0YXJnZXQSFQoGa2V5X2lkGAIgASgJUgVrZXlJZBI8CglhbGdvcml0aG0YAyABKA4yHi5z'
    'a2V5cy52MS5GaW5nZXJwcmludEFsZ29yaXRobVIJYWxnb3JpdGht');

@$core.Deprecated('Use getFingerprintResponseDescriptor instead')
const GetFingerprintResponse$json = {
  '1': 'GetFingerprintResponse',
  '2': [
    {'1': 'fingerprint', '3': 1, '4': 1, '5': 9, '10': 'fingerprint'},
    {'1': 'algorithm', '3': 2, '4': 1, '5': 14, '6': '.skeys.v1.FingerprintAlgorithm', '10': 'algorithm'},
  ],
};

/// Descriptor for `GetFingerprintResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getFingerprintResponseDescriptor = $convert.base64Decode(
    'ChZHZXRGaW5nZXJwcmludFJlc3BvbnNlEiAKC2ZpbmdlcnByaW50GAEgASgJUgtmaW5nZXJwcm'
    'ludBI8CglhbGdvcml0aG0YAiABKA4yHi5za2V5cy52MS5GaW5nZXJwcmludEFsZ29yaXRobVIJ'
    'YWxnb3JpdGht');

@$core.Deprecated('Use changePassphraseRequestDescriptor instead')
const ChangePassphraseRequest$json = {
  '1': 'ChangePassphraseRequest',
  '2': [
    {'1': 'target', '3': 1, '4': 1, '5': 11, '6': '.skeys.v1.Target', '10': 'target'},
    {'1': 'key_id', '3': 2, '4': 1, '5': 9, '10': 'keyId'},
    {'1': 'old_passphrase', '3': 3, '4': 1, '5': 9, '10': 'oldPassphrase'},
    {'1': 'new_passphrase', '3': 4, '4': 1, '5': 9, '10': 'newPassphrase'},
  ],
};

/// Descriptor for `ChangePassphraseRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List changePassphraseRequestDescriptor = $convert.base64Decode(
    'ChdDaGFuZ2VQYXNzcGhyYXNlUmVxdWVzdBIoCgZ0YXJnZXQYASABKAsyEC5za2V5cy52MS5UYX'
    'JnZXRSBnRhcmdldBIVCgZrZXlfaWQYAiABKAlSBWtleUlkEiUKDm9sZF9wYXNzcGhyYXNlGAMg'
    'ASgJUg1vbGRQYXNzcGhyYXNlEiUKDm5ld19wYXNzcGhyYXNlGAQgASgJUg1uZXdQYXNzcGhyYX'
    'Nl');

@$core.Deprecated('Use pushKeyToRemoteRequestDescriptor instead')
const PushKeyToRemoteRequest$json = {
  '1': 'PushKeyToRemoteRequest',
  '2': [
    {'1': 'key_id', '3': 1, '4': 1, '5': 9, '10': 'keyId'},
    {'1': 'remote_id', '3': 2, '4': 1, '5': 9, '10': 'remoteId'},
    {'1': 'remote_user', '3': 3, '4': 1, '5': 9, '10': 'remoteUser'},
    {'1': 'append', '3': 4, '4': 1, '5': 8, '10': 'append'},
  ],
};

/// Descriptor for `PushKeyToRemoteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pushKeyToRemoteRequestDescriptor = $convert.base64Decode(
    'ChZQdXNoS2V5VG9SZW1vdGVSZXF1ZXN0EhUKBmtleV9pZBgBIAEoCVIFa2V5SWQSGwoJcmVtb3'
    'RlX2lkGAIgASgJUghyZW1vdGVJZBIfCgtyZW1vdGVfdXNlchgDIAEoCVIKcmVtb3RlVXNlchIW'
    'CgZhcHBlbmQYBCABKAhSBmFwcGVuZA==');

@$core.Deprecated('Use pushKeyToRemoteResponseDescriptor instead')
const PushKeyToRemoteResponse$json = {
  '1': 'PushKeyToRemoteResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `PushKeyToRemoteResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pushKeyToRemoteResponseDescriptor = $convert.base64Decode(
    'ChdQdXNoS2V5VG9SZW1vdGVSZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZXNzEhgKB2'
    '1lc3NhZ2UYAiABKAlSB21lc3NhZ2U=');

@$core.Deprecated('Use watchKeysRequestDescriptor instead')
const WatchKeysRequest$json = {
  '1': 'WatchKeysRequest',
  '2': [
    {'1': 'target', '3': 1, '4': 1, '5': 11, '6': '.skeys.v1.Target', '10': 'target'},
  ],
};

/// Descriptor for `WatchKeysRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchKeysRequestDescriptor = $convert.base64Decode(
    'ChBXYXRjaEtleXNSZXF1ZXN0EigKBnRhcmdldBgBIAEoCzIQLnNrZXlzLnYxLlRhcmdldFIGdG'
    'FyZ2V0');

