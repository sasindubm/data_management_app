import '../screens/signup_screen.dart';
import '../screens/draft_screen.dart';
import 'package:flutter/material.dart';
import '../screens/response_screen.dart';
import '../screens/newform_screen.dart';
import '../screens/project_screen.dart';
import '../screens/form_screen.dart';
import '../screens/newproject_screen.dart';
import '../screens/login_screen.dart';

class AppRoutes {
  final Map<String, WidgetBuilder> appRoutes = {
    '/': (context) => LoginScreen(),
    '/reg': (context) => SignupScreen(),
    '/new-project': (context) => NewProjectScreen(),
    '/new-form' : (context) => NewFormScreen(),
    '/form' : (context) => FormScreen(),
    '/project': (context) => ProjectScreen(),
    '/res': (context) => ResponseScreen(),
    '/draft': (context) => DraftScreen()
  };
}
