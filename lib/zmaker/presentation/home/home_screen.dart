import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:intl/intl.dart';
import '../../core/util/sleep_recommendation.dart';
import '../../core/util/alarm_service.dart';
import '../../core/data/sleep_database.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _now = DateTime.now();
  Timer? _timer;
  TimeOfDay _wakeTime = const TimeOfDay(hour: 7, minute: 0);

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => setState(() => _now = DateTime.now()));
    AlarmService.init();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  DateTime _toNextDateTime(TimeOfDay t) {
    final now = DateTime.now();
    var dt = DateTime(now.year, now.month, now.day, t.hour, t.minute);
    if (dt.isBefore(now)) dt = dt.add(const Duration(days: 1));
    return dt;
  }

  Future<void> _saveSampleSleep() async {
    final db = SleepDatabase.instance;
    final start = DateTime.now().subtract(const Duration(hours: 7, minutes: 30)).millisecondsSinceEpoch;
    final end = DateTime.now().millisecondsSinceEpoch;
    await db.insertSleep({'start': start, 'end': end, 'quality': 80});
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sample sleep saved')));
  }

  @override
  Widget build(BuildContext context) {
    final wakeDt = _toNextDateTime(_wakeTime);
    final suggested = SleepRecommendation.getSuggestedBedtime(wakeDt);
    final window = SleepRecommendation.getRecommendedWindow(wakeDt);

    return Scaffold(
      appBar: AppBar(title: const Text('Z Maker - Sleep Planner')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(width: 260, height: 260, child: CustomPaint(painter: _AnalogPainter(_now))),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.blueGrey.shade900, borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.all(12),
              child: Column(children: [
                Text('📅 ${DateFormat.yMMMMd().format(_now)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  const Text('Desired wake-up time:', style: TextStyle(fontSize: 16)),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final picked = await showTimePicker(context: context, initialTime: _wakeTime);
                      if (picked != null) setState(() => _wakeTime = picked);
                    },
                    icon: const Icon(Icons.alarm),
                    label: Text(DateFormat.Hm().format(_toNextDateTime(_wakeTime))),
                  ),
                ]),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.indigo.shade700, borderRadius: BorderRadius.circular(8)),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('Sleep Recommendation', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('If you want to wake at ${DateFormat.Hm().format(wakeDt)}, we suggest:'),
                    const SizedBox(height: 6),
                    Text('• Suggested bedtime: ${DateFormat.Hm().format(suggested)} (for ~8 hours)'),
                    const SizedBox(height: 4),
                    Text('• Recommended window: ${DateFormat.Hm().format(window['start']!)} - ${DateFormat.Hm().format(window['end']!)} (7–9 hrs)'),
                    const SizedBox(height: 8),
                    Row(children: [
                      ElevatedButton.icon(
                        onPressed: () async {
                            await AlarmService.scheduleAlarm(wakeDt, 'Wake up', 'Time to wake up!', id: 1);
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Wake alarm scheduled')));
                        },
                        icon: const Icon(Icons.alarm_add),
                        label: const Text('Schedule Wake Alarm'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: () async {
                            final bt = suggested;
                            final alertTime = bt;
                            await AlarmService.scheduleAlarm(alertTime, 'Bedtime', 'It\'s time to go to bed', id: 2);
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Bedtime alert scheduled')));
                        },
                        icon: const Icon(Icons.bedtime),
                        label: const Text('Schedule Bedtime Alert'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: _saveSampleSleep,
                        icon: const Icon(Icons.save),
                        label: const Text('Save Sample Sleep'),
                      ),
                    ])
                  ]),
                ),
                const SizedBox(height: 12),
                ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/stats'), child: const Text('View Sleep Stats'))
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnalogPainter extends CustomPainter {
  final DateTime now;
  _AnalogPainter(this.now);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final face = Paint()..color = Colors.grey.shade200;
    canvas.drawCircle(center, radius, face);
    final border = Paint()..color = Colors.black26..style = PaintingStyle.stroke..strokeWidth = 3;
    canvas.drawCircle(center, radius, border);

    final tick = Paint()..color = Colors.black54..strokeWidth = 2;
    for (int i = 0; i < 60; i++) {
      final len = (i % 5 == 0) ? 10.0 : 5.0;
      final a = (i * 6) * pi / 180;
      final p1 = Offset(center.dx + (radius - 4) * sin(a), center.dy - (radius - 4) * cos(a));
      final p2 = Offset(center.dx + (radius - 4 - len) * sin(a), center.dy - (radius - 4 - len) * cos(a));
      canvas.drawLine(p1, p2, tick);
    }

    final hourAngle = ((now.hour % 12) + now.minute / 60) * 30 * pi / 180;
    final minuteAngle = (now.minute + now.second / 60) * 6 * pi / 180;
    final secondAngle = now.second * 6 * pi / 180;

    final hourPaint = Paint()..color = Colors.black87..strokeWidth = 6..strokeCap = StrokeCap.round;
    final minPaint = Paint()..color = Colors.black87..strokeWidth = 4..strokeCap = StrokeCap.round;
    final secPaint = Paint()..color = Colors.red..strokeWidth = 2..strokeCap = StrokeCap.round;

    canvas.drawLine(center, center + Offset((radius * 0.5) * sin(hourAngle), -(radius * 0.5) * cos(hourAngle)), hourPaint);
    canvas.drawLine(center, center + Offset((radius * 0.75) * sin(minuteAngle), -(radius * 0.75) * cos(minuteAngle)), minPaint);
    canvas.drawLine(center, center + Offset((radius * 0.85) * sin(secondAngle), -(radius * 0.85) * cos(secondAngle)), secPaint);
    canvas.drawCircle(center, 5, Paint()..color = Colors.black);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
