import 'package:flutter/material.dart';
import 'utils/theme.dart';
import 'routes/app_routes.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CivicData Core',
      theme: governmentTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: AppRoutes().appRoutes,
    );
  }
}
