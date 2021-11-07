// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class realTimeDatabase {
  //eltárolunk egy referenciát, mely a megfelelő helyet hivatkozza a Firebase-en
  final databaseReference = FirebaseDatabase.instance.reference();
  //fügvények melyekkel elérjük az adatbázist

  //frissíti a LED csík színét
  Future updateColor(int _red, int _green, int _blue) async {
    return await databaseReference
        .child("Control/LED control/Colors")
        .update({'Red': _red, 'Green': _green, 'Blue': _blue});
  }

  //frissíti a fényerőt a LED-en
  Future updateBrightness(int br) async {
    return await databaseReference
        .child("Control/LED control")
        .update({'Brightness': br});
  }

  //lekérdezi a fényerőt, melyet a fényérzékelő küld az adatbázisba
  int? br;
  Future getBrightness() async {
    await databaseReference
        .child('Control/LED control/Brightness')
        .once()
        .then((DataSnapshot snapshot) {
      br = snapshot.value;
    });
  }

  //be van-e kapcsolva az automatika
  bool? autoOn;
  Future getAuto() async {
    await databaseReference
        .child('Control/LED control/Auto')
        .once()
        .then((DataSnapshot snapshot) => autoOn = snapshot.value);
  }

  //módváltás auto => manuális
  Future changeMode() async {
    await getAuto();
    await databaseReference
        .child('Control/LED control')
        .update({'Auto': !autoOn!});
  }

  //ki, vagy bekapcsolja a LED-et szimplán a fényerő állításával
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

  //tesztelés szempontjából hozzáad egy eseményt a biztonsági részhez az adatbázisban
  Future addEvent(String time, int currlogIndex) async {
    await databaseReference
        .child('Control/Security/Log')
        .update({'${currlogIndex}': time});
  }

  //lekéri, hogy be van-e kapcsolva a biztonsági rendszert
  bool? secState;
  Future checkSecState() async {
    await databaseReference
        .child('Control/Security/On')
        .once()
        .then((DataSnapshot snapshot) {
      secState = snapshot.value;
    });
  }

  //ki-be kapcsolja a biztonsági rendszert
  Future turnSecOnOff() async {
    await checkSecState();
    await databaseReference
        .child('Control/Security/')
        .update({'On': !secState!});
  }

  //be van-e kapcsolva a termosztát
  bool? tempStateBool;
  Future checkTempState() async {
    await realTimeDatabase()
        .databaseReference
        .child('Control/Heating/On')
        .once()
        .then((DataSnapshot snapshot) {
      tempStateBool = snapshot.value;
    });
  }

  //ki-be kapcsolja a termosztátot
  Future turnTempOnOff() async {
    await checkTempState();
    await databaseReference
        .child('Control/Heating/')
        .update({'On': !tempStateBool!});
  }

  //frissíti a kívánt hőmérsékletet
  Future updateTemp(double temp) async {
    await databaseReference.child('Control/Heating/').update({'Temp': temp});
  }
}
