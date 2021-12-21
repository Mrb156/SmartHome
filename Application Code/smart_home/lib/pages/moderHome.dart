// ignore_for_file: file_names
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
                  title: 'Hello!',
                ),
                preferredSize: Size.fromHeight(constraints.maxHeight * 0.15),
              ),
              body: Stack(children: [
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
