//
//  Generated code. Do not modify.
//  source: skeys/v1/version.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// VersionInfo contains version information about the daemon
class VersionInfo extends $pb.GeneratedMessage {
  factory VersionInfo({
    $core.String? daemonVersion,
    $core.String? daemonCommit,
    $core.String? goVersion,
  }) {
    final $result = create();
    if (daemonVersion != null) {
      $result.daemonVersion = daemonVersion;
    }
    if (daemonCommit != null) {
      $result.daemonCommit = daemonCommit;
    }
    if (goVersion != null) {
      $result.goVersion = goVersion;
    }
    return $result;
  }
  VersionInfo._() : super();
  factory VersionInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory VersionInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'VersionInfo', package: const $pb.PackageName(_omitMessageNames ? '' : 'skeys.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'daemonVersion')
    ..aOS(2, _omitFieldNames ? '' : 'daemonCommit')
    ..aOS(3, _omitFieldNames ? '' : 'goVersion')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  VersionInfo clone() => VersionInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  VersionInfo copyWith(void Function(VersionInfo) updates) => super.copyWith((message) => updates(message as VersionInfo)) as VersionInfo;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VersionInfo create() => VersionInfo._();
  VersionInfo createEmptyInstance() => create();
  static $pb.PbList<VersionInfo> createRepeated() => $pb.PbList<VersionInfo>();
  @$core.pragma('dart2js:noInline')
  static VersionInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<VersionInfo>(create);
  static VersionInfo? _defaultInstance;

  /// daemon_version is the version of skeys-daemon (e.g., "0.0.1")
  @$pb.TagNumber(1)
  $core.String get daemonVersion => $_getSZ(0);
  @$pb.TagNumber(1)
  set daemonVersion($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDaemonVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearDaemonVersion() => clearField(1);

  /// daemon_commit is the git commit hash of the build
  @$pb.TagNumber(2)
  $core.String get daemonCommit => $_getSZ(1);
  @$pb.TagNumber(2)
  set daemonCommit($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasDaemonCommit() => $_has(1);
  @$pb.TagNumber(2)
  void clearDaemonCommit() => clearField(2);

  /// go_version is the Go runtime version (e.g., "go1.22.0")
  @$pb.TagNumber(3)
  $core.String get goVersion => $_getSZ(2);
  @$pb.TagNumber(3)
  set goVersion($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasGoVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearGoVersion() => clearField(3);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
