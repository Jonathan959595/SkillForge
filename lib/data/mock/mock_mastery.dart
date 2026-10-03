import '../../core/models/topic_mastery.dart';

final mockMastery = <TopicMastery>[
  TopicMastery(
    studentId: 'student_1',
    topic: 'Arrays',
    score: 0.78,
    questionsAttempted: 8,
    questionsSolved: 7,
    averageTimeSeconds: 280,
    lastUpdated: DateTime.now(),
  ),
  TopicMastery(
    studentId: 'student_1',
    topic: 'Strings',
    score: 0.62,
    questionsAttempted: 6,
    questionsSolved: 4,
    averageTimeSeconds: 350,
    lastUpdated: DateTime.now(),
  ),
  TopicMastery(
    studentId: 'student_1',
    topic: 'Linked Lists',
    score: 0.45,
    questionsAttempted: 5,
    questionsSolved: 2,
    averageTimeSeconds: 500,
    lastUpdated: DateTime.now(),
  ),
  TopicMastery(
    studentId: 'student_1',
    topic: 'Graphs',
    score: 0.31,
    questionsAttempted: 4,
    questionsSolved: 1,
    averageTimeSeconds: 700,
    lastUpdated: DateTime.now(),
  ),
];