class TestResult {
  final String testCaseId;
  final bool passed;
  final String actualOutput;
  final String expectedOutput;
  final String? errorMessage;

  const TestResult({
    required this.testCaseId,
    required this.passed,
    required this.actualOutput,
    required this.expectedOutput,
    this.errorMessage,
  });
}