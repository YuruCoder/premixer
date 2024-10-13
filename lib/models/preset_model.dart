import 'dart:convert';

import 'package:premixer/models/recipe_model.dart';
import 'package:premixer/models/source_model.dart';

class PresetModel {
  final int? id;
  final String name;
  final List<RecipeModel> recipeList;
  List<SourceModel> srcList = [];

  PresetModel({
    this.id,
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'recipeList': recipeList.map((x) => x.toMap()).toList(),
      'srcList': srcList.map((x) => x.toMap()).toList(),
    };
  }

  factory PresetModel.fromMap(Map<String, dynamic> map) {
    return PresetModel(
      id: map['id'],
      name: map['name'],
      recipeList: List<RecipeModel>.from(
          map['recipeList']?.map((x) => RecipeModel.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory PresetModel.fromJson(String source) =>
      PresetModel.fromMap(json.decode(source));
}
