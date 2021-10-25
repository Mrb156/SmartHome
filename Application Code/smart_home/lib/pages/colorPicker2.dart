import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:smart_home/objects/buttons.dart';
import 'package:smart_home/services/realtimeDatabaseService.dart';

import '../mediaQuery.dart';

class ColorPickerPage extends StatefulWidget {
  const ColorPickerPage({Key? key}) : super(key: key);

  @override
  _ColorPickerPageState createState() => _ColorPickerPageState();
}

class _ColorPickerPageState extends State<ColorPickerPage> {
  Color _pickerColor = Colors.red;
  int? _brightness = 0;
  bool lightIsOn = true;
  bool _isSwitched = true;
  Map<dynamic, dynamic>? data;

  void changeColor(Color color) {
    _pickerColor = color;
    realTimeDatabse().updateBrightness((color.alpha / 2.55).round());
  }

  void sendData() async {
    await realTimeDatabse()
        .updateColor(_pickerColor.red, _pickerColor.green, _pickerColor.blue);
  }

  void turnLightOnOff(int value) async {
    if (_brightness! == 0) {
      lightIsOn = false;
    } else if (_brightness! > 0) {
      lightIsOn = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: FutureBuilder(
            future: realTimeDatabse()
                .databaseReference
                .child('/Control/LED control/')
                .once(),
            builder:
                (BuildContext context, AsyncSnapshot<DataSnapshot> snapshot) {
              if (snapshot.hasData) {
                data = snapshot.data!.value;

                _pickerColor = Color.fromARGB(
                  (data!['Brightness'] * 2.55).round(),
                  (data!['Colors']['Red']),
                  (data!['Colors']['Green']),
                  (data!['Colors']['Blue']),
                );
                // _brightness = (data!['Brightness'] * 2.55).round();
                return Column(
                  children: [
                    AbsorbPointer(
                      absorbing: false,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: displayHeight(context) * 3),
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
                    ),
                    TurnOnOffButton(
                        onPressed: () => turnLightOnOff(lightIsOn ? 0 : 100)),
                    SendButton(onPressed: () => sendData()),
                    LightSwitch(
                      onChagned: () {},
                      isSwitched: _isSwitched,
                    )
                  ],
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }
}
