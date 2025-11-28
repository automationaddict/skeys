// This is a generated file - do not edit.
//
// Generated from skeys/v1/config.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'common.pb.dart' as $2;
import 'config.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'config.pbenum.dart';

class SSHConfigEntry extends $pb.GeneratedMessage {
  factory SSHConfigEntry({
    $core.String? id,
    SSHConfigEntryType? type,
    $core.int? position,
    $core.Iterable<$core.String>? patterns,
    SSHOptions? options,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (type != null) result.type = type;
    if (position != null) result.position = position;
    if (patterns != null) result.patterns.addAll(patterns);
    if (options != null) result.options = options;
    return result;
  }

  SSHConfigEntry._();

  factory SSHConfigEntry.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SSHConfigEntry.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SSHConfigEntry',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aE<SSHConfigEntryType>(2, _omitFieldNames ? '' : 'type',
        enumValues: SSHConfigEntryType.values)
    ..aI(3, _omitFieldNames ? '' : 'position')
    ..pPS(4, _omitFieldNames ? '' : 'patterns')
    ..aOM<SSHOptions>(5, _omitFieldNames ? '' : 'options',
        subBuilder: SSHOptions.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SSHConfigEntry clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SSHConfigEntry copyWith(void Function(SSHConfigEntry) updates) =>
      super.copyWith((message) => updates(message as SSHConfigEntry))
          as SSHConfigEntry;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SSHConfigEntry create() => SSHConfigEntry._();
  @$core.override
  SSHConfigEntry createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SSHConfigEntry getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SSHConfigEntry>(create);
  static SSHConfigEntry? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  SSHConfigEntryType get type => $_getN(1);
  @$pb.TagNumber(2)
  set type(SSHConfigEntryType value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasType() => $_has(1);
  @$pb.TagNumber(2)
  void clearType() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get position => $_getIZ(2);
  @$pb.TagNumber(3)
  set position($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPosition() => $_has(2);
  @$pb.TagNumber(3)
  void clearPosition() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get patterns => $_getList(3);

  @$pb.TagNumber(5)
  SSHOptions get options => $_getN(4);
  @$pb.TagNumber(5)
  set options(SSHOptions value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasOptions() => $_has(4);
  @$pb.TagNumber(5)
  void clearOptions() => $_clearField(5);
  @$pb.TagNumber(5)
  SSHOptions ensureOptions() => $_ensure(4);
}

class SSHOptions extends $pb.GeneratedMessage {
  factory SSHOptions({
    $core.String? hostname,
    $core.int? port,
    $core.String? user,
    $core.Iterable<$core.String>? identityFiles,
    $core.String? proxyJump,
    $core.String? proxyCommand,
    $core.bool? forwardAgent,
    $core.bool? identitiesOnly,
    $core.String? strictHostKeyChecking,
    $core.int? serverAliveInterval,
    $core.int? serverAliveCountMax,
    $core.bool? compression,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? extraOptions,
  }) {
    final result = create();
    if (hostname != null) result.hostname = hostname;
    if (port != null) result.port = port;
    if (user != null) result.user = user;
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
    if (compression != null) result.compression = compression;
    if (extraOptions != null) result.extraOptions.addEntries(extraOptions);
    return result;
  }

  SSHOptions._();

  factory SSHOptions.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SSHOptions.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SSHOptions',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'hostname')
    ..aI(2, _omitFieldNames ? '' : 'port')
    ..aOS(3, _omitFieldNames ? '' : 'user')
    ..pPS(4, _omitFieldNames ? '' : 'identityFiles')
    ..aOS(5, _omitFieldNames ? '' : 'proxyJump')
    ..aOS(6, _omitFieldNames ? '' : 'proxyCommand')
    ..aOB(7, _omitFieldNames ? '' : 'forwardAgent')
    ..aOB(8, _omitFieldNames ? '' : 'identitiesOnly')
    ..aOS(9, _omitFieldNames ? '' : 'strictHostKeyChecking')
    ..aI(10, _omitFieldNames ? '' : 'serverAliveInterval')
    ..aI(11, _omitFieldNames ? '' : 'serverAliveCountMax')
    ..aOB(12, _omitFieldNames ? '' : 'compression')
    ..m<$core.String, $core.String>(100, _omitFieldNames ? '' : 'extraOptions',
        entryClassName: 'SSHOptions.ExtraOptionsEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('skeys.v1'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SSHOptions clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SSHOptions copyWith(void Function(SSHOptions) updates) =>
      super.copyWith((message) => updates(message as SSHOptions)) as SSHOptions;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SSHOptions create() => SSHOptions._();
  @$core.override
  SSHOptions createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SSHOptions getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SSHOptions>(create);
  static SSHOptions? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get hostname => $_getSZ(0);
  @$pb.TagNumber(1)
  set hostname($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasHostname() => $_has(0);
  @$pb.TagNumber(1)
  void clearHostname() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get port => $_getIZ(1);
  @$pb.TagNumber(2)
  set port($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPort() => $_has(1);
  @$pb.TagNumber(2)
  void clearPort() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get user => $_getSZ(2);
  @$pb.TagNumber(3)
  set user($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUser() => $_has(2);
  @$pb.TagNumber(3)
  void clearUser() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get identityFiles => $_getList(3);

  @$pb.TagNumber(5)
  $core.String get proxyJump => $_getSZ(4);
  @$pb.TagNumber(5)
  set proxyJump($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasProxyJump() => $_has(4);
  @$pb.TagNumber(5)
  void clearProxyJump() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get proxyCommand => $_getSZ(5);
  @$pb.TagNumber(6)
  set proxyCommand($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasProxyCommand() => $_has(5);
  @$pb.TagNumber(6)
  void clearProxyCommand() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get forwardAgent => $_getBF(6);
  @$pb.TagNumber(7)
  set forwardAgent($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasForwardAgent() => $_has(6);
  @$pb.TagNumber(7)
  void clearForwardAgent() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get identitiesOnly => $_getBF(7);
  @$pb.TagNumber(8)
  set identitiesOnly($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasIdentitiesOnly() => $_has(7);
  @$pb.TagNumber(8)
  void clearIdentitiesOnly() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get strictHostKeyChecking => $_getSZ(8);
  @$pb.TagNumber(9)
  set strictHostKeyChecking($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasStrictHostKeyChecking() => $_has(8);
  @$pb.TagNumber(9)
  void clearStrictHostKeyChecking() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get serverAliveInterval => $_getIZ(9);
  @$pb.TagNumber(10)
  set serverAliveInterval($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasServerAliveInterval() => $_has(9);
  @$pb.TagNumber(10)
  void clearServerAliveInterval() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.int get serverAliveCountMax => $_getIZ(10);
  @$pb.TagNumber(11)
  set serverAliveCountMax($core.int value) => $_setSignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasServerAliveCountMax() => $_has(10);
  @$pb.TagNumber(11)
  void clearServerAliveCountMax() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.bool get compression => $_getBF(11);
  @$pb.TagNumber(12)
  set compression($core.bool value) => $_setBool(11, value);
  @$pb.TagNumber(12)
  $core.bool hasCompression() => $_has(11);
  @$pb.TagNumber(12)
  void clearCompression() => $_clearField(12);

  @$pb.TagNumber(100)
  $pb.PbMap<$core.String, $core.String> get extraOptions => $_getMap(12);
}

/// New API request/response messages
class ListSSHConfigEntriesRequest extends $pb.GeneratedMessage {
  factory ListSSHConfigEntriesRequest({
    $2.Target? target,
  }) {
    final result = create();
    if (target != null) result.target = target;
    return result;
  }

  ListSSHConfigEntriesRequest._();

  factory ListSSHConfigEntriesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListSSHConfigEntriesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListSSHConfigEntriesRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOM<$2.Target>(1, _omitFieldNames ? '' : 'target',
        subBuilder: $2.Target.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListSSHConfigEntriesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListSSHConfigEntriesRequest copyWith(
          void Function(ListSSHConfigEntriesRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ListSSHConfigEntriesRequest))
          as ListSSHConfigEntriesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListSSHConfigEntriesRequest create() =>
      ListSSHConfigEntriesRequest._();
  @$core.override
  ListSSHConfigEntriesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListSSHConfigEntriesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListSSHConfigEntriesRequest>(create);
  static ListSSHConfigEntriesRequest? _defaultInstance;

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

class WatchSSHConfigEntriesRequest extends $pb.GeneratedMessage {
  factory WatchSSHConfigEntriesRequest({
    $2.Target? target,
  }) {
    final result = create();
    if (target != null) result.target = target;
    return result;
  }

  WatchSSHConfigEntriesRequest._();

  factory WatchSSHConfigEntriesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WatchSSHConfigEntriesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WatchSSHConfigEntriesRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOM<$2.Target>(1, _omitFieldNames ? '' : 'target',
        subBuilder: $2.Target.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchSSHConfigEntriesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchSSHConfigEntriesRequest copyWith(
          void Function(WatchSSHConfigEntriesRequest) updates) =>
      super.copyWith(
              (message) => updates(message as WatchSSHConfigEntriesRequest))
          as WatchSSHConfigEntriesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WatchSSHConfigEntriesRequest create() =>
      WatchSSHConfigEntriesRequest._();
  @$core.override
  WatchSSHConfigEntriesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WatchSSHConfigEntriesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WatchSSHConfigEntriesRequest>(create);
  static WatchSSHConfigEntriesRequest? _defaultInstance;

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

class ListSSHConfigEntriesResponse extends $pb.GeneratedMessage {
  factory ListSSHConfigEntriesResponse({
    $core.Iterable<SSHConfigEntry>? entries,
  }) {
    final result = create();
    if (entries != null) result.entries.addAll(entries);
    return result;
  }

  ListSSHConfigEntriesResponse._();

  factory ListSSHConfigEntriesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListSSHConfigEntriesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListSSHConfigEntriesResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..pPM<SSHConfigEntry>(1, _omitFieldNames ? '' : 'entries',
        subBuilder: SSHConfigEntry.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListSSHConfigEntriesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListSSHConfigEntriesResponse copyWith(
          void Function(ListSSHConfigEntriesResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListSSHConfigEntriesResponse))
          as ListSSHConfigEntriesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListSSHConfigEntriesResponse create() =>
      ListSSHConfigEntriesResponse._();
  @$core.override
  ListSSHConfigEntriesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListSSHConfigEntriesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListSSHConfigEntriesResponse>(create);
  static ListSSHConfigEntriesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<SSHConfigEntry> get entries => $_getList(0);
}

class GetSSHConfigEntryRequest extends $pb.GeneratedMessage {
  factory GetSSHConfigEntryRequest({
    $2.Target? target,
    $core.String? id,
  }) {
    final result = create();
    if (target != null) result.target = target;
    if (id != null) result.id = id;
    return result;
  }

  GetSSHConfigEntryRequest._();

  factory GetSSHConfigEntryRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetSSHConfigEntryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetSSHConfigEntryRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOM<$2.Target>(1, _omitFieldNames ? '' : 'target',
        subBuilder: $2.Target.create)
    ..aOS(2, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSSHConfigEntryRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSSHConfigEntryRequest copyWith(
          void Function(GetSSHConfigEntryRequest) updates) =>
      super.copyWith((message) => updates(message as GetSSHConfigEntryRequest))
          as GetSSHConfigEntryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetSSHConfigEntryRequest create() => GetSSHConfigEntryRequest._();
  @$core.override
  GetSSHConfigEntryRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetSSHConfigEntryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetSSHConfigEntryRequest>(create);
  static GetSSHConfigEntryRequest? _defaultInstance;

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
  $core.String get id => $_getSZ(1);
  @$pb.TagNumber(2)
  set id($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasId() => $_has(1);
  @$pb.TagNumber(2)
  void clearId() => $_clearField(2);
}

class CreateSSHConfigEntryRequest extends $pb.GeneratedMessage {
  factory CreateSSHConfigEntryRequest({
    $2.Target? target,
    SSHConfigEntry? entry,
    $core.int? insertPosition,
  }) {
    final result = create();
    if (target != null) result.target = target;
    if (entry != null) result.entry = entry;
    if (insertPosition != null) result.insertPosition = insertPosition;
    return result;
  }

  CreateSSHConfigEntryRequest._();

  factory CreateSSHConfigEntryRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateSSHConfigEntryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateSSHConfigEntryRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOM<$2.Target>(1, _omitFieldNames ? '' : 'target',
        subBuilder: $2.Target.create)
    ..aOM<SSHConfigEntry>(2, _omitFieldNames ? '' : 'entry',
        subBuilder: SSHConfigEntry.create)
    ..aI(3, _omitFieldNames ? '' : 'insertPosition')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateSSHConfigEntryRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateSSHConfigEntryRequest copyWith(
          void Function(CreateSSHConfigEntryRequest) updates) =>
      super.copyWith(
              (message) => updates(message as CreateSSHConfigEntryRequest))
          as CreateSSHConfigEntryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateSSHConfigEntryRequest create() =>
      CreateSSHConfigEntryRequest._();
  @$core.override
  CreateSSHConfigEntryRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CreateSSHConfigEntryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateSSHConfigEntryRequest>(create);
  static CreateSSHConfigEntryRequest? _defaultInstance;

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
  SSHConfigEntry get entry => $_getN(1);
  @$pb.TagNumber(2)
  set entry(SSHConfigEntry value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasEntry() => $_has(1);
  @$pb.TagNumber(2)
  void clearEntry() => $_clearField(2);
  @$pb.TagNumber(2)
  SSHConfigEntry ensureEntry() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.int get insertPosition => $_getIZ(2);
  @$pb.TagNumber(3)
  set insertPosition($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasInsertPosition() => $_has(2);
  @$pb.TagNumber(3)
  void clearInsertPosition() => $_clearField(3);
}

class UpdateSSHConfigEntryRequest extends $pb.GeneratedMessage {
  factory UpdateSSHConfigEntryRequest({
    $2.Target? target,
    $core.String? id,
    SSHConfigEntry? entry,
  }) {
    final result = create();
    if (target != null) result.target = target;
    if (id != null) result.id = id;
    if (entry != null) result.entry = entry;
    return result;
  }

  UpdateSSHConfigEntryRequest._();

  factory UpdateSSHConfigEntryRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateSSHConfigEntryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateSSHConfigEntryRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOM<$2.Target>(1, _omitFieldNames ? '' : 'target',
        subBuilder: $2.Target.create)
    ..aOS(2, _omitFieldNames ? '' : 'id')
    ..aOM<SSHConfigEntry>(3, _omitFieldNames ? '' : 'entry',
        subBuilder: SSHConfigEntry.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateSSHConfigEntryRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateSSHConfigEntryRequest copyWith(
          void Function(UpdateSSHConfigEntryRequest) updates) =>
      super.copyWith(
              (message) => updates(message as UpdateSSHConfigEntryRequest))
          as UpdateSSHConfigEntryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateSSHConfigEntryRequest create() =>
      UpdateSSHConfigEntryRequest._();
  @$core.override
  UpdateSSHConfigEntryRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateSSHConfigEntryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateSSHConfigEntryRequest>(create);
  static UpdateSSHConfigEntryRequest? _defaultInstance;

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
  $core.String get id => $_getSZ(1);
  @$pb.TagNumber(2)
  set id($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasId() => $_has(1);
  @$pb.TagNumber(2)
  void clearId() => $_clearField(2);

  @$pb.TagNumber(3)
  SSHConfigEntry get entry => $_getN(2);
  @$pb.TagNumber(3)
  set entry(SSHConfigEntry value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasEntry() => $_has(2);
  @$pb.TagNumber(3)
  void clearEntry() => $_clearField(3);
  @$pb.TagNumber(3)
  SSHConfigEntry ensureEntry() => $_ensure(2);
}

class DeleteSSHConfigEntryRequest extends $pb.GeneratedMessage {
  factory DeleteSSHConfigEntryRequest({
    $2.Target? target,
    $core.String? id,
  }) {
    final result = create();
    if (target != null) result.target = target;
    if (id != null) result.id = id;
    return result;
  }

  DeleteSSHConfigEntryRequest._();

  factory DeleteSSHConfigEntryRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteSSHConfigEntryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteSSHConfigEntryRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOM<$2.Target>(1, _omitFieldNames ? '' : 'target',
        subBuilder: $2.Target.create)
    ..aOS(2, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteSSHConfigEntryRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteSSHConfigEntryRequest copyWith(
          void Function(DeleteSSHConfigEntryRequest) updates) =>
      super.copyWith(
              (message) => updates(message as DeleteSSHConfigEntryRequest))
          as DeleteSSHConfigEntryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteSSHConfigEntryRequest create() =>
      DeleteSSHConfigEntryRequest._();
  @$core.override
  DeleteSSHConfigEntryRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeleteSSHConfigEntryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteSSHConfigEntryRequest>(create);
  static DeleteSSHConfigEntryRequest? _defaultInstance;

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
  $core.String get id => $_getSZ(1);
  @$pb.TagNumber(2)
  set id($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasId() => $_has(1);
  @$pb.TagNumber(2)
  void clearId() => $_clearField(2);
}

class ReorderSSHConfigEntriesRequest extends $pb.GeneratedMessage {
  factory ReorderSSHConfigEntriesRequest({
    $2.Target? target,
    $core.Iterable<$core.String>? entryIds,
  }) {
    final result = create();
    if (target != null) result.target = target;
    if (entryIds != null) result.entryIds.addAll(entryIds);
    return result;
  }

  ReorderSSHConfigEntriesRequest._();

  factory ReorderSSHConfigEntriesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReorderSSHConfigEntriesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReorderSSHConfigEntriesRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOM<$2.Target>(1, _omitFieldNames ? '' : 'target',
        subBuilder: $2.Target.create)
    ..pPS(2, _omitFieldNames ? '' : 'entryIds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReorderSSHConfigEntriesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReorderSSHConfigEntriesRequest copyWith(
          void Function(ReorderSSHConfigEntriesRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ReorderSSHConfigEntriesRequest))
          as ReorderSSHConfigEntriesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReorderSSHConfigEntriesRequest create() =>
      ReorderSSHConfigEntriesRequest._();
  @$core.override
  ReorderSSHConfigEntriesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReorderSSHConfigEntriesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReorderSSHConfigEntriesRequest>(create);
  static ReorderSSHConfigEntriesRequest? _defaultInstance;

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
  $pb.PbList<$core.String> get entryIds => $_getList(1);
}

/// Legacy HostConfig message (backward compatibility)
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

/// Skeys SSH Agent Integration messages
class GetSshConfigStatusRequest extends $pb.GeneratedMessage {
  factory GetSshConfigStatusRequest() => create();

  GetSshConfigStatusRequest._();

  factory GetSshConfigStatusRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetSshConfigStatusRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetSshConfigStatusRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSshConfigStatusRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSshConfigStatusRequest copyWith(
          void Function(GetSshConfigStatusRequest) updates) =>
      super.copyWith((message) => updates(message as GetSshConfigStatusRequest))
          as GetSshConfigStatusRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetSshConfigStatusRequest create() => GetSshConfigStatusRequest._();
  @$core.override
  GetSshConfigStatusRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetSshConfigStatusRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetSshConfigStatusRequest>(create);
  static GetSshConfigStatusRequest? _defaultInstance;
}

class GetSshConfigStatusResponse extends $pb.GeneratedMessage {
  factory GetSshConfigStatusResponse({
    $core.bool? enabled,
    $core.String? agentSocket,
  }) {
    final result = create();
    if (enabled != null) result.enabled = enabled;
    if (agentSocket != null) result.agentSocket = agentSocket;
    return result;
  }

  GetSshConfigStatusResponse._();

  factory GetSshConfigStatusResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetSshConfigStatusResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetSshConfigStatusResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'enabled')
    ..aOS(2, _omitFieldNames ? '' : 'agentSocket')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSshConfigStatusResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSshConfigStatusResponse copyWith(
          void Function(GetSshConfigStatusResponse) updates) =>
      super.copyWith(
              (message) => updates(message as GetSshConfigStatusResponse))
          as GetSshConfigStatusResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetSshConfigStatusResponse create() => GetSshConfigStatusResponse._();
  @$core.override
  GetSshConfigStatusResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetSshConfigStatusResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetSshConfigStatusResponse>(create);
  static GetSshConfigStatusResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get enabled => $_getBF(0);
  @$pb.TagNumber(1)
  set enabled($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEnabled() => $_has(0);
  @$pb.TagNumber(1)
  void clearEnabled() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get agentSocket => $_getSZ(1);
  @$pb.TagNumber(2)
  set agentSocket($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAgentSocket() => $_has(1);
  @$pb.TagNumber(2)
  void clearAgentSocket() => $_clearField(2);
}

class EnableSshConfigRequest extends $pb.GeneratedMessage {
  factory EnableSshConfigRequest() => create();

  EnableSshConfigRequest._();

  factory EnableSshConfigRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EnableSshConfigRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EnableSshConfigRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EnableSshConfigRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EnableSshConfigRequest copyWith(
          void Function(EnableSshConfigRequest) updates) =>
      super.copyWith((message) => updates(message as EnableSshConfigRequest))
          as EnableSshConfigRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EnableSshConfigRequest create() => EnableSshConfigRequest._();
  @$core.override
  EnableSshConfigRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EnableSshConfigRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EnableSshConfigRequest>(create);
  static EnableSshConfigRequest? _defaultInstance;
}

class EnableSshConfigResponse extends $pb.GeneratedMessage {
  factory EnableSshConfigResponse({
    $core.bool? success,
    $core.String? message,
  }) {
    final result = create();
    if (success != null) result.success = success;
    if (message != null) result.message = message;
    return result;
  }

  EnableSshConfigResponse._();

  factory EnableSshConfigResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EnableSshConfigResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EnableSshConfigResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EnableSshConfigResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EnableSshConfigResponse copyWith(
          void Function(EnableSshConfigResponse) updates) =>
      super.copyWith((message) => updates(message as EnableSshConfigResponse))
          as EnableSshConfigResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EnableSshConfigResponse create() => EnableSshConfigResponse._();
  @$core.override
  EnableSshConfigResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EnableSshConfigResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EnableSshConfigResponse>(create);
  static EnableSshConfigResponse? _defaultInstance;

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

class DisableSshConfigRequest extends $pb.GeneratedMessage {
  factory DisableSshConfigRequest() => create();

  DisableSshConfigRequest._();

  factory DisableSshConfigRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DisableSshConfigRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DisableSshConfigRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DisableSshConfigRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DisableSshConfigRequest copyWith(
          void Function(DisableSshConfigRequest) updates) =>
      super.copyWith((message) => updates(message as DisableSshConfigRequest))
          as DisableSshConfigRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DisableSshConfigRequest create() => DisableSshConfigRequest._();
  @$core.override
  DisableSshConfigRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DisableSshConfigRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DisableSshConfigRequest>(create);
  static DisableSshConfigRequest? _defaultInstance;
}

class DisableSshConfigResponse extends $pb.GeneratedMessage {
  factory DisableSshConfigResponse({
    $core.bool? success,
    $core.String? message,
  }) {
    final result = create();
    if (success != null) result.success = success;
    if (message != null) result.message = message;
    return result;
  }

  DisableSshConfigResponse._();

  factory DisableSshConfigResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DisableSshConfigResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DisableSshConfigResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DisableSshConfigResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DisableSshConfigResponse copyWith(
          void Function(DisableSshConfigResponse) updates) =>
      super.copyWith((message) => updates(message as DisableSshConfigResponse))
          as DisableSshConfigResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DisableSshConfigResponse create() => DisableSshConfigResponse._();
  @$core.override
  DisableSshConfigResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DisableSshConfigResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DisableSshConfigResponse>(create);
  static DisableSshConfigResponse? _defaultInstance;

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

/// Global directives messages (options outside Host/Match blocks in ~/.ssh/config)
class GlobalDirective extends $pb.GeneratedMessage {
  factory GlobalDirective({
    $core.String? key,
    $core.String? value,
  }) {
    final result = create();
    if (key != null) result.key = key;
    if (value != null) result.value = value;
    return result;
  }

  GlobalDirective._();

  factory GlobalDirective.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GlobalDirective.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GlobalDirective',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'key')
    ..aOS(2, _omitFieldNames ? '' : 'value')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GlobalDirective clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GlobalDirective copyWith(void Function(GlobalDirective) updates) =>
      super.copyWith((message) => updates(message as GlobalDirective))
          as GlobalDirective;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GlobalDirective create() => GlobalDirective._();
  @$core.override
  GlobalDirective createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GlobalDirective getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GlobalDirective>(create);
  static GlobalDirective? _defaultInstance;

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
}

class ListGlobalDirectivesRequest extends $pb.GeneratedMessage {
  factory ListGlobalDirectivesRequest({
    $2.Target? target,
  }) {
    final result = create();
    if (target != null) result.target = target;
    return result;
  }

  ListGlobalDirectivesRequest._();

  factory ListGlobalDirectivesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListGlobalDirectivesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListGlobalDirectivesRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOM<$2.Target>(1, _omitFieldNames ? '' : 'target',
        subBuilder: $2.Target.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListGlobalDirectivesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListGlobalDirectivesRequest copyWith(
          void Function(ListGlobalDirectivesRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ListGlobalDirectivesRequest))
          as ListGlobalDirectivesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListGlobalDirectivesRequest create() =>
      ListGlobalDirectivesRequest._();
  @$core.override
  ListGlobalDirectivesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListGlobalDirectivesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListGlobalDirectivesRequest>(create);
  static ListGlobalDirectivesRequest? _defaultInstance;

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

class ListGlobalDirectivesResponse extends $pb.GeneratedMessage {
  factory ListGlobalDirectivesResponse({
    $core.Iterable<GlobalDirective>? directives,
  }) {
    final result = create();
    if (directives != null) result.directives.addAll(directives);
    return result;
  }

  ListGlobalDirectivesResponse._();

  factory ListGlobalDirectivesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListGlobalDirectivesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListGlobalDirectivesResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..pPM<GlobalDirective>(1, _omitFieldNames ? '' : 'directives',
        subBuilder: GlobalDirective.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListGlobalDirectivesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListGlobalDirectivesResponse copyWith(
          void Function(ListGlobalDirectivesResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListGlobalDirectivesResponse))
          as ListGlobalDirectivesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListGlobalDirectivesResponse create() =>
      ListGlobalDirectivesResponse._();
  @$core.override
  ListGlobalDirectivesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListGlobalDirectivesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListGlobalDirectivesResponse>(create);
  static ListGlobalDirectivesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<GlobalDirective> get directives => $_getList(0);
}

class SetGlobalDirectiveRequest extends $pb.GeneratedMessage {
  factory SetGlobalDirectiveRequest({
    $2.Target? target,
    $core.String? key,
    $core.String? value,
  }) {
    final result = create();
    if (target != null) result.target = target;
    if (key != null) result.key = key;
    if (value != null) result.value = value;
    return result;
  }

  SetGlobalDirectiveRequest._();

  factory SetGlobalDirectiveRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetGlobalDirectiveRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetGlobalDirectiveRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOM<$2.Target>(1, _omitFieldNames ? '' : 'target',
        subBuilder: $2.Target.create)
    ..aOS(2, _omitFieldNames ? '' : 'key')
    ..aOS(3, _omitFieldNames ? '' : 'value')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetGlobalDirectiveRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetGlobalDirectiveRequest copyWith(
          void Function(SetGlobalDirectiveRequest) updates) =>
      super.copyWith((message) => updates(message as SetGlobalDirectiveRequest))
          as SetGlobalDirectiveRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetGlobalDirectiveRequest create() => SetGlobalDirectiveRequest._();
  @$core.override
  SetGlobalDirectiveRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetGlobalDirectiveRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetGlobalDirectiveRequest>(create);
  static SetGlobalDirectiveRequest? _defaultInstance;

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
  $core.String get key => $_getSZ(1);
  @$pb.TagNumber(2)
  set key($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearKey() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get value => $_getSZ(2);
  @$pb.TagNumber(3)
  set value($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasValue() => $_has(2);
  @$pb.TagNumber(3)
  void clearValue() => $_clearField(3);
}

class DeleteGlobalDirectiveRequest extends $pb.GeneratedMessage {
  factory DeleteGlobalDirectiveRequest({
    $2.Target? target,
    $core.String? key,
  }) {
    final result = create();
    if (target != null) result.target = target;
    if (key != null) result.key = key;
    return result;
  }

  DeleteGlobalDirectiveRequest._();

  factory DeleteGlobalDirectiveRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteGlobalDirectiveRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteGlobalDirectiveRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOM<$2.Target>(1, _omitFieldNames ? '' : 'target',
        subBuilder: $2.Target.create)
    ..aOS(2, _omitFieldNames ? '' : 'key')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteGlobalDirectiveRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteGlobalDirectiveRequest copyWith(
          void Function(DeleteGlobalDirectiveRequest) updates) =>
      super.copyWith(
              (message) => updates(message as DeleteGlobalDirectiveRequest))
          as DeleteGlobalDirectiveRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteGlobalDirectiveRequest create() =>
      DeleteGlobalDirectiveRequest._();
  @$core.override
  DeleteGlobalDirectiveRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeleteGlobalDirectiveRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteGlobalDirectiveRequest>(create);
  static DeleteGlobalDirectiveRequest? _defaultInstance;

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
  $core.String get key => $_getSZ(1);
  @$pb.TagNumber(2)
  set key($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearKey() => $_clearField(2);
}

/// Config Path Discovery messages
class DiscoverConfigPathsRequest extends $pb.GeneratedMessage {
  factory DiscoverConfigPathsRequest({
    $2.Target? target,
  }) {
    final result = create();
    if (target != null) result.target = target;
    return result;
  }

  DiscoverConfigPathsRequest._();

  factory DiscoverConfigPathsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DiscoverConfigPathsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DiscoverConfigPathsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOM<$2.Target>(1, _omitFieldNames ? '' : 'target',
        subBuilder: $2.Target.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DiscoverConfigPathsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DiscoverConfigPathsRequest copyWith(
          void Function(DiscoverConfigPathsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as DiscoverConfigPathsRequest))
          as DiscoverConfigPathsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DiscoverConfigPathsRequest create() => DiscoverConfigPathsRequest._();
  @$core.override
  DiscoverConfigPathsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DiscoverConfigPathsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DiscoverConfigPathsRequest>(create);
  static DiscoverConfigPathsRequest? _defaultInstance;

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

class DiscoverConfigPathsResponse extends $pb.GeneratedMessage {
  factory DiscoverConfigPathsResponse({
    ConfigPathInfo? clientSystemConfig,
    ConfigPathInfo? clientUserConfig,
    ConfigPathInfo? serverConfig,
    $core.String? distribution,
    $core.bool? sshClientInstalled,
    $core.bool? sshServerInstalled,
  }) {
    final result = create();
    if (clientSystemConfig != null)
      result.clientSystemConfig = clientSystemConfig;
    if (clientUserConfig != null) result.clientUserConfig = clientUserConfig;
    if (serverConfig != null) result.serverConfig = serverConfig;
    if (distribution != null) result.distribution = distribution;
    if (sshClientInstalled != null)
      result.sshClientInstalled = sshClientInstalled;
    if (sshServerInstalled != null)
      result.sshServerInstalled = sshServerInstalled;
    return result;
  }

  DiscoverConfigPathsResponse._();

  factory DiscoverConfigPathsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DiscoverConfigPathsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DiscoverConfigPathsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOM<ConfigPathInfo>(1, _omitFieldNames ? '' : 'clientSystemConfig',
        subBuilder: ConfigPathInfo.create)
    ..aOM<ConfigPathInfo>(2, _omitFieldNames ? '' : 'clientUserConfig',
        subBuilder: ConfigPathInfo.create)
    ..aOM<ConfigPathInfo>(3, _omitFieldNames ? '' : 'serverConfig',
        subBuilder: ConfigPathInfo.create)
    ..aOS(4, _omitFieldNames ? '' : 'distribution')
    ..aOB(5, _omitFieldNames ? '' : 'sshClientInstalled')
    ..aOB(6, _omitFieldNames ? '' : 'sshServerInstalled')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DiscoverConfigPathsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DiscoverConfigPathsResponse copyWith(
          void Function(DiscoverConfigPathsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as DiscoverConfigPathsResponse))
          as DiscoverConfigPathsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DiscoverConfigPathsResponse create() =>
      DiscoverConfigPathsResponse._();
  @$core.override
  DiscoverConfigPathsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DiscoverConfigPathsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DiscoverConfigPathsResponse>(create);
  static DiscoverConfigPathsResponse? _defaultInstance;

  /// Client config paths
  @$pb.TagNumber(1)
  ConfigPathInfo get clientSystemConfig => $_getN(0);
  @$pb.TagNumber(1)
  set clientSystemConfig(ConfigPathInfo value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasClientSystemConfig() => $_has(0);
  @$pb.TagNumber(1)
  void clearClientSystemConfig() => $_clearField(1);
  @$pb.TagNumber(1)
  ConfigPathInfo ensureClientSystemConfig() => $_ensure(0);

  @$pb.TagNumber(2)
  ConfigPathInfo get clientUserConfig => $_getN(1);
  @$pb.TagNumber(2)
  set clientUserConfig(ConfigPathInfo value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasClientUserConfig() => $_has(1);
  @$pb.TagNumber(2)
  void clearClientUserConfig() => $_clearField(2);
  @$pb.TagNumber(2)
  ConfigPathInfo ensureClientUserConfig() => $_ensure(1);

  /// Server config paths
  @$pb.TagNumber(3)
  ConfigPathInfo get serverConfig => $_getN(2);
  @$pb.TagNumber(3)
  set serverConfig(ConfigPathInfo value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasServerConfig() => $_has(2);
  @$pb.TagNumber(3)
  void clearServerConfig() => $_clearField(3);
  @$pb.TagNumber(3)
  ConfigPathInfo ensureServerConfig() => $_ensure(2);

  /// Additional info
  @$pb.TagNumber(4)
  $core.String get distribution => $_getSZ(3);
  @$pb.TagNumber(4)
  set distribution($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDistribution() => $_has(3);
  @$pb.TagNumber(4)
  void clearDistribution() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get sshClientInstalled => $_getBF(4);
  @$pb.TagNumber(5)
  set sshClientInstalled($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSshClientInstalled() => $_has(4);
  @$pb.TagNumber(5)
  void clearSshClientInstalled() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get sshServerInstalled => $_getBF(5);
  @$pb.TagNumber(6)
  set sshServerInstalled($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSshServerInstalled() => $_has(5);
  @$pb.TagNumber(6)
  void clearSshServerInstalled() => $_clearField(6);
}

class ConfigPathInfo extends $pb.GeneratedMessage {
  factory ConfigPathInfo({
    $core.String? path,
    $core.bool? exists,
    $core.bool? readable,
    $core.bool? writable,
    $core.String? includeDir,
    DiscoveryMethod? discoveryMethod,
  }) {
    final result = create();
    if (path != null) result.path = path;
    if (exists != null) result.exists = exists;
    if (readable != null) result.readable = readable;
    if (writable != null) result.writable = writable;
    if (includeDir != null) result.includeDir = includeDir;
    if (discoveryMethod != null) result.discoveryMethod = discoveryMethod;
    return result;
  }

  ConfigPathInfo._();

  factory ConfigPathInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ConfigPathInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ConfigPathInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'path')
    ..aOB(2, _omitFieldNames ? '' : 'exists')
    ..aOB(3, _omitFieldNames ? '' : 'readable')
    ..aOB(4, _omitFieldNames ? '' : 'writable')
    ..aOS(5, _omitFieldNames ? '' : 'includeDir')
    ..aE<DiscoveryMethod>(6, _omitFieldNames ? '' : 'discoveryMethod',
        enumValues: DiscoveryMethod.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConfigPathInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConfigPathInfo copyWith(void Function(ConfigPathInfo) updates) =>
      super.copyWith((message) => updates(message as ConfigPathInfo))
          as ConfigPathInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ConfigPathInfo create() => ConfigPathInfo._();
  @$core.override
  ConfigPathInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ConfigPathInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConfigPathInfo>(create);
  static ConfigPathInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get path => $_getSZ(0);
  @$pb.TagNumber(1)
  set path($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPath() => $_has(0);
  @$pb.TagNumber(1)
  void clearPath() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get exists => $_getBF(1);
  @$pb.TagNumber(2)
  set exists($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasExists() => $_has(1);
  @$pb.TagNumber(2)
  void clearExists() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get readable => $_getBF(2);
  @$pb.TagNumber(3)
  set readable($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReadable() => $_has(2);
  @$pb.TagNumber(3)
  void clearReadable() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get writable => $_getBF(3);
  @$pb.TagNumber(4)
  set writable($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasWritable() => $_has(3);
  @$pb.TagNumber(4)
  void clearWritable() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get includeDir => $_getSZ(4);
  @$pb.TagNumber(5)
  set includeDir($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasIncludeDir() => $_has(4);
  @$pb.TagNumber(5)
  void clearIncludeDir() => $_clearField(5);

  @$pb.TagNumber(6)
  DiscoveryMethod get discoveryMethod => $_getN(5);
  @$pb.TagNumber(6)
  set discoveryMethod(DiscoveryMethod value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasDiscoveryMethod() => $_has(5);
  @$pb.TagNumber(6)
  void clearDiscoveryMethod() => $_clearField(6);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
