import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final isConnected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('음료 미리 섞은 자판기'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: isConnected ? buildConnectedScreen() : buildDisconnectedScreen(),
      ),
    );
  }

  Column buildConnectedScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '현재 선택된 레시피',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w400,
          ),
        ),
        const Text(
          '레시피 추가하기',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w400,
          ),
        ),
        Container(
          height: 80,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black54,
              width: 1,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add),
              Text('연결'),
            ],
          ),
        ),
        const Text(
          '저장된 레시피 목록',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Column buildDisconnectedScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '기기 연결',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w400,
          ),
        ),
        Container(
          height: 80,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black54,
              width: 1,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add),
              Text('연결'),
            ],
          ),
        ),
      ],
    );
  }
}
