import 'package:flutter/material.dart';
import '../domain/execution_models.dart';

class TestResultsView extends StatelessWidget {
  final ExecutionResult result;
  const TestResultsView({super.key, required this.result});

  Color _color(ExecStatus s) => switch (s) {
        ExecStatus.accepted => Colors.green,
        ExecStatus.wrongAnswer => Colors.red,
        ExecStatus.runtimeError => Colors.deepOrange,
        ExecStatus.timeLimit => Colors.amber.shade800,
        ExecStatus.compilationError => Colors.purple,
      };

  @override
  Widget build(BuildContext context) {
    if (result.compileError != null) {
      return Card(
        color: Colors.purple.withValues(alpha: 0.1),
        child: ListTile(
          leading: const Icon(Icons.error, color: Colors.purple),
          title: const Text('Compilation Error'),
          subtitle: Text(result.compileError!,
              style: const TextStyle(fontFamily: 'monospace')),
        ),
      );
    }
    return Column(children: [
      ListTile(
        title: Text('${result.passedCount} / ${result.total} tests passed',
            style: Theme.of(context).textTheme.titleLarge),
        subtitle: Text('Total execution time: ${result.totalTimeMs} ms'),
        trailing: Icon(
          result.allPassed ? Icons.check_circle : Icons.cancel,
          color: result.allPassed ? Colors.green : Colors.red,
          size: 36,
        ),
      ),
      for (final r in result.results)
        Card(
          child: ListTile(
            leading: Icon(r.passed ? Icons.check_circle : Icons.cancel,
                color: _color(r.status)),
            title: Text('Test ${r.index + 1}${r.isEdge ? '  (Edge case)' : ''}'),
            subtitle: Text(r.passed
                ? '${r.timeMs} ms'
                : '${r.status.label} • ${r.timeMs} ms'
                    '${r.message != null ? '\n${r.message}' : ''}'),
            trailing: Chip(
              label: Text(r.status.label, style: const TextStyle(fontSize: 11)),
              backgroundColor: _color(r.status).withValues(alpha: 0.15),
            ),
          ),
        ),
    ]);
  }
}
