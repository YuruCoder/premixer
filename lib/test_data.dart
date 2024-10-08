import 'package:premixer/models/preset_model.dart';
import 'package:premixer/models/recipe_model.dart';
import 'package:premixer/models/source_model.dart';

class TestData {
  static final srcA = SourceModel(
    id: 1,
    name: '망고',
  );
  static final srcB = SourceModel(
    id: 2,
    name: '사케',
  );
  static final recipes = [
    RecipeModel(
      id: 1,
      name: '콜라',
      srcA: srcA,
      srcB: srcB,
      ratioA: 2,
      ratioB: 1,
    ),
    RecipeModel(
      id: 2,
      name: '소다',
      srcA: srcA,
      srcB: srcB,
      ratioA: 1,
      ratioB: 2,
    ),
  ];
  static final preset = PresetModel(
    id: 1,
    name: '프리셋 1',
    recipeList: recipes,
  );
}
