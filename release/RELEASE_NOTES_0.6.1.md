# 0.6.1+31 Two-Profile PIN Security Repair

- Replaces deprecated DropdownButtonFormField.value with initialValue.
- Removes the duplicate crypto dev dependency while retaining crypto as a runtime dependency.
- Documents the intentionally caught authentication failure in the lockout test.
- Retains separate USER_1/USER_2 PIN hashes, random salts, five-attempt lockout, Windows secure storage, backup/restore, isolation tests, Windows Release build, smoke launch, and rollback gates.
