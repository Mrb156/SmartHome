// ignore_for_file: file_names

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:smart_home/main.dart';
import 'package:smart_home/objects/buttons.dart';
import 'package:smart_home/objects/cards.dart';
import 'package:smart_home/pages/colorPicker2.dart';
// import 'package:smart_home/services/localNotification.dart';
import 'package:smart_home/services/realtimeDatabaseService.dart';
import 'package:intl/intl.dart';

class AlertPage extends StatefulWidget {
  const AlertPage({Key? key}) : super(key: key);

  @override
  _AlertPageState createState() => _AlertPageState();
}

class _AlertPageState extends State<AlertPage> {
  List secEvents = [];
  bool secState = true;
  int currLengthOfEvents = 0;
  bool currMotionDetect = true;
  int currLogIndex = 0;

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

  Future checkNotiState() async {
    await realTimeDatabase()
        .databaseReference
        .child('notification/status')
        .once()
        .then((DataSnapshot snapshot) {
      currMotionDetect = snapshot.value;
    });
  }

  //ez a metódus fut le minden megnyitáskor
  @override
  void initState() {
    super.initState();
    checkSecState();
    checkNotiState();
    currLogIndex = currLengthOfEvents;
    Intl.defaultLocale = 'hu_HU';
    initializeDateFormatting('hu');
  }

  @override
  Widget build(BuildContext context) {
    //stream-et használunk, hogy minden értesítés egyből a listában is megjelenjen
    // initializeDateFormatting('hu');

    return StreamBuilder(
        stream: realTimeDatabase()
            .databaseReference
            .child('notification/status')
            .onValue,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData &&
              snapshot.data!.snapshot.value != currMotionDetect) {
            currMotionDetect = snapshot.data!.snapshot.value;
            realTimeDatabase().addEvent(
                DateFormat.yMMMMEEEEd().add_Hm().format(DateTime.now()),
                currLogIndex);
            currLogIndex++;
          }
          return LayoutBuilder(
              builder: (context, BoxConstraints constraints) => Stack(
                    children: [
                      Positioned(
                          bottom: 200,
                          left: -213,
                          child: Image(
                              image: AssetImage('assets/cloudsunny.png'))),
                      Scaffold(
                          backgroundColor: Colors.transparent,
                          body: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(
                                    constraints.maxHeight * 0.02),
                                child: Text(
                                  'Biztonsági értesítések',
                                  style: TextStyle(
                                      fontSize: constraints.maxHeight * 0.03),
                                ),
                              ),
                              Expanded(
                                child: StreamBuilder<Object>(
                                    stream: realTimeDatabase()
                                        .databaseReference
                                        .child('Control/Security/Log')
                                        .onValue,
                                    builder: (context, AsyncSnapshot snapshot) {
                                      if (snapshot.hasData) {
                                        secEvents.clear();
                                        DataSnapshot dataValues =
                                            snapshot.data.snapshot;
                                        List values = dataValues.value;
                                        for (var value in values) {
                                          secEvents.add(value);
                                        }
                                        List secEventsRev =
                                            secEvents.reversed.toList();

                                        currLengthOfEvents = secEvents.length;

                                        return ListView.builder(
                                            physics: BouncingScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: secEvents.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return AlertCard(
                                                  date: secEventsRev[index]);
                                            });
                                      } else {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      }
                                    }),
                              )
                            ],
                          )),
                    ],
                  ));
        });
  }
}
