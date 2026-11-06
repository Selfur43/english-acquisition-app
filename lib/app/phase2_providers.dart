import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/persistence/local_database.dart';
import '../features/authentication/authentication.dart';
import '../features/goals/application/controllers/goals_controller.dart';
import '../features/goals/data/repositories/sqlite_goals_repository.dart';
import '../features/learner_profile/application/controllers/learner_profile_controller.dart';
import '../features/learner_profile/data/repositories/sqlite_learner_profile_repository.dart';
import '../features/learning_session/application/learning_session_controller.dart';
import '../features/learning_session/learning_session.dart';

final localDatabaseProvider = FutureProvider<LocalDatabase>((ref) async {
  final database = await LocalDatabase.open();
  ref.onDispose(database.close);
  return database;
});

final learnerProfileControllerProvider =
    FutureProvider.autoDispose<LearnerProfileController>((ref) async {
      final user = ref.watch(authenticationControllerProvider).user;
      if (user == null) throw StateError('Authentication is required.');
      final database = await ref.watch(localDatabaseProvider.future);
      final controller = LearnerProfileController(
        SqliteLearnerProfileRepository(database),
        user.id,
      );
      ref.onDispose(controller.dispose);
      await controller.load();
      return controller;
    });

final goalsControllerProvider = FutureProvider.autoDispose<GoalsController>((
  ref,
) async {
  final user = ref.watch(authenticationControllerProvider).user;
  if (user == null) throw StateError('Authentication is required.');
  final database = await ref.watch(localDatabaseProvider.future);
  final controller = GoalsController(SqliteGoalsRepository(database), user.id);
  ref.onDispose(controller.dispose);
  await controller.load();
  return controller;
});

final learningSessionControllerProvider =
    FutureProvider.autoDispose<LearningSessionController>((ref) async {
      final user = ref.watch(authenticationControllerProvider).user;
      if (user == null) throw StateError('Authentication is required.');
      final database = await ref.watch(localDatabaseProvider.future);
      final controller = LearningSessionController(
        LearningSessionRepository(database),
        user.id,
      );
      ref.onDispose(controller.dispose);
      controller.load();
      return controller;
    });
