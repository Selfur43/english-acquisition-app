import '../../../../core/persistence/local_database.dart';
import '../../domain/entities/learner_profile.dart';
import '../../domain/repositories/learner_profile_repository.dart';

final class SqliteLearnerProfileRepository implements LearnerProfileRepository {
  const SqliteLearnerProfileRepository(this._database);
  final LocalDatabase _database;

  @override
  Future<LearnerProfile?> load(String learnerId) async {
    final rows = _database.raw.select(
      'SELECT * FROM learner_profiles WHERE learner_id = ?',
      [learnerId],
    );
    if (rows.isEmpty) return null;
    final row = rows.first;
    return LearnerProfile(
      accessibilityNotes: row['accessibility_notes'] as String,
      communicationTasks: row['communication_tasks'] as String,
      displayName: row['display_name'] as String,
      englishLevel: row['english_level'] as String,
      industry: row['industry'] as String,
      learnerId: row['learner_id'] as String,
      nativeLanguage: row['native_language'] as String,
      occupationalRole: row['occupational_role'] as String,
      preferredSessionMinutes: row['preferred_session_minutes'] as int,
      procurementExperienceYears: row['procurement_experience_years'] as int,
      updatedAt: DateTime.parse(row['updated_at'] as String),
    );
  }

  @override
  Future<void> save(LearnerProfile profile) async {
    _database.raw.execute(
      '''
      INSERT INTO learner_profiles (
        learner_id, display_name, native_language, english_level,
        occupational_role, industry, procurement_experience_years,
        communication_tasks, preferred_session_minutes,
        accessibility_notes, updated_at
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      ON CONFLICT(learner_id) DO UPDATE SET
        display_name = excluded.display_name,
        native_language = excluded.native_language,
        english_level = excluded.english_level,
        occupational_role = excluded.occupational_role,
        industry = excluded.industry,
        procurement_experience_years = excluded.procurement_experience_years,
        communication_tasks = excluded.communication_tasks,
        preferred_session_minutes = excluded.preferred_session_minutes,
        accessibility_notes = excluded.accessibility_notes,
        updated_at = excluded.updated_at;
    ''',
      [
        profile.learnerId,
        profile.displayName,
        profile.nativeLanguage,
        profile.englishLevel,
        profile.occupationalRole,
        profile.industry,
        profile.procurementExperienceYears,
        profile.communicationTasks,
        profile.preferredSessionMinutes,
        profile.accessibilityNotes,
        profile.updatedAt.toUtc().toIso8601String(),
      ],
    );
  }
}
