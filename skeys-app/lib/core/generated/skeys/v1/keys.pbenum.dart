// This is a generated file - do not edit.
//
// Generated from skeys/v1/keys.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class KeyType extends $pb.ProtobufEnum {
  static const KeyType KEY_TYPE_UNSPECIFIED =
      KeyType._(0, _omitEnumNames ? '' : 'KEY_TYPE_UNSPECIFIED');
  static const KeyType KEY_TYPE_RSA =
      KeyType._(1, _omitEnumNames ? '' : 'KEY_TYPE_RSA');
  static const KeyType KEY_TYPE_ED25519 =
      KeyType._(2, _omitEnumNames ? '' : 'KEY_TYPE_ED25519');
  static const KeyType KEY_TYPE_ECDSA =
      KeyType._(3, _omitEnumNames ? '' : 'KEY_TYPE_ECDSA');
  static const KeyType KEY_TYPE_ED25519_SK =
      KeyType._(4, _omitEnumNames ? '' : 'KEY_TYPE_ED25519_SK');
  static const KeyType KEY_TYPE_ECDSA_SK =
      KeyType._(5, _omitEnumNames ? '' : 'KEY_TYPE_ECDSA_SK');

  static const $core.List<KeyType> values = <KeyType>[
    KEY_TYPE_UNSPECIFIED,
    KEY_TYPE_RSA,
    KEY_TYPE_ED25519,
    KEY_TYPE_ECDSA,
    KEY_TYPE_ED25519_SK,
    KEY_TYPE_ECDSA_SK,
  ];

  static final $core.List<KeyType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static KeyType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const KeyType._(super.value, super.name);
}

class FingerprintAlgorithm extends $pb.ProtobufEnum {
  static const FingerprintAlgorithm FINGERPRINT_ALGORITHM_UNSPECIFIED =
      FingerprintAlgorithm._(
          0, _omitEnumNames ? '' : 'FINGERPRINT_ALGORITHM_UNSPECIFIED');
  static const FingerprintAlgorithm FINGERPRINT_ALGORITHM_SHA256 =
      FingerprintAlgorithm._(
          1, _omitEnumNames ? '' : 'FINGERPRINT_ALGORITHM_SHA256');
  static const FingerprintAlgorithm FINGERPRINT_ALGORITHM_MD5 =
      FingerprintAlgorithm._(
          2, _omitEnumNames ? '' : 'FINGERPRINT_ALGORITHM_MD5');

  static const $core.List<FingerprintAlgorithm> values = <FingerprintAlgorithm>[
    FINGERPRINT_ALGORITHM_UNSPECIFIED,
    FINGERPRINT_ALGORITHM_SHA256,
    FINGERPRINT_ALGORITHM_MD5,
  ];

  static final $core.List<FingerprintAlgorithm?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static FingerprintAlgorithm? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const FingerprintAlgorithm._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
