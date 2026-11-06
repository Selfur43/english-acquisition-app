import 'dart:io';

void main() {
  final failures = <String>[];
  for (final path in <String>[
    'lib/core/backup/local_backup_service.dart',
    'lib/core/security/pin_hasher.dart',
    'lib/core/security/secure_credential_store.dart',
    'test/authentication_security_test.dart',
    'test/startup_lock_and_switch_test.dart',
    'test/home_security_controls_test.dart',
    'test/learning_insights_ui_test.dart',
    'test/mastery_attempts_contract_test.dart',
    'lib/features/learning_session/presentation/learning_insights_page.dart',
    'test/backup_restore_test.dart',
    'test/v7_schema_isolation_test.dart',
    'scripts/update_from_zip.ps1',
    'scripts/install_desktop_shortcuts.ps1',
    'windows/runner/resources/app_icon.ico',
  ]) {
    if (!File(path).existsSync()) failures.add('Missing $path');
  }
  final pubspec = File('pubspec.yaml').readAsStringSync();
  for (final token in <String>['http:', 'dio:', 'firebase_', 'supabase']) {
    if (pubspec.contains(token)) failures.add('Online dependency $token');
  }
  final updater = File('scripts/update_from_zip.ps1').readAsStringSync();
  for (final token in <String>[
    "@('analyze')",
    "@('test')",
    "@('build','windows','--release')",
    'ROLLBACK SUCCESS',
    'ALL V7 RELEASE GATES PASSED',
  ]) {
    if (!updater.contains(token)) failures.add('Updater gate $token');
  }
  if (failures.isNotEmpty) {
    stderr.writeln(failures.join('\n'));
    exitCode = 1;
  } else {
    stdout.writeln('V7 static audit passed.');
  }
}
