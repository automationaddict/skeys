//
//  Generated code. Do not modify.
//  source: skeys/v1/metadata.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// KeyMetadata contains metadata associated with an SSH key
class KeyMetadata extends $pb.GeneratedMessage {
  factory KeyMetadata({
    $core.String? keyPath,
    $core.String? verifiedService,
    $core.String? verifiedHost,
    $core.int? verifiedPort,
    $core.String? verifiedUser,
  }) {
    final $result = create();
    if (keyPath != null) {
      $result.keyPath = keyPath;
    }
    if (verifiedService != null) {
      $result.verifiedService = verifiedService;
    }
    if (verifiedHost != null) {
      $result.verifiedHost = verifiedHost;
    }
    if (verifiedPort != null) {
      $result.verifiedPort = verifiedPort;
    }
    if (verifiedUser != null) {
      $result.verifiedUser = verifiedUser;
    }
    return $result;
  }
  KeyMetadata._() : super();
  factory KeyMetadata.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory KeyMetadata.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'KeyMetadata', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'keyPath')
    ..aOS(2, _omitFieldNames ? '' : 'verifiedService')
    ..aOS(3, _omitFieldNames ? '' : 'verifiedHost')
    ..a<$core.int>(4, _omitFieldNames ? '' : 'verifiedPort', $pb.PbFieldType.O3)
    ..aOS(5, _omitFieldNames ? '' : 'verifiedUser')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  KeyMetadata clone() => KeyMetadata()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  KeyMetadata copyWith(void Function(KeyMetadata) updates) => super.copyWith((message) => updates(message as KeyMetadata)) as KeyMetadata;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static KeyMetadata create() => KeyMetadata._();
  KeyMetadata createEmptyInstance() => create();
  static $pb.PbList<KeyMetadata> createRepeated() => $pb.PbList<KeyMetadata>();
  @$core.pragma('dart2js:noInline')
  static KeyMetadata getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<KeyMetadata>(create);
  static KeyMetadata? _defaultInstance;

  /// key_path is the absolute path to the private key file
  @$pb.TagNumber(1)
  $core.String get keyPath => $_getSZ(0);
  @$pb.TagNumber(1)
  set keyPath($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasKeyPath() => $_has(0);
  @$pb.TagNumber(1)
  void clearKeyPath() => clearField(1);

  /// verified_service is the service name (e.g., "github.com") used for verification
  @$pb.TagNumber(2)
  $core.String get verifiedService => $_getSZ(1);
  @$pb.TagNumber(2)
  set verifiedService($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasVerifiedService() => $_has(1);
  @$pb.TagNumber(2)
  void clearVerifiedService() => clearField(2);

  /// verified_host is the host used for verification
  @$pb.TagNumber(3)
  $core.String get verifiedHost => $_getSZ(2);
  @$pb.TagNumber(3)
  set verifiedHost($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasVerifiedHost() => $_has(2);
  @$pb.TagNumber(3)
  void clearVerifiedHost() => clearField(3);

  /// verified_port is the port used for verification
  @$pb.TagNumber(4)
  $core.int get verifiedPort => $_getIZ(3);
  @$pb.TagNumber(4)
  set verifiedPort($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasVerifiedPort() => $_has(3);
  @$pb.TagNumber(4)
  void clearVerifiedPort() => clearField(4);

  /// verified_user is the user used for verification
  @$pb.TagNumber(5)
  $core.String get verifiedUser => $_getSZ(4);
  @$pb.TagNumber(5)
  set verifiedUser($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasVerifiedUser() => $_has(4);
  @$pb.TagNumber(5)
  void clearVerifiedUser() => clearField(5);
}

class GetKeyMetadataRequest extends $pb.GeneratedMessage {
  factory GetKeyMetadataRequest({
    $core.String? keyPath,
  }) {
    final $result = create();
    if (keyPath != null) {
      $result.keyPath = keyPath;
    }
    return $result;
  }
  GetKeyMetadataRequest._() : super();
  factory GetKeyMetadataRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetKeyMetadataRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetKeyMetadataRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'keyPath')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetKeyMetadataRequest clone() => GetKeyMetadataRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetKeyMetadataRequest copyWith(void Function(GetKeyMetadataRequest) updates) => super.copyWith((message) => updates(message as GetKeyMetadataRequest)) as GetKeyMetadataRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetKeyMetadataRequest create() => GetKeyMetadataRequest._();
  GetKeyMetadataRequest createEmptyInstance() => create();
  static $pb.PbList<GetKeyMetadataRequest> createRepeated() => $pb.PbList<GetKeyMetadataRequest>();
  @$core.pragma('dart2js:noInline')
  static GetKeyMetadataRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetKeyMetadataRequest>(create);
  static GetKeyMetadataRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get keyPath => $_getSZ(0);
  @$pb.TagNumber(1)
  set keyPath($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasKeyPath() => $_has(0);
  @$pb.TagNumber(1)
  void clearKeyPath() => clearField(1);
}

class SetKeyMetadataRequest extends $pb.GeneratedMessage {
  factory SetKeyMetadataRequest({
    KeyMetadata? metadata,
  }) {
    final $result = create();
    if (metadata != null) {
      $result.metadata = metadata;
    }
    return $result;
  }
  SetKeyMetadataRequest._() : super();
  factory SetKeyMetadataRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SetKeyMetadataRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SetKeyMetadataRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..aOM<KeyMetadata>(1, _omitFieldNames ? '' : 'metadata', subBuilder: KeyMetadata.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SetKeyMetadataRequest clone() => SetKeyMetadataRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SetKeyMetadataRequest copyWith(void Function(SetKeyMetadataRequest) updates) => super.copyWith((message) => updates(message as SetKeyMetadataRequest)) as SetKeyMetadataRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetKeyMetadataRequest create() => SetKeyMetadataRequest._();
  SetKeyMetadataRequest createEmptyInstance() => create();
  static $pb.PbList<SetKeyMetadataRequest> createRepeated() => $pb.PbList<SetKeyMetadataRequest>();
  @$core.pragma('dart2js:noInline')
  static SetKeyMetadataRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SetKeyMetadataRequest>(create);
  static SetKeyMetadataRequest? _defaultInstance;

  @$pb.TagNumber(1)
  KeyMetadata get metadata => $_getN(0);
  @$pb.TagNumber(1)
  set metadata(KeyMetadata v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasMetadata() => $_has(0);
  @$pb.TagNumber(1)
  void clearMetadata() => clearField(1);
  @$pb.TagNumber(1)
  KeyMetadata ensureMetadata() => $_ensure(0);
}

class DeleteKeyMetadataRequest extends $pb.GeneratedMessage {
  factory DeleteKeyMetadataRequest({
    $core.String? keyPath,
  }) {
    final $result = create();
    if (keyPath != null) {
      $result.keyPath = keyPath;
    }
    return $result;
  }
  DeleteKeyMetadataRequest._() : super();
  factory DeleteKeyMetadataRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeleteKeyMetadataRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DeleteKeyMetadataRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'keyPath')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeleteKeyMetadataRequest clone() => DeleteKeyMetadataRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeleteKeyMetadataRequest copyWith(void Function(DeleteKeyMetadataRequest) updates) => super.copyWith((message) => updates(message as DeleteKeyMetadataRequest)) as DeleteKeyMetadataRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteKeyMetadataRequest create() => DeleteKeyMetadataRequest._();
  DeleteKeyMetadataRequest createEmptyInstance() => create();
  static $pb.PbList<DeleteKeyMetadataRequest> createRepeated() => $pb.PbList<DeleteKeyMetadataRequest>();
  @$core.pragma('dart2js:noInline')
  static DeleteKeyMetadataRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeleteKeyMetadataRequest>(create);
  static DeleteKeyMetadataRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get keyPath => $_getSZ(0);
  @$pb.TagNumber(1)
  set keyPath($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasKeyPath() => $_has(0);
  @$pb.TagNumber(1)
  void clearKeyPath() => clearField(1);
}

class ListKeyMetadataRequest extends $pb.GeneratedMessage {
  factory ListKeyMetadataRequest() => create();
  ListKeyMetadataRequest._() : super();
  factory ListKeyMetadataRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListKeyMetadataRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListKeyMetadataRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListKeyMetadataRequest clone() => ListKeyMetadataRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListKeyMetadataRequest copyWith(void Function(ListKeyMetadataRequest) updates) => super.copyWith((message) => updates(message as ListKeyMetadataRequest)) as ListKeyMetadataRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListKeyMetadataRequest create() => ListKeyMetadataRequest._();
  ListKeyMetadataRequest createEmptyInstance() => create();
  static $pb.PbList<ListKeyMetadataRequest> createRepeated() => $pb.PbList<ListKeyMetadataRequest>();
  @$core.pragma('dart2js:noInline')
  static ListKeyMetadataRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListKeyMetadataRequest>(create);
  static ListKeyMetadataRequest? _defaultInstance;
}

class ListKeyMetadataResponse extends $pb.GeneratedMessage {
  factory ListKeyMetadataResponse({
    $core.Iterable<KeyMetadata>? metadata,
  }) {
    final $result = create();
    if (metadata != null) {
      $result.metadata.addAll(metadata);
    }
    return $result;
  }
  ListKeyMetadataResponse._() : super();
  factory ListKeyMetadataResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListKeyMetadataResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListKeyMetadataResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..pc<KeyMetadata>(1, _omitFieldNames ? '' : 'metadata', $pb.PbFieldType.PM, subBuilder: KeyMetadata.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListKeyMetadataResponse clone() => ListKeyMetadataResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListKeyMetadataResponse copyWith(void Function(ListKeyMetadataResponse) updates) => super.copyWith((message) => updates(message as ListKeyMetadataResponse)) as ListKeyMetadataResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListKeyMetadataResponse create() => ListKeyMetadataResponse._();
  ListKeyMetadataResponse createEmptyInstance() => create();
  static $pb.PbList<ListKeyMetadataResponse> createRepeated() => $pb.PbList<ListKeyMetadataResponse>();
  @$core.pragma('dart2js:noInline')
  static ListKeyMetadataResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListKeyMetadataResponse>(create);
  static ListKeyMetadataResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<KeyMetadata> get metadata => $_getList(0);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
