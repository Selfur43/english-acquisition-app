import 'dart:io';
import 'package:english_acquisition_app/core/backup/local_backup_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('database backup and restore preserve bytes', () async {
    final temp = await Directory.systemTemp.createTemp('backup_restore_');
    addTearDown(() => temp.delete(recursive: true));
    final database = File('${temp.path}${Platform.pathSeparator}app.sqlite3');
    await database.writeAsBytes([1, 2, 3, 4, 5]);
    final service = LocalBackupService();
    final backup = await service.createDatabaseBackup(
      databaseFile: database,
      backupDirectory: Directory('${temp.path}${Platform.pathSeparator}backup'),
      now: DateTime.utc(2026, 11, 3, 19, 0),
    );
    expect(backup, isNotNull);
    await database.writeAsBytes([9]);
    await service.restoreDatabaseBackup(
      backupFile: backup!,
      databaseFile: database,
    );
    expect(await database.readAsBytes(), [1, 2, 3, 4, 5]);
  });
}
