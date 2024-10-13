import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:premixer/models/source_model.dart';
import 'package:premixer/models/recipe_model.dart';
import 'package:premixer/models/preset_model.dart';
import 'package:premixer/services/provider_service.dart';
import 'package:premixer/services/database_service.dart';

import 'provider_service_test.mocks.dart';

@GenerateMocks([DatabaseService])
void main() {
  late ProviderService providerService;
  late MockDatabaseService mockDatabaseService;

  setUp(() {
    mockDatabaseService = MockDatabaseService();
  });

  test('Load data from database', () async {
    final sources = [SourceModel(id: 1, name: 'Test Source')];
    final recipes = [
      RecipeModel(
          id: 1,
          name: 'Test Recipe',
          srcA: sources[0],
          srcB: sources[0],
          ratioA: 1,
          ratioB: 1)
    ];
    final presets = [
      PresetModel(id: 1, name: 'Test Preset', recipeList: recipes)
    ];

    when(mockDatabaseService.getSources()).thenAnswer((_) async => sources);
    when(mockDatabaseService.getRecipes()).thenAnswer((_) async => recipes);
    when(mockDatabaseService.getPresets()).thenAnswer((_) async => presets);

    providerService = ProviderService(databaseService: mockDatabaseService);

    // Wait for the _loadData to complete
    await Future.delayed(Duration.zero);

    expect(providerService.sources, equals(sources));
    expect(providerService.recipes, equals(recipes));
    expect(providerService.presets, equals(presets));
  });

  test('Add source', () async {
    final source = SourceModel(name: 'New Source');
    when(mockDatabaseService.insertSource(source)).thenAnswer((_) async => 1);

    providerService = ProviderService(databaseService: mockDatabaseService);
    await providerService.addSource(source);

    verify(mockDatabaseService.insertSource(source)).called(1);
    expect(providerService.sources.length, equals(1));
    expect(providerService.sources[0].id, equals(1));
    expect(providerService.sources[0].name, equals('New Source'));
  });

  test('Add recipe', () async {
    final source = SourceModel(id: 1, name: 'Test Source');
    final recipe = RecipeModel(
        name: 'New Recipe', srcA: source, srcB: source, ratioA: 1, ratioB: 2);
    when(mockDatabaseService.insertRecipe(recipe)).thenAnswer((_) async => 1);

    providerService = ProviderService(databaseService: mockDatabaseService);
    await providerService.addRecipe(recipe);

    verify(mockDatabaseService.insertRecipe(recipe)).called(1);
    expect(providerService.recipes.length, equals(1));
    expect(providerService.recipes[0].id, equals(1));
    expect(providerService.recipes[0].name, equals('New Recipe'));
  });

  test('Add preset', () async {
    final source = SourceModel(id: 1, name: 'Test Source');
    final recipe = RecipeModel(
        id: 1,
        name: 'Test Recipe',
        srcA: source,
        srcB: source,
        ratioA: 1,
        ratioB: 1);
    final preset = PresetModel(name: 'New Preset', recipeList: [recipe]);
    when(mockDatabaseService.insertPreset(preset)).thenAnswer((_) async => 1);

    providerService = ProviderService(databaseService: mockDatabaseService);
    await providerService.addPreset(preset);

    verify(mockDatabaseService.insertPreset(preset)).called(1);
    expect(providerService.presets.length, equals(1));
    expect(providerService.presets[0].id, equals(1));
    expect(providerService.presets[0].name, equals('New Preset'));
  });
}
