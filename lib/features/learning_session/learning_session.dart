import '../../core/persistence/local_database.dart';
import 'curriculum.dart';

enum LearningSessionStatus { active, completed }

final class LearningSession {
  const LearningSession({
    required this.id,
    required this.learnerId,
    required this.status,
    required this.currentStep,
    required this.totalSteps,
    required this.startedAt,
    required this.updatedAt,
    this.completedAt,
  });
  final String id, learnerId;
  final LearningSessionStatus status;
  final int currentStep, totalSteps;
  final DateTime startedAt, updatedAt;
  final DateTime? completedAt;
}

final class MasteryRecord {
  const MasteryRecord(this.activityId, this.skill, this.mastery, this.attempts);
  final String activityId, skill;
  final double mastery;
  final int attempts;
}

final class LearningSessionRepository {
  const LearningSessionRepository(this.db);
  final LocalDatabase db;
  LearningSession? active(String l) {
    final r = db.raw.select(
      "SELECT * FROM learning_sessions WHERE learner_id=? AND status='active' ORDER BY updated_at DESC LIMIT 1",
      [l],
    );
    return r.isEmpty ? null : _m(r.first);
  }

  List<LearningSession> history(String l) => db.raw
      .select(
        "SELECT * FROM learning_sessions WHERE learner_id=? AND status='completed'",
        [l],
      )
      .map(_m)
      .toList();
  void save(LearningSession s) => db.raw.execute(
    "INSERT INTO learning_sessions VALUES(?,?,?,?,?,?,?,?,?) ON CONFLICT(id) DO UPDATE SET status=excluded.status,current_step=excluded.current_step,total_steps=excluded.total_steps,completed_at=excluded.completed_at,updated_at=excluded.updated_at",
    [
      s.id,
      s.learnerId,
      'Adaptive procurement English',
      s.status.name,
      s.currentStep,
      s.totalSteps,
      s.startedAt.toIso8601String(),
      s.completedAt?.toIso8601String(),
      s.updatedAt.toIso8601String(),
    ],
  );
  void saveQueue(String l, String id, List<CurriculumActivity> q) {
    db.raw.execute(
      'DELETE FROM session_activities WHERE learner_id=? AND session_id=?',
      [l, id],
    );
    for (var i = 0; i < q.length; i++) {
      db.raw.execute('INSERT INTO session_activities VALUES(?,?,?,?)', [
        id,
        l,
        i,
        q[i].id,
      ]);
    }
  }

  List<String> loadQueue(String l, String id) => db.raw
      .select(
        'SELECT activity_key FROM session_activities WHERE learner_id=? AND session_id=? ORDER BY position',
        [l, id],
      )
      .map((r) => r['activity_key'] as String)
      .toList();
  List<MasteryRecord> mastery(String l) => db.raw
      .select('SELECT * FROM activity_mastery WHERE learner_id=?', [l])
      .map(
        (r) => MasteryRecord(
          r['activity_key'] as String,
          r['skill'] as String,
          r['mastery'] as double,
          r['attempts'] as int,
        ),
      )
      .toList();
  void record(String l, CurriculumActivity a, int score) {
    final n = DateTime.now().toUtc(),
        old = db.raw.select(
          'SELECT attempts,mastery FROM activity_mastery WHERE learner_id=? AND activity_key=?',
          [l, a.id],
        ),
        attempts = old.isEmpty ? 1 : (old.first['attempts'] as int) + 1,
        previous = old.isEmpty ? 0.0 : old.first['mastery'] as double,
        m = (previous * .65 + score / 100 * .35).clamp(0.0, 1.0);
    db.raw.execute(
      'INSERT INTO activity_mastery VALUES(?,?,?,?,?,?) ON CONFLICT(learner_id,activity_key) DO UPDATE SET attempts=excluded.attempts,mastery=excluded.mastery,next_review_at=excluded.next_review_at',
      [
        l,
        a.id,
        a.skill.name,
        attempts,
        m,
        n
            .add(
              Duration(
                days: m >= .8
                    ? 7
                    : m >= .6
                    ? 3
                    : 1,
              ),
            )
            .toIso8601String(),
      ],
    );
  }

  LearningSession _m(dynamic r) => LearningSession(
    id: r['id'] as String,
    learnerId: r['learner_id'] as String,
    status: LearningSessionStatus.values.byName(r['status'] as String),
    currentStep: r['current_step'] as int,
    totalSteps: r['total_steps'] as int,
    startedAt: DateTime.parse(r['started_at'] as String),
    completedAt: r['completed_at'] == null
        ? null
        : DateTime.parse(r['completed_at'] as String),
    updatedAt: DateTime.parse(r['updated_at'] as String),
  );
}
