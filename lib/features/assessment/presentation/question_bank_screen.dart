import 'package:flutter/material.dart';
import '../domain/assessment_models.dart';
import 'question_detail_view.dart';

/// Lists questions with topic and difficulty filters.
/// Tapping a question calls [onSelect]; if not given, opens the detail view.
class QuestionBankScreen extends StatefulWidget {
  final List<AssessmentQuestion> questions;
  final void Function(AssessmentQuestion question)? onSelect;

  const QuestionBankScreen({
    super.key,
    required this.questions,
    this.onSelect,
  });

  @override
  State<QuestionBankScreen> createState() => _QuestionBankScreenState();
}

class _QuestionBankScreenState extends State<QuestionBankScreen> {
  static const _difficulties = ['Easy', 'Medium', 'Hard'];

  String? _topic;
  String? _difficulty;

  List<String> get _topics =>
      widget.questions.map((q) => q.topic).toSet().toList()..sort();

  List<AssessmentQuestion> get _filtered => widget.questions
      .where((q) =>
          (_topic == null || q.topic == _topic) &&
          (_difficulty == null || q.difficulty == _difficulty))
      .toList();

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

  void _open(AssessmentQuestion q) {
    if (widget.onSelect != null) {
      widget.onSelect!(q);
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: Text(q.title)),
          body: QuestionDetailView(question: q),
        ),
      ),
    );
  }

  Widget _chipRow(
    String label,
    List<String> options,
    String? selected,
    void Function(String?) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Text(label),
            const SizedBox(width: 8),
            ChoiceChip(
              label: const Text('All'),
              selected: selected == null,
              onSelected: (_) => onChanged(null),
            ),
            for (final o in options) ...[
              const SizedBox(width: 6),
              ChoiceChip(
                label: Text(o),
                selected: selected == o,
                onSelected: (_) => onChanged(o),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = _filtered;

    return Column(
      children: [
        const SizedBox(height: 8),
        _chipRow('Topic', _topics, _topic, (v) => setState(() => _topic = v)),
        _chipRow('Level', _difficulties, _difficulty,
            (v) => setState(() => _difficulty = v)),
        const Divider(),
        Expanded(
          child: items.isEmpty
              ? const Center(child: Text('No questions match these filters'))
              : ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, i) {
                    final q = items[i];
                    final color = _difficultyColor(q.difficulty);
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      child: ListTile(
                        title: Text(q.title),
                        subtitle: Text(
                            '${q.topic} • ${_formatTime(q.expectedTimeSec)}'),
                        trailing: Chip(
                          label: Text(q.difficulty,
                              style: TextStyle(color: color, fontSize: 11)),
                          backgroundColor: color.withValues(alpha: 0.15),
                        ),
                        onTap: () => _open(q),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}