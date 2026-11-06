import 'package:english_acquisition_app/core/persistence/local_database.dart';
import 'package:english_acquisition_app/features/learning_session/curriculum.dart';
import 'package:english_acquisition_app/features/learning_session/learning_session.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('mastery records expose persisted attempt counts', () {
    final database = LocalDatabase.inMemory();
    addTearDown(database.close);
    const learnerId = 'learner-1';
    const repositoryActivity = ProcurementCurriculum.activities;
    final repository = LearningSessionRepository(database);
    final activity = repositoryActivity.first;
    repository.record(learnerId, activity, 70);
    repository.record(learnerId, activity, 90);
    final mastery = repository.mastery(learnerId).single;
    expect(mastery.activityId, activity.id);
    expect(mastery.attempts, 2);
    expect(mastery.mastery, greaterThan(0));
  });
}
