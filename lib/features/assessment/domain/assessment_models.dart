import 'execution_models.dart';

class AssessmentQuestion {
  final String id;
  final String title;
  final String topic;
  final String difficulty; // Easy, Medium, Hard
  final String statement;
  final List<String> examples;
  final int expectedTimeSec;
  final List<TestCaseInput> testCases;
  final Map<String, String> starterCode; // language -> code
  const AssessmentQuestion({
    required this.id,
    required this.title,
    required this.topic,
    required this.difficulty,
    required this.statement,
    required this.examples,
    required this.expectedTimeSec,
    required this.testCases,
    required this.starterCode,
  });
}

class AttemptRecord {
  final AssessmentQuestion question;
  final String language;
  final String code;
  final ExecutionResult result;
  final int timeTakenSec;
  const AttemptRecord({
    required this.question,
    required this.language,
    required this.code,
    required this.result,
    required this.timeTakenSec,
  });
}