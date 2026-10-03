import 'package:flutter/material.dart';
import '../domain/assessment_models.dart';

/// Pure display widget: shows one question's details.
class QuestionDetailView extends StatelessWidget {
  final AssessmentQuestion question;
  const QuestionDetailView({super.key, required this.question});

  Color _difficultyColor(String d) => switch (d) {
        'Easy' => Colors.green,
        'Medium' => Colors.orange,
        _ => Colors.red,
      };

  String _formatTime(int sec) {
    final m = sec ~/ 60;
    final s = sec % 60;
    if (m == 0) return '${s}s';
    return s == 0 ? '$m min' : '$m min ${s}s';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _difficultyColor(question.difficulty);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(question.title, style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              Chip(label: Text(question.topic)),
              Chip(
                label: Text(question.difficulty,
                    style: TextStyle(color: color, fontSize: 12)),
                backgroundColor: color.withValues(alpha: 0.15),
              ),
              Chip(
                avatar: const Icon(Icons.timer_outlined, size: 16),
                label: Text('Expected: ${_formatTime(question.expectedTimeSec)}'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(question.statement, style: theme.textTheme.bodyMedium),
          if (question.examples.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text('Examples', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            for (var i = 0; i < question.examples.length; i++)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  question.examples[i],
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
                ),
              ),
          ],
        ],
      ),
    );
  }
}