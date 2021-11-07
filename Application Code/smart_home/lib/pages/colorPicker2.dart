import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:smart_home/colors.dart';
import 'package:smart_home/objects/appBar.dart';
import 'package:smart_home/objects/buttons.dart';
import 'package:smart_home/services/realtimeDatabaseService.dart';

//TODO: manuális és automatikus átállás

//LED csík színének beállításának oldala
class ColorPickerPage extends StatefulWidget {
  const ColorPickerPage({Key? key}) : super(key: key);

  @override
  _ColorPickerPageState createState() => _ColorPickerPageState();
}

class _ColorPickerPageState extends State<ColorPickerPage> {
  Color _pickerColor = Colors.red;
  int currBr = 0;
  bool lightIsOn = true;
  bool _isSwitched = true;
  Map<dynamic, dynamic>? data;
  bool pickerAbsorbed = false;
  bool pageAbsorbed = false;
  bool? autoOn;
  //ez a metódus változtat a színen, amit megjelenít a color picker, valamint menti a színt, és a beállított fényerőt
  //utóbbit fel is tölti realtime az adatbázisba, ezáltal a csúszkát használva folyamatosan változtatható
  void changeColor(Color color) {
    _pickerColor = color;
    // _brightness = color.alpha;
    realTimeDatabase().updateBrightness((color.alpha / 2.55).round());
  }

  //feltölti a színt az adatbázisba
  void sendData() async {
    await realTimeDatabase()
        .updateColor(_pickerColor.red, _pickerColor.green, _pickerColor.blue);
  }

  Future getAuto() async {
    await realTimeDatabase()
        .databaseReference
        .child('Control/LED control/Auto')
        .once()
        .then((DataSnapshot snapshot) => autoOn = snapshot.value);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAuto();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) => Scaffold(
        appBar: PreferredSize(
          child: appBar(
            leading: Padding(
              padding: EdgeInsets.only(left: constraints.maxWidth * 0.03),
              child: GestureDetector(
                child: Icon(
                  Icons.arrow_back_outlined,
                  color: MyColors.primaryBlack,
                  size: constraints.maxHeight * 0.04,
                ),
                onTap: () => Navigator.of(context).pop(),
              ),
            ),
            title: '',
          ),
          preferredSize: Size.fromHeight(constraints.maxHeight * 0.07),
        ),
        body:
            //itt elegendő un. future-t használni stream helyett, mivel nem kell folyamatos adatfolyamra számítani az adatbázisból
            FutureBuilder(
                future: realTimeDatabase()
                    .databaseReference
                    .child('/Control/LED control/')
                    .once(),
                builder: (BuildContext context,
                    AsyncSnapshot<DataSnapshot> snapshot) {
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
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding:
                                EdgeInsets.all(constraints.maxHeight * 0.02),
                            child: Title(
                                color: Colors.black,
                                child: Text(
                                  'Color Picker',
                                  style: TextStyle(
                                      fontSize: constraints.maxHeight * 0.04),
                                )),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: constraints.maxHeight * 0.02),
                          child: ColorPicker(
                            displayThumbColor: true,
                            pickerColor: _pickerColor,
                            onColorChanged: changeColor,
                            showLabel: false,
                            pickerAreaHeightPercent: 1,
                            colorPickerWidth: constraints.maxWidth * 0.75,
                            enableAlpha: true,
                            pickerAreaBorderRadius: BorderRadius.circular(
                                constraints.maxHeight * 0.03),
                          ),
                        ),
                        SendButton(
                          onPressed: () => sendData(),
                          constraints: constraints,
                        ),
                        Padding(
                          padding: EdgeInsets.all(constraints.maxHeight * 0.05),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                data!['Auto']
                                    ? 'Turn auto on'
                                    : 'Turn auto off',
                                style: TextStyle(
                                    fontSize: constraints.maxHeight * 0.03),
                              ),
                              Transform.scale(
                                scale: constraints.maxWidth * 0.0045,
                                child: Switch(
                                  activeColor: Colors.white,
                                  activeTrackColor: MyColors.primaryBlack,
                                  inactiveTrackColor: MyColors.secondGrey,
                                  value: autoOn!,
                                  onChanged: (bool value) {
                                    setState(() {
                                      autoOn = value;
                                    });
                                    realTimeDatabase().changeMode();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
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
