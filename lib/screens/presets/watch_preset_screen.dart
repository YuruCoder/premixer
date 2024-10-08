import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:premixer/models/preset_model.dart';

class WatchPresetScreen extends StatelessWidget {
  final PresetModel preset;

  const WatchPresetScreen({
    super.key,
    required this.preset,
  });

  void turnOnBluetooth() async {
    if (await FlutterBluePlus.isSupported == false) {
      print('Bluetooth not supported by this device');
      return;
    }

    var subscription =
        FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) {
      print(state);
      if (state == BluetoothAdapterState.on) {
        // usually start scanning, connecting, etc
      } else {
        // show an error to the user, etc
      }
    });

    if (Platform.isAndroid) {
      await FlutterBluePlus.turnOn();
    }

    subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(preset.name),
        actions: [
          IconButton(
            onPressed: () => {},
            icon: const Icon(Icons.send_rounded),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            for (var recipe in preset.recipeList)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      buildSourceTag('${recipe.srcA.name}: ${recipe.ratioA}'),
                      const SizedBox(width: 8),
                      buildSourceTag('${recipe.srcB.name}: ${recipe.ratioB}'),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Container buildSourceTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black12,
          width: 4,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(text),
      ),
    );
  }
}
