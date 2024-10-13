import 'package:flutter_test/flutter_test.dart';
import 'package:premixer/models/preset_model.dart';
import 'package:premixer/models/recipe_model.dart';
import 'package:premixer/models/source_model.dart';
import 'package:premixer/services/database_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late DatabaseService databaseService;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    databaseService = DatabaseService.instance;
    await databaseService.database;
  });

  test('Insert and retrieve a source', () async {
    final source =
        SourceModel(name: 'Test Source', description: 'Test Description');
    final id = await databaseService.insertSource(source);
    expect(id, isNotNull);

    final retrievedSource = await databaseService.getSourceById(id);
    expect(retrievedSource.name, equals(source.name));
    expect(retrievedSource.description, equals(source.description));
  });

  test('Insert and retrieve a recipe', () async {
    final sourceA = SourceModel(name: 'Source A');
    final sourceB = SourceModel(name: 'Source B');
    final idA = await databaseService.insertSource(sourceA);
    final idB = await databaseService.insertSource(sourceB);

    final recipe = RecipeModel(
      name: 'Test Recipe',
      srcA: SourceModel(id: idA, name: sourceA.name),
      srcB: SourceModel(id: idB, name: sourceB.name),
      ratioA: 1,
      ratioB: 2,
    );

    final id = await databaseService.insertRecipe(recipe);
    expect(id, isNotNull);

    final retrievedRecipe = await databaseService.getRecipeById(id);
    expect(retrievedRecipe.name, equals(recipe.name));
    expect(retrievedRecipe.ratioA, equals(recipe.ratioA));
    expect(retrievedRecipe.ratioB, equals(recipe.ratioB));
  });

  test('Insert and retrieve a preset', () async {
    final source = SourceModel(name: 'Test Source');
    final sourceId = await databaseService.insertSource(source);

    final recipe = RecipeModel(
      name: 'Test Recipe',
      srcA: SourceModel(id: sourceId, name: source.name),
      srcB: SourceModel(id: sourceId, name: source.name),
      ratioA: 1,
      ratioB: 1,
    );
    final recipeId = await databaseService.insertRecipe(recipe);

    final preset = PresetModel(
      name: 'Test Preset',
      recipeList: [
        RecipeModel(
            id: recipeId,
            name: recipe.name,
            srcA: recipe.srcA,
            srcB: recipe.srcB,
            ratioA: recipe.ratioA,
            ratioB: recipe.ratioB)
      ],
    );

    final id = await databaseService.insertPreset(preset);
    expect(id, isNotNull);

    final presets = await databaseService.getPresets();
    expect(presets.length, equals(1));
    expect(presets[0].name, equals(preset.name));
    expect(presets[0].recipeList.length, equals(1));
  });
}
