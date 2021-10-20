import 'package:flutter/material.dart';
import 'package:smart_home/pages/home.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();
    return MaterialApp(
      title: 'Smart Home Control',
      home: Home(),
    );
  }
}
