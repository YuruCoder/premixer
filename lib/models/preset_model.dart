import 'package:premixer/models/recipe_model.dart';
import 'package:premixer/models/source_model.dart';

class PresetModel {
  final int id;
  final int srcNum; // 2개

  final List<RecipeModel> recipeList; // 2개
  final List<SourceModel> srcList = []; // 2개

  PresetModel({
    required this.id,
    this.srcNum = 2,
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
