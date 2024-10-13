import 'package:flutter/material.dart';
import 'package:premixer/models/source_model.dart';
import 'package:premixer/services/provider_service.dart';
import 'package:provider/provider.dart';

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
      await Provider.of<ProviderService>(context, listen: false)
          .addSource(newSource);
      Navigator.of(context).pop();
    }
  }
}
