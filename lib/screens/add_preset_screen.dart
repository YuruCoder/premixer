import 'package:flutter/material.dart';

class AddPresetScreen extends StatelessWidget {
  const AddPresetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('프리셋 추가하기'),
      ),
      body: const Center(
        child: Text('Add Preset'),
      ),
    );
  }
}
