// This is a generated file - do not edit.
//
// Generated from skeys/v1/agent.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;
import '../../google/protobuf/duration.pb.dart' as $3;

import 'common.pb.dart' as $2;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

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
    final result = create();
    if (fingerprint != null) result.fingerprint = fingerprint;
    if (comment != null) result.comment = comment;
    if (type != null) result.type = type;
    if (bits != null) result.bits = bits;
    if (hasLifetime != null) result.hasLifetime = hasLifetime;
    if (lifetimeSeconds != null) result.lifetimeSeconds = lifetimeSeconds;
    if (isConfirm != null) result.isConfirm = isConfirm;
    return result;
  }

  AgentKey._();

  factory AgentKey.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AgentKey.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AgentKey',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'fingerprint')
    ..aOS(2, _omitFieldNames ? '' : 'comment')
    ..aOS(3, _omitFieldNames ? '' : 'type')
    ..aI(4, _omitFieldNames ? '' : 'bits')
    ..aOB(5, _omitFieldNames ? '' : 'hasLifetime')
    ..aI(6, _omitFieldNames ? '' : 'lifetimeSeconds')
    ..aOB(7, _omitFieldNames ? '' : 'isConfirm')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AgentKey clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AgentKey copyWith(void Function(AgentKey) updates) =>
      super.copyWith((message) => updates(message as AgentKey)) as AgentKey;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AgentKey create() => AgentKey._();
  @$core.override
  AgentKey createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AgentKey getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AgentKey>(create);
  static AgentKey? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get fingerprint => $_getSZ(0);
  @$pb.TagNumber(1)
  set fingerprint($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFingerprint() => $_has(0);
  @$pb.TagNumber(1)
  void clearFingerprint() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get comment => $_getSZ(1);
  @$pb.TagNumber(2)
  set comment($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasComment() => $_has(1);
  @$pb.TagNumber(2)
  void clearComment() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get type => $_getSZ(2);
  @$pb.TagNumber(3)
  set type($core.String value) => $_setString(2, value);
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
  $core.bool get hasLifetime => $_getBF(4);
  @$pb.TagNumber(5)
  set hasLifetime($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasHasLifetime() => $_has(4);
  @$pb.TagNumber(5)
  void clearHasLifetime() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get lifetimeSeconds => $_getIZ(5);
  @$pb.TagNumber(6)
  set lifetimeSeconds($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasLifetimeSeconds() => $_has(5);
  @$pb.TagNumber(6)
  void clearLifetimeSeconds() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get isConfirm => $_getBF(6);
  @$pb.TagNumber(7)
  set isConfirm($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasIsConfirm() => $_has(6);
  @$pb.TagNumber(7)
  void clearIsConfirm() => $_clearField(7);
}

class GetAgentStatusRequest extends $pb.GeneratedMessage {
  factory GetAgentStatusRequest({
    $2.Target? target,
  }) {
    final result = create();
    if (target != null) result.target = target;
    return result;
  }

  GetAgentStatusRequest._();

  factory GetAgentStatusRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetAgentStatusRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetAgentStatusRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOM<$2.Target>(1, _omitFieldNames ? '' : 'target',
        subBuilder: $2.Target.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAgentStatusRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAgentStatusRequest copyWith(
          void Function(GetAgentStatusRequest) updates) =>
      super.copyWith((message) => updates(message as GetAgentStatusRequest))
          as GetAgentStatusRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetAgentStatusRequest create() => GetAgentStatusRequest._();
  @$core.override
  GetAgentStatusRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetAgentStatusRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetAgentStatusRequest>(create);
  static GetAgentStatusRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.Target get target => $_getN(0);
  @$pb.TagNumber(1)
  set target($2.Target value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTarget() => $_has(0);
  @$pb.TagNumber(1)
  void clearTarget() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.Target ensureTarget() => $_ensure(0);
}

class GetAgentStatusResponse extends $pb.GeneratedMessage {
  factory GetAgentStatusResponse({
    $core.bool? running,
    $core.String? socketPath,
    $core.bool? isLocked,
    $core.int? keyCount,
  }) {
    final result = create();
    if (running != null) result.running = running;
    if (socketPath != null) result.socketPath = socketPath;
    if (isLocked != null) result.isLocked = isLocked;
    if (keyCount != null) result.keyCount = keyCount;
    return result;
  }

  GetAgentStatusResponse._();

  factory GetAgentStatusResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetAgentStatusResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetAgentStatusResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'running')
    ..aOS(2, _omitFieldNames ? '' : 'socketPath')
    ..aOB(3, _omitFieldNames ? '' : 'isLocked')
    ..aI(4, _omitFieldNames ? '' : 'keyCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAgentStatusResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAgentStatusResponse copyWith(
          void Function(GetAgentStatusResponse) updates) =>
      super.copyWith((message) => updates(message as GetAgentStatusResponse))
          as GetAgentStatusResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetAgentStatusResponse create() => GetAgentStatusResponse._();
  @$core.override
  GetAgentStatusResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetAgentStatusResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetAgentStatusResponse>(create);
  static GetAgentStatusResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get running => $_getBF(0);
  @$pb.TagNumber(1)
  set running($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRunning() => $_has(0);
  @$pb.TagNumber(1)
  void clearRunning() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get socketPath => $_getSZ(1);
  @$pb.TagNumber(2)
  set socketPath($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSocketPath() => $_has(1);
  @$pb.TagNumber(2)
  void clearSocketPath() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get isLocked => $_getBF(2);
  @$pb.TagNumber(3)
  set isLocked($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIsLocked() => $_has(2);
  @$pb.TagNumber(3)
  void clearIsLocked() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get keyCount => $_getIZ(3);
  @$pb.TagNumber(4)
  set keyCount($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasKeyCount() => $_has(3);
  @$pb.TagNumber(4)
  void clearKeyCount() => $_clearField(4);
}

class ListAgentKeysRequest extends $pb.GeneratedMessage {
  factory ListAgentKeysRequest({
    $2.Target? target,
  }) {
    final result = create();
    if (target != null) result.target = target;
    return result;
  }

  ListAgentKeysRequest._();

  factory ListAgentKeysRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListAgentKeysRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListAgentKeysRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOM<$2.Target>(1, _omitFieldNames ? '' : 'target',
        subBuilder: $2.Target.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAgentKeysRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAgentKeysRequest copyWith(void Function(ListAgentKeysRequest) updates) =>
      super.copyWith((message) => updates(message as ListAgentKeysRequest))
          as ListAgentKeysRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListAgentKeysRequest create() => ListAgentKeysRequest._();
  @$core.override
  ListAgentKeysRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListAgentKeysRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListAgentKeysRequest>(create);
  static ListAgentKeysRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.Target get target => $_getN(0);
  @$pb.TagNumber(1)
  set target($2.Target value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTarget() => $_has(0);
  @$pb.TagNumber(1)
  void clearTarget() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.Target ensureTarget() => $_ensure(0);
}

class ListAgentKeysResponse extends $pb.GeneratedMessage {
  factory ListAgentKeysResponse({
    $core.Iterable<AgentKey>? keys,
  }) {
    final result = create();
    if (keys != null) result.keys.addAll(keys);
    return result;
  }

  ListAgentKeysResponse._();

  factory ListAgentKeysResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListAgentKeysResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListAgentKeysResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..pPM<AgentKey>(1, _omitFieldNames ? '' : 'keys',
        subBuilder: AgentKey.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAgentKeysResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAgentKeysResponse copyWith(
          void Function(ListAgentKeysResponse) updates) =>
      super.copyWith((message) => updates(message as ListAgentKeysResponse))
          as ListAgentKeysResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListAgentKeysResponse create() => ListAgentKeysResponse._();
  @$core.override
  ListAgentKeysResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListAgentKeysResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListAgentKeysResponse>(create);
  static ListAgentKeysResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<AgentKey> get keys => $_getList(0);
}

class AddKeyToAgentRequest extends $pb.GeneratedMessage {
  factory AddKeyToAgentRequest({
    $2.Target? target,
    $core.String? keyPath,
    $core.String? passphrase,
    $3.Duration? lifetime,
    $core.bool? confirm,
  }) {
    final result = create();
    if (target != null) result.target = target;
    if (keyPath != null) result.keyPath = keyPath;
    if (passphrase != null) result.passphrase = passphrase;
    if (lifetime != null) result.lifetime = lifetime;
    if (confirm != null) result.confirm = confirm;
    return result;
  }

  AddKeyToAgentRequest._();

  factory AddKeyToAgentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddKeyToAgentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddKeyToAgentRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOM<$2.Target>(1, _omitFieldNames ? '' : 'target',
        subBuilder: $2.Target.create)
    ..aOS(2, _omitFieldNames ? '' : 'keyPath')
    ..aOS(3, _omitFieldNames ? '' : 'passphrase')
    ..aOM<$3.Duration>(4, _omitFieldNames ? '' : 'lifetime',
        subBuilder: $3.Duration.create)
    ..aOB(5, _omitFieldNames ? '' : 'confirm')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddKeyToAgentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddKeyToAgentRequest copyWith(void Function(AddKeyToAgentRequest) updates) =>
      super.copyWith((message) => updates(message as AddKeyToAgentRequest))
          as AddKeyToAgentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddKeyToAgentRequest create() => AddKeyToAgentRequest._();
  @$core.override
  AddKeyToAgentRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AddKeyToAgentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddKeyToAgentRequest>(create);
  static AddKeyToAgentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.Target get target => $_getN(0);
  @$pb.TagNumber(1)
  set target($2.Target value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTarget() => $_has(0);
  @$pb.TagNumber(1)
  void clearTarget() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.Target ensureTarget() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get keyPath => $_getSZ(1);
  @$pb.TagNumber(2)
  set keyPath($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasKeyPath() => $_has(1);
  @$pb.TagNumber(2)
  void clearKeyPath() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get passphrase => $_getSZ(2);
  @$pb.TagNumber(3)
  set passphrase($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPassphrase() => $_has(2);
  @$pb.TagNumber(3)
  void clearPassphrase() => $_clearField(3);

  @$pb.TagNumber(4)
  $3.Duration get lifetime => $_getN(3);
  @$pb.TagNumber(4)
  set lifetime($3.Duration value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasLifetime() => $_has(3);
  @$pb.TagNumber(4)
  void clearLifetime() => $_clearField(4);
  @$pb.TagNumber(4)
  $3.Duration ensureLifetime() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.bool get confirm => $_getBF(4);
  @$pb.TagNumber(5)
  set confirm($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasConfirm() => $_has(4);
  @$pb.TagNumber(5)
  void clearConfirm() => $_clearField(5);
}

class RemoveKeyFromAgentRequest extends $pb.GeneratedMessage {
  factory RemoveKeyFromAgentRequest({
    $2.Target? target,
    $core.String? fingerprint,
  }) {
    final result = create();
    if (target != null) result.target = target;
    if (fingerprint != null) result.fingerprint = fingerprint;
    return result;
  }

  RemoveKeyFromAgentRequest._();

  factory RemoveKeyFromAgentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RemoveKeyFromAgentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RemoveKeyFromAgentRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOM<$2.Target>(1, _omitFieldNames ? '' : 'target',
        subBuilder: $2.Target.create)
    ..aOS(2, _omitFieldNames ? '' : 'fingerprint')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemoveKeyFromAgentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemoveKeyFromAgentRequest copyWith(
          void Function(RemoveKeyFromAgentRequest) updates) =>
      super.copyWith((message) => updates(message as RemoveKeyFromAgentRequest))
          as RemoveKeyFromAgentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RemoveKeyFromAgentRequest create() => RemoveKeyFromAgentRequest._();
  @$core.override
  RemoveKeyFromAgentRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RemoveKeyFromAgentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RemoveKeyFromAgentRequest>(create);
  static RemoveKeyFromAgentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.Target get target => $_getN(0);
  @$pb.TagNumber(1)
  set target($2.Target value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTarget() => $_has(0);
  @$pb.TagNumber(1)
  void clearTarget() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.Target ensureTarget() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get fingerprint => $_getSZ(1);
  @$pb.TagNumber(2)
  set fingerprint($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFingerprint() => $_has(1);
  @$pb.TagNumber(2)
  void clearFingerprint() => $_clearField(2);
}

class RemoveAllKeysFromAgentRequest extends $pb.GeneratedMessage {
  factory RemoveAllKeysFromAgentRequest({
    $2.Target? target,
  }) {
    final result = create();
    if (target != null) result.target = target;
    return result;
  }

  RemoveAllKeysFromAgentRequest._();

  factory RemoveAllKeysFromAgentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RemoveAllKeysFromAgentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RemoveAllKeysFromAgentRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOM<$2.Target>(1, _omitFieldNames ? '' : 'target',
        subBuilder: $2.Target.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemoveAllKeysFromAgentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemoveAllKeysFromAgentRequest copyWith(
          void Function(RemoveAllKeysFromAgentRequest) updates) =>
      super.copyWith(
              (message) => updates(message as RemoveAllKeysFromAgentRequest))
          as RemoveAllKeysFromAgentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RemoveAllKeysFromAgentRequest create() =>
      RemoveAllKeysFromAgentRequest._();
  @$core.override
  RemoveAllKeysFromAgentRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RemoveAllKeysFromAgentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RemoveAllKeysFromAgentRequest>(create);
  static RemoveAllKeysFromAgentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.Target get target => $_getN(0);
  @$pb.TagNumber(1)
  set target($2.Target value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTarget() => $_has(0);
  @$pb.TagNumber(1)
  void clearTarget() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.Target ensureTarget() => $_ensure(0);
}

class LockAgentRequest extends $pb.GeneratedMessage {
  factory LockAgentRequest({
    $2.Target? target,
    $core.String? passphrase,
  }) {
    final result = create();
    if (target != null) result.target = target;
    if (passphrase != null) result.passphrase = passphrase;
    return result;
  }

  LockAgentRequest._();

  factory LockAgentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LockAgentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LockAgentRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOM<$2.Target>(1, _omitFieldNames ? '' : 'target',
        subBuilder: $2.Target.create)
    ..aOS(2, _omitFieldNames ? '' : 'passphrase')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LockAgentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LockAgentRequest copyWith(void Function(LockAgentRequest) updates) =>
      super.copyWith((message) => updates(message as LockAgentRequest))
          as LockAgentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LockAgentRequest create() => LockAgentRequest._();
  @$core.override
  LockAgentRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LockAgentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LockAgentRequest>(create);
  static LockAgentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.Target get target => $_getN(0);
  @$pb.TagNumber(1)
  set target($2.Target value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTarget() => $_has(0);
  @$pb.TagNumber(1)
  void clearTarget() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.Target ensureTarget() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get passphrase => $_getSZ(1);
  @$pb.TagNumber(2)
  set passphrase($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPassphrase() => $_has(1);
  @$pb.TagNumber(2)
  void clearPassphrase() => $_clearField(2);
}

class UnlockAgentRequest extends $pb.GeneratedMessage {
  factory UnlockAgentRequest({
    $2.Target? target,
    $core.String? passphrase,
  }) {
    final result = create();
    if (target != null) result.target = target;
    if (passphrase != null) result.passphrase = passphrase;
    return result;
  }

  UnlockAgentRequest._();

  factory UnlockAgentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UnlockAgentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UnlockAgentRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOM<$2.Target>(1, _omitFieldNames ? '' : 'target',
        subBuilder: $2.Target.create)
    ..aOS(2, _omitFieldNames ? '' : 'passphrase')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnlockAgentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnlockAgentRequest copyWith(void Function(UnlockAgentRequest) updates) =>
      super.copyWith((message) => updates(message as UnlockAgentRequest))
          as UnlockAgentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UnlockAgentRequest create() => UnlockAgentRequest._();
  @$core.override
  UnlockAgentRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UnlockAgentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UnlockAgentRequest>(create);
  static UnlockAgentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.Target get target => $_getN(0);
  @$pb.TagNumber(1)
  set target($2.Target value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTarget() => $_has(0);
  @$pb.TagNumber(1)
  void clearTarget() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.Target ensureTarget() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get passphrase => $_getSZ(1);
  @$pb.TagNumber(2)
  set passphrase($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPassphrase() => $_has(1);
  @$pb.TagNumber(2)
  void clearPassphrase() => $_clearField(2);
}

class WatchAgentRequest extends $pb.GeneratedMessage {
  factory WatchAgentRequest({
    $2.Target? target,
  }) {
    final result = create();
    if (target != null) result.target = target;
    return result;
  }

  WatchAgentRequest._();

  factory WatchAgentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WatchAgentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WatchAgentRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOM<$2.Target>(1, _omitFieldNames ? '' : 'target',
        subBuilder: $2.Target.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchAgentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchAgentRequest copyWith(void Function(WatchAgentRequest) updates) =>
      super.copyWith((message) => updates(message as WatchAgentRequest))
          as WatchAgentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WatchAgentRequest create() => WatchAgentRequest._();
  @$core.override
  WatchAgentRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WatchAgentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WatchAgentRequest>(create);
  static WatchAgentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.Target get target => $_getN(0);
  @$pb.TagNumber(1)
  set target($2.Target value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTarget() => $_has(0);
  @$pb.TagNumber(1)
  void clearTarget() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.Target ensureTarget() => $_ensure(0);
}

class WatchAgentResponse extends $pb.GeneratedMessage {
  factory WatchAgentResponse({
    $core.bool? running,
    $core.String? socketPath,
    $core.bool? isLocked,
    $core.Iterable<AgentKey>? keys,
  }) {
    final result = create();
    if (running != null) result.running = running;
    if (socketPath != null) result.socketPath = socketPath;
    if (isLocked != null) result.isLocked = isLocked;
    if (keys != null) result.keys.addAll(keys);
    return result;
  }

  WatchAgentResponse._();

  factory WatchAgentResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WatchAgentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WatchAgentResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'running')
    ..aOS(2, _omitFieldNames ? '' : 'socketPath')
    ..aOB(3, _omitFieldNames ? '' : 'isLocked')
    ..pPM<AgentKey>(4, _omitFieldNames ? '' : 'keys',
        subBuilder: AgentKey.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchAgentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchAgentResponse copyWith(void Function(WatchAgentResponse) updates) =>
      super.copyWith((message) => updates(message as WatchAgentResponse))
          as WatchAgentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WatchAgentResponse create() => WatchAgentResponse._();
  @$core.override
  WatchAgentResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WatchAgentResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WatchAgentResponse>(create);
  static WatchAgentResponse? _defaultInstance;

  /// Status info
  @$pb.TagNumber(1)
  $core.bool get running => $_getBF(0);
  @$pb.TagNumber(1)
  set running($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRunning() => $_has(0);
  @$pb.TagNumber(1)
  void clearRunning() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get socketPath => $_getSZ(1);
  @$pb.TagNumber(2)
  set socketPath($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSocketPath() => $_has(1);
  @$pb.TagNumber(2)
  void clearSocketPath() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get isLocked => $_getBF(2);
  @$pb.TagNumber(3)
  set isLocked($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIsLocked() => $_has(2);
  @$pb.TagNumber(3)
  void clearIsLocked() => $_clearField(3);

  /// Keys currently loaded
  @$pb.TagNumber(4)
  $pb.PbList<AgentKey> get keys => $_getList(3);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
