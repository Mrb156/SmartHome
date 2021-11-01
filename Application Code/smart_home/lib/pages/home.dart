import 'package:flutter/material.dart';
import 'package:smart_home/pages/colorPicker2.dart';
import 'package:smart_home/pages/homePage.dart';

import 'heating.dart';

//ezen az oldalon van az app váza, ami körülfogja a megfelelő oldalakat

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //létrehozzuk a megfelelő változókat, és függvényeket
  int _selectedIndex = 1;
  final List<Widget> _pages = const [ColorPickerPage(), HomePage(), Heating()];

  //ez a metódus vezérli a bottom navigation bar-t, hogy tudjunk váltogatni az oldalak között
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Smart Home Control',
          style: TextStyle(color: Colors.black),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.colorize), label: 'Color Picker'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.waves), label: 'Heating'),
        ],
      ),
      body: _pages[_selectedIndex],
    );
  }
}
