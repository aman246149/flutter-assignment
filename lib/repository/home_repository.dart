import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
}
