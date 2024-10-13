import 'dart:convert';

import 'package:premixer/models/source_model.dart';

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
