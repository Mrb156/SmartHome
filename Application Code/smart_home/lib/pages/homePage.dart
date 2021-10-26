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
  // Map<dynamic, dynamic> secEvents

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: realTimeDatabse()
          .databaseReference
          .child('Control/Security/Log')
          .onValue,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          secEvents.clear();
          DataSnapshot dataValues = snapshot.data.snapshot;
          List values = dataValues.value;
          values.forEach((value) {
            secEvents.add(value);
          });
          List secEventsRev = secEvents.reversed.toList();
          return Scaffold(body:
              LayoutBuilder(builder: (context, BoxConstraints constraints) {
            return Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                child: Column(
                  children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Hello, Barna!',
                          style: TextStyle(
                              color: Colors.blue[900],
                              fontSize: constraints.maxHeight * 0.1),
                        )),
                    ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: secEvents.length,
                        itemBuilder: (BuildContext context, int index) {
                          return AlertCard(date: secEventsRev[index]);
                        })
                  ],
                ),
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
