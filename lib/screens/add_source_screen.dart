import 'package:flutter/material.dart';

class AddSourceScreen extends StatelessWidget {
  const AddSourceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('재료 추가하기'),
      ),
      body: const Center(
        child: Text('Hello'),
      ),
    );
  }
}
