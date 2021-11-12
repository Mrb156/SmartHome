import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_home/objects/cards.dart';
import 'package:smart_home/pages/colorPicker2.dart';
import 'package:smart_home/pages/heating.dart';
import 'package:smart_home/services/realtimeDatabaseService.dart';

class Control extends StatefulWidget {
  const Control({Key? key}) : super(key: key);

  @override
  _ControlState createState() => _ControlState();
}

class _ControlState extends State<Control> {
  Color? color;
  Map<dynamic, dynamic>? colorData;
  Map<dynamic, dynamic>? tempData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // checkTempState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, BoxConstraints constraints) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Row(
            children: [
              Expanded(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: constraints.maxHeight * 0.05,
                      top: constraints.maxHeight * 0.03),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      StreamBuilder(
                          stream: realTimeDatabase()
                              .databaseReference
                              .child('Control/LED control/')
                              .onValue,
                          builder: (context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              colorData = snapshot.data.snapshot.value;
                              color = Color.fromARGB(
                                (colorData!['Brightness'] * 2.55).round(),
                                (colorData!['Colors']['Red']),
                                (colorData!['Colors']['Green']),
                                (colorData!['Colors']['Blue']),
                              );
                              return ControlCard(
                                only: false,
                                height: constraints.minHeight * 0.25,
                                width: constraints.minWidth * 0.6,
                                constraints: constraints,
                                title: 'Lámpa',
                                switchValue: color!.alpha == 0 ? false : true,
                                primaryProp: 'Szín',
                                primaryValue: Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle, color: color),
                                  height: constraints.maxHeight * 0.03,
                                ),
                                secondaryProp: 'Brightness',
                                secondaryValue: '${colorData!['Brightness']}%',
                                onSwitchChange: () =>
                                    realTimeDatabase().turnLightOnOff(),
                                wichPageToOpen: ColorPickerPage(),
                              );
                            } else {
                              return CircularProgressIndicator();
                            }
                          }),
                      StreamBuilder(
                          stream: realTimeDatabase()
                              .databaseReference
                              .child('Control/Heating/')
                              .onValue,
                          builder: (context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              tempData = snapshot.data.snapshot.value;
                              return ControlCard(
                                only: false,
                                height: constraints.minHeight * 0.25,
                                width: constraints.minWidth * 0.6,
                                constraints: constraints,
                                title: 'Termosztát',
                                switchValue: tempData!['On'],
                                primaryProp: 'Temp',
                                primaryValue: Text('${tempData!['currTemp']}°'),
                                secondaryValue: '${tempData!['Humidity']}%',
                                secondaryProp: 'Humidity',
                                onSwitchChange: () =>
                                    realTimeDatabase().turnTempOnOff(),
                                wichPageToOpen: Heating(),
                              );
                            } else {
                              return CircularProgressIndicator();
                            }
                          }),
                      ControlCard(
                        only: true,
                        height: constraints.minHeight * 0.15,
                        width: constraints.minWidth * 0.6,
                        constraints: constraints,
                        title: 'Biztonsági rendszer',
                        switchValue: true,
                        primaryProp: '',
                        primaryValue: Text(''),
                        secondaryValue: '',
                        secondaryProp: '',
                        onSwitchChange: () => realTimeDatabase().turnSecOnOff(),
                      ),
                      SizedBox(
                        height: constraints.maxHeight * 0.01,
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                  child: Image(
                image: AssetImage('assets/cloudsunny.png'),
              ))
            ],
          ),
        );
      },
    );
  }
}
