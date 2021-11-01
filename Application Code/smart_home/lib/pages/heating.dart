import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:flutter_circular_slider/flutter_circular_slider.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTemp();
  }

  @override
  Widget build(BuildContext context) {
    //stream-et haszálunk, hogy állandóan változó hőmérséklet megjelenjen
    return Scaffold(body: LayoutBuilder(
      builder: (context, BoxConstraints constraints) {
        return StreamBuilder(
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
                      Padding(
                        padding: EdgeInsets.all(constraints.maxHeight * 0.04),
                        child: Title(
                            color: Colors.black,
                            child: Text(
                              'Hőmérsékélet vezérlés',
                              style: TextStyle(
                                  fontSize: constraints.maxHeight * 0.04),
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: constraints.maxHeight * 0.02),
                        child: SleekCircularSlider(
                            appearance: CircularSliderAppearance(
                                angleRange: 360,
                                size: constraints.maxWidth * 0.7,
                                infoProperties:
                                    InfoProperties(modifier: (double value) {
                                  final roundedValue = value.toStringAsFixed(1);
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
                        style:
                            TextStyle(fontSize: constraints.maxHeight * 0.03),
                      )
                    ],
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            });
      },
    ));
  }
}
