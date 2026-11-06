import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('simulation lab covers realistic general and workplace contexts', () {
    final s = File(
      'lib/features/simulation/presentation/simulation_lab_page.dart',
    ).readAsStringSync();
    for (final text in [
      'Face-to-face supplier negotiation',
      'Factory visit and production walk',
      'Teams meeting: delivery recovery',
      'Email chain: quotation clarification',
      'Everyday conversation and small talk',
      'Presentation and challenging Q&A',
      'Quality incident and 8D discussion',
      'Phone call: urgent logistics update',
      'Travel disruption and hotel problem',
      'Conference networking',
      'Executive crisis call: production stop',
      'Customer complaint and service recovery',
      'International job interview',
      'Factory safety briefing and incident response',
    ]) {
      expect(s, contains(text));
    }
    expect(
      RegExp('SimulationScenario\\(', multiLine: true).allMatches(s).length,
      greaterThanOrEqualTo(16),
    );
    expect(s, contains('Simulation review'));
    expect(s, contains('Coaching hint'));
  });
}
