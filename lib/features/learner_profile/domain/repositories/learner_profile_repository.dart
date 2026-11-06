import '../entities/learner_profile.dart';

abstract interface class LearnerProfileRepository {
  Future<LearnerProfile?> load(String learnerId);
  Future<void> save(LearnerProfile profile);
}
