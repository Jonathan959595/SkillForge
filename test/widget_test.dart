import 'package:flutter_test/flutter_test.dart';
import 'package:skillforge/app/app.dart';

void main() {
  testWidgets('SkillForge app loads', (tester) async {
    await tester.pumpWidget(const SkillForgeApp());

    expect(find.text('SkillForge'), findsOneWidget);
  });
}