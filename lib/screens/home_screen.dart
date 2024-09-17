import 'package:flutter/material.dart';
import 'package:premixer/models/recipe_model.dart';
import 'package:premixer/test_data.dart';
import 'package:premixer/widgets/source_tag.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final preset = TestData.preset;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '내 프리셋',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text(
                '원천 음료: ',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              for (var src in preset.srcList) ...[
                SourceTag(src: src),
                const SizedBox(width: 4)
              ],
            ],
          ),
          const SizedBox(height: 16),
          for (var recipe in preset.recipeList) ...[
            buildRecipeCard(recipe),
            const SizedBox(
              height: 8,
            )
          ],
        ],
      ),
    );
  }

  Container buildRecipeCard(RecipeModel recipe) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('이름: ${recipe.drinkName}'),
          Text('원천 1: ${recipe.srcA.name} / 비율: ${recipe.ratioA}'),
          Text('원천 2: ${recipe.srcB.name} / 비율: ${recipe.ratioB}'),
        ],
      ),
    );
  }
}
