import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../domain/entities/authenticated_user.dart';
import '../../domain/failures/authentication_failure.dart';
import '../../domain/repositories/authentication_repository.dart';
import '../../domain/value_objects/authentication_status.dart';

final class AuthenticationController extends ChangeNotifier {
  AuthenticationController(this._repository);

  static const Duration _sessionClearTimeout = Duration(seconds: 2);

  final AuthenticationRepository _repository;
  bool _disposed = false;

  String? errorMessage;
  bool isBusy = false;
  AuthenticationStatus status = AuthenticationStatus.initializing;
  AuthenticatedUser? user;

  /// Unlocks the startup UI immediately and clears any stale persisted session
  /// in the background. The app intentionally asks for a PIN after every
  /// process start, so secure-storage latency must never block the first frame.
  Future<void> initialize() async {
    user = null;
    errorMessage = null;
    isBusy = false;
    status = AuthenticationStatus.unauthenticated;
    _notifySafely();

    unawaited(_clearPersistedSessionSafely());
  }

  Future<void> _clearPersistedSessionSafely() async {
    try {
      await _repository.signOut().timeout(_sessionClearTimeout);
    } catch (_) {
      // A stale session identifier is never trusted at startup. Failure to
      // clear secure storage must not trap the user on an endless spinner.
    }
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
    user = null;
    errorMessage = null;
    isBusy = false;
    status = AuthenticationStatus.unauthenticated;
    _notifySafely();

    try {
      await _repository.signOut().timeout(_sessionClearTimeout);
    } catch (_) {
      // The in-memory session is already locked. Secure-storage cleanup can be
      // retried on the next launch without keeping the UI blocked.
    }
  }

  void _notifySafely() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
