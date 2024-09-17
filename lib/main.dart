import 'package:flutter/material.dart';
import 'package:premixer/screens/home_screen.dart';
import 'package:premixer/screens/recipe_screen.dart';
import 'package:premixer/screens/setting_screen.dart';

void main() {
  runApp(const PremixerApp());
}

class PremixerApp extends StatefulWidget {
  const PremixerApp({super.key});

  @override
  State<PremixerApp> createState() => _PremixerAppState();
}

class _PremixerAppState extends State<PremixerApp> {
  int _selectedIndex = 0;

  static const List<Widget> _titleOptions = <Widget>[
    Text('음료: 미리섞은'),
    Text('레시피'),
    Text('설정'),
  ];

  static final List<Widget> _screenOptions = <Widget>[
    HomeScreen(),
    RecipeScreen(),
    const SettingScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: _titleOptions.elementAt(_selectedIndex),
        ),
        body: _screenOptions.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
          currentIndex: _selectedIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: '홈',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.create_rounded),
              label: '레시피',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_rounded),
              label: '설정',
            ),
          ],
        ),
      ),
    );
  }
}
