import 'package:equatable/equatable.dart';

/// SSH Key types.
enum KeyType {
  rsa,
  ed25519,
  ecdsa,
  ed25519Sk,
  ecdsaSk,
  unknown,
}

/// Domain entity representing an SSH key.
class KeyEntity extends Equatable {
  final String path;
  final String name;
  final KeyType type;
  final int bits;
  final String fingerprint;
  final String publicKey;
  final String comment;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final bool hasPassphrase;
  final bool isInAgent;

  const KeyEntity({
    required this.path,
    required this.name,
    required this.type,
    required this.bits,
    required this.fingerprint,
    required this.publicKey,
    required this.comment,
    required this.createdAt,
    required this.modifiedAt,
    required this.hasPassphrase,
    required this.isInAgent,
  });

  @override
  List<Object?> get props => [
        path,
        name,
        type,
        bits,
        fingerprint,
        publicKey,
        comment,
        createdAt,
        modifiedAt,
        hasPassphrase,
        isInAgent,
      ];

  KeyEntity copyWith({
    String? path,
    String? name,
    KeyType? type,
    int? bits,
    String? fingerprint,
    String? publicKey,
    String? comment,
    DateTime? createdAt,
    DateTime? modifiedAt,
    bool? hasPassphrase,
    bool? isInAgent,
  }) {
    return KeyEntity(
      path: path ?? this.path,
      name: name ?? this.name,
      type: type ?? this.type,
      bits: bits ?? this.bits,
      fingerprint: fingerprint ?? this.fingerprint,
      publicKey: publicKey ?? this.publicKey,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      hasPassphrase: hasPassphrase ?? this.hasPassphrase,
      isInAgent: isInAgent ?? this.isInAgent,
    );
  }
}
