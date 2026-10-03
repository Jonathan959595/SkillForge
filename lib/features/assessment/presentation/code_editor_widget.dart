import 'package:flutter/material.dart';
import '../domain/assessment_models.dart';

/// Language dropdown, code box, Run and Submit buttons with loading state.
class CodeEditorWidget extends StatefulWidget {
  final AssessmentQuestion question;
  final bool isRunning;
  final bool isSubmitting;
  final void Function(String language, String code) onRun;
  final void Function(String language, String code) onSubmit;

  const CodeEditorWidget({
    super.key,
    required this.question,
    required this.isRunning,
    required this.isSubmitting,
    required this.onRun,
    required this.onSubmit,
  });

  @override
  State<CodeEditorWidget> createState() => _CodeEditorWidgetState();
}

class _CodeEditorWidgetState extends State<CodeEditorWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  late final List<String> _languages;
  late String _language;
  late final TextEditingController _code;

  @override
  void initState() {
    super.initState();
    final keys = widget.question.starterCode.keys.toList();
    _languages = keys.isEmpty ? ['python', 'java', 'cpp'] : keys;
    _language =
        _languages.contains('python') ? 'python' : _languages.first;
    _code = TextEditingController(
        text: widget.question.starterCode[_language] ?? '');
  }

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  void _changeLanguage(String? lang) {
    if (lang == null) return;
    setState(() {
      _language = lang;
      _code.text = widget.question.starterCode[lang] ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final busy = widget.isRunning || widget.isSubmitting;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Text('Language: '),
            const SizedBox(width: 8),
            DropdownButton<String>(
              value: _language,
              items: [
                for (final l in _languages)
                  DropdownMenuItem(value: l, child: Text(l)),
              ],
              onChanged: busy ? null : _changeLanguage,
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _code,
          enabled: !busy,
          minLines: 12,
          maxLines: 12,
          keyboardType: TextInputType.multiline,
          autocorrect: false,
          enableSuggestions: false,
          style: const TextStyle(fontFamily: 'monospace', fontSize: 14),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Write your code here',
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed:
                    busy ? null : () => widget.onRun(_language, _code.text),
                icon: widget.isRunning
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.play_arrow),
                label: Text(widget.isRunning ? 'Running...' : 'Run'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.icon(
                onPressed:
                    busy ? null : () => widget.onSubmit(_language, _code.text),
                icon: widget.isSubmitting
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.send),
                label: Text(widget.isSubmitting ? 'Submitting...' : 'Submit'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}