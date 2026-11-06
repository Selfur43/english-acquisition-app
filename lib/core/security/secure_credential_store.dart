import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final class StoredCredential {
  const StoredCredential({
    required this.failedAttempts,
    required this.hash,
    required this.salt,
    this.lockedUntilUtc,
  });

  final int failedAttempts;
  final String hash;
  final DateTime? lockedUntilUtc;
  final String salt;
}

abstract interface class SecureCredentialStore {
  Future<StoredCredential?> read(String userId);
  Future<void> write(String userId, StoredCredential credential);
}

final class FlutterSecureCredentialStore implements SecureCredentialStore {
  const FlutterSecureCredentialStore(this._storage);
  final FlutterSecureStorage _storage;

  String _key(String userId, String field) => 'credential_${userId}_$field';

  @override
  Future<StoredCredential?> read(String userId) async {
    final hash = await _storage.read(key: _key(userId, 'hash'));
    final salt = await _storage.read(key: _key(userId, 'salt'));
    if (hash == null || salt == null) return null;
    final failed =
        int.tryParse(await _storage.read(key: _key(userId, 'failed')) ?? '') ??
        0;
    final lockedRaw = await _storage.read(key: _key(userId, 'locked_until'));
    return StoredCredential(
      failedAttempts: failed,
      hash: hash,
      salt: salt,
      lockedUntilUtc: lockedRaw == null ? null : DateTime.tryParse(lockedRaw),
    );
  }

  @override
  Future<void> write(String userId, StoredCredential credential) async {
    await _storage.write(key: _key(userId, 'hash'), value: credential.hash);
    await _storage.write(key: _key(userId, 'salt'), value: credential.salt);
    await _storage.write(
      key: _key(userId, 'failed'),
      value: credential.failedAttempts.toString(),
    );
    if (credential.lockedUntilUtc == null) {
      await _storage.delete(key: _key(userId, 'locked_until'));
    } else {
      await _storage.write(
        key: _key(userId, 'locked_until'),
        value: credential.lockedUntilUtc!.toUtc().toIso8601String(),
      );
    }
  }
}
