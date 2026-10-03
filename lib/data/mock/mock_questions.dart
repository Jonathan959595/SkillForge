import '../../core/models/question.dart';

final mockQuestions = <Question>[
  Question(
    id: 'q1',
    title: 'Find Maximum Element',
    description:
        'Given an array of integers, find the maximum element.',
    topic: 'Arrays',
    difficulty: Difficulty.easy,
    expectedSolvingTimeMinutes: 5,
    supportedLanguages: ['Dart', 'Python', 'Java', 'C++'],
    testCases: [
      TestCase(
        id: 'tc1',
        input: '3 7 2 9 4',
        expectedOutput: '9',
      ),
      TestCase(
        id: 'tc2',
        input: '-5 -2 -8',
        expectedOutput: '-2',
        isHidden: true,
      ),
    ],
  ),

  Question(
    id: 'q2',
    title: 'Reverse a String',
    description:
        'Write a program to reverse the given string.',
    topic: 'Strings',
    difficulty: Difficulty.easy,
    expectedSolvingTimeMinutes: 5,
    supportedLanguages: ['Dart', 'Python', 'Java', 'C++'],
    testCases: [
      TestCase(
        id: 'tc3',
        input: 'hello',
        expectedOutput: 'olleh',
      ),
    ],
  ),

  Question(
    id: 'q3',
    title: 'Two Sum',
    description:
        'Find two numbers in an array that add up to a target.',
    topic: 'Arrays',
    difficulty: Difficulty.medium,
    expectedSolvingTimeMinutes: 10,
    supportedLanguages: ['Dart', 'Python', 'Java', 'C++'],
    testCases: [
      TestCase(
        id: 'tc4',
        input: '2 7 11 15 | target=9',
        expectedOutput: '0 1',
      ),
    ],
  ),

  Question(
    id: 'q4',
    title: 'Binary Search',
    description:
        'Search for a target value in a sorted array.',
    topic: 'Searching',
    difficulty: Difficulty.medium,
    expectedSolvingTimeMinutes: 10,
    supportedLanguages: ['Dart', 'Python', 'Java', 'C++'],
    testCases: [
      TestCase(
        id: 'tc5',
        input: '1 3 5 7 9 | target=7',
        expectedOutput: '3',
      ),
    ],
  ),

  Question(
    id: 'q5',
    title: 'Graph Traversal',
    description:
        'Traverse a graph using breadth-first search.',
    topic: 'Graphs',
    difficulty: Difficulty.hard,
    expectedSolvingTimeMinutes: 20,
    supportedLanguages: ['Dart', 'Python', 'Java', 'C++'],
    testCases: [
      TestCase(
        id: 'tc6',
        input: '0-1, 0-2, 1-3',
        expectedOutput: '0 1 2 3',
      ),
    ],
  ),
];