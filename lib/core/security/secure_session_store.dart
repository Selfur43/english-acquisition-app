import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract interface class SecureSessionStore {
  Future<void> clear();
  Future<String?> readUserId();
  Future<void> writeUserId(String userId);
}

final class FlutterSecureSessionStore implements SecureSessionStore {
  const FlutterSecureSessionStore(this._storage);

  static const _userIdKey = 'authenticated_user_id';
  final FlutterSecureStorage _storage;

  @override
  Future<void> clear() => _storage.delete(key: _userIdKey);

  @override
  Future<String?> readUserId() => _storage.read(key: _userIdKey);

  @override
  Future<void> writeUserId(String userId) =>
      _storage.write(key: _userIdKey, value: userId);
}
