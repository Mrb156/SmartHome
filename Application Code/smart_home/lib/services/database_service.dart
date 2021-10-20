import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  CollectionReference controlCollection =
      FirebaseFirestore.instance.collection('Control');

  Future updateData(bool _on) async {
    return await controlCollection.doc('Security').update({'On': _on});
  }

  Future updateColor(int _red, int _green, int _blue) async {
    return await controlCollection.doc('LED control').update({
      'Colors.Red': _red,
      'Colors.Green': _green,
      'Colors.Blue': _blue,
    });
  }
}
