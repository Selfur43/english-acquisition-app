import 'package:english_acquisition_app/core/persistence/local_database.dart';
import 'package:english_acquisition_app/features/learner_profile/application/controllers/learner_profile_controller.dart';
import 'package:english_acquisition_app/features/learner_profile/data/repositories/sqlite_learner_profile_repository.dart';
import 'package:english_acquisition_app/features/learner_profile/domain/entities/learner_profile.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('incomplete profile is rejected', () async {
    final db = LocalDatabase.inMemory();
    final c = LearnerProfileController(
      SqliteLearnerProfileRepository(db),
      'learner-1',
    );
    final result = await c.save(
      LearnerProfile(
        accessibilityNotes: '',
        communicationTasks: '',
        displayName: '',
        englishLevel: 'B1',
        industry: '',
        learnerId: 'learner-1',
        nativeLanguage: '',
        occupationalRole: '',
        preferredSessionMinutes: 25,
        procurementExperienceYears: 0,
        updatedAt: DateTime.now(),
      ),
    );
    expect(result, isFalse);
    expect(c.errorMessage, isNotNull);
    db.close();
  });
}
