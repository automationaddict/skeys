//
//  Generated code. Do not modify.
//  source: skeys/v1/agent.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../../google/protobuf/duration.pb.dart' as $7;
import 'common.pb.dart' as $6;

class AgentKey extends $pb.GeneratedMessage {
  factory AgentKey({
    $core.String? fingerprint,
    $core.String? comment,
    $core.String? type,
    $core.int? bits,
    $core.bool? hasLifetime,
    $core.int? lifetimeSeconds,
    $core.bool? isConfirm,
  }) {
    final $result = create();
    if (fingerprint != null) {
      $result.fingerprint = fingerprint;
    }
    if (comment != null) {
      $result.comment = comment;
    }
    if (type != null) {
      $result.type = type;
    }
    if (bits != null) {
      $result.bits = bits;
    }
    if (hasLifetime != null) {
      $result.hasLifetime = hasLifetime;
    }
    if (lifetimeSeconds != null) {
      $result.lifetimeSeconds = lifetimeSeconds;
    }
    if (isConfirm != null) {
      $result.isConfirm = isConfirm;
    }
    return $result;
  }
  AgentKey._() : super();
  factory AgentKey.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AgentKey.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AgentKey', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'fingerprint')
    ..aOS(2, _omitFieldNames ? '' : 'comment')
    ..aOS(3, _omitFieldNames ? '' : 'type')
    ..a<$core.int>(4, _omitFieldNames ? '' : 'bits', $pb.PbFieldType.O3)
    ..aOB(5, _omitFieldNames ? '' : 'hasLifetime')
    ..a<$core.int>(6, _omitFieldNames ? '' : 'lifetimeSeconds', $pb.PbFieldType.O3)
    ..aOB(7, _omitFieldNames ? '' : 'isConfirm')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AgentKey clone() => AgentKey()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AgentKey copyWith(void Function(AgentKey) updates) => super.copyWith((message) => updates(message as AgentKey)) as AgentKey;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AgentKey create() => AgentKey._();
  AgentKey createEmptyInstance() => create();
  static $pb.PbList<AgentKey> createRepeated() => $pb.PbList<AgentKey>();
  @$core.pragma('dart2js:noInline')
  static AgentKey getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AgentKey>(create);
  static AgentKey? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get fingerprint => $_getSZ(0);
  @$pb.TagNumber(1)
  set fingerprint($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasFingerprint() => $_has(0);
  @$pb.TagNumber(1)
  void clearFingerprint() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get comment => $_getSZ(1);
  @$pb.TagNumber(2)
  set comment($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasComment() => $_has(1);
  @$pb.TagNumber(2)
  void clearComment() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get type => $_getSZ(2);
  @$pb.TagNumber(3)
  set type($core.String v) { $_setString(2, v); }
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
  $core.bool get hasLifetime => $_getBF(4);
  @$pb.TagNumber(5)
  set hasLifetime($core.bool v) { $_setBool(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasHasLifetime() => $_has(4);
  @$pb.TagNumber(5)
  void clearHasLifetime() => clearField(5);

  @$pb.TagNumber(6)
  $core.int get lifetimeSeconds => $_getIZ(5);
  @$pb.TagNumber(6)
  set lifetimeSeconds($core.int v) { $_setSignedInt32(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasLifetimeSeconds() => $_has(5);
  @$pb.TagNumber(6)
  void clearLifetimeSeconds() => clearField(6);

  @$pb.TagNumber(7)
  $core.bool get isConfirm => $_getBF(6);
  @$pb.TagNumber(7)
  set isConfirm($core.bool v) { $_setBool(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasIsConfirm() => $_has(6);
  @$pb.TagNumber(7)
  void clearIsConfirm() => clearField(7);
}

class GetAgentStatusRequest extends $pb.GeneratedMessage {
  factory GetAgentStatusRequest({
    $6.Target? target,
  }) {
    final $result = create();
    if (target != null) {
      $result.target = target;
    }
    return $result;
  }
  GetAgentStatusRequest._() : super();
  factory GetAgentStatusRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetAgentStatusRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetAgentStatusRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..aOM<$6.Target>(1, _omitFieldNames ? '' : 'target', subBuilder: $6.Target.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetAgentStatusRequest clone() => GetAgentStatusRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetAgentStatusRequest copyWith(void Function(GetAgentStatusRequest) updates) => super.copyWith((message) => updates(message as GetAgentStatusRequest)) as GetAgentStatusRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetAgentStatusRequest create() => GetAgentStatusRequest._();
  GetAgentStatusRequest createEmptyInstance() => create();
  static $pb.PbList<GetAgentStatusRequest> createRepeated() => $pb.PbList<GetAgentStatusRequest>();
  @$core.pragma('dart2js:noInline')
  static GetAgentStatusRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetAgentStatusRequest>(create);
  static GetAgentStatusRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $6.Target get target => $_getN(0);
  @$pb.TagNumber(1)
  set target($6.Target v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasTarget() => $_has(0);
  @$pb.TagNumber(1)
  void clearTarget() => clearField(1);
  @$pb.TagNumber(1)
  $6.Target ensureTarget() => $_ensure(0);
}

class GetAgentStatusResponse extends $pb.GeneratedMessage {
  factory GetAgentStatusResponse({
    $core.bool? running,
    $core.String? socketPath,
    $core.bool? isLocked,
    $core.int? keyCount,
  }) {
    final $result = create();
    if (running != null) {
      $result.running = running;
    }
    if (socketPath != null) {
      $result.socketPath = socketPath;
    }
    if (isLocked != null) {
      $result.isLocked = isLocked;
    }
    if (keyCount != null) {
      $result.keyCount = keyCount;
    }
    return $result;
  }
  GetAgentStatusResponse._() : super();
  factory GetAgentStatusResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetAgentStatusResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetAgentStatusResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'running')
    ..aOS(2, _omitFieldNames ? '' : 'socketPath')
    ..aOB(3, _omitFieldNames ? '' : 'isLocked')
    ..a<$core.int>(4, _omitFieldNames ? '' : 'keyCount', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetAgentStatusResponse clone() => GetAgentStatusResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetAgentStatusResponse copyWith(void Function(GetAgentStatusResponse) updates) => super.copyWith((message) => updates(message as GetAgentStatusResponse)) as GetAgentStatusResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetAgentStatusResponse create() => GetAgentStatusResponse._();
  GetAgentStatusResponse createEmptyInstance() => create();
  static $pb.PbList<GetAgentStatusResponse> createRepeated() => $pb.PbList<GetAgentStatusResponse>();
  @$core.pragma('dart2js:noInline')
  static GetAgentStatusResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetAgentStatusResponse>(create);
  static GetAgentStatusResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get running => $_getBF(0);
  @$pb.TagNumber(1)
  set running($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasRunning() => $_has(0);
  @$pb.TagNumber(1)
  void clearRunning() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get socketPath => $_getSZ(1);
  @$pb.TagNumber(2)
  set socketPath($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSocketPath() => $_has(1);
  @$pb.TagNumber(2)
  void clearSocketPath() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get isLocked => $_getBF(2);
  @$pb.TagNumber(3)
  set isLocked($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasIsLocked() => $_has(2);
  @$pb.TagNumber(3)
  void clearIsLocked() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get keyCount => $_getIZ(3);
  @$pb.TagNumber(4)
  set keyCount($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasKeyCount() => $_has(3);
  @$pb.TagNumber(4)
  void clearKeyCount() => clearField(4);
}

class ListAgentKeysRequest extends $pb.GeneratedMessage {
  factory ListAgentKeysRequest({
    $6.Target? target,
  }) {
    final $result = create();
    if (target != null) {
      $result.target = target;
    }
    return $result;
  }
  ListAgentKeysRequest._() : super();
  factory ListAgentKeysRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListAgentKeysRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListAgentKeysRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..aOM<$6.Target>(1, _omitFieldNames ? '' : 'target', subBuilder: $6.Target.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListAgentKeysRequest clone() => ListAgentKeysRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListAgentKeysRequest copyWith(void Function(ListAgentKeysRequest) updates) => super.copyWith((message) => updates(message as ListAgentKeysRequest)) as ListAgentKeysRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListAgentKeysRequest create() => ListAgentKeysRequest._();
  ListAgentKeysRequest createEmptyInstance() => create();
  static $pb.PbList<ListAgentKeysRequest> createRepeated() => $pb.PbList<ListAgentKeysRequest>();
  @$core.pragma('dart2js:noInline')
  static ListAgentKeysRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListAgentKeysRequest>(create);
  static ListAgentKeysRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $6.Target get target => $_getN(0);
  @$pb.TagNumber(1)
  set target($6.Target v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasTarget() => $_has(0);
  @$pb.TagNumber(1)
  void clearTarget() => clearField(1);
  @$pb.TagNumber(1)
  $6.Target ensureTarget() => $_ensure(0);
}

class ListAgentKeysResponse extends $pb.GeneratedMessage {
  factory ListAgentKeysResponse({
    $core.Iterable<AgentKey>? keys,
  }) {
    final $result = create();
    if (keys != null) {
      $result.keys.addAll(keys);
    }
    return $result;
  }
  ListAgentKeysResponse._() : super();
  factory ListAgentKeysResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListAgentKeysResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListAgentKeysResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..pc<AgentKey>(1, _omitFieldNames ? '' : 'keys', $pb.PbFieldType.PM, subBuilder: AgentKey.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListAgentKeysResponse clone() => ListAgentKeysResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListAgentKeysResponse copyWith(void Function(ListAgentKeysResponse) updates) => super.copyWith((message) => updates(message as ListAgentKeysResponse)) as ListAgentKeysResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListAgentKeysResponse create() => ListAgentKeysResponse._();
  ListAgentKeysResponse createEmptyInstance() => create();
  static $pb.PbList<ListAgentKeysResponse> createRepeated() => $pb.PbList<ListAgentKeysResponse>();
  @$core.pragma('dart2js:noInline')
  static ListAgentKeysResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListAgentKeysResponse>(create);
  static ListAgentKeysResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<AgentKey> get keys => $_getList(0);
}

class AddKeyToAgentRequest extends $pb.GeneratedMessage {
  factory AddKeyToAgentRequest({
    $6.Target? target,
    $core.String? keyPath,
    $core.String? passphrase,
    $7.Duration? lifetime,
    $core.bool? confirm,
  }) {
    final $result = create();
    if (target != null) {
      $result.target = target;
    }
    if (keyPath != null) {
      $result.keyPath = keyPath;
    }
    if (passphrase != null) {
      $result.passphrase = passphrase;
    }
    if (lifetime != null) {
      $result.lifetime = lifetime;
    }
    if (confirm != null) {
      $result.confirm = confirm;
    }
    return $result;
  }
  AddKeyToAgentRequest._() : super();
  factory AddKeyToAgentRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AddKeyToAgentRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AddKeyToAgentRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..aOM<$6.Target>(1, _omitFieldNames ? '' : 'target', subBuilder: $6.Target.create)
    ..aOS(2, _omitFieldNames ? '' : 'keyPath')
    ..aOS(3, _omitFieldNames ? '' : 'passphrase')
    ..aOM<$7.Duration>(4, _omitFieldNames ? '' : 'lifetime', subBuilder: $7.Duration.create)
    ..aOB(5, _omitFieldNames ? '' : 'confirm')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AddKeyToAgentRequest clone() => AddKeyToAgentRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AddKeyToAgentRequest copyWith(void Function(AddKeyToAgentRequest) updates) => super.copyWith((message) => updates(message as AddKeyToAgentRequest)) as AddKeyToAgentRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddKeyToAgentRequest create() => AddKeyToAgentRequest._();
  AddKeyToAgentRequest createEmptyInstance() => create();
  static $pb.PbList<AddKeyToAgentRequest> createRepeated() => $pb.PbList<AddKeyToAgentRequest>();
  @$core.pragma('dart2js:noInline')
  static AddKeyToAgentRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AddKeyToAgentRequest>(create);
  static AddKeyToAgentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $6.Target get target => $_getN(0);
  @$pb.TagNumber(1)
  set target($6.Target v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasTarget() => $_has(0);
  @$pb.TagNumber(1)
  void clearTarget() => clearField(1);
  @$pb.TagNumber(1)
  $6.Target ensureTarget() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get keyPath => $_getSZ(1);
  @$pb.TagNumber(2)
  set keyPath($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasKeyPath() => $_has(1);
  @$pb.TagNumber(2)
  void clearKeyPath() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get passphrase => $_getSZ(2);
  @$pb.TagNumber(3)
  set passphrase($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPassphrase() => $_has(2);
  @$pb.TagNumber(3)
  void clearPassphrase() => clearField(3);

  @$pb.TagNumber(4)
  $7.Duration get lifetime => $_getN(3);
  @$pb.TagNumber(4)
  set lifetime($7.Duration v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasLifetime() => $_has(3);
  @$pb.TagNumber(4)
  void clearLifetime() => clearField(4);
  @$pb.TagNumber(4)
  $7.Duration ensureLifetime() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.bool get confirm => $_getBF(4);
  @$pb.TagNumber(5)
  set confirm($core.bool v) { $_setBool(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasConfirm() => $_has(4);
  @$pb.TagNumber(5)
  void clearConfirm() => clearField(5);
}

class RemoveKeyFromAgentRequest extends $pb.GeneratedMessage {
  factory RemoveKeyFromAgentRequest({
    $6.Target? target,
    $core.String? fingerprint,
  }) {
    final $result = create();
    if (target != null) {
      $result.target = target;
    }
    if (fingerprint != null) {
      $result.fingerprint = fingerprint;
    }
    return $result;
  }
  RemoveKeyFromAgentRequest._() : super();
  factory RemoveKeyFromAgentRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RemoveKeyFromAgentRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RemoveKeyFromAgentRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..aOM<$6.Target>(1, _omitFieldNames ? '' : 'target', subBuilder: $6.Target.create)
    ..aOS(2, _omitFieldNames ? '' : 'fingerprint')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RemoveKeyFromAgentRequest clone() => RemoveKeyFromAgentRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RemoveKeyFromAgentRequest copyWith(void Function(RemoveKeyFromAgentRequest) updates) => super.copyWith((message) => updates(message as RemoveKeyFromAgentRequest)) as RemoveKeyFromAgentRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RemoveKeyFromAgentRequest create() => RemoveKeyFromAgentRequest._();
  RemoveKeyFromAgentRequest createEmptyInstance() => create();
  static $pb.PbList<RemoveKeyFromAgentRequest> createRepeated() => $pb.PbList<RemoveKeyFromAgentRequest>();
  @$core.pragma('dart2js:noInline')
  static RemoveKeyFromAgentRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RemoveKeyFromAgentRequest>(create);
  static RemoveKeyFromAgentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $6.Target get target => $_getN(0);
  @$pb.TagNumber(1)
  set target($6.Target v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasTarget() => $_has(0);
  @$pb.TagNumber(1)
  void clearTarget() => clearField(1);
  @$pb.TagNumber(1)
  $6.Target ensureTarget() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get fingerprint => $_getSZ(1);
  @$pb.TagNumber(2)
  set fingerprint($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasFingerprint() => $_has(1);
  @$pb.TagNumber(2)
  void clearFingerprint() => clearField(2);
}

class RemoveAllKeysFromAgentRequest extends $pb.GeneratedMessage {
  factory RemoveAllKeysFromAgentRequest({
    $6.Target? target,
  }) {
    final $result = create();
    if (target != null) {
      $result.target = target;
    }
    return $result;
  }
  RemoveAllKeysFromAgentRequest._() : super();
  factory RemoveAllKeysFromAgentRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RemoveAllKeysFromAgentRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RemoveAllKeysFromAgentRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..aOM<$6.Target>(1, _omitFieldNames ? '' : 'target', subBuilder: $6.Target.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RemoveAllKeysFromAgentRequest clone() => RemoveAllKeysFromAgentRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RemoveAllKeysFromAgentRequest copyWith(void Function(RemoveAllKeysFromAgentRequest) updates) => super.copyWith((message) => updates(message as RemoveAllKeysFromAgentRequest)) as RemoveAllKeysFromAgentRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RemoveAllKeysFromAgentRequest create() => RemoveAllKeysFromAgentRequest._();
  RemoveAllKeysFromAgentRequest createEmptyInstance() => create();
  static $pb.PbList<RemoveAllKeysFromAgentRequest> createRepeated() => $pb.PbList<RemoveAllKeysFromAgentRequest>();
  @$core.pragma('dart2js:noInline')
  static RemoveAllKeysFromAgentRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RemoveAllKeysFromAgentRequest>(create);
  static RemoveAllKeysFromAgentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $6.Target get target => $_getN(0);
  @$pb.TagNumber(1)
  set target($6.Target v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasTarget() => $_has(0);
  @$pb.TagNumber(1)
  void clearTarget() => clearField(1);
  @$pb.TagNumber(1)
  $6.Target ensureTarget() => $_ensure(0);
}

class LockAgentRequest extends $pb.GeneratedMessage {
  factory LockAgentRequest({
    $6.Target? target,
    $core.String? passphrase,
  }) {
    final $result = create();
    if (target != null) {
      $result.target = target;
    }
    if (passphrase != null) {
      $result.passphrase = passphrase;
    }
    return $result;
  }
  LockAgentRequest._() : super();
  factory LockAgentRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LockAgentRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LockAgentRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..aOM<$6.Target>(1, _omitFieldNames ? '' : 'target', subBuilder: $6.Target.create)
    ..aOS(2, _omitFieldNames ? '' : 'passphrase')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LockAgentRequest clone() => LockAgentRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LockAgentRequest copyWith(void Function(LockAgentRequest) updates) => super.copyWith((message) => updates(message as LockAgentRequest)) as LockAgentRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LockAgentRequest create() => LockAgentRequest._();
  LockAgentRequest createEmptyInstance() => create();
  static $pb.PbList<LockAgentRequest> createRepeated() => $pb.PbList<LockAgentRequest>();
  @$core.pragma('dart2js:noInline')
  static LockAgentRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LockAgentRequest>(create);
  static LockAgentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $6.Target get target => $_getN(0);
  @$pb.TagNumber(1)
  set target($6.Target v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasTarget() => $_has(0);
  @$pb.TagNumber(1)
  void clearTarget() => clearField(1);
  @$pb.TagNumber(1)
  $6.Target ensureTarget() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get passphrase => $_getSZ(1);
  @$pb.TagNumber(2)
  set passphrase($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPassphrase() => $_has(1);
  @$pb.TagNumber(2)
  void clearPassphrase() => clearField(2);
}

class UnlockAgentRequest extends $pb.GeneratedMessage {
  factory UnlockAgentRequest({
    $6.Target? target,
    $core.String? passphrase,
  }) {
    final $result = create();
    if (target != null) {
      $result.target = target;
    }
    if (passphrase != null) {
      $result.passphrase = passphrase;
    }
    return $result;
  }
  UnlockAgentRequest._() : super();
  factory UnlockAgentRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UnlockAgentRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UnlockAgentRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..aOM<$6.Target>(1, _omitFieldNames ? '' : 'target', subBuilder: $6.Target.create)
    ..aOS(2, _omitFieldNames ? '' : 'passphrase')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UnlockAgentRequest clone() => UnlockAgentRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UnlockAgentRequest copyWith(void Function(UnlockAgentRequest) updates) => super.copyWith((message) => updates(message as UnlockAgentRequest)) as UnlockAgentRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UnlockAgentRequest create() => UnlockAgentRequest._();
  UnlockAgentRequest createEmptyInstance() => create();
  static $pb.PbList<UnlockAgentRequest> createRepeated() => $pb.PbList<UnlockAgentRequest>();
  @$core.pragma('dart2js:noInline')
  static UnlockAgentRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UnlockAgentRequest>(create);
  static UnlockAgentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $6.Target get target => $_getN(0);
  @$pb.TagNumber(1)
  set target($6.Target v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasTarget() => $_has(0);
  @$pb.TagNumber(1)
  void clearTarget() => clearField(1);
  @$pb.TagNumber(1)
  $6.Target ensureTarget() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get passphrase => $_getSZ(1);
  @$pb.TagNumber(2)
  set passphrase($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPassphrase() => $_has(1);
  @$pb.TagNumber(2)
  void clearPassphrase() => clearField(2);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
