import 'package:english_acquisition_app/core/persistence/local_database.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('current schema keeps every learner-owned table scoped', () {
    final database = LocalDatabase.inMemory();
    expect(database.raw.userVersion, LocalDatabase.currentSchemaVersion);
    for (final table in <String>[
      'learner_profiles',
      'learner_goals',
      'learning_sessions',
      'practice_responses',
      'activity_mastery',
      'session_activities',
    ]) {
      final columns = database.raw
          .select('PRAGMA table_info($table)')
          .map((row) => row['name'] as String)
          .toSet();
      expect(
        columns,
        contains('learner_id'),
        reason: '$table must be learner-scoped',
      );
    }
    database.close();
  });
}
