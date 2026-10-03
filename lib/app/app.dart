import 'package:flutter/material.dart';

import 'routes.dart';
import 'theme.dart';

class SkillForgeApp extends StatelessWidget {
  const SkillForgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SkillForge',
      debugShowCheckedModeBanner: false,
      theme: SkillForgeTheme.light,
      initialRoute: AppRoutes.home,
      routes: AppRoutes.routes,
    );
  }
}