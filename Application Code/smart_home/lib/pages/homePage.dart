import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smart_home/objects/buttons.dart';
import 'package:smart_home/objects/cards.dart';
import 'package:smart_home/services/realtimeDatabaseService.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List secEvents = [];
  bool secState = true;

  Future checkSecState() async {
    await realTimeDatabase()
        .databaseReference
        .child('Control/Security/On')
        .once()
        .then((DataSnapshot snapshot) {
      secState = snapshot.value;
    });
  }

  @override
  void initState() {
    super.initState();
    checkSecState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: realTimeDatabase()
          .databaseReference
          .child('Control/Security/Log')
          .onValue,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          secEvents.clear();
          DataSnapshot dataValues = snapshot.data.snapshot;
          List values = dataValues.value;
          for (var value in values) {
            secEvents.add(value);
          }
          List secEventsRev = secEvents.reversed.toList();
          return Scaffold(body:
              LayoutBuilder(builder: (context, BoxConstraints constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              child: Column(
                children: [
                  Row(
                    children: [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Hello, Barna!',
                            style: TextStyle(
                                color: Colors.blue[900],
                                fontSize: constraints.maxWidth * 0.1),
                          )),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: constraints.maxWidth * 0.05),
                        child: SecOnOffButton(
                            onPressed: () => realTimeDatabase().turnSecOnOff(),
                            iconIsOn: secState),
                      )
                    ],
                  ),
                  ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: secEvents.length,
                      itemBuilder: (BuildContext context, int index) {
                        return AlertCard(date: secEventsRev[index]);
                      })
                ],
              ),
            );
          }));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
