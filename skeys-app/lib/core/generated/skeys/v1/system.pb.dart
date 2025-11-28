// This is a generated file - do not edit.
//
// Generated from skeys/v1/system.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'common.pb.dart' as $1;
import 'config.pb.dart' as $2;
import 'system.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'system.pbenum.dart';

class GetSSHStatusRequest extends $pb.GeneratedMessage {
  factory GetSSHStatusRequest({
    $1.Target? target,
  }) {
    final result = create();
    if (target != null) result.target = target;
    return result;
  }

  GetSSHStatusRequest._();

  factory GetSSHStatusRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetSSHStatusRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetSSHStatusRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOM<$1.Target>(1, _omitFieldNames ? '' : 'target',
        subBuilder: $1.Target.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSSHStatusRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSSHStatusRequest copyWith(void Function(GetSSHStatusRequest) updates) =>
      super.copyWith((message) => updates(message as GetSSHStatusRequest))
          as GetSSHStatusRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetSSHStatusRequest create() => GetSSHStatusRequest._();
  @$core.override
  GetSSHStatusRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetSSHStatusRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetSSHStatusRequest>(create);
  static GetSSHStatusRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.Target get target => $_getN(0);
  @$pb.TagNumber(1)
  set target($1.Target value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTarget() => $_has(0);
  @$pb.TagNumber(1)
  void clearTarget() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.Target ensureTarget() => $_ensure(0);
}

class WatchSSHStatusRequest extends $pb.GeneratedMessage {
  factory WatchSSHStatusRequest({
    $1.Target? target,
  }) {
    final result = create();
    if (target != null) result.target = target;
    return result;
  }

  WatchSSHStatusRequest._();

  factory WatchSSHStatusRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WatchSSHStatusRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WatchSSHStatusRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOM<$1.Target>(1, _omitFieldNames ? '' : 'target',
        subBuilder: $1.Target.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchSSHStatusRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchSSHStatusRequest copyWith(
          void Function(WatchSSHStatusRequest) updates) =>
      super.copyWith((message) => updates(message as WatchSSHStatusRequest))
          as WatchSSHStatusRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WatchSSHStatusRequest create() => WatchSSHStatusRequest._();
  @$core.override
  WatchSSHStatusRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WatchSSHStatusRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WatchSSHStatusRequest>(create);
  static WatchSSHStatusRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.Target get target => $_getN(0);
  @$pb.TagNumber(1)
  set target($1.Target value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTarget() => $_has(0);
  @$pb.TagNumber(1)
  void clearTarget() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.Target ensureTarget() => $_ensure(0);
}

class GetSSHStatusResponse extends $pb.GeneratedMessage {
  factory GetSSHStatusResponse({
    $core.String? distribution,
    $core.String? distributionVersion,
    SSHClientStatus? client,
    SSHServerStatus? server,
  }) {
    final result = create();
    if (distribution != null) result.distribution = distribution;
    if (distributionVersion != null)
      result.distributionVersion = distributionVersion;
    if (client != null) result.client = client;
    if (server != null) result.server = server;
    return result;
  }

  GetSSHStatusResponse._();

  factory GetSSHStatusResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetSSHStatusResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetSSHStatusResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'distribution')
    ..aOS(2, _omitFieldNames ? '' : 'distributionVersion')
    ..aOM<SSHClientStatus>(3, _omitFieldNames ? '' : 'client',
        subBuilder: SSHClientStatus.create)
    ..aOM<SSHServerStatus>(4, _omitFieldNames ? '' : 'server',
        subBuilder: SSHServerStatus.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSSHStatusResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSSHStatusResponse copyWith(void Function(GetSSHStatusResponse) updates) =>
      super.copyWith((message) => updates(message as GetSSHStatusResponse))
          as GetSSHStatusResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetSSHStatusResponse create() => GetSSHStatusResponse._();
  @$core.override
  GetSSHStatusResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetSSHStatusResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetSSHStatusResponse>(create);
  static GetSSHStatusResponse? _defaultInstance;

  /// System info
  @$pb.TagNumber(1)
  $core.String get distribution => $_getSZ(0);
  @$pb.TagNumber(1)
  set distribution($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDistribution() => $_has(0);
  @$pb.TagNumber(1)
  void clearDistribution() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get distributionVersion => $_getSZ(1);
  @$pb.TagNumber(2)
  set distributionVersion($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDistributionVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearDistributionVersion() => $_clearField(2);

  /// SSH Client status
  @$pb.TagNumber(3)
  SSHClientStatus get client => $_getN(2);
  @$pb.TagNumber(3)
  set client(SSHClientStatus value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasClient() => $_has(2);
  @$pb.TagNumber(3)
  void clearClient() => $_clearField(3);
  @$pb.TagNumber(3)
  SSHClientStatus ensureClient() => $_ensure(2);

  /// SSH Server status
  @$pb.TagNumber(4)
  SSHServerStatus get server => $_getN(3);
  @$pb.TagNumber(4)
  set server(SSHServerStatus value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasServer() => $_has(3);
  @$pb.TagNumber(4)
  void clearServer() => $_clearField(4);
  @$pb.TagNumber(4)
  SSHServerStatus ensureServer() => $_ensure(3);
}

class SSHClientStatus extends $pb.GeneratedMessage {
  factory SSHClientStatus({
    $core.bool? installed,
    $core.String? version,
    $core.String? binaryPath,
    $2.ConfigPathInfo? systemConfig,
    $2.ConfigPathInfo? userConfig,
  }) {
    final result = create();
    if (installed != null) result.installed = installed;
    if (version != null) result.version = version;
    if (binaryPath != null) result.binaryPath = binaryPath;
    if (systemConfig != null) result.systemConfig = systemConfig;
    if (userConfig != null) result.userConfig = userConfig;
    return result;
  }

  SSHClientStatus._();

  factory SSHClientStatus.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SSHClientStatus.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SSHClientStatus',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'installed')
    ..aOS(2, _omitFieldNames ? '' : 'version')
    ..aOS(3, _omitFieldNames ? '' : 'binaryPath')
    ..aOM<$2.ConfigPathInfo>(4, _omitFieldNames ? '' : 'systemConfig',
        subBuilder: $2.ConfigPathInfo.create)
    ..aOM<$2.ConfigPathInfo>(5, _omitFieldNames ? '' : 'userConfig',
        subBuilder: $2.ConfigPathInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SSHClientStatus clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SSHClientStatus copyWith(void Function(SSHClientStatus) updates) =>
      super.copyWith((message) => updates(message as SSHClientStatus))
          as SSHClientStatus;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SSHClientStatus create() => SSHClientStatus._();
  @$core.override
  SSHClientStatus createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SSHClientStatus getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SSHClientStatus>(create);
  static SSHClientStatus? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get installed => $_getBF(0);
  @$pb.TagNumber(1)
  set installed($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasInstalled() => $_has(0);
  @$pb.TagNumber(1)
  void clearInstalled() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get version => $_getSZ(1);
  @$pb.TagNumber(2)
  set version($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearVersion() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get binaryPath => $_getSZ(2);
  @$pb.TagNumber(3)
  set binaryPath($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBinaryPath() => $_has(2);
  @$pb.TagNumber(3)
  void clearBinaryPath() => $_clearField(3);

  @$pb.TagNumber(4)
  $2.ConfigPathInfo get systemConfig => $_getN(3);
  @$pb.TagNumber(4)
  set systemConfig($2.ConfigPathInfo value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasSystemConfig() => $_has(3);
  @$pb.TagNumber(4)
  void clearSystemConfig() => $_clearField(4);
  @$pb.TagNumber(4)
  $2.ConfigPathInfo ensureSystemConfig() => $_ensure(3);

  @$pb.TagNumber(5)
  $2.ConfigPathInfo get userConfig => $_getN(4);
  @$pb.TagNumber(5)
  set userConfig($2.ConfigPathInfo value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasUserConfig() => $_has(4);
  @$pb.TagNumber(5)
  void clearUserConfig() => $_clearField(5);
  @$pb.TagNumber(5)
  $2.ConfigPathInfo ensureUserConfig() => $_ensure(4);
}

class SSHServerStatus extends $pb.GeneratedMessage {
  factory SSHServerStatus({
    $core.bool? installed,
    $core.String? version,
    $core.String? binaryPath,
    ServiceStatus? service,
    $2.ConfigPathInfo? config,
  }) {
    final result = create();
    if (installed != null) result.installed = installed;
    if (version != null) result.version = version;
    if (binaryPath != null) result.binaryPath = binaryPath;
    if (service != null) result.service = service;
    if (config != null) result.config = config;
    return result;
  }

  SSHServerStatus._();

  factory SSHServerStatus.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SSHServerStatus.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SSHServerStatus',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'installed')
    ..aOS(2, _omitFieldNames ? '' : 'version')
    ..aOS(3, _omitFieldNames ? '' : 'binaryPath')
    ..aOM<ServiceStatus>(4, _omitFieldNames ? '' : 'service',
        subBuilder: ServiceStatus.create)
    ..aOM<$2.ConfigPathInfo>(5, _omitFieldNames ? '' : 'config',
        subBuilder: $2.ConfigPathInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SSHServerStatus clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SSHServerStatus copyWith(void Function(SSHServerStatus) updates) =>
      super.copyWith((message) => updates(message as SSHServerStatus))
          as SSHServerStatus;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SSHServerStatus create() => SSHServerStatus._();
  @$core.override
  SSHServerStatus createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SSHServerStatus getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SSHServerStatus>(create);
  static SSHServerStatus? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get installed => $_getBF(0);
  @$pb.TagNumber(1)
  set installed($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasInstalled() => $_has(0);
  @$pb.TagNumber(1)
  void clearInstalled() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get version => $_getSZ(1);
  @$pb.TagNumber(2)
  set version($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearVersion() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get binaryPath => $_getSZ(2);
  @$pb.TagNumber(3)
  set binaryPath($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBinaryPath() => $_has(2);
  @$pb.TagNumber(3)
  void clearBinaryPath() => $_clearField(3);

  @$pb.TagNumber(4)
  ServiceStatus get service => $_getN(3);
  @$pb.TagNumber(4)
  set service(ServiceStatus value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasService() => $_has(3);
  @$pb.TagNumber(4)
  void clearService() => $_clearField(4);
  @$pb.TagNumber(4)
  ServiceStatus ensureService() => $_ensure(3);

  @$pb.TagNumber(5)
  $2.ConfigPathInfo get config => $_getN(4);
  @$pb.TagNumber(5)
  set config($2.ConfigPathInfo value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasConfig() => $_has(4);
  @$pb.TagNumber(5)
  void clearConfig() => $_clearField(5);
  @$pb.TagNumber(5)
  $2.ConfigPathInfo ensureConfig() => $_ensure(4);
}

class ServiceStatus extends $pb.GeneratedMessage {
  factory ServiceStatus({
    ServiceState? state,
    $core.bool? enabled,
    $core.String? activeState,
    $core.String? subState,
    $core.String? loadState,
    $fixnum.Int64? pid,
    $core.String? startedAt,
    $core.String? serviceName,
  }) {
    final result = create();
    if (state != null) result.state = state;
    if (enabled != null) result.enabled = enabled;
    if (activeState != null) result.activeState = activeState;
    if (subState != null) result.subState = subState;
    if (loadState != null) result.loadState = loadState;
    if (pid != null) result.pid = pid;
    if (startedAt != null) result.startedAt = startedAt;
    if (serviceName != null) result.serviceName = serviceName;
    return result;
  }

  ServiceStatus._();

  factory ServiceStatus.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ServiceStatus.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ServiceStatus',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aE<ServiceState>(1, _omitFieldNames ? '' : 'state',
        enumValues: ServiceState.values)
    ..aOB(2, _omitFieldNames ? '' : 'enabled')
    ..aOS(3, _omitFieldNames ? '' : 'activeState')
    ..aOS(4, _omitFieldNames ? '' : 'subState')
    ..aOS(5, _omitFieldNames ? '' : 'loadState')
    ..aInt64(6, _omitFieldNames ? '' : 'pid')
    ..aOS(7, _omitFieldNames ? '' : 'startedAt')
    ..aOS(8, _omitFieldNames ? '' : 'serviceName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServiceStatus clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServiceStatus copyWith(void Function(ServiceStatus) updates) =>
      super.copyWith((message) => updates(message as ServiceStatus))
          as ServiceStatus;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServiceStatus create() => ServiceStatus._();
  @$core.override
  ServiceStatus createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ServiceStatus getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ServiceStatus>(create);
  static ServiceStatus? _defaultInstance;

  @$pb.TagNumber(1)
  ServiceState get state => $_getN(0);
  @$pb.TagNumber(1)
  set state(ServiceState value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get enabled => $_getBF(1);
  @$pb.TagNumber(2)
  set enabled($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEnabled() => $_has(1);
  @$pb.TagNumber(2)
  void clearEnabled() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get activeState => $_getSZ(2);
  @$pb.TagNumber(3)
  set activeState($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasActiveState() => $_has(2);
  @$pb.TagNumber(3)
  void clearActiveState() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get subState => $_getSZ(3);
  @$pb.TagNumber(4)
  set subState($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSubState() => $_has(3);
  @$pb.TagNumber(4)
  void clearSubState() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get loadState => $_getSZ(4);
  @$pb.TagNumber(5)
  set loadState($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasLoadState() => $_has(4);
  @$pb.TagNumber(5)
  void clearLoadState() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get pid => $_getI64(5);
  @$pb.TagNumber(6)
  set pid($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPid() => $_has(5);
  @$pb.TagNumber(6)
  void clearPid() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get startedAt => $_getSZ(6);
  @$pb.TagNumber(7)
  set startedAt($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasStartedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearStartedAt() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get serviceName => $_getSZ(7);
  @$pb.TagNumber(8)
  set serviceName($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasServiceName() => $_has(7);
  @$pb.TagNumber(8)
  void clearServiceName() => $_clearField(8);
}

class GetSSHServiceStatusRequest extends $pb.GeneratedMessage {
  factory GetSSHServiceStatusRequest({
    $1.Target? target,
  }) {
    final result = create();
    if (target != null) result.target = target;
    return result;
  }

  GetSSHServiceStatusRequest._();

  factory GetSSHServiceStatusRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetSSHServiceStatusRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetSSHServiceStatusRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOM<$1.Target>(1, _omitFieldNames ? '' : 'target',
        subBuilder: $1.Target.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSSHServiceStatusRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSSHServiceStatusRequest copyWith(
          void Function(GetSSHServiceStatusRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetSSHServiceStatusRequest))
          as GetSSHServiceStatusRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetSSHServiceStatusRequest create() => GetSSHServiceStatusRequest._();
  @$core.override
  GetSSHServiceStatusRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetSSHServiceStatusRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetSSHServiceStatusRequest>(create);
  static GetSSHServiceStatusRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.Target get target => $_getN(0);
  @$pb.TagNumber(1)
  set target($1.Target value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTarget() => $_has(0);
  @$pb.TagNumber(1)
  void clearTarget() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.Target ensureTarget() => $_ensure(0);
}

class GetSSHServiceStatusResponse extends $pb.GeneratedMessage {
  factory GetSSHServiceStatusResponse({
    ServiceStatus? status,
  }) {
    final result = create();
    if (status != null) result.status = status;
    return result;
  }

  GetSSHServiceStatusResponse._();

  factory GetSSHServiceStatusResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetSSHServiceStatusResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetSSHServiceStatusResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOM<ServiceStatus>(1, _omitFieldNames ? '' : 'status',
        subBuilder: ServiceStatus.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSSHServiceStatusResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSSHServiceStatusResponse copyWith(
          void Function(GetSSHServiceStatusResponse) updates) =>
      super.copyWith(
              (message) => updates(message as GetSSHServiceStatusResponse))
          as GetSSHServiceStatusResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetSSHServiceStatusResponse create() =>
      GetSSHServiceStatusResponse._();
  @$core.override
  GetSSHServiceStatusResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetSSHServiceStatusResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetSSHServiceStatusResponse>(create);
  static GetSSHServiceStatusResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ServiceStatus get status => $_getN(0);
  @$pb.TagNumber(1)
  set status(ServiceStatus value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => $_clearField(1);
  @$pb.TagNumber(1)
  ServiceStatus ensureStatus() => $_ensure(0);
}

class StartSSHServiceRequest extends $pb.GeneratedMessage {
  factory StartSSHServiceRequest({
    $1.Target? target,
  }) {
    final result = create();
    if (target != null) result.target = target;
    return result;
  }

  StartSSHServiceRequest._();

  factory StartSSHServiceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StartSSHServiceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartSSHServiceRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOM<$1.Target>(1, _omitFieldNames ? '' : 'target',
        subBuilder: $1.Target.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartSSHServiceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartSSHServiceRequest copyWith(
          void Function(StartSSHServiceRequest) updates) =>
      super.copyWith((message) => updates(message as StartSSHServiceRequest))
          as StartSSHServiceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartSSHServiceRequest create() => StartSSHServiceRequest._();
  @$core.override
  StartSSHServiceRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StartSSHServiceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartSSHServiceRequest>(create);
  static StartSSHServiceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.Target get target => $_getN(0);
  @$pb.TagNumber(1)
  set target($1.Target value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTarget() => $_has(0);
  @$pb.TagNumber(1)
  void clearTarget() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.Target ensureTarget() => $_ensure(0);
}

class StopSSHServiceRequest extends $pb.GeneratedMessage {
  factory StopSSHServiceRequest({
    $1.Target? target,
  }) {
    final result = create();
    if (target != null) result.target = target;
    return result;
  }

  StopSSHServiceRequest._();

  factory StopSSHServiceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StopSSHServiceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StopSSHServiceRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOM<$1.Target>(1, _omitFieldNames ? '' : 'target',
        subBuilder: $1.Target.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StopSSHServiceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StopSSHServiceRequest copyWith(
          void Function(StopSSHServiceRequest) updates) =>
      super.copyWith((message) => updates(message as StopSSHServiceRequest))
          as StopSSHServiceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StopSSHServiceRequest create() => StopSSHServiceRequest._();
  @$core.override
  StopSSHServiceRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StopSSHServiceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StopSSHServiceRequest>(create);
  static StopSSHServiceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.Target get target => $_getN(0);
  @$pb.TagNumber(1)
  set target($1.Target value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTarget() => $_has(0);
  @$pb.TagNumber(1)
  void clearTarget() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.Target ensureTarget() => $_ensure(0);
}

class RestartSSHServiceWithStatusRequest extends $pb.GeneratedMessage {
  factory RestartSSHServiceWithStatusRequest({
    $1.Target? target,
  }) {
    final result = create();
    if (target != null) result.target = target;
    return result;
  }

  RestartSSHServiceWithStatusRequest._();

  factory RestartSSHServiceWithStatusRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RestartSSHServiceWithStatusRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RestartSSHServiceWithStatusRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOM<$1.Target>(1, _omitFieldNames ? '' : 'target',
        subBuilder: $1.Target.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RestartSSHServiceWithStatusRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RestartSSHServiceWithStatusRequest copyWith(
          void Function(RestartSSHServiceWithStatusRequest) updates) =>
      super.copyWith((message) =>
              updates(message as RestartSSHServiceWithStatusRequest))
          as RestartSSHServiceWithStatusRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RestartSSHServiceWithStatusRequest create() =>
      RestartSSHServiceWithStatusRequest._();
  @$core.override
  RestartSSHServiceWithStatusRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RestartSSHServiceWithStatusRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RestartSSHServiceWithStatusRequest>(
          create);
  static RestartSSHServiceWithStatusRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.Target get target => $_getN(0);
  @$pb.TagNumber(1)
  set target($1.Target value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTarget() => $_has(0);
  @$pb.TagNumber(1)
  void clearTarget() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.Target ensureTarget() => $_ensure(0);
}

class ReloadSSHServiceRequest extends $pb.GeneratedMessage {
  factory ReloadSSHServiceRequest({
    $1.Target? target,
  }) {
    final result = create();
    if (target != null) result.target = target;
    return result;
  }

  ReloadSSHServiceRequest._();

  factory ReloadSSHServiceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReloadSSHServiceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReloadSSHServiceRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOM<$1.Target>(1, _omitFieldNames ? '' : 'target',
        subBuilder: $1.Target.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReloadSSHServiceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReloadSSHServiceRequest copyWith(
          void Function(ReloadSSHServiceRequest) updates) =>
      super.copyWith((message) => updates(message as ReloadSSHServiceRequest))
          as ReloadSSHServiceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReloadSSHServiceRequest create() => ReloadSSHServiceRequest._();
  @$core.override
  ReloadSSHServiceRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReloadSSHServiceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReloadSSHServiceRequest>(create);
  static ReloadSSHServiceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.Target get target => $_getN(0);
  @$pb.TagNumber(1)
  set target($1.Target value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTarget() => $_has(0);
  @$pb.TagNumber(1)
  void clearTarget() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.Target ensureTarget() => $_ensure(0);
}

class EnableSSHServiceRequest extends $pb.GeneratedMessage {
  factory EnableSSHServiceRequest({
    $1.Target? target,
  }) {
    final result = create();
    if (target != null) result.target = target;
    return result;
  }

  EnableSSHServiceRequest._();

  factory EnableSSHServiceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EnableSSHServiceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EnableSSHServiceRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOM<$1.Target>(1, _omitFieldNames ? '' : 'target',
        subBuilder: $1.Target.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EnableSSHServiceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EnableSSHServiceRequest copyWith(
          void Function(EnableSSHServiceRequest) updates) =>
      super.copyWith((message) => updates(message as EnableSSHServiceRequest))
          as EnableSSHServiceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EnableSSHServiceRequest create() => EnableSSHServiceRequest._();
  @$core.override
  EnableSSHServiceRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EnableSSHServiceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EnableSSHServiceRequest>(create);
  static EnableSSHServiceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.Target get target => $_getN(0);
  @$pb.TagNumber(1)
  set target($1.Target value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTarget() => $_has(0);
  @$pb.TagNumber(1)
  void clearTarget() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.Target ensureTarget() => $_ensure(0);
}

class DisableSSHServiceRequest extends $pb.GeneratedMessage {
  factory DisableSSHServiceRequest({
    $1.Target? target,
  }) {
    final result = create();
    if (target != null) result.target = target;
    return result;
  }

  DisableSSHServiceRequest._();

  factory DisableSSHServiceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DisableSSHServiceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DisableSSHServiceRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOM<$1.Target>(1, _omitFieldNames ? '' : 'target',
        subBuilder: $1.Target.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DisableSSHServiceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DisableSSHServiceRequest copyWith(
          void Function(DisableSSHServiceRequest) updates) =>
      super.copyWith((message) => updates(message as DisableSSHServiceRequest))
          as DisableSSHServiceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DisableSSHServiceRequest create() => DisableSSHServiceRequest._();
  @$core.override
  DisableSSHServiceRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DisableSSHServiceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DisableSSHServiceRequest>(create);
  static DisableSSHServiceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.Target get target => $_getN(0);
  @$pb.TagNumber(1)
  set target($1.Target value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTarget() => $_has(0);
  @$pb.TagNumber(1)
  void clearTarget() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.Target ensureTarget() => $_ensure(0);
}

class SSHServiceControlResponse extends $pb.GeneratedMessage {
  factory SSHServiceControlResponse({
    $core.bool? success,
    $core.String? message,
    ServiceStatus? status,
  }) {
    final result = create();
    if (success != null) result.success = success;
    if (message != null) result.message = message;
    if (status != null) result.status = status;
    return result;
  }

  SSHServiceControlResponse._();

  factory SSHServiceControlResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SSHServiceControlResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SSHServiceControlResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..aOM<ServiceStatus>(3, _omitFieldNames ? '' : 'status',
        subBuilder: ServiceStatus.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SSHServiceControlResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SSHServiceControlResponse copyWith(
          void Function(SSHServiceControlResponse) updates) =>
      super.copyWith((message) => updates(message as SSHServiceControlResponse))
          as SSHServiceControlResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SSHServiceControlResponse create() => SSHServiceControlResponse._();
  @$core.override
  SSHServiceControlResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SSHServiceControlResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SSHServiceControlResponse>(create);
  static SSHServiceControlResponse? _defaultInstance;

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
  ServiceStatus get status => $_getN(2);
  @$pb.TagNumber(3)
  set status(ServiceStatus value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearStatus() => $_clearField(3);
  @$pb.TagNumber(3)
  ServiceStatus ensureStatus() => $_ensure(2);
}

class GetInstallInstructionsRequest extends $pb.GeneratedMessage {
  factory GetInstallInstructionsRequest({
    $1.Target? target,
    SSHComponent? component,
  }) {
    final result = create();
    if (target != null) result.target = target;
    if (component != null) result.component = component;
    return result;
  }

  GetInstallInstructionsRequest._();

  factory GetInstallInstructionsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetInstallInstructionsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetInstallInstructionsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOM<$1.Target>(1, _omitFieldNames ? '' : 'target',
        subBuilder: $1.Target.create)
    ..aE<SSHComponent>(2, _omitFieldNames ? '' : 'component',
        enumValues: SSHComponent.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetInstallInstructionsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetInstallInstructionsRequest copyWith(
          void Function(GetInstallInstructionsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetInstallInstructionsRequest))
          as GetInstallInstructionsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetInstallInstructionsRequest create() =>
      GetInstallInstructionsRequest._();
  @$core.override
  GetInstallInstructionsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetInstallInstructionsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetInstallInstructionsRequest>(create);
  static GetInstallInstructionsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.Target get target => $_getN(0);
  @$pb.TagNumber(1)
  set target($1.Target value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTarget() => $_has(0);
  @$pb.TagNumber(1)
  void clearTarget() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.Target ensureTarget() => $_ensure(0);

  @$pb.TagNumber(2)
  SSHComponent get component => $_getN(1);
  @$pb.TagNumber(2)
  set component(SSHComponent value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasComponent() => $_has(1);
  @$pb.TagNumber(2)
  void clearComponent() => $_clearField(2);
}

class GetInstallInstructionsResponse extends $pb.GeneratedMessage {
  factory GetInstallInstructionsResponse({
    $core.String? distribution,
    SSHComponent? component,
    $core.String? packageName,
    $core.String? installCommand,
    $core.String? documentationUrl,
    $core.Iterable<$core.String>? steps,
  }) {
    final result = create();
    if (distribution != null) result.distribution = distribution;
    if (component != null) result.component = component;
    if (packageName != null) result.packageName = packageName;
    if (installCommand != null) result.installCommand = installCommand;
    if (documentationUrl != null) result.documentationUrl = documentationUrl;
    if (steps != null) result.steps.addAll(steps);
    return result;
  }

  GetInstallInstructionsResponse._();

  factory GetInstallInstructionsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetInstallInstructionsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetInstallInstructionsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'distribution')
    ..aE<SSHComponent>(2, _omitFieldNames ? '' : 'component',
        enumValues: SSHComponent.values)
    ..aOS(3, _omitFieldNames ? '' : 'packageName')
    ..aOS(4, _omitFieldNames ? '' : 'installCommand')
    ..aOS(5, _omitFieldNames ? '' : 'documentationUrl')
    ..pPS(6, _omitFieldNames ? '' : 'steps')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetInstallInstructionsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetInstallInstructionsResponse copyWith(
          void Function(GetInstallInstructionsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as GetInstallInstructionsResponse))
          as GetInstallInstructionsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetInstallInstructionsResponse create() =>
      GetInstallInstructionsResponse._();
  @$core.override
  GetInstallInstructionsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetInstallInstructionsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetInstallInstructionsResponse>(create);
  static GetInstallInstructionsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get distribution => $_getSZ(0);
  @$pb.TagNumber(1)
  set distribution($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDistribution() => $_has(0);
  @$pb.TagNumber(1)
  void clearDistribution() => $_clearField(1);

  @$pb.TagNumber(2)
  SSHComponent get component => $_getN(1);
  @$pb.TagNumber(2)
  set component(SSHComponent value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasComponent() => $_has(1);
  @$pb.TagNumber(2)
  void clearComponent() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get packageName => $_getSZ(2);
  @$pb.TagNumber(3)
  set packageName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPackageName() => $_has(2);
  @$pb.TagNumber(3)
  void clearPackageName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get installCommand => $_getSZ(3);
  @$pb.TagNumber(4)
  set installCommand($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasInstallCommand() => $_has(3);
  @$pb.TagNumber(4)
  void clearInstallCommand() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get documentationUrl => $_getSZ(4);
  @$pb.TagNumber(5)
  set documentationUrl($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDocumentationUrl() => $_has(4);
  @$pb.TagNumber(5)
  void clearDocumentationUrl() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<$core.String> get steps => $_getList(5);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
