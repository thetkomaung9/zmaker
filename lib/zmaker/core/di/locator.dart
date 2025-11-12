// Simple locator placeholder
class Locator {
  static final Locator _instance = Locator._internal();
  Locator._internal();
  factory Locator() => _instance;
}
