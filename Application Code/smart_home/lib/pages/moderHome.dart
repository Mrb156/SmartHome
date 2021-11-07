import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, BoxConstraints constraints) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: PreferredSize(
              child: appBar(
                tabBar: TabBar(
                  labelStyle:
                      TextStyle(fontSize: constraints.maxHeight * 0.025),
                  indicatorColor: Colors.transparent,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  tabs: [
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
            body: const TabBarView(
              children: [
                Control(),
                HomePage(),
              ],
            ),
          ),
        );
      },
    );
  }
}
