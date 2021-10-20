import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:smart_home/services/database_service.dart';
import 'package:firebase_core/firebase_core.dart';

import '../mediaQuery.dart';

class ColorPickerPage extends StatefulWidget {
  const ColorPickerPage({Key? key}) : super(key: key);

  @override
  _ColorPickerPageState createState() => _ColorPickerPageState();
}

class _ColorPickerPageState extends State<ColorPickerPage> {
  Color _pickerColor = Colors.red;
  void changeColor(Color color) async {
    _pickerColor = color;
    await DatabaseService().updateColor(color.red, color.green, color.blue);
  }

  @override
  Widget build(BuildContext context) {
    // Firebase.initializeApp();
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: displayHeight(context) * 3),
            child: ColorPicker(
              displayThumbColor: true,
              pickerColor: _pickerColor,
              onColorChanged: changeColor,
              showLabel: false,
              pickerAreaHeightPercent: 1,
              colorPickerWidth: displayWidth(context) * 70,
              enableAlpha: true,
              pickerAreaBorderRadius: BorderRadius.circular(50),
            ),
          ),
        ],
      ),
    );
  }
}
