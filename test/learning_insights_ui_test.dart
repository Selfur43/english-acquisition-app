import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('learning insights exposes private evidence and adaptive actions', () {
    final source = File(
      'lib/features/learning_session/presentation/learning_insights_page.dart',
    ).readAsStringSync();
    for (final text in <String>[
      'Private learning evidence',
      'Overall mastery',
      'Completed sessions',
      'Today queue',
      'Priority review',
      'Continue learning',
    ]) {
      expect(source, contains(text));
    }
  });
  test('home exposes guidance and insights navigation', () {
    final source = File(
      'lib/features/home/presentation/pages/home_page.dart',
    ).readAsStringSync();
    expect(source, contains('Recommended setup'));
    expect(source, contains('Learning insights'));
    expect(source, contains("context.go('/insights')"));
  });
  test('Windows runner uses product title', () {
    final source = File('windows/runner/main.cpp').readAsStringSync();
    expect(source, contains('AI English Reflex Coach'));
  });
}
