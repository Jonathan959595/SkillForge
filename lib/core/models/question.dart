enum Difficulty {
  easy,
  medium,
  hard,
}

class TestCase {
  final String id;
  final String input;
  final String expectedOutput;
  final bool isHidden;

  const TestCase({
    required this.id,
    required this.input,
    required this.expectedOutput,
    this.isHidden = false,
  });
}

class Question {
  final String id;
  final String title;
  final String description;
  final String topic;
  final Difficulty difficulty;
  final int expectedSolvingTimeMinutes;
  final List<String> supportedLanguages;
  final List<TestCase> testCases;

  const Question({
    required this.id,
    required this.title,
    required this.description,
    required this.topic,
    required this.difficulty,
    required this.expectedSolvingTimeMinutes,
    required this.supportedLanguages,
    required this.testCases,
  });
}