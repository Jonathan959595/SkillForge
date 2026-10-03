enum SubmissionStatus {
  pending,
  accepted,
  wrongAnswer,
  timeLimit,
  runtimeError,
  compilationError,
}

class Submission {
  final String id;
  final String questionId;
  final String studentId;
  final String code;
  final String language;
  final DateTime submittedAt;
  final SubmissionStatus status;
  final double executionTimeMs;
  final int? memoryUsedKb;

  const Submission({
    required this.id,
    required this.questionId,
    required this.studentId,
    required this.code,
    required this.language,
    required this.submittedAt,
    required this.status,
    required this.executionTimeMs,
    this.memoryUsedKb,
  });
}