import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../widgets/animatedNavigator.dart';
import '../widgets/appSnackBar.dart';
import '../widgets/customAlertDialogue.dart';


class FirebaseGeneralServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Saves data to Firebase Firestore.
  ///
  /// - `collectionPath`: The path of the collection where the document should be saved.
  /// - `data`: The data to be saved as a `Map<String, dynamic>`.
  /// - `documentId`: The document ID. If null, an auto-generated ID will be used.
  Future<void> saveData(
      {required String collectionPath,
        required Map<String, dynamic> data,
        String? documentId}) async {
    try {
      DocumentReference docRef =
      _firestore.collection(collectionPath).doc(documentId);
      await docRef.set(data);
      debugPrint('Data saved successfully with ID: ${docRef.id}');
    } catch (error) {
      _handleError(error);
    }
  }

  Future<void> saveWinlossData(
      {required Map<String, dynamic> data,
        String? documentId,
        String? betID}) async {
    try {
      QuickAlert.show(
          type: QuickAlertType.loading,
          headerBackgroundColor: Colors.white,
          confirmBtnColor: Colors.black,
          buttonFunction: () {
            //  AppNavigator.to(const TermOfUseScreen());
          },
          title: "Loading...");
      DocumentReference docRef = _firestore
          .collection("Users")
          .doc(documentId)
          .collection("WinLoss")
          .doc(betID
        //getdateWithMoth()
      );
      await docRef.set(data);
      debugPrint('Data saved successfully with ID: ${docRef.id}');
      AppNavigator.off();
    } catch (error) {
      _handleError(error);
    }
  }

  Future<List<Map<String, dynamic>>> getWinLossList(String documentId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection("Users")
          .doc(documentId)
          .collection("WinLoss")
          .get();

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (error) {
      _handleError(error);
      return [];
    }
  }

  /// Retrieves data from Firebase Firestore.
  ///
  /// - `collectionPath`: The path of the collection from which the document should be retrieved.
  /// - `documentId`: The ID of the document to retrieve.
  ///
  /// Returns the data as a `Map<String, dynamic>` if found, or `null` if not found.
  Future<Map<String, dynamic>?> getData(
      String collectionPath, String documentId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
      await _firestore.collection(collectionPath).doc(documentId).get();

      if (snapshot.exists && snapshot.data() != null) {
        return snapshot.data();
      } else {
        debugPrint('Document not found.');
        return null;
      }
    } catch (error) {
      _handleError(error);
      return null;
    }
  }

  /// Deletes a document from Firebase Firestore by its document ID.
  ///
  /// - `collectionPath`: The path of the collection where the document is located.
  /// - `documentId`: The ID of the document to delete.
  Future<void> deleteData(String collectionPath, String documentId) async {
    try {
      await _firestore.collection(collectionPath).doc(documentId).delete();
      debugPrint('Document deleted successfully.');
    } catch (error) {
      _handleError(error);
    }
  }

  /// Updates an existing document in Firebase Firestore by its document ID.
  ///
  /// - `collectionPath`: The path of the collection where the document is located.
  /// - `documentId`: The ID of the document to update.
  /// - `data`: A map of the data to update.
  Future<void> updateData(String collectionPath, String documentId,
      Map<String, dynamic> data) async {
    QuickAlert.show(
        type: QuickAlertType.loading,
        headerBackgroundColor: Colors.white,
        confirmBtnColor: Colors.black,
        buttonFunction: () {
          //  AppNavigator.to(const TermOfUseScreen());
        },
        title: "Loading...");
    try {
      await _firestore.collection(collectionPath).doc(documentId).update(data);
      debugPrint('Data updated successfully.');
    } catch (error) {
      _handleError(error);
    }
    AppNavigator.off();
  }

  /// Handles errors during Firebase operations.
  void _handleError(dynamic error) {
    String errorMessage = 'An error occurred: $error';
    debugPrint(errorMessage);
    // Implement your snackbar or dialog to show the error message
    snaki(msg: errorMessage);
  }
}
