//
//  Generated code. Do not modify.
//  source: skeys/v1/keys.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class KeyType extends $pb.ProtobufEnum {
  static const KeyType KEY_TYPE_UNSPECIFIED = KeyType._(0, _omitEnumNames ? '' : 'KEY_TYPE_UNSPECIFIED');
  static const KeyType KEY_TYPE_RSA = KeyType._(1, _omitEnumNames ? '' : 'KEY_TYPE_RSA');
  static const KeyType KEY_TYPE_ED25519 = KeyType._(2, _omitEnumNames ? '' : 'KEY_TYPE_ED25519');
  static const KeyType KEY_TYPE_ECDSA = KeyType._(3, _omitEnumNames ? '' : 'KEY_TYPE_ECDSA');
  static const KeyType KEY_TYPE_ED25519_SK = KeyType._(4, _omitEnumNames ? '' : 'KEY_TYPE_ED25519_SK');
  static const KeyType KEY_TYPE_ECDSA_SK = KeyType._(5, _omitEnumNames ? '' : 'KEY_TYPE_ECDSA_SK');

  static const $core.List<KeyType> values = <KeyType> [
    KEY_TYPE_UNSPECIFIED,
    KEY_TYPE_RSA,
    KEY_TYPE_ED25519,
    KEY_TYPE_ECDSA,
    KEY_TYPE_ED25519_SK,
    KEY_TYPE_ECDSA_SK,
  ];

  static final $core.Map<$core.int, KeyType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static KeyType? valueOf($core.int value) => _byValue[value];

  const KeyType._($core.int v, $core.String n) : super(v, n);
}

class FingerprintAlgorithm extends $pb.ProtobufEnum {
  static const FingerprintAlgorithm FINGERPRINT_ALGORITHM_UNSPECIFIED = FingerprintAlgorithm._(0, _omitEnumNames ? '' : 'FINGERPRINT_ALGORITHM_UNSPECIFIED');
  static const FingerprintAlgorithm FINGERPRINT_ALGORITHM_SHA256 = FingerprintAlgorithm._(1, _omitEnumNames ? '' : 'FINGERPRINT_ALGORITHM_SHA256');
  static const FingerprintAlgorithm FINGERPRINT_ALGORITHM_MD5 = FingerprintAlgorithm._(2, _omitEnumNames ? '' : 'FINGERPRINT_ALGORITHM_MD5');

  static const $core.List<FingerprintAlgorithm> values = <FingerprintAlgorithm> [
    FINGERPRINT_ALGORITHM_UNSPECIFIED,
    FINGERPRINT_ALGORITHM_SHA256,
    FINGERPRINT_ALGORITHM_MD5,
  ];

  static final $core.Map<$core.int, FingerprintAlgorithm> _byValue = $pb.ProtobufEnum.initByValue(values);
  static FingerprintAlgorithm? valueOf($core.int value) => _byValue[value];

  const FingerprintAlgorithm._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
