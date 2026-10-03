import 'execution_models.dart';

/// Code -> Submit -> CodeExecutionService -> ExecutionResult -> TestCaseResults.
/// Screens and controller depend only on this interface, never on Judge0 directly.
abstract class CodeExecutionService {
  Future<ExecutionResult> execute(ExecutionRequest request);
}