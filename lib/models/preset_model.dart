import 'package:premixer/models/recipe_model.dart';
import 'package:premixer/models/source_model.dart';

class PresetModel {
  final int id;
  final String name;
  final List<RecipeModel> recipeList;
  final List<SourceModel> srcList = [];

  PresetModel({
    required this.id,
    required this.name,
    required this.recipeList,
  }) {
    for (var recipe in recipeList) {
      if (!srcList.contains(recipe.srcA)) {
        srcList.add(recipe.srcA);
      }
      if (!srcList.contains(recipe.srcB)) {
        srcList.add(recipe.srcB);
      }
    }
  }
}
