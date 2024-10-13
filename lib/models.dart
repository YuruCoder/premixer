import 'dart:convert';

class SourceModel {
  final int? id;
  final String name;
  final String description;

  SourceModel({
    this.id,
    required this.name,
    this.description = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }

  factory SourceModel.fromMap(Map<String, dynamic> map) {
    return SourceModel(
      id: map['id'],
      name: map['name'],
      description: map['description'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SourceModel.fromJson(String source) =>
      SourceModel.fromMap(json.decode(source));
}

class RecipeModel {
  final int? id;
  final String name;
  final SourceModel srcA;
  final SourceModel srcB;
  final int ratioA;
  final int ratioB;

  RecipeModel({
    this.id,
    required this.name,
    required this.srcA,
    required this.srcB,
    required this.ratioA,
    required this.ratioB,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'srcA': srcA.toMap(),
      'srcB': srcB.toMap(),
      'ratioA': ratioA,
      'ratioB': ratioB,
    };
  }

  factory RecipeModel.fromMap(Map<String, dynamic> map) {
    return RecipeModel(
      id: map['id'],
      name: map['name'],
      srcA: SourceModel.fromMap(map['srcA']),
      srcB: SourceModel.fromMap(map['srcB']),
      ratioA: map['ratioA'],
      ratioB: map['ratioB'],
    );
  }

  String toJson() => json.encode(toMap());

  factory RecipeModel.fromJson(String source) =>
      RecipeModel.fromMap(json.decode(source));
}

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
