enum GoalStatus { active, archived, completed }

final class LearnerGoal {
  const LearnerGoal({
    required this.createdAt,
    required this.description,
    required this.id,
    required this.learnerId,
    required this.occupationalContext,
    required this.priority,
    required this.status,
    required this.title,
    required this.updatedAt,
    this.targetDate,
  });

  final DateTime createdAt;
  final String description;
  final String id;
  final String learnerId;
  final String occupationalContext;
  final int priority;
  final GoalStatus status;
  final DateTime? targetDate;
  final String title;
  final DateTime updatedAt;
}
