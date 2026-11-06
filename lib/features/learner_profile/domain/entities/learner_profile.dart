final class LearnerProfile {
  const LearnerProfile({
    required this.accessibilityNotes,
    required this.communicationTasks,
    required this.displayName,
    required this.englishLevel,
    required this.industry,
    required this.learnerId,
    required this.nativeLanguage,
    required this.occupationalRole,
    required this.preferredSessionMinutes,
    required this.procurementExperienceYears,
    required this.updatedAt,
  });

  final String accessibilityNotes;
  final String communicationTasks;
  final String displayName;
  final String englishLevel;
  final String industry;
  final String learnerId;
  final String nativeLanguage;
  final String occupationalRole;
  final int preferredSessionMinutes;
  final int procurementExperienceYears;
  final DateTime updatedAt;

  bool get isComplete =>
      displayName.trim().isNotEmpty &&
      nativeLanguage.trim().isNotEmpty &&
      englishLevel.trim().isNotEmpty &&
      occupationalRole.trim().isNotEmpty;
}
