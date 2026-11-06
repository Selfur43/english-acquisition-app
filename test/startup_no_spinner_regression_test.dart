import 'dart:async';
import 'dart:io';

import 'package:english_acquisition_app/features/authentication/application/controllers/authentication_controller.dart';
import 'package:english_acquisition_app/features/authentication/domain/entities/authenticated_user.dart';
import 'package:english_acquisition_app/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:english_acquisition_app/features/authentication/domain/value_objects/authentication_status.dart';
import 'package:flutter_test/flutter_test.dart';

final class NeverCompletingSignOutRepository
    implements AuthenticationRepository {
  final Completer<void> signOutCompleter = Completer<void>();

  @override
  Future<AuthenticatedUser?> restore() async => null;

  @override
  Future<AuthenticatedUser> signIn({
    required String password,
    required String userName,
  }) async => const AuthenticatedUser(displayName: 'Furkan', id: 'learner-1');

  @override
  Future<void> signOut() => signOutCompleter.future;
}

void main() {
  test(
    'startup unlocks UI without waiting for secure storage cleanup',
    () async {
      final controller = AuthenticationController(
        NeverCompletingSignOutRepository(),
      );
      addTearDown(controller.dispose);

      await controller.initialize();

      expect(controller.status, AuthenticationStatus.unauthenticated);
      expect(controller.user, isNull);
      expect(controller.isBusy, isFalse);
    },
  );

  test('router has no startup spinner route', () {
    final source = File('lib/app/routing/app_router.dart').readAsStringSync();
    expect(source, contains("initialLocation: '/sign-in'"));
    expect(source, isNot(contains("path: '/starting'")));
    expect(source, isNot(contains('CircularProgressIndicator')));
  });
}
