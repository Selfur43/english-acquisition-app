import '../learning_session/curriculum.dart';

final class CoachFeedback {
  const CoachFeedback(
    this.score,
    this.message,
    this.strengths,
    this.targets,
    this.model,
  );
  final int score;
  final String message, model;
  final List<String> strengths, targets;
}

final class OfflineProcurementAiCoach {
  const OfflineProcurementAiCoach();
  CoachFeedback evaluate(CurriculumActivity a, String response) {
    final t = response.trim(),
        lower = t.toLowerCase(),
        strengths = <String>[],
        targets = <String>[];
    if (t.length >= 15) {
      strengths.add('Complete response.');
    } else {
      targets.add('Write a complete sentence.');
    }
    if (RegExp(r'please|could you|would you').hasMatch(lower)) {
      strengths.add('Professional tone.');
    } else if (a.kind == ActivityKind.writing ||
        a.kind == ActivityKind.simulation) {
      targets.add('Use a polite request phrase.');
    }
    final exact = a.answer.isNotEmpty && _n(t).contains(_n(a.answer));
    final score =
        ((exact ? 85 : 55) + strengths.length * 5 - targets.length * 5)
            .clamp(0, 100)
            .toInt();
    return CoachFeedback(
      score,
      score >= 75 ? 'Strong response.' : 'Good attempt. Apply the feedback.',
      strengths,
      targets,
      a.model,
    );
  }

  String _n(String s) => s
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9 ]'), '')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}
