// This is a generated file - do not edit.
//
// Generated from skeys/v1/update.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;
import '../../google/protobuf/timestamp.pb.dart'
    as $2;

import 'update.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'update.pbenum.dart';

/// UpdateInfo contains information about an available update
class UpdateInfo extends $pb.GeneratedMessage {
  factory UpdateInfo({
    $core.bool? updateAvailable,
    $core.String? currentVersion,
    $core.String? latestVersion,
    $core.String? releaseUrl,
    $core.String? releaseNotes,
    $fixnum.Int64? downloadSize,
    $2.Timestamp? publishedAt,
    $core.bool? prerelease,
  }) {
    final result = create();
    if (updateAvailable != null) result.updateAvailable = updateAvailable;
    if (currentVersion != null) result.currentVersion = currentVersion;
    if (latestVersion != null) result.latestVersion = latestVersion;
    if (releaseUrl != null) result.releaseUrl = releaseUrl;
    if (releaseNotes != null) result.releaseNotes = releaseNotes;
    if (downloadSize != null) result.downloadSize = downloadSize;
    if (publishedAt != null) result.publishedAt = publishedAt;
    if (prerelease != null) result.prerelease = prerelease;
    return result;
  }

  UpdateInfo._();

  factory UpdateInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'updateAvailable')
    ..aOS(2, _omitFieldNames ? '' : 'currentVersion')
    ..aOS(3, _omitFieldNames ? '' : 'latestVersion')
    ..aOS(4, _omitFieldNames ? '' : 'releaseUrl')
    ..aOS(5, _omitFieldNames ? '' : 'releaseNotes')
    ..aInt64(6, _omitFieldNames ? '' : 'downloadSize')
    ..aOM<$2.Timestamp>(7, _omitFieldNames ? '' : 'publishedAt',
        subBuilder: $2.Timestamp.create)
    ..aOB(8, _omitFieldNames ? '' : 'prerelease')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateInfo copyWith(void Function(UpdateInfo) updates) =>
      super.copyWith((message) => updates(message as UpdateInfo)) as UpdateInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateInfo create() => UpdateInfo._();
  @$core.override
  UpdateInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateInfo>(create);
  static UpdateInfo? _defaultInstance;

  /// Whether an update is available
  @$pb.TagNumber(1)
  $core.bool get updateAvailable => $_getBF(0);
  @$pb.TagNumber(1)
  set updateAvailable($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUpdateAvailable() => $_has(0);
  @$pb.TagNumber(1)
  void clearUpdateAvailable() => $_clearField(1);

  /// Current installed version
  @$pb.TagNumber(2)
  $core.String get currentVersion => $_getSZ(1);
  @$pb.TagNumber(2)
  set currentVersion($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCurrentVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearCurrentVersion() => $_clearField(2);

  /// Latest available version
  @$pb.TagNumber(3)
  $core.String get latestVersion => $_getSZ(2);
  @$pb.TagNumber(3)
  set latestVersion($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLatestVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearLatestVersion() => $_clearField(3);

  /// URL to the release page on GitHub
  @$pb.TagNumber(4)
  $core.String get releaseUrl => $_getSZ(3);
  @$pb.TagNumber(4)
  set releaseUrl($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasReleaseUrl() => $_has(3);
  @$pb.TagNumber(4)
  void clearReleaseUrl() => $_clearField(4);

  /// Release notes/changelog
  @$pb.TagNumber(5)
  $core.String get releaseNotes => $_getSZ(4);
  @$pb.TagNumber(5)
  set releaseNotes($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasReleaseNotes() => $_has(4);
  @$pb.TagNumber(5)
  void clearReleaseNotes() => $_clearField(5);

  /// Size of the download in bytes
  @$pb.TagNumber(6)
  $fixnum.Int64 get downloadSize => $_getI64(5);
  @$pb.TagNumber(6)
  set downloadSize($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDownloadSize() => $_has(5);
  @$pb.TagNumber(6)
  void clearDownloadSize() => $_clearField(6);

  /// When the release was published
  @$pb.TagNumber(7)
  $2.Timestamp get publishedAt => $_getN(6);
  @$pb.TagNumber(7)
  set publishedAt($2.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasPublishedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearPublishedAt() => $_clearField(7);
  @$pb.TagNumber(7)
  $2.Timestamp ensurePublishedAt() => $_ensure(6);

  /// Whether this is a prerelease
  @$pb.TagNumber(8)
  $core.bool get prerelease => $_getBF(7);
  @$pb.TagNumber(8)
  set prerelease($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPrerelease() => $_has(7);
  @$pb.TagNumber(8)
  void clearPrerelease() => $_clearField(8);
}

/// DownloadUpdateRequest initiates a download
class DownloadUpdateRequest extends $pb.GeneratedMessage {
  factory DownloadUpdateRequest({
    $core.String? version,
  }) {
    final result = create();
    if (version != null) result.version = version;
    return result;
  }

  DownloadUpdateRequest._();

  factory DownloadUpdateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DownloadUpdateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DownloadUpdateRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DownloadUpdateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DownloadUpdateRequest copyWith(
          void Function(DownloadUpdateRequest) updates) =>
      super.copyWith((message) => updates(message as DownloadUpdateRequest))
          as DownloadUpdateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DownloadUpdateRequest create() => DownloadUpdateRequest._();
  @$core.override
  DownloadUpdateRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DownloadUpdateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DownloadUpdateRequest>(create);
  static DownloadUpdateRequest? _defaultInstance;

  /// Version to download (empty for latest)
  @$pb.TagNumber(1)
  $core.String get version => $_getSZ(0);
  @$pb.TagNumber(1)
  set version($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearVersion() => $_clearField(1);
}

/// DownloadProgress reports download status
class DownloadProgress extends $pb.GeneratedMessage {
  factory DownloadProgress({
    DownloadState? state,
    $fixnum.Int64? bytesDownloaded,
    $fixnum.Int64? totalBytes,
    $fixnum.Int64? bytesPerSecond,
    $core.String? error,
    $core.String? downloadedPath,
  }) {
    final result = create();
    if (state != null) result.state = state;
    if (bytesDownloaded != null) result.bytesDownloaded = bytesDownloaded;
    if (totalBytes != null) result.totalBytes = totalBytes;
    if (bytesPerSecond != null) result.bytesPerSecond = bytesPerSecond;
    if (error != null) result.error = error;
    if (downloadedPath != null) result.downloadedPath = downloadedPath;
    return result;
  }

  DownloadProgress._();

  factory DownloadProgress.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DownloadProgress.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DownloadProgress',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aE<DownloadState>(1, _omitFieldNames ? '' : 'state',
        enumValues: DownloadState.values)
    ..aInt64(2, _omitFieldNames ? '' : 'bytesDownloaded')
    ..aInt64(3, _omitFieldNames ? '' : 'totalBytes')
    ..aInt64(4, _omitFieldNames ? '' : 'bytesPerSecond')
    ..aOS(5, _omitFieldNames ? '' : 'error')
    ..aOS(6, _omitFieldNames ? '' : 'downloadedPath')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DownloadProgress clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DownloadProgress copyWith(void Function(DownloadProgress) updates) =>
      super.copyWith((message) => updates(message as DownloadProgress))
          as DownloadProgress;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DownloadProgress create() => DownloadProgress._();
  @$core.override
  DownloadProgress createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DownloadProgress getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DownloadProgress>(create);
  static DownloadProgress? _defaultInstance;

  /// Current state of the download
  @$pb.TagNumber(1)
  DownloadState get state => $_getN(0);
  @$pb.TagNumber(1)
  set state(DownloadState value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => $_clearField(1);

  /// Bytes downloaded so far
  @$pb.TagNumber(2)
  $fixnum.Int64 get bytesDownloaded => $_getI64(1);
  @$pb.TagNumber(2)
  set bytesDownloaded($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBytesDownloaded() => $_has(1);
  @$pb.TagNumber(2)
  void clearBytesDownloaded() => $_clearField(2);

  /// Total bytes to download
  @$pb.TagNumber(3)
  $fixnum.Int64 get totalBytes => $_getI64(2);
  @$pb.TagNumber(3)
  set totalBytes($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTotalBytes() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalBytes() => $_clearField(3);

  /// Download speed in bytes per second
  @$pb.TagNumber(4)
  $fixnum.Int64 get bytesPerSecond => $_getI64(3);
  @$pb.TagNumber(4)
  set bytesPerSecond($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasBytesPerSecond() => $_has(3);
  @$pb.TagNumber(4)
  void clearBytesPerSecond() => $_clearField(4);

  /// Error message if state is ERROR
  @$pb.TagNumber(5)
  $core.String get error => $_getSZ(4);
  @$pb.TagNumber(5)
  set error($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasError() => $_has(4);
  @$pb.TagNumber(5)
  void clearError() => $_clearField(5);

  /// Path to downloaded file when state is COMPLETED
  @$pb.TagNumber(6)
  $core.String get downloadedPath => $_getSZ(5);
  @$pb.TagNumber(6)
  set downloadedPath($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDownloadedPath() => $_has(5);
  @$pb.TagNumber(6)
  void clearDownloadedPath() => $_clearField(6);
}

/// ApplyUpdateRequest triggers update application
class ApplyUpdateRequest extends $pb.GeneratedMessage {
  factory ApplyUpdateRequest({
    $core.String? tarballPath,
    $core.bool? force,
  }) {
    final result = create();
    if (tarballPath != null) result.tarballPath = tarballPath;
    if (force != null) result.force = force;
    return result;
  }

  ApplyUpdateRequest._();

  factory ApplyUpdateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ApplyUpdateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ApplyUpdateRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'tarballPath')
    ..aOB(2, _omitFieldNames ? '' : 'force')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApplyUpdateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApplyUpdateRequest copyWith(void Function(ApplyUpdateRequest) updates) =>
      super.copyWith((message) => updates(message as ApplyUpdateRequest))
          as ApplyUpdateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApplyUpdateRequest create() => ApplyUpdateRequest._();
  @$core.override
  ApplyUpdateRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ApplyUpdateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ApplyUpdateRequest>(create);
  static ApplyUpdateRequest? _defaultInstance;

  /// Path to the downloaded tarball (from DownloadProgress.downloaded_path)
  @$pb.TagNumber(1)
  $core.String get tarballPath => $_getSZ(0);
  @$pb.TagNumber(1)
  set tarballPath($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTarballPath() => $_has(0);
  @$pb.TagNumber(1)
  void clearTarballPath() => $_clearField(1);

  /// Force update even if version check fails
  @$pb.TagNumber(2)
  $core.bool get force => $_getBF(1);
  @$pb.TagNumber(2)
  set force($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasForce() => $_has(1);
  @$pb.TagNumber(2)
  void clearForce() => $_clearField(2);
}

/// ApplyUpdateResponse contains the result of applying an update
class ApplyUpdateResponse extends $pb.GeneratedMessage {
  factory ApplyUpdateResponse({
    $core.bool? success,
    $core.String? error,
    $core.bool? restartRequired,
    $core.String? newVersion,
  }) {
    final result = create();
    if (success != null) result.success = success;
    if (error != null) result.error = error;
    if (restartRequired != null) result.restartRequired = restartRequired;
    if (newVersion != null) result.newVersion = newVersion;
    return result;
  }

  ApplyUpdateResponse._();

  factory ApplyUpdateResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ApplyUpdateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ApplyUpdateResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'error')
    ..aOB(3, _omitFieldNames ? '' : 'restartRequired')
    ..aOS(4, _omitFieldNames ? '' : 'newVersion')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApplyUpdateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApplyUpdateResponse copyWith(void Function(ApplyUpdateResponse) updates) =>
      super.copyWith((message) => updates(message as ApplyUpdateResponse))
          as ApplyUpdateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApplyUpdateResponse create() => ApplyUpdateResponse._();
  @$core.override
  ApplyUpdateResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ApplyUpdateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ApplyUpdateResponse>(create);
  static ApplyUpdateResponse? _defaultInstance;

  /// Whether the update was applied successfully
  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  /// Error message if success is false
  @$pb.TagNumber(2)
  $core.String get error => $_getSZ(1);
  @$pb.TagNumber(2)
  set error($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasError() => $_has(1);
  @$pb.TagNumber(2)
  void clearError() => $_clearField(2);

  /// Whether a restart is required (daemon will restart itself)
  @$pb.TagNumber(3)
  $core.bool get restartRequired => $_getBF(2);
  @$pb.TagNumber(3)
  set restartRequired($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRestartRequired() => $_has(2);
  @$pb.TagNumber(3)
  void clearRestartRequired() => $_clearField(3);

  /// The new version that was installed
  @$pb.TagNumber(4)
  $core.String get newVersion => $_getSZ(3);
  @$pb.TagNumber(4)
  set newVersion($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNewVersion() => $_has(3);
  @$pb.TagNumber(4)
  void clearNewVersion() => $_clearField(4);
}

/// UpdateSettings configures automatic update behavior
class UpdateSettings extends $pb.GeneratedMessage {
  factory UpdateSettings({
    $core.bool? autoCheck,
    $core.bool? autoDownload,
    $core.bool? autoApply,
    $core.bool? includePrereleases,
    $core.int? checkIntervalHours,
  }) {
    final result = create();
    if (autoCheck != null) result.autoCheck = autoCheck;
    if (autoDownload != null) result.autoDownload = autoDownload;
    if (autoApply != null) result.autoApply = autoApply;
    if (includePrereleases != null)
      result.includePrereleases = includePrereleases;
    if (checkIntervalHours != null)
      result.checkIntervalHours = checkIntervalHours;
    return result;
  }

  UpdateSettings._();

  factory UpdateSettings.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateSettings.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateSettings',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'autoCheck')
    ..aOB(2, _omitFieldNames ? '' : 'autoDownload')
    ..aOB(3, _omitFieldNames ? '' : 'autoApply')
    ..aOB(4, _omitFieldNames ? '' : 'includePrereleases')
    ..aI(5, _omitFieldNames ? '' : 'checkIntervalHours')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateSettings clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateSettings copyWith(void Function(UpdateSettings) updates) =>
      super.copyWith((message) => updates(message as UpdateSettings))
          as UpdateSettings;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateSettings create() => UpdateSettings._();
  @$core.override
  UpdateSettings createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateSettings getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateSettings>(create);
  static UpdateSettings? _defaultInstance;

  /// Check for updates automatically on daemon startup
  @$pb.TagNumber(1)
  $core.bool get autoCheck => $_getBF(0);
  @$pb.TagNumber(1)
  set autoCheck($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAutoCheck() => $_has(0);
  @$pb.TagNumber(1)
  void clearAutoCheck() => $_clearField(1);

  /// Download updates automatically when available
  @$pb.TagNumber(2)
  $core.bool get autoDownload => $_getBF(1);
  @$pb.TagNumber(2)
  set autoDownload($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAutoDownload() => $_has(1);
  @$pb.TagNumber(2)
  void clearAutoDownload() => $_clearField(2);

  /// Apply updates automatically (requires auto_download)
  @$pb.TagNumber(3)
  $core.bool get autoApply => $_getBF(2);
  @$pb.TagNumber(3)
  set autoApply($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAutoApply() => $_has(2);
  @$pb.TagNumber(3)
  void clearAutoApply() => $_clearField(3);

  /// Include prerelease versions
  @$pb.TagNumber(4)
  $core.bool get includePrereleases => $_getBF(3);
  @$pb.TagNumber(4)
  set includePrereleases($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIncludePrereleases() => $_has(3);
  @$pb.TagNumber(4)
  void clearIncludePrereleases() => $_clearField(4);

  /// How often to check for updates (in hours, 0 = only on startup)
  @$pb.TagNumber(5)
  $core.int get checkIntervalHours => $_getIZ(4);
  @$pb.TagNumber(5)
  set checkIntervalHours($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCheckIntervalHours() => $_has(4);
  @$pb.TagNumber(5)
  void clearCheckIntervalHours() => $_clearField(5);
}

/// UpdateStatus represents the current state of the update system
class UpdateStatus extends $pb.GeneratedMessage {
  factory UpdateStatus({
    UpdateState? state,
    UpdateInfo? availableUpdate,
    DownloadProgress? downloadProgress,
    $2.Timestamp? lastCheck,
    $core.String? error,
  }) {
    final result = create();
    if (state != null) result.state = state;
    if (availableUpdate != null) result.availableUpdate = availableUpdate;
    if (downloadProgress != null) result.downloadProgress = downloadProgress;
    if (lastCheck != null) result.lastCheck = lastCheck;
    if (error != null) result.error = error;
    return result;
  }

  UpdateStatus._();

  factory UpdateStatus.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateStatus.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateStatus',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'),
      createEmptyInstance: create)
    ..aE<UpdateState>(1, _omitFieldNames ? '' : 'state',
        enumValues: UpdateState.values)
    ..aOM<UpdateInfo>(2, _omitFieldNames ? '' : 'availableUpdate',
        subBuilder: UpdateInfo.create)
    ..aOM<DownloadProgress>(3, _omitFieldNames ? '' : 'downloadProgress',
        subBuilder: DownloadProgress.create)
    ..aOM<$2.Timestamp>(4, _omitFieldNames ? '' : 'lastCheck',
        subBuilder: $2.Timestamp.create)
    ..aOS(5, _omitFieldNames ? '' : 'error')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateStatus clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateStatus copyWith(void Function(UpdateStatus) updates) =>
      super.copyWith((message) => updates(message as UpdateStatus))
          as UpdateStatus;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateStatus create() => UpdateStatus._();
  @$core.override
  UpdateStatus createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateStatus getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateStatus>(create);
  static UpdateStatus? _defaultInstance;

  /// Current state
  @$pb.TagNumber(1)
  UpdateState get state => $_getN(0);
  @$pb.TagNumber(1)
  set state(UpdateState value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => $_clearField(1);

  /// Information about available update (if any)
  @$pb.TagNumber(2)
  UpdateInfo get availableUpdate => $_getN(1);
  @$pb.TagNumber(2)
  set availableUpdate(UpdateInfo value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasAvailableUpdate() => $_has(1);
  @$pb.TagNumber(2)
  void clearAvailableUpdate() => $_clearField(2);
  @$pb.TagNumber(2)
  UpdateInfo ensureAvailableUpdate() => $_ensure(1);

  /// Download progress (if downloading)
  @$pb.TagNumber(3)
  DownloadProgress get downloadProgress => $_getN(2);
  @$pb.TagNumber(3)
  set downloadProgress(DownloadProgress value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasDownloadProgress() => $_has(2);
  @$pb.TagNumber(3)
  void clearDownloadProgress() => $_clearField(3);
  @$pb.TagNumber(3)
  DownloadProgress ensureDownloadProgress() => $_ensure(2);

  /// Last time updates were checked
  @$pb.TagNumber(4)
  $2.Timestamp get lastCheck => $_getN(3);
  @$pb.TagNumber(4)
  set lastCheck($2.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasLastCheck() => $_has(3);
  @$pb.TagNumber(4)
  void clearLastCheck() => $_clearField(4);
  @$pb.TagNumber(4)
  $2.Timestamp ensureLastCheck() => $_ensure(3);

  /// Error message if state is ERROR
  @$pb.TagNumber(5)
  $core.String get error => $_getSZ(4);
  @$pb.TagNumber(5)
  set error($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasError() => $_has(4);
  @$pb.TagNumber(5)
  void clearError() => $_clearField(5);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
