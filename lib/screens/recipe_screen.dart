import 'package:flutter/material.dart';
import 'package:premixer/models.dart';
import 'package:premixer/provider.dart';
import 'package:provider/provider.dart';

class RecipeScreen extends StatelessWidget {
  const RecipeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, appState, child) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection(
                context: context,
                title: '내 재료',
                items: appState.sources,
                itemBuilder: (source) => Text(source.name),
                onAddPressed: () => _addSource(context),
              ),
              const SizedBox(height: 16),
              _buildSection(
                context: context,
                title: '내 레시피',
                items: appState.recipes,
                itemBuilder: (recipe) => Text(recipe.name),
                onAddPressed: () => _addRecipe(context),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSection<T>({
    required BuildContext context,
    required String title,
    required List<T> items,
    required Widget Function(T) itemBuilder,
    required VoidCallback onAddPressed,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            GestureDetector(
              onTap: onAddPressed,
              child: const Text(
                '추가하기',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        items.isEmpty
            ? Text('$title가 없습니다.')
            : Column(
                children: items.map((item) => itemBuilder(item)).toList(),
              ),
      ],
    );
  }

  void _addSource(BuildContext context) async {
    final newSource = await Navigator.push<SourceModel>(
      context,
      MaterialPageRoute(
        builder: (context) => const AddSourceScreen(),
        fullscreenDialog: true,
      ),
    );
    if (newSource != null) {
      Provider.of<AppStateProvider>(context, listen: false)
          .addSource(newSource);
    }
  }

  void _addRecipe(BuildContext context) async {
    final appState = Provider.of<AppStateProvider>(context, listen: false);
    final newRecipe = await Navigator.push<RecipeModel>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AddRecipeScreen(availableSources: appState.sources),
        fullscreenDialog: true,
      ),
    );
    if (newRecipe != null) {
      appState.addRecipe(newRecipe);
    }
  }
}

class AddSourceScreen extends StatefulWidget {
  const AddSourceScreen({super.key});

  @override
  _AddSourceScreenState createState() => _AddSourceScreenState();
}

class _AddSourceScreenState extends State<AddSourceScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _description = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('재료 추가하기'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveSource,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: '재료 이름'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '재료 이름을 입력해주세요';
                }
                return null;
              },
              onSaved: (value) => _name = value!,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(labelText: '설명 (선택사항)'),
              maxLines: 3,
              onSaved: (value) => _description = value ?? '',
            ),
          ],
        ),
      ),
    );
  }

  void _saveSource() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newSource = SourceModel(
        name: _name,
        description: _description,
      );
      await Provider.of<AppStateProvider>(context, listen: false)
          .addSource(newSource);
      Navigator.of(context).pop();
    }
  }
}

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
