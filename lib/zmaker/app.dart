import 'package:flutter/material.dart';
import 'presentation/home/home_screen.dart';
import 'presentation/planner/shift_planner_screen.dart';
import 'presentation/insights/insights_screen.dart';
import 'presentation/settings/settings_screen.dart';

class ZMakerApp extends StatelessWidget {
  const ZMakerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Z Maker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
        brightness: Brightness.dark,
      ),
      routes: {
        '/': (_) => const HomeScreen(),
        '/planner': (_) => const ShiftPlannerScreen(),
        '/insights': (_) => const InsightsScreen(),
        '/settings': (_) => const SettingsScreen(),
      },
    );
  }
}
