import 'package:flutter/material.dart';
import 'package:smart_home/pages/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:smart_home/services/notification.dart';

//a main a program belépő pontja
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  NotificationApi().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Smart Home Control',
      home: Home(),
    );
  }
}
