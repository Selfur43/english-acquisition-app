import 'dart:io';

void main() {
  const files = [
    'pubspec.yaml',
    'lib/main.dart',
    'lib/core/persistence/local_database.dart',
    'lib/features/ai_coach/ai_coach.dart',
    'lib/features/learning_session/curriculum.dart',
    'lib/features/learning_session/learning_session.dart',
    'lib/features/learning_session/application/learning_session_controller.dart',
    'lib/features/learning_session/presentation/learning_plan_page.dart',
    'lib/features/learning_session/presentation/learning_session_page.dart',
    'lib/features/learning_session/presentation/progress_page.dart',
    'test/adaptive_curriculum_test.dart',
  ];
  final missing = files.where((f) => !File(f).existsSync()).toList();
  if (missing.isNotEmpty) {
    stderr.writeln(missing);
    exitCode = 1;
  } else {
    stdout.writeln('v0.4.5 structure verified.');
  }
}
