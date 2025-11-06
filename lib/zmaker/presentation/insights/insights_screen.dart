import 'package:flutter/material.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('수면 통계')),
      body: const Center(child: Text('Sleep insights and charts coming soon...')),
    );
  }
}
