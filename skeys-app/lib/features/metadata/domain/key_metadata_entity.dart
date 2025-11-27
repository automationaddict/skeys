/// Domain entity for key metadata.
class KeyMetadataEntity {
  final String keyPath;
  final String? verifiedService;
  final String? verifiedHost;
  final int? verifiedPort;
  final String? verifiedUser;

  KeyMetadataEntity({
    required this.keyPath,
    this.verifiedService,
    this.verifiedHost,
    this.verifiedPort,
    this.verifiedUser,
  });
}
