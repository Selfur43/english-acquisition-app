import 'package:flutter/foundation.dart';

import '../../domain/entities/authenticated_user.dart';
import '../../domain/failures/authentication_failure.dart';
import '../../domain/repositories/authentication_repository.dart';
import '../../domain/value_objects/authentication_status.dart';

final class AuthenticationController extends ChangeNotifier {
  AuthenticationController(this._repository);

  final AuthenticationRepository _repository;
  bool _disposed = false;

  String? errorMessage;
  bool isBusy = false;
  AuthenticationStatus status = AuthenticationStatus.initializing;
  AuthenticatedUser? user;

  Future<void> initialize() async {
    // V7 security policy: every process start requires explicit PIN unlock.
    await _repository.signOut();
    user = null;
    errorMessage = null;
    status = AuthenticationStatus.unauthenticated;
    _notifySafely();
  }

  Future<void> signIn({
    required String password,
    required String userName,
  }) async {
    errorMessage = null;
    isBusy = true;
    _notifySafely();
    try {
      user = await _repository.signIn(password: password, userName: userName);
      status = AuthenticationStatus.authenticated;
    } on AuthenticationFailure catch (failure) {
      errorMessage = failure.message;
      status = AuthenticationStatus.unauthenticated;
    } catch (_) {
      errorMessage = 'Sign-in could not be completed.';
      status = AuthenticationStatus.unauthenticated;
    } finally {
      isBusy = false;
      _notifySafely();
    }
  }

  Future<void> signOut() async {
    await _repository.signOut();
    errorMessage = null;
    status = AuthenticationStatus.unauthenticated;
    user = null;
    _notifySafely();
  }

  void _notifySafely() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
