import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore store = FirebaseFirestore.instance;
final mediaCollection = store.collection('posts');

class FirebaseOperations {
  static getAllPosts() {}
}
