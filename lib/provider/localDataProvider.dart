import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/local_storage/lcal_data.dart';

class LocalDataProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? localData;
  List<QueryDocumentSnapshot<Map<String, dynamic>>> buddies = [];
  getdataData() async {
    localData = await LocalStorage.getMap('userData');
    notifyListeners();
  }

  Future<void> getBudies() async {
    String currentUserID = localData!['uid'];
    String currentUserCountry = localData!['location']['country'];

    QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection("Users")
        .where("location.country", isEqualTo: currentUserCountry)
        .where("isOnline", isEqualTo: "Online")
        .get();

    // Filter out the current user
    buddies = snapshot.docs.where((doc) => doc.id != currentUserID).toList();

    // Example: print buddy names
    if (buddies.isEmpty) {
      print("Not found");
    }
    for (var doc in buddies) {
      print(doc.data()['name']); // or whatever field you want to access
    }
  }
}
