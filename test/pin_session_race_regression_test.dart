import 'package:english_acquisition_app/core/security/pin_hasher.dart';
import 'package:english_acquisition_app/core/security/secure_credential_store.dart';
import 'package:english_acquisition_app/core/security/secure_session_store.dart';
import 'package:english_acquisition_app/features/authentication/data/repositories/local_two_user_authentication_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'startup session clear cannot invalidate a correct existing PIN',
    () async {
      final sessions = VolatileSecureSessionStore();
      final credentials = _MemoryCredentialStore();
      final repository = LocalTwoUserAuthenticationRepository(
        sessions,
        credentials,
        pinHasher: const PinHasher(),
      );

      await repository.signIn(userName: 'USER_2', password: '246810');
      await sessions.clear();

      final user = await repository.signIn(
        userName: 'USER_2',
        password: '246810',
      );

      expect(user.id, 'learner-2');
      expect(await sessions.readUserId(), 'learner-2');
    },
  );
}

final class _MemoryCredentialStore implements SecureCredentialStore {
  final Map<String, StoredCredential> _values = <String, StoredCredential>{};

  @override
  Future<StoredCredential?> read(String userId) async => _values[userId];

  @override
  Future<void> write(String userId, StoredCredential credential) async {
    _values[userId] = credential;
  }
}
