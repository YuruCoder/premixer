import 'package:flutter/material.dart';

class AddRecipeScreen extends StatelessWidget {
  const AddRecipeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('레시피 추가하기'),
      ),
      body: const Center(
        child: Text('Add Recipe'),
      ),
    );
  }
}
