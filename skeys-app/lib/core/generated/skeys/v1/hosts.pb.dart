//
//  Generated code. Do not modify.
//  source: skeys/v1/hosts.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'common.pb.dart' as $6;

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
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (hostnames != null) {
      $result.hostnames.addAll(hostnames);
    }
    if (keyType != null) {
      $result.keyType = keyType;
    }
    if (fingerprint != null) {
      $result.fingerprint = fingerprint;
    }
    if (publicKey != null) {
      $result.publicKey = publicKey;
    }
    if (isHashed != null) {
      $result.isHashed = isHashed;
    }
    if (isRevoked != null) {
      $result.isRevoked = isRevoked;
    }
    if (isCertAuthority != null) {
      $result.isCertAuthority = isCertAuthority;
    }
    if (lineNumber != null) {
      $result.lineNumber = lineNumber;
    }
    return $result;
  }
  KnownHost._() : super();
  factory KnownHost.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory KnownHost.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'KnownHost', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..pPS(2, _omitFieldNames ? '' : 'hostnames')
    ..aOS(3, _omitFieldNames ? '' : 'keyType')
    ..aOS(4, _omitFieldNames ? '' : 'fingerprint')
    ..aOS(5, _omitFieldNames ? '' : 'publicKey')
    ..aOB(6, _omitFieldNames ? '' : 'isHashed')
    ..aOB(7, _omitFieldNames ? '' : 'isRevoked')
    ..aOB(8, _omitFieldNames ? '' : 'isCertAuthority')
    ..a<$core.int>(9, _omitFieldNames ? '' : 'lineNumber', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  KnownHost clone() => KnownHost()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  KnownHost copyWith(void Function(KnownHost) updates) => super.copyWith((message) => updates(message as KnownHost)) as KnownHost;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static KnownHost create() => KnownHost._();
  KnownHost createEmptyInstance() => create();
  static $pb.PbList<KnownHost> createRepeated() => $pb.PbList<KnownHost>();
  @$core.pragma('dart2js:noInline')
  static KnownHost getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<KnownHost>(create);
  static KnownHost? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.String> get hostnames => $_getList(1);

  @$pb.TagNumber(3)
  $core.String get keyType => $_getSZ(2);
  @$pb.TagNumber(3)
  set keyType($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasKeyType() => $_has(2);
  @$pb.TagNumber(3)
  void clearKeyType() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get fingerprint => $_getSZ(3);
  @$pb.TagNumber(4)
  set fingerprint($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasFingerprint() => $_has(3);
  @$pb.TagNumber(4)
  void clearFingerprint() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get publicKey => $_getSZ(4);
  @$pb.TagNumber(5)
  set publicKey($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasPublicKey() => $_has(4);
  @$pb.TagNumber(5)
  void clearPublicKey() => clearField(5);

  @$pb.TagNumber(6)
  $core.bool get isHashed => $_getBF(5);
  @$pb.TagNumber(6)
  set isHashed($core.bool v) { $_setBool(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasIsHashed() => $_has(5);
  @$pb.TagNumber(6)
  void clearIsHashed() => clearField(6);

  @$pb.TagNumber(7)
  $core.bool get isRevoked => $_getBF(6);
  @$pb.TagNumber(7)
  set isRevoked($core.bool v) { $_setBool(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasIsRevoked() => $_has(6);
  @$pb.TagNumber(7)
  void clearIsRevoked() => clearField(7);

  @$pb.TagNumber(8)
  $core.bool get isCertAuthority => $_getBF(7);
  @$pb.TagNumber(8)
  set isCertAuthority($core.bool v) { $_setBool(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasIsCertAuthority() => $_has(7);
  @$pb.TagNumber(8)
  void clearIsCertAuthority() => clearField(8);

  @$pb.TagNumber(9)
  $core.int get lineNumber => $_getIZ(8);
  @$pb.TagNumber(9)
  set lineNumber($core.int v) { $_setSignedInt32(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasLineNumber() => $_has(8);
  @$pb.TagNumber(9)
  void clearLineNumber() => clearField(9);
}

class ListKnownHostsRequest extends $pb.GeneratedMessage {
  factory ListKnownHostsRequest({
    $6.Target? target,
  }) {
    final $result = create();
    if (target != null) {
      $result.target = target;
    }
    return $result;
  }
  ListKnownHostsRequest._() : super();
  factory ListKnownHostsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListKnownHostsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListKnownHostsRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..aOM<$6.Target>(1, _omitFieldNames ? '' : 'target', subBuilder: $6.Target.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListKnownHostsRequest clone() => ListKnownHostsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListKnownHostsRequest copyWith(void Function(ListKnownHostsRequest) updates) => super.copyWith((message) => updates(message as ListKnownHostsRequest)) as ListKnownHostsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListKnownHostsRequest create() => ListKnownHostsRequest._();
  ListKnownHostsRequest createEmptyInstance() => create();
  static $pb.PbList<ListKnownHostsRequest> createRepeated() => $pb.PbList<ListKnownHostsRequest>();
  @$core.pragma('dart2js:noInline')
  static ListKnownHostsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListKnownHostsRequest>(create);
  static ListKnownHostsRequest? _defaultInstance;

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

class ListKnownHostsResponse extends $pb.GeneratedMessage {
  factory ListKnownHostsResponse({
    $core.Iterable<KnownHost>? hosts,
  }) {
    final $result = create();
    if (hosts != null) {
      $result.hosts.addAll(hosts);
    }
    return $result;
  }
  ListKnownHostsResponse._() : super();
  factory ListKnownHostsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListKnownHostsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListKnownHostsResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..pc<KnownHost>(1, _omitFieldNames ? '' : 'hosts', $pb.PbFieldType.PM, subBuilder: KnownHost.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListKnownHostsResponse clone() => ListKnownHostsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListKnownHostsResponse copyWith(void Function(ListKnownHostsResponse) updates) => super.copyWith((message) => updates(message as ListKnownHostsResponse)) as ListKnownHostsResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListKnownHostsResponse create() => ListKnownHostsResponse._();
  ListKnownHostsResponse createEmptyInstance() => create();
  static $pb.PbList<ListKnownHostsResponse> createRepeated() => $pb.PbList<ListKnownHostsResponse>();
  @$core.pragma('dart2js:noInline')
  static ListKnownHostsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListKnownHostsResponse>(create);
  static ListKnownHostsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<KnownHost> get hosts => $_getList(0);
}

class GetKnownHostRequest extends $pb.GeneratedMessage {
  factory GetKnownHostRequest({
    $6.Target? target,
    $core.String? hostname,
    $core.int? port,
  }) {
    final $result = create();
    if (target != null) {
      $result.target = target;
    }
    if (hostname != null) {
      $result.hostname = hostname;
    }
    if (port != null) {
      $result.port = port;
    }
    return $result;
  }
  GetKnownHostRequest._() : super();
  factory GetKnownHostRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetKnownHostRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetKnownHostRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..aOM<$6.Target>(1, _omitFieldNames ? '' : 'target', subBuilder: $6.Target.create)
    ..aOS(2, _omitFieldNames ? '' : 'hostname')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'port', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetKnownHostRequest clone() => GetKnownHostRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetKnownHostRequest copyWith(void Function(GetKnownHostRequest) updates) => super.copyWith((message) => updates(message as GetKnownHostRequest)) as GetKnownHostRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetKnownHostRequest create() => GetKnownHostRequest._();
  GetKnownHostRequest createEmptyInstance() => create();
  static $pb.PbList<GetKnownHostRequest> createRepeated() => $pb.PbList<GetKnownHostRequest>();
  @$core.pragma('dart2js:noInline')
  static GetKnownHostRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetKnownHostRequest>(create);
  static GetKnownHostRequest? _defaultInstance;

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
  $core.String get hostname => $_getSZ(1);
  @$pb.TagNumber(2)
  set hostname($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasHostname() => $_has(1);
  @$pb.TagNumber(2)
  void clearHostname() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get port => $_getIZ(2);
  @$pb.TagNumber(3)
  set port($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPort() => $_has(2);
  @$pb.TagNumber(3)
  void clearPort() => clearField(3);
}

class GetKnownHostResponse extends $pb.GeneratedMessage {
  factory GetKnownHostResponse({
    $core.Iterable<KnownHost>? hosts,
  }) {
    final $result = create();
    if (hosts != null) {
      $result.hosts.addAll(hosts);
    }
    return $result;
  }
  GetKnownHostResponse._() : super();
  factory GetKnownHostResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetKnownHostResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetKnownHostResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..pc<KnownHost>(1, _omitFieldNames ? '' : 'hosts', $pb.PbFieldType.PM, subBuilder: KnownHost.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetKnownHostResponse clone() => GetKnownHostResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetKnownHostResponse copyWith(void Function(GetKnownHostResponse) updates) => super.copyWith((message) => updates(message as GetKnownHostResponse)) as GetKnownHostResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetKnownHostResponse create() => GetKnownHostResponse._();
  GetKnownHostResponse createEmptyInstance() => create();
  static $pb.PbList<GetKnownHostResponse> createRepeated() => $pb.PbList<GetKnownHostResponse>();
  @$core.pragma('dart2js:noInline')
  static GetKnownHostResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetKnownHostResponse>(create);
  static GetKnownHostResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<KnownHost> get hosts => $_getList(0);
}

class RemoveKnownHostRequest extends $pb.GeneratedMessage {
  factory RemoveKnownHostRequest({
    $6.Target? target,
    $core.String? hostname,
    $core.int? port,
  }) {
    final $result = create();
    if (target != null) {
      $result.target = target;
    }
    if (hostname != null) {
      $result.hostname = hostname;
    }
    if (port != null) {
      $result.port = port;
    }
    return $result;
  }
  RemoveKnownHostRequest._() : super();
  factory RemoveKnownHostRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RemoveKnownHostRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RemoveKnownHostRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..aOM<$6.Target>(1, _omitFieldNames ? '' : 'target', subBuilder: $6.Target.create)
    ..aOS(2, _omitFieldNames ? '' : 'hostname')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'port', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RemoveKnownHostRequest clone() => RemoveKnownHostRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RemoveKnownHostRequest copyWith(void Function(RemoveKnownHostRequest) updates) => super.copyWith((message) => updates(message as RemoveKnownHostRequest)) as RemoveKnownHostRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RemoveKnownHostRequest create() => RemoveKnownHostRequest._();
  RemoveKnownHostRequest createEmptyInstance() => create();
  static $pb.PbList<RemoveKnownHostRequest> createRepeated() => $pb.PbList<RemoveKnownHostRequest>();
  @$core.pragma('dart2js:noInline')
  static RemoveKnownHostRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RemoveKnownHostRequest>(create);
  static RemoveKnownHostRequest? _defaultInstance;

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
  $core.String get hostname => $_getSZ(1);
  @$pb.TagNumber(2)
  set hostname($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasHostname() => $_has(1);
  @$pb.TagNumber(2)
  void clearHostname() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get port => $_getIZ(2);
  @$pb.TagNumber(3)
  set port($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPort() => $_has(2);
  @$pb.TagNumber(3)
  void clearPort() => clearField(3);
}

class HashKnownHostsRequest extends $pb.GeneratedMessage {
  factory HashKnownHostsRequest({
    $6.Target? target,
  }) {
    final $result = create();
    if (target != null) {
      $result.target = target;
    }
    return $result;
  }
  HashKnownHostsRequest._() : super();
  factory HashKnownHostsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory HashKnownHostsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'HashKnownHostsRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..aOM<$6.Target>(1, _omitFieldNames ? '' : 'target', subBuilder: $6.Target.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  HashKnownHostsRequest clone() => HashKnownHostsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  HashKnownHostsRequest copyWith(void Function(HashKnownHostsRequest) updates) => super.copyWith((message) => updates(message as HashKnownHostsRequest)) as HashKnownHostsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HashKnownHostsRequest create() => HashKnownHostsRequest._();
  HashKnownHostsRequest createEmptyInstance() => create();
  static $pb.PbList<HashKnownHostsRequest> createRepeated() => $pb.PbList<HashKnownHostsRequest>();
  @$core.pragma('dart2js:noInline')
  static HashKnownHostsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<HashKnownHostsRequest>(create);
  static HashKnownHostsRequest? _defaultInstance;

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

class ScanHostKeysRequest extends $pb.GeneratedMessage {
  factory ScanHostKeysRequest({
    $core.String? hostname,
    $core.int? port,
    $core.int? timeoutSeconds,
  }) {
    final $result = create();
    if (hostname != null) {
      $result.hostname = hostname;
    }
    if (port != null) {
      $result.port = port;
    }
    if (timeoutSeconds != null) {
      $result.timeoutSeconds = timeoutSeconds;
    }
    return $result;
  }
  ScanHostKeysRequest._() : super();
  factory ScanHostKeysRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ScanHostKeysRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ScanHostKeysRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'hostname')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'port', $pb.PbFieldType.O3)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'timeoutSeconds', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ScanHostKeysRequest clone() => ScanHostKeysRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ScanHostKeysRequest copyWith(void Function(ScanHostKeysRequest) updates) => super.copyWith((message) => updates(message as ScanHostKeysRequest)) as ScanHostKeysRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ScanHostKeysRequest create() => ScanHostKeysRequest._();
  ScanHostKeysRequest createEmptyInstance() => create();
  static $pb.PbList<ScanHostKeysRequest> createRepeated() => $pb.PbList<ScanHostKeysRequest>();
  @$core.pragma('dart2js:noInline')
  static ScanHostKeysRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ScanHostKeysRequest>(create);
  static ScanHostKeysRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get hostname => $_getSZ(0);
  @$pb.TagNumber(1)
  set hostname($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasHostname() => $_has(0);
  @$pb.TagNumber(1)
  void clearHostname() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get port => $_getIZ(1);
  @$pb.TagNumber(2)
  set port($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPort() => $_has(1);
  @$pb.TagNumber(2)
  void clearPort() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get timeoutSeconds => $_getIZ(2);
  @$pb.TagNumber(3)
  set timeoutSeconds($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasTimeoutSeconds() => $_has(2);
  @$pb.TagNumber(3)
  void clearTimeoutSeconds() => clearField(3);
}

class ScannedHostKey extends $pb.GeneratedMessage {
  factory ScannedHostKey({
    $core.String? hostname,
    $core.int? port,
    $core.String? keyType,
    $core.String? publicKey,
    $core.String? fingerprint,
  }) {
    final $result = create();
    if (hostname != null) {
      $result.hostname = hostname;
    }
    if (port != null) {
      $result.port = port;
    }
    if (keyType != null) {
      $result.keyType = keyType;
    }
    if (publicKey != null) {
      $result.publicKey = publicKey;
    }
    if (fingerprint != null) {
      $result.fingerprint = fingerprint;
    }
    return $result;
  }
  ScannedHostKey._() : super();
  factory ScannedHostKey.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ScannedHostKey.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ScannedHostKey', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'hostname')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'port', $pb.PbFieldType.O3)
    ..aOS(3, _omitFieldNames ? '' : 'keyType')
    ..aOS(4, _omitFieldNames ? '' : 'publicKey')
    ..aOS(5, _omitFieldNames ? '' : 'fingerprint')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ScannedHostKey clone() => ScannedHostKey()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ScannedHostKey copyWith(void Function(ScannedHostKey) updates) => super.copyWith((message) => updates(message as ScannedHostKey)) as ScannedHostKey;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ScannedHostKey create() => ScannedHostKey._();
  ScannedHostKey createEmptyInstance() => create();
  static $pb.PbList<ScannedHostKey> createRepeated() => $pb.PbList<ScannedHostKey>();
  @$core.pragma('dart2js:noInline')
  static ScannedHostKey getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ScannedHostKey>(create);
  static ScannedHostKey? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get hostname => $_getSZ(0);
  @$pb.TagNumber(1)
  set hostname($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasHostname() => $_has(0);
  @$pb.TagNumber(1)
  void clearHostname() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get port => $_getIZ(1);
  @$pb.TagNumber(2)
  set port($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPort() => $_has(1);
  @$pb.TagNumber(2)
  void clearPort() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get keyType => $_getSZ(2);
  @$pb.TagNumber(3)
  set keyType($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasKeyType() => $_has(2);
  @$pb.TagNumber(3)
  void clearKeyType() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get publicKey => $_getSZ(3);
  @$pb.TagNumber(4)
  set publicKey($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasPublicKey() => $_has(3);
  @$pb.TagNumber(4)
  void clearPublicKey() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get fingerprint => $_getSZ(4);
  @$pb.TagNumber(5)
  set fingerprint($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasFingerprint() => $_has(4);
  @$pb.TagNumber(5)
  void clearFingerprint() => clearField(5);
}

class ScanHostKeysResponse extends $pb.GeneratedMessage {
  factory ScanHostKeysResponse({
    $core.Iterable<ScannedHostKey>? keys,
  }) {
    final $result = create();
    if (keys != null) {
      $result.keys.addAll(keys);
    }
    return $result;
  }
  ScanHostKeysResponse._() : super();
  factory ScanHostKeysResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ScanHostKeysResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ScanHostKeysResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..pc<ScannedHostKey>(1, _omitFieldNames ? '' : 'keys', $pb.PbFieldType.PM, subBuilder: ScannedHostKey.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ScanHostKeysResponse clone() => ScanHostKeysResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ScanHostKeysResponse copyWith(void Function(ScanHostKeysResponse) updates) => super.copyWith((message) => updates(message as ScanHostKeysResponse)) as ScanHostKeysResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ScanHostKeysResponse create() => ScanHostKeysResponse._();
  ScanHostKeysResponse createEmptyInstance() => create();
  static $pb.PbList<ScanHostKeysResponse> createRepeated() => $pb.PbList<ScanHostKeysResponse>();
  @$core.pragma('dart2js:noInline')
  static ScanHostKeysResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ScanHostKeysResponse>(create);
  static ScanHostKeysResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<ScannedHostKey> get keys => $_getList(0);
}

class AddKnownHostRequest extends $pb.GeneratedMessage {
  factory AddKnownHostRequest({
    $6.Target? target,
    $core.String? hostname,
    $core.int? port,
    $core.String? keyType,
    $core.String? publicKey,
    $core.bool? hashHostname,
  }) {
    final $result = create();
    if (target != null) {
      $result.target = target;
    }
    if (hostname != null) {
      $result.hostname = hostname;
    }
    if (port != null) {
      $result.port = port;
    }
    if (keyType != null) {
      $result.keyType = keyType;
    }
    if (publicKey != null) {
      $result.publicKey = publicKey;
    }
    if (hashHostname != null) {
      $result.hashHostname = hashHostname;
    }
    return $result;
  }
  AddKnownHostRequest._() : super();
  factory AddKnownHostRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AddKnownHostRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AddKnownHostRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..aOM<$6.Target>(1, _omitFieldNames ? '' : 'target', subBuilder: $6.Target.create)
    ..aOS(2, _omitFieldNames ? '' : 'hostname')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'port', $pb.PbFieldType.O3)
    ..aOS(4, _omitFieldNames ? '' : 'keyType')
    ..aOS(5, _omitFieldNames ? '' : 'publicKey')
    ..aOB(6, _omitFieldNames ? '' : 'hashHostname')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AddKnownHostRequest clone() => AddKnownHostRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AddKnownHostRequest copyWith(void Function(AddKnownHostRequest) updates) => super.copyWith((message) => updates(message as AddKnownHostRequest)) as AddKnownHostRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddKnownHostRequest create() => AddKnownHostRequest._();
  AddKnownHostRequest createEmptyInstance() => create();
  static $pb.PbList<AddKnownHostRequest> createRepeated() => $pb.PbList<AddKnownHostRequest>();
  @$core.pragma('dart2js:noInline')
  static AddKnownHostRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AddKnownHostRequest>(create);
  static AddKnownHostRequest? _defaultInstance;

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
  $core.String get hostname => $_getSZ(1);
  @$pb.TagNumber(2)
  set hostname($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasHostname() => $_has(1);
  @$pb.TagNumber(2)
  void clearHostname() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get port => $_getIZ(2);
  @$pb.TagNumber(3)
  set port($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPort() => $_has(2);
  @$pb.TagNumber(3)
  void clearPort() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get keyType => $_getSZ(3);
  @$pb.TagNumber(4)
  set keyType($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasKeyType() => $_has(3);
  @$pb.TagNumber(4)
  void clearKeyType() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get publicKey => $_getSZ(4);
  @$pb.TagNumber(5)
  set publicKey($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasPublicKey() => $_has(4);
  @$pb.TagNumber(5)
  void clearPublicKey() => clearField(5);

  @$pb.TagNumber(6)
  $core.bool get hashHostname => $_getBF(5);
  @$pb.TagNumber(6)
  set hashHostname($core.bool v) { $_setBool(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasHashHostname() => $_has(5);
  @$pb.TagNumber(6)
  void clearHashHostname() => clearField(6);
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
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (keyType != null) {
      $result.keyType = keyType;
    }
    if (fingerprint != null) {
      $result.fingerprint = fingerprint;
    }
    if (comment != null) {
      $result.comment = comment;
    }
    if (publicKey != null) {
      $result.publicKey = publicKey;
    }
    if (options != null) {
      $result.options.addAll(options);
    }
    if (lineNumber != null) {
      $result.lineNumber = lineNumber;
    }
    return $result;
  }
  AuthorizedKey._() : super();
  factory AuthorizedKey.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AuthorizedKey.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AuthorizedKey', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'keyType')
    ..aOS(3, _omitFieldNames ? '' : 'fingerprint')
    ..aOS(4, _omitFieldNames ? '' : 'comment')
    ..aOS(5, _omitFieldNames ? '' : 'publicKey')
    ..pPS(6, _omitFieldNames ? '' : 'options')
    ..a<$core.int>(7, _omitFieldNames ? '' : 'lineNumber', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AuthorizedKey clone() => AuthorizedKey()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AuthorizedKey copyWith(void Function(AuthorizedKey) updates) => super.copyWith((message) => updates(message as AuthorizedKey)) as AuthorizedKey;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthorizedKey create() => AuthorizedKey._();
  AuthorizedKey createEmptyInstance() => create();
  static $pb.PbList<AuthorizedKey> createRepeated() => $pb.PbList<AuthorizedKey>();
  @$core.pragma('dart2js:noInline')
  static AuthorizedKey getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthorizedKey>(create);
  static AuthorizedKey? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get keyType => $_getSZ(1);
  @$pb.TagNumber(2)
  set keyType($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasKeyType() => $_has(1);
  @$pb.TagNumber(2)
  void clearKeyType() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get fingerprint => $_getSZ(2);
  @$pb.TagNumber(3)
  set fingerprint($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasFingerprint() => $_has(2);
  @$pb.TagNumber(3)
  void clearFingerprint() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get comment => $_getSZ(3);
  @$pb.TagNumber(4)
  set comment($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasComment() => $_has(3);
  @$pb.TagNumber(4)
  void clearComment() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get publicKey => $_getSZ(4);
  @$pb.TagNumber(5)
  set publicKey($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasPublicKey() => $_has(4);
  @$pb.TagNumber(5)
  void clearPublicKey() => clearField(5);

  @$pb.TagNumber(6)
  $core.List<$core.String> get options => $_getList(5);

  @$pb.TagNumber(7)
  $core.int get lineNumber => $_getIZ(6);
  @$pb.TagNumber(7)
  set lineNumber($core.int v) { $_setSignedInt32(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasLineNumber() => $_has(6);
  @$pb.TagNumber(7)
  void clearLineNumber() => clearField(7);
}

class ListAuthorizedKeysRequest extends $pb.GeneratedMessage {
  factory ListAuthorizedKeysRequest({
    $6.Target? target,
    $core.String? user,
  }) {
    final $result = create();
    if (target != null) {
      $result.target = target;
    }
    if (user != null) {
      $result.user = user;
    }
    return $result;
  }
  ListAuthorizedKeysRequest._() : super();
  factory ListAuthorizedKeysRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListAuthorizedKeysRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListAuthorizedKeysRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..aOM<$6.Target>(1, _omitFieldNames ? '' : 'target', subBuilder: $6.Target.create)
    ..aOS(2, _omitFieldNames ? '' : 'user')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListAuthorizedKeysRequest clone() => ListAuthorizedKeysRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListAuthorizedKeysRequest copyWith(void Function(ListAuthorizedKeysRequest) updates) => super.copyWith((message) => updates(message as ListAuthorizedKeysRequest)) as ListAuthorizedKeysRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListAuthorizedKeysRequest create() => ListAuthorizedKeysRequest._();
  ListAuthorizedKeysRequest createEmptyInstance() => create();
  static $pb.PbList<ListAuthorizedKeysRequest> createRepeated() => $pb.PbList<ListAuthorizedKeysRequest>();
  @$core.pragma('dart2js:noInline')
  static ListAuthorizedKeysRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListAuthorizedKeysRequest>(create);
  static ListAuthorizedKeysRequest? _defaultInstance;

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
  $core.String get user => $_getSZ(1);
  @$pb.TagNumber(2)
  set user($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasUser() => $_has(1);
  @$pb.TagNumber(2)
  void clearUser() => clearField(2);
}

class ListAuthorizedKeysResponse extends $pb.GeneratedMessage {
  factory ListAuthorizedKeysResponse({
    $core.Iterable<AuthorizedKey>? keys,
  }) {
    final $result = create();
    if (keys != null) {
      $result.keys.addAll(keys);
    }
    return $result;
  }
  ListAuthorizedKeysResponse._() : super();
  factory ListAuthorizedKeysResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListAuthorizedKeysResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListAuthorizedKeysResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..pc<AuthorizedKey>(1, _omitFieldNames ? '' : 'keys', $pb.PbFieldType.PM, subBuilder: AuthorizedKey.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListAuthorizedKeysResponse clone() => ListAuthorizedKeysResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListAuthorizedKeysResponse copyWith(void Function(ListAuthorizedKeysResponse) updates) => super.copyWith((message) => updates(message as ListAuthorizedKeysResponse)) as ListAuthorizedKeysResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListAuthorizedKeysResponse create() => ListAuthorizedKeysResponse._();
  ListAuthorizedKeysResponse createEmptyInstance() => create();
  static $pb.PbList<ListAuthorizedKeysResponse> createRepeated() => $pb.PbList<ListAuthorizedKeysResponse>();
  @$core.pragma('dart2js:noInline')
  static ListAuthorizedKeysResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListAuthorizedKeysResponse>(create);
  static ListAuthorizedKeysResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<AuthorizedKey> get keys => $_getList(0);
}

class AddAuthorizedKeyRequest extends $pb.GeneratedMessage {
  factory AddAuthorizedKeyRequest({
    $6.Target? target,
    $core.String? publicKey,
    $core.Iterable<$core.String>? options,
    $core.String? user,
  }) {
    final $result = create();
    if (target != null) {
      $result.target = target;
    }
    if (publicKey != null) {
      $result.publicKey = publicKey;
    }
    if (options != null) {
      $result.options.addAll(options);
    }
    if (user != null) {
      $result.user = user;
    }
    return $result;
  }
  AddAuthorizedKeyRequest._() : super();
  factory AddAuthorizedKeyRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AddAuthorizedKeyRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AddAuthorizedKeyRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..aOM<$6.Target>(1, _omitFieldNames ? '' : 'target', subBuilder: $6.Target.create)
    ..aOS(2, _omitFieldNames ? '' : 'publicKey')
    ..pPS(3, _omitFieldNames ? '' : 'options')
    ..aOS(4, _omitFieldNames ? '' : 'user')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AddAuthorizedKeyRequest clone() => AddAuthorizedKeyRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AddAuthorizedKeyRequest copyWith(void Function(AddAuthorizedKeyRequest) updates) => super.copyWith((message) => updates(message as AddAuthorizedKeyRequest)) as AddAuthorizedKeyRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddAuthorizedKeyRequest create() => AddAuthorizedKeyRequest._();
  AddAuthorizedKeyRequest createEmptyInstance() => create();
  static $pb.PbList<AddAuthorizedKeyRequest> createRepeated() => $pb.PbList<AddAuthorizedKeyRequest>();
  @$core.pragma('dart2js:noInline')
  static AddAuthorizedKeyRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AddAuthorizedKeyRequest>(create);
  static AddAuthorizedKeyRequest? _defaultInstance;

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
  $core.String get publicKey => $_getSZ(1);
  @$pb.TagNumber(2)
  set publicKey($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPublicKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearPublicKey() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.String> get options => $_getList(2);

  @$pb.TagNumber(4)
  $core.String get user => $_getSZ(3);
  @$pb.TagNumber(4)
  set user($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasUser() => $_has(3);
  @$pb.TagNumber(4)
  void clearUser() => clearField(4);
}

class UpdateAuthorizedKeyRequest extends $pb.GeneratedMessage {
  factory UpdateAuthorizedKeyRequest({
    $6.Target? target,
    $core.String? keyId,
    $core.Iterable<$core.String>? options,
    $core.String? comment,
  }) {
    final $result = create();
    if (target != null) {
      $result.target = target;
    }
    if (keyId != null) {
      $result.keyId = keyId;
    }
    if (options != null) {
      $result.options.addAll(options);
    }
    if (comment != null) {
      $result.comment = comment;
    }
    return $result;
  }
  UpdateAuthorizedKeyRequest._() : super();
  factory UpdateAuthorizedKeyRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpdateAuthorizedKeyRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UpdateAuthorizedKeyRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..aOM<$6.Target>(1, _omitFieldNames ? '' : 'target', subBuilder: $6.Target.create)
    ..aOS(2, _omitFieldNames ? '' : 'keyId')
    ..pPS(3, _omitFieldNames ? '' : 'options')
    ..aOS(4, _omitFieldNames ? '' : 'comment')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpdateAuthorizedKeyRequest clone() => UpdateAuthorizedKeyRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpdateAuthorizedKeyRequest copyWith(void Function(UpdateAuthorizedKeyRequest) updates) => super.copyWith((message) => updates(message as UpdateAuthorizedKeyRequest)) as UpdateAuthorizedKeyRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateAuthorizedKeyRequest create() => UpdateAuthorizedKeyRequest._();
  UpdateAuthorizedKeyRequest createEmptyInstance() => create();
  static $pb.PbList<UpdateAuthorizedKeyRequest> createRepeated() => $pb.PbList<UpdateAuthorizedKeyRequest>();
  @$core.pragma('dart2js:noInline')
  static UpdateAuthorizedKeyRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateAuthorizedKeyRequest>(create);
  static UpdateAuthorizedKeyRequest? _defaultInstance;

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
  $core.String get keyId => $_getSZ(1);
  @$pb.TagNumber(2)
  set keyId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasKeyId() => $_has(1);
  @$pb.TagNumber(2)
  void clearKeyId() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.String> get options => $_getList(2);

  @$pb.TagNumber(4)
  $core.String get comment => $_getSZ(3);
  @$pb.TagNumber(4)
  set comment($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasComment() => $_has(3);
  @$pb.TagNumber(4)
  void clearComment() => clearField(4);
}

class RemoveAuthorizedKeyRequest extends $pb.GeneratedMessage {
  factory RemoveAuthorizedKeyRequest({
    $6.Target? target,
    $core.String? keyId,
    $core.String? user,
  }) {
    final $result = create();
    if (target != null) {
      $result.target = target;
    }
    if (keyId != null) {
      $result.keyId = keyId;
    }
    if (user != null) {
      $result.user = user;
    }
    return $result;
  }
  RemoveAuthorizedKeyRequest._() : super();
  factory RemoveAuthorizedKeyRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RemoveAuthorizedKeyRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RemoveAuthorizedKeyRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..aOM<$6.Target>(1, _omitFieldNames ? '' : 'target', subBuilder: $6.Target.create)
    ..aOS(2, _omitFieldNames ? '' : 'keyId')
    ..aOS(3, _omitFieldNames ? '' : 'user')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RemoveAuthorizedKeyRequest clone() => RemoveAuthorizedKeyRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RemoveAuthorizedKeyRequest copyWith(void Function(RemoveAuthorizedKeyRequest) updates) => super.copyWith((message) => updates(message as RemoveAuthorizedKeyRequest)) as RemoveAuthorizedKeyRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RemoveAuthorizedKeyRequest create() => RemoveAuthorizedKeyRequest._();
  RemoveAuthorizedKeyRequest createEmptyInstance() => create();
  static $pb.PbList<RemoveAuthorizedKeyRequest> createRepeated() => $pb.PbList<RemoveAuthorizedKeyRequest>();
  @$core.pragma('dart2js:noInline')
  static RemoveAuthorizedKeyRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RemoveAuthorizedKeyRequest>(create);
  static RemoveAuthorizedKeyRequest? _defaultInstance;

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
  $core.String get keyId => $_getSZ(1);
  @$pb.TagNumber(2)
  set keyId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasKeyId() => $_has(1);
  @$pb.TagNumber(2)
  void clearKeyId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get user => $_getSZ(2);
  @$pb.TagNumber(3)
  set user($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasUser() => $_has(2);
  @$pb.TagNumber(3)
  void clearUser() => clearField(3);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
