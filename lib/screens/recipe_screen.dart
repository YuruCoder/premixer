import 'package:flutter/material.dart';
import 'package:premixer/models/recipe_model.dart';
import 'package:premixer/models/source_model.dart';
import 'package:premixer/screens/add_recipe_screen.dart';
import 'package:premixer/screens/add_source_screen.dart';
import 'package:premixer/services/provider_service.dart';
import 'package:provider/provider.dart';

class RecipeScreen extends StatelessWidget {
  const RecipeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderService>(
      builder: (context, appState, child) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection(
                context: context,
                title: '내 재료',
                items: appState.sources,
                itemBuilder: (source) => Text(source.name),
                onAddPressed: () => _addSource(context),
              ),
              const SizedBox(height: 16),
              _buildSection(
                context: context,
                title: '내 레시피',
                items: appState.recipes,
                itemBuilder: (recipe) => Text(recipe.name),
                onAddPressed: () => _addRecipe(context),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSection<T>({
    required BuildContext context,
    required String title,
    required List<T> items,
    required Widget Function(T) itemBuilder,
    required VoidCallback onAddPressed,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            GestureDetector(
              onTap: onAddPressed,
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
        items.isEmpty
            ? Text('$title가 없습니다.')
            : Column(
                children: items.map((item) => itemBuilder(item)).toList(),
              ),
      ],
    );
  }

  void _addSource(BuildContext context) async {
    final newSource = await Navigator.push<SourceModel>(
      context,
      MaterialPageRoute(
        builder: (context) => const AddSourceScreen(),
        fullscreenDialog: true,
      ),
    );
    if (newSource != null) {
      Provider.of<ProviderService>(context, listen: false).addSource(newSource);
    }
  }

  void _addRecipe(BuildContext context) async {
    final appState = Provider.of<ProviderService>(context, listen: false);
    final newRecipe = await Navigator.push<RecipeModel>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AddRecipeScreen(availableSources: appState.sources),
        fullscreenDialog: true,
      ),
    );
    if (newRecipe != null) {
      appState.addRecipe(newRecipe);
    }
  }
}
