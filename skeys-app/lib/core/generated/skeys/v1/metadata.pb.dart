// This is a generated file - do not edit.
//
// Generated from skeys/v1/metadata.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

/// KeyMetadata contains metadata associated with an SSH key
class KeyMetadata extends $pb.GeneratedMessage {
  factory KeyMetadata({
    $core.String? keyPath,
    $core.String? verifiedService,
    $core.String? verifiedHost,
    $core.int? verifiedPort,
    $core.String? verifiedUser,
  }) {
    final result = create();
    if (keyPath != null) result.keyPath = keyPath;
    if (verifiedService != null) result.verifiedService = verifiedService;
    if (verifiedHost != null) result.verifiedHost = verifiedHost;
    if (verifiedPort != null) result.verifiedPort = verifiedPort;
    if (verifiedUser != null) result.verifiedUser = verifiedUser;
    return result;
  }

  KeyMetadata._();

  factory KeyMetadata.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory KeyMetadata.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'KeyMetadata',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'keyPath')
    ..aOS(2, _omitFieldNames ? '' : 'verifiedService')
    ..aOS(3, _omitFieldNames ? '' : 'verifiedHost')
    ..aI(4, _omitFieldNames ? '' : 'verifiedPort')
    ..aOS(5, _omitFieldNames ? '' : 'verifiedUser')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  KeyMetadata clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  KeyMetadata copyWith(void Function(KeyMetadata) updates) =>
      super.copyWith((message) => updates(message as KeyMetadata))
          as KeyMetadata;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static KeyMetadata create() => KeyMetadata._();
  @$core.override
  KeyMetadata createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static KeyMetadata getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<KeyMetadata>(create);
  static KeyMetadata? _defaultInstance;

  /// key_path is the absolute path to the private key file
  @$pb.TagNumber(1)
  $core.String get keyPath => $_getSZ(0);
  @$pb.TagNumber(1)
  set keyPath($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasKeyPath() => $_has(0);
  @$pb.TagNumber(1)
  void clearKeyPath() => $_clearField(1);

  /// verified_service is the service name (e.g., "github.com") used for verification
  @$pb.TagNumber(2)
  $core.String get verifiedService => $_getSZ(1);
  @$pb.TagNumber(2)
  set verifiedService($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVerifiedService() => $_has(1);
  @$pb.TagNumber(2)
  void clearVerifiedService() => $_clearField(2);

  /// verified_host is the host used for verification
  @$pb.TagNumber(3)
  $core.String get verifiedHost => $_getSZ(2);
  @$pb.TagNumber(3)
  set verifiedHost($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasVerifiedHost() => $_has(2);
  @$pb.TagNumber(3)
  void clearVerifiedHost() => $_clearField(3);

  /// verified_port is the port used for verification
  @$pb.TagNumber(4)
  $core.int get verifiedPort => $_getIZ(3);
  @$pb.TagNumber(4)
  set verifiedPort($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasVerifiedPort() => $_has(3);
  @$pb.TagNumber(4)
  void clearVerifiedPort() => $_clearField(4);

  /// verified_user is the user used for verification
  @$pb.TagNumber(5)
  $core.String get verifiedUser => $_getSZ(4);
  @$pb.TagNumber(5)
  set verifiedUser($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasVerifiedUser() => $_has(4);
  @$pb.TagNumber(5)
  void clearVerifiedUser() => $_clearField(5);
}

class GetKeyMetadataRequest extends $pb.GeneratedMessage {
  factory GetKeyMetadataRequest({
    $core.String? keyPath,
  }) {
    final result = create();
    if (keyPath != null) result.keyPath = keyPath;
    return result;
  }

  GetKeyMetadataRequest._();

  factory GetKeyMetadataRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetKeyMetadataRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetKeyMetadataRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'keyPath')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetKeyMetadataRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetKeyMetadataRequest copyWith(
          void Function(GetKeyMetadataRequest) updates) =>
      super.copyWith((message) => updates(message as GetKeyMetadataRequest))
          as GetKeyMetadataRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetKeyMetadataRequest create() => GetKeyMetadataRequest._();
  @$core.override
  GetKeyMetadataRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetKeyMetadataRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetKeyMetadataRequest>(create);
  static GetKeyMetadataRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get keyPath => $_getSZ(0);
  @$pb.TagNumber(1)
  set keyPath($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasKeyPath() => $_has(0);
  @$pb.TagNumber(1)
  void clearKeyPath() => $_clearField(1);
}

class SetKeyMetadataRequest extends $pb.GeneratedMessage {
  factory SetKeyMetadataRequest({
    KeyMetadata? metadata,
  }) {
    final result = create();
    if (metadata != null) result.metadata = metadata;
    return result;
  }

  SetKeyMetadataRequest._();

  factory SetKeyMetadataRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetKeyMetadataRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetKeyMetadataRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOM<KeyMetadata>(1, _omitFieldNames ? '' : 'metadata',
        subBuilder: KeyMetadata.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetKeyMetadataRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetKeyMetadataRequest copyWith(
          void Function(SetKeyMetadataRequest) updates) =>
      super.copyWith((message) => updates(message as SetKeyMetadataRequest))
          as SetKeyMetadataRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetKeyMetadataRequest create() => SetKeyMetadataRequest._();
  @$core.override
  SetKeyMetadataRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetKeyMetadataRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetKeyMetadataRequest>(create);
  static SetKeyMetadataRequest? _defaultInstance;

  @$pb.TagNumber(1)
  KeyMetadata get metadata => $_getN(0);
  @$pb.TagNumber(1)
  set metadata(KeyMetadata value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMetadata() => $_has(0);
  @$pb.TagNumber(1)
  void clearMetadata() => $_clearField(1);
  @$pb.TagNumber(1)
  KeyMetadata ensureMetadata() => $_ensure(0);
}

class DeleteKeyMetadataRequest extends $pb.GeneratedMessage {
  factory DeleteKeyMetadataRequest({
    $core.String? keyPath,
  }) {
    final result = create();
    if (keyPath != null) result.keyPath = keyPath;
    return result;
  }

  DeleteKeyMetadataRequest._();

  factory DeleteKeyMetadataRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteKeyMetadataRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteKeyMetadataRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'keyPath')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteKeyMetadataRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteKeyMetadataRequest copyWith(
          void Function(DeleteKeyMetadataRequest) updates) =>
      super.copyWith((message) => updates(message as DeleteKeyMetadataRequest))
          as DeleteKeyMetadataRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteKeyMetadataRequest create() => DeleteKeyMetadataRequest._();
  @$core.override
  DeleteKeyMetadataRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeleteKeyMetadataRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteKeyMetadataRequest>(create);
  static DeleteKeyMetadataRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get keyPath => $_getSZ(0);
  @$pb.TagNumber(1)
  set keyPath($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasKeyPath() => $_has(0);
  @$pb.TagNumber(1)
  void clearKeyPath() => $_clearField(1);
}

class ListKeyMetadataRequest extends $pb.GeneratedMessage {
  factory ListKeyMetadataRequest() => create();

  ListKeyMetadataRequest._();

  factory ListKeyMetadataRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListKeyMetadataRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListKeyMetadataRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListKeyMetadataRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListKeyMetadataRequest copyWith(
          void Function(ListKeyMetadataRequest) updates) =>
      super.copyWith((message) => updates(message as ListKeyMetadataRequest))
          as ListKeyMetadataRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListKeyMetadataRequest create() => ListKeyMetadataRequest._();
  @$core.override
  ListKeyMetadataRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListKeyMetadataRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListKeyMetadataRequest>(create);
  static ListKeyMetadataRequest? _defaultInstance;
}

class ListKeyMetadataResponse extends $pb.GeneratedMessage {
  factory ListKeyMetadataResponse({
    $core.Iterable<KeyMetadata>? metadata,
  }) {
    final result = create();
    if (metadata != null) result.metadata.addAll(metadata);
    return result;
  }

  ListKeyMetadataResponse._();

  factory ListKeyMetadataResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListKeyMetadataResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListKeyMetadataResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..pPM<KeyMetadata>(1, _omitFieldNames ? '' : 'metadata',
        subBuilder: KeyMetadata.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListKeyMetadataResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListKeyMetadataResponse copyWith(
          void Function(ListKeyMetadataResponse) updates) =>
      super.copyWith((message) => updates(message as ListKeyMetadataResponse))
          as ListKeyMetadataResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListKeyMetadataResponse create() => ListKeyMetadataResponse._();
  @$core.override
  ListKeyMetadataResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListKeyMetadataResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListKeyMetadataResponse>(create);
  static ListKeyMetadataResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<KeyMetadata> get metadata => $_getList(0);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
