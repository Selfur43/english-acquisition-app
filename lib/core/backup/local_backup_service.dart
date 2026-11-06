import 'dart:io';

final class LocalBackupService {
  const LocalBackupService();

  Future<File?> createDatabaseBackup({
    required File databaseFile,
    required Directory backupDirectory,
    DateTime? now,
  }) async {
    if (!await databaseFile.exists()) return null;
    await backupDirectory.create(recursive: true);
    final stamp = (now ?? DateTime.now().toUtc())
        .toIso8601String()
        .replaceAll(RegExp(r'[^0-9]'), '')
        .substring(0, 14);
    return databaseFile.copy(
      '${backupDirectory.path}${Platform.pathSeparator}'
      'english_acquisition_$stamp.sqlite3.bak',
    );
  }

  Future<void> restoreDatabaseBackup({
    required File backupFile,
    required File databaseFile,
  }) async {
    if (!await backupFile.exists()) {
      throw StateError('Backup file does not exist: ${backupFile.path}');
    }
    await databaseFile.parent.create(recursive: true);
    await backupFile.copy(databaseFile.path);
  }
}
