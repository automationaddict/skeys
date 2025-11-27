//
//  Generated code. Do not modify.
//  source: skeys/v1/remote.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../../google/protobuf/timestamp.pb.dart' as $8;
import 'remote.pbenum.dart';

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
    $8.Timestamp? createdAt,
    $8.Timestamp? lastConnectedAt,
    RemoteStatus? status,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (name != null) {
      $result.name = name;
    }
    if (host != null) {
      $result.host = host;
    }
    if (port != null) {
      $result.port = port;
    }
    if (user != null) {
      $result.user = user;
    }
    if (identityFile != null) {
      $result.identityFile = identityFile;
    }
    if (sshConfigAlias != null) {
      $result.sshConfigAlias = sshConfigAlias;
    }
    if (createdAt != null) {
      $result.createdAt = createdAt;
    }
    if (lastConnectedAt != null) {
      $result.lastConnectedAt = lastConnectedAt;
    }
    if (status != null) {
      $result.status = status;
    }
    return $result;
  }
  Remote._() : super();
  factory Remote.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Remote.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Remote', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'host')
    ..a<$core.int>(4, _omitFieldNames ? '' : 'port', $pb.PbFieldType.O3)
    ..aOS(5, _omitFieldNames ? '' : 'user')
    ..aOS(6, _omitFieldNames ? '' : 'identityFile')
    ..aOS(7, _omitFieldNames ? '' : 'sshConfigAlias')
    ..aOM<$8.Timestamp>(8, _omitFieldNames ? '' : 'createdAt', subBuilder: $8.Timestamp.create)
    ..aOM<$8.Timestamp>(9, _omitFieldNames ? '' : 'lastConnectedAt', subBuilder: $8.Timestamp.create)
    ..e<RemoteStatus>(10, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OE, defaultOrMaker: RemoteStatus.REMOTE_STATUS_UNSPECIFIED, valueOf: RemoteStatus.valueOf, enumValues: RemoteStatus.values)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Remote clone() => Remote()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Remote copyWith(void Function(Remote) updates) => super.copyWith((message) => updates(message as Remote)) as Remote;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Remote create() => Remote._();
  Remote createEmptyInstance() => create();
  static $pb.PbList<Remote> createRepeated() => $pb.PbList<Remote>();
  @$core.pragma('dart2js:noInline')
  static Remote getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Remote>(create);
  static Remote? _defaultInstance;

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
  $core.String get host => $_getSZ(2);
  @$pb.TagNumber(3)
  set host($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasHost() => $_has(2);
  @$pb.TagNumber(3)
  void clearHost() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get port => $_getIZ(3);
  @$pb.TagNumber(4)
  set port($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasPort() => $_has(3);
  @$pb.TagNumber(4)
  void clearPort() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get user => $_getSZ(4);
  @$pb.TagNumber(5)
  set user($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasUser() => $_has(4);
  @$pb.TagNumber(5)
  void clearUser() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get identityFile => $_getSZ(5);
  @$pb.TagNumber(6)
  set identityFile($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasIdentityFile() => $_has(5);
  @$pb.TagNumber(6)
  void clearIdentityFile() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get sshConfigAlias => $_getSZ(6);
  @$pb.TagNumber(7)
  set sshConfigAlias($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasSshConfigAlias() => $_has(6);
  @$pb.TagNumber(7)
  void clearSshConfigAlias() => clearField(7);

  @$pb.TagNumber(8)
  $8.Timestamp get createdAt => $_getN(7);
  @$pb.TagNumber(8)
  set createdAt($8.Timestamp v) { setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasCreatedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearCreatedAt() => clearField(8);
  @$pb.TagNumber(8)
  $8.Timestamp ensureCreatedAt() => $_ensure(7);

  @$pb.TagNumber(9)
  $8.Timestamp get lastConnectedAt => $_getN(8);
  @$pb.TagNumber(9)
  set lastConnectedAt($8.Timestamp v) { setField(9, v); }
  @$pb.TagNumber(9)
  $core.bool hasLastConnectedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearLastConnectedAt() => clearField(9);
  @$pb.TagNumber(9)
  $8.Timestamp ensureLastConnectedAt() => $_ensure(8);

  @$pb.TagNumber(10)
  RemoteStatus get status => $_getN(9);
  @$pb.TagNumber(10)
  set status(RemoteStatus v) { setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasStatus() => $_has(9);
  @$pb.TagNumber(10)
  void clearStatus() => clearField(10);
}

class Connection extends $pb.GeneratedMessage {
  factory Connection({
    $core.String? id,
    $core.String? remoteId,
    $core.String? host,
    $core.int? port,
    $core.String? user,
    $core.String? serverVersion,
    $8.Timestamp? connectedAt,
    $8.Timestamp? lastActivityAt,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (remoteId != null) {
      $result.remoteId = remoteId;
    }
    if (host != null) {
      $result.host = host;
    }
    if (port != null) {
      $result.port = port;
    }
    if (user != null) {
      $result.user = user;
    }
    if (serverVersion != null) {
      $result.serverVersion = serverVersion;
    }
    if (connectedAt != null) {
      $result.connectedAt = connectedAt;
    }
    if (lastActivityAt != null) {
      $result.lastActivityAt = lastActivityAt;
    }
    return $result;
  }
  Connection._() : super();
  factory Connection.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Connection.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Connection', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'remoteId')
    ..aOS(3, _omitFieldNames ? '' : 'host')
    ..a<$core.int>(4, _omitFieldNames ? '' : 'port', $pb.PbFieldType.O3)
    ..aOS(5, _omitFieldNames ? '' : 'user')
    ..aOS(6, _omitFieldNames ? '' : 'serverVersion')
    ..aOM<$8.Timestamp>(7, _omitFieldNames ? '' : 'connectedAt', subBuilder: $8.Timestamp.create)
    ..aOM<$8.Timestamp>(8, _omitFieldNames ? '' : 'lastActivityAt', subBuilder: $8.Timestamp.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Connection clone() => Connection()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Connection copyWith(void Function(Connection) updates) => super.copyWith((message) => updates(message as Connection)) as Connection;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Connection create() => Connection._();
  Connection createEmptyInstance() => create();
  static $pb.PbList<Connection> createRepeated() => $pb.PbList<Connection>();
  @$core.pragma('dart2js:noInline')
  static Connection getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Connection>(create);
  static Connection? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get remoteId => $_getSZ(1);
  @$pb.TagNumber(2)
  set remoteId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasRemoteId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRemoteId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get host => $_getSZ(2);
  @$pb.TagNumber(3)
  set host($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasHost() => $_has(2);
  @$pb.TagNumber(3)
  void clearHost() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get port => $_getIZ(3);
  @$pb.TagNumber(4)
  set port($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasPort() => $_has(3);
  @$pb.TagNumber(4)
  void clearPort() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get user => $_getSZ(4);
  @$pb.TagNumber(5)
  set user($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasUser() => $_has(4);
  @$pb.TagNumber(5)
  void clearUser() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get serverVersion => $_getSZ(5);
  @$pb.TagNumber(6)
  set serverVersion($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasServerVersion() => $_has(5);
  @$pb.TagNumber(6)
  void clearServerVersion() => clearField(6);

  @$pb.TagNumber(7)
  $8.Timestamp get connectedAt => $_getN(6);
  @$pb.TagNumber(7)
  set connectedAt($8.Timestamp v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasConnectedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearConnectedAt() => clearField(7);
  @$pb.TagNumber(7)
  $8.Timestamp ensureConnectedAt() => $_ensure(6);

  @$pb.TagNumber(8)
  $8.Timestamp get lastActivityAt => $_getN(7);
  @$pb.TagNumber(8)
  set lastActivityAt($8.Timestamp v) { setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasLastActivityAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearLastActivityAt() => clearField(8);
  @$pb.TagNumber(8)
  $8.Timestamp ensureLastActivityAt() => $_ensure(7);
}

class ListRemotesRequest extends $pb.GeneratedMessage {
  factory ListRemotesRequest() => create();
  ListRemotesRequest._() : super();
  factory ListRemotesRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListRemotesRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListRemotesRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListRemotesRequest clone() => ListRemotesRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListRemotesRequest copyWith(void Function(ListRemotesRequest) updates) => super.copyWith((message) => updates(message as ListRemotesRequest)) as ListRemotesRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListRemotesRequest create() => ListRemotesRequest._();
  ListRemotesRequest createEmptyInstance() => create();
  static $pb.PbList<ListRemotesRequest> createRepeated() => $pb.PbList<ListRemotesRequest>();
  @$core.pragma('dart2js:noInline')
  static ListRemotesRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListRemotesRequest>(create);
  static ListRemotesRequest? _defaultInstance;
}

class ListRemotesResponse extends $pb.GeneratedMessage {
  factory ListRemotesResponse({
    $core.Iterable<Remote>? remotes,
  }) {
    final $result = create();
    if (remotes != null) {
      $result.remotes.addAll(remotes);
    }
    return $result;
  }
  ListRemotesResponse._() : super();
  factory ListRemotesResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListRemotesResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListRemotesResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..pc<Remote>(1, _omitFieldNames ? '' : 'remotes', $pb.PbFieldType.PM, subBuilder: Remote.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListRemotesResponse clone() => ListRemotesResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListRemotesResponse copyWith(void Function(ListRemotesResponse) updates) => super.copyWith((message) => updates(message as ListRemotesResponse)) as ListRemotesResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListRemotesResponse create() => ListRemotesResponse._();
  ListRemotesResponse createEmptyInstance() => create();
  static $pb.PbList<ListRemotesResponse> createRepeated() => $pb.PbList<ListRemotesResponse>();
  @$core.pragma('dart2js:noInline')
  static ListRemotesResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListRemotesResponse>(create);
  static ListRemotesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<Remote> get remotes => $_getList(0);
}

class GetRemoteRequest extends $pb.GeneratedMessage {
  factory GetRemoteRequest({
    $core.String? id,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  GetRemoteRequest._() : super();
  factory GetRemoteRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetRemoteRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetRemoteRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetRemoteRequest clone() => GetRemoteRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetRemoteRequest copyWith(void Function(GetRemoteRequest) updates) => super.copyWith((message) => updates(message as GetRemoteRequest)) as GetRemoteRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetRemoteRequest create() => GetRemoteRequest._();
  GetRemoteRequest createEmptyInstance() => create();
  static $pb.PbList<GetRemoteRequest> createRepeated() => $pb.PbList<GetRemoteRequest>();
  @$core.pragma('dart2js:noInline')
  static GetRemoteRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetRemoteRequest>(create);
  static GetRemoteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);
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
    final $result = create();
    if (name != null) {
      $result.name = name;
    }
    if (host != null) {
      $result.host = host;
    }
    if (port != null) {
      $result.port = port;
    }
    if (user != null) {
      $result.user = user;
    }
    if (identityFile != null) {
      $result.identityFile = identityFile;
    }
    if (sshConfigAlias != null) {
      $result.sshConfigAlias = sshConfigAlias;
    }
    return $result;
  }
  AddRemoteRequest._() : super();
  factory AddRemoteRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AddRemoteRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AddRemoteRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'host')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'port', $pb.PbFieldType.O3)
    ..aOS(4, _omitFieldNames ? '' : 'user')
    ..aOS(5, _omitFieldNames ? '' : 'identityFile')
    ..aOS(6, _omitFieldNames ? '' : 'sshConfigAlias')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AddRemoteRequest clone() => AddRemoteRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AddRemoteRequest copyWith(void Function(AddRemoteRequest) updates) => super.copyWith((message) => updates(message as AddRemoteRequest)) as AddRemoteRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddRemoteRequest create() => AddRemoteRequest._();
  AddRemoteRequest createEmptyInstance() => create();
  static $pb.PbList<AddRemoteRequest> createRepeated() => $pb.PbList<AddRemoteRequest>();
  @$core.pragma('dart2js:noInline')
  static AddRemoteRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AddRemoteRequest>(create);
  static AddRemoteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get host => $_getSZ(1);
  @$pb.TagNumber(2)
  set host($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasHost() => $_has(1);
  @$pb.TagNumber(2)
  void clearHost() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get port => $_getIZ(2);
  @$pb.TagNumber(3)
  set port($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPort() => $_has(2);
  @$pb.TagNumber(3)
  void clearPort() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get user => $_getSZ(3);
  @$pb.TagNumber(4)
  set user($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasUser() => $_has(3);
  @$pb.TagNumber(4)
  void clearUser() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get identityFile => $_getSZ(4);
  @$pb.TagNumber(5)
  set identityFile($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasIdentityFile() => $_has(4);
  @$pb.TagNumber(5)
  void clearIdentityFile() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get sshConfigAlias => $_getSZ(5);
  @$pb.TagNumber(6)
  set sshConfigAlias($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasSshConfigAlias() => $_has(5);
  @$pb.TagNumber(6)
  void clearSshConfigAlias() => clearField(6);
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
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (name != null) {
      $result.name = name;
    }
    if (host != null) {
      $result.host = host;
    }
    if (port != null) {
      $result.port = port;
    }
    if (user != null) {
      $result.user = user;
    }
    if (identityFile != null) {
      $result.identityFile = identityFile;
    }
    if (sshConfigAlias != null) {
      $result.sshConfigAlias = sshConfigAlias;
    }
    return $result;
  }
  UpdateRemoteRequest._() : super();
  factory UpdateRemoteRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpdateRemoteRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UpdateRemoteRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'host')
    ..a<$core.int>(4, _omitFieldNames ? '' : 'port', $pb.PbFieldType.O3)
    ..aOS(5, _omitFieldNames ? '' : 'user')
    ..aOS(6, _omitFieldNames ? '' : 'identityFile')
    ..aOS(7, _omitFieldNames ? '' : 'sshConfigAlias')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpdateRemoteRequest clone() => UpdateRemoteRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpdateRemoteRequest copyWith(void Function(UpdateRemoteRequest) updates) => super.copyWith((message) => updates(message as UpdateRemoteRequest)) as UpdateRemoteRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateRemoteRequest create() => UpdateRemoteRequest._();
  UpdateRemoteRequest createEmptyInstance() => create();
  static $pb.PbList<UpdateRemoteRequest> createRepeated() => $pb.PbList<UpdateRemoteRequest>();
  @$core.pragma('dart2js:noInline')
  static UpdateRemoteRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateRemoteRequest>(create);
  static UpdateRemoteRequest? _defaultInstance;

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
  $core.String get host => $_getSZ(2);
  @$pb.TagNumber(3)
  set host($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasHost() => $_has(2);
  @$pb.TagNumber(3)
  void clearHost() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get port => $_getIZ(3);
  @$pb.TagNumber(4)
  set port($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasPort() => $_has(3);
  @$pb.TagNumber(4)
  void clearPort() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get user => $_getSZ(4);
  @$pb.TagNumber(5)
  set user($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasUser() => $_has(4);
  @$pb.TagNumber(5)
  void clearUser() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get identityFile => $_getSZ(5);
  @$pb.TagNumber(6)
  set identityFile($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasIdentityFile() => $_has(5);
  @$pb.TagNumber(6)
  void clearIdentityFile() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get sshConfigAlias => $_getSZ(6);
  @$pb.TagNumber(7)
  set sshConfigAlias($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasSshConfigAlias() => $_has(6);
  @$pb.TagNumber(7)
  void clearSshConfigAlias() => clearField(7);
}

class DeleteRemoteRequest extends $pb.GeneratedMessage {
  factory DeleteRemoteRequest({
    $core.String? id,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  DeleteRemoteRequest._() : super();
  factory DeleteRemoteRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeleteRemoteRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DeleteRemoteRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeleteRemoteRequest clone() => DeleteRemoteRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeleteRemoteRequest copyWith(void Function(DeleteRemoteRequest) updates) => super.copyWith((message) => updates(message as DeleteRemoteRequest)) as DeleteRemoteRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteRemoteRequest create() => DeleteRemoteRequest._();
  DeleteRemoteRequest createEmptyInstance() => create();
  static $pb.PbList<DeleteRemoteRequest> createRepeated() => $pb.PbList<DeleteRemoteRequest>();
  @$core.pragma('dart2js:noInline')
  static DeleteRemoteRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeleteRemoteRequest>(create);
  static DeleteRemoteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);
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
    final $result = create();
    if (remoteId != null) {
      $result.remoteId = remoteId;
    }
    if (host != null) {
      $result.host = host;
    }
    if (port != null) {
      $result.port = port;
    }
    if (user != null) {
      $result.user = user;
    }
    if (identityFile != null) {
      $result.identityFile = identityFile;
    }
    if (timeoutSeconds != null) {
      $result.timeoutSeconds = timeoutSeconds;
    }
    if (passphrase != null) {
      $result.passphrase = passphrase;
    }
    if (trustHostKey != null) {
      $result.trustHostKey = trustHostKey;
    }
    return $result;
  }
  TestRemoteConnectionRequest._() : super();
  factory TestRemoteConnectionRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TestRemoteConnectionRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TestRemoteConnectionRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'remoteId')
    ..aOS(2, _omitFieldNames ? '' : 'host')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'port', $pb.PbFieldType.O3)
    ..aOS(4, _omitFieldNames ? '' : 'user')
    ..aOS(5, _omitFieldNames ? '' : 'identityFile')
    ..a<$core.int>(6, _omitFieldNames ? '' : 'timeoutSeconds', $pb.PbFieldType.O3)
    ..aOS(7, _omitFieldNames ? '' : 'passphrase')
    ..aOB(8, _omitFieldNames ? '' : 'trustHostKey')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TestRemoteConnectionRequest clone() => TestRemoteConnectionRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TestRemoteConnectionRequest copyWith(void Function(TestRemoteConnectionRequest) updates) => super.copyWith((message) => updates(message as TestRemoteConnectionRequest)) as TestRemoteConnectionRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TestRemoteConnectionRequest create() => TestRemoteConnectionRequest._();
  TestRemoteConnectionRequest createEmptyInstance() => create();
  static $pb.PbList<TestRemoteConnectionRequest> createRepeated() => $pb.PbList<TestRemoteConnectionRequest>();
  @$core.pragma('dart2js:noInline')
  static TestRemoteConnectionRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TestRemoteConnectionRequest>(create);
  static TestRemoteConnectionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get remoteId => $_getSZ(0);
  @$pb.TagNumber(1)
  set remoteId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasRemoteId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRemoteId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get host => $_getSZ(1);
  @$pb.TagNumber(2)
  set host($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasHost() => $_has(1);
  @$pb.TagNumber(2)
  void clearHost() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get port => $_getIZ(2);
  @$pb.TagNumber(3)
  set port($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPort() => $_has(2);
  @$pb.TagNumber(3)
  void clearPort() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get user => $_getSZ(3);
  @$pb.TagNumber(4)
  set user($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasUser() => $_has(3);
  @$pb.TagNumber(4)
  void clearUser() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get identityFile => $_getSZ(4);
  @$pb.TagNumber(5)
  set identityFile($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasIdentityFile() => $_has(4);
  @$pb.TagNumber(5)
  void clearIdentityFile() => clearField(5);

  @$pb.TagNumber(6)
  $core.int get timeoutSeconds => $_getIZ(5);
  @$pb.TagNumber(6)
  set timeoutSeconds($core.int v) { $_setSignedInt32(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasTimeoutSeconds() => $_has(5);
  @$pb.TagNumber(6)
  void clearTimeoutSeconds() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get passphrase => $_getSZ(6);
  @$pb.TagNumber(7)
  set passphrase($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasPassphrase() => $_has(6);
  @$pb.TagNumber(7)
  void clearPassphrase() => clearField(7);

  @$pb.TagNumber(8)
  $core.bool get trustHostKey => $_getBF(7);
  @$pb.TagNumber(8)
  set trustHostKey($core.bool v) { $_setBool(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasTrustHostKey() => $_has(7);
  @$pb.TagNumber(8)
  void clearTrustHostKey() => clearField(8);
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
    if (fingerprint != null) {
      $result.fingerprint = fingerprint;
    }
    if (publicKey != null) {
      $result.publicKey = publicKey;
    }
    return $result;
  }
  HostKeyInfo._() : super();
  factory HostKeyInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory HostKeyInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'HostKeyInfo', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'hostname')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'port', $pb.PbFieldType.O3)
    ..aOS(3, _omitFieldNames ? '' : 'keyType')
    ..aOS(4, _omitFieldNames ? '' : 'fingerprint')
    ..aOS(5, _omitFieldNames ? '' : 'publicKey')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  HostKeyInfo clone() => HostKeyInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  HostKeyInfo copyWith(void Function(HostKeyInfo) updates) => super.copyWith((message) => updates(message as HostKeyInfo)) as HostKeyInfo;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HostKeyInfo create() => HostKeyInfo._();
  HostKeyInfo createEmptyInstance() => create();
  static $pb.PbList<HostKeyInfo> createRepeated() => $pb.PbList<HostKeyInfo>();
  @$core.pragma('dart2js:noInline')
  static HostKeyInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<HostKeyInfo>(create);
  static HostKeyInfo? _defaultInstance;

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
    if (hostKeyStatus != null) {
      $result.hostKeyStatus = hostKeyStatus;
    }
    if (hostKeyInfo != null) {
      $result.hostKeyInfo = hostKeyInfo;
    }
    return $result;
  }
  TestRemoteConnectionResponse._() : super();
  factory TestRemoteConnectionResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TestRemoteConnectionResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TestRemoteConnectionResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..aOS(3, _omitFieldNames ? '' : 'serverVersion')
    ..a<$core.int>(4, _omitFieldNames ? '' : 'latencyMs', $pb.PbFieldType.O3)
    ..e<HostKeyStatus>(5, _omitFieldNames ? '' : 'hostKeyStatus', $pb.PbFieldType.OE, defaultOrMaker: HostKeyStatus.HOST_KEY_STATUS_UNSPECIFIED, valueOf: HostKeyStatus.valueOf, enumValues: HostKeyStatus.values)
    ..aOM<HostKeyInfo>(6, _omitFieldNames ? '' : 'hostKeyInfo', subBuilder: HostKeyInfo.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TestRemoteConnectionResponse clone() => TestRemoteConnectionResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TestRemoteConnectionResponse copyWith(void Function(TestRemoteConnectionResponse) updates) => super.copyWith((message) => updates(message as TestRemoteConnectionResponse)) as TestRemoteConnectionResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TestRemoteConnectionResponse create() => TestRemoteConnectionResponse._();
  TestRemoteConnectionResponse createEmptyInstance() => create();
  static $pb.PbList<TestRemoteConnectionResponse> createRepeated() => $pb.PbList<TestRemoteConnectionResponse>();
  @$core.pragma('dart2js:noInline')
  static TestRemoteConnectionResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TestRemoteConnectionResponse>(create);
  static TestRemoteConnectionResponse? _defaultInstance;

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

  @$pb.TagNumber(5)
  HostKeyStatus get hostKeyStatus => $_getN(4);
  @$pb.TagNumber(5)
  set hostKeyStatus(HostKeyStatus v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasHostKeyStatus() => $_has(4);
  @$pb.TagNumber(5)
  void clearHostKeyStatus() => clearField(5);

  @$pb.TagNumber(6)
  HostKeyInfo get hostKeyInfo => $_getN(5);
  @$pb.TagNumber(6)
  set hostKeyInfo(HostKeyInfo v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasHostKeyInfo() => $_has(5);
  @$pb.TagNumber(6)
  void clearHostKeyInfo() => clearField(6);
  @$pb.TagNumber(6)
  HostKeyInfo ensureHostKeyInfo() => $_ensure(5);
}

class ConnectRequest extends $pb.GeneratedMessage {
  factory ConnectRequest({
    $core.String? remoteId,
    $core.String? passphrase,
  }) {
    final $result = create();
    if (remoteId != null) {
      $result.remoteId = remoteId;
    }
    if (passphrase != null) {
      $result.passphrase = passphrase;
    }
    return $result;
  }
  ConnectRequest._() : super();
  factory ConnectRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ConnectRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ConnectRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'remoteId')
    ..aOS(2, _omitFieldNames ? '' : 'passphrase')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ConnectRequest clone() => ConnectRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ConnectRequest copyWith(void Function(ConnectRequest) updates) => super.copyWith((message) => updates(message as ConnectRequest)) as ConnectRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ConnectRequest create() => ConnectRequest._();
  ConnectRequest createEmptyInstance() => create();
  static $pb.PbList<ConnectRequest> createRepeated() => $pb.PbList<ConnectRequest>();
  @$core.pragma('dart2js:noInline')
  static ConnectRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ConnectRequest>(create);
  static ConnectRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get remoteId => $_getSZ(0);
  @$pb.TagNumber(1)
  set remoteId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasRemoteId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRemoteId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get passphrase => $_getSZ(1);
  @$pb.TagNumber(2)
  set passphrase($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPassphrase() => $_has(1);
  @$pb.TagNumber(2)
  void clearPassphrase() => clearField(2);
}

class ConnectResponse extends $pb.GeneratedMessage {
  factory ConnectResponse({
    Connection? connection,
  }) {
    final $result = create();
    if (connection != null) {
      $result.connection = connection;
    }
    return $result;
  }
  ConnectResponse._() : super();
  factory ConnectResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ConnectResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ConnectResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..aOM<Connection>(1, _omitFieldNames ? '' : 'connection', subBuilder: Connection.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ConnectResponse clone() => ConnectResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ConnectResponse copyWith(void Function(ConnectResponse) updates) => super.copyWith((message) => updates(message as ConnectResponse)) as ConnectResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ConnectResponse create() => ConnectResponse._();
  ConnectResponse createEmptyInstance() => create();
  static $pb.PbList<ConnectResponse> createRepeated() => $pb.PbList<ConnectResponse>();
  @$core.pragma('dart2js:noInline')
  static ConnectResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ConnectResponse>(create);
  static ConnectResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Connection get connection => $_getN(0);
  @$pb.TagNumber(1)
  set connection(Connection v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasConnection() => $_has(0);
  @$pb.TagNumber(1)
  void clearConnection() => clearField(1);
  @$pb.TagNumber(1)
  Connection ensureConnection() => $_ensure(0);
}

class DisconnectRequest extends $pb.GeneratedMessage {
  factory DisconnectRequest({
    $core.String? connectionId,
  }) {
    final $result = create();
    if (connectionId != null) {
      $result.connectionId = connectionId;
    }
    return $result;
  }
  DisconnectRequest._() : super();
  factory DisconnectRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DisconnectRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DisconnectRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'connectionId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DisconnectRequest clone() => DisconnectRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DisconnectRequest copyWith(void Function(DisconnectRequest) updates) => super.copyWith((message) => updates(message as DisconnectRequest)) as DisconnectRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DisconnectRequest create() => DisconnectRequest._();
  DisconnectRequest createEmptyInstance() => create();
  static $pb.PbList<DisconnectRequest> createRepeated() => $pb.PbList<DisconnectRequest>();
  @$core.pragma('dart2js:noInline')
  static DisconnectRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DisconnectRequest>(create);
  static DisconnectRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get connectionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set connectionId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasConnectionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearConnectionId() => clearField(1);
}

class ListConnectionsRequest extends $pb.GeneratedMessage {
  factory ListConnectionsRequest() => create();
  ListConnectionsRequest._() : super();
  factory ListConnectionsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListConnectionsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListConnectionsRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListConnectionsRequest clone() => ListConnectionsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListConnectionsRequest copyWith(void Function(ListConnectionsRequest) updates) => super.copyWith((message) => updates(message as ListConnectionsRequest)) as ListConnectionsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListConnectionsRequest create() => ListConnectionsRequest._();
  ListConnectionsRequest createEmptyInstance() => create();
  static $pb.PbList<ListConnectionsRequest> createRepeated() => $pb.PbList<ListConnectionsRequest>();
  @$core.pragma('dart2js:noInline')
  static ListConnectionsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListConnectionsRequest>(create);
  static ListConnectionsRequest? _defaultInstance;
}

class ListConnectionsResponse extends $pb.GeneratedMessage {
  factory ListConnectionsResponse({
    $core.Iterable<Connection>? connections,
  }) {
    final $result = create();
    if (connections != null) {
      $result.connections.addAll(connections);
    }
    return $result;
  }
  ListConnectionsResponse._() : super();
  factory ListConnectionsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListConnectionsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListConnectionsResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..pc<Connection>(1, _omitFieldNames ? '' : 'connections', $pb.PbFieldType.PM, subBuilder: Connection.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListConnectionsResponse clone() => ListConnectionsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListConnectionsResponse copyWith(void Function(ListConnectionsResponse) updates) => super.copyWith((message) => updates(message as ListConnectionsResponse)) as ListConnectionsResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListConnectionsResponse create() => ListConnectionsResponse._();
  ListConnectionsResponse createEmptyInstance() => create();
  static $pb.PbList<ListConnectionsResponse> createRepeated() => $pb.PbList<ListConnectionsResponse>();
  @$core.pragma('dart2js:noInline')
  static ListConnectionsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListConnectionsResponse>(create);
  static ListConnectionsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<Connection> get connections => $_getList(0);
}

class ExecuteCommandRequest extends $pb.GeneratedMessage {
  factory ExecuteCommandRequest({
    $core.String? connectionId,
    $core.String? command,
    $core.int? timeoutSeconds,
  }) {
    final $result = create();
    if (connectionId != null) {
      $result.connectionId = connectionId;
    }
    if (command != null) {
      $result.command = command;
    }
    if (timeoutSeconds != null) {
      $result.timeoutSeconds = timeoutSeconds;
    }
    return $result;
  }
  ExecuteCommandRequest._() : super();
  factory ExecuteCommandRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ExecuteCommandRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ExecuteCommandRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'connectionId')
    ..aOS(2, _omitFieldNames ? '' : 'command')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'timeoutSeconds', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ExecuteCommandRequest clone() => ExecuteCommandRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ExecuteCommandRequest copyWith(void Function(ExecuteCommandRequest) updates) => super.copyWith((message) => updates(message as ExecuteCommandRequest)) as ExecuteCommandRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExecuteCommandRequest create() => ExecuteCommandRequest._();
  ExecuteCommandRequest createEmptyInstance() => create();
  static $pb.PbList<ExecuteCommandRequest> createRepeated() => $pb.PbList<ExecuteCommandRequest>();
  @$core.pragma('dart2js:noInline')
  static ExecuteCommandRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ExecuteCommandRequest>(create);
  static ExecuteCommandRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get connectionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set connectionId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasConnectionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearConnectionId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get command => $_getSZ(1);
  @$pb.TagNumber(2)
  set command($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCommand() => $_has(1);
  @$pb.TagNumber(2)
  void clearCommand() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get timeoutSeconds => $_getIZ(2);
  @$pb.TagNumber(3)
  set timeoutSeconds($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasTimeoutSeconds() => $_has(2);
  @$pb.TagNumber(3)
  void clearTimeoutSeconds() => clearField(3);
}

class ExecuteCommandResponse extends $pb.GeneratedMessage {
  factory ExecuteCommandResponse({
    $core.int? exitCode,
    $core.String? stdout,
    $core.String? stderr,
  }) {
    final $result = create();
    if (exitCode != null) {
      $result.exitCode = exitCode;
    }
    if (stdout != null) {
      $result.stdout = stdout;
    }
    if (stderr != null) {
      $result.stderr = stderr;
    }
    return $result;
  }
  ExecuteCommandResponse._() : super();
  factory ExecuteCommandResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ExecuteCommandResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ExecuteCommandResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'exitCode', $pb.PbFieldType.O3)
    ..aOS(2, _omitFieldNames ? '' : 'stdout')
    ..aOS(3, _omitFieldNames ? '' : 'stderr')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ExecuteCommandResponse clone() => ExecuteCommandResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ExecuteCommandResponse copyWith(void Function(ExecuteCommandResponse) updates) => super.copyWith((message) => updates(message as ExecuteCommandResponse)) as ExecuteCommandResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExecuteCommandResponse create() => ExecuteCommandResponse._();
  ExecuteCommandResponse createEmptyInstance() => create();
  static $pb.PbList<ExecuteCommandResponse> createRepeated() => $pb.PbList<ExecuteCommandResponse>();
  @$core.pragma('dart2js:noInline')
  static ExecuteCommandResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ExecuteCommandResponse>(create);
  static ExecuteCommandResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get exitCode => $_getIZ(0);
  @$pb.TagNumber(1)
  set exitCode($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasExitCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearExitCode() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get stdout => $_getSZ(1);
  @$pb.TagNumber(2)
  set stdout($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasStdout() => $_has(1);
  @$pb.TagNumber(2)
  void clearStdout() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get stderr => $_getSZ(2);
  @$pb.TagNumber(3)
  set stderr($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasStderr() => $_has(2);
  @$pb.TagNumber(3)
  void clearStderr() => clearField(3);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
