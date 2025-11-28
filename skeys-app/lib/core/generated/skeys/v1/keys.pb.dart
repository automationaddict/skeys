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
import '../../google/protobuf/timestamp.pb.dart' as $2;

import 'common.pb.dart' as $3;
import 'keys.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'keys.pbenum.dart';

class SSHKey extends $pb.GeneratedMessage {
  factory SSHKey({
    $core.String? id,
    $core.String? name,
    $core.String? privateKeyPath,
    $core.String? publicKeyPath,
    KeyType? type,
    $core.int? bits,
    $core.String? comment,
    $core.String? fingerprintSha256,
    $core.String? fingerprintMd5,
    $core.String? publicKey,
    $core.bool? hasPassphrase,
    $core.bool? inAgent,
    $2.Timestamp? createdAt,
    $2.Timestamp? modifiedAt,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    if (privateKeyPath != null) result.privateKeyPath = privateKeyPath;
    if (publicKeyPath != null) result.publicKeyPath = publicKeyPath;
    if (type != null) result.type = type;
    if (bits != null) result.bits = bits;
    if (comment != null) result.comment = comment;
    if (fingerprintSha256 != null) result.fingerprintSha256 = fingerprintSha256;
    if (fingerprintMd5 != null) result.fingerprintMd5 = fingerprintMd5;
    if (publicKey != null) result.publicKey = publicKey;
    if (hasPassphrase != null) result.hasPassphrase = hasPassphrase;
    if (inAgent != null) result.inAgent = inAgent;
    if (createdAt != null) result.createdAt = createdAt;
    if (modifiedAt != null) result.modifiedAt = modifiedAt;
    return result;
  }

  SSHKey._();

  factory SSHKey.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SSHKey.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SSHKey',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'privateKeyPath')
    ..aOS(4, _omitFieldNames ? '' : 'publicKeyPath')
    ..aE<KeyType>(5, _omitFieldNames ? '' : 'type', enumValues: KeyType.values)
    ..aI(6, _omitFieldNames ? '' : 'bits')
    ..aOS(7, _omitFieldNames ? '' : 'comment')
    ..aOS(8, _omitFieldNames ? '' : 'fingerprintSha256')
    ..aOS(9, _omitFieldNames ? '' : 'fingerprintMd5')
    ..aOS(10, _omitFieldNames ? '' : 'publicKey')
    ..aOB(11, _omitFieldNames ? '' : 'hasPassphrase')
    ..aOB(12, _omitFieldNames ? '' : 'inAgent')
    ..aOM<$2.Timestamp>(13, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $2.Timestamp.create)
    ..aOM<$2.Timestamp>(14, _omitFieldNames ? '' : 'modifiedAt',
        subBuilder: $2.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SSHKey clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SSHKey copyWith(void Function(SSHKey) updates) =>
      super.copyWith((message) => updates(message as SSHKey)) as SSHKey;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SSHKey create() => SSHKey._();
  @$core.override
  SSHKey createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SSHKey getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SSHKey>(create);
  static SSHKey? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get privateKeyPath => $_getSZ(2);
  @$pb.TagNumber(3)
  set privateKeyPath($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPrivateKeyPath() => $_has(2);
  @$pb.TagNumber(3)
  void clearPrivateKeyPath() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get publicKeyPath => $_getSZ(3);
  @$pb.TagNumber(4)
  set publicKeyPath($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPublicKeyPath() => $_has(3);
  @$pb.TagNumber(4)
  void clearPublicKeyPath() => $_clearField(4);

  @$pb.TagNumber(5)
  KeyType get type => $_getN(4);
  @$pb.TagNumber(5)
  set type(KeyType value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasType() => $_has(4);
  @$pb.TagNumber(5)
  void clearType() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get bits => $_getIZ(5);
  @$pb.TagNumber(6)
  set bits($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasBits() => $_has(5);
  @$pb.TagNumber(6)
  void clearBits() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get comment => $_getSZ(6);
  @$pb.TagNumber(7)
  set comment($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasComment() => $_has(6);
  @$pb.TagNumber(7)
  void clearComment() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get fingerprintSha256 => $_getSZ(7);
  @$pb.TagNumber(8)
  set fingerprintSha256($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasFingerprintSha256() => $_has(7);
  @$pb.TagNumber(8)
  void clearFingerprintSha256() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get fingerprintMd5 => $_getSZ(8);
  @$pb.TagNumber(9)
  set fingerprintMd5($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasFingerprintMd5() => $_has(8);
  @$pb.TagNumber(9)
  void clearFingerprintMd5() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get publicKey => $_getSZ(9);
  @$pb.TagNumber(10)
  set publicKey($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasPublicKey() => $_has(9);
  @$pb.TagNumber(10)
  void clearPublicKey() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.bool get hasPassphrase => $_getBF(10);
  @$pb.TagNumber(11)
  set hasPassphrase($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasHasPassphrase() => $_has(10);
  @$pb.TagNumber(11)
  void clearHasPassphrase() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.bool get inAgent => $_getBF(11);
  @$pb.TagNumber(12)
  set inAgent($core.bool value) => $_setBool(11, value);
  @$pb.TagNumber(12)
  $core.bool hasInAgent() => $_has(11);
  @$pb.TagNumber(12)
  void clearInAgent() => $_clearField(12);

  @$pb.TagNumber(13)
  $2.Timestamp get createdAt => $_getN(12);
  @$pb.TagNumber(13)
  set createdAt($2.Timestamp value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasCreatedAt() => $_has(12);
  @$pb.TagNumber(13)
  void clearCreatedAt() => $_clearField(13);
  @$pb.TagNumber(13)
  $2.Timestamp ensureCreatedAt() => $_ensure(12);

  @$pb.TagNumber(14)
  $2.Timestamp get modifiedAt => $_getN(13);
  @$pb.TagNumber(14)
  set modifiedAt($2.Timestamp value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasModifiedAt() => $_has(13);
  @$pb.TagNumber(14)
  void clearModifiedAt() => $_clearField(14);
  @$pb.TagNumber(14)
  $2.Timestamp ensureModifiedAt() => $_ensure(13);
}

class ListKeysRequest extends $pb.GeneratedMessage {
  factory ListKeysRequest({
    $3.Target? target,
  }) {
    final result = create();
    if (target != null) result.target = target;
    return result;
  }

  ListKeysRequest._();

  factory ListKeysRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListKeysRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListKeysRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOM<$3.Target>(1, _omitFieldNames ? '' : 'target',
        subBuilder: $3.Target.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListKeysRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListKeysRequest copyWith(void Function(ListKeysRequest) updates) =>
      super.copyWith((message) => updates(message as ListKeysRequest))
          as ListKeysRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListKeysRequest create() => ListKeysRequest._();
  @$core.override
  ListKeysRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListKeysRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListKeysRequest>(create);
  static ListKeysRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $3.Target get target => $_getN(0);
  @$pb.TagNumber(1)
  set target($3.Target value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTarget() => $_has(0);
  @$pb.TagNumber(1)
  void clearTarget() => $_clearField(1);
  @$pb.TagNumber(1)
  $3.Target ensureTarget() => $_ensure(0);
}

class ListKeysResponse extends $pb.GeneratedMessage {
  factory ListKeysResponse({
    $core.Iterable<SSHKey>? keys,
  }) {
    final result = create();
    if (keys != null) result.keys.addAll(keys);
    return result;
  }

  ListKeysResponse._();

  factory ListKeysResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListKeysResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListKeysResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..pPM<SSHKey>(1, _omitFieldNames ? '' : 'keys', subBuilder: SSHKey.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListKeysResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListKeysResponse copyWith(void Function(ListKeysResponse) updates) =>
      super.copyWith((message) => updates(message as ListKeysResponse))
          as ListKeysResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListKeysResponse create() => ListKeysResponse._();
  @$core.override
  ListKeysResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListKeysResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListKeysResponse>(create);
  static ListKeysResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<SSHKey> get keys => $_getList(0);
}

class GetKeyRequest extends $pb.GeneratedMessage {
  factory GetKeyRequest({
    $3.Target? target,
    $core.String? keyId,
  }) {
    final result = create();
    if (target != null) result.target = target;
    if (keyId != null) result.keyId = keyId;
    return result;
  }

  GetKeyRequest._();

  factory GetKeyRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetKeyRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetKeyRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOM<$3.Target>(1, _omitFieldNames ? '' : 'target',
        subBuilder: $3.Target.create)
    ..aOS(2, _omitFieldNames ? '' : 'keyId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetKeyRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetKeyRequest copyWith(void Function(GetKeyRequest) updates) =>
      super.copyWith((message) => updates(message as GetKeyRequest))
          as GetKeyRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetKeyRequest create() => GetKeyRequest._();
  @$core.override
  GetKeyRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetKeyRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetKeyRequest>(create);
  static GetKeyRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $3.Target get target => $_getN(0);
  @$pb.TagNumber(1)
  set target($3.Target value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTarget() => $_has(0);
  @$pb.TagNumber(1)
  void clearTarget() => $_clearField(1);
  @$pb.TagNumber(1)
  $3.Target ensureTarget() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get keyId => $_getSZ(1);
  @$pb.TagNumber(2)
  set keyId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasKeyId() => $_has(1);
  @$pb.TagNumber(2)
  void clearKeyId() => $_clearField(2);
}

class GenerateKeyRequest extends $pb.GeneratedMessage {
  factory GenerateKeyRequest({
    $3.Target? target,
    $core.String? name,
    KeyType? type,
    $core.int? bits,
    $core.String? comment,
    $core.String? passphrase,
    $core.bool? addToAgent,
  }) {
    final result = create();
    if (target != null) result.target = target;
    if (name != null) result.name = name;
    if (type != null) result.type = type;
    if (bits != null) result.bits = bits;
    if (comment != null) result.comment = comment;
    if (passphrase != null) result.passphrase = passphrase;
    if (addToAgent != null) result.addToAgent = addToAgent;
    return result;
  }

  GenerateKeyRequest._();

  factory GenerateKeyRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GenerateKeyRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GenerateKeyRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOM<$3.Target>(1, _omitFieldNames ? '' : 'target',
        subBuilder: $3.Target.create)
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aE<KeyType>(3, _omitFieldNames ? '' : 'type', enumValues: KeyType.values)
    ..aI(4, _omitFieldNames ? '' : 'bits')
    ..aOS(5, _omitFieldNames ? '' : 'comment')
    ..aOS(6, _omitFieldNames ? '' : 'passphrase')
    ..aOB(7, _omitFieldNames ? '' : 'addToAgent')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GenerateKeyRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GenerateKeyRequest copyWith(void Function(GenerateKeyRequest) updates) =>
      super.copyWith((message) => updates(message as GenerateKeyRequest))
          as GenerateKeyRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GenerateKeyRequest create() => GenerateKeyRequest._();
  @$core.override
  GenerateKeyRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GenerateKeyRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GenerateKeyRequest>(create);
  static GenerateKeyRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $3.Target get target => $_getN(0);
  @$pb.TagNumber(1)
  set target($3.Target value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTarget() => $_has(0);
  @$pb.TagNumber(1)
  void clearTarget() => $_clearField(1);
  @$pb.TagNumber(1)
  $3.Target ensureTarget() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  KeyType get type => $_getN(2);
  @$pb.TagNumber(3)
  set type(KeyType value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasType() => $_has(2);
  @$pb.TagNumber(3)
  void clearType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get bits => $_getIZ(3);
  @$pb.TagNumber(4)
  set bits($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasBits() => $_has(3);
  @$pb.TagNumber(4)
  void clearBits() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get comment => $_getSZ(4);
  @$pb.TagNumber(5)
  set comment($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasComment() => $_has(4);
  @$pb.TagNumber(5)
  void clearComment() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get passphrase => $_getSZ(5);
  @$pb.TagNumber(6)
  set passphrase($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPassphrase() => $_has(5);
  @$pb.TagNumber(6)
  void clearPassphrase() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get addToAgent => $_getBF(6);
  @$pb.TagNumber(7)
  set addToAgent($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasAddToAgent() => $_has(6);
  @$pb.TagNumber(7)
  void clearAddToAgent() => $_clearField(7);
}

class DeleteKeyRequest extends $pb.GeneratedMessage {
  factory DeleteKeyRequest({
    $3.Target? target,
    $core.String? keyId,
  }) {
    final result = create();
    if (target != null) result.target = target;
    if (keyId != null) result.keyId = keyId;
    return result;
  }

  DeleteKeyRequest._();

  factory DeleteKeyRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteKeyRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteKeyRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOM<$3.Target>(1, _omitFieldNames ? '' : 'target',
        subBuilder: $3.Target.create)
    ..aOS(2, _omitFieldNames ? '' : 'keyId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteKeyRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteKeyRequest copyWith(void Function(DeleteKeyRequest) updates) =>
      super.copyWith((message) => updates(message as DeleteKeyRequest))
          as DeleteKeyRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteKeyRequest create() => DeleteKeyRequest._();
  @$core.override
  DeleteKeyRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeleteKeyRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteKeyRequest>(create);
  static DeleteKeyRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $3.Target get target => $_getN(0);
  @$pb.TagNumber(1)
  set target($3.Target value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTarget() => $_has(0);
  @$pb.TagNumber(1)
  void clearTarget() => $_clearField(1);
  @$pb.TagNumber(1)
  $3.Target ensureTarget() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get keyId => $_getSZ(1);
  @$pb.TagNumber(2)
  set keyId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasKeyId() => $_has(1);
  @$pb.TagNumber(2)
  void clearKeyId() => $_clearField(2);
}

class GetFingerprintRequest extends $pb.GeneratedMessage {
  factory GetFingerprintRequest({
    $3.Target? target,
    $core.String? keyId,
    FingerprintAlgorithm? algorithm,
  }) {
    final result = create();
    if (target != null) result.target = target;
    if (keyId != null) result.keyId = keyId;
    if (algorithm != null) result.algorithm = algorithm;
    return result;
  }

  GetFingerprintRequest._();

  factory GetFingerprintRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetFingerprintRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetFingerprintRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOM<$3.Target>(1, _omitFieldNames ? '' : 'target',
        subBuilder: $3.Target.create)
    ..aOS(2, _omitFieldNames ? '' : 'keyId')
    ..aE<FingerprintAlgorithm>(3, _omitFieldNames ? '' : 'algorithm',
        enumValues: FingerprintAlgorithm.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetFingerprintRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetFingerprintRequest copyWith(
          void Function(GetFingerprintRequest) updates) =>
      super.copyWith((message) => updates(message as GetFingerprintRequest))
          as GetFingerprintRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetFingerprintRequest create() => GetFingerprintRequest._();
  @$core.override
  GetFingerprintRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetFingerprintRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetFingerprintRequest>(create);
  static GetFingerprintRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $3.Target get target => $_getN(0);
  @$pb.TagNumber(1)
  set target($3.Target value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTarget() => $_has(0);
  @$pb.TagNumber(1)
  void clearTarget() => $_clearField(1);
  @$pb.TagNumber(1)
  $3.Target ensureTarget() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get keyId => $_getSZ(1);
  @$pb.TagNumber(2)
  set keyId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasKeyId() => $_has(1);
  @$pb.TagNumber(2)
  void clearKeyId() => $_clearField(2);

  @$pb.TagNumber(3)
  FingerprintAlgorithm get algorithm => $_getN(2);
  @$pb.TagNumber(3)
  set algorithm(FingerprintAlgorithm value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasAlgorithm() => $_has(2);
  @$pb.TagNumber(3)
  void clearAlgorithm() => $_clearField(3);
}

class GetFingerprintResponse extends $pb.GeneratedMessage {
  factory GetFingerprintResponse({
    $core.String? fingerprint,
    FingerprintAlgorithm? algorithm,
  }) {
    final result = create();
    if (fingerprint != null) result.fingerprint = fingerprint;
    if (algorithm != null) result.algorithm = algorithm;
    return result;
  }

  GetFingerprintResponse._();

  factory GetFingerprintResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetFingerprintResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetFingerprintResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'fingerprint')
    ..aE<FingerprintAlgorithm>(2, _omitFieldNames ? '' : 'algorithm',
        enumValues: FingerprintAlgorithm.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetFingerprintResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetFingerprintResponse copyWith(
          void Function(GetFingerprintResponse) updates) =>
      super.copyWith((message) => updates(message as GetFingerprintResponse))
          as GetFingerprintResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetFingerprintResponse create() => GetFingerprintResponse._();
  @$core.override
  GetFingerprintResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetFingerprintResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetFingerprintResponse>(create);
  static GetFingerprintResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get fingerprint => $_getSZ(0);
  @$pb.TagNumber(1)
  set fingerprint($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFingerprint() => $_has(0);
  @$pb.TagNumber(1)
  void clearFingerprint() => $_clearField(1);

  @$pb.TagNumber(2)
  FingerprintAlgorithm get algorithm => $_getN(1);
  @$pb.TagNumber(2)
  set algorithm(FingerprintAlgorithm value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasAlgorithm() => $_has(1);
  @$pb.TagNumber(2)
  void clearAlgorithm() => $_clearField(2);
}

class ChangePassphraseRequest extends $pb.GeneratedMessage {
  factory ChangePassphraseRequest({
    $3.Target? target,
    $core.String? keyId,
    $core.String? oldPassphrase,
    $core.String? newPassphrase,
  }) {
    final result = create();
    if (target != null) result.target = target;
    if (keyId != null) result.keyId = keyId;
    if (oldPassphrase != null) result.oldPassphrase = oldPassphrase;
    if (newPassphrase != null) result.newPassphrase = newPassphrase;
    return result;
  }

  ChangePassphraseRequest._();

  factory ChangePassphraseRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChangePassphraseRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChangePassphraseRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOM<$3.Target>(1, _omitFieldNames ? '' : 'target',
        subBuilder: $3.Target.create)
    ..aOS(2, _omitFieldNames ? '' : 'keyId')
    ..aOS(3, _omitFieldNames ? '' : 'oldPassphrase')
    ..aOS(4, _omitFieldNames ? '' : 'newPassphrase')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChangePassphraseRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChangePassphraseRequest copyWith(
          void Function(ChangePassphraseRequest) updates) =>
      super.copyWith((message) => updates(message as ChangePassphraseRequest))
          as ChangePassphraseRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChangePassphraseRequest create() => ChangePassphraseRequest._();
  @$core.override
  ChangePassphraseRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChangePassphraseRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChangePassphraseRequest>(create);
  static ChangePassphraseRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $3.Target get target => $_getN(0);
  @$pb.TagNumber(1)
  set target($3.Target value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTarget() => $_has(0);
  @$pb.TagNumber(1)
  void clearTarget() => $_clearField(1);
  @$pb.TagNumber(1)
  $3.Target ensureTarget() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get keyId => $_getSZ(1);
  @$pb.TagNumber(2)
  set keyId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasKeyId() => $_has(1);
  @$pb.TagNumber(2)
  void clearKeyId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get oldPassphrase => $_getSZ(2);
  @$pb.TagNumber(3)
  set oldPassphrase($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOldPassphrase() => $_has(2);
  @$pb.TagNumber(3)
  void clearOldPassphrase() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get newPassphrase => $_getSZ(3);
  @$pb.TagNumber(4)
  set newPassphrase($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNewPassphrase() => $_has(3);
  @$pb.TagNumber(4)
  void clearNewPassphrase() => $_clearField(4);
}

class PushKeyToRemoteRequest extends $pb.GeneratedMessage {
  factory PushKeyToRemoteRequest({
    $core.String? keyId,
    $core.String? remoteId,
    $core.String? remoteUser,
    $core.bool? append,
  }) {
    final result = create();
    if (keyId != null) result.keyId = keyId;
    if (remoteId != null) result.remoteId = remoteId;
    if (remoteUser != null) result.remoteUser = remoteUser;
    if (append != null) result.append = append;
    return result;
  }

  PushKeyToRemoteRequest._();

  factory PushKeyToRemoteRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PushKeyToRemoteRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PushKeyToRemoteRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'keyId')
    ..aOS(2, _omitFieldNames ? '' : 'remoteId')
    ..aOS(3, _omitFieldNames ? '' : 'remoteUser')
    ..aOB(4, _omitFieldNames ? '' : 'append')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PushKeyToRemoteRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PushKeyToRemoteRequest copyWith(
          void Function(PushKeyToRemoteRequest) updates) =>
      super.copyWith((message) => updates(message as PushKeyToRemoteRequest))
          as PushKeyToRemoteRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PushKeyToRemoteRequest create() => PushKeyToRemoteRequest._();
  @$core.override
  PushKeyToRemoteRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PushKeyToRemoteRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PushKeyToRemoteRequest>(create);
  static PushKeyToRemoteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get keyId => $_getSZ(0);
  @$pb.TagNumber(1)
  set keyId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasKeyId() => $_has(0);
  @$pb.TagNumber(1)
  void clearKeyId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get remoteId => $_getSZ(1);
  @$pb.TagNumber(2)
  set remoteId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRemoteId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRemoteId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get remoteUser => $_getSZ(2);
  @$pb.TagNumber(3)
  set remoteUser($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRemoteUser() => $_has(2);
  @$pb.TagNumber(3)
  void clearRemoteUser() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get append => $_getBF(3);
  @$pb.TagNumber(4)
  set append($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAppend() => $_has(3);
  @$pb.TagNumber(4)
  void clearAppend() => $_clearField(4);
}

class PushKeyToRemoteResponse extends $pb.GeneratedMessage {
  factory PushKeyToRemoteResponse({
    $core.bool? success,
    $core.String? message,
  }) {
    final result = create();
    if (success != null) result.success = success;
    if (message != null) result.message = message;
    return result;
  }

  PushKeyToRemoteResponse._();

  factory PushKeyToRemoteResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PushKeyToRemoteResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PushKeyToRemoteResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PushKeyToRemoteResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PushKeyToRemoteResponse copyWith(
          void Function(PushKeyToRemoteResponse) updates) =>
      super.copyWith((message) => updates(message as PushKeyToRemoteResponse))
          as PushKeyToRemoteResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PushKeyToRemoteResponse create() => PushKeyToRemoteResponse._();
  @$core.override
  PushKeyToRemoteResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PushKeyToRemoteResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PushKeyToRemoteResponse>(create);
  static PushKeyToRemoteResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => $_clearField(2);
}

class WatchKeysRequest extends $pb.GeneratedMessage {
  factory WatchKeysRequest({
    $3.Target? target,
  }) {
    final result = create();
    if (target != null) result.target = target;
    return result;
  }

  WatchKeysRequest._();

  factory WatchKeysRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WatchKeysRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WatchKeysRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOM<$3.Target>(1, _omitFieldNames ? '' : 'target',
        subBuilder: $3.Target.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchKeysRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchKeysRequest copyWith(void Function(WatchKeysRequest) updates) =>
      super.copyWith((message) => updates(message as WatchKeysRequest))
          as WatchKeysRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WatchKeysRequest create() => WatchKeysRequest._();
  @$core.override
  WatchKeysRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WatchKeysRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WatchKeysRequest>(create);
  static WatchKeysRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $3.Target get target => $_getN(0);
  @$pb.TagNumber(1)
  set target($3.Target value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTarget() => $_has(0);
  @$pb.TagNumber(1)
  void clearTarget() => $_clearField(1);
  @$pb.TagNumber(1)
  $3.Target ensureTarget() => $_ensure(0);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
