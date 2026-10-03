import '../models/question.dart';
import '../models/topic_mastery.dart';

class AdaptiveEngine {
  const AdaptiveEngine();

  Question selectNextQuestion({
    required List<Question> availableQuestions,
    required List<TopicMastery> mastery,
    Set<String> attemptedQuestionIds = const {},
  }) {
    final unattempted = availableQuestions
        .where((q) => !attemptedQuestionIds.contains(q.id))
        .toList();

    if (unattempted.isEmpty) {
      return availableQuestions.first;
    }

    // Find the weakest topic.
    final sortedMastery = [...mastery]
      ..sort((a, b) => a.score.compareTo(b.score));

    final weakestTopic =
        sortedMastery.isNotEmpty ? sortedMastery.first.topic : null;

    // Prioritize questions from the weakest topic.
    final weakTopicQuestions = unattempted
        .where((q) => q.topic == weakestTopic)
        .toList();

    if (weakTopicQuestions.isNotEmpty) {
      return _selectByDifficulty(
        weakTopicQuestions,
        sortedMastery.isNotEmpty ? sortedMastery.first.score : 0.5,
      );
    }

    // Otherwise select based on overall mastery.
    return _selectByDifficulty(
      unattempted,
      sortedMastery.isNotEmpty ? sortedMastery.first.score : 0.5,
    );
  }

  Question _selectByDifficulty(
    List<Question> questions,
    double masteryScore,
  ) {
    Difficulty targetDifficulty;

    if (masteryScore < 0.40) {
      targetDifficulty = Difficulty.easy;
    } else if (masteryScore < 0.70) {
      targetDifficulty = Difficulty.medium;
    } else {
      targetDifficulty = Difficulty.hard;
    }

    final matching = questions
        .where((q) => q.difficulty == targetDifficulty)
        .toList();

    return matching.isNotEmpty ? matching.first : questions.first;
  }

  TopicMastery updateMastery({
    required TopicMastery current,
    required bool passed,
    required int solvingTimeSeconds,
    required int expectedTimeSeconds,
  }) {
    double newScore = current.score;

    if (passed) {
      newScore += 0.08;

      // Reward solving faster than expected.
      if (solvingTimeSeconds < expectedTimeSeconds) {
        newScore += 0.04;
      }
    } else {
      newScore -= 0.10;
    }

    newScore = newScore.clamp(0.0, 1.0);

    final attempts = current.questionsAttempted + 1;
    final solved =
        current.questionsSolved + (passed ? 1 : 0);

    final averageTime =
        ((current.averageTimeSeconds * current.questionsAttempted) +
                solvingTimeSeconds) /
            attempts;

    return current.copyWith(
      score: newScore,
      questionsAttempted: attempts,
      questionsSolved: solved,
      averageTimeSeconds: averageTime,
      lastUpdated: DateTime.now(),
    );
  }
}