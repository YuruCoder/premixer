import 'package:flutter/foundation.dart';
import 'package:premixer/models.dart';
import 'package:premixer/database.dart';

class AppStateProvider extends ChangeNotifier {
  List<SourceModel> _sources = [];
  List<RecipeModel> _recipes = [];
  List<PresetModel> _presets = [];

  List<SourceModel> get sources => _sources;
  List<RecipeModel> get recipes => _recipes;
  List<PresetModel> get presets => _presets;

  AppStateProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    _sources = await DatabaseHelper.instance.getSources();
    _recipes = await DatabaseHelper.instance.getRecipes();
    _presets = await DatabaseHelper.instance.getPresets();
    notifyListeners();
  }

  Future<void> addSource(SourceModel source) async {
    int id = await DatabaseHelper.instance.insertSource(source);
    _sources.add(SourceModel(
        id: id, name: source.name, description: source.description));
    notifyListeners();
  }

  Future<void> addRecipe(RecipeModel recipe) async {
    int id = await DatabaseHelper.instance.insertRecipe(recipe);
    _recipes.add(RecipeModel(
      id: id,
      name: recipe.name,
      srcA: recipe.srcA,
      srcB: recipe.srcB,
      ratioA: recipe.ratioA,
      ratioB: recipe.ratioB,
    ));
    notifyListeners();
  }

  Future<void> addPreset(PresetModel preset) async {
    int id = await DatabaseHelper.instance.insertPreset(preset);
    _presets.add(PresetModel(
      id: id,
      name: preset.name,
      recipeList: preset.recipeList,
    ));
    notifyListeners();
  }
}
