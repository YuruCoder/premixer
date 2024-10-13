import 'package:flutter/material.dart';
import 'package:premixer/models/recipe_model.dart';
import 'package:premixer/models/source_model.dart';

class AddRecipeScreen extends StatefulWidget {
  final List<SourceModel> availableSources;

  const AddRecipeScreen({super.key, required this.availableSources});

  @override
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  SourceModel? _sourceA;
  SourceModel? _sourceB;
  int _ratioA = 1;
  int _ratioB = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('레시피 추가하기'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveRecipe,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: '레시피 이름'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '레시피 이름을 입력해주세요';
                }
                return null;
              },
              onSaved: (value) => _name = value!,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<SourceModel>(
              decoration: const InputDecoration(labelText: '재료 A'),
              value: _sourceA,
              items: widget.availableSources
                  .map((source) => DropdownMenuItem(
                        value: source,
                        child: Text(source.name),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => _sourceA = value),
              validator: (value) => value == null ? '재료 A를 선택해주세요' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<SourceModel>(
              decoration: const InputDecoration(labelText: '재료 B'),
              value: _sourceB,
              items: widget.availableSources
                  .map((source) => DropdownMenuItem(
                        value: source,
                        child: Text(source.name),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => _sourceB = value),
              validator: (value) => value == null ? '재료 B를 선택해주세요' : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: '비율 A'),
                    keyboardType: TextInputType.number,
                    initialValue: _ratioA.toString(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '비율을 입력해주세요';
                      }
                      if (int.tryParse(value) == null ||
                          int.parse(value) <= 0) {
                        return '유효한 숫자를 입력해주세요';
                      }
                      return null;
                    },
                    onSaved: (value) => _ratioA = int.parse(value!),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: '비율 B'),
                    keyboardType: TextInputType.number,
                    initialValue: _ratioB.toString(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '비율을 입력해주세요';
                      }
                      if (int.tryParse(value) == null ||
                          int.parse(value) <= 0) {
                        return '유효한 숫자를 입력해주세요';
                      }
                      return null;
                    },
                    onSaved: (value) => _ratioB = int.parse(value!),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _saveRecipe() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newRecipe = RecipeModel(
        id: DateTime.now().millisecondsSinceEpoch,
        name: _name,
        srcA: _sourceA!,
        srcB: _sourceB!,
        ratioA: _ratioA,
        ratioB: _ratioB,
      );
      Navigator.of(context).pop(newRecipe);
    }
  }
}
