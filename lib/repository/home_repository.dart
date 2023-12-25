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

     //create a new collection called GameLobby and add data in it and store that document reference in my both players

    DocumentReference doc=  await  _firestore.collection("gameLobby").add({

            "imageUrl": imageUrl,
            "position": [1.2,1.2],
            "opponentPlayerId": playerId,
            "myplayerId": _auth.currentUser!.uid,
            "challengerId": _auth.currentUser!.uid,

      });

      await  _firestore.collection("users").doc(_auth.currentUser!.uid).update({

            "gameLobbyId": doc.id,
            "battlewith": playerId,

      });

      await _firestore.collection("users").doc(playerId).update({

            "gameLobbyId": doc.id,
            "battlewith": _auth.currentUser!.uid,

      });

    } catch (e) {
      print('Failed to upload image and start game: $e');
      rethrow;
    }
  }


 Stream<DocumentSnapshot<Map<String, dynamic>>> getGameLobbyStream(String gameLobbyId) {
  try {
    return _firestore
        .collection('gameLobby').doc(gameLobbyId)
        .snapshots();
  } catch (e) {
    rethrow;
  }
}

//create a method to update the position of the player in the gameLobby collection

Future<void> updatePosition(List<double> position,String gameLobbyId) async {
  try {
    await _firestore.collection('gameLobby').doc(gameLobbyId).update({
      'position': position,
    });
  } catch (e) {
    print('Failed to update position: $e');
    rethrow;
  } 
}

 
}
