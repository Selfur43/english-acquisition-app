import 'dart:io';
import 'package:sqlite3/sqlite3.dart';

final class LocalDatabase {
  LocalDatabase._(this._database);
  static const currentSchemaVersion = 3;
  final Database _database;
  Database get raw => _database;

  static Future<LocalDatabase> open() async {
    final appData = Platform.environment['APPDATA'] ?? Directory.current.path;
    final data = Directory(
      '$appData${Platform.pathSeparator}EnglishAcquisitionApp${Platform.pathSeparator}data',
    );
    await data.create(recursive: true);
    final value = LocalDatabase._(
      sqlite3.open(
        '${data.path}${Platform.pathSeparator}english_acquisition.sqlite3',
      ),
    );
    value._migrate();
    return value;
  }

  static LocalDatabase inMemory() {
    final value = LocalDatabase._(sqlite3.openInMemory());
    value._migrate();
    return value;
  }

  void _migrate() {
    _database.execute('PRAGMA foreign_keys = ON');
    _database.execute('BEGIN IMMEDIATE');
    try {
      var version = _database.userVersion;
      if (version == 0) {
        _createPhase2Schema();
        _database.userVersion = 1;
        version = 1;
      }
      if (version == 1) {
        _createPhase3Schema();
        _database.userVersion = 2;
        version = 2;
      }
      if (version == 2) {
        _createAdaptiveSchema();
        _database.userVersion = 3;
        version = 3;
      }
      if (version != currentSchemaVersion) {
        throw StateError('Unsupported database schema version: $version');
      }
      _database.execute('COMMIT');
    } catch (_) {
      _database.execute('ROLLBACK');
      rethrow;
    }
  }

  void _createPhase2Schema() {
    _database.execute(
      "CREATE TABLE IF NOT EXISTS learner_profiles (learner_id TEXT NOT NULL PRIMARY KEY, display_name TEXT NOT NULL, native_language TEXT NOT NULL, english_level TEXT NOT NULL, occupational_role TEXT NOT NULL, industry TEXT NOT NULL, procurement_experience_years INTEGER NOT NULL, communication_tasks TEXT NOT NULL, preferred_session_minutes INTEGER NOT NULL, accessibility_notes TEXT NOT NULL, updated_at TEXT NOT NULL) STRICT",
    );
    _database.execute(
      "CREATE TABLE IF NOT EXISTS learner_goals (id TEXT NOT NULL PRIMARY KEY, learner_id TEXT NOT NULL, title TEXT NOT NULL, description TEXT NOT NULL, occupational_context TEXT NOT NULL, priority INTEGER NOT NULL, status TEXT NOT NULL, target_date TEXT, created_at TEXT NOT NULL, updated_at TEXT NOT NULL) STRICT",
    );
    _database.execute(
      'CREATE INDEX IF NOT EXISTS idx_goals_learner_priority ON learner_goals (learner_id, status, priority, updated_at)',
    );
  }

  void _createPhase3Schema() {
    _database.execute(
      "CREATE TABLE IF NOT EXISTS learning_sessions (id TEXT NOT NULL PRIMARY KEY, learner_id TEXT NOT NULL, focus TEXT NOT NULL, status TEXT NOT NULL CHECK(status IN ('active','completed')), current_step INTEGER NOT NULL, total_steps INTEGER NOT NULL, started_at TEXT NOT NULL, completed_at TEXT, updated_at TEXT NOT NULL) STRICT",
    );
    _database.execute(
      "CREATE TABLE IF NOT EXISTS practice_responses (id TEXT NOT NULL PRIMARY KEY, learner_id TEXT NOT NULL, session_id TEXT NOT NULL, activity_key TEXT NOT NULL, activity_type TEXT NOT NULL, response_text TEXT NOT NULL, is_correct INTEGER, created_at TEXT NOT NULL, FOREIGN KEY(session_id) REFERENCES learning_sessions(id) ON DELETE CASCADE) STRICT",
    );
    _database.execute(
      'CREATE INDEX IF NOT EXISTS idx_sessions_learner_status ON learning_sessions (learner_id, status, updated_at)',
    );
    _database.execute(
      'CREATE INDEX IF NOT EXISTS idx_responses_learner_session ON practice_responses (learner_id, session_id, created_at)',
    );
  }

  void _createAdaptiveSchema() {
    _database.execute(
      "CREATE TABLE IF NOT EXISTS activity_mastery (learner_id TEXT NOT NULL, activity_key TEXT NOT NULL, skill TEXT NOT NULL, attempts INTEGER NOT NULL DEFAULT 0, mastery REAL NOT NULL DEFAULT 0, next_review_at TEXT NOT NULL, PRIMARY KEY(learner_id, activity_key)) STRICT",
    );
    _database.execute(
      "CREATE TABLE IF NOT EXISTS session_activities (session_id TEXT NOT NULL, learner_id TEXT NOT NULL, position INTEGER NOT NULL, activity_key TEXT NOT NULL, PRIMARY KEY(session_id, position), FOREIGN KEY(session_id) REFERENCES learning_sessions(id) ON DELETE CASCADE) STRICT",
    );
  }

  void close() => _database.close();
}
