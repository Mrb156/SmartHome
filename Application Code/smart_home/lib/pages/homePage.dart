import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:smart_home/main.dart';
import 'package:smart_home/objects/appBar.dart';
import 'package:smart_home/objects/buttons.dart';
import 'package:smart_home/objects/cards.dart';
import 'package:smart_home/pages/blankPage.dart';
import 'package:smart_home/pages/colorPicker2.dart';
import 'package:smart_home/pages/home.dart';
import 'package:smart_home/services/localNotification.dart';
import 'package:smart_home/services/notification.dart';
import 'package:smart_home/services/realtimeDatabaseService.dart';

//ebben a fájlban található a főoldal, amin megjelennek a biztonsági értesítések
Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification!.title);
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List secEvents = [];
  bool secState = true;
  int currLengthOfEvents = 0;
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FirebaseMessaging messaging = FirebaseMessaging.instance;

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

    LocalNotificationService.initialize(context);
    FirebaseMessaging.onBackgroundMessage(backgroundHandler);

    FirebaseMessaging.instance.getInitialMessage().then((message) async {
      if (message != null) {
        // final routeFromMessage = message.data["route"];

        // Navigator.of(context).pushNamed(routeFromMessage);
      }
    });

    FirebaseMessaging.onMessage.listen((message) async {
      LocalNotificationService.display(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) async {});
  }

  @override
  Widget build(BuildContext context) {
    //stream-et használunk, hogy minden értesítés egyből a listában is megjelenjen
    //

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
                  appBar: PreferredSize(
                      child: appBar(),
                      preferredSize:
                          Size.fromHeight(constraints.maxHeight * 0.07)),
                  body: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: constraints.maxHeight * 0.05,
                            top: constraints.maxHeight * 0.01),
                        child: Row(
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
                              child: TurnOnOffButton(
                                  iconOn:
                                      const Icon(Icons.verified_user_outlined),
                                  iconOff:
                                      const Icon(Icons.privacy_tip_outlined),
                                  onPressed: () =>
                                      realTimeDatabase().turnSecOnOff(),
                                  iconIsOn: secState),
                            ),
                          ],
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
