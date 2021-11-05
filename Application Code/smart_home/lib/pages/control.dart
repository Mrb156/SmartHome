import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_home/objects/cards.dart';
import 'package:smart_home/pages/colorPicker2.dart';
import 'package:smart_home/pages/heating.dart';

class Control extends StatefulWidget {
  const Control({Key? key}) : super(key: key);

  @override
  _ControlState createState() => _ControlState();
}

class _ControlState extends State<Control> {
  bool lampIsOn = true;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, BoxConstraints constraints) {
        return Scaffold(
          body: Row(
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: constraints.maxHeight * 0.05,
                      top: constraints.maxHeight * 0.03),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ControlCard(
                        only: false,
                        height: constraints.minHeight * 0.25,
                        width: constraints.minWidth * 0.6,
                        constraints: constraints,
                        title: 'Lámpa',
                        switchValue: lampIsOn,
                        primaryProp: 'Szín',
                        primaryValue: '#d8d8dd8',
                        secondaryValue: '100%',
                        secondaryProp: 'Brightness',
                        onSwitchChange: (bool value) {
                          setState(() {
                            lampIsOn = value;
                          });
                        },
                        wichPageToOpen: ColorPickerPage(),
                      ),
                      ControlCard(
                        only: false,
                        height: constraints.minHeight * 0.25,
                        width: constraints.minWidth * 0.6,
                        constraints: constraints,
                        title: 'Termosztát',
                        switchValue: true,
                        primaryProp: 'Temp',
                        primaryValue: '24°',
                        secondaryValue: '50%',
                        secondaryProp: 'Humidity',
                        onSwitchChange: () {},
                        wichPageToOpen: Heating(),
                      ),
                      ControlCard(
                        only: true,
                        height: constraints.minHeight * 0.15,
                        width: constraints.minWidth * 0.6,
                        constraints: constraints,
                        title: 'Biztonsági rendszer',
                        switchValue: true,
                        primaryProp: '',
                        primaryValue: '',
                        secondaryValue: '',
                        secondaryProp: '',
                        onSwitchChange: () {},
                      ),
                      SizedBox(
                        height: constraints.maxHeight * 0.01,
                      )
                    ],
                  ),
                ),
              ),
              Expanded(child: Container())
            ],
          ),
        );
      },
    );
  }
}
