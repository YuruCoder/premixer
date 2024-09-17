import 'package:flutter/material.dart';
import 'package:premixer/interfaces/db_interface.dart';
import 'package:premixer/models/preset_model.dart';
import 'package:premixer/models/recipe_model.dart';
import 'package:premixer/models/source_model.dart';

class FakedbService implements DbInterface {
  @override
  List<SourceModel> sourceData = [];

  @override
  List<RecipeModel> recipeData = [];

  @override
  List<PresetModel> presetData = [];

  int _srcId = 0, _recipeId = 0, _presetId = 0;

  @override
  void setSource({
    required String name,
    String description = '',
  }) {
    if (sourceData.any((src) => src.name == name)) {
      throw ErrorDescription('이미 입력된 원료입니다.');
    }

    if (description.length > 300) {
      throw ErrorHint('설명글이 300자 이상입니다.');
    }

    sourceData.add(SourceModel(
      id: _srcId++,
      name: name,
      description: description,
    ));
  }

  @override
  List<SourceModel> getAllSources() => sourceData;

  @override
  SourceModel getSourceById(int id) {
    var data = sourceData.firstWhere(
      (src) => src.id == id,
      orElse: () => SourceModel(id: -1, name: ''),
    );

    if (data.id == -1) {
      throw ErrorDescription('해당 id의 원료가 존재하지 않습니다.');
    }

    return data;
  }

  @override
  bool deleteSourceById(int id) {
    try {
      var data = getSourceById(id);
      return sourceData.remove(data);
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  void setRecipe(
    String name,
    SourceModel srcA,
    SourceModel srcB,
    int ratioA,
    int ratioB,
  ) {
    if (!(sourceData.contains(srcA) && sourceData.contains(srcB))) {
      throw ErrorDescription('저장된 원료를 사용하지 않았습니다.');
    }

    recipeData.add(RecipeModel(
      id: _recipeId++,
      drinkName: name,
      srcA: srcA,
      srcB: srcB,
      ratioA: ratioA,
      ratioB: ratioB,
    ));
  }

  @override
  List<RecipeModel> getAllRecipies() => recipeData;

  @override
  RecipeModel getRecipeById(int id) {
    var data = recipeData.firstWhere(
      (recipe) => recipe.id == id,
      orElse: () => RecipeModel(
        id: -1,
        drinkName: '',
        srcA: SourceModel(id: -1, name: ''),
        srcB: SourceModel(id: -1, name: ''),
        ratioA: 0,
        ratioB: 0,
      ),
    );

    if (data.id == -1) {
      throw ErrorDescription('해당 id의 레시피가 존재하지 않습니다.');
    }

    return data;
  }

  @override
  bool deleteRecipeById(int id) {
    try {
      var data = getRecipeById(id);
      return recipeData.remove(data);
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  void setPreset(List<RecipeModel> recipeList) {
    presetData.add(PresetModel(id: _presetId++, recipeList: recipeList));
  }

  @override
  List<PresetModel> getAllPresets() => presetData;

  @override
  PresetModel getPresetById(int id) {
    var data = presetData.firstWhere(
      (preset) => preset.id == id,
      orElse: () => PresetModel(id: -1, recipeList: []),
    );

    if (data.id == -1) {
      throw ErrorDescription('해당 id의 프레셋이 존재하지 않습니다.');
    }

    return data;
  }

  @override
  bool deletePresetById(int id) {
    try {
      var data = getPresetById(id);
      return presetData.remove(data);
    } catch (e) {
      print(e);
      return false;
    }
  }
}
