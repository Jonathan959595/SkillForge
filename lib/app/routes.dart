import 'package:flutter/material.dart';

import '../features/student/student_home_page.dart';

class AppRoutes {
  static const home = '/';

  static final routes = <String, WidgetBuilder>{
    home: (_) => const StudentHomePage(),
  };
}