import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class MessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Singleton pattern
  static final MessagingService _instance = MessagingService._internal();
  factory MessagingService() => _instance;
  MessagingService._internal();

  Future<String?> getToken() async {
    try {
      return await _firebaseMessaging.getToken();
    } catch (e) {
      // Handle error
      return null;
    }
  }

  // Other methods related to Firebase Messaging can be added here
}

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Singleton pattern
  static final FirestoreService _instance = FirestoreService._internal();
  factory FirestoreService() => _instance;
  FirestoreService._internal();

  Future<void> setUserToken(String email,String name, String token) async {
    try {
      await _firestore.collection('users').doc(email).set({
        "name" : name,
        "user-token": token,
        "role": "user",
      }, SetOptions(merge: true));
    } catch (e) {
      // Handle error
    }
  }
  Future<void> setAdminToken(String email, String token) async {
    try {
      await _firestore.collection('users').doc(email).set({
        "user-token": token,
        "role": "admin",
      }, SetOptions(merge: true));
    } catch (e) {
      // Handle error
    }
  }

  Future<DocumentSnapshot> getUserDocument(String email) async {
    try {
      return await _firestore.collection('users').doc(email).get();
    } catch (e) {
      // Handle error
      rethrow;
    }
  }
}
