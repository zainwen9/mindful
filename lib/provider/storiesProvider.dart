import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StoriesProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> getStoriesStream() {
    return _firestore
        .collection('Stories')
        .orderBy('time', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  Stream<Map<String, dynamic>?> getFirstStoryStream() {
    return _firestore
        .collection('Stories')
        .orderBy('time', descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.data();
      } else {
        return null;
      }
    });
  }
}
