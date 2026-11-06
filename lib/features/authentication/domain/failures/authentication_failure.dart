final class AuthenticationFailure implements Exception {
  const AuthenticationFailure(this.message);
  final String message;
}
