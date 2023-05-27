import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dainik_ujala/Backend/models.dart';
import 'package:dainik_ujala/Backend/sqlite_services.dart';

final FirebaseFirestore store = FirebaseFirestore.instance;
final advtCollection = store.collection('advts');

class Promotions {
  Promotions() {
    log("Performing something in Promotions");
  }
  onOpened({required String id}) async {
    await advtCollection.doc(id).update({'open': FieldValue.increment(1)});
  }

  onIgnored({required String id}) async {
    await advtCollection.doc(id).update({'close': FieldValue.increment(1)});
  }

  Future<List<AdvtModel>> getPromotions() async {
    List<AdvtModel> data = [];
    QuerySnapshot<Map<String, dynamic>> d = await advtCollection.get();
    var l = d.docs;
    List<AdvtModel> temp = List.generate(
      l.length,
      (index) => AdvtModel.fromMap(
        l.elementAt(index).data(),
      ),
    );

    for (var e in temp) {
      bool h = await SqliteServices().chechAdvt(id: e.id);

      if (h) {
        data.add(e);
      }
    }

    return data;
  }
}
