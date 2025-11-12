import 'package:flutter/material.dart';
class CommonButton extends StatelessWidget {
  final IconData icon; final String label; final VoidCallback onPressed;
  const CommonButton({super.key, required this.icon, required this.label, required this.onPressed});
  @override Widget build(BuildContext context) => ElevatedButton.icon(onPressed: onPressed, icon: Icon(icon), label: Text(label));
}
