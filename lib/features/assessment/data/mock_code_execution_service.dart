import 'dart:math';
import '../domain/code_execution_service.dart';
import '../domain/execution_models.dart';

/// Fake executor so the whole flow works offline. Replaced by Judge0 later.
class MockCodeExecutionService implements CodeExecutionService {
  final _rng = Random();

  @override
  Future<ExecutionResult> execute(ExecutionRequest r) async {
    await Future.delayed(const Duration(milliseconds: 1200));
    final code = r.code.trim();

    if (code.isEmpty || code.contains('syntax error')) {
      return const ExecutionResult(
          results: [], compileError: 'line 1: invalid syntax');
    }
    final results = <TestCaseResult>[];
    for (var i = 0; i < r.tests.length; i++) {
      final t = r.tests[i];
      var s = ExecStatus.accepted;
      String? msg;
      if (code.contains('while True') || code.contains('while(true)')) {
        s = ExecStatus.timeLimit;
      } else if (code.contains('raise') || code.contains('throw')) {
        s = ExecStatus.runtimeError;
        msg = 'Exception thrown at runtime';
      } else if (code.length < 25 && (t.isEdge || i == r.tests.length - 1)) {
        s = ExecStatus.wrongAnswer; // very short code fails the edge/last test
      }
      results.add(TestCaseResult(
        index: i,
        status: s,
        isEdge: t.isEdge,
        timeMs: 20 + _rng.nextInt(180),
        expectedOutput: t.expectedOutput,
        actualOutput:
            s == ExecStatus.accepted ? t.expectedOutput : '(different output)',
        message: msg,
      ));
    }
    return ExecutionResult(results: results);
  }
}