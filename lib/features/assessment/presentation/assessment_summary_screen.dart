import 'package:flutter/material.dart';
import '../domain/assessment_models.dart';

/// Shown when the assessment ends: totals and per-topic results.
class AssessmentSummaryScreen extends StatelessWidget {
  final List<AttemptRecord> history;
  final VoidCallback? onRestart;

  const AssessmentSummaryScreen({
    super.key,
    required this.history,
    this.onRestart,
  });

  String _fmt(int sec) {
    final m = sec ~/ 60;
    final s = sec % 60;
    return '${m}m ${s}s';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final solved = history.where((h) => h.result.allPassed).length;
    final totalSec = history.fold<int>(0, (s, h) => s + h.timeTakenSec);

    // topic -> [solved, attempted]
    final byTopic = <String, List<int>>{};
    for (final h in history) {
      final e = byTopic.putIfAbsent(h.question.topic, () => [0, 0]);
      e[1] += 1;
      if (h.result.allPassed) e[0] += 1;
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Assessment complete', style: theme.textTheme.headlineSmall),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _stat(context, 'Solved', '$solved/${history.length}')),
            const SizedBox(width: 12),
            Expanded(child: _stat(context, 'Total time', _fmt(totalSec))),
          ],
        ),
        const SizedBox(height: 20),
        Text('By topic', style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        for (final e in byTopic.entries)
          Card(
            child: ListTile(
              title: Text(e.key),
              subtitle: LinearProgressIndicator(
                value: e.value[1] == 0 ? 0 : e.value[0] / e.value[1],
              ),
              trailing: Text('${e.value[0]}/${e.value[1]}'),
            ),
          ),
        const SizedBox(height: 20),
        Text('Questions', style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        for (final h in history)
          Card(
            child: ListTile(
              leading: Icon(
                h.result.allPassed ? Icons.check_circle : Icons.cancel,
                color: h.result.allPassed ? Colors.green : Colors.red,
              ),
              title: Text(h.question.title),
              subtitle: Text(
                  '${h.result.passedCount}/${h.result.total} tests • ${_fmt(h.timeTakenSec)} '
                  '(expected ${_fmt(h.question.expectedTimeSec)})'),
            ),
          ),
        if (onRestart != null) ...[
          const SizedBox(height: 16),
          FilledButton(onPressed: onRestart, child: const Text('Start again')),
        ],
      ],
    );
  }

  Widget _stat(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(value, style: theme.textTheme.headlineSmall),
            const SizedBox(height: 4),
            Text(label),
          ],
        ),
      ),
    );
  }
}