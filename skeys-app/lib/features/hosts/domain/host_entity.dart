import 'package:equatable/equatable.dart';

/// Known host entry.
class KnownHostEntry extends Equatable {
  final String host;
  final String keyType;
  final String publicKey;
  final bool isHashed;

  const KnownHostEntry({
    required this.host,
    required this.keyType,
    required this.publicKey,
    required this.isHashed,
  });

  @override
  List<Object?> get props => [host, keyType, publicKey, isHashed];
}

/// Authorized key entry.
class AuthorizedKeyEntry extends Equatable {
  final String keyType;
  final String publicKey;
  final String comment;
  final List<String> options;

  const AuthorizedKeyEntry({
    required this.keyType,
    required this.publicKey,
    required this.comment,
    this.options = const [],
  });

  @override
  List<Object?> get props => [keyType, publicKey, comment, options];
}
