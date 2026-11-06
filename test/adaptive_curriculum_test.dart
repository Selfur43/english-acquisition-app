import 'package:english_acquisition_app/core/persistence/local_database.dart';
import 'package:english_acquisition_app/features/learning_session/application/learning_session_controller.dart';
import 'package:english_acquisition_app/features/learning_session/learning_session.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('adaptive mastery is learner scoped', () {
    final db = LocalDatabase.inMemory(),
        c = LearningSessionController(LearningSessionRepository(db), 'one');
    c.load();
    c.start();
    expect(c.queue, hasLength(8));
    expect(c.check('RFQ'), isTrue);
    c.next();
    expect(c.mastery, isNotEmpty);
    final o = LearningSessionController(LearningSessionRepository(db), 'two');
    o.load();
    expect(o.mastery, isEmpty);
    db.close();
  });
}
