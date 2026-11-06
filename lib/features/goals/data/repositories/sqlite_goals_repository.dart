import '../../../../core/persistence/local_database.dart';
import '../../domain/entities/learner_goal.dart';
import '../../domain/repositories/goals_repository.dart';

final class SqliteGoalsRepository implements GoalsRepository {
  const SqliteGoalsRepository(this._database);
  final LocalDatabase _database;

  @override
  Future<void> delete({
    required String goalId,
    required String learnerId,
  }) async {
    _database.raw.execute(
      'DELETE FROM learner_goals WHERE id = ? AND learner_id = ?',
      [goalId, learnerId],
    );
  }

  @override
  Future<List<LearnerGoal>> load(String learnerId) async {
    final rows = _database.raw.select(
      '''
      SELECT * FROM learner_goals
      WHERE learner_id = ?
      ORDER BY CASE status WHEN 'active' THEN 0 WHEN 'completed' THEN 1 ELSE 2 END,
               priority ASC, updated_at DESC
    ''',
      [learnerId],
    );
    return rows
        .map(
          (row) => LearnerGoal(
            createdAt: DateTime.parse(row['created_at'] as String),
            description: row['description'] as String,
            id: row['id'] as String,
            learnerId: row['learner_id'] as String,
            occupationalContext: row['occupational_context'] as String,
            priority: row['priority'] as int,
            status: GoalStatus.values.byName(row['status'] as String),
            targetDate: row['target_date'] == null
                ? null
                : DateTime.parse(row['target_date'] as String),
            title: row['title'] as String,
            updatedAt: DateTime.parse(row['updated_at'] as String),
          ),
        )
        .toList(growable: false);
  }

  @override
  Future<void> save(LearnerGoal goal) async {
    _database.raw.execute(
      '''
      INSERT INTO learner_goals (
        id, learner_id, title, description, occupational_context,
        priority, status, target_date, created_at, updated_at
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      ON CONFLICT(id) DO UPDATE SET
        title = excluded.title,
        description = excluded.description,
        occupational_context = excluded.occupational_context,
        priority = excluded.priority,
        status = excluded.status,
        target_date = excluded.target_date,
        updated_at = excluded.updated_at
      WHERE learner_goals.learner_id = excluded.learner_id;
    ''',
      [
        goal.id,
        goal.learnerId,
        goal.title,
        goal.description,
        goal.occupationalContext,
        goal.priority,
        goal.status.name,
        goal.targetDate?.toUtc().toIso8601String(),
        goal.createdAt.toUtc().toIso8601String(),
        goal.updatedAt.toUtc().toIso8601String(),
      ],
    );
  }
}
