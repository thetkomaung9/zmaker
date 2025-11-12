import 'package:flutter/material.dart';
import 'presentation/home/home_screen.dart';
import 'presentation/stats/sleep_chart_screen.dart';

class ZMakerApp extends StatelessWidget {
  const ZMakerApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Z Maker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.teal, brightness: Brightness.dark),
      home: const HomeScreen(),
      routes: {'/stats': (_) => const SleepChartScreen()},
    );
  }
}
