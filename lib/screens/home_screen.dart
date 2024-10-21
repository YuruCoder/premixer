import 'package:flutter/material.dart';
import 'package:premixer/models/preset_model.dart';
import 'package:premixer/screens/add_preset_screen.dart';
import 'package:premixer/screens/watch_preset_screen.dart';
import 'package:premixer/services/provider_service.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderService>(
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
              const SizedBox(
                height: 8,
              ),
              appState.presets.isNotEmpty
                  ? _PresetCard(
                      preset: appState.presets.last,
                    )
                  : const Text('현재 프리셋이 없습니다.'),
              const SizedBox(
                height: 16,
              ),
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
              const SizedBox(
                height: 8,
              ),
              Expanded(
                child: appState.presets.isEmpty
                    ? const Text('내 프리셋이 없습니다.')
                    : ListView.builder(
                        itemCount: appState.presets.length,
                        itemBuilder: (context, index) {
                          return _PresetCard(
                            preset: appState.presets[index],
                          );
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
    final appState = Provider.of<ProviderService>(context, listen: false);
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

  const _PresetCard({
    required this.preset,
  });

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
