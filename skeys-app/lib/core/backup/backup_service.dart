// Copyright (c) 2025 John Nelson
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:cryptography/cryptography.dart';
import 'package:path/path.dart' as p;

/// Options for what to include in a backup.
class BackupOptions {
  final bool includeKeys;
  final bool includeConfig;
  final bool includeKnownHosts;
  final bool includeAuthorizedKeys;

  const BackupOptions({
    this.includeKeys = true,
    this.includeConfig = true,
    this.includeKnownHosts = true,
    this.includeAuthorizedKeys = false,
  });

  bool get isEmpty =>
      !includeKeys &&
      !includeConfig &&
      !includeKnownHosts &&
      !includeAuthorizedKeys;
}

/// Result of analyzing a backup file.
class BackupContents {
  final List<String> keyFiles;
  final bool hasConfig;
  final bool hasKnownHosts;
  final bool hasAuthorizedKeys;
  final DateTime? createdAt;
  final String? hostname;

  BackupContents({
    required this.keyFiles,
    required this.hasConfig,
    required this.hasKnownHosts,
    required this.hasAuthorizedKeys,
    this.createdAt,
    this.hostname,
  });

  int get keyCount => keyFiles.where((f) => !f.endsWith('.pub')).length;
}

/// Service for creating and restoring SSH backups.
class BackupService {
  static const _magicHeader = 'SKEYS_BACKUP_V1';
  static const _saltLength = 16;
  static const _nonceLength = 12;

  final String sshDir;

  BackupService({String? sshDir})
    : sshDir = sshDir ?? p.join(Platform.environment['HOME'] ?? '', '.ssh');

  /// Create an encrypted backup archive.
  Future<Uint8List> createBackup({
    required String passphrase,
    BackupOptions options = const BackupOptions(),
  }) async {
    if (options.isEmpty) {
      throw ArgumentError('At least one backup option must be selected');
    }

    final archive = Archive();

    // Add metadata
    final metadata = {
      'version': 1,
      'created_at': DateTime.now().toIso8601String(),
      'hostname': Platform.localHostname,
      'options': {
        'keys': options.includeKeys,
        'config': options.includeConfig,
        'known_hosts': options.includeKnownHosts,
        'authorized_keys': options.includeAuthorizedKeys,
      },
    };
    archive.addFile(
      ArchiveFile(
        'metadata.json',
        utf8.encode(jsonEncode(metadata)).length,
        utf8.encode(jsonEncode(metadata)),
      ),
    );

    // Add SSH keys
    if (options.includeKeys) {
      await _addKeysToArchive(archive);
    }

    // Add config
    if (options.includeConfig) {
      await _addFileToArchive(archive, 'config');
    }

    // Add known_hosts
    if (options.includeKnownHosts) {
      await _addFileToArchive(archive, 'known_hosts');
    }

    // Add authorized_keys
    if (options.includeAuthorizedKeys) {
      await _addFileToArchive(archive, 'authorized_keys');
    }

    // Encode archive to tar
    final tarData = TarEncoder().encode(archive);

    // Compress with gzip
    final gzipData = GZipEncoder().encode(tarData);

    // Encrypt
    return _encrypt(Uint8List.fromList(gzipData), passphrase);
  }

  /// Analyze a backup file without fully decrypting.
  Future<BackupContents> analyzeBackup({
    required Uint8List data,
    required String passphrase,
  }) async {
    final decrypted = await _decrypt(data, passphrase);
    final decompressed = GZipDecoder().decodeBytes(decrypted);
    final archive = TarDecoder().decodeBytes(decompressed);

    final keyFiles = <String>[];
    var hasConfig = false;
    var hasKnownHosts = false;
    var hasAuthorizedKeys = false;
    DateTime? createdAt;
    String? hostname;

    for (final file in archive.files) {
      if (file.name == 'metadata.json') {
        final metadata = jsonDecode(utf8.decode(file.content as List<int>));
        createdAt = DateTime.tryParse(metadata['created_at'] ?? '');
        hostname = metadata['hostname'];
      } else if (file.name == 'config') {
        hasConfig = true;
      } else if (file.name == 'known_hosts') {
        hasKnownHosts = true;
      } else if (file.name == 'authorized_keys') {
        hasAuthorizedKeys = true;
      } else if (file.name.startsWith('keys/')) {
        keyFiles.add(file.name.substring(5)); // Remove 'keys/' prefix
      }
    }

    return BackupContents(
      keyFiles: keyFiles,
      hasConfig: hasConfig,
      hasKnownHosts: hasKnownHosts,
      hasAuthorizedKeys: hasAuthorizedKeys,
      createdAt: createdAt,
      hostname: hostname,
    );
  }

  /// Restore from an encrypted backup.
  Future<RestoreResult> restoreBackup({
    required Uint8List data,
    required String passphrase,
    bool overwriteExisting = false,
    BackupOptions? filter,
  }) async {
    final decrypted = await _decrypt(data, passphrase);
    final decompressed = GZipDecoder().decodeBytes(decrypted);
    final archive = TarDecoder().decodeBytes(decompressed);

    final result = RestoreResult();

    // Ensure .ssh directory exists with correct permissions
    final sshDirectory = Directory(sshDir);
    if (!await sshDirectory.exists()) {
      await sshDirectory.create(recursive: true);
      await Process.run('chmod', ['700', sshDir]);
    }

    for (final file in archive.files) {
      if (file.name == 'metadata.json') continue;

      final shouldRestore = _shouldRestoreFile(file.name, filter);
      if (!shouldRestore) continue;

      final targetPath = _getTargetPath(file.name);
      final targetFile = File(targetPath);

      if (await targetFile.exists() && !overwriteExisting) {
        result.skipped.add(file.name);
        continue;
      }

      try {
        // Create parent directories if needed
        await targetFile.parent.create(recursive: true);

        // Write file
        await targetFile.writeAsBytes(file.content as List<int>);

        // Set appropriate permissions
        await _setFilePermissions(targetPath, file.name);

        result.restored.add(file.name);
      } catch (e) {
        result.errors[file.name] = e.toString();
      }
    }

    return result;
  }

  Future<void> _addKeysToArchive(Archive archive) async {
    final dir = Directory(sshDir);
    if (!await dir.exists()) return;

    await for (final entity in dir.list()) {
      if (entity is! File) continue;

      final name = p.basename(entity.path);

      // Skip non-key files
      if (name == 'config' ||
          name == 'known_hosts' ||
          name == 'authorized_keys' ||
          name.startsWith('.')) {
        continue;
      }

      // Check if it looks like a key file
      final isPublicKey = name.endsWith('.pub');
      final hasMatchingPub =
          await File('${entity.path}.pub').exists() || isPublicKey;
      final hasMatchingPrivate = isPublicKey
          ? await File(
              entity.path.substring(0, entity.path.length - 4),
            ).exists()
          : true;

      if (!hasMatchingPub && !hasMatchingPrivate) continue;

      try {
        final content = await entity.readAsBytes();
        archive.addFile(ArchiveFile('keys/$name', content.length, content));
      } catch (e) {
        // Skip files we can't read
      }
    }
  }

  Future<void> _addFileToArchive(Archive archive, String filename) async {
    final file = File(p.join(sshDir, filename));
    if (!await file.exists()) return;

    try {
      final content = await file.readAsBytes();
      archive.addFile(ArchiveFile(filename, content.length, content));
    } catch (e) {
      // Skip files we can't read
    }
  }

  Future<Uint8List> _encrypt(Uint8List data, String passphrase) async {
    final algorithm = AesGcm.with256bits();

    // Derive key from passphrase
    final pbkdf2 = Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: 100000,
      bits: 256,
    );

    final salt = Uint8List(_saltLength);
    _fillRandomBytes(salt);

    final secretKey = await pbkdf2.deriveKey(
      secretKey: SecretKey(utf8.encode(passphrase)),
      nonce: salt,
    );

    // Encrypt
    final nonce = algorithm.newNonce();
    final secretBox = await algorithm.encrypt(
      data,
      secretKey: secretKey,
      nonce: nonce,
    );

    // Combine: magic + salt + nonce + ciphertext + mac
    final result = BytesBuilder();
    result.add(utf8.encode(_magicHeader));
    result.add(salt);
    result.add(secretBox.nonce);
    result.add(secretBox.cipherText);
    result.add(secretBox.mac.bytes);

    return result.toBytes();
  }

  Future<Uint8List> _decrypt(Uint8List data, String passphrase) async {
    // Verify magic header
    final header = utf8.decode(data.sublist(0, _magicHeader.length));
    if (header != _magicHeader) {
      throw FormatException('Invalid backup file format');
    }

    var offset = _magicHeader.length;

    // Extract salt
    final salt = data.sublist(offset, offset + _saltLength);
    offset += _saltLength;

    // Extract nonce
    final nonce = data.sublist(offset, offset + _nonceLength);
    offset += _nonceLength;

    // Extract ciphertext and MAC (MAC is last 16 bytes)
    final macLength = 16;
    final cipherText = data.sublist(offset, data.length - macLength);
    final mac = data.sublist(data.length - macLength);

    // Derive key
    final pbkdf2 = Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: 100000,
      bits: 256,
    );

    final secretKey = await pbkdf2.deriveKey(
      secretKey: SecretKey(utf8.encode(passphrase)),
      nonce: salt,
    );

    // Decrypt
    final algorithm = AesGcm.with256bits();
    final secretBox = SecretBox(cipherText, nonce: nonce, mac: Mac(mac));

    try {
      final decrypted = await algorithm.decrypt(
        secretBox,
        secretKey: secretKey,
      );
      return Uint8List.fromList(decrypted);
    } catch (e) {
      throw FormatException('Decryption failed - incorrect passphrase');
    }
  }

  void _fillRandomBytes(Uint8List buffer) {
    final random = SecureRandom.secure();
    for (var i = 0; i < buffer.length; i++) {
      buffer[i] = random.nextInt(256);
    }
  }

  bool _shouldRestoreFile(String filename, BackupOptions? filter) {
    if (filter == null) return true;

    if (filename.startsWith('keys/')) return filter.includeKeys;
    if (filename == 'config') return filter.includeConfig;
    if (filename == 'known_hosts') return filter.includeKnownHosts;
    if (filename == 'authorized_keys') return filter.includeAuthorizedKeys;

    return false;
  }

  String _getTargetPath(String archivePath) {
    if (archivePath.startsWith('keys/')) {
      return p.join(sshDir, archivePath.substring(5));
    }
    return p.join(sshDir, archivePath);
  }

  Future<void> _setFilePermissions(String path, String archivePath) async {
    // Private keys should be 600, everything else 644
    final isPrivateKey =
        archivePath.startsWith('keys/') && !archivePath.endsWith('.pub');
    final mode = isPrivateKey ? '600' : '644';

    await Process.run('chmod', [mode, path]);
  }
}

/// Result of a restore operation.
class RestoreResult {
  final List<String> restored = [];
  final List<String> skipped = [];
  final Map<String, String> errors = {};

  bool get hasErrors => errors.isNotEmpty;
  bool get success => restored.isNotEmpty && !hasErrors;
}

class SecureRandom {
  static final _instance = SecureRandom._();
  static SecureRandom secure() => _instance;

  SecureRandom._();

  final _seed = DateTime.now().millisecondsSinceEpoch;
  int _counter = 0;

  int nextInt(int max) {
    _counter++;
    // Use dart:io's built-in secure random through file system
    final file = File('/dev/urandom');
    if (file.existsSync()) {
      final raf = file.openSync();
      final bytes = raf.readSync(4);
      raf.closeSync();
      final value =
          bytes[0] | (bytes[1] << 8) | (bytes[2] << 16) | (bytes[3] << 24);
      return value.abs() % max;
    }
    // Fallback (less secure)
    return ((_seed + _counter * 31337) % max).abs();
  }
}
