// import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class realTimeDatabase {
  final databaseReference = FirebaseDatabase.instance.reference();
  //functions for the LED
  int? br;

  Future updateColor(int _red, int _green, int _blue) async {
    return await databaseReference
        .child("Control/LED control/Colors")
        .update({'Red': _red, 'Green': _green, 'Blue': _blue});
  }

  Future updateBrightness(int br) async {
    return await databaseReference
        .child("Control/LED control")
        .update({'Brightness': br});
  }

  Future getBrightness() async {
    await databaseReference
        .child('Control/LED control/Brightness')
        .once()
        .then((DataSnapshot snapshot) {
      br = snapshot.value;
    });
  }

  Future turnLightOnOff() async {
    await getBrightness();
    if (br! != 0) {
      return await databaseReference
          .child("Control/LED control")
          .update({'Brightness': 0});
    } else if (br! == 0) {
      return await databaseReference
          .child("Control/LED control")
          .update({'Brightness': 100});
    }
  }

  //functions for security
  bool? secState;
  Future addEvent(String time, int currlogIndex) async {
    await databaseReference
        .child('Control/Security/Log')
        .update({'${currlogIndex}': time});
  }

  Future checkSecState() async {
    await databaseReference
        .child('Control/Security/On')
        .once()
        .then((DataSnapshot snapshot) {
      secState = snapshot.value;
    });
  }

  Future turnSecOnOff() async {
    await checkSecState();

    await databaseReference
        .child('Control/Security/')
        .update({'On': !secState!});
  }

  //functions for heating

  Future updateTemp(double temp) async {
    await databaseReference.child('Control/Heating/').update({'Temp': temp});
  }
}
