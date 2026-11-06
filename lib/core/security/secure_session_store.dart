abstract interface class SecureSessionStore {
  Future<void> clear();
  Future<String?> readUserId();
  Future<void> writeUserId(String userId);
}

/// Keeps the unlocked profile only in process memory.
///
/// The desktop app deliberately requires the PIN after every restart. Persisting
/// the active profile in Windows secure storage added no security value and
/// allowed a concurrent startup delete to race with a successful sign-in write.
/// PIN credentials remain protected by the credential store; only the transient
/// active-profile marker is kept here.
final class VolatileSecureSessionStore implements SecureSessionStore {
  String? _userId;

  @override
  Future<void> clear() async {
    _userId = null;
  }

  @override
  Future<String?> readUserId() async => _userId;

  @override
  Future<void> writeUserId(String userId) async {
    _userId = userId;
  }
}
