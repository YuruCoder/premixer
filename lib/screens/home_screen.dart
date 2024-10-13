import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:premixer/models.dart';
import 'package:premixer/provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, appState, child) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '현재 프리셋',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              appState.presets.isNotEmpty
                  ? _PresetCard(preset: appState.presets.last)
                  : const Text('현재 프리셋이 없습니다.'),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '내 프리셋',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _addPreset(context),
                    child: const Text(
                      '추가하기',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: appState.presets.isEmpty
                    ? const Text('내 프리셋이 없습니다.')
                    : ListView.builder(
                        itemCount: appState.presets.length,
                        itemBuilder: (context, index) {
                          return _PresetCard(preset: appState.presets[index]);
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _addPreset(BuildContext context) async {
    final appState = Provider.of<AppStateProvider>(context, listen: false);
    final newPreset = await Navigator.push<PresetModel>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AddPresetScreen(availableRecipes: appState.recipes),
        fullscreenDialog: true,
      ),
    );
    if (newPreset != null) {
      appState.addPreset(newPreset);
    }
  }
}

class _PresetCard extends StatelessWidget {
  final PresetModel preset;

  const _PresetCard({super.key, required this.preset});

  @override
  Widget build(BuildContext context) {
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                preset.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text('레시피: ${preset.recipeList.length}개'),
            ],
          ),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WatchPresetScreen(preset: preset),
                fullscreenDialog: true,
              ),
            ),
            child: const Row(
              children: [
                Text(
                  '자세히',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 24,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onAddTap;

  const _SectionHeader(
      {super.key, required this.title, required this.onAddTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _SectionTitle(title: title),
        GestureDetector(
          onTap: onAddTap,
          child: const Text(
            '추가하기',
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ),
      ],
    );
  }
}

class _PresetInfoRow extends StatelessWidget {
  final String title;
  final List<String> items;

  const _PresetInfoRow({super.key, required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title),
        ...items.map((item) => Text('$item ')),
      ],
    );
  }
}

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

class AddPresetScreen extends StatefulWidget {
  final List<RecipeModel> availableRecipes;

  const AddPresetScreen({super.key, required this.availableRecipes});

  @override
  _AddPresetScreenState createState() => _AddPresetScreenState();
}

class _AddPresetScreenState extends State<AddPresetScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  final List<RecipeModel> _selectedRecipes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('프리셋 추가하기'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _savePreset,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: '프리셋 이름'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '프리셋 이름을 입력해주세요';
                }
                return null;
              },
              onSaved: (value) => _name = value!,
            ),
            const SizedBox(height: 16),
            const Text('레시피 선택',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ..._buildRecipeCheckboxes(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildRecipeCheckboxes() {
    return widget.availableRecipes.map((recipe) {
      return CheckboxListTile(
        title: Text(recipe.name),
        subtitle: Text('${recipe.srcA.name} + ${recipe.srcB.name}'),
        value: _selectedRecipes.contains(recipe),
        onChanged: (bool? value) {
          setState(() {
            if (value == true) {
              _selectedRecipes.add(recipe);
            } else {
              _selectedRecipes.remove(recipe);
            }
          });
        },
      );
    }).toList();
  }

  void _savePreset() {
    if (_formKey.currentState!.validate() && _selectedRecipes.isNotEmpty) {
      _formKey.currentState!.save();
      final newPreset = PresetModel(
        id: DateTime.now().millisecondsSinceEpoch,
        name: _name,
        recipeList: _selectedRecipes,
      );
      Navigator.of(context).pop(newPreset);
    } else if (_selectedRecipes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('최소 하나의 레시피를 선택해주세요')),
      );
    }
  }
}
