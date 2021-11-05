import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:smart_home/colors.dart';
import 'package:smart_home/objects/appBar.dart';
import 'package:smart_home/objects/buttons.dart';
import 'package:smart_home/services/realtimeDatabaseService.dart';
import 'dart:math' as math;

//ebben a fájlban található a termosztát vezérlő oldala
class Heating extends StatefulWidget {
  const Heating({Key? key}) : super(key: key);

  @override
  _HeatingState createState() => _HeatingState();
}

class _HeatingState extends State<Heating> {
  double currTemp = 0;
  double temp = 0;
  bool? tempState;
  //lekérjük a legutóbb beállított kívánt hőmérsékletet
  //
  Future getTemp() async {
    await realTimeDatabase()
        .databaseReference
        .child('Control/Heating/Temp')
        .once()
        .then((DataSnapshot snapshot) {
      temp = (snapshot.value).toDouble();
    });
  }

  Future checkTempState() async {
    await realTimeDatabase()
        .databaseReference
        .child('Control/Heating/On')
        .once()
        .then((DataSnapshot snapshot) {
      tempState = snapshot.value;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTemp();
    checkTempState();
  }

  @override
  Widget build(BuildContext context) {
    //stream-et haszálunk, hogy állandóan változó hőmérséklet megjelenjen
    return LayoutBuilder(
        builder: (context, BoxConstraints constraints) => Scaffold(
              // backgroundColor: Colors.white,
              appBar: PreferredSize(
                child: appBar(
                  title: '',
                ),
                preferredSize: Size.fromHeight(constraints.maxHeight * 0.07),
              ),
              body: StreamBuilder(
                  stream: realTimeDatabase()
                      .databaseReference
                      .child('Control/Heating/currTemp')
                      .onValue,
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      currTemp = snapshot.data.snapshot.value;
                      print(currTemp);
                      return Center(
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.all(
                                    constraints.maxHeight * 0.02),
                                child: Title(
                                    color: Colors.black,
                                    child: Text(
                                      'Hőmérsékélet',
                                      style: TextStyle(
                                          fontSize:
                                              constraints.maxHeight * 0.04),
                                    )),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: constraints.maxHeight * 0.02),
                              child: SleekCircularSlider(
                                  appearance: CircularSliderAppearance(
                                      customWidths: CustomSliderWidths(
                                          trackWidth:
                                              constraints.maxWidth * 0.002,
                                          progressBarWidth:
                                              constraints.maxWidth * 0.014,
                                          handlerSize:
                                              constraints.maxWidth * 0.03),
                                      customColors: CustomSliderColors(
                                          trackColor: MyColors.middleGrey,
                                          progressBarColor:
                                              MyColors.primaryBlack,
                                          dotColor: MyColors.primaryBlack,
                                          hideShadow: true),
                                      angleRange: 360,
                                      size: constraints.maxWidth * 0.7,
                                      infoProperties: InfoProperties(
                                          modifier: (double value) {
                                        final roundedValue =
                                            value.toStringAsFixed(1);
                                        return '$roundedValue °C';
                                      })),
                                  min: 0,
                                  max: 40,
                                  initialValue: temp,
                                  onChange: (double value) {
                                    realTimeDatabase().updateTemp(
                                        double.parse(value.toStringAsFixed(1)));
                                  }),
                            ),
                            Text('Jelenlegi hőmérséklet'),
                            Text(
                              '$currTemp',
                              style: TextStyle(
                                  fontSize: constraints.maxHeight * 0.03),
                            ),
                            TurnOnOffButton(
                              iconIsOn: tempState == true ? false : true,
                              iconOn: Icon(Icons.thermostat_outlined),
                              iconOff: Icon(Icons.close_outlined),
                              onPressed: () =>
                                  realTimeDatabase().turnTempOnOff(),
                            )
                          ],
                        ),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            ));
  }
}
