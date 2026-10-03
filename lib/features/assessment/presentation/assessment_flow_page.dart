import 'package:flutter/material.dart';
import '../application/assessment_controller.dart';
import '../domain/assessment_models.dart';
import '../domain/code_execution_service.dart';
import '../domain/question_selector.dart';
import 'assessment_screen.dart';

/// Single entry widget for the assessment feature.
/// Teammates only need a route to this. Judge0 plugs in via [executor].
class AssessmentFlowPage extends StatefulWidget {
  final List<AssessmentQuestion> pool;
  final CodeExecutionService executor;
  final QuestionSelector? selector;
  final int maxQuestions;

  const AssessmentFlowPage({
    super.key,
    required this.pool,
    required this.executor,
    this.selector,
    this.maxQuestions = 5,
  });

  @override
  State<AssessmentFlowPage> createState() => _AssessmentFlowPageState();
}

class _AssessmentFlowPageState extends State<AssessmentFlowPage> {
  late final AssessmentController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AssessmentController(
      executor: widget.executor,
      selector: widget.selector ?? SimpleSelector(),
      pool: widget.pool,
      maxQuestions: widget.maxQuestions,
    );
    _controller.start();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      AssessmentScreen(controller: _controller);
}