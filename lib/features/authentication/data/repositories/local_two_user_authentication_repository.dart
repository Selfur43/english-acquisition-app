import '../../../../core/security/pin_hasher.dart';
import '../../../../core/security/secure_credential_store.dart';
import '../../../../core/security/secure_session_store.dart';
import '../../domain/entities/authenticated_user.dart';
import '../../domain/failures/authentication_failure.dart';
import '../../domain/repositories/authentication_repository.dart';

final class LocalTwoUserAuthenticationRepository
    implements AuthenticationRepository {
  LocalTwoUserAuthenticationRepository(
    this._sessionStore,
    this._credentialStore, {
    PinHasher pinHasher = const PinHasher(),
    DateTime Function()? clock,
  }) : _pinHasher = pinHasher,
       _clock = clock ?? DateTime.now;

  static const maxFailedAttempts = 5;
  static const lockDuration = Duration(minutes: 5);

  final SecureCredentialStore _credentialStore;
  final DateTime Function() _clock;
  final PinHasher _pinHasher;
  final SecureSessionStore _sessionStore;

  static const users = <String, AuthenticatedUser>{
    'USER_1': AuthenticatedUser(displayName: 'Furkan', id: 'learner-1'),
    'USER_2': AuthenticatedUser(displayName: 'Learner 2', id: 'learner-2'),
  };

  @override
  Future<AuthenticatedUser?> restore() async {
    final userId = await _sessionStore.readUserId();
    for (final user in users.values) {
      if (user.id == userId) return user;
    }
    return null;
  }

  @override
  Future<AuthenticatedUser> signIn({
    required String password,
    required String userName,
  }) async {
    final user = users[userName.trim().toUpperCase()];
    if (user == null) {
      throw const AuthenticationFailure('Select USER_1 or USER_2.');
    }
    if (!RegExp(r'^\d{6}$').hasMatch(password)) {
      throw const AuthenticationFailure('PIN must contain exactly six digits.');
    }

    final now = _clock().toUtc();
    var credential = await _credentialStore.read(user.id);
    if (credential == null) {
      final salt = _pinHasher.createSalt();
      credential = StoredCredential(
        failedAttempts: 0,
        hash: _pinHasher.hash(pin: password, salt: salt),
        salt: salt,
      );
      await _credentialStore.write(user.id, credential);
      await _sessionStore.writeUserId(user.id);
      return user;
    }

    final lockedUntil = credential.lockedUntilUtc;
    if (lockedUntil != null && now.isBefore(lockedUntil)) {
      final seconds = lockedUntil.difference(now).inSeconds + 1;
      throw AuthenticationFailure(
        'Profile locked. Try again in $seconds seconds.',
      );
    }

    if (!_pinHasher.verify(
      expectedHash: credential.hash,
      pin: password,
      salt: credential.salt,
    )) {
      final failures = credential.failedAttempts + 1;
      final shouldLock = failures >= maxFailedAttempts;
      await _credentialStore.write(
        user.id,
        StoredCredential(
          failedAttempts: shouldLock ? 0 : failures,
          hash: credential.hash,
          salt: credential.salt,
          lockedUntilUtc: shouldLock ? now.add(lockDuration) : null,
        ),
      );
      if (shouldLock) {
        throw const AuthenticationFailure(
          'Too many incorrect attempts. Profile locked for five minutes.',
        );
      }
      throw AuthenticationFailure(
        'Incorrect PIN. ${maxFailedAttempts - failures} attempts remaining.',
      );
    }

    await _credentialStore.write(
      user.id,
      StoredCredential(
        failedAttempts: 0,
        hash: credential.hash,
        salt: credential.salt,
      ),
    );
    await _sessionStore.writeUserId(user.id);
    return user;
  }

  @override
  Future<void> signOut() => _sessionStore.clear();
}
