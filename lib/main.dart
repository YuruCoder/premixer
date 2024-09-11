import 'package:flutter/material.dart';
import 'package:premixer/screens/home_screen.dart';

void main() {
  runApp(const PremixerApp());
}

class PremixerApp extends StatelessWidget {
  const PremixerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}
