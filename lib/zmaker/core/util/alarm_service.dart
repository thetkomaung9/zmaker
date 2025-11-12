import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tzdata;

class AlarmService {
  static final FlutterLocalNotificationsPlugin _notif = FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;
    const AndroidInitializationSettings aInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings = InitializationSettings(android: aInit);
    await _notif.initialize(initSettings);
    tzdata.initializeTimeZones();
    _initialized = true;
  }

  static Future<void> scheduleAlarm(DateTime dt, String title, String body, {int id = 0}) async {
    await init();
    await _notif.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(dt, tz.local),
      const NotificationDetails(android: AndroidNotificationDetails('zmaker_channel', 'ZMaker', importance: Importance.max, priority: Priority.high)),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
