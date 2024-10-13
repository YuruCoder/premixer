import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:premixer/models.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('premixer.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE sources (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  description TEXT
)
''');

    await db.execute('''
CREATE TABLE recipes (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  srcA_id INTEGER NOT NULL,
  srcB_id INTEGER NOT NULL,
  ratioA INTEGER NOT NULL,
  ratioB INTEGER NOT NULL,
  FOREIGN KEY (srcA_id) REFERENCES sources (id),
  FOREIGN KEY (srcB_id) REFERENCES sources (id)
)
''');

    await db.execute('''
CREATE TABLE presets (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL
)
''');

    await db.execute('''
CREATE TABLE preset_recipes (
  preset_id INTEGER NOT NULL,
  recipe_id INTEGER NOT NULL,
  FOREIGN KEY (preset_id) REFERENCES presets (id),
  FOREIGN KEY (recipe_id) REFERENCES recipes (id),
  PRIMARY KEY (preset_id, recipe_id)
)
''');
  }

  Future<int> insertSource(SourceModel source) async {
    final db = await database;
    return await db.insert('sources', source.toMap());
  }

  Future<int> insertRecipe(RecipeModel recipe) async {
    final db = await database;
    return await db.insert('recipes', {
      'name': recipe.name,
      'srcA_id': recipe.srcA.id,
      'srcB_id': recipe.srcB.id,
      'ratioA': recipe.ratioA,
      'ratioB': recipe.ratioB,
    });
  }

  Future<int> insertPreset(PresetModel preset) async {
    final db = await database;
    int presetId = await db.insert('presets', {'name': preset.name});
    for (var recipe in preset.recipeList) {
      await db.insert('preset_recipes', {
        'preset_id': presetId,
        'recipe_id': recipe.id,
      });
    }
    return presetId;
  }

  Future<List<SourceModel>> getSources() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('sources');
    return List.generate(maps.length, (i) => SourceModel.fromMap(maps[i]));
  }

  Future<List<RecipeModel>> getRecipes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('recipes');
    List<RecipeModel> recipes = [];
    for (var map in maps) {
      SourceModel srcA = await getSourceById(map['srcA_id']);
      SourceModel srcB = await getSourceById(map['srcB_id']);
      recipes.add(RecipeModel(
        id: map['id'],
        name: map['name'],
        srcA: srcA,
        srcB: srcB,
        ratioA: map['ratioA'],
        ratioB: map['ratioB'],
      ));
    }
    return recipes;
  }

  Future<List<PresetModel>> getPresets() async {
    final db = await database;
    final List<Map<String, dynamic>> presetMaps = await db.query('presets');
    List<PresetModel> presets = [];
    for (var presetMap in presetMaps) {
      final List<Map<String, dynamic>> recipeIdMaps = await db.query(
        'preset_recipes',
        where: 'preset_id = ?',
        whereArgs: [presetMap['id']],
      );
      List<RecipeModel> recipes = [];
      for (var recipeIdMap in recipeIdMaps) {
        RecipeModel recipe = await getRecipeById(recipeIdMap['recipe_id']);
        recipes.add(recipe);
      }
      presets.add(PresetModel(
        id: presetMap['id'],
        name: presetMap['name'],
        recipeList: recipes,
      ));
    }
    return presets;
  }

  Future<SourceModel> getSourceById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'sources',
      where: 'id = ?',
      whereArgs: [id],
    );
    return SourceModel.fromMap(maps.first);
  }

  Future<RecipeModel> getRecipeById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'recipes',
      where: 'id = ?',
      whereArgs: [id],
    );
    SourceModel srcA = await getSourceById(maps.first['srcA_id']);
    SourceModel srcB = await getSourceById(maps.first['srcB_id']);
    return RecipeModel(
      id: maps.first['id'],
      name: maps.first['name'],
      srcA: srcA,
      srcB: srcB,
      ratioA: maps.first['ratioA'],
      ratioB: maps.first['ratioB'],
    );
  }
}
