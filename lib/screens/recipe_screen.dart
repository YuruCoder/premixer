import 'package:flutter/material.dart';
import 'package:premixer/screens/add_recipe_screen.dart';
import 'package:premixer/screens/add_source_screen.dart';
import 'package:premixer/services/fakedb_service.dart';

class RecipeScreen extends StatelessWidget {
  RecipeScreen({super.key});

  final db = FakedbService();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '내 재료',
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
                      builder: (context) => const AddSourceScreen(),
                      fullscreenDialog: true,
                    ),
                  ),
                },
                child: const Text(
                  '추가하기',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text('내 재료가 없습니다.'),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '내 레시피',
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
                      builder: (context) => const AddRecipeScreen(),
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
          const Text('내 레시피가 없습니다.'),
        ],
      ),
    );
  }
}
