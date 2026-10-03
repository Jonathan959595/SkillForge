import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../domain/code_execution_service.dart';
import '../domain/execution_models.dart';

class BackendCodeExecutionService implements CodeExecutionService {
  BackendCodeExecutionService({
    required this.endpoint,
    http.Client? client,
  })  : _client = client ?? http.Client(),
        _ownsClient = client == null;

  final Uri endpoint;
  final http.Client _client;
  final bool _ownsClient;

  @override
  Future<ExecutionResult> execute(ExecutionRequest request) async {
    final response = await _client.post(
      endpoint,
      headers: const {'content-type': 'application/json'},
      body: jsonEncode({
        'question_id': request.problemId,
        'language': request.language,
        'code': request.code,
      }),
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw HttpException(
        'Code execution backend returned ${response.statusCode}',
        uri: endpoint,
      );
    }
    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Invalid code execution response');
    }
    return _parseResult(decoded);
  }

  void close() {
    if (_ownsClient) _client.close();
  }

  ExecutionResult _parseResult(Map<String, dynamic> response) {
    final root = _nestedResult(response);
    final rawResults =
        root['test_results'] ?? root['results'] ?? root['test_cases'];
    final backendCompileError = _firstString(root, const [
      'compile_error',
      'compile_output',
    ]);
    final results = rawResults is List
        ? [
            for (var index = 0; index < rawResults.length; index++)
              if (rawResults[index] is Map)
                _parseTest(
                  (rawResults[index] as Map).cast<String, dynamic>(),
                  index,
                ),
          ]
        : _synthesizeResults(root, backendCompileError);
    final compileError = backendCompileError ??
        results
            .where((result) => result.status == ExecStatus.compilationError)
            .map((result) => result.message)
            .firstWhere((message) => message != null, orElse: () => null);

    return ExecutionResult(
      results: results,
      compileError: compileError,
      executionTimeMs: _durationMs(root),
      memoryUsedKb: _memoryKb(root) ??
          (results.isEmpty
              ? null
              : results
                  .map((result) => result.memoryUsedKb ?? 0)
                  .reduce((a, b) => a > b ? a : b)),
    );
  }

  Map<String, dynamic> _nestedResult(Map<String, dynamic> response) {
    final nested = response['result'] ?? response['data'];
    return nested is Map ? nested.cast<String, dynamic>() : response;
  }

  TestCaseResult _parseTest(Map<String, dynamic> test, int fallbackIndex) {
    final statusValue = test['status'] ?? test['verdict'];
    final statusText = statusValue is Map
        ? statusValue['description'] ?? statusValue['name'] ?? statusValue['id']
        : statusValue;
    final passed = test['passed'] == true || test['accepted'] == true;
    final status = _status(statusText, passed: passed);
    return TestCaseResult(
        index: _integer(test['index']) ??
          ((_integer(test['test_number']) ?? fallbackIndex + 1) - 1),
      status: status,
      isEdge: test['is_edge'] == true || test['isEdge'] == true,
      timeMs: _durationMs(test) ?? 0,
      memoryUsedKb: _memoryKb(test),
      actualOutput: _string(test['actual_output'] ?? test['stdout']),
      expectedOutput: _string(test['expected_output']),
      message: _firstString(test, const [
        'message',
        'stderr',
        'runtime_error',
        'compile_output',
      ]),
    );
  }

  List<TestCaseResult> _synthesizeResults(
    Map<String, dynamic> root,
    String? compileError,
  ) {
    final total = _integer(_firstValue(root, const [
          'total_tests',
          'total_count',
          'test_count',
          'total',
        ])) ??
        1;
    final passed = (_integer(_firstValue(root, const [
              'passed_count',
              'passed_tests',
              'tests_passed',
            ])) ??
            (_status(_statusValue(root), passed: root['passed'] == true) ==
                    ExecStatus.accepted
                ? total
                : 0))
        .clamp(0, total);
    final failureStatus = compileError != null
        ? ExecStatus.compilationError
        : _status(_statusValue(root), passed: false);
    final count = total.clamp(0, 1000);
    return List.generate(
      count,
      (index) => TestCaseResult(
        index: index,
        status: index < passed ? ExecStatus.accepted : failureStatus,
        timeMs: 0,
        message: index < passed ? null : compileError,
      ),
    );
  }

  Object? _statusValue(Map<String, dynamic> root) {
    final value = root['status'] ?? root['verdict'];
    if (value is Map) return value['description'] ?? value['name'] ?? value['id'];
    return value;
  }

  ExecStatus _status(Object? value, {required bool passed}) {
    if (passed) return ExecStatus.accepted;
    final text = value?.toString().toLowerCase().replaceAll('_', ' ') ?? '';
    if (value == 3 || text.contains('accepted') || text == 'passed') {
      return ExecStatus.accepted;
    }
    if (value == 5 || text.contains('time limit') || text == 'tle') {
      return ExecStatus.timeLimit;
    }
    if (value == 6 || text.contains('compilation') || text.contains('compile')) {
      return ExecStatus.compilationError;
    }
    if (value == 4 || text.contains('wrong answer')) {
      return ExecStatus.wrongAnswer;
    }
    if (text.contains('runtime') || text.contains('error') ||
        (value is int && value >= 7)) {
      return ExecStatus.runtimeError;
    }
    return ExecStatus.wrongAnswer;
  }

  int? _durationMs(Map<String, dynamic> values) {
    for (final key in const [
      'execution_time_ms',
      'total_time_ms',
      'time_ms',
      'executionTimeMs',
    ]) {
      final number = _number(values[key]);
      if (number != null) return number.round();
    }
    final seconds = _number(values['time']);
    return seconds == null ? null : (seconds * 1000).round();
  }

  int? _memoryKb(Map<String, dynamic> values) => _integer(_firstValue(
        values,
        const ['memory_used_kb', 'memory_kb', 'memoryUsedKb', 'memory'],
      ));

  Object? _firstValue(Map<String, dynamic> values, List<String> keys) {
    for (final key in keys) {
      if (values[key] != null) return values[key];
    }
    return null;
  }

  String? _firstString(Map<String, dynamic> values, List<String> keys) {
    for (final key in keys) {
      final value = _string(values[key]);
      if (value != null && value.isNotEmpty) return value;
    }
    return null;
  }

  String? _string(Object? value) => value is String ? value : null;

  num? _number(Object? value) => value is num ? value : num.tryParse('$value');

  int? _integer(Object? value) => _number(value)?.round();
}