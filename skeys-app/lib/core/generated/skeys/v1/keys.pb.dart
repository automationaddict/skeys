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

import '../../google/protobuf/timestamp.pb.dart' as $10;
import 'common.pb.dart' as $8;
import 'keys.pbenum.dart';

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
    $10.Timestamp? createdAt,
    $10.Timestamp? modifiedAt,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (name != null) {
      $result.name = name;
    }
    if (privateKeyPath != null) {
      $result.privateKeyPath = privateKeyPath;
    }
    if (publicKeyPath != null) {
      $result.publicKeyPath = publicKeyPath;
    }
    if (type != null) {
      $result.type = type;
    }
    if (bits != null) {
      $result.bits = bits;
    }
    if (comment != null) {
      $result.comment = comment;
    }
    if (fingerprintSha256 != null) {
      $result.fingerprintSha256 = fingerprintSha256;
    }
    if (fingerprintMd5 != null) {
      $result.fingerprintMd5 = fingerprintMd5;
    }
    if (publicKey != null) {
      $result.publicKey = publicKey;
    }
    if (hasPassphrase != null) {
      $result.hasPassphrase = hasPassphrase;
    }
    if (inAgent != null) {
      $result.inAgent = inAgent;
    }
    if (createdAt != null) {
      $result.createdAt = createdAt;
    }
    if (modifiedAt != null) {
      $result.modifiedAt = modifiedAt;
    }
    return $result;
  }
  SSHKey._() : super();
  factory SSHKey.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SSHKey.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SSHKey', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'privateKeyPath')
    ..aOS(4, _omitFieldNames ? '' : 'publicKeyPath')
    ..e<KeyType>(5, _omitFieldNames ? '' : 'type', $pb.PbFieldType.OE, defaultOrMaker: KeyType.KEY_TYPE_UNSPECIFIED, valueOf: KeyType.valueOf, enumValues: KeyType.values)
    ..a<$core.int>(6, _omitFieldNames ? '' : 'bits', $pb.PbFieldType.O3)
    ..aOS(7, _omitFieldNames ? '' : 'comment')
    ..aOS(8, _omitFieldNames ? '' : 'fingerprintSha256')
    ..aOS(9, _omitFieldNames ? '' : 'fingerprintMd5')
    ..aOS(10, _omitFieldNames ? '' : 'publicKey')
    ..aOB(11, _omitFieldNames ? '' : 'hasPassphrase')
    ..aOB(12, _omitFieldNames ? '' : 'inAgent')
    ..aOM<$10.Timestamp>(13, _omitFieldNames ? '' : 'createdAt', subBuilder: $10.Timestamp.create)
    ..aOM<$10.Timestamp>(14, _omitFieldNames ? '' : 'modifiedAt', subBuilder: $10.Timestamp.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SSHKey clone() => SSHKey()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SSHKey copyWith(void Function(SSHKey) updates) => super.copyWith((message) => updates(message as SSHKey)) as SSHKey;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SSHKey create() => SSHKey._();
  SSHKey createEmptyInstance() => create();
  static $pb.PbList<SSHKey> createRepeated() => $pb.PbList<SSHKey>();
  @$core.pragma('dart2js:noInline')
  static SSHKey getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SSHKey>(create);
  static SSHKey? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get privateKeyPath => $_getSZ(2);
  @$pb.TagNumber(3)
  set privateKeyPath($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPrivateKeyPath() => $_has(2);
  @$pb.TagNumber(3)
  void clearPrivateKeyPath() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get publicKeyPath => $_getSZ(3);
  @$pb.TagNumber(4)
  set publicKeyPath($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasPublicKeyPath() => $_has(3);
  @$pb.TagNumber(4)
  void clearPublicKeyPath() => clearField(4);

  @$pb.TagNumber(5)
  KeyType get type => $_getN(4);
  @$pb.TagNumber(5)
  set type(KeyType v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasType() => $_has(4);
  @$pb.TagNumber(5)
  void clearType() => clearField(5);

  @$pb.TagNumber(6)
  $core.int get bits => $_getIZ(5);
  @$pb.TagNumber(6)
  set bits($core.int v) { $_setSignedInt32(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasBits() => $_has(5);
  @$pb.TagNumber(6)
  void clearBits() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get comment => $_getSZ(6);
  @$pb.TagNumber(7)
  set comment($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasComment() => $_has(6);
  @$pb.TagNumber(7)
  void clearComment() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get fingerprintSha256 => $_getSZ(7);
  @$pb.TagNumber(8)
  set fingerprintSha256($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasFingerprintSha256() => $_has(7);
  @$pb.TagNumber(8)
  void clearFingerprintSha256() => clearField(8);

  @$pb.TagNumber(9)
  $core.String get fingerprintMd5 => $_getSZ(8);
  @$pb.TagNumber(9)
  set fingerprintMd5($core.String v) { $_setString(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasFingerprintMd5() => $_has(8);
  @$pb.TagNumber(9)
  void clearFingerprintMd5() => clearField(9);

  @$pb.TagNumber(10)
  $core.String get publicKey => $_getSZ(9);
  @$pb.TagNumber(10)
  set publicKey($core.String v) { $_setString(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasPublicKey() => $_has(9);
  @$pb.TagNumber(10)
  void clearPublicKey() => clearField(10);

  @$pb.TagNumber(11)
  $core.bool get hasPassphrase => $_getBF(10);
  @$pb.TagNumber(11)
  set hasPassphrase($core.bool v) { $_setBool(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasHasPassphrase() => $_has(10);
  @$pb.TagNumber(11)
  void clearHasPassphrase() => clearField(11);

  @$pb.TagNumber(12)
  $core.bool get inAgent => $_getBF(11);
  @$pb.TagNumber(12)
  set inAgent($core.bool v) { $_setBool(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasInAgent() => $_has(11);
  @$pb.TagNumber(12)
  void clearInAgent() => clearField(12);

  @$pb.TagNumber(13)
  $10.Timestamp get createdAt => $_getN(12);
  @$pb.TagNumber(13)
  set createdAt($10.Timestamp v) { setField(13, v); }
  @$pb.TagNumber(13)
  $core.bool hasCreatedAt() => $_has(12);
  @$pb.TagNumber(13)
  void clearCreatedAt() => clearField(13);
  @$pb.TagNumber(13)
  $10.Timestamp ensureCreatedAt() => $_ensure(12);

  @$pb.TagNumber(14)
  $10.Timestamp get modifiedAt => $_getN(13);
  @$pb.TagNumber(14)
  set modifiedAt($10.Timestamp v) { setField(14, v); }
  @$pb.TagNumber(14)
  $core.bool hasModifiedAt() => $_has(13);
  @$pb.TagNumber(14)
  void clearModifiedAt() => clearField(14);
  @$pb.TagNumber(14)
  $10.Timestamp ensureModifiedAt() => $_ensure(13);
}

class ListKeysRequest extends $pb.GeneratedMessage {
  factory ListKeysRequest({
    $8.Target? target,
  }) {
    final $result = create();
    if (target != null) {
      $result.target = target;
    }
    return $result;
  }
  ListKeysRequest._() : super();
  factory ListKeysRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListKeysRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListKeysRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..aOM<$8.Target>(1, _omitFieldNames ? '' : 'target', subBuilder: $8.Target.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListKeysRequest clone() => ListKeysRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListKeysRequest copyWith(void Function(ListKeysRequest) updates) => super.copyWith((message) => updates(message as ListKeysRequest)) as ListKeysRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListKeysRequest create() => ListKeysRequest._();
  ListKeysRequest createEmptyInstance() => create();
  static $pb.PbList<ListKeysRequest> createRepeated() => $pb.PbList<ListKeysRequest>();
  @$core.pragma('dart2js:noInline')
  static ListKeysRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListKeysRequest>(create);
  static ListKeysRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $8.Target get target => $_getN(0);
  @$pb.TagNumber(1)
  set target($8.Target v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasTarget() => $_has(0);
  @$pb.TagNumber(1)
  void clearTarget() => clearField(1);
  @$pb.TagNumber(1)
  $8.Target ensureTarget() => $_ensure(0);
}

class ListKeysResponse extends $pb.GeneratedMessage {
  factory ListKeysResponse({
    $core.Iterable<SSHKey>? keys,
  }) {
    final $result = create();
    if (keys != null) {
      $result.keys.addAll(keys);
    }
    return $result;
  }
  ListKeysResponse._() : super();
  factory ListKeysResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListKeysResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListKeysResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..pc<SSHKey>(1, _omitFieldNames ? '' : 'keys', $pb.PbFieldType.PM, subBuilder: SSHKey.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListKeysResponse clone() => ListKeysResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListKeysResponse copyWith(void Function(ListKeysResponse) updates) => super.copyWith((message) => updates(message as ListKeysResponse)) as ListKeysResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListKeysResponse create() => ListKeysResponse._();
  ListKeysResponse createEmptyInstance() => create();
  static $pb.PbList<ListKeysResponse> createRepeated() => $pb.PbList<ListKeysResponse>();
  @$core.pragma('dart2js:noInline')
  static ListKeysResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListKeysResponse>(create);
  static ListKeysResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<SSHKey> get keys => $_getList(0);
}

class GetKeyRequest extends $pb.GeneratedMessage {
  factory GetKeyRequest({
    $8.Target? target,
    $core.String? keyId,
  }) {
    final $result = create();
    if (target != null) {
      $result.target = target;
    }
    if (keyId != null) {
      $result.keyId = keyId;
    }
    return $result;
  }
  GetKeyRequest._() : super();
  factory GetKeyRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetKeyRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetKeyRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..aOM<$8.Target>(1, _omitFieldNames ? '' : 'target', subBuilder: $8.Target.create)
    ..aOS(2, _omitFieldNames ? '' : 'keyId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetKeyRequest clone() => GetKeyRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetKeyRequest copyWith(void Function(GetKeyRequest) updates) => super.copyWith((message) => updates(message as GetKeyRequest)) as GetKeyRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetKeyRequest create() => GetKeyRequest._();
  GetKeyRequest createEmptyInstance() => create();
  static $pb.PbList<GetKeyRequest> createRepeated() => $pb.PbList<GetKeyRequest>();
  @$core.pragma('dart2js:noInline')
  static GetKeyRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetKeyRequest>(create);
  static GetKeyRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $8.Target get target => $_getN(0);
  @$pb.TagNumber(1)
  set target($8.Target v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasTarget() => $_has(0);
  @$pb.TagNumber(1)
  void clearTarget() => clearField(1);
  @$pb.TagNumber(1)
  $8.Target ensureTarget() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get keyId => $_getSZ(1);
  @$pb.TagNumber(2)
  set keyId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasKeyId() => $_has(1);
  @$pb.TagNumber(2)
  void clearKeyId() => clearField(2);
}

class GenerateKeyRequest extends $pb.GeneratedMessage {
  factory GenerateKeyRequest({
    $8.Target? target,
    $core.String? name,
    KeyType? type,
    $core.int? bits,
    $core.String? comment,
    $core.String? passphrase,
    $core.bool? addToAgent,
  }) {
    final $result = create();
    if (target != null) {
      $result.target = target;
    }
    if (name != null) {
      $result.name = name;
    }
    if (type != null) {
      $result.type = type;
    }
    if (bits != null) {
      $result.bits = bits;
    }
    if (comment != null) {
      $result.comment = comment;
    }
    if (passphrase != null) {
      $result.passphrase = passphrase;
    }
    if (addToAgent != null) {
      $result.addToAgent = addToAgent;
    }
    return $result;
  }
  GenerateKeyRequest._() : super();
  factory GenerateKeyRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GenerateKeyRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GenerateKeyRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..aOM<$8.Target>(1, _omitFieldNames ? '' : 'target', subBuilder: $8.Target.create)
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..e<KeyType>(3, _omitFieldNames ? '' : 'type', $pb.PbFieldType.OE, defaultOrMaker: KeyType.KEY_TYPE_UNSPECIFIED, valueOf: KeyType.valueOf, enumValues: KeyType.values)
    ..a<$core.int>(4, _omitFieldNames ? '' : 'bits', $pb.PbFieldType.O3)
    ..aOS(5, _omitFieldNames ? '' : 'comment')
    ..aOS(6, _omitFieldNames ? '' : 'passphrase')
    ..aOB(7, _omitFieldNames ? '' : 'addToAgent')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GenerateKeyRequest clone() => GenerateKeyRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GenerateKeyRequest copyWith(void Function(GenerateKeyRequest) updates) => super.copyWith((message) => updates(message as GenerateKeyRequest)) as GenerateKeyRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GenerateKeyRequest create() => GenerateKeyRequest._();
  GenerateKeyRequest createEmptyInstance() => create();
  static $pb.PbList<GenerateKeyRequest> createRepeated() => $pb.PbList<GenerateKeyRequest>();
  @$core.pragma('dart2js:noInline')
  static GenerateKeyRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GenerateKeyRequest>(create);
  static GenerateKeyRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $8.Target get target => $_getN(0);
  @$pb.TagNumber(1)
  set target($8.Target v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasTarget() => $_has(0);
  @$pb.TagNumber(1)
  void clearTarget() => clearField(1);
  @$pb.TagNumber(1)
  $8.Target ensureTarget() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);

  @$pb.TagNumber(3)
  KeyType get type => $_getN(2);
  @$pb.TagNumber(3)
  set type(KeyType v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasType() => $_has(2);
  @$pb.TagNumber(3)
  void clearType() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get bits => $_getIZ(3);
  @$pb.TagNumber(4)
  set bits($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasBits() => $_has(3);
  @$pb.TagNumber(4)
  void clearBits() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get comment => $_getSZ(4);
  @$pb.TagNumber(5)
  set comment($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasComment() => $_has(4);
  @$pb.TagNumber(5)
  void clearComment() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get passphrase => $_getSZ(5);
  @$pb.TagNumber(6)
  set passphrase($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasPassphrase() => $_has(5);
  @$pb.TagNumber(6)
  void clearPassphrase() => clearField(6);

  @$pb.TagNumber(7)
  $core.bool get addToAgent => $_getBF(6);
  @$pb.TagNumber(7)
  set addToAgent($core.bool v) { $_setBool(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasAddToAgent() => $_has(6);
  @$pb.TagNumber(7)
  void clearAddToAgent() => clearField(7);
}

class DeleteKeyRequest extends $pb.GeneratedMessage {
  factory DeleteKeyRequest({
    $8.Target? target,
    $core.String? keyId,
  }) {
    final $result = create();
    if (target != null) {
      $result.target = target;
    }
    if (keyId != null) {
      $result.keyId = keyId;
    }
    return $result;
  }
  DeleteKeyRequest._() : super();
  factory DeleteKeyRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeleteKeyRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DeleteKeyRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..aOM<$8.Target>(1, _omitFieldNames ? '' : 'target', subBuilder: $8.Target.create)
    ..aOS(2, _omitFieldNames ? '' : 'keyId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeleteKeyRequest clone() => DeleteKeyRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeleteKeyRequest copyWith(void Function(DeleteKeyRequest) updates) => super.copyWith((message) => updates(message as DeleteKeyRequest)) as DeleteKeyRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteKeyRequest create() => DeleteKeyRequest._();
  DeleteKeyRequest createEmptyInstance() => create();
  static $pb.PbList<DeleteKeyRequest> createRepeated() => $pb.PbList<DeleteKeyRequest>();
  @$core.pragma('dart2js:noInline')
  static DeleteKeyRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeleteKeyRequest>(create);
  static DeleteKeyRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $8.Target get target => $_getN(0);
  @$pb.TagNumber(1)
  set target($8.Target v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasTarget() => $_has(0);
  @$pb.TagNumber(1)
  void clearTarget() => clearField(1);
  @$pb.TagNumber(1)
  $8.Target ensureTarget() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get keyId => $_getSZ(1);
  @$pb.TagNumber(2)
  set keyId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasKeyId() => $_has(1);
  @$pb.TagNumber(2)
  void clearKeyId() => clearField(2);
}

class GetFingerprintRequest extends $pb.GeneratedMessage {
  factory GetFingerprintRequest({
    $8.Target? target,
    $core.String? keyId,
    FingerprintAlgorithm? algorithm,
  }) {
    final $result = create();
    if (target != null) {
      $result.target = target;
    }
    if (keyId != null) {
      $result.keyId = keyId;
    }
    if (algorithm != null) {
      $result.algorithm = algorithm;
    }
    return $result;
  }
  GetFingerprintRequest._() : super();
  factory GetFingerprintRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetFingerprintRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetFingerprintRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..aOM<$8.Target>(1, _omitFieldNames ? '' : 'target', subBuilder: $8.Target.create)
    ..aOS(2, _omitFieldNames ? '' : 'keyId')
    ..e<FingerprintAlgorithm>(3, _omitFieldNames ? '' : 'algorithm', $pb.PbFieldType.OE, defaultOrMaker: FingerprintAlgorithm.FINGERPRINT_ALGORITHM_UNSPECIFIED, valueOf: FingerprintAlgorithm.valueOf, enumValues: FingerprintAlgorithm.values)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetFingerprintRequest clone() => GetFingerprintRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetFingerprintRequest copyWith(void Function(GetFingerprintRequest) updates) => super.copyWith((message) => updates(message as GetFingerprintRequest)) as GetFingerprintRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetFingerprintRequest create() => GetFingerprintRequest._();
  GetFingerprintRequest createEmptyInstance() => create();
  static $pb.PbList<GetFingerprintRequest> createRepeated() => $pb.PbList<GetFingerprintRequest>();
  @$core.pragma('dart2js:noInline')
  static GetFingerprintRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetFingerprintRequest>(create);
  static GetFingerprintRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $8.Target get target => $_getN(0);
  @$pb.TagNumber(1)
  set target($8.Target v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasTarget() => $_has(0);
  @$pb.TagNumber(1)
  void clearTarget() => clearField(1);
  @$pb.TagNumber(1)
  $8.Target ensureTarget() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get keyId => $_getSZ(1);
  @$pb.TagNumber(2)
  set keyId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasKeyId() => $_has(1);
  @$pb.TagNumber(2)
  void clearKeyId() => clearField(2);

  @$pb.TagNumber(3)
  FingerprintAlgorithm get algorithm => $_getN(2);
  @$pb.TagNumber(3)
  set algorithm(FingerprintAlgorithm v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasAlgorithm() => $_has(2);
  @$pb.TagNumber(3)
  void clearAlgorithm() => clearField(3);
}

class GetFingerprintResponse extends $pb.GeneratedMessage {
  factory GetFingerprintResponse({
    $core.String? fingerprint,
    FingerprintAlgorithm? algorithm,
  }) {
    final $result = create();
    if (fingerprint != null) {
      $result.fingerprint = fingerprint;
    }
    if (algorithm != null) {
      $result.algorithm = algorithm;
    }
    return $result;
  }
  GetFingerprintResponse._() : super();
  factory GetFingerprintResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetFingerprintResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetFingerprintResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'fingerprint')
    ..e<FingerprintAlgorithm>(2, _omitFieldNames ? '' : 'algorithm', $pb.PbFieldType.OE, defaultOrMaker: FingerprintAlgorithm.FINGERPRINT_ALGORITHM_UNSPECIFIED, valueOf: FingerprintAlgorithm.valueOf, enumValues: FingerprintAlgorithm.values)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetFingerprintResponse clone() => GetFingerprintResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetFingerprintResponse copyWith(void Function(GetFingerprintResponse) updates) => super.copyWith((message) => updates(message as GetFingerprintResponse)) as GetFingerprintResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetFingerprintResponse create() => GetFingerprintResponse._();
  GetFingerprintResponse createEmptyInstance() => create();
  static $pb.PbList<GetFingerprintResponse> createRepeated() => $pb.PbList<GetFingerprintResponse>();
  @$core.pragma('dart2js:noInline')
  static GetFingerprintResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetFingerprintResponse>(create);
  static GetFingerprintResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get fingerprint => $_getSZ(0);
  @$pb.TagNumber(1)
  set fingerprint($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasFingerprint() => $_has(0);
  @$pb.TagNumber(1)
  void clearFingerprint() => clearField(1);

  @$pb.TagNumber(2)
  FingerprintAlgorithm get algorithm => $_getN(1);
  @$pb.TagNumber(2)
  set algorithm(FingerprintAlgorithm v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasAlgorithm() => $_has(1);
  @$pb.TagNumber(2)
  void clearAlgorithm() => clearField(2);
}

class ChangePassphraseRequest extends $pb.GeneratedMessage {
  factory ChangePassphraseRequest({
    $8.Target? target,
    $core.String? keyId,
    $core.String? oldPassphrase,
    $core.String? newPassphrase,
  }) {
    final $result = create();
    if (target != null) {
      $result.target = target;
    }
    if (keyId != null) {
      $result.keyId = keyId;
    }
    if (oldPassphrase != null) {
      $result.oldPassphrase = oldPassphrase;
    }
    if (newPassphrase != null) {
      $result.newPassphrase = newPassphrase;
    }
    return $result;
  }
  ChangePassphraseRequest._() : super();
  factory ChangePassphraseRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ChangePassphraseRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ChangePassphraseRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..aOM<$8.Target>(1, _omitFieldNames ? '' : 'target', subBuilder: $8.Target.create)
    ..aOS(2, _omitFieldNames ? '' : 'keyId')
    ..aOS(3, _omitFieldNames ? '' : 'oldPassphrase')
    ..aOS(4, _omitFieldNames ? '' : 'newPassphrase')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ChangePassphraseRequest clone() => ChangePassphraseRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ChangePassphraseRequest copyWith(void Function(ChangePassphraseRequest) updates) => super.copyWith((message) => updates(message as ChangePassphraseRequest)) as ChangePassphraseRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChangePassphraseRequest create() => ChangePassphraseRequest._();
  ChangePassphraseRequest createEmptyInstance() => create();
  static $pb.PbList<ChangePassphraseRequest> createRepeated() => $pb.PbList<ChangePassphraseRequest>();
  @$core.pragma('dart2js:noInline')
  static ChangePassphraseRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ChangePassphraseRequest>(create);
  static ChangePassphraseRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $8.Target get target => $_getN(0);
  @$pb.TagNumber(1)
  set target($8.Target v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasTarget() => $_has(0);
  @$pb.TagNumber(1)
  void clearTarget() => clearField(1);
  @$pb.TagNumber(1)
  $8.Target ensureTarget() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get keyId => $_getSZ(1);
  @$pb.TagNumber(2)
  set keyId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasKeyId() => $_has(1);
  @$pb.TagNumber(2)
  void clearKeyId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get oldPassphrase => $_getSZ(2);
  @$pb.TagNumber(3)
  set oldPassphrase($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasOldPassphrase() => $_has(2);
  @$pb.TagNumber(3)
  void clearOldPassphrase() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get newPassphrase => $_getSZ(3);
  @$pb.TagNumber(4)
  set newPassphrase($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasNewPassphrase() => $_has(3);
  @$pb.TagNumber(4)
  void clearNewPassphrase() => clearField(4);
}

class PushKeyToRemoteRequest extends $pb.GeneratedMessage {
  factory PushKeyToRemoteRequest({
    $core.String? keyId,
    $core.String? remoteId,
    $core.String? remoteUser,
    $core.bool? append,
  }) {
    final $result = create();
    if (keyId != null) {
      $result.keyId = keyId;
    }
    if (remoteId != null) {
      $result.remoteId = remoteId;
    }
    if (remoteUser != null) {
      $result.remoteUser = remoteUser;
    }
    if (append != null) {
      $result.append = append;
    }
    return $result;
  }
  PushKeyToRemoteRequest._() : super();
  factory PushKeyToRemoteRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PushKeyToRemoteRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PushKeyToRemoteRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'keyId')
    ..aOS(2, _omitFieldNames ? '' : 'remoteId')
    ..aOS(3, _omitFieldNames ? '' : 'remoteUser')
    ..aOB(4, _omitFieldNames ? '' : 'append')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PushKeyToRemoteRequest clone() => PushKeyToRemoteRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PushKeyToRemoteRequest copyWith(void Function(PushKeyToRemoteRequest) updates) => super.copyWith((message) => updates(message as PushKeyToRemoteRequest)) as PushKeyToRemoteRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PushKeyToRemoteRequest create() => PushKeyToRemoteRequest._();
  PushKeyToRemoteRequest createEmptyInstance() => create();
  static $pb.PbList<PushKeyToRemoteRequest> createRepeated() => $pb.PbList<PushKeyToRemoteRequest>();
  @$core.pragma('dart2js:noInline')
  static PushKeyToRemoteRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PushKeyToRemoteRequest>(create);
  static PushKeyToRemoteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get keyId => $_getSZ(0);
  @$pb.TagNumber(1)
  set keyId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasKeyId() => $_has(0);
  @$pb.TagNumber(1)
  void clearKeyId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get remoteId => $_getSZ(1);
  @$pb.TagNumber(2)
  set remoteId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasRemoteId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRemoteId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get remoteUser => $_getSZ(2);
  @$pb.TagNumber(3)
  set remoteUser($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasRemoteUser() => $_has(2);
  @$pb.TagNumber(3)
  void clearRemoteUser() => clearField(3);

  @$pb.TagNumber(4)
  $core.bool get append => $_getBF(3);
  @$pb.TagNumber(4)
  set append($core.bool v) { $_setBool(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasAppend() => $_has(3);
  @$pb.TagNumber(4)
  void clearAppend() => clearField(4);
}

class PushKeyToRemoteResponse extends $pb.GeneratedMessage {
  factory PushKeyToRemoteResponse({
    $core.bool? success,
    $core.String? message,
  }) {
    final $result = create();
    if (success != null) {
      $result.success = success;
    }
    if (message != null) {
      $result.message = message;
    }
    return $result;
  }
  PushKeyToRemoteResponse._() : super();
  factory PushKeyToRemoteResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PushKeyToRemoteResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PushKeyToRemoteResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PushKeyToRemoteResponse clone() => PushKeyToRemoteResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PushKeyToRemoteResponse copyWith(void Function(PushKeyToRemoteResponse) updates) => super.copyWith((message) => updates(message as PushKeyToRemoteResponse)) as PushKeyToRemoteResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PushKeyToRemoteResponse create() => PushKeyToRemoteResponse._();
  PushKeyToRemoteResponse createEmptyInstance() => create();
  static $pb.PbList<PushKeyToRemoteResponse> createRepeated() => $pb.PbList<PushKeyToRemoteResponse>();
  @$core.pragma('dart2js:noInline')
  static PushKeyToRemoteResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PushKeyToRemoteResponse>(create);
  static PushKeyToRemoteResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => clearField(2);
}

class WatchKeysRequest extends $pb.GeneratedMessage {
  factory WatchKeysRequest({
    $8.Target? target,
  }) {
    final $result = create();
    if (target != null) {
      $result.target = target;
    }
    return $result;
  }
  WatchKeysRequest._() : super();
  factory WatchKeysRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory WatchKeysRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'WatchKeysRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..aOM<$8.Target>(1, _omitFieldNames ? '' : 'target', subBuilder: $8.Target.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  WatchKeysRequest clone() => WatchKeysRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  WatchKeysRequest copyWith(void Function(WatchKeysRequest) updates) => super.copyWith((message) => updates(message as WatchKeysRequest)) as WatchKeysRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WatchKeysRequest create() => WatchKeysRequest._();
  WatchKeysRequest createEmptyInstance() => create();
  static $pb.PbList<WatchKeysRequest> createRepeated() => $pb.PbList<WatchKeysRequest>();
  @$core.pragma('dart2js:noInline')
  static WatchKeysRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<WatchKeysRequest>(create);
  static WatchKeysRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $8.Target get target => $_getN(0);
  @$pb.TagNumber(1)
  set target($8.Target v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasTarget() => $_has(0);
  @$pb.TagNumber(1)
  void clearTarget() => clearField(1);
  @$pb.TagNumber(1)
  $8.Target ensureTarget() => $_ensure(0);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
