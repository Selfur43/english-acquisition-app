import 'package:english_acquisition_app/core/persistence/local_database.dart';
import 'package:english_acquisition_app/features/goals/data/repositories/sqlite_goals_repository.dart';
import 'package:english_acquisition_app/features/goals/domain/entities/learner_goal.dart';
import 'package:english_acquisition_app/features/learner_profile/data/repositories/sqlite_learner_profile_repository.dart';
import 'package:english_acquisition_app/features/learner_profile/domain/entities/learner_profile.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('profiles and goals are isolated by learner id', () async {
    final db = LocalDatabase.inMemory();
    final profiles = SqliteLearnerProfileRepository(db);
    final goals = SqliteGoalsRepository(db);
    final now = DateTime.utc(2026, 1, 1);
    await profiles.save(
      LearnerProfile(
        accessibilityNotes: '',
        communicationTasks: 'Supplier meetings',
        displayName: 'Furkan',
        englishLevel: 'B1',
        industry: 'Automotive',
        learnerId: 'learner-1',
        nativeLanguage: 'Turkish',
        occupationalRole: 'Procurement',
        preferredSessionMinutes: 25,
        procurementExperienceYears: 1,
        updatedAt: now,
      ),
    );
    await goals.save(
      LearnerGoal(
        createdAt: now,
        description: '',
        id: 'g1',
        learnerId: 'learner-1',
        occupationalContext: 'RFQ',
        priority: 1,
        status: GoalStatus.active,
        title: 'Clarify RFQs',
        updatedAt: now,
      ),
    );
    expect((await profiles.load('learner-1'))?.displayName, 'Furkan');
    expect(await profiles.load('learner-2'), isNull);
    expect((await goals.load('learner-1')).length, 1);
    expect(await goals.load('learner-2'), isEmpty);
    db.close();
  });
}
