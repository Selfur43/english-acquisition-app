import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('home page exposes lock and profile-switch controls', () {
    final source = File(
      'lib/features/home/presentation/pages/home_page.dart',
    ).readAsStringSync();
    expect(source, contains('Switch profile'));
    expect(source, contains('Lock now'));
    expect(source, contains('PIN required again after every restart'));
    expect(
      source,
      contains('ref.invalidate(learnerProfileControllerProvider)'),
    );
    expect(source, contains('ref.invalidate(goalsControllerProvider)'));
    expect(
      source,
      contains('ref.invalidate(learningSessionControllerProvider)'),
    );
  });
}
