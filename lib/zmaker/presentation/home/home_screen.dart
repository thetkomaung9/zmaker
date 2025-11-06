import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Timer _timer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Z Maker"),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.grey[200],
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Analog clock (pan-kan style)
            Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                color: Colors.greenAccent[100],
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: CustomPaint(
                painter: AnalogClockPainter(_now),
              ),
            ),

            const SizedBox(height: 32),

            // Calendar box
            Container(
              width: 320,
              height: 240,
              decoration: BoxDecoration(
                color: Colors.lightBlue[200],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blueAccent, width: 1),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      "캘린더",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Expanded(child: _SimpleCalendar()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnalogClockPainter extends CustomPainter {
  final DateTime now;

  AnalogClockPainter(this.now);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    final face = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final border = Paint()
      ..color = Colors.black54
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Clock face
    canvas.drawCircle(center, radius, face);
    canvas.drawCircle(center, radius, border);

    // Hour ticks
    final tick = Paint()
      ..color = Colors.black54
      ..strokeWidth = 2;
    for (int i = 0; i < 60; i++) {
      final tickLength = (i % 5 == 0) ? 10.0 : 5.0;
      final angle = (i * 6) * pi / 180;
      final p1 = Offset(
        center.dx + (radius - 4) * sin(angle),
        center.dy - (radius - 4) * cos(angle),
      );
      final p2 = Offset(
        center.dx + (radius - 4 - tickLength) * sin(angle),
        center.dy - (radius - 4 - tickLength) * cos(angle),
      );
      canvas.drawLine(p1, p2, tick);
    }

    // Hour numbers
    final textPainter = TextPainter(textAlign: TextAlign.center, textDirection: TextDirection.ltr);
    for (int i = 1; i <= 12; i++) {
      final angle = (i * 30) * pi / 180;
      final dx = center.dx + (radius - 26) * sin(angle);
      final dy = center.dy - (radius - 26) * cos(angle);
      textPainter.text = const TextSpan(style: TextStyle(fontSize: 14, color: Colors.black), text: '');
      textPainter.text = TextSpan(text: "$i", style: const TextStyle(fontSize: 14, color: Colors.black));
      textPainter.layout();
      textPainter.paint(canvas, Offset(dx - 6, dy - 8));
    }

    // Angles
    final hourAngle = ((now.hour % 12) + now.minute / 60) * 30 * pi / 180;
    final minuteAngle = (now.minute + now.second / 60) * 6 * pi / 180;
    final secondAngle = now.second * 6 * pi / 180;

    final hourHand = Paint()
      ..color = Colors.black87
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    final minuteHand = Paint()
      ..color = Colors.black87
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    final secondHand = Paint()
      ..color = Colors.red
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    // Hands
    canvas.drawLine(center, Offset(center.dx + 60 * sin(hourAngle), center.dy - 60 * cos(hourAngle)), hourHand);
    canvas.drawLine(center, Offset(center.dx + 90 * sin(minuteAngle), center.dy - 90 * cos(minuteAngle)), minuteHand);
    canvas.drawLine(center, Offset(center.dx + 100 * sin(secondAngle), center.dy - 100 * cos(secondAngle)), secondHand);

    // Center
    canvas.drawCircle(center, 5, Paint()..color = Colors.black);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class _SimpleCalendar extends StatelessWidget {
  const _SimpleCalendar();

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final daysInMonth = DateUtils.getDaysInMonth(now.year, now.month);
    final firstWeekday = DateTime(now.year, now.month, 1).weekday; // 1-7 (Mon-Sun)

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: daysInMonth + firstWeekday - 1,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
      itemBuilder: (context, index) {
        if (index < firstWeekday - 1) {
          return const SizedBox();
        }
        final day = index - firstWeekday + 2;
        final isToday = (day == now.day);
        return Container(
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: isToday ? Colors.orangeAccent : Colors.white,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Center(
            child: Text(
              "$day",
              style: TextStyle(
                color: isToday ? Colors.white : Colors.black,
                fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      },
    );
  }
}
