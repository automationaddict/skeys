// This is a generated file - do not edit.
//
// Generated from skeys/v1/hosts.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'common.pb.dart' as $2;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class KnownHost extends $pb.GeneratedMessage {
  factory KnownHost({
    $core.String? id,
    $core.Iterable<$core.String>? hostnames,
    $core.String? keyType,
    $core.String? fingerprint,
    $core.String? publicKey,
    $core.bool? isHashed,
    $core.bool? isRevoked,
    $core.bool? isCertAuthority,
    $core.int? lineNumber,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (hostnames != null) result.hostnames.addAll(hostnames);
    if (keyType != null) result.keyType = keyType;
    if (fingerprint != null) result.fingerprint = fingerprint;
    if (publicKey != null) result.publicKey = publicKey;
    if (isHashed != null) result.isHashed = isHashed;
    if (isRevoked != null) result.isRevoked = isRevoked;
    if (isCertAuthority != null) result.isCertAuthority = isCertAuthority;
    if (lineNumber != null) result.lineNumber = lineNumber;
    return result;
  }

  KnownHost._();

  factory KnownHost.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory KnownHost.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'KnownHost',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..pPS(2, _omitFieldNames ? '' : 'hostnames')
    ..aOS(3, _omitFieldNames ? '' : 'keyType')
    ..aOS(4, _omitFieldNames ? '' : 'fingerprint')
    ..aOS(5, _omitFieldNames ? '' : 'publicKey')
    ..aOB(6, _omitFieldNames ? '' : 'isHashed')
    ..aOB(7, _omitFieldNames ? '' : 'isRevoked')
    ..aOB(8, _omitFieldNames ? '' : 'isCertAuthority')
    ..aI(9, _omitFieldNames ? '' : 'lineNumber')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  KnownHost clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  KnownHost copyWith(void Function(KnownHost) updates) =>
      super.copyWith((message) => updates(message as KnownHost)) as KnownHost;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static KnownHost create() => KnownHost._();
  @$core.override
  KnownHost createEmptyInstance() => create();
  static $pb.PbList<KnownHost> createRepeated() => $pb.PbList<KnownHost>();
  @$core.pragma('dart2js:noInline')
  static KnownHost getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<KnownHost>(create);
  static KnownHost? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get hostnames => $_getList(1);

  @$pb.TagNumber(3)
  $core.String get keyType => $_getSZ(2);
  @$pb.TagNumber(3)
  set keyType($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasKeyType() => $_has(2);
  @$pb.TagNumber(3)
  void clearKeyType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get fingerprint => $_getSZ(3);
  @$pb.TagNumber(4)
  set fingerprint($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFingerprint() => $_has(3);
  @$pb.TagNumber(4)
  void clearFingerprint() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get publicKey => $_getSZ(4);
  @$pb.TagNumber(5)
  set publicKey($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPublicKey() => $_has(4);
  @$pb.TagNumber(5)
  void clearPublicKey() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get isHashed => $_getBF(5);
  @$pb.TagNumber(6)
  set isHashed($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasIsHashed() => $_has(5);
  @$pb.TagNumber(6)
  void clearIsHashed() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get isRevoked => $_getBF(6);
  @$pb.TagNumber(7)
  set isRevoked($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasIsRevoked() => $_has(6);
  @$pb.TagNumber(7)
  void clearIsRevoked() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get isCertAuthority => $_getBF(7);
  @$pb.TagNumber(8)
  set isCertAuthority($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasIsCertAuthority() => $_has(7);
  @$pb.TagNumber(8)
  void clearIsCertAuthority() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get lineNumber => $_getIZ(8);
  @$pb.TagNumber(9)
  set lineNumber($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasLineNumber() => $_has(8);
  @$pb.TagNumber(9)
  void clearLineNumber() => $_clearField(9);
}

class ListKnownHostsRequest extends $pb.GeneratedMessage {
  factory ListKnownHostsRequest({
    $2.Target? target,
  }) {
    final result = create();
    if (target != null) result.target = target;
    return result;
  }

  ListKnownHostsRequest._();

  factory ListKnownHostsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListKnownHostsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListKnownHostsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOM<$2.Target>(1, _omitFieldNames ? '' : 'target',
        subBuilder: $2.Target.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListKnownHostsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListKnownHostsRequest copyWith(
          void Function(ListKnownHostsRequest) updates) =>
      super.copyWith((message) => updates(message as ListKnownHostsRequest))
          as ListKnownHostsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListKnownHostsRequest create() => ListKnownHostsRequest._();
  @$core.override
  ListKnownHostsRequest createEmptyInstance() => create();
  static $pb.PbList<ListKnownHostsRequest> createRepeated() =>
      $pb.PbList<ListKnownHostsRequest>();
  @$core.pragma('dart2js:noInline')
  static ListKnownHostsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListKnownHostsRequest>(create);
  static ListKnownHostsRequest? _defaultInstance;

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

class ListKnownHostsResponse extends $pb.GeneratedMessage {
  factory ListKnownHostsResponse({
    $core.Iterable<KnownHost>? hosts,
  }) {
    final result = create();
    if (hosts != null) result.hosts.addAll(hosts);
    return result;
  }

  ListKnownHostsResponse._();

  factory ListKnownHostsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListKnownHostsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListKnownHostsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..pPM<KnownHost>(1, _omitFieldNames ? '' : 'hosts',
        subBuilder: KnownHost.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListKnownHostsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListKnownHostsResponse copyWith(
          void Function(ListKnownHostsResponse) updates) =>
      super.copyWith((message) => updates(message as ListKnownHostsResponse))
          as ListKnownHostsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListKnownHostsResponse create() => ListKnownHostsResponse._();
  @$core.override
  ListKnownHostsResponse createEmptyInstance() => create();
  static $pb.PbList<ListKnownHostsResponse> createRepeated() =>
      $pb.PbList<ListKnownHostsResponse>();
  @$core.pragma('dart2js:noInline')
  static ListKnownHostsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListKnownHostsResponse>(create);
  static ListKnownHostsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<KnownHost> get hosts => $_getList(0);
}

class GetKnownHostRequest extends $pb.GeneratedMessage {
  factory GetKnownHostRequest({
    $2.Target? target,
    $core.String? hostname,
    $core.int? port,
  }) {
    final result = create();
    if (target != null) result.target = target;
    if (hostname != null) result.hostname = hostname;
    if (port != null) result.port = port;
    return result;
  }

  GetKnownHostRequest._();

  factory GetKnownHostRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetKnownHostRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetKnownHostRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOM<$2.Target>(1, _omitFieldNames ? '' : 'target',
        subBuilder: $2.Target.create)
    ..aOS(2, _omitFieldNames ? '' : 'hostname')
    ..aI(3, _omitFieldNames ? '' : 'port')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetKnownHostRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetKnownHostRequest copyWith(void Function(GetKnownHostRequest) updates) =>
      super.copyWith((message) => updates(message as GetKnownHostRequest))
          as GetKnownHostRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetKnownHostRequest create() => GetKnownHostRequest._();
  @$core.override
  GetKnownHostRequest createEmptyInstance() => create();
  static $pb.PbList<GetKnownHostRequest> createRepeated() =>
      $pb.PbList<GetKnownHostRequest>();
  @$core.pragma('dart2js:noInline')
  static GetKnownHostRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetKnownHostRequest>(create);
  static GetKnownHostRequest? _defaultInstance;

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
  $core.String get hostname => $_getSZ(1);
  @$pb.TagNumber(2)
  set hostname($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasHostname() => $_has(1);
  @$pb.TagNumber(2)
  void clearHostname() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get port => $_getIZ(2);
  @$pb.TagNumber(3)
  set port($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPort() => $_has(2);
  @$pb.TagNumber(3)
  void clearPort() => $_clearField(3);
}

class GetKnownHostResponse extends $pb.GeneratedMessage {
  factory GetKnownHostResponse({
    $core.Iterable<KnownHost>? hosts,
  }) {
    final result = create();
    if (hosts != null) result.hosts.addAll(hosts);
    return result;
  }

  GetKnownHostResponse._();

  factory GetKnownHostResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetKnownHostResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetKnownHostResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..pPM<KnownHost>(1, _omitFieldNames ? '' : 'hosts',
        subBuilder: KnownHost.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetKnownHostResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetKnownHostResponse copyWith(void Function(GetKnownHostResponse) updates) =>
      super.copyWith((message) => updates(message as GetKnownHostResponse))
          as GetKnownHostResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetKnownHostResponse create() => GetKnownHostResponse._();
  @$core.override
  GetKnownHostResponse createEmptyInstance() => create();
  static $pb.PbList<GetKnownHostResponse> createRepeated() =>
      $pb.PbList<GetKnownHostResponse>();
  @$core.pragma('dart2js:noInline')
  static GetKnownHostResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetKnownHostResponse>(create);
  static GetKnownHostResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<KnownHost> get hosts => $_getList(0);
}

class RemoveKnownHostRequest extends $pb.GeneratedMessage {
  factory RemoveKnownHostRequest({
    $2.Target? target,
    $core.String? hostname,
    $core.int? port,
  }) {
    final result = create();
    if (target != null) result.target = target;
    if (hostname != null) result.hostname = hostname;
    if (port != null) result.port = port;
    return result;
  }

  RemoveKnownHostRequest._();

  factory RemoveKnownHostRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RemoveKnownHostRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RemoveKnownHostRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOM<$2.Target>(1, _omitFieldNames ? '' : 'target',
        subBuilder: $2.Target.create)
    ..aOS(2, _omitFieldNames ? '' : 'hostname')
    ..aI(3, _omitFieldNames ? '' : 'port')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemoveKnownHostRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemoveKnownHostRequest copyWith(
          void Function(RemoveKnownHostRequest) updates) =>
      super.copyWith((message) => updates(message as RemoveKnownHostRequest))
          as RemoveKnownHostRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RemoveKnownHostRequest create() => RemoveKnownHostRequest._();
  @$core.override
  RemoveKnownHostRequest createEmptyInstance() => create();
  static $pb.PbList<RemoveKnownHostRequest> createRepeated() =>
      $pb.PbList<RemoveKnownHostRequest>();
  @$core.pragma('dart2js:noInline')
  static RemoveKnownHostRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RemoveKnownHostRequest>(create);
  static RemoveKnownHostRequest? _defaultInstance;

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
  $core.String get hostname => $_getSZ(1);
  @$pb.TagNumber(2)
  set hostname($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasHostname() => $_has(1);
  @$pb.TagNumber(2)
  void clearHostname() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get port => $_getIZ(2);
  @$pb.TagNumber(3)
  set port($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPort() => $_has(2);
  @$pb.TagNumber(3)
  void clearPort() => $_clearField(3);
}

class HashKnownHostsRequest extends $pb.GeneratedMessage {
  factory HashKnownHostsRequest({
    $2.Target? target,
  }) {
    final result = create();
    if (target != null) result.target = target;
    return result;
  }

  HashKnownHostsRequest._();

  factory HashKnownHostsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory HashKnownHostsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HashKnownHostsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOM<$2.Target>(1, _omitFieldNames ? '' : 'target',
        subBuilder: $2.Target.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HashKnownHostsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HashKnownHostsRequest copyWith(
          void Function(HashKnownHostsRequest) updates) =>
      super.copyWith((message) => updates(message as HashKnownHostsRequest))
          as HashKnownHostsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HashKnownHostsRequest create() => HashKnownHostsRequest._();
  @$core.override
  HashKnownHostsRequest createEmptyInstance() => create();
  static $pb.PbList<HashKnownHostsRequest> createRepeated() =>
      $pb.PbList<HashKnownHostsRequest>();
  @$core.pragma('dart2js:noInline')
  static HashKnownHostsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HashKnownHostsRequest>(create);
  static HashKnownHostsRequest? _defaultInstance;

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

class AuthorizedKey extends $pb.GeneratedMessage {
  factory AuthorizedKey({
    $core.String? id,
    $core.String? keyType,
    $core.String? fingerprint,
    $core.String? comment,
    $core.String? publicKey,
    $core.Iterable<$core.String>? options,
    $core.int? lineNumber,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (keyType != null) result.keyType = keyType;
    if (fingerprint != null) result.fingerprint = fingerprint;
    if (comment != null) result.comment = comment;
    if (publicKey != null) result.publicKey = publicKey;
    if (options != null) result.options.addAll(options);
    if (lineNumber != null) result.lineNumber = lineNumber;
    return result;
  }

  AuthorizedKey._();

  factory AuthorizedKey.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AuthorizedKey.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AuthorizedKey',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'keyType')
    ..aOS(3, _omitFieldNames ? '' : 'fingerprint')
    ..aOS(4, _omitFieldNames ? '' : 'comment')
    ..aOS(5, _omitFieldNames ? '' : 'publicKey')
    ..pPS(6, _omitFieldNames ? '' : 'options')
    ..aI(7, _omitFieldNames ? '' : 'lineNumber')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthorizedKey clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthorizedKey copyWith(void Function(AuthorizedKey) updates) =>
      super.copyWith((message) => updates(message as AuthorizedKey))
          as AuthorizedKey;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthorizedKey create() => AuthorizedKey._();
  @$core.override
  AuthorizedKey createEmptyInstance() => create();
  static $pb.PbList<AuthorizedKey> createRepeated() =>
      $pb.PbList<AuthorizedKey>();
  @$core.pragma('dart2js:noInline')
  static AuthorizedKey getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AuthorizedKey>(create);
  static AuthorizedKey? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get keyType => $_getSZ(1);
  @$pb.TagNumber(2)
  set keyType($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasKeyType() => $_has(1);
  @$pb.TagNumber(2)
  void clearKeyType() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get fingerprint => $_getSZ(2);
  @$pb.TagNumber(3)
  set fingerprint($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFingerprint() => $_has(2);
  @$pb.TagNumber(3)
  void clearFingerprint() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get comment => $_getSZ(3);
  @$pb.TagNumber(4)
  set comment($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasComment() => $_has(3);
  @$pb.TagNumber(4)
  void clearComment() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get publicKey => $_getSZ(4);
  @$pb.TagNumber(5)
  set publicKey($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPublicKey() => $_has(4);
  @$pb.TagNumber(5)
  void clearPublicKey() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<$core.String> get options => $_getList(5);

  @$pb.TagNumber(7)
  $core.int get lineNumber => $_getIZ(6);
  @$pb.TagNumber(7)
  set lineNumber($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasLineNumber() => $_has(6);
  @$pb.TagNumber(7)
  void clearLineNumber() => $_clearField(7);
}

class ListAuthorizedKeysRequest extends $pb.GeneratedMessage {
  factory ListAuthorizedKeysRequest({
    $2.Target? target,
    $core.String? user,
  }) {
    final result = create();
    if (target != null) result.target = target;
    if (user != null) result.user = user;
    return result;
  }

  ListAuthorizedKeysRequest._();

  factory ListAuthorizedKeysRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListAuthorizedKeysRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListAuthorizedKeysRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOM<$2.Target>(1, _omitFieldNames ? '' : 'target',
        subBuilder: $2.Target.create)
    ..aOS(2, _omitFieldNames ? '' : 'user')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAuthorizedKeysRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAuthorizedKeysRequest copyWith(
          void Function(ListAuthorizedKeysRequest) updates) =>
      super.copyWith((message) => updates(message as ListAuthorizedKeysRequest))
          as ListAuthorizedKeysRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListAuthorizedKeysRequest create() => ListAuthorizedKeysRequest._();
  @$core.override
  ListAuthorizedKeysRequest createEmptyInstance() => create();
  static $pb.PbList<ListAuthorizedKeysRequest> createRepeated() =>
      $pb.PbList<ListAuthorizedKeysRequest>();
  @$core.pragma('dart2js:noInline')
  static ListAuthorizedKeysRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListAuthorizedKeysRequest>(create);
  static ListAuthorizedKeysRequest? _defaultInstance;

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
  $core.String get user => $_getSZ(1);
  @$pb.TagNumber(2)
  set user($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUser() => $_has(1);
  @$pb.TagNumber(2)
  void clearUser() => $_clearField(2);
}

class ListAuthorizedKeysResponse extends $pb.GeneratedMessage {
  factory ListAuthorizedKeysResponse({
    $core.Iterable<AuthorizedKey>? keys,
  }) {
    final result = create();
    if (keys != null) result.keys.addAll(keys);
    return result;
  }

  ListAuthorizedKeysResponse._();

  factory ListAuthorizedKeysResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListAuthorizedKeysResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListAuthorizedKeysResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..pPM<AuthorizedKey>(1, _omitFieldNames ? '' : 'keys',
        subBuilder: AuthorizedKey.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAuthorizedKeysResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAuthorizedKeysResponse copyWith(
          void Function(ListAuthorizedKeysResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListAuthorizedKeysResponse))
          as ListAuthorizedKeysResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListAuthorizedKeysResponse create() => ListAuthorizedKeysResponse._();
  @$core.override
  ListAuthorizedKeysResponse createEmptyInstance() => create();
  static $pb.PbList<ListAuthorizedKeysResponse> createRepeated() =>
      $pb.PbList<ListAuthorizedKeysResponse>();
  @$core.pragma('dart2js:noInline')
  static ListAuthorizedKeysResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListAuthorizedKeysResponse>(create);
  static ListAuthorizedKeysResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<AuthorizedKey> get keys => $_getList(0);
}

class AddAuthorizedKeyRequest extends $pb.GeneratedMessage {
  factory AddAuthorizedKeyRequest({
    $2.Target? target,
    $core.String? publicKey,
    $core.Iterable<$core.String>? options,
    $core.String? user,
  }) {
    final result = create();
    if (target != null) result.target = target;
    if (publicKey != null) result.publicKey = publicKey;
    if (options != null) result.options.addAll(options);
    if (user != null) result.user = user;
    return result;
  }

  AddAuthorizedKeyRequest._();

  factory AddAuthorizedKeyRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddAuthorizedKeyRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddAuthorizedKeyRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOM<$2.Target>(1, _omitFieldNames ? '' : 'target',
        subBuilder: $2.Target.create)
    ..aOS(2, _omitFieldNames ? '' : 'publicKey')
    ..pPS(3, _omitFieldNames ? '' : 'options')
    ..aOS(4, _omitFieldNames ? '' : 'user')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddAuthorizedKeyRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddAuthorizedKeyRequest copyWith(
          void Function(AddAuthorizedKeyRequest) updates) =>
      super.copyWith((message) => updates(message as AddAuthorizedKeyRequest))
          as AddAuthorizedKeyRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddAuthorizedKeyRequest create() => AddAuthorizedKeyRequest._();
  @$core.override
  AddAuthorizedKeyRequest createEmptyInstance() => create();
  static $pb.PbList<AddAuthorizedKeyRequest> createRepeated() =>
      $pb.PbList<AddAuthorizedKeyRequest>();
  @$core.pragma('dart2js:noInline')
  static AddAuthorizedKeyRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddAuthorizedKeyRequest>(create);
  static AddAuthorizedKeyRequest? _defaultInstance;

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
  $core.String get publicKey => $_getSZ(1);
  @$pb.TagNumber(2)
  set publicKey($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPublicKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearPublicKey() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get options => $_getList(2);

  @$pb.TagNumber(4)
  $core.String get user => $_getSZ(3);
  @$pb.TagNumber(4)
  set user($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUser() => $_has(3);
  @$pb.TagNumber(4)
  void clearUser() => $_clearField(4);
}

class UpdateAuthorizedKeyRequest extends $pb.GeneratedMessage {
  factory UpdateAuthorizedKeyRequest({
    $2.Target? target,
    $core.String? keyId,
    $core.Iterable<$core.String>? options,
    $core.String? comment,
  }) {
    final result = create();
    if (target != null) result.target = target;
    if (keyId != null) result.keyId = keyId;
    if (options != null) result.options.addAll(options);
    if (comment != null) result.comment = comment;
    return result;
  }

  UpdateAuthorizedKeyRequest._();

  factory UpdateAuthorizedKeyRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateAuthorizedKeyRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateAuthorizedKeyRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOM<$2.Target>(1, _omitFieldNames ? '' : 'target',
        subBuilder: $2.Target.create)
    ..aOS(2, _omitFieldNames ? '' : 'keyId')
    ..pPS(3, _omitFieldNames ? '' : 'options')
    ..aOS(4, _omitFieldNames ? '' : 'comment')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateAuthorizedKeyRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateAuthorizedKeyRequest copyWith(
          void Function(UpdateAuthorizedKeyRequest) updates) =>
      super.copyWith(
              (message) => updates(message as UpdateAuthorizedKeyRequest))
          as UpdateAuthorizedKeyRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateAuthorizedKeyRequest create() => UpdateAuthorizedKeyRequest._();
  @$core.override
  UpdateAuthorizedKeyRequest createEmptyInstance() => create();
  static $pb.PbList<UpdateAuthorizedKeyRequest> createRepeated() =>
      $pb.PbList<UpdateAuthorizedKeyRequest>();
  @$core.pragma('dart2js:noInline')
  static UpdateAuthorizedKeyRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateAuthorizedKeyRequest>(create);
  static UpdateAuthorizedKeyRequest? _defaultInstance;

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
  $core.String get keyId => $_getSZ(1);
  @$pb.TagNumber(2)
  set keyId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasKeyId() => $_has(1);
  @$pb.TagNumber(2)
  void clearKeyId() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get options => $_getList(2);

  @$pb.TagNumber(4)
  $core.String get comment => $_getSZ(3);
  @$pb.TagNumber(4)
  set comment($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasComment() => $_has(3);
  @$pb.TagNumber(4)
  void clearComment() => $_clearField(4);
}

class RemoveAuthorizedKeyRequest extends $pb.GeneratedMessage {
  factory RemoveAuthorizedKeyRequest({
    $2.Target? target,
    $core.String? keyId,
    $core.String? user,
  }) {
    final result = create();
    if (target != null) result.target = target;
    if (keyId != null) result.keyId = keyId;
    if (user != null) result.user = user;
    return result;
  }

  RemoveAuthorizedKeyRequest._();

  factory RemoveAuthorizedKeyRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RemoveAuthorizedKeyRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RemoveAuthorizedKeyRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOM<$2.Target>(1, _omitFieldNames ? '' : 'target',
        subBuilder: $2.Target.create)
    ..aOS(2, _omitFieldNames ? '' : 'keyId')
    ..aOS(3, _omitFieldNames ? '' : 'user')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemoveAuthorizedKeyRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemoveAuthorizedKeyRequest copyWith(
          void Function(RemoveAuthorizedKeyRequest) updates) =>
      super.copyWith(
              (message) => updates(message as RemoveAuthorizedKeyRequest))
          as RemoveAuthorizedKeyRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RemoveAuthorizedKeyRequest create() => RemoveAuthorizedKeyRequest._();
  @$core.override
  RemoveAuthorizedKeyRequest createEmptyInstance() => create();
  static $pb.PbList<RemoveAuthorizedKeyRequest> createRepeated() =>
      $pb.PbList<RemoveAuthorizedKeyRequest>();
  @$core.pragma('dart2js:noInline')
  static RemoveAuthorizedKeyRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RemoveAuthorizedKeyRequest>(create);
  static RemoveAuthorizedKeyRequest? _defaultInstance;

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
  $core.String get keyId => $_getSZ(1);
  @$pb.TagNumber(2)
  set keyId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasKeyId() => $_has(1);
  @$pb.TagNumber(2)
  void clearKeyId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get user => $_getSZ(2);
  @$pb.TagNumber(3)
  set user($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUser() => $_has(2);
  @$pb.TagNumber(3)
  void clearUser() => $_clearField(3);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
