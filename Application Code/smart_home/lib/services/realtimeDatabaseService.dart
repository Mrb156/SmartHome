import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class realTimeDatabse {
  final databaseReference = FirebaseDatabase.instance.reference();

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
}
