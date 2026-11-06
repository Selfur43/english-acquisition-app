import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../core/security/secure_credential_store.dart';
import '../../core/security/secure_session_store.dart';
import 'application/controllers/authentication_controller.dart';
import 'data/repositories/local_two_user_authentication_repository.dart';
import 'domain/repositories/authentication_repository.dart';

export 'application/controllers/authentication_controller.dart';
export 'domain/entities/authenticated_user.dart';
export 'domain/value_objects/authentication_status.dart';
export 'presentation/pages/sign_in_page.dart';

final secureSessionStoreProvider = Provider<SecureSessionStore>(
  (ref) => VolatileSecureSessionStore(),
);

final secureCredentialStoreProvider = Provider<SecureCredentialStore>(
  (ref) => const FlutterSecureCredentialStore(FlutterSecureStorage()),
);

final authenticationRepositoryProvider = Provider<AuthenticationRepository>(
  (ref) => LocalTwoUserAuthenticationRepository(
    ref.watch(secureSessionStoreProvider),
    ref.watch(secureCredentialStoreProvider),
  ),
);

final authenticationControllerProvider = Provider<AuthenticationController>((
  ref,
) {
  final controller = AuthenticationController(
    ref.watch(authenticationRepositoryProvider),
  );
  ref.onDispose(controller.dispose);
  controller.initialize();
  return controller;
});
