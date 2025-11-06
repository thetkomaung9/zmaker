import 'package:flutter/material.dart';
import 'zmaker/app.dart';
import 'zmaker/core/di/locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  runApp(const ZMakerApp());
}
