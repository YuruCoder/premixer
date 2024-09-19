import 'package:flutter/material.dart';
import 'package:premixer/models/preset_model.dart';

class WatchPresetScreen extends StatelessWidget {
  final PresetModel preset;

  const WatchPresetScreen({
    super.key,
    required this.preset,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(preset.name),
      ),
      body: const Center(
        child: Text('프리셋 보기'),
      ),
    );
  }
}
