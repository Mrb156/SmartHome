import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smart_home/objects/buttons.dart';
import 'package:smart_home/services/realtimeDatabaseService.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List secEvents = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
      stream: realTimeDatabse()
          .databaseReference
          .child('Control/Security/Log')
          .onValue,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          DataSnapshot dataValues = snapshot.data.snapshot;
          Map<dynamic, dynamic> values = dataValues.value;
          values.forEach((key, values) {
            secEvents.add(values);
          });
          return Column(
            children: [
              AddEventButton(),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: secEvents.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(secEvents[index].toString()),
                      ),
                    );
                  })
            ],
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    ));
  }
}
