class TopicMastery {
  final String studentId;
  final String topic;
  final double score;
  final int questionsAttempted;
  final int questionsSolved;
  final double averageTimeSeconds;
  final DateTime lastUpdated;

  const TopicMastery({
    required this.studentId,
    required this.topic,
    required this.score,
    required this.questionsAttempted,
    required this.questionsSolved,
    required this.averageTimeSeconds,
    required this.lastUpdated,
  });

  TopicMastery copyWith({
    double? score,
    int? questionsAttempted,
    int? questionsSolved,
    double? averageTimeSeconds,
    DateTime? lastUpdated,
  }) {
    return TopicMastery(
      studentId: studentId,
      topic: topic,
      score: score ?? this.score,
      questionsAttempted:
          questionsAttempted ?? this.questionsAttempted,
      questionsSolved: questionsSolved ?? this.questionsSolved,
      averageTimeSeconds:
          averageTimeSeconds ?? this.averageTimeSeconds,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}