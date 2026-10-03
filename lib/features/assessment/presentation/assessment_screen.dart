import 'dart:async';
import 'package:flutter/material.dart';
import '../application/assessment_controller.dart';
import '../domain/execution_models.dart';
import 'assessment_summary_screen.dart';
import 'code_editor_widget.dart';
import 'question_detail_view.dart';
import 'test_results_screen.dart';

/// Shows the right view for each controller state.
class AssessmentScreen extends StatelessWidget {
  final AssessmentController controller;
  const AssessmentScreen({super.key, required this.controller});

  String _verdict(ExecutionResult r) {
    if (r.compileError != null) return ExecStatus.compilationError.label;
    if (r.allPassed) return 'Accepted';
    final failed = r.results.where((t) => !t.passed);
    return failed.isEmpty ? 'No tests' : failed.first.status.label;
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        switch (controller.state) {
          case SessionState.idle:
          case SessionState.loadingQuestion:
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));
          case SessionState.finished:
            return Scaffold(
              appBar: AppBar(title: const Text('Summary')),
              body: AssessmentSummaryScreen(
                history: controller.history,
                onRestart: controller.start,
              ),
            );
          case SessionState.showingResult:
            return _resultView(context);
          case SessionState.answering:
          case SessionState.submitting:
            return _answerView(context);
        }
      },
    );
  }

  Widget _answerView(BuildContext context) {
    final q = controller.current!;
    final number = controller.history.length + 1;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Question $number of ${controller.maxQuestions}'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: _ElapsedTimer(
                    key: ValueKey(q.id), expectedSec: q.expectedTimeSec),
              ),
            ),
          ],
          bottom: const TabBar(
              tabs: [Tab(text: 'Problem'), Tab(text: 'Code')]),
        ),
        body: TabBarView(
          children: [
            QuestionDetailView(question: q),
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CodeEditorWidget(
                    key: ValueKey(q.id),
                    question: q,
                    isRunning: controller.running,
                    isSubmitting:
                        controller.state == SessionState.submitting,
                    onRun: (lang, code) =>
                        controller.runSample(language: lang, code: code),
                    onSubmit: (lang, code) =>
                        controller.submit(language: lang, code: code),
                  ),
                  if (controller.error != null) ...[
                    const SizedBox(height: 12),
                    Text(controller.error!,
                        style: const TextStyle(color: Colors.red)),
                  ],
                  if (controller.sampleResult != null) ...[
                    const SizedBox(height: 16),
                    Text('Run result: ${_verdict(controller.sampleResult!)}',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    if (controller.sampleResult!.compileError != null)
                        Container(
                           padding: const EdgeInsets.all(12),
                           color: Colors.red.withValues(alpha: 0.1),
                           child: Text(controller.sampleResult!.compileError!,
                           style: const TextStyle(fontFamily: 'monospace')),
                        ),
                    TestResultsView(result: controller.sampleResult!),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _resultView(BuildContext context) {
    final attempt = controller.lastAttempt!;
    final r = attempt.result;
    final isLast = controller.history.length >= controller.maxQuestions;
    return Scaffold(
      appBar: AppBar(title: const Text('Result')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(_verdict(r), style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text('${r.passedCount}/${r.total} tests passed • ${r.totalTimeMs} ms'),
          if (r.memoryUsedKb != null)
            Text('Peak memory: ${r.memoryUsedKb} KB'),
          Text('Time taken: ${attempt.timeTakenSec}s '
              '(expected ${attempt.question.expectedTimeSec}s)'),
          if (r.compileError != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.red.withValues(alpha: 0.1),
              child: Text(r.compileError!,
                  style: const TextStyle(fontFamily: 'monospace')),
            ),
          ],
          const SizedBox(height: 12),
          TestResultsView(result: r),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: controller.next,
            child: Text(isLast ? 'Finish' : 'Next question'),
          ),
        ],
      ),
    );
  }
}

class _ElapsedTimer extends StatefulWidget {
  final int expectedSec;
  const _ElapsedTimer({super.key, required this.expectedSec});

  @override
  State<_ElapsedTimer> createState() => _ElapsedTimerState();
}

class _ElapsedTimerState extends State<_ElapsedTimer> {
  Timer? _timer;
  int _sec = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
        const Duration(seconds: 1), (_) => setState(() => _sec++));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _mmss(int s) =>
      '${(s ~/ 60).toString().padLeft(2, '0')}:${(s % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final over = _sec > widget.expectedSec;
    return Text(
      '${_mmss(_sec)} / ${_mmss(widget.expectedSec)}',
      style: TextStyle(color: over ? Colors.red : null),
    );
  }
}