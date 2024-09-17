import 'package:premixer/models/source_model.dart';

class RecipeModel {
  final int id, ratioA, ratioB;
  final String drinkName;
  final SourceModel srcA, srcB;

  RecipeModel({
    required this.id,
    required this.drinkName,
    required this.srcA,
    required this.srcB,
    required this.ratioA,
    required this.ratioB,
  });
}
