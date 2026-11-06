import 'package:flutter/foundation.dart';
import '../../ai_coach/ai_coach.dart';
import '../curriculum.dart';
import '../learning_session.dart';

final class LearningSessionController extends ChangeNotifier {
  LearningSessionController(this.repo, this.learnerId);
  final LearningSessionRepository repo;
  final String learnerId;
  final coach = const OfflineProcurementAiCoach();
  LearningSession? session;
  List<LearningSession> history = [];
  List<CurriculumActivity> queue = [];
  CoachFeedback? feedback;
  String? errorMessage;
  CurriculumActivity? get current =>
      session == null || session!.currentStep >= queue.length
      ? null
      : queue[session!.currentStep];
  List<MasteryRecord> get mastery => repo.mastery(learnerId);
  double get overallMastery => mastery.isEmpty
      ? 0
      : mastery.map((e) => e.mastery).reduce((a, b) => a + b) / mastery.length;
  void load() {
    history = repo.history(learnerId);
    session = repo.active(learnerId);
    if (session != null) {
      final ids = repo.loadQueue(learnerId, session!.id);
      queue = ids
          .map(
            (id) =>
                ProcurementCurriculum.activities.firstWhere((a) => a.id == id),
          )
          .toList();
    }
    if (queue.isEmpty) _build();
    notifyListeners();
  }

  void _build() {
    final scores = {for (final m in mastery) m.activityId: m.mastery},
        items = [...ProcurementCurriculum.activities]
          ..sort((a, b) => (scores[a.id] ?? 0).compareTo(scores[b.id] ?? 0));
    queue = items.take(8).toList();
  }

  void start() {
    _build();
    final n = DateTime.now().toUtc();
    session = LearningSession(
      id: '$learnerId-${n.microsecondsSinceEpoch}',
      learnerId: learnerId,
      status: LearningSessionStatus.active,
      currentStep: 0,
      totalSteps: queue.length,
      startedAt: n,
      updatedAt: n,
    );
    repo.save(session!);
    repo.saveQueue(learnerId, session!.id, queue);
    notifyListeners();
  }

  bool check(String answer) {
    final a = current;
    if (a == null || answer.trim().isEmpty) {
      errorMessage = 'Write or select an answer.';
      notifyListeners();
      return false;
    }
    feedback = coach.evaluate(a, answer);
    repo.record(learnerId, a, feedback!.score);
    errorMessage = null;
    notifyListeners();
    return true;
  }

  void next() {
    final s = session;
    if (s == null || feedback == null) return;
    final step = s.currentStep + 1, n = DateTime.now().toUtc();
    session = LearningSession(
      id: s.id,
      learnerId: s.learnerId,
      status: step >= queue.length
          ? LearningSessionStatus.completed
          : LearningSessionStatus.active,
      currentStep: step,
      totalSteps: queue.length,
      startedAt: s.startedAt,
      completedAt: step >= queue.length ? n : null,
      updatedAt: n,
    );
    repo.save(session!);
    feedback = null;
    history = repo.history(learnerId);
    notifyListeners();
  }
}
