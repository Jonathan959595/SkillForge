enum AssessmentStatus {
  notStarted,
  inProgress,
  completed,
}

class QuestionAttempt {
  final String id;
  final String questionId;
  final DateTime startedAt;
  final DateTime? submittedAt;
  final bool? passed;
  final int? solvingTimeSeconds;

  const QuestionAttempt({
    required this.id,
    required this.questionId,
    required this.startedAt,
    this.submittedAt,
    this.passed,
    this.solvingTimeSeconds,
  });
}

class Assessment {
  final String id;
  final String studentId;
  final DateTime startedAt;
  final DateTime? completedAt;
  final AssessmentStatus status;
  final List<QuestionAttempt> attempts;

  const Assessment({
    required this.id,
    required this.studentId,
    required this.startedAt,
    this.completedAt,
    required this.status,
    this.attempts = const [],
  });
}