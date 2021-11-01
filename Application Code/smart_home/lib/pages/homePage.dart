import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smart_home/objects/buttons.dart';
import 'package:smart_home/objects/cards.dart';
import 'package:smart_home/pages/blankPage.dart';
import 'package:smart_home/pages/home.dart';
import 'package:smart_home/services/notification.dart';
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
    NotificationApi().init();
    listenNotifications();
  }

  void listenNotifications() {
    NotificationApi.onNotifications.stream.listen(onClickedNotification);
  }

  void onClickedNotification(String? payload) => Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => Blank()));

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
                        child: TurnOnOffButton(
                            iconOn: const Icon(Icons.verified_user_outlined),
                            iconOff: const Icon(Icons.privacy_tip_outlined),
                            onPressed: () => realTimeDatabase().turnSecOnOff(),
                            iconIsOn: secState),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    child: Text('noti'),
                    onPressed: () {
                      NotificationApi.showNotification(
                          id: 0,
                          title: 'Helo',
                          body: 'It\'s me',
                          payload: 'ez.mi');
                    },
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
