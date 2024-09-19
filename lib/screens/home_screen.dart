import 'package:flutter/material.dart';
import 'package:premixer/models/preset_model.dart';
import 'package:premixer/screens/presets/add_preset_screen.dart';
import 'package:premixer/screens/presets/watch_preset_screen.dart';
import 'package:premixer/test_data.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  // 실제로는 DB를 사용 예정. 현재 테스트를 위해 Delayed를 이용
  final Future<PresetModel> currentPreset = Future.delayed(
    const Duration(seconds: 2),
    () => TestData.preset,
  );

  @override
  Widget build(BuildContext context) {
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
          FutureBuilder(
            future: currentPreset,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data!;
                return buildPresetCard(context, data);
              } else {
                return const Text(
                  'Loading...',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                );
              }
            },
          ),
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
                onTap: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddPresetScreen(),
                      fullscreenDialog: true,
                    ),
                  ),
                },
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
          const Text('내 프리셋이 없습니다.'),
        ],
      ),
    );
  }

  Container buildPresetCard(BuildContext context, PresetModel data) {
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
                data.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  const Text('재료: '),
                  for (var src in data.srcList) Text('${src.name} ')
                ],
              ),
              Row(
                children: [
                  const Text('레시피: '),
                  for (var recipe in data.recipeList) Text('${recipe.name} ')
                ],
              ),
            ],
          ),
          IconButton(
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WatchPresetScreen(preset: data),
                  fullscreenDialog: true,
                ),
              )
            },
            icon: const Icon(Icons.chevron_right_rounded),
          )
        ],
      ),
    );
  }
}
