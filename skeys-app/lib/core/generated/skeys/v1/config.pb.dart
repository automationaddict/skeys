// This is a generated file - do not edit.
//
// Generated from skeys/v1/config.proto.

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
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? extraOptions,
    $core.bool? isPattern,
    $core.int? lineNumber,
  }) {
    final result = create();
    if (alias != null) result.alias = alias;
    if (hostname != null) result.hostname = hostname;
    if (user != null) result.user = user;
    if (port != null) result.port = port;
    if (identityFiles != null) result.identityFiles.addAll(identityFiles);
    if (proxyJump != null) result.proxyJump = proxyJump;
    if (proxyCommand != null) result.proxyCommand = proxyCommand;
    if (forwardAgent != null) result.forwardAgent = forwardAgent;
    if (identitiesOnly != null) result.identitiesOnly = identitiesOnly;
    if (strictHostKeyChecking != null)
      result.strictHostKeyChecking = strictHostKeyChecking;
    if (serverAliveInterval != null)
      result.serverAliveInterval = serverAliveInterval;
    if (serverAliveCountMax != null)
      result.serverAliveCountMax = serverAliveCountMax;
    if (extraOptions != null) result.extraOptions.addEntries(extraOptions);
    if (isPattern != null) result.isPattern = isPattern;
    if (lineNumber != null) result.lineNumber = lineNumber;
    return result;
  }

  HostConfig._();

  factory HostConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory HostConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HostConfig',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'alias')
    ..aOS(2, _omitFieldNames ? '' : 'hostname')
    ..aOS(3, _omitFieldNames ? '' : 'user')
    ..aI(4, _omitFieldNames ? '' : 'port')
    ..pPS(5, _omitFieldNames ? '' : 'identityFiles')
    ..aOS(6, _omitFieldNames ? '' : 'proxyJump')
    ..aOS(7, _omitFieldNames ? '' : 'proxyCommand')
    ..aOB(8, _omitFieldNames ? '' : 'forwardAgent')
    ..aOB(9, _omitFieldNames ? '' : 'identitiesOnly')
    ..aOS(10, _omitFieldNames ? '' : 'strictHostKeyChecking')
    ..aI(11, _omitFieldNames ? '' : 'serverAliveInterval')
    ..aI(12, _omitFieldNames ? '' : 'serverAliveCountMax')
    ..m<$core.String, $core.String>(13, _omitFieldNames ? '' : 'extraOptions',
        entryClassName: 'HostConfig.ExtraOptionsEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('skeys.v1'))
    ..aOB(14, _omitFieldNames ? '' : 'isPattern')
    ..aI(15, _omitFieldNames ? '' : 'lineNumber')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HostConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HostConfig copyWith(void Function(HostConfig) updates) =>
      super.copyWith((message) => updates(message as HostConfig)) as HostConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HostConfig create() => HostConfig._();
  @$core.override
  HostConfig createEmptyInstance() => create();
  static $pb.PbList<HostConfig> createRepeated() => $pb.PbList<HostConfig>();
  @$core.pragma('dart2js:noInline')
  static HostConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HostConfig>(create);
  static HostConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get alias => $_getSZ(0);
  @$pb.TagNumber(1)
  set alias($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAlias() => $_has(0);
  @$pb.TagNumber(1)
  void clearAlias() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get hostname => $_getSZ(1);
  @$pb.TagNumber(2)
  set hostname($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasHostname() => $_has(1);
  @$pb.TagNumber(2)
  void clearHostname() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get user => $_getSZ(2);
  @$pb.TagNumber(3)
  set user($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUser() => $_has(2);
  @$pb.TagNumber(3)
  void clearUser() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get port => $_getIZ(3);
  @$pb.TagNumber(4)
  set port($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPort() => $_has(3);
  @$pb.TagNumber(4)
  void clearPort() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<$core.String> get identityFiles => $_getList(4);

  @$pb.TagNumber(6)
  $core.String get proxyJump => $_getSZ(5);
  @$pb.TagNumber(6)
  set proxyJump($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasProxyJump() => $_has(5);
  @$pb.TagNumber(6)
  void clearProxyJump() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get proxyCommand => $_getSZ(6);
  @$pb.TagNumber(7)
  set proxyCommand($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasProxyCommand() => $_has(6);
  @$pb.TagNumber(7)
  void clearProxyCommand() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get forwardAgent => $_getBF(7);
  @$pb.TagNumber(8)
  set forwardAgent($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasForwardAgent() => $_has(7);
  @$pb.TagNumber(8)
  void clearForwardAgent() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get identitiesOnly => $_getBF(8);
  @$pb.TagNumber(9)
  set identitiesOnly($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasIdentitiesOnly() => $_has(8);
  @$pb.TagNumber(9)
  void clearIdentitiesOnly() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get strictHostKeyChecking => $_getSZ(9);
  @$pb.TagNumber(10)
  set strictHostKeyChecking($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasStrictHostKeyChecking() => $_has(9);
  @$pb.TagNumber(10)
  void clearStrictHostKeyChecking() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.int get serverAliveInterval => $_getIZ(10);
  @$pb.TagNumber(11)
  set serverAliveInterval($core.int value) => $_setSignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasServerAliveInterval() => $_has(10);
  @$pb.TagNumber(11)
  void clearServerAliveInterval() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.int get serverAliveCountMax => $_getIZ(11);
  @$pb.TagNumber(12)
  set serverAliveCountMax($core.int value) => $_setSignedInt32(11, value);
  @$pb.TagNumber(12)
  $core.bool hasServerAliveCountMax() => $_has(11);
  @$pb.TagNumber(12)
  void clearServerAliveCountMax() => $_clearField(12);

  @$pb.TagNumber(13)
  $pb.PbMap<$core.String, $core.String> get extraOptions => $_getMap(12);

  @$pb.TagNumber(14)
  $core.bool get isPattern => $_getBF(13);
  @$pb.TagNumber(14)
  set isPattern($core.bool value) => $_setBool(13, value);
  @$pb.TagNumber(14)
  $core.bool hasIsPattern() => $_has(13);
  @$pb.TagNumber(14)
  void clearIsPattern() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.int get lineNumber => $_getIZ(14);
  @$pb.TagNumber(15)
  set lineNumber($core.int value) => $_setSignedInt32(14, value);
  @$pb.TagNumber(15)
  $core.bool hasLineNumber() => $_has(14);
  @$pb.TagNumber(15)
  void clearLineNumber() => $_clearField(15);
}

class ListHostConfigsRequest extends $pb.GeneratedMessage {
  factory ListHostConfigsRequest({
    $2.Target? target,
  }) {
    final result = create();
    if (target != null) result.target = target;
    return result;
  }

  ListHostConfigsRequest._();

  factory ListHostConfigsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListHostConfigsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListHostConfigsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOM<$2.Target>(1, _omitFieldNames ? '' : 'target',
        subBuilder: $2.Target.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListHostConfigsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListHostConfigsRequest copyWith(
          void Function(ListHostConfigsRequest) updates) =>
      super.copyWith((message) => updates(message as ListHostConfigsRequest))
          as ListHostConfigsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListHostConfigsRequest create() => ListHostConfigsRequest._();
  @$core.override
  ListHostConfigsRequest createEmptyInstance() => create();
  static $pb.PbList<ListHostConfigsRequest> createRepeated() =>
      $pb.PbList<ListHostConfigsRequest>();
  @$core.pragma('dart2js:noInline')
  static ListHostConfigsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListHostConfigsRequest>(create);
  static ListHostConfigsRequest? _defaultInstance;

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

class ListHostConfigsResponse extends $pb.GeneratedMessage {
  factory ListHostConfigsResponse({
    $core.Iterable<HostConfig>? hosts,
  }) {
    final result = create();
    if (hosts != null) result.hosts.addAll(hosts);
    return result;
  }

  ListHostConfigsResponse._();

  factory ListHostConfigsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListHostConfigsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListHostConfigsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..pPM<HostConfig>(1, _omitFieldNames ? '' : 'hosts',
        subBuilder: HostConfig.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListHostConfigsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListHostConfigsResponse copyWith(
          void Function(ListHostConfigsResponse) updates) =>
      super.copyWith((message) => updates(message as ListHostConfigsResponse))
          as ListHostConfigsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListHostConfigsResponse create() => ListHostConfigsResponse._();
  @$core.override
  ListHostConfigsResponse createEmptyInstance() => create();
  static $pb.PbList<ListHostConfigsResponse> createRepeated() =>
      $pb.PbList<ListHostConfigsResponse>();
  @$core.pragma('dart2js:noInline')
  static ListHostConfigsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListHostConfigsResponse>(create);
  static ListHostConfigsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<HostConfig> get hosts => $_getList(0);
}

class GetHostConfigRequest extends $pb.GeneratedMessage {
  factory GetHostConfigRequest({
    $2.Target? target,
    $core.String? alias,
  }) {
    final result = create();
    if (target != null) result.target = target;
    if (alias != null) result.alias = alias;
    return result;
  }

  GetHostConfigRequest._();

  factory GetHostConfigRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetHostConfigRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetHostConfigRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOM<$2.Target>(1, _omitFieldNames ? '' : 'target',
        subBuilder: $2.Target.create)
    ..aOS(2, _omitFieldNames ? '' : 'alias')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetHostConfigRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetHostConfigRequest copyWith(void Function(GetHostConfigRequest) updates) =>
      super.copyWith((message) => updates(message as GetHostConfigRequest))
          as GetHostConfigRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetHostConfigRequest create() => GetHostConfigRequest._();
  @$core.override
  GetHostConfigRequest createEmptyInstance() => create();
  static $pb.PbList<GetHostConfigRequest> createRepeated() =>
      $pb.PbList<GetHostConfigRequest>();
  @$core.pragma('dart2js:noInline')
  static GetHostConfigRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetHostConfigRequest>(create);
  static GetHostConfigRequest? _defaultInstance;

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
  $core.String get alias => $_getSZ(1);
  @$pb.TagNumber(2)
  set alias($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAlias() => $_has(1);
  @$pb.TagNumber(2)
  void clearAlias() => $_clearField(2);
}

class CreateHostConfigRequest extends $pb.GeneratedMessage {
  factory CreateHostConfigRequest({
    $2.Target? target,
    HostConfig? config,
  }) {
    final result = create();
    if (target != null) result.target = target;
    if (config != null) result.config = config;
    return result;
  }

  CreateHostConfigRequest._();

  factory CreateHostConfigRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateHostConfigRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateHostConfigRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOM<$2.Target>(1, _omitFieldNames ? '' : 'target',
        subBuilder: $2.Target.create)
    ..aOM<HostConfig>(2, _omitFieldNames ? '' : 'config',
        subBuilder: HostConfig.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateHostConfigRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateHostConfigRequest copyWith(
          void Function(CreateHostConfigRequest) updates) =>
      super.copyWith((message) => updates(message as CreateHostConfigRequest))
          as CreateHostConfigRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateHostConfigRequest create() => CreateHostConfigRequest._();
  @$core.override
  CreateHostConfigRequest createEmptyInstance() => create();
  static $pb.PbList<CreateHostConfigRequest> createRepeated() =>
      $pb.PbList<CreateHostConfigRequest>();
  @$core.pragma('dart2js:noInline')
  static CreateHostConfigRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateHostConfigRequest>(create);
  static CreateHostConfigRequest? _defaultInstance;

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
  HostConfig get config => $_getN(1);
  @$pb.TagNumber(2)
  set config(HostConfig value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasConfig() => $_has(1);
  @$pb.TagNumber(2)
  void clearConfig() => $_clearField(2);
  @$pb.TagNumber(2)
  HostConfig ensureConfig() => $_ensure(1);
}

class UpdateHostConfigRequest extends $pb.GeneratedMessage {
  factory UpdateHostConfigRequest({
    $2.Target? target,
    $core.String? alias,
    HostConfig? config,
  }) {
    final result = create();
    if (target != null) result.target = target;
    if (alias != null) result.alias = alias;
    if (config != null) result.config = config;
    return result;
  }

  UpdateHostConfigRequest._();

  factory UpdateHostConfigRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateHostConfigRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateHostConfigRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOM<$2.Target>(1, _omitFieldNames ? '' : 'target',
        subBuilder: $2.Target.create)
    ..aOS(2, _omitFieldNames ? '' : 'alias')
    ..aOM<HostConfig>(3, _omitFieldNames ? '' : 'config',
        subBuilder: HostConfig.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateHostConfigRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateHostConfigRequest copyWith(
          void Function(UpdateHostConfigRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateHostConfigRequest))
          as UpdateHostConfigRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateHostConfigRequest create() => UpdateHostConfigRequest._();
  @$core.override
  UpdateHostConfigRequest createEmptyInstance() => create();
  static $pb.PbList<UpdateHostConfigRequest> createRepeated() =>
      $pb.PbList<UpdateHostConfigRequest>();
  @$core.pragma('dart2js:noInline')
  static UpdateHostConfigRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateHostConfigRequest>(create);
  static UpdateHostConfigRequest? _defaultInstance;

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
  $core.String get alias => $_getSZ(1);
  @$pb.TagNumber(2)
  set alias($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAlias() => $_has(1);
  @$pb.TagNumber(2)
  void clearAlias() => $_clearField(2);

  @$pb.TagNumber(3)
  HostConfig get config => $_getN(2);
  @$pb.TagNumber(3)
  set config(HostConfig value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasConfig() => $_has(2);
  @$pb.TagNumber(3)
  void clearConfig() => $_clearField(3);
  @$pb.TagNumber(3)
  HostConfig ensureConfig() => $_ensure(2);
}

class DeleteHostConfigRequest extends $pb.GeneratedMessage {
  factory DeleteHostConfigRequest({
    $2.Target? target,
    $core.String? alias,
  }) {
    final result = create();
    if (target != null) result.target = target;
    if (alias != null) result.alias = alias;
    return result;
  }

  DeleteHostConfigRequest._();

  factory DeleteHostConfigRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteHostConfigRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteHostConfigRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOM<$2.Target>(1, _omitFieldNames ? '' : 'target',
        subBuilder: $2.Target.create)
    ..aOS(2, _omitFieldNames ? '' : 'alias')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteHostConfigRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteHostConfigRequest copyWith(
          void Function(DeleteHostConfigRequest) updates) =>
      super.copyWith((message) => updates(message as DeleteHostConfigRequest))
          as DeleteHostConfigRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteHostConfigRequest create() => DeleteHostConfigRequest._();
  @$core.override
  DeleteHostConfigRequest createEmptyInstance() => create();
  static $pb.PbList<DeleteHostConfigRequest> createRepeated() =>
      $pb.PbList<DeleteHostConfigRequest>();
  @$core.pragma('dart2js:noInline')
  static DeleteHostConfigRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteHostConfigRequest>(create);
  static DeleteHostConfigRequest? _defaultInstance;

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
  $core.String get alias => $_getSZ(1);
  @$pb.TagNumber(2)
  set alias($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAlias() => $_has(1);
  @$pb.TagNumber(2)
  void clearAlias() => $_clearField(2);
}

class TestConnectionRequest extends $pb.GeneratedMessage {
  factory TestConnectionRequest({
    $2.Target? target,
    $core.String? alias,
    $core.int? timeoutSeconds,
  }) {
    final result = create();
    if (target != null) result.target = target;
    if (alias != null) result.alias = alias;
    if (timeoutSeconds != null) result.timeoutSeconds = timeoutSeconds;
    return result;
  }

  TestConnectionRequest._();

  factory TestConnectionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TestConnectionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TestConnectionRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOM<$2.Target>(1, _omitFieldNames ? '' : 'target',
        subBuilder: $2.Target.create)
    ..aOS(2, _omitFieldNames ? '' : 'alias')
    ..aI(3, _omitFieldNames ? '' : 'timeoutSeconds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TestConnectionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TestConnectionRequest copyWith(
          void Function(TestConnectionRequest) updates) =>
      super.copyWith((message) => updates(message as TestConnectionRequest))
          as TestConnectionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TestConnectionRequest create() => TestConnectionRequest._();
  @$core.override
  TestConnectionRequest createEmptyInstance() => create();
  static $pb.PbList<TestConnectionRequest> createRepeated() =>
      $pb.PbList<TestConnectionRequest>();
  @$core.pragma('dart2js:noInline')
  static TestConnectionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TestConnectionRequest>(create);
  static TestConnectionRequest? _defaultInstance;

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
  $core.String get alias => $_getSZ(1);
  @$pb.TagNumber(2)
  set alias($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAlias() => $_has(1);
  @$pb.TagNumber(2)
  void clearAlias() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get timeoutSeconds => $_getIZ(2);
  @$pb.TagNumber(3)
  set timeoutSeconds($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTimeoutSeconds() => $_has(2);
  @$pb.TagNumber(3)
  void clearTimeoutSeconds() => $_clearField(3);
}

class TestConnectionResponse extends $pb.GeneratedMessage {
  factory TestConnectionResponse({
    $core.bool? success,
    $core.String? message,
    $core.String? serverVersion,
    $core.int? latencyMs,
  }) {
    final result = create();
    if (success != null) result.success = success;
    if (message != null) result.message = message;
    if (serverVersion != null) result.serverVersion = serverVersion;
    if (latencyMs != null) result.latencyMs = latencyMs;
    return result;
  }

  TestConnectionResponse._();

  factory TestConnectionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TestConnectionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TestConnectionResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..aOS(3, _omitFieldNames ? '' : 'serverVersion')
    ..aI(4, _omitFieldNames ? '' : 'latencyMs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TestConnectionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TestConnectionResponse copyWith(
          void Function(TestConnectionResponse) updates) =>
      super.copyWith((message) => updates(message as TestConnectionResponse))
          as TestConnectionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TestConnectionResponse create() => TestConnectionResponse._();
  @$core.override
  TestConnectionResponse createEmptyInstance() => create();
  static $pb.PbList<TestConnectionResponse> createRepeated() =>
      $pb.PbList<TestConnectionResponse>();
  @$core.pragma('dart2js:noInline')
  static TestConnectionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TestConnectionResponse>(create);
  static TestConnectionResponse? _defaultInstance;

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

  @$pb.TagNumber(3)
  $core.String get serverVersion => $_getSZ(2);
  @$pb.TagNumber(3)
  set serverVersion($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasServerVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearServerVersion() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get latencyMs => $_getIZ(3);
  @$pb.TagNumber(4)
  set latencyMs($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLatencyMs() => $_has(3);
  @$pb.TagNumber(4)
  void clearLatencyMs() => $_clearField(4);
}

class ServerConfig extends $pb.GeneratedMessage {
  factory ServerConfig({
    $core.Iterable<ServerConfigDirective>? directives,
    $core.String? rawContent,
  }) {
    final result = create();
    if (directives != null) result.directives.addAll(directives);
    if (rawContent != null) result.rawContent = rawContent;
    return result;
  }

  ServerConfig._();

  factory ServerConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ServerConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ServerConfig',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..pPM<ServerConfigDirective>(1, _omitFieldNames ? '' : 'directives',
        subBuilder: ServerConfigDirective.create)
    ..aOS(2, _omitFieldNames ? '' : 'rawContent')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServerConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServerConfig copyWith(void Function(ServerConfig) updates) =>
      super.copyWith((message) => updates(message as ServerConfig))
          as ServerConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServerConfig create() => ServerConfig._();
  @$core.override
  ServerConfig createEmptyInstance() => create();
  static $pb.PbList<ServerConfig> createRepeated() =>
      $pb.PbList<ServerConfig>();
  @$core.pragma('dart2js:noInline')
  static ServerConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ServerConfig>(create);
  static ServerConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ServerConfigDirective> get directives => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get rawContent => $_getSZ(1);
  @$pb.TagNumber(2)
  set rawContent($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRawContent() => $_has(1);
  @$pb.TagNumber(2)
  void clearRawContent() => $_clearField(2);
}

class ServerConfigDirective extends $pb.GeneratedMessage {
  factory ServerConfigDirective({
    $core.String? key,
    $core.String? value,
    $core.int? lineNumber,
    $core.bool? isCommented,
    $core.String? matchBlock,
  }) {
    final result = create();
    if (key != null) result.key = key;
    if (value != null) result.value = value;
    if (lineNumber != null) result.lineNumber = lineNumber;
    if (isCommented != null) result.isCommented = isCommented;
    if (matchBlock != null) result.matchBlock = matchBlock;
    return result;
  }

  ServerConfigDirective._();

  factory ServerConfigDirective.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ServerConfigDirective.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ServerConfigDirective',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'key')
    ..aOS(2, _omitFieldNames ? '' : 'value')
    ..aI(3, _omitFieldNames ? '' : 'lineNumber')
    ..aOB(4, _omitFieldNames ? '' : 'isCommented')
    ..aOS(5, _omitFieldNames ? '' : 'matchBlock')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServerConfigDirective clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServerConfigDirective copyWith(
          void Function(ServerConfigDirective) updates) =>
      super.copyWith((message) => updates(message as ServerConfigDirective))
          as ServerConfigDirective;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServerConfigDirective create() => ServerConfigDirective._();
  @$core.override
  ServerConfigDirective createEmptyInstance() => create();
  static $pb.PbList<ServerConfigDirective> createRepeated() =>
      $pb.PbList<ServerConfigDirective>();
  @$core.pragma('dart2js:noInline')
  static ServerConfigDirective getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ServerConfigDirective>(create);
  static ServerConfigDirective? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get key => $_getSZ(0);
  @$pb.TagNumber(1)
  set key($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearKey() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get value => $_getSZ(1);
  @$pb.TagNumber(2)
  set value($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearValue() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get lineNumber => $_getIZ(2);
  @$pb.TagNumber(3)
  set lineNumber($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLineNumber() => $_has(2);
  @$pb.TagNumber(3)
  void clearLineNumber() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get isCommented => $_getBF(3);
  @$pb.TagNumber(4)
  set isCommented($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIsCommented() => $_has(3);
  @$pb.TagNumber(4)
  void clearIsCommented() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get matchBlock => $_getSZ(4);
  @$pb.TagNumber(5)
  set matchBlock($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMatchBlock() => $_has(4);
  @$pb.TagNumber(5)
  void clearMatchBlock() => $_clearField(5);
}

class GetServerConfigRequest extends $pb.GeneratedMessage {
  factory GetServerConfigRequest({
    $2.Target? target,
  }) {
    final result = create();
    if (target != null) result.target = target;
    return result;
  }

  GetServerConfigRequest._();

  factory GetServerConfigRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetServerConfigRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetServerConfigRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOM<$2.Target>(1, _omitFieldNames ? '' : 'target',
        subBuilder: $2.Target.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetServerConfigRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetServerConfigRequest copyWith(
          void Function(GetServerConfigRequest) updates) =>
      super.copyWith((message) => updates(message as GetServerConfigRequest))
          as GetServerConfigRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetServerConfigRequest create() => GetServerConfigRequest._();
  @$core.override
  GetServerConfigRequest createEmptyInstance() => create();
  static $pb.PbList<GetServerConfigRequest> createRepeated() =>
      $pb.PbList<GetServerConfigRequest>();
  @$core.pragma('dart2js:noInline')
  static GetServerConfigRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetServerConfigRequest>(create);
  static GetServerConfigRequest? _defaultInstance;

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

class UpdateServerConfigRequest extends $pb.GeneratedMessage {
  factory UpdateServerConfigRequest({
    $2.Target? target,
    $core.Iterable<ServerConfigUpdate>? updates,
  }) {
    final result = create();
    if (target != null) result.target = target;
    if (updates != null) result.updates.addAll(updates);
    return result;
  }

  UpdateServerConfigRequest._();

  factory UpdateServerConfigRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateServerConfigRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateServerConfigRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOM<$2.Target>(1, _omitFieldNames ? '' : 'target',
        subBuilder: $2.Target.create)
    ..pPM<ServerConfigUpdate>(2, _omitFieldNames ? '' : 'updates',
        subBuilder: ServerConfigUpdate.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateServerConfigRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateServerConfigRequest copyWith(
          void Function(UpdateServerConfigRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateServerConfigRequest))
          as UpdateServerConfigRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateServerConfigRequest create() => UpdateServerConfigRequest._();
  @$core.override
  UpdateServerConfigRequest createEmptyInstance() => create();
  static $pb.PbList<UpdateServerConfigRequest> createRepeated() =>
      $pb.PbList<UpdateServerConfigRequest>();
  @$core.pragma('dart2js:noInline')
  static UpdateServerConfigRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateServerConfigRequest>(create);
  static UpdateServerConfigRequest? _defaultInstance;

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
  $pb.PbList<ServerConfigUpdate> get updates => $_getList(1);
}

class ServerConfigUpdate extends $pb.GeneratedMessage {
  factory ServerConfigUpdate({
    $core.String? key,
    $core.String? value,
    $core.bool? delete,
  }) {
    final result = create();
    if (key != null) result.key = key;
    if (value != null) result.value = value;
    if (delete != null) result.delete = delete;
    return result;
  }

  ServerConfigUpdate._();

  factory ServerConfigUpdate.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ServerConfigUpdate.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ServerConfigUpdate',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'key')
    ..aOS(2, _omitFieldNames ? '' : 'value')
    ..aOB(3, _omitFieldNames ? '' : 'delete')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServerConfigUpdate clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServerConfigUpdate copyWith(void Function(ServerConfigUpdate) updates) =>
      super.copyWith((message) => updates(message as ServerConfigUpdate))
          as ServerConfigUpdate;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServerConfigUpdate create() => ServerConfigUpdate._();
  @$core.override
  ServerConfigUpdate createEmptyInstance() => create();
  static $pb.PbList<ServerConfigUpdate> createRepeated() =>
      $pb.PbList<ServerConfigUpdate>();
  @$core.pragma('dart2js:noInline')
  static ServerConfigUpdate getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ServerConfigUpdate>(create);
  static ServerConfigUpdate? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get key => $_getSZ(0);
  @$pb.TagNumber(1)
  set key($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearKey() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get value => $_getSZ(1);
  @$pb.TagNumber(2)
  set value($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearValue() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get delete => $_getBF(2);
  @$pb.TagNumber(3)
  set delete($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDelete() => $_has(2);
  @$pb.TagNumber(3)
  void clearDelete() => $_clearField(3);
}

class ValidateServerConfigRequest extends $pb.GeneratedMessage {
  factory ValidateServerConfigRequest({
    $2.Target? target,
    $core.String? content,
  }) {
    final result = create();
    if (target != null) result.target = target;
    if (content != null) result.content = content;
    return result;
  }

  ValidateServerConfigRequest._();

  factory ValidateServerConfigRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ValidateServerConfigRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ValidateServerConfigRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOM<$2.Target>(1, _omitFieldNames ? '' : 'target',
        subBuilder: $2.Target.create)
    ..aOS(2, _omitFieldNames ? '' : 'content')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ValidateServerConfigRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ValidateServerConfigRequest copyWith(
          void Function(ValidateServerConfigRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ValidateServerConfigRequest))
          as ValidateServerConfigRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ValidateServerConfigRequest create() =>
      ValidateServerConfigRequest._();
  @$core.override
  ValidateServerConfigRequest createEmptyInstance() => create();
  static $pb.PbList<ValidateServerConfigRequest> createRepeated() =>
      $pb.PbList<ValidateServerConfigRequest>();
  @$core.pragma('dart2js:noInline')
  static ValidateServerConfigRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ValidateServerConfigRequest>(create);
  static ValidateServerConfigRequest? _defaultInstance;

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
  $core.String get content => $_getSZ(1);
  @$pb.TagNumber(2)
  set content($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasContent() => $_has(1);
  @$pb.TagNumber(2)
  void clearContent() => $_clearField(2);
}

class ValidateServerConfigResponse extends $pb.GeneratedMessage {
  factory ValidateServerConfigResponse({
    $core.bool? valid,
    $core.String? errorMessage,
  }) {
    final result = create();
    if (valid != null) result.valid = valid;
    if (errorMessage != null) result.errorMessage = errorMessage;
    return result;
  }

  ValidateServerConfigResponse._();

  factory ValidateServerConfigResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ValidateServerConfigResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ValidateServerConfigResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'valid')
    ..aOS(2, _omitFieldNames ? '' : 'errorMessage')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ValidateServerConfigResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ValidateServerConfigResponse copyWith(
          void Function(ValidateServerConfigResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ValidateServerConfigResponse))
          as ValidateServerConfigResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ValidateServerConfigResponse create() =>
      ValidateServerConfigResponse._();
  @$core.override
  ValidateServerConfigResponse createEmptyInstance() => create();
  static $pb.PbList<ValidateServerConfigResponse> createRepeated() =>
      $pb.PbList<ValidateServerConfigResponse>();
  @$core.pragma('dart2js:noInline')
  static ValidateServerConfigResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ValidateServerConfigResponse>(create);
  static ValidateServerConfigResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get valid => $_getBF(0);
  @$pb.TagNumber(1)
  set valid($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasValid() => $_has(0);
  @$pb.TagNumber(1)
  void clearValid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get errorMessage => $_getSZ(1);
  @$pb.TagNumber(2)
  set errorMessage($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasErrorMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearErrorMessage() => $_clearField(2);
}

class RestartSSHServiceRequest extends $pb.GeneratedMessage {
  factory RestartSSHServiceRequest({
    $2.Target? target,
    $core.bool? reloadOnly,
  }) {
    final result = create();
    if (target != null) result.target = target;
    if (reloadOnly != null) result.reloadOnly = reloadOnly;
    return result;
  }

  RestartSSHServiceRequest._();

  factory RestartSSHServiceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RestartSSHServiceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RestartSSHServiceRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOM<$2.Target>(1, _omitFieldNames ? '' : 'target',
        subBuilder: $2.Target.create)
    ..aOB(2, _omitFieldNames ? '' : 'reloadOnly')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RestartSSHServiceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RestartSSHServiceRequest copyWith(
          void Function(RestartSSHServiceRequest) updates) =>
      super.copyWith((message) => updates(message as RestartSSHServiceRequest))
          as RestartSSHServiceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RestartSSHServiceRequest create() => RestartSSHServiceRequest._();
  @$core.override
  RestartSSHServiceRequest createEmptyInstance() => create();
  static $pb.PbList<RestartSSHServiceRequest> createRepeated() =>
      $pb.PbList<RestartSSHServiceRequest>();
  @$core.pragma('dart2js:noInline')
  static RestartSSHServiceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RestartSSHServiceRequest>(create);
  static RestartSSHServiceRequest? _defaultInstance;

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
  $core.bool get reloadOnly => $_getBF(1);
  @$pb.TagNumber(2)
  set reloadOnly($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReloadOnly() => $_has(1);
  @$pb.TagNumber(2)
  void clearReloadOnly() => $_clearField(2);
}

class RestartSSHServiceResponse extends $pb.GeneratedMessage {
  factory RestartSSHServiceResponse({
    $core.bool? success,
    $core.String? message,
  }) {
    final result = create();
    if (success != null) result.success = success;
    if (message != null) result.message = message;
    return result;
  }

  RestartSSHServiceResponse._();

  factory RestartSSHServiceResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RestartSSHServiceResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RestartSSHServiceResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RestartSSHServiceResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RestartSSHServiceResponse copyWith(
          void Function(RestartSSHServiceResponse) updates) =>
      super.copyWith((message) => updates(message as RestartSSHServiceResponse))
          as RestartSSHServiceResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RestartSSHServiceResponse create() => RestartSSHServiceResponse._();
  @$core.override
  RestartSSHServiceResponse createEmptyInstance() => create();
  static $pb.PbList<RestartSSHServiceResponse> createRepeated() =>
      $pb.PbList<RestartSSHServiceResponse>();
  @$core.pragma('dart2js:noInline')
  static RestartSSHServiceResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RestartSSHServiceResponse>(create);
  static RestartSSHServiceResponse? _defaultInstance;

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

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
