import 'package:premixer/models/preset_model.dart';
import 'package:premixer/models/recipe_model.dart';
import 'package:premixer/models/source_model.dart';

abstract class DbInterface {
  abstract List<SourceModel> sourceData;
  abstract List<RecipeModel> recipeData;
  abstract List<PresetModel> presetData;

  void setSource({required String name, String description = ''});
  List<SourceModel> getAllSources();
  SourceModel getSourceById(int id);
  bool deleteSourceById(int id);

  void setRecipe(
      String name, SourceModel srcA, SourceModel srcB, int ratioA, int ratioB);
  List<RecipeModel> getAllRecipies();
  RecipeModel getRecipeById(int id);
  bool deleteRecipeById(int id);

  void setPreset(List<RecipeModel> recipeList);
  List<PresetModel> getAllPresets();
  PresetModel getPresetById(int id);
  bool deletePresetById(int id);
}
