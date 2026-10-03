import 'package:flutter/foundation.dart';
import '../domain/assessment_models.dart';
import '../domain/code_execution_service.dart';
import '../domain/execution_models.dart';
import '../domain/question_selector.dart';

enum SessionState { idle, loadingQuestion, answering, submitting, showingResult, finished }

class AssessmentController extends ChangeNotifier {
  final CodeExecutionService executor;
  final QuestionSelector selector;
  final List<AssessmentQuestion> pool;
  final int maxQuestions;

  AssessmentController({
    required this.executor,
    required this.selector,
    required this.pool,
    this.maxQuestions = 5,
  });

  SessionState state = SessionState.idle;
  AssessmentQuestion? current;
  final List<AttemptRecord> history = [];
  AttemptRecord? lastAttempt;
  String? error;
  bool running = false;
  ExecutionResult? sampleResult;
  DateTime? _questionStart;

  Future<void> start() async {
    history.clear();
    lastAttempt = null;
    await _loadNext();
  }

  Future<void> _loadNext() async {
    state = SessionState.loadingQuestion;
    sampleResult = null;
    error = null;
    notifyListeners();
    current = await selector.next(
        pool: pool, history: history, maxQuestions: maxQuestions);
    if (current == null) {
      state = SessionState.finished;
    } else {
      _questionStart = DateTime.now();
      state = SessionState.answering;
    }
    notifyListeners();
  }

  /// Run: only the first 2 tests, does not count as an attempt.
  Future<void> runSample({required String language, required String code}) async {
    if (current == null || running || state == SessionState.submitting) return;
    running = true;
    error = null;
    sampleResult = null;
    notifyListeners();
    try {
      final q = current!;
      sampleResult = await executor.execute(ExecutionRequest(
        problemId: q.id,
        language: language,
        code: code,
        tests: q.testCases.take(2).toList(),
      ));
    } catch (_) {
      error = 'Could not run your code. Check your connection and try again.';
    }
    running = false;
    notifyListeners();
  }

  /// Code -> Submit -> CodeExecutionService -> ExecutionResult.
  Future<void> submit({required String language, required String code}) async {
    if (current == null || running || state == SessionState.submitting) return;
    state = SessionState.submitting;
    error = null;
    notifyListeners();
    try {
      final q = current!;
      final result = await executor.execute(ExecutionRequest(
        problemId: q.id,
        language: language,
        code: code,
        tests: q.testCases,
      ));
      lastAttempt = AttemptRecord(
        question: q,
        language: language,
        code: code,
        result: result,
        timeTakenSec: DateTime.now().difference(_questionStart!).inSeconds,
      );
      history.add(lastAttempt!);
      state = SessionState.showingResult;
    } catch (_) {
      error = 'Could not run your code. Check your connection and try again.';
      state = SessionState.answering;
    }
    notifyListeners();
  }

  Future<void> next() => _loadNext();
}