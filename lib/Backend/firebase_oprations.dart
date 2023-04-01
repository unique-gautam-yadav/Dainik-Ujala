import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dainik_ujala/Backend/models.dart';

final FirebaseFirestore store = FirebaseFirestore.instance;
final mediaCollection = store.collection('posts');

class FirebaseOperations {
  static Future<List<MediaModel>> getAllPosts({int times = 1}) async {
    QuerySnapshot<Map<String, dynamic>> d =
        await mediaCollection.orderBy('timeStamp').limit(20 * times).get();
    return List.generate(d.docs.length, (index) {
      return MediaModel.fromMap(d.docs.elementAt(index).data());
    });
  }
}
