import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:smart_home/objects/buttons.dart';
import 'package:smart_home/services/realtimeDatabaseService.dart';

class ColorPickerPage extends StatefulWidget {
  const ColorPickerPage({Key? key}) : super(key: key);

  @override
  _ColorPickerPageState createState() => _ColorPickerPageState();
}

class _ColorPickerPageState extends State<ColorPickerPage> {
  Color _pickerColor = Colors.red;
  int _brightness = 0;
  bool lightIsOn = true;
  bool _isSwitched = true;
  Map<dynamic, dynamic>? data;

  void changeColor(Color color) {
    _pickerColor = color;
    _brightness = color.alpha;
    realTimeDatabase().updateBrightness((color.alpha / 2.55).round());
  }

  void sendData() async {
    await realTimeDatabase()
        .updateColor(_pickerColor.red, _pickerColor.green, _pickerColor.blue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return FutureBuilder(
              future: realTimeDatabase()
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
                              vertical: constraints.maxHeight * 0.02),
                          child: ColorPicker(
                            displayThumbColor: true,
                            pickerColor: _pickerColor,
                            onColorChanged: changeColor,
                            showLabel: false,
                            pickerAreaHeightPercent: 1,
                            colorPickerWidth: constraints.maxHeight * 0.45,
                            enableAlpha: true,
                            pickerAreaBorderRadius: BorderRadius.circular(
                                constraints.maxHeight * 0.03),
                          ),
                        ),
                      ),
                      TurnOnOffButton(
                          iconIsOn: _pickerColor.alpha == 0 ? false : true,
                          onPressed: () => realTimeDatabase().turnLightOnOff()),
                      SendButton(onPressed: () => sendData()),
                      // LightSwitch(
                      //   onChagned: () =>
                      //       realTimeDatabse().turnLightOnOff(lightIsOn),
                      //   isSwitched: _isSwitched,
                      // )
                    ],
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              });
        },
      ),
    );
  }
}
