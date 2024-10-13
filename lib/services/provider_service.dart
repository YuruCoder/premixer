import 'package:flutter/foundation.dart';
import 'package:premixer/models/preset_model.dart';
import 'package:premixer/models/recipe_model.dart';
import 'package:premixer/models/source_model.dart';
import 'package:premixer/services/database_service.dart';

class ProviderService extends ChangeNotifier {
  final DatabaseService _databaseService;

  List<SourceModel> _sources = [];
  List<RecipeModel> _recipes = [];
  List<PresetModel> _presets = [];

  List<SourceModel> get sources => _sources;
  List<RecipeModel> get recipes => _recipes;
  List<PresetModel> get presets => _presets;

  ProviderService({DatabaseService? databaseService})
      : _databaseService = databaseService ?? DatabaseService.instance {
    _loadData();
  }

  Future<void> _loadData() async {
    _sources = await _databaseService.getSources();
    _recipes = await _databaseService.getRecipes();
    _presets = await _databaseService.getPresets();
    notifyListeners();
  }

  Future<void> addSource(SourceModel source) async {
    int id = await _databaseService.insertSource(source);
    _sources.add(SourceModel(
        id: id, name: source.name, description: source.description));
    notifyListeners();
  }

  Future<void> addRecipe(RecipeModel recipe) async {
    int id = await _databaseService.insertRecipe(recipe);
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
    int id = await _databaseService.insertPreset(preset);
    _presets.add(PresetModel(
      id: id,
      name: preset.name,
      recipeList: preset.recipeList,
    ));
    notifyListeners();
  }
}
