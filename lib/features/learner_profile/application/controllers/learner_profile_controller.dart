import 'package:flutter/foundation.dart';

import '../../domain/entities/learner_profile.dart';
import '../../domain/repositories/learner_profile_repository.dart';

final class LearnerProfileController extends ChangeNotifier {
  LearnerProfileController(this._repository, this.learnerId);

  final LearnerProfileRepository _repository;
  final String learnerId;

  String? errorMessage;
  bool isBusy = false;
  LearnerProfile? profile;

  Future<void> load() async {
    isBusy = true;
    notifyListeners();
    try {
      profile = await _repository.load(learnerId);
      errorMessage = null;
    } catch (_) {
      errorMessage = 'The learner profile could not be loaded.';
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }

  Future<bool> save(LearnerProfile value) async {
    if (!value.isComplete || value.preferredSessionMinutes < 5) {
      errorMessage = 'Complete the required profile fields.';
      notifyListeners();
      return false;
    }
    isBusy = true;
    notifyListeners();
    try {
      await _repository.save(value);
      profile = value;
      errorMessage = null;
      return true;
    } catch (_) {
      errorMessage = 'The learner profile could not be saved.';
      return false;
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }
}
