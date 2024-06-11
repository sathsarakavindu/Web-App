import 'package:cloud_firestore/cloud_firestore.dart';

class FetchingUserData {
  Future<List<Map<String, dynamic>>> fetchData() async {
    final firestore = FirebaseFirestore.instance;
    final collection = await firestore.collection('User').get();
    final data = collection.docs.map((doc) => doc.data()).toList();
    return data;
  }
}
