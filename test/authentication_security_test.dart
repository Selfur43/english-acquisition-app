import 'package:english_acquisition_app/core/security/pin_hasher.dart';
import 'package:english_acquisition_app/core/security/secure_credential_store.dart';
import 'package:english_acquisition_app/core/security/secure_session_store.dart';
import 'package:english_acquisition_app/features/authentication/data/repositories/local_two_user_authentication_repository.dart';
import 'package:english_acquisition_app/features/authentication/domain/failures/authentication_failure.dart';
import 'package:flutter_test/flutter_test.dart';

final class MemorySessionStore implements SecureSessionStore {
  String? value;
  @override
  Future<void> clear() async => value = null;
  @override
  Future<String?> readUserId() async => value;
  @override
  Future<void> writeUserId(String userId) async => value = userId;
}

final class MemoryCredentialStore implements SecureCredentialStore {
  final values = <String, StoredCredential>{};
  @override
  Future<StoredCredential?> read(String userId) async => values[userId];
  @override
  Future<void> write(String userId, StoredCredential credential) async =>
      values[userId] = credential;
}

void main() {
  test('first sign-in creates separate hashed credentials', () async {
    final credentials = MemoryCredentialStore();
    final repository = LocalTwoUserAuthenticationRepository(
      MemorySessionStore(),
      credentials,
      pinHasher: const PinHasher(iterations: 10),
    );
    expect(
      (await repository.signIn(userName: 'USER_1', password: '123456')).id,
      'learner-1',
    );
    expect(
      (await repository.signIn(userName: 'USER_2', password: '654321')).id,
      'learner-2',
    );
    expect(credentials.values.length, 2);
    expect(credentials.values['learner-1']!.hash, isNot('123456'));
    expect(
      credentials.values['learner-1']!.hash,
      isNot(credentials.values['learner-2']!.hash),
    );
  });

  test('invalid PIN format is rejected', () async {
    final repository = LocalTwoUserAuthenticationRepository(
      MemorySessionStore(),
      MemoryCredentialStore(),
      pinHasher: const PinHasher(iterations: 10),
    );
    expect(
      () => repository.signIn(userName: 'USER_1', password: '123'),
      throwsA(isA<AuthenticationFailure>()),
    );
  });

  test('five incorrect PINs lock only selected profile', () async {
    var now = DateTime.utc(2026, 11, 4, 12);
    final credentials = MemoryCredentialStore();
    final repository = LocalTwoUserAuthenticationRepository(
      MemorySessionStore(),
      credentials,
      pinHasher: const PinHasher(iterations: 10),
      clock: () => now,
    );
    await repository.signIn(userName: 'USER_1', password: '123456');
    await repository.signOut();
    for (var attempt = 0; attempt < 5; attempt++) {
      try {
        await repository.signIn(userName: 'USER_1', password: '000000');
      } on AuthenticationFailure {
        // Expected while exercising the lockout counter.
      }
    }
    expect(
      () => repository.signIn(userName: 'USER_1', password: '123456'),
      throwsA(isA<AuthenticationFailure>()),
    );
    expect(
      (await repository.signIn(userName: 'USER_2', password: '654321')).id,
      'learner-2',
    );
    now = now.add(const Duration(minutes: 6));
    expect(
      (await repository.signIn(userName: 'USER_1', password: '123456')).id,
      'learner-1',
    );
  });
}
