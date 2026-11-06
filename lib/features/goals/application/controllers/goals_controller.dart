import 'package:flutter/foundation.dart';

import '../../domain/entities/learner_goal.dart';
import '../../domain/repositories/goals_repository.dart';

final class GoalsController extends ChangeNotifier {
  GoalsController(this._repository, this.learnerId);

  final GoalsRepository _repository;
  final String learnerId;

  String? errorMessage;
  List<LearnerGoal> goals = const [];
  bool isBusy = false;

  Future<void> load() async {
    isBusy = true;
    notifyListeners();
    try {
      goals = await _repository.load(learnerId);
      errorMessage = null;
    } catch (_) {
      errorMessage = 'Goals could not be loaded.';
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }

  Future<bool> save(LearnerGoal goal) async {
    if (goal.learnerId != learnerId || goal.title.trim().isEmpty) {
      errorMessage = 'Enter a goal title.';
      notifyListeners();
      return false;
    }
    isBusy = true;
    notifyListeners();
    try {
      await _repository.save(goal);
      goals = await _repository.load(learnerId);
      errorMessage = null;
      return true;
    } catch (_) {
      errorMessage = 'The goal could not be saved.';
      return false;
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }

  Future<void> delete(String goalId) async {
    await _repository.delete(goalId: goalId, learnerId: learnerId);
    goals = await _repository.load(learnerId);
    notifyListeners();
  }
}
