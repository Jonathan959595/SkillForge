import '../domain/assessment_models.dart';
import '../domain/execution_models.dart';

const _starter = {
  'python': '# write your solution here\n',
  'java':
      'import java.util.*;\n\npublic class Main {\n  public static void main(String[] args) {\n    Scanner sc = new Scanner(System.in);\n    // write your solution here\n  }\n}\n',
  'cpp':
      '#include <bits/stdc++.h>\nusing namespace std;\n\nint main() {\n  // write your solution here\n  return 0;\n}\n',
};

const sampleQuestions = <AssessmentQuestion>[
  AssessmentQuestion(
    id: 'arr_easy_1',
    title: 'Sum of Array',
    topic: 'Arrays',
    difficulty: 'Easy',
    statement: 'Read n, then n integers on the next line. Print their sum.',
    examples: ['Input: 3 / 1 2 3  ->  Output: 6'],
    expectedTimeSec: 300,
    testCases: [
      TestCaseInput(input: '3\n1 2 3', expectedOutput: '6'),
      TestCaseInput(input: '1\n5', expectedOutput: '5'),
      TestCaseInput(input: '2\n-1 1', expectedOutput: '0', isEdge: true),
    ],
    starterCode: _starter,
  ),
  AssessmentQuestion(
    id: 'str_easy_1',
    title: 'Reverse a String',
    topic: 'Strings',
    difficulty: 'Easy',
    statement: 'Read a string and print it reversed.',
    examples: ['Input: hello  ->  Output: olleh'],
    expectedTimeSec: 300,
    testCases: [
      TestCaseInput(input: 'hello', expectedOutput: 'olleh'),
      TestCaseInput(input: 'abc', expectedOutput: 'cba'),
      TestCaseInput(input: 'a', expectedOutput: 'a', isEdge: true),
    ],
    starterCode: _starter,
  ),
  AssessmentQuestion(
    id: 'sort_med_1',
    title: 'Sort Numbers',
    topic: 'Sorting',
    difficulty: 'Medium',
    statement:
        'Read n, then n integers. Print them in ascending order, separated by spaces.',
    examples: ['Input: 3 / 3 1 2  ->  Output: 1 2 3'],
    expectedTimeSec: 600,
    testCases: [
      TestCaseInput(input: '5\n3 1 2 5 4', expectedOutput: '1 2 3 4 5'),
      TestCaseInput(input: '3\n9 -2 0', expectedOutput: '-2 0 9'),
      TestCaseInput(input: '1\n7', expectedOutput: '7', isEdge: true),
    ],
    starterCode: _starter,
  ),
  AssessmentQuestion(
    id: 'hash_med_1',
    title: 'Count Distinct Numbers',
    topic: 'Hashing',
    difficulty: 'Medium',
    statement: 'Read n, then n integers. Print how many distinct values appear.',
    examples: ['Input: 5 / 1 2 2 3 3  ->  Output: 3'],
    expectedTimeSec: 600,
    testCases: [
      TestCaseInput(input: '5\n1 2 2 3 3', expectedOutput: '3'),
      TestCaseInput(input: '4\n7 7 7 7', expectedOutput: '1'),
      TestCaseInput(input: '1\n9', expectedOutput: '1', isEdge: true),
    ],
    starterCode: _starter,
  ),
  AssessmentQuestion(
    id: 'rec_hard_1',
    title: 'Nth Fibonacci',
    topic: 'Recursion',
    difficulty: 'Hard',
    statement: 'Read n and print the nth Fibonacci number (F0 = 0, F1 = 1).',
    examples: ['Input: 10  ->  Output: 55'],
    expectedTimeSec: 900,
    testCases: [
      TestCaseInput(input: '10', expectedOutput: '55'),
      TestCaseInput(input: '20', expectedOutput: '6765'),
      TestCaseInput(input: '0', expectedOutput: '0', isEdge: true),
      TestCaseInput(input: '1', expectedOutput: '1', isEdge: true),
    ],
    starterCode: _starter,
  ),
  AssessmentQuestion(
    id: 'dp_hard_1',
    title: 'Climbing Stairs',
    topic: 'DP',
    difficulty: 'Hard',
    statement:
        'You can climb 1 or 2 steps at a time. Read n and print the number of ways to reach step n.',
    examples: ['Input: 3  ->  Output: 3'],
    expectedTimeSec: 900,
    testCases: [
      TestCaseInput(input: '2', expectedOutput: '2'),
      TestCaseInput(input: '5', expectedOutput: '8'),
      TestCaseInput(input: '10', expectedOutput: '89'),
      TestCaseInput(input: '1', expectedOutput: '1', isEdge: true),
    ],
    starterCode: _starter,
  ),
];