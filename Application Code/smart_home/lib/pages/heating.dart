import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:smart_home/colors.dart';
import 'package:smart_home/objects/appBar.dart';
import 'package:smart_home/objects/buttons.dart';
import 'package:smart_home/objects/cards.dart';
import 'package:smart_home/services/realtimeDatabaseService.dart';
import 'dart:math' as math;

//ebben a fájlban található a termosztát vezérlő oldala
class Heating extends StatefulWidget {
  const Heating({Key? key}) : super(key: key);

  @override
  _HeatingState createState() => _HeatingState();
}

class _HeatingState extends State<Heating> {
  double temp = 0;
  bool? tempState;
  Map<dynamic, dynamic>? tempData;

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
              // backgroundColor: Colors.transparent,
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
              body: StreamBuilder(
                  stream: realTimeDatabase()
                      .databaseReference
                      .child('Control/Heating/')
                      .onValue,
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      tempData = snapshot.data.snapshot.value;
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
                            AbsorbPointer(
                              absorbing: !tempData!['On'],
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: constraints.maxHeight * 0.02),
                                child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Center(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey,
                                                  offset:
                                                      Offset(0.0, 10), //(x,y)
                                                  blurRadius: 9,
                                                ),
                                                BoxShadow(
                                                  color: Colors.grey.shade100,
                                                  offset:
                                                      Offset(-10, 0), //(x,y)
                                                  blurRadius: 9,
                                                ),
                                              ],
                                              color: MyColors.background,
                                              shape: BoxShape.circle),
                                          height: constraints.maxHeight * 0.27,
                                        ),
                                      ),
                                      Center(
                                        child: SleekCircularSlider(
                                            appearance:
                                                CircularSliderAppearance(
                                                    customWidths: CustomSliderWidths(
                                                        trackWidth: constraints
                                                                .maxWidth *
                                                            0.002,
                                                        progressBarWidth:
                                                            constraints
                                                                    .maxWidth *
                                                                0.014,
                                                        handlerSize: constraints
                                                                .maxWidth *
                                                            0.03),
                                                    customColors: CustomSliderColors(
                                                        trackColor:
                                                            MyColors.middleGrey,
                                                        progressBarColor:
                                                            MyColors
                                                                .primaryBlack,
                                                        dotColor: MyColors
                                                            .primaryBlack,
                                                        hideShadow: true),
                                                    angleRange: 360,
                                                    size: constraints.maxWidth *
                                                        0.7,
                                                    infoProperties:
                                                        InfoProperties(modifier:
                                                            (double value) {
                                                      final roundedValue = value
                                                          .toStringAsFixed(1);
                                                      return '$roundedValue °C';
                                                    })),
                                            min: 0,
                                            max: 40,
                                            initialValue: temp,
                                            onChange: (double value) {
                                              realTimeDatabase().updateTemp(
                                                  double.parse(value
                                                      .toStringAsFixed(1)));
                                            }),
                                      )
                                    ]),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                TempPropCard(
                                    constraints: constraints,
                                    dataType: 'hőmérséklet',
                                    data: '${tempData!['currTemp']}°C'),
                                TempPropCard(
                                    constraints: constraints,
                                    dataType: 'páratartalom',
                                    data: '${tempData!['Humidity']}%')
                              ],
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.all(constraints.maxHeight * 0.05),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    tempState == false ? 'Turn on' : 'Turn off',
                                    style: TextStyle(
                                        fontSize: constraints.maxHeight * 0.03),
                                  ),
                                  Transform.scale(
                                    scale: constraints.maxWidth * 0.0045,
                                    child: Switch(
                                      activeColor: Colors.white,
                                      activeTrackColor: MyColors.primaryBlack,
                                      inactiveTrackColor: MyColors.secondGrey,
                                      value: tempData!['On'],
                                      onChanged: (bool value) {
                                        setState(() {
                                          tempState = value;
                                        });
                                        realTimeDatabase().turnTempOnOff();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // SizedBox(
                            //   height: constraints.maxHeight * 0.06,
                            // )
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
