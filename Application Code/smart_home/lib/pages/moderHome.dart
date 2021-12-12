// ignore_for_file: file_names

import 'package:alan_voice/alan_voice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_home/colors.dart';
import 'package:smart_home/objects/appBar.dart';
import 'package:smart_home/pages/control.dart';
import 'package:smart_home/pages/heating.dart';
import 'package:smart_home/pages/homePage.dart';
import 'package:tabnavigator/tabnavigator.dart';

class MaterialHome extends StatefulWidget {
  const MaterialHome({Key? key}) : super(key: key);

  @override
  _MaterialHomeState createState() => _MaterialHomeState();
}

class _MaterialHomeState extends State<MaterialHome> {
  bool lampIsOn = true;
  _MaterialHomeState() {
    AlanVoice.addButton(
        "710278fdcf1b65a4fe5a195b1209b1322e956eca572e1d8b807a3e2338fdd0dc/stage",
        buttonAlign: AlanVoice.BUTTON_ALIGN_RIGHT);
    AlanVoice.callbacks.add((command) => _handleCommand(command.data));
  }

  _handleCommand(Map<String, dynamic> response) {
    switch (response["command"]) {
      case "command_1":
        print('I hear you');
        break;
      case "command_2":
        //do something according to command_2
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, BoxConstraints constraints) {
        return DefaultTabController(
          length: 2,
          child: Container(
            decoration: linearDec,
            child: Scaffold(
              // backgroundColor: Colors.transparent,
              appBar: PreferredSize(
                child: appBar(
                  tabBar: TabBar(
                    labelStyle:
                        TextStyle(fontSize: constraints.maxHeight * 0.025),
                    indicatorColor: Colors.transparent,
                    indicatorWeight: 0.1,
                    labelColor: MyColors.primaryBlack,
                    unselectedLabelColor: Colors.grey,
                    tabs: const [
                      Tab(
                        text: 'Control',
                      ),
                      Tab(
                        text: 'Security',
                      )
                    ],
                  ),
                  title: 'Hello, Barna!',
                ),
                preferredSize: Size.fromHeight(constraints.maxHeight * 0.15),
              ),
              body: Stack(children: const [
                // Positioned(
                //     bottom: 200,
                //     right: -400,
                //     child: Image(image: AssetImage('assets/cloudsunny.png'))),
                TabBarView(
                  children: [
                    Control(),
                    AlertPage(),
                  ],
                ),
              ]),
            ),
          ),
        );
      },
    );
  }
}
