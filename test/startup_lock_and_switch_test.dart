import 'package:english_acquisition_app/core/security/pin_hasher.dart';
import 'package:english_acquisition_app/core/security/secure_credential_store.dart';
import 'package:english_acquisition_app/core/security/secure_session_store.dart';
import 'package:english_acquisition_app/features/authentication/application/controllers/authentication_controller.dart';
import 'package:english_acquisition_app/features/authentication/data/repositories/local_two_user_authentication_repository.dart';
import 'package:english_acquisition_app/features/authentication/domain/value_objects/authentication_status.dart';
import 'package:flutter_test/flutter_test.dart';

final class MemorySessionStore implements SecureSessionStore {
  String? value = 'learner-1';
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
  Future<void> write(String userId, StoredCredential value) async =>
      values[userId] = value;
}

void main() {
  test('startup clears a saved session and requires PIN', () async {
    final session = MemorySessionStore();
    final controller = AuthenticationController(
      LocalTwoUserAuthenticationRepository(
        session,
        MemoryCredentialStore(),
        pinHasher: const PinHasher(iterations: 10),
      ),
    );
    await controller.initialize();
    expect(session.value, isNull);
    expect(controller.user, isNull);
    expect(controller.status, AuthenticationStatus.unauthenticated);
  });

  test('switching profile clears current session', () async {
    final session = MemorySessionStore();
    final controller = AuthenticationController(
      LocalTwoUserAuthenticationRepository(
        session,
        MemoryCredentialStore(),
        pinHasher: const PinHasher(iterations: 10),
      ),
    );
    await controller.initialize();
    await controller.signIn(userName: 'USER_1', password: '123456');
    expect(controller.user?.id, 'learner-1');
    await controller.signOut();
    expect(session.value, isNull);
    expect(controller.status, AuthenticationStatus.unauthenticated);
  });
}
