import 'package:flutter/material.dart';
import 'package:premixer/models/preset_model.dart';
import 'package:premixer/models/recipe_model.dart';

class AddPresetScreen extends StatefulWidget {
  final List<RecipeModel> availableRecipes;

  const AddPresetScreen({super.key, required this.availableRecipes});

  @override
  State<StatefulWidget> createState() => _AddPresetScreenState();
}

class _AddPresetScreenState extends State<AddPresetScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  final List<RecipeModel> _selectedRecipes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('프리셋 추가하기'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _savePreset,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: '프리셋 이름'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '프리셋 이름을 입력해주세요';
                }
                return null;
              },
              onSaved: (value) => _name = value!,
            ),
            const SizedBox(height: 16),
            const Text('레시피 선택',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ..._buildRecipeCheckboxes(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildRecipeCheckboxes() {
    return widget.availableRecipes.map((recipe) {
      return CheckboxListTile(
        title: Text(recipe.name),
        subtitle: Text('${recipe.srcA.name} + ${recipe.srcB.name}'),
        value: _selectedRecipes.contains(recipe),
        onChanged: (bool? value) {
          setState(() {
            if (value == true) {
              _selectedRecipes.add(recipe);
            } else {
              _selectedRecipes.remove(recipe);
            }
          });
        },
      );
    }).toList();
  }

  void _savePreset() {
    if (_formKey.currentState!.validate() && _selectedRecipes.isNotEmpty) {
      _formKey.currentState!.save();
      final newPreset = PresetModel(
        id: DateTime.now().millisecondsSinceEpoch,
        name: _name,
        recipeList: _selectedRecipes,
      );
      Navigator.of(context).pop(newPreset);
    } else if (_selectedRecipes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('최소 하나의 레시피를 선택해주세요')),
      );
    }
  }
}
