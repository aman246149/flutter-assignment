import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class HomeRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> getOnlineUserNames() {
    try {
      return _firestore
          .collection('users')
          .where('status', isEqualTo: 'ONLINE')
          .snapshots();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> setUserStatusOnline() async {
    try {
      await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
        'status': 'ONLINE',
      });
    } catch (e) {
      print('Failed to set user status to ONLINE: $e');
      rethrow;
    }
  }

  Future<void> setUserStatusOffline() async {
    try {
      await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
        'status': 'OFFLINE',
      });
    } catch (e) {
      print('Failed to set user status to OFFLINE: $e');
      rethrow;
    }
  }

  Future<void> sendImageAndStartGame(
    File imageFile,
    String playerId,
  ) async {
    try {
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/$playerId/${DateTime.now().toString()}');

      firebase_storage.UploadTask uploadTask = ref.putFile(imageFile);

      final String imageUrl = await (await uploadTask).ref.getDownloadURL();

      await _firestore.collection('users').doc(playerId).update({
        'imageUrl': imageUrl,
        "battlewith": _auth.currentUser!.uid,
        "opponent": true,
        "chancesRemaining": 3,
      });
      await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
        'imageUrl': imageUrl,
        "battlewith": playerId,
        "imageCordinates": [],
      });
    } catch (e) {
      print('Failed to upload image and start game: $e');
      rethrow;
    }
  }

  //create a function to update cordinates in particular document id
  Future<void> updateCordinates(
      List<double> cordinates, String opponentPlayerId) async {
    try {
      await _firestore
          .collection('users')
          .doc(opponentPlayerId)
          .update({'imageCordinates': cordinates, "done": true});
    } catch (e) {
      print('Failed to update cordinates: $e');
      rethrow;
    }
  }

  Future<void> changeColor(String opponentPlayerId) async {
    try {
      await _firestore
          .collection('users')
          .doc(opponentPlayerId)
          .update({"done": false});
    } catch (e) {
      print('Failed to update cordinates: $e');
      rethrow;
    }
  }

  Future<void> updateChances(String opponentPlayerId) async {
    try {
      await _firestore
          .collection('users')
          .doc(opponentPlayerId)
          .update({"chancesRemaining": FieldValue.increment(-1)});
    } catch (e) {
      print('Failed to update cordinates: $e');
      rethrow;
    }
  }

  //create a function to reset document in
  // 'username': username,
  //   "status": "ONLINE",
  //   "userId": userCredential.user!.uid,
  //   "battlewith": "",
  // });
  //this state

  Future<void> resetGame(String opponentPlayerId) async {
    try {
      await _firestore.collection('users').doc(opponentPlayerId).update({
        "battlewith": "",
        "done": FieldValue.delete(),
        "imageCordinates": FieldValue.delete(),
        "opponent": FieldValue.delete(),
        "imageUrl": FieldValue.delete(),
      });

      await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
        "battlewith": "",
        "done": FieldValue.delete(),
        "imageCordinates": FieldValue.delete(),
        "opponent": FieldValue.delete(),
        "imageUrl": FieldValue.delete(),
      });
    } catch (e) {
      print('Failed to update cordinates: $e');
      rethrow;
    }
  }
}
