import '../entities/authenticated_user.dart';

abstract interface class AuthenticationRepository {
  Future<AuthenticatedUser?> restore();
  Future<AuthenticatedUser> signIn({
    required String password,
    required String userName,
  });
  Future<void> signOut();
}
