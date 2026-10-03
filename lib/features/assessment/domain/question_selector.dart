import 'assessment_models.dart';

/// The adaptive engine implements this interface later.
abstract class QuestionSelector {
  /// Returns null when the assessment should end.
  Future<AssessmentQuestion?> next({
    required List<AssessmentQuestion> pool,
    required List<AttemptRecord> history,
    required int maxQuestions,
  });
}

/// Temporary selector: passed last question -> harder, failed -> easier.
class SimpleSelector implements QuestionSelector {
  static const _order = ['Easy', 'Medium', 'Hard'];

  @override
  Future<AssessmentQuestion?> next({
    required List<AssessmentQuestion> pool,
    required List<AttemptRecord> history,
    required int maxQuestions,
  }) async {
    if (history.length >= maxQuestions) return null;
    final seen = history.map((h) => h.question.id).toSet();
    final unseen = pool.where((q) => !seen.contains(q.id)).toList();
    if (unseen.isEmpty) return null;
    if (history.isEmpty) {
      return unseen.firstWhere((q) => q.difficulty == 'Easy',
          orElse: () => unseen.first);
    }
    final last = history.last;
    var idx = _order.indexOf(last.question.difficulty);
    idx = last.result.passRatio >= 0.8 ? idx + 1 : idx - 1;
    final target = _order[idx.clamp(0, 2)];
    return unseen.firstWhere((q) => q.difficulty == target,
        orElse: () => unseen.first);
  }
}