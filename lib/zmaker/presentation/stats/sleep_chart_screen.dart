import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/data/sleep_database.dart';

class SleepChartScreen extends StatefulWidget {
  const SleepChartScreen({super.key});
  @override
  State<SleepChartScreen> createState() => _SleepChartScreenState();
}

class _SleepChartScreenState extends State<SleepChartScreen> {
  List<Map<String, dynamic>> _data = [];
  @override
  void initState() { super.initState(); _load(); }
  Future<void> _load() async {
    final db = SleepDatabase.instance;
    final rows = await db.fetchLastNDays(7);
    setState(() => _data = rows);
  }
  @override
  Widget build(BuildContext context) {
    if (_data.isEmpty) return Scaffold(appBar: AppBar(title: const Text('Sleep Stats')), body: const Center(child: Text('No data')));
    final spots = <BarChartGroupData>[];
    for (int i = 0; i < _data.length; i++) {
      final row = _data[i];
      final start = DateTime.fromMillisecondsSinceEpoch(row['start']);
      final end = DateTime.fromMillisecondsSinceEpoch(row['end']);
      final hours = end.difference(start).inMinutes / 60.0;
      spots.add(BarChartGroupData(x: i, barRods: [BarChartRodData(toY: hours, width: 12)]));
    }
    return Scaffold(appBar: AppBar(title: const Text('Sleep Stats')), body: Padding(padding: const EdgeInsets.all(16), child: BarChart(BarChartData(barGroups: spots, titlesData: FlTitlesData(show: true)))));
  }
}
