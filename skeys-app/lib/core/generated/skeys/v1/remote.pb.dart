// This is a generated file - do not edit.
//
// Generated from skeys/v1/remote.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;
import '../../google/protobuf/timestamp.pb.dart'
    as $2;

import 'remote.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'remote.pbenum.dart';

class Remote extends $pb.GeneratedMessage {
  factory Remote({
    $core.String? id,
    $core.String? name,
    $core.String? host,
    $core.int? port,
    $core.String? user,
    $core.String? identityFile,
    $core.String? sshConfigAlias,
    $2.Timestamp? createdAt,
    $2.Timestamp? lastConnectedAt,
    RemoteStatus? status,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    if (host != null) result.host = host;
    if (port != null) result.port = port;
    if (user != null) result.user = user;
    if (identityFile != null) result.identityFile = identityFile;
    if (sshConfigAlias != null) result.sshConfigAlias = sshConfigAlias;
    if (createdAt != null) result.createdAt = createdAt;
    if (lastConnectedAt != null) result.lastConnectedAt = lastConnectedAt;
    if (status != null) result.status = status;
    return result;
  }

  Remote._();

  factory Remote.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Remote.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Remote',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'host')
    ..aI(4, _omitFieldNames ? '' : 'port')
    ..aOS(5, _omitFieldNames ? '' : 'user')
    ..aOS(6, _omitFieldNames ? '' : 'identityFile')
    ..aOS(7, _omitFieldNames ? '' : 'sshConfigAlias')
    ..aOM<$2.Timestamp>(8, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $2.Timestamp.create)
    ..aOM<$2.Timestamp>(9, _omitFieldNames ? '' : 'lastConnectedAt',
        subBuilder: $2.Timestamp.create)
    ..aE<RemoteStatus>(10, _omitFieldNames ? '' : 'status',
        enumValues: RemoteStatus.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Remote clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Remote copyWith(void Function(Remote) updates) =>
      super.copyWith((message) => updates(message as Remote)) as Remote;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Remote create() => Remote._();
  @$core.override
  Remote createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Remote getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Remote>(create);
  static Remote? _defaultInstance;

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
  $core.String get host => $_getSZ(2);
  @$pb.TagNumber(3)
  set host($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasHost() => $_has(2);
  @$pb.TagNumber(3)
  void clearHost() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get port => $_getIZ(3);
  @$pb.TagNumber(4)
  set port($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPort() => $_has(3);
  @$pb.TagNumber(4)
  void clearPort() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get user => $_getSZ(4);
  @$pb.TagNumber(5)
  set user($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasUser() => $_has(4);
  @$pb.TagNumber(5)
  void clearUser() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get identityFile => $_getSZ(5);
  @$pb.TagNumber(6)
  set identityFile($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasIdentityFile() => $_has(5);
  @$pb.TagNumber(6)
  void clearIdentityFile() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get sshConfigAlias => $_getSZ(6);
  @$pb.TagNumber(7)
  set sshConfigAlias($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSshConfigAlias() => $_has(6);
  @$pb.TagNumber(7)
  void clearSshConfigAlias() => $_clearField(7);

  @$pb.TagNumber(8)
  $2.Timestamp get createdAt => $_getN(7);
  @$pb.TagNumber(8)
  set createdAt($2.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasCreatedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearCreatedAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $2.Timestamp ensureCreatedAt() => $_ensure(7);

  @$pb.TagNumber(9)
  $2.Timestamp get lastConnectedAt => $_getN(8);
  @$pb.TagNumber(9)
  set lastConnectedAt($2.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasLastConnectedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearLastConnectedAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $2.Timestamp ensureLastConnectedAt() => $_ensure(8);

  @$pb.TagNumber(10)
  RemoteStatus get status => $_getN(9);
  @$pb.TagNumber(10)
  set status(RemoteStatus value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasStatus() => $_has(9);
  @$pb.TagNumber(10)
  void clearStatus() => $_clearField(10);
}

class Connection extends $pb.GeneratedMessage {
  factory Connection({
    $core.String? id,
    $core.String? remoteId,
    $core.String? host,
    $core.int? port,
    $core.String? user,
    $core.String? serverVersion,
    $2.Timestamp? connectedAt,
    $2.Timestamp? lastActivityAt,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (remoteId != null) result.remoteId = remoteId;
    if (host != null) result.host = host;
    if (port != null) result.port = port;
    if (user != null) result.user = user;
    if (serverVersion != null) result.serverVersion = serverVersion;
    if (connectedAt != null) result.connectedAt = connectedAt;
    if (lastActivityAt != null) result.lastActivityAt = lastActivityAt;
    return result;
  }

  Connection._();

  factory Connection.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Connection.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Connection',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'remoteId')
    ..aOS(3, _omitFieldNames ? '' : 'host')
    ..aI(4, _omitFieldNames ? '' : 'port')
    ..aOS(5, _omitFieldNames ? '' : 'user')
    ..aOS(6, _omitFieldNames ? '' : 'serverVersion')
    ..aOM<$2.Timestamp>(7, _omitFieldNames ? '' : 'connectedAt',
        subBuilder: $2.Timestamp.create)
    ..aOM<$2.Timestamp>(8, _omitFieldNames ? '' : 'lastActivityAt',
        subBuilder: $2.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Connection clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Connection copyWith(void Function(Connection) updates) =>
      super.copyWith((message) => updates(message as Connection)) as Connection;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Connection create() => Connection._();
  @$core.override
  Connection createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Connection getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Connection>(create);
  static Connection? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get remoteId => $_getSZ(1);
  @$pb.TagNumber(2)
  set remoteId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRemoteId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRemoteId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get host => $_getSZ(2);
  @$pb.TagNumber(3)
  set host($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasHost() => $_has(2);
  @$pb.TagNumber(3)
  void clearHost() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get port => $_getIZ(3);
  @$pb.TagNumber(4)
  set port($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPort() => $_has(3);
  @$pb.TagNumber(4)
  void clearPort() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get user => $_getSZ(4);
  @$pb.TagNumber(5)
  set user($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasUser() => $_has(4);
  @$pb.TagNumber(5)
  void clearUser() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get serverVersion => $_getSZ(5);
  @$pb.TagNumber(6)
  set serverVersion($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasServerVersion() => $_has(5);
  @$pb.TagNumber(6)
  void clearServerVersion() => $_clearField(6);

  @$pb.TagNumber(7)
  $2.Timestamp get connectedAt => $_getN(6);
  @$pb.TagNumber(7)
  set connectedAt($2.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasConnectedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearConnectedAt() => $_clearField(7);
  @$pb.TagNumber(7)
  $2.Timestamp ensureConnectedAt() => $_ensure(6);

  @$pb.TagNumber(8)
  $2.Timestamp get lastActivityAt => $_getN(7);
  @$pb.TagNumber(8)
  set lastActivityAt($2.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasLastActivityAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearLastActivityAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $2.Timestamp ensureLastActivityAt() => $_ensure(7);
}

class ListRemotesRequest extends $pb.GeneratedMessage {
  factory ListRemotesRequest() => create();

  ListRemotesRequest._();

  factory ListRemotesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListRemotesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListRemotesRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRemotesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRemotesRequest copyWith(void Function(ListRemotesRequest) updates) =>
      super.copyWith((message) => updates(message as ListRemotesRequest))
          as ListRemotesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListRemotesRequest create() => ListRemotesRequest._();
  @$core.override
  ListRemotesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListRemotesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListRemotesRequest>(create);
  static ListRemotesRequest? _defaultInstance;
}

class ListRemotesResponse extends $pb.GeneratedMessage {
  factory ListRemotesResponse({
    $core.Iterable<Remote>? remotes,
  }) {
    final result = create();
    if (remotes != null) result.remotes.addAll(remotes);
    return result;
  }

  ListRemotesResponse._();

  factory ListRemotesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListRemotesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListRemotesResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..pPM<Remote>(1, _omitFieldNames ? '' : 'remotes',
        subBuilder: Remote.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRemotesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRemotesResponse copyWith(void Function(ListRemotesResponse) updates) =>
      super.copyWith((message) => updates(message as ListRemotesResponse))
          as ListRemotesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListRemotesResponse create() => ListRemotesResponse._();
  @$core.override
  ListRemotesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListRemotesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListRemotesResponse>(create);
  static ListRemotesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Remote> get remotes => $_getList(0);
}

class GetRemoteRequest extends $pb.GeneratedMessage {
  factory GetRemoteRequest({
    $core.String? id,
  }) {
    final result = create();
    if (id != null) result.id = id;
    return result;
  }

  GetRemoteRequest._();

  factory GetRemoteRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetRemoteRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRemoteRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRemoteRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRemoteRequest copyWith(void Function(GetRemoteRequest) updates) =>
      super.copyWith((message) => updates(message as GetRemoteRequest))
          as GetRemoteRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetRemoteRequest create() => GetRemoteRequest._();
  @$core.override
  GetRemoteRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetRemoteRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetRemoteRequest>(create);
  static GetRemoteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

class AddRemoteRequest extends $pb.GeneratedMessage {
  factory AddRemoteRequest({
    $core.String? name,
    $core.String? host,
    $core.int? port,
    $core.String? user,
    $core.String? identityFile,
    $core.String? sshConfigAlias,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (host != null) result.host = host;
    if (port != null) result.port = port;
    if (user != null) result.user = user;
    if (identityFile != null) result.identityFile = identityFile;
    if (sshConfigAlias != null) result.sshConfigAlias = sshConfigAlias;
    return result;
  }

  AddRemoteRequest._();

  factory AddRemoteRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddRemoteRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddRemoteRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'host')
    ..aI(3, _omitFieldNames ? '' : 'port')
    ..aOS(4, _omitFieldNames ? '' : 'user')
    ..aOS(5, _omitFieldNames ? '' : 'identityFile')
    ..aOS(6, _omitFieldNames ? '' : 'sshConfigAlias')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddRemoteRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddRemoteRequest copyWith(void Function(AddRemoteRequest) updates) =>
      super.copyWith((message) => updates(message as AddRemoteRequest))
          as AddRemoteRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddRemoteRequest create() => AddRemoteRequest._();
  @$core.override
  AddRemoteRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AddRemoteRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddRemoteRequest>(create);
  static AddRemoteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get host => $_getSZ(1);
  @$pb.TagNumber(2)
  set host($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasHost() => $_has(1);
  @$pb.TagNumber(2)
  void clearHost() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get port => $_getIZ(2);
  @$pb.TagNumber(3)
  set port($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPort() => $_has(2);
  @$pb.TagNumber(3)
  void clearPort() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get user => $_getSZ(3);
  @$pb.TagNumber(4)
  set user($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUser() => $_has(3);
  @$pb.TagNumber(4)
  void clearUser() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get identityFile => $_getSZ(4);
  @$pb.TagNumber(5)
  set identityFile($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasIdentityFile() => $_has(4);
  @$pb.TagNumber(5)
  void clearIdentityFile() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get sshConfigAlias => $_getSZ(5);
  @$pb.TagNumber(6)
  set sshConfigAlias($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSshConfigAlias() => $_has(5);
  @$pb.TagNumber(6)
  void clearSshConfigAlias() => $_clearField(6);
}

class UpdateRemoteRequest extends $pb.GeneratedMessage {
  factory UpdateRemoteRequest({
    $core.String? id,
    $core.String? name,
    $core.String? host,
    $core.int? port,
    $core.String? user,
    $core.String? identityFile,
    $core.String? sshConfigAlias,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    if (host != null) result.host = host;
    if (port != null) result.port = port;
    if (user != null) result.user = user;
    if (identityFile != null) result.identityFile = identityFile;
    if (sshConfigAlias != null) result.sshConfigAlias = sshConfigAlias;
    return result;
  }

  UpdateRemoteRequest._();

  factory UpdateRemoteRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateRemoteRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateRemoteRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'host')
    ..aI(4, _omitFieldNames ? '' : 'port')
    ..aOS(5, _omitFieldNames ? '' : 'user')
    ..aOS(6, _omitFieldNames ? '' : 'identityFile')
    ..aOS(7, _omitFieldNames ? '' : 'sshConfigAlias')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateRemoteRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateRemoteRequest copyWith(void Function(UpdateRemoteRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateRemoteRequest))
          as UpdateRemoteRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateRemoteRequest create() => UpdateRemoteRequest._();
  @$core.override
  UpdateRemoteRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateRemoteRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateRemoteRequest>(create);
  static UpdateRemoteRequest? _defaultInstance;

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
  $core.String get host => $_getSZ(2);
  @$pb.TagNumber(3)
  set host($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasHost() => $_has(2);
  @$pb.TagNumber(3)
  void clearHost() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get port => $_getIZ(3);
  @$pb.TagNumber(4)
  set port($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPort() => $_has(3);
  @$pb.TagNumber(4)
  void clearPort() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get user => $_getSZ(4);
  @$pb.TagNumber(5)
  set user($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasUser() => $_has(4);
  @$pb.TagNumber(5)
  void clearUser() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get identityFile => $_getSZ(5);
  @$pb.TagNumber(6)
  set identityFile($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasIdentityFile() => $_has(5);
  @$pb.TagNumber(6)
  void clearIdentityFile() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get sshConfigAlias => $_getSZ(6);
  @$pb.TagNumber(7)
  set sshConfigAlias($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSshConfigAlias() => $_has(6);
  @$pb.TagNumber(7)
  void clearSshConfigAlias() => $_clearField(7);
}

class DeleteRemoteRequest extends $pb.GeneratedMessage {
  factory DeleteRemoteRequest({
    $core.String? id,
  }) {
    final result = create();
    if (id != null) result.id = id;
    return result;
  }

  DeleteRemoteRequest._();

  factory DeleteRemoteRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteRemoteRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteRemoteRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteRemoteRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteRemoteRequest copyWith(void Function(DeleteRemoteRequest) updates) =>
      super.copyWith((message) => updates(message as DeleteRemoteRequest))
          as DeleteRemoteRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteRemoteRequest create() => DeleteRemoteRequest._();
  @$core.override
  DeleteRemoteRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeleteRemoteRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteRemoteRequest>(create);
  static DeleteRemoteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

class TestRemoteConnectionRequest extends $pb.GeneratedMessage {
  factory TestRemoteConnectionRequest({
    $core.String? remoteId,
    $core.String? host,
    $core.int? port,
    $core.String? user,
    $core.String? identityFile,
    $core.int? timeoutSeconds,
    $core.String? passphrase,
    $core.bool? trustHostKey,
  }) {
    final result = create();
    if (remoteId != null) result.remoteId = remoteId;
    if (host != null) result.host = host;
    if (port != null) result.port = port;
    if (user != null) result.user = user;
    if (identityFile != null) result.identityFile = identityFile;
    if (timeoutSeconds != null) result.timeoutSeconds = timeoutSeconds;
    if (passphrase != null) result.passphrase = passphrase;
    if (trustHostKey != null) result.trustHostKey = trustHostKey;
    return result;
  }

  TestRemoteConnectionRequest._();

  factory TestRemoteConnectionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TestRemoteConnectionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TestRemoteConnectionRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'remoteId')
    ..aOS(2, _omitFieldNames ? '' : 'host')
    ..aI(3, _omitFieldNames ? '' : 'port')
    ..aOS(4, _omitFieldNames ? '' : 'user')
    ..aOS(5, _omitFieldNames ? '' : 'identityFile')
    ..aI(6, _omitFieldNames ? '' : 'timeoutSeconds')
    ..aOS(7, _omitFieldNames ? '' : 'passphrase')
    ..aOB(8, _omitFieldNames ? '' : 'trustHostKey')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TestRemoteConnectionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TestRemoteConnectionRequest copyWith(
          void Function(TestRemoteConnectionRequest) updates) =>
      super.copyWith(
              (message) => updates(message as TestRemoteConnectionRequest))
          as TestRemoteConnectionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TestRemoteConnectionRequest create() =>
      TestRemoteConnectionRequest._();
  @$core.override
  TestRemoteConnectionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TestRemoteConnectionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TestRemoteConnectionRequest>(create);
  static TestRemoteConnectionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get remoteId => $_getSZ(0);
  @$pb.TagNumber(1)
  set remoteId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRemoteId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRemoteId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get host => $_getSZ(1);
  @$pb.TagNumber(2)
  set host($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasHost() => $_has(1);
  @$pb.TagNumber(2)
  void clearHost() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get port => $_getIZ(2);
  @$pb.TagNumber(3)
  set port($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPort() => $_has(2);
  @$pb.TagNumber(3)
  void clearPort() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get user => $_getSZ(3);
  @$pb.TagNumber(4)
  set user($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUser() => $_has(3);
  @$pb.TagNumber(4)
  void clearUser() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get identityFile => $_getSZ(4);
  @$pb.TagNumber(5)
  set identityFile($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasIdentityFile() => $_has(4);
  @$pb.TagNumber(5)
  void clearIdentityFile() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get timeoutSeconds => $_getIZ(5);
  @$pb.TagNumber(6)
  set timeoutSeconds($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTimeoutSeconds() => $_has(5);
  @$pb.TagNumber(6)
  void clearTimeoutSeconds() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get passphrase => $_getSZ(6);
  @$pb.TagNumber(7)
  set passphrase($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasPassphrase() => $_has(6);
  @$pb.TagNumber(7)
  void clearPassphrase() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get trustHostKey => $_getBF(7);
  @$pb.TagNumber(8)
  set trustHostKey($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasTrustHostKey() => $_has(7);
  @$pb.TagNumber(8)
  void clearTrustHostKey() => $_clearField(8);
}

/// Information about an unknown or mismatched host key
class HostKeyInfo extends $pb.GeneratedMessage {
  factory HostKeyInfo({
    $core.String? hostname,
    $core.int? port,
    $core.String? keyType,
    $core.String? fingerprint,
    $core.String? publicKey,
  }) {
    final result = create();
    if (hostname != null) result.hostname = hostname;
    if (port != null) result.port = port;
    if (keyType != null) result.keyType = keyType;
    if (fingerprint != null) result.fingerprint = fingerprint;
    if (publicKey != null) result.publicKey = publicKey;
    return result;
  }

  HostKeyInfo._();

  factory HostKeyInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory HostKeyInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HostKeyInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'hostname')
    ..aI(2, _omitFieldNames ? '' : 'port')
    ..aOS(3, _omitFieldNames ? '' : 'keyType')
    ..aOS(4, _omitFieldNames ? '' : 'fingerprint')
    ..aOS(5, _omitFieldNames ? '' : 'publicKey')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HostKeyInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HostKeyInfo copyWith(void Function(HostKeyInfo) updates) =>
      super.copyWith((message) => updates(message as HostKeyInfo))
          as HostKeyInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HostKeyInfo create() => HostKeyInfo._();
  @$core.override
  HostKeyInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static HostKeyInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HostKeyInfo>(create);
  static HostKeyInfo? _defaultInstance;

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
}

class TestRemoteConnectionResponse extends $pb.GeneratedMessage {
  factory TestRemoteConnectionResponse({
    $core.bool? success,
    $core.String? message,
    $core.String? serverVersion,
    $core.int? latencyMs,
    HostKeyStatus? hostKeyStatus,
    HostKeyInfo? hostKeyInfo,
  }) {
    final result = create();
    if (success != null) result.success = success;
    if (message != null) result.message = message;
    if (serverVersion != null) result.serverVersion = serverVersion;
    if (latencyMs != null) result.latencyMs = latencyMs;
    if (hostKeyStatus != null) result.hostKeyStatus = hostKeyStatus;
    if (hostKeyInfo != null) result.hostKeyInfo = hostKeyInfo;
    return result;
  }

  TestRemoteConnectionResponse._();

  factory TestRemoteConnectionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TestRemoteConnectionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TestRemoteConnectionResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..aOS(3, _omitFieldNames ? '' : 'serverVersion')
    ..aI(4, _omitFieldNames ? '' : 'latencyMs')
    ..aE<HostKeyStatus>(5, _omitFieldNames ? '' : 'hostKeyStatus',
        enumValues: HostKeyStatus.values)
    ..aOM<HostKeyInfo>(6, _omitFieldNames ? '' : 'hostKeyInfo',
        subBuilder: HostKeyInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TestRemoteConnectionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TestRemoteConnectionResponse copyWith(
          void Function(TestRemoteConnectionResponse) updates) =>
      super.copyWith(
              (message) => updates(message as TestRemoteConnectionResponse))
          as TestRemoteConnectionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TestRemoteConnectionResponse create() =>
      TestRemoteConnectionResponse._();
  @$core.override
  TestRemoteConnectionResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TestRemoteConnectionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TestRemoteConnectionResponse>(create);
  static TestRemoteConnectionResponse? _defaultInstance;

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

  @$pb.TagNumber(5)
  HostKeyStatus get hostKeyStatus => $_getN(4);
  @$pb.TagNumber(5)
  set hostKeyStatus(HostKeyStatus value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasHostKeyStatus() => $_has(4);
  @$pb.TagNumber(5)
  void clearHostKeyStatus() => $_clearField(5);

  @$pb.TagNumber(6)
  HostKeyInfo get hostKeyInfo => $_getN(5);
  @$pb.TagNumber(6)
  set hostKeyInfo(HostKeyInfo value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasHostKeyInfo() => $_has(5);
  @$pb.TagNumber(6)
  void clearHostKeyInfo() => $_clearField(6);
  @$pb.TagNumber(6)
  HostKeyInfo ensureHostKeyInfo() => $_ensure(5);
}

class ConnectRequest extends $pb.GeneratedMessage {
  factory ConnectRequest({
    $core.String? remoteId,
    $core.String? passphrase,
  }) {
    final result = create();
    if (remoteId != null) result.remoteId = remoteId;
    if (passphrase != null) result.passphrase = passphrase;
    return result;
  }

  ConnectRequest._();

  factory ConnectRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ConnectRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ConnectRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'remoteId')
    ..aOS(2, _omitFieldNames ? '' : 'passphrase')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConnectRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConnectRequest copyWith(void Function(ConnectRequest) updates) =>
      super.copyWith((message) => updates(message as ConnectRequest))
          as ConnectRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ConnectRequest create() => ConnectRequest._();
  @$core.override
  ConnectRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ConnectRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConnectRequest>(create);
  static ConnectRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get remoteId => $_getSZ(0);
  @$pb.TagNumber(1)
  set remoteId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRemoteId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRemoteId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get passphrase => $_getSZ(1);
  @$pb.TagNumber(2)
  set passphrase($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPassphrase() => $_has(1);
  @$pb.TagNumber(2)
  void clearPassphrase() => $_clearField(2);
}

class ConnectResponse extends $pb.GeneratedMessage {
  factory ConnectResponse({
    Connection? connection,
  }) {
    final result = create();
    if (connection != null) result.connection = connection;
    return result;
  }

  ConnectResponse._();

  factory ConnectResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ConnectResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ConnectResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOM<Connection>(1, _omitFieldNames ? '' : 'connection',
        subBuilder: Connection.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConnectResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConnectResponse copyWith(void Function(ConnectResponse) updates) =>
      super.copyWith((message) => updates(message as ConnectResponse))
          as ConnectResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ConnectResponse create() => ConnectResponse._();
  @$core.override
  ConnectResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ConnectResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConnectResponse>(create);
  static ConnectResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Connection get connection => $_getN(0);
  @$pb.TagNumber(1)
  set connection(Connection value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasConnection() => $_has(0);
  @$pb.TagNumber(1)
  void clearConnection() => $_clearField(1);
  @$pb.TagNumber(1)
  Connection ensureConnection() => $_ensure(0);
}

class DisconnectRequest extends $pb.GeneratedMessage {
  factory DisconnectRequest({
    $core.String? connectionId,
  }) {
    final result = create();
    if (connectionId != null) result.connectionId = connectionId;
    return result;
  }

  DisconnectRequest._();

  factory DisconnectRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DisconnectRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DisconnectRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'connectionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DisconnectRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DisconnectRequest copyWith(void Function(DisconnectRequest) updates) =>
      super.copyWith((message) => updates(message as DisconnectRequest))
          as DisconnectRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DisconnectRequest create() => DisconnectRequest._();
  @$core.override
  DisconnectRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DisconnectRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DisconnectRequest>(create);
  static DisconnectRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get connectionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set connectionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasConnectionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearConnectionId() => $_clearField(1);
}

class ListConnectionsRequest extends $pb.GeneratedMessage {
  factory ListConnectionsRequest() => create();

  ListConnectionsRequest._();

  factory ListConnectionsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListConnectionsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListConnectionsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListConnectionsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListConnectionsRequest copyWith(
          void Function(ListConnectionsRequest) updates) =>
      super.copyWith((message) => updates(message as ListConnectionsRequest))
          as ListConnectionsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListConnectionsRequest create() => ListConnectionsRequest._();
  @$core.override
  ListConnectionsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListConnectionsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListConnectionsRequest>(create);
  static ListConnectionsRequest? _defaultInstance;
}

class ListConnectionsResponse extends $pb.GeneratedMessage {
  factory ListConnectionsResponse({
    $core.Iterable<Connection>? connections,
  }) {
    final result = create();
    if (connections != null) result.connections.addAll(connections);
    return result;
  }

  ListConnectionsResponse._();

  factory ListConnectionsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListConnectionsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListConnectionsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..pPM<Connection>(1, _omitFieldNames ? '' : 'connections',
        subBuilder: Connection.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListConnectionsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListConnectionsResponse copyWith(
          void Function(ListConnectionsResponse) updates) =>
      super.copyWith((message) => updates(message as ListConnectionsResponse))
          as ListConnectionsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListConnectionsResponse create() => ListConnectionsResponse._();
  @$core.override
  ListConnectionsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListConnectionsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListConnectionsResponse>(create);
  static ListConnectionsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Connection> get connections => $_getList(0);
}

class ExecuteCommandRequest extends $pb.GeneratedMessage {
  factory ExecuteCommandRequest({
    $core.String? connectionId,
    $core.String? command,
    $core.int? timeoutSeconds,
  }) {
    final result = create();
    if (connectionId != null) result.connectionId = connectionId;
    if (command != null) result.command = command;
    if (timeoutSeconds != null) result.timeoutSeconds = timeoutSeconds;
    return result;
  }

  ExecuteCommandRequest._();

  factory ExecuteCommandRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ExecuteCommandRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExecuteCommandRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'connectionId')
    ..aOS(2, _omitFieldNames ? '' : 'command')
    ..aI(3, _omitFieldNames ? '' : 'timeoutSeconds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExecuteCommandRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExecuteCommandRequest copyWith(
          void Function(ExecuteCommandRequest) updates) =>
      super.copyWith((message) => updates(message as ExecuteCommandRequest))
          as ExecuteCommandRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExecuteCommandRequest create() => ExecuteCommandRequest._();
  @$core.override
  ExecuteCommandRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ExecuteCommandRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExecuteCommandRequest>(create);
  static ExecuteCommandRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get connectionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set connectionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasConnectionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearConnectionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get command => $_getSZ(1);
  @$pb.TagNumber(2)
  set command($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCommand() => $_has(1);
  @$pb.TagNumber(2)
  void clearCommand() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get timeoutSeconds => $_getIZ(2);
  @$pb.TagNumber(3)
  set timeoutSeconds($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTimeoutSeconds() => $_has(2);
  @$pb.TagNumber(3)
  void clearTimeoutSeconds() => $_clearField(3);
}

class ExecuteCommandResponse extends $pb.GeneratedMessage {
  factory ExecuteCommandResponse({
    $core.int? exitCode,
    $core.String? stdout,
    $core.String? stderr,
  }) {
    final result = create();
    if (exitCode != null) result.exitCode = exitCode;
    if (stdout != null) result.stdout = stdout;
    if (stderr != null) result.stderr = stderr;
    return result;
  }

  ExecuteCommandResponse._();

  factory ExecuteCommandResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ExecuteCommandResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExecuteCommandResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'exitCode')
    ..aOS(2, _omitFieldNames ? '' : 'stdout')
    ..aOS(3, _omitFieldNames ? '' : 'stderr')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExecuteCommandResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExecuteCommandResponse copyWith(
          void Function(ExecuteCommandResponse) updates) =>
      super.copyWith((message) => updates(message as ExecuteCommandResponse))
          as ExecuteCommandResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExecuteCommandResponse create() => ExecuteCommandResponse._();
  @$core.override
  ExecuteCommandResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ExecuteCommandResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExecuteCommandResponse>(create);
  static ExecuteCommandResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get exitCode => $_getIZ(0);
  @$pb.TagNumber(1)
  set exitCode($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasExitCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearExitCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get stdout => $_getSZ(1);
  @$pb.TagNumber(2)
  set stdout($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStdout() => $_has(1);
  @$pb.TagNumber(2)
  void clearStdout() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get stderr => $_getSZ(2);
  @$pb.TagNumber(3)
  set stderr($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasStderr() => $_has(2);
  @$pb.TagNumber(3)
  void clearStderr() => $_clearField(3);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
