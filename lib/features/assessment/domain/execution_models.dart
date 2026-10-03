enum ExecStatus { accepted, wrongAnswer, runtimeError, timeLimit, compilationError }

extension ExecStatusX on ExecStatus {
  String get label => switch (this) {
        ExecStatus.accepted => 'Passed',
        ExecStatus.wrongAnswer => 'Wrong Answer',
        ExecStatus.runtimeError => 'Runtime Error',
        ExecStatus.timeLimit => 'Time Limit',
        ExecStatus.compilationError => 'Compilation Error',
      };
}

class TestCaseInput {
  final String input;
  final String expectedOutput;
  final bool isEdge;
  const TestCaseInput({
    required this.input,
    required this.expectedOutput,
    this.isEdge = false,
  });
}

class TestCaseResult {
  final int index;
  final ExecStatus status;
  final bool isEdge;
  final int timeMs;
  final String? actualOutput;
  final String? expectedOutput;
  final String? message;
  const TestCaseResult({
    required this.index,
    required this.status,
    this.isEdge = false,
    this.timeMs = 0,
    this.actualOutput,
    this.expectedOutput,
    this.message,
  });
  bool get passed => status == ExecStatus.accepted;
}

class ExecutionRequest {
  final String problemId;
  final String language; // 'python' | 'java' | 'cpp'
  final String code;
  final List<TestCaseInput> tests;
  final int timeLimitMs;
  final int memoryLimitKb;
  const ExecutionRequest({
    required this.problemId,
    required this.language,
    required this.code,
    required this.tests,
    this.timeLimitMs = 2000,
    this.memoryLimitKb = 128000,
  });
}

class ExecutionResult {
  final List<TestCaseResult> results;
  final String? compileError;
  const ExecutionResult({required this.results, this.compileError});

  int get passedCount => results.where((r) => r.passed).length;
  int get total => results.length;
  double get passRatio => total == 0 ? 0 : passedCount / total;
  int get totalTimeMs => results.fold(0, (s, r) => s + r.timeMs);
  bool get allPassed => total > 0 && passedCount == total;
}