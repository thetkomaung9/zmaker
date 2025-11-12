class SleepRecommendation {
  static DateTime getSuggestedBedtime(DateTime wakeTime, {double targetHours = 8}) {
    return wakeTime.subtract(Duration(minutes: (targetHours * 60).toInt()));
  }
  static Map<String, DateTime> getRecommendedWindow(DateTime wakeTime, {double minHours = 7, double maxHours = 9}) {
    final start = wakeTime.subtract(Duration(minutes: (maxHours * 60).toInt()));
    final end = wakeTime.subtract(Duration(minutes: (minHours * 60).toInt()));
    return {'start': start, 'end': end};
  }
}
