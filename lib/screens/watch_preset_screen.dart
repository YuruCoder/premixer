import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:premixer/models/preset_model.dart';

class WatchPresetScreen extends StatefulWidget {
  final PresetModel preset;

  const WatchPresetScreen({
    super.key,
    required this.preset,
  });

  @override
  State<StatefulWidget> createState() => _WatchPresetScreenState();
}

class _WatchPresetScreenState extends State<WatchPresetScreen> {
  BluetoothDevice? _connectedDevice;
  BluetoothCharacteristic? _characteristic;

  @override
  void initState() {
    super.initState();
    _initBluetooth();
  }

  void _initBluetooth() async {
    FlutterBluePlus.scanResults.listen((results) {
      // TODO: Implement device selection logic
      // For now, we'll connect to the first device we find
      if (results.isNotEmpty) {
        _connectToDevice(results.first.device);
      }
    });

    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 4));
  }

  void _connectToDevice(BluetoothDevice device) async {
    await device.connect();
    _connectedDevice = device;

    List<BluetoothService> services = await device.discoverServices();
    for (var service in services) {
      // TODO: Replace with your specific service and characteristic UUIDs
      if (service.uuid.toString() == 'YOUR_SERVICE_UUID') {
        for (var characteristic in service.characteristics) {
          if (characteristic.uuid.toString() == 'YOUR_CHARACTERISTIC_UUID') {
            _characteristic = characteristic;
          }
        }
      }
    }
  }

  Future<void> _sendPreset() async {
    if (_characteristic == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bluetooth not connected')),
      );
      return;
    }

    try {
      String jsonPreset = jsonEncode(widget.preset.toJson());
      List<int> bytes = utf8.encode(jsonPreset);
      await _characteristic!.write(bytes);

      // Update current preset
      // TODO: Update this to use your state management solution
      // For now, we'll just show a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preset sent and set as current')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send preset: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.preset.name),
        actions: [
          IconButton(
            onPressed: _sendPreset,
            icon: const Icon(Icons.send_rounded),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            for (var recipe in widget.preset.recipeList)
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
