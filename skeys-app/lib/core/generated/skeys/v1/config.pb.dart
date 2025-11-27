//
//  Generated code. Do not modify.
//  source: skeys/v1/config.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'common.pb.dart' as $8;

class HostConfig extends $pb.GeneratedMessage {
  factory HostConfig({
    $core.String? alias,
    $core.String? hostname,
    $core.String? user,
    $core.int? port,
    $core.Iterable<$core.String>? identityFiles,
    $core.String? proxyJump,
    $core.String? proxyCommand,
    $core.bool? forwardAgent,
    $core.bool? identitiesOnly,
    $core.String? strictHostKeyChecking,
    $core.int? serverAliveInterval,
    $core.int? serverAliveCountMax,
    $core.Map<$core.String, $core.String>? extraOptions,
    $core.bool? isPattern,
    $core.int? lineNumber,
  }) {
    final $result = create();
    if (alias != null) {
      $result.alias = alias;
    }
    if (hostname != null) {
      $result.hostname = hostname;
    }
    if (user != null) {
      $result.user = user;
    }
    if (port != null) {
      $result.port = port;
    }
    if (identityFiles != null) {
      $result.identityFiles.addAll(identityFiles);
    }
    if (proxyJump != null) {
      $result.proxyJump = proxyJump;
    }
    if (proxyCommand != null) {
      $result.proxyCommand = proxyCommand;
    }
    if (forwardAgent != null) {
      $result.forwardAgent = forwardAgent;
    }
    if (identitiesOnly != null) {
      $result.identitiesOnly = identitiesOnly;
    }
    if (strictHostKeyChecking != null) {
      $result.strictHostKeyChecking = strictHostKeyChecking;
    }
    if (serverAliveInterval != null) {
      $result.serverAliveInterval = serverAliveInterval;
    }
    if (serverAliveCountMax != null) {
      $result.serverAliveCountMax = serverAliveCountMax;
    }
    if (extraOptions != null) {
      $result.extraOptions.addAll(extraOptions);
    }
    if (isPattern != null) {
      $result.isPattern = isPattern;
    }
    if (lineNumber != null) {
      $result.lineNumber = lineNumber;
    }
    return $result;
  }
  HostConfig._() : super();
  factory HostConfig.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory HostConfig.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'HostConfig', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'alias')
    ..aOS(2, _omitFieldNames ? '' : 'hostname')
    ..aOS(3, _omitFieldNames ? '' : 'user')
    ..a<$core.int>(4, _omitFieldNames ? '' : 'port', $pb.PbFieldType.O3)
    ..pPS(5, _omitFieldNames ? '' : 'identityFiles')
    ..aOS(6, _omitFieldNames ? '' : 'proxyJump')
    ..aOS(7, _omitFieldNames ? '' : 'proxyCommand')
    ..aOB(8, _omitFieldNames ? '' : 'forwardAgent')
    ..aOB(9, _omitFieldNames ? '' : 'identitiesOnly')
    ..aOS(10, _omitFieldNames ? '' : 'strictHostKeyChecking')
    ..a<$core.int>(11, _omitFieldNames ? '' : 'serverAliveInterval', $pb.PbFieldType.O3)
    ..a<$core.int>(12, _omitFieldNames ? '' : 'serverAliveCountMax', $pb.PbFieldType.O3)
    ..m<$core.String, $core.String>(13, _omitFieldNames ? '' : 'extraOptions', entryClassName: 'HostConfig.ExtraOptionsEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OS, packageName: const $pb.PackageName('skeys.v1'))
    ..aOB(14, _omitFieldNames ? '' : 'isPattern')
    ..a<$core.int>(15, _omitFieldNames ? '' : 'lineNumber', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  HostConfig clone() => HostConfig()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  HostConfig copyWith(void Function(HostConfig) updates) => super.copyWith((message) => updates(message as HostConfig)) as HostConfig;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HostConfig create() => HostConfig._();
  HostConfig createEmptyInstance() => create();
  static $pb.PbList<HostConfig> createRepeated() => $pb.PbList<HostConfig>();
  @$core.pragma('dart2js:noInline')
  static HostConfig getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<HostConfig>(create);
  static HostConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get alias => $_getSZ(0);
  @$pb.TagNumber(1)
  set alias($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAlias() => $_has(0);
  @$pb.TagNumber(1)
  void clearAlias() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get hostname => $_getSZ(1);
  @$pb.TagNumber(2)
  set hostname($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasHostname() => $_has(1);
  @$pb.TagNumber(2)
  void clearHostname() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get user => $_getSZ(2);
  @$pb.TagNumber(3)
  set user($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasUser() => $_has(2);
  @$pb.TagNumber(3)
  void clearUser() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get port => $_getIZ(3);
  @$pb.TagNumber(4)
  set port($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasPort() => $_has(3);
  @$pb.TagNumber(4)
  void clearPort() => clearField(4);

  @$pb.TagNumber(5)
  $core.List<$core.String> get identityFiles => $_getList(4);

  @$pb.TagNumber(6)
  $core.String get proxyJump => $_getSZ(5);
  @$pb.TagNumber(6)
  set proxyJump($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasProxyJump() => $_has(5);
  @$pb.TagNumber(6)
  void clearProxyJump() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get proxyCommand => $_getSZ(6);
  @$pb.TagNumber(7)
  set proxyCommand($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasProxyCommand() => $_has(6);
  @$pb.TagNumber(7)
  void clearProxyCommand() => clearField(7);

  @$pb.TagNumber(8)
  $core.bool get forwardAgent => $_getBF(7);
  @$pb.TagNumber(8)
  set forwardAgent($core.bool v) { $_setBool(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasForwardAgent() => $_has(7);
  @$pb.TagNumber(8)
  void clearForwardAgent() => clearField(8);

  @$pb.TagNumber(9)
  $core.bool get identitiesOnly => $_getBF(8);
  @$pb.TagNumber(9)
  set identitiesOnly($core.bool v) { $_setBool(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasIdentitiesOnly() => $_has(8);
  @$pb.TagNumber(9)
  void clearIdentitiesOnly() => clearField(9);

  @$pb.TagNumber(10)
  $core.String get strictHostKeyChecking => $_getSZ(9);
  @$pb.TagNumber(10)
  set strictHostKeyChecking($core.String v) { $_setString(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasStrictHostKeyChecking() => $_has(9);
  @$pb.TagNumber(10)
  void clearStrictHostKeyChecking() => clearField(10);

  @$pb.TagNumber(11)
  $core.int get serverAliveInterval => $_getIZ(10);
  @$pb.TagNumber(11)
  set serverAliveInterval($core.int v) { $_setSignedInt32(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasServerAliveInterval() => $_has(10);
  @$pb.TagNumber(11)
  void clearServerAliveInterval() => clearField(11);

  @$pb.TagNumber(12)
  $core.int get serverAliveCountMax => $_getIZ(11);
  @$pb.TagNumber(12)
  set serverAliveCountMax($core.int v) { $_setSignedInt32(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasServerAliveCountMax() => $_has(11);
  @$pb.TagNumber(12)
  void clearServerAliveCountMax() => clearField(12);

  @$pb.TagNumber(13)
  $core.Map<$core.String, $core.String> get extraOptions => $_getMap(12);

  @$pb.TagNumber(14)
  $core.bool get isPattern => $_getBF(13);
  @$pb.TagNumber(14)
  set isPattern($core.bool v) { $_setBool(13, v); }
  @$pb.TagNumber(14)
  $core.bool hasIsPattern() => $_has(13);
  @$pb.TagNumber(14)
  void clearIsPattern() => clearField(14);

  @$pb.TagNumber(15)
  $core.int get lineNumber => $_getIZ(14);
  @$pb.TagNumber(15)
  set lineNumber($core.int v) { $_setSignedInt32(14, v); }
  @$pb.TagNumber(15)
  $core.bool hasLineNumber() => $_has(14);
  @$pb.TagNumber(15)
  void clearLineNumber() => clearField(15);
}

class ListHostConfigsRequest extends $pb.GeneratedMessage {
  factory ListHostConfigsRequest({
    $8.Target? target,
  }) {
    final $result = create();
    if (target != null) {
      $result.target = target;
    }
    return $result;
  }
  ListHostConfigsRequest._() : super();
  factory ListHostConfigsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListHostConfigsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListHostConfigsRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..aOM<$8.Target>(1, _omitFieldNames ? '' : 'target', subBuilder: $8.Target.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListHostConfigsRequest clone() => ListHostConfigsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListHostConfigsRequest copyWith(void Function(ListHostConfigsRequest) updates) => super.copyWith((message) => updates(message as ListHostConfigsRequest)) as ListHostConfigsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListHostConfigsRequest create() => ListHostConfigsRequest._();
  ListHostConfigsRequest createEmptyInstance() => create();
  static $pb.PbList<ListHostConfigsRequest> createRepeated() => $pb.PbList<ListHostConfigsRequest>();
  @$core.pragma('dart2js:noInline')
  static ListHostConfigsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListHostConfigsRequest>(create);
  static ListHostConfigsRequest? _defaultInstance;

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

class ListHostConfigsResponse extends $pb.GeneratedMessage {
  factory ListHostConfigsResponse({
    $core.Iterable<HostConfig>? hosts,
  }) {
    final $result = create();
    if (hosts != null) {
      $result.hosts.addAll(hosts);
    }
    return $result;
  }
  ListHostConfigsResponse._() : super();
  factory ListHostConfigsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListHostConfigsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListHostConfigsResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..pc<HostConfig>(1, _omitFieldNames ? '' : 'hosts', $pb.PbFieldType.PM, subBuilder: HostConfig.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListHostConfigsResponse clone() => ListHostConfigsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListHostConfigsResponse copyWith(void Function(ListHostConfigsResponse) updates) => super.copyWith((message) => updates(message as ListHostConfigsResponse)) as ListHostConfigsResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListHostConfigsResponse create() => ListHostConfigsResponse._();
  ListHostConfigsResponse createEmptyInstance() => create();
  static $pb.PbList<ListHostConfigsResponse> createRepeated() => $pb.PbList<ListHostConfigsResponse>();
  @$core.pragma('dart2js:noInline')
  static ListHostConfigsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListHostConfigsResponse>(create);
  static ListHostConfigsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<HostConfig> get hosts => $_getList(0);
}

class GetHostConfigRequest extends $pb.GeneratedMessage {
  factory GetHostConfigRequest({
    $8.Target? target,
    $core.String? alias,
  }) {
    final $result = create();
    if (target != null) {
      $result.target = target;
    }
    if (alias != null) {
      $result.alias = alias;
    }
    return $result;
  }
  GetHostConfigRequest._() : super();
  factory GetHostConfigRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetHostConfigRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetHostConfigRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..aOM<$8.Target>(1, _omitFieldNames ? '' : 'target', subBuilder: $8.Target.create)
    ..aOS(2, _omitFieldNames ? '' : 'alias')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetHostConfigRequest clone() => GetHostConfigRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetHostConfigRequest copyWith(void Function(GetHostConfigRequest) updates) => super.copyWith((message) => updates(message as GetHostConfigRequest)) as GetHostConfigRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetHostConfigRequest create() => GetHostConfigRequest._();
  GetHostConfigRequest createEmptyInstance() => create();
  static $pb.PbList<GetHostConfigRequest> createRepeated() => $pb.PbList<GetHostConfigRequest>();
  @$core.pragma('dart2js:noInline')
  static GetHostConfigRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetHostConfigRequest>(create);
  static GetHostConfigRequest? _defaultInstance;

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
  $core.String get alias => $_getSZ(1);
  @$pb.TagNumber(2)
  set alias($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAlias() => $_has(1);
  @$pb.TagNumber(2)
  void clearAlias() => clearField(2);
}

class CreateHostConfigRequest extends $pb.GeneratedMessage {
  factory CreateHostConfigRequest({
    $8.Target? target,
    HostConfig? config,
  }) {
    final $result = create();
    if (target != null) {
      $result.target = target;
    }
    if (config != null) {
      $result.config = config;
    }
    return $result;
  }
  CreateHostConfigRequest._() : super();
  factory CreateHostConfigRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateHostConfigRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CreateHostConfigRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..aOM<$8.Target>(1, _omitFieldNames ? '' : 'target', subBuilder: $8.Target.create)
    ..aOM<HostConfig>(2, _omitFieldNames ? '' : 'config', subBuilder: HostConfig.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateHostConfigRequest clone() => CreateHostConfigRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateHostConfigRequest copyWith(void Function(CreateHostConfigRequest) updates) => super.copyWith((message) => updates(message as CreateHostConfigRequest)) as CreateHostConfigRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateHostConfigRequest create() => CreateHostConfigRequest._();
  CreateHostConfigRequest createEmptyInstance() => create();
  static $pb.PbList<CreateHostConfigRequest> createRepeated() => $pb.PbList<CreateHostConfigRequest>();
  @$core.pragma('dart2js:noInline')
  static CreateHostConfigRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateHostConfigRequest>(create);
  static CreateHostConfigRequest? _defaultInstance;

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
  HostConfig get config => $_getN(1);
  @$pb.TagNumber(2)
  set config(HostConfig v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasConfig() => $_has(1);
  @$pb.TagNumber(2)
  void clearConfig() => clearField(2);
  @$pb.TagNumber(2)
  HostConfig ensureConfig() => $_ensure(1);
}

class UpdateHostConfigRequest extends $pb.GeneratedMessage {
  factory UpdateHostConfigRequest({
    $8.Target? target,
    $core.String? alias,
    HostConfig? config,
  }) {
    final $result = create();
    if (target != null) {
      $result.target = target;
    }
    if (alias != null) {
      $result.alias = alias;
    }
    if (config != null) {
      $result.config = config;
    }
    return $result;
  }
  UpdateHostConfigRequest._() : super();
  factory UpdateHostConfigRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpdateHostConfigRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UpdateHostConfigRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..aOM<$8.Target>(1, _omitFieldNames ? '' : 'target', subBuilder: $8.Target.create)
    ..aOS(2, _omitFieldNames ? '' : 'alias')
    ..aOM<HostConfig>(3, _omitFieldNames ? '' : 'config', subBuilder: HostConfig.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpdateHostConfigRequest clone() => UpdateHostConfigRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpdateHostConfigRequest copyWith(void Function(UpdateHostConfigRequest) updates) => super.copyWith((message) => updates(message as UpdateHostConfigRequest)) as UpdateHostConfigRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateHostConfigRequest create() => UpdateHostConfigRequest._();
  UpdateHostConfigRequest createEmptyInstance() => create();
  static $pb.PbList<UpdateHostConfigRequest> createRepeated() => $pb.PbList<UpdateHostConfigRequest>();
  @$core.pragma('dart2js:noInline')
  static UpdateHostConfigRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateHostConfigRequest>(create);
  static UpdateHostConfigRequest? _defaultInstance;

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
  $core.String get alias => $_getSZ(1);
  @$pb.TagNumber(2)
  set alias($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAlias() => $_has(1);
  @$pb.TagNumber(2)
  void clearAlias() => clearField(2);

  @$pb.TagNumber(3)
  HostConfig get config => $_getN(2);
  @$pb.TagNumber(3)
  set config(HostConfig v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasConfig() => $_has(2);
  @$pb.TagNumber(3)
  void clearConfig() => clearField(3);
  @$pb.TagNumber(3)
  HostConfig ensureConfig() => $_ensure(2);
}

class DeleteHostConfigRequest extends $pb.GeneratedMessage {
  factory DeleteHostConfigRequest({
    $8.Target? target,
    $core.String? alias,
  }) {
    final $result = create();
    if (target != null) {
      $result.target = target;
    }
    if (alias != null) {
      $result.alias = alias;
    }
    return $result;
  }
  DeleteHostConfigRequest._() : super();
  factory DeleteHostConfigRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeleteHostConfigRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DeleteHostConfigRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..aOM<$8.Target>(1, _omitFieldNames ? '' : 'target', subBuilder: $8.Target.create)
    ..aOS(2, _omitFieldNames ? '' : 'alias')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeleteHostConfigRequest clone() => DeleteHostConfigRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeleteHostConfigRequest copyWith(void Function(DeleteHostConfigRequest) updates) => super.copyWith((message) => updates(message as DeleteHostConfigRequest)) as DeleteHostConfigRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteHostConfigRequest create() => DeleteHostConfigRequest._();
  DeleteHostConfigRequest createEmptyInstance() => create();
  static $pb.PbList<DeleteHostConfigRequest> createRepeated() => $pb.PbList<DeleteHostConfigRequest>();
  @$core.pragma('dart2js:noInline')
  static DeleteHostConfigRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeleteHostConfigRequest>(create);
  static DeleteHostConfigRequest? _defaultInstance;

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
  $core.String get alias => $_getSZ(1);
  @$pb.TagNumber(2)
  set alias($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAlias() => $_has(1);
  @$pb.TagNumber(2)
  void clearAlias() => clearField(2);
}

class TestConnectionRequest extends $pb.GeneratedMessage {
  factory TestConnectionRequest({
    $8.Target? target,
    $core.String? alias,
    $core.int? timeoutSeconds,
  }) {
    final $result = create();
    if (target != null) {
      $result.target = target;
    }
    if (alias != null) {
      $result.alias = alias;
    }
    if (timeoutSeconds != null) {
      $result.timeoutSeconds = timeoutSeconds;
    }
    return $result;
  }
  TestConnectionRequest._() : super();
  factory TestConnectionRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TestConnectionRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TestConnectionRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..aOM<$8.Target>(1, _omitFieldNames ? '' : 'target', subBuilder: $8.Target.create)
    ..aOS(2, _omitFieldNames ? '' : 'alias')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'timeoutSeconds', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TestConnectionRequest clone() => TestConnectionRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TestConnectionRequest copyWith(void Function(TestConnectionRequest) updates) => super.copyWith((message) => updates(message as TestConnectionRequest)) as TestConnectionRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TestConnectionRequest create() => TestConnectionRequest._();
  TestConnectionRequest createEmptyInstance() => create();
  static $pb.PbList<TestConnectionRequest> createRepeated() => $pb.PbList<TestConnectionRequest>();
  @$core.pragma('dart2js:noInline')
  static TestConnectionRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TestConnectionRequest>(create);
  static TestConnectionRequest? _defaultInstance;

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
  $core.String get alias => $_getSZ(1);
  @$pb.TagNumber(2)
  set alias($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAlias() => $_has(1);
  @$pb.TagNumber(2)
  void clearAlias() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get timeoutSeconds => $_getIZ(2);
  @$pb.TagNumber(3)
  set timeoutSeconds($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasTimeoutSeconds() => $_has(2);
  @$pb.TagNumber(3)
  void clearTimeoutSeconds() => clearField(3);
}

class TestConnectionResponse extends $pb.GeneratedMessage {
  factory TestConnectionResponse({
    $core.bool? success,
    $core.String? message,
    $core.String? serverVersion,
    $core.int? latencyMs,
  }) {
    final $result = create();
    if (success != null) {
      $result.success = success;
    }
    if (message != null) {
      $result.message = message;
    }
    if (serverVersion != null) {
      $result.serverVersion = serverVersion;
    }
    if (latencyMs != null) {
      $result.latencyMs = latencyMs;
    }
    return $result;
  }
  TestConnectionResponse._() : super();
  factory TestConnectionResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TestConnectionResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TestConnectionResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..aOS(3, _omitFieldNames ? '' : 'serverVersion')
    ..a<$core.int>(4, _omitFieldNames ? '' : 'latencyMs', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TestConnectionResponse clone() => TestConnectionResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TestConnectionResponse copyWith(void Function(TestConnectionResponse) updates) => super.copyWith((message) => updates(message as TestConnectionResponse)) as TestConnectionResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TestConnectionResponse create() => TestConnectionResponse._();
  TestConnectionResponse createEmptyInstance() => create();
  static $pb.PbList<TestConnectionResponse> createRepeated() => $pb.PbList<TestConnectionResponse>();
  @$core.pragma('dart2js:noInline')
  static TestConnectionResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TestConnectionResponse>(create);
  static TestConnectionResponse? _defaultInstance;

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

  @$pb.TagNumber(3)
  $core.String get serverVersion => $_getSZ(2);
  @$pb.TagNumber(3)
  set serverVersion($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasServerVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearServerVersion() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get latencyMs => $_getIZ(3);
  @$pb.TagNumber(4)
  set latencyMs($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasLatencyMs() => $_has(3);
  @$pb.TagNumber(4)
  void clearLatencyMs() => clearField(4);
}

class ServerConfig extends $pb.GeneratedMessage {
  factory ServerConfig({
    $core.Iterable<ServerConfigDirective>? directives,
    $core.String? rawContent,
  }) {
    final $result = create();
    if (directives != null) {
      $result.directives.addAll(directives);
    }
    if (rawContent != null) {
      $result.rawContent = rawContent;
    }
    return $result;
  }
  ServerConfig._() : super();
  factory ServerConfig.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ServerConfig.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ServerConfig', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..pc<ServerConfigDirective>(1, _omitFieldNames ? '' : 'directives', $pb.PbFieldType.PM, subBuilder: ServerConfigDirective.create)
    ..aOS(2, _omitFieldNames ? '' : 'rawContent')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ServerConfig clone() => ServerConfig()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ServerConfig copyWith(void Function(ServerConfig) updates) => super.copyWith((message) => updates(message as ServerConfig)) as ServerConfig;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServerConfig create() => ServerConfig._();
  ServerConfig createEmptyInstance() => create();
  static $pb.PbList<ServerConfig> createRepeated() => $pb.PbList<ServerConfig>();
  @$core.pragma('dart2js:noInline')
  static ServerConfig getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ServerConfig>(create);
  static ServerConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<ServerConfigDirective> get directives => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get rawContent => $_getSZ(1);
  @$pb.TagNumber(2)
  set rawContent($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasRawContent() => $_has(1);
  @$pb.TagNumber(2)
  void clearRawContent() => clearField(2);
}

class ServerConfigDirective extends $pb.GeneratedMessage {
  factory ServerConfigDirective({
    $core.String? key,
    $core.String? value,
    $core.int? lineNumber,
    $core.bool? isCommented,
    $core.String? matchBlock,
  }) {
    final $result = create();
    if (key != null) {
      $result.key = key;
    }
    if (value != null) {
      $result.value = value;
    }
    if (lineNumber != null) {
      $result.lineNumber = lineNumber;
    }
    if (isCommented != null) {
      $result.isCommented = isCommented;
    }
    if (matchBlock != null) {
      $result.matchBlock = matchBlock;
    }
    return $result;
  }
  ServerConfigDirective._() : super();
  factory ServerConfigDirective.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ServerConfigDirective.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ServerConfigDirective', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'key')
    ..aOS(2, _omitFieldNames ? '' : 'value')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'lineNumber', $pb.PbFieldType.O3)
    ..aOB(4, _omitFieldNames ? '' : 'isCommented')
    ..aOS(5, _omitFieldNames ? '' : 'matchBlock')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ServerConfigDirective clone() => ServerConfigDirective()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ServerConfigDirective copyWith(void Function(ServerConfigDirective) updates) => super.copyWith((message) => updates(message as ServerConfigDirective)) as ServerConfigDirective;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServerConfigDirective create() => ServerConfigDirective._();
  ServerConfigDirective createEmptyInstance() => create();
  static $pb.PbList<ServerConfigDirective> createRepeated() => $pb.PbList<ServerConfigDirective>();
  @$core.pragma('dart2js:noInline')
  static ServerConfigDirective getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ServerConfigDirective>(create);
  static ServerConfigDirective? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get key => $_getSZ(0);
  @$pb.TagNumber(1)
  set key($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearKey() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get value => $_getSZ(1);
  @$pb.TagNumber(2)
  set value($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearValue() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get lineNumber => $_getIZ(2);
  @$pb.TagNumber(3)
  set lineNumber($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasLineNumber() => $_has(2);
  @$pb.TagNumber(3)
  void clearLineNumber() => clearField(3);

  @$pb.TagNumber(4)
  $core.bool get isCommented => $_getBF(3);
  @$pb.TagNumber(4)
  set isCommented($core.bool v) { $_setBool(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasIsCommented() => $_has(3);
  @$pb.TagNumber(4)
  void clearIsCommented() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get matchBlock => $_getSZ(4);
  @$pb.TagNumber(5)
  set matchBlock($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasMatchBlock() => $_has(4);
  @$pb.TagNumber(5)
  void clearMatchBlock() => clearField(5);
}

class GetServerConfigRequest extends $pb.GeneratedMessage {
  factory GetServerConfigRequest({
    $8.Target? target,
  }) {
    final $result = create();
    if (target != null) {
      $result.target = target;
    }
    return $result;
  }
  GetServerConfigRequest._() : super();
  factory GetServerConfigRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetServerConfigRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetServerConfigRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..aOM<$8.Target>(1, _omitFieldNames ? '' : 'target', subBuilder: $8.Target.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetServerConfigRequest clone() => GetServerConfigRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetServerConfigRequest copyWith(void Function(GetServerConfigRequest) updates) => super.copyWith((message) => updates(message as GetServerConfigRequest)) as GetServerConfigRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetServerConfigRequest create() => GetServerConfigRequest._();
  GetServerConfigRequest createEmptyInstance() => create();
  static $pb.PbList<GetServerConfigRequest> createRepeated() => $pb.PbList<GetServerConfigRequest>();
  @$core.pragma('dart2js:noInline')
  static GetServerConfigRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetServerConfigRequest>(create);
  static GetServerConfigRequest? _defaultInstance;

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

class UpdateServerConfigRequest extends $pb.GeneratedMessage {
  factory UpdateServerConfigRequest({
    $8.Target? target,
    $core.Iterable<ServerConfigUpdate>? updates,
  }) {
    final $result = create();
    if (target != null) {
      $result.target = target;
    }
    if (updates != null) {
      $result.updates.addAll(updates);
    }
    return $result;
  }
  UpdateServerConfigRequest._() : super();
  factory UpdateServerConfigRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpdateServerConfigRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UpdateServerConfigRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..aOM<$8.Target>(1, _omitFieldNames ? '' : 'target', subBuilder: $8.Target.create)
    ..pc<ServerConfigUpdate>(2, _omitFieldNames ? '' : 'updates', $pb.PbFieldType.PM, subBuilder: ServerConfigUpdate.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpdateServerConfigRequest clone() => UpdateServerConfigRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpdateServerConfigRequest copyWith(void Function(UpdateServerConfigRequest) updates) => super.copyWith((message) => updates(message as UpdateServerConfigRequest)) as UpdateServerConfigRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateServerConfigRequest create() => UpdateServerConfigRequest._();
  UpdateServerConfigRequest createEmptyInstance() => create();
  static $pb.PbList<UpdateServerConfigRequest> createRepeated() => $pb.PbList<UpdateServerConfigRequest>();
  @$core.pragma('dart2js:noInline')
  static UpdateServerConfigRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateServerConfigRequest>(create);
  static UpdateServerConfigRequest? _defaultInstance;

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
  $core.List<ServerConfigUpdate> get updates => $_getList(1);
}

class ServerConfigUpdate extends $pb.GeneratedMessage {
  factory ServerConfigUpdate({
    $core.String? key,
    $core.String? value,
    $core.bool? delete,
  }) {
    final $result = create();
    if (key != null) {
      $result.key = key;
    }
    if (value != null) {
      $result.value = value;
    }
    if (delete != null) {
      $result.delete = delete;
    }
    return $result;
  }
  ServerConfigUpdate._() : super();
  factory ServerConfigUpdate.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ServerConfigUpdate.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ServerConfigUpdate', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'key')
    ..aOS(2, _omitFieldNames ? '' : 'value')
    ..aOB(3, _omitFieldNames ? '' : 'delete')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ServerConfigUpdate clone() => ServerConfigUpdate()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ServerConfigUpdate copyWith(void Function(ServerConfigUpdate) updates) => super.copyWith((message) => updates(message as ServerConfigUpdate)) as ServerConfigUpdate;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServerConfigUpdate create() => ServerConfigUpdate._();
  ServerConfigUpdate createEmptyInstance() => create();
  static $pb.PbList<ServerConfigUpdate> createRepeated() => $pb.PbList<ServerConfigUpdate>();
  @$core.pragma('dart2js:noInline')
  static ServerConfigUpdate getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ServerConfigUpdate>(create);
  static ServerConfigUpdate? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get key => $_getSZ(0);
  @$pb.TagNumber(1)
  set key($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearKey() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get value => $_getSZ(1);
  @$pb.TagNumber(2)
  set value($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearValue() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get delete => $_getBF(2);
  @$pb.TagNumber(3)
  set delete($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasDelete() => $_has(2);
  @$pb.TagNumber(3)
  void clearDelete() => clearField(3);
}

class ValidateServerConfigRequest extends $pb.GeneratedMessage {
  factory ValidateServerConfigRequest({
    $8.Target? target,
    $core.String? content,
  }) {
    final $result = create();
    if (target != null) {
      $result.target = target;
    }
    if (content != null) {
      $result.content = content;
    }
    return $result;
  }
  ValidateServerConfigRequest._() : super();
  factory ValidateServerConfigRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ValidateServerConfigRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ValidateServerConfigRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..aOM<$8.Target>(1, _omitFieldNames ? '' : 'target', subBuilder: $8.Target.create)
    ..aOS(2, _omitFieldNames ? '' : 'content')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ValidateServerConfigRequest clone() => ValidateServerConfigRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ValidateServerConfigRequest copyWith(void Function(ValidateServerConfigRequest) updates) => super.copyWith((message) => updates(message as ValidateServerConfigRequest)) as ValidateServerConfigRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ValidateServerConfigRequest create() => ValidateServerConfigRequest._();
  ValidateServerConfigRequest createEmptyInstance() => create();
  static $pb.PbList<ValidateServerConfigRequest> createRepeated() => $pb.PbList<ValidateServerConfigRequest>();
  @$core.pragma('dart2js:noInline')
  static ValidateServerConfigRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ValidateServerConfigRequest>(create);
  static ValidateServerConfigRequest? _defaultInstance;

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
  $core.String get content => $_getSZ(1);
  @$pb.TagNumber(2)
  set content($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasContent() => $_has(1);
  @$pb.TagNumber(2)
  void clearContent() => clearField(2);
}

class ValidateServerConfigResponse extends $pb.GeneratedMessage {
  factory ValidateServerConfigResponse({
    $core.bool? valid,
    $core.String? errorMessage,
  }) {
    final $result = create();
    if (valid != null) {
      $result.valid = valid;
    }
    if (errorMessage != null) {
      $result.errorMessage = errorMessage;
    }
    return $result;
  }
  ValidateServerConfigResponse._() : super();
  factory ValidateServerConfigResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ValidateServerConfigResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ValidateServerConfigResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'valid')
    ..aOS(2, _omitFieldNames ? '' : 'errorMessage')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ValidateServerConfigResponse clone() => ValidateServerConfigResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ValidateServerConfigResponse copyWith(void Function(ValidateServerConfigResponse) updates) => super.copyWith((message) => updates(message as ValidateServerConfigResponse)) as ValidateServerConfigResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ValidateServerConfigResponse create() => ValidateServerConfigResponse._();
  ValidateServerConfigResponse createEmptyInstance() => create();
  static $pb.PbList<ValidateServerConfigResponse> createRepeated() => $pb.PbList<ValidateServerConfigResponse>();
  @$core.pragma('dart2js:noInline')
  static ValidateServerConfigResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ValidateServerConfigResponse>(create);
  static ValidateServerConfigResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get valid => $_getBF(0);
  @$pb.TagNumber(1)
  set valid($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasValid() => $_has(0);
  @$pb.TagNumber(1)
  void clearValid() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get errorMessage => $_getSZ(1);
  @$pb.TagNumber(2)
  set errorMessage($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasErrorMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearErrorMessage() => clearField(2);
}

class RestartSSHServiceRequest extends $pb.GeneratedMessage {
  factory RestartSSHServiceRequest({
    $8.Target? target,
    $core.bool? reloadOnly,
  }) {
    final $result = create();
    if (target != null) {
      $result.target = target;
    }
    if (reloadOnly != null) {
      $result.reloadOnly = reloadOnly;
    }
    return $result;
  }
  RestartSSHServiceRequest._() : super();
  factory RestartSSHServiceRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RestartSSHServiceRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RestartSSHServiceRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..aOM<$8.Target>(1, _omitFieldNames ? '' : 'target', subBuilder: $8.Target.create)
    ..aOB(2, _omitFieldNames ? '' : 'reloadOnly')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RestartSSHServiceRequest clone() => RestartSSHServiceRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RestartSSHServiceRequest copyWith(void Function(RestartSSHServiceRequest) updates) => super.copyWith((message) => updates(message as RestartSSHServiceRequest)) as RestartSSHServiceRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RestartSSHServiceRequest create() => RestartSSHServiceRequest._();
  RestartSSHServiceRequest createEmptyInstance() => create();
  static $pb.PbList<RestartSSHServiceRequest> createRepeated() => $pb.PbList<RestartSSHServiceRequest>();
  @$core.pragma('dart2js:noInline')
  static RestartSSHServiceRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RestartSSHServiceRequest>(create);
  static RestartSSHServiceRequest? _defaultInstance;

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
  $core.bool get reloadOnly => $_getBF(1);
  @$pb.TagNumber(2)
  set reloadOnly($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasReloadOnly() => $_has(1);
  @$pb.TagNumber(2)
  void clearReloadOnly() => clearField(2);
}

class RestartSSHServiceResponse extends $pb.GeneratedMessage {
  factory RestartSSHServiceResponse({
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
  RestartSSHServiceResponse._() : super();
  factory RestartSSHServiceResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RestartSSHServiceResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RestartSSHServiceResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RestartSSHServiceResponse clone() => RestartSSHServiceResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RestartSSHServiceResponse copyWith(void Function(RestartSSHServiceResponse) updates) => super.copyWith((message) => updates(message as RestartSSHServiceResponse)) as RestartSSHServiceResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RestartSSHServiceResponse create() => RestartSSHServiceResponse._();
  RestartSSHServiceResponse createEmptyInstance() => create();
  static $pb.PbList<RestartSSHServiceResponse> createRepeated() => $pb.PbList<RestartSSHServiceResponse>();
  @$core.pragma('dart2js:noInline')
  static RestartSSHServiceResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RestartSSHServiceResponse>(create);
  static RestartSSHServiceResponse? _defaultInstance;

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

/// Skeys SSH Agent Integration messages
class GetSshConfigStatusRequest extends $pb.GeneratedMessage {
  factory GetSshConfigStatusRequest() => create();
  GetSshConfigStatusRequest._() : super();
  factory GetSshConfigStatusRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetSshConfigStatusRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetSshConfigStatusRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetSshConfigStatusRequest clone() => GetSshConfigStatusRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetSshConfigStatusRequest copyWith(void Function(GetSshConfigStatusRequest) updates) => super.copyWith((message) => updates(message as GetSshConfigStatusRequest)) as GetSshConfigStatusRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetSshConfigStatusRequest create() => GetSshConfigStatusRequest._();
  GetSshConfigStatusRequest createEmptyInstance() => create();
  static $pb.PbList<GetSshConfigStatusRequest> createRepeated() => $pb.PbList<GetSshConfigStatusRequest>();
  @$core.pragma('dart2js:noInline')
  static GetSshConfigStatusRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetSshConfigStatusRequest>(create);
  static GetSshConfigStatusRequest? _defaultInstance;
}

class GetSshConfigStatusResponse extends $pb.GeneratedMessage {
  factory GetSshConfigStatusResponse({
    $core.bool? enabled,
    $core.String? agentSocket,
  }) {
    final $result = create();
    if (enabled != null) {
      $result.enabled = enabled;
    }
    if (agentSocket != null) {
      $result.agentSocket = agentSocket;
    }
    return $result;
  }
  GetSshConfigStatusResponse._() : super();
  factory GetSshConfigStatusResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetSshConfigStatusResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetSshConfigStatusResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'enabled')
    ..aOS(2, _omitFieldNames ? '' : 'agentSocket')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetSshConfigStatusResponse clone() => GetSshConfigStatusResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetSshConfigStatusResponse copyWith(void Function(GetSshConfigStatusResponse) updates) => super.copyWith((message) => updates(message as GetSshConfigStatusResponse)) as GetSshConfigStatusResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetSshConfigStatusResponse create() => GetSshConfigStatusResponse._();
  GetSshConfigStatusResponse createEmptyInstance() => create();
  static $pb.PbList<GetSshConfigStatusResponse> createRepeated() => $pb.PbList<GetSshConfigStatusResponse>();
  @$core.pragma('dart2js:noInline')
  static GetSshConfigStatusResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetSshConfigStatusResponse>(create);
  static GetSshConfigStatusResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get enabled => $_getBF(0);
  @$pb.TagNumber(1)
  set enabled($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasEnabled() => $_has(0);
  @$pb.TagNumber(1)
  void clearEnabled() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get agentSocket => $_getSZ(1);
  @$pb.TagNumber(2)
  set agentSocket($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAgentSocket() => $_has(1);
  @$pb.TagNumber(2)
  void clearAgentSocket() => clearField(2);
}

class EnableSshConfigRequest extends $pb.GeneratedMessage {
  factory EnableSshConfigRequest() => create();
  EnableSshConfigRequest._() : super();
  factory EnableSshConfigRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory EnableSshConfigRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'EnableSshConfigRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  EnableSshConfigRequest clone() => EnableSshConfigRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  EnableSshConfigRequest copyWith(void Function(EnableSshConfigRequest) updates) => super.copyWith((message) => updates(message as EnableSshConfigRequest)) as EnableSshConfigRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EnableSshConfigRequest create() => EnableSshConfigRequest._();
  EnableSshConfigRequest createEmptyInstance() => create();
  static $pb.PbList<EnableSshConfigRequest> createRepeated() => $pb.PbList<EnableSshConfigRequest>();
  @$core.pragma('dart2js:noInline')
  static EnableSshConfigRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EnableSshConfigRequest>(create);
  static EnableSshConfigRequest? _defaultInstance;
}

class EnableSshConfigResponse extends $pb.GeneratedMessage {
  factory EnableSshConfigResponse({
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
  EnableSshConfigResponse._() : super();
  factory EnableSshConfigResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory EnableSshConfigResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'EnableSshConfigResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  EnableSshConfigResponse clone() => EnableSshConfigResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  EnableSshConfigResponse copyWith(void Function(EnableSshConfigResponse) updates) => super.copyWith((message) => updates(message as EnableSshConfigResponse)) as EnableSshConfigResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EnableSshConfigResponse create() => EnableSshConfigResponse._();
  EnableSshConfigResponse createEmptyInstance() => create();
  static $pb.PbList<EnableSshConfigResponse> createRepeated() => $pb.PbList<EnableSshConfigResponse>();
  @$core.pragma('dart2js:noInline')
  static EnableSshConfigResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EnableSshConfigResponse>(create);
  static EnableSshConfigResponse? _defaultInstance;

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

class DisableSshConfigRequest extends $pb.GeneratedMessage {
  factory DisableSshConfigRequest() => create();
  DisableSshConfigRequest._() : super();
  factory DisableSshConfigRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DisableSshConfigRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DisableSshConfigRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DisableSshConfigRequest clone() => DisableSshConfigRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DisableSshConfigRequest copyWith(void Function(DisableSshConfigRequest) updates) => super.copyWith((message) => updates(message as DisableSshConfigRequest)) as DisableSshConfigRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DisableSshConfigRequest create() => DisableSshConfigRequest._();
  DisableSshConfigRequest createEmptyInstance() => create();
  static $pb.PbList<DisableSshConfigRequest> createRepeated() => $pb.PbList<DisableSshConfigRequest>();
  @$core.pragma('dart2js:noInline')
  static DisableSshConfigRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DisableSshConfigRequest>(create);
  static DisableSshConfigRequest? _defaultInstance;
}

class DisableSshConfigResponse extends $pb.GeneratedMessage {
  factory DisableSshConfigResponse({
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
  DisableSshConfigResponse._() : super();
  factory DisableSshConfigResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DisableSshConfigResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DisableSshConfigResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DisableSshConfigResponse clone() => DisableSshConfigResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DisableSshConfigResponse copyWith(void Function(DisableSshConfigResponse) updates) => super.copyWith((message) => updates(message as DisableSshConfigResponse)) as DisableSshConfigResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DisableSshConfigResponse create() => DisableSshConfigResponse._();
  DisableSshConfigResponse createEmptyInstance() => create();
  static $pb.PbList<DisableSshConfigResponse> createRepeated() => $pb.PbList<DisableSshConfigResponse>();
  @$core.pragma('dart2js:noInline')
  static DisableSshConfigResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DisableSshConfigResponse>(create);
  static DisableSshConfigResponse? _defaultInstance;

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


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
