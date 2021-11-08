import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:smart_home/main.dart';
import 'package:smart_home/objects/appBar.dart';
import 'package:smart_home/objects/buttons.dart';
import 'package:smart_home/objects/cards.dart';
import 'package:smart_home/pages/blankPage.dart';
import 'package:smart_home/pages/colorPicker2.dart';
import 'package:smart_home/pages/home.dart';
// import 'package:smart_home/services/localNotification.dart';
import 'package:smart_home/services/realtimeDatabaseService.dart';

//ebben a fájlban található a főoldal, amin megjelennek a biztonsági értesítések

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List secEvents = [];
  bool secState = true;
  int currLengthOfEvents = 0;

  //ez a függvény kérdezi le az adatbázisból hogy be van-e kapcsolva, vagy nem
  //erre azért van szükség, hogy a bekapcsológomb megfelelően jelenjen meg megnyitáskor
  Future checkSecState() async {
    await realTimeDatabase()
        .databaseReference
        .child('Control/Security/On')
        .once()
        .then((DataSnapshot snapshot) {
      secState = snapshot.value;
    });
  }

  //ez a metódus fut le minden megnyitáskor
  @override
  void initState() {
    super.initState();
    checkSecState();
  }

  @override
  Widget build(BuildContext context) {
    //stream-et használunk, hogy minden értesítés egyből a listában is megjelenjen

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

          currLengthOfEvents = secEvents.length;

          return LayoutBuilder(
              builder: (context, BoxConstraints constraints) => Scaffold(
                      body: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(constraints.maxHeight * 0.02),
                        child: Text(
                          'Biztonsági értesítések',
                          style:
                              TextStyle(fontSize: constraints.maxHeight * 0.03),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: secEvents.length,
                            itemBuilder: (BuildContext context, int index) {
                              return AlertCard(date: secEventsRev[index]);
                            }),
                      )
                    ],
                  )));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}