import '../entities/learner_goal.dart';

abstract interface class GoalsRepository {
  Future<void> delete({required String goalId, required String learnerId});
  Future<List<LearnerGoal>> load(String learnerId);
  Future<void> save(LearnerGoal goal);
}
