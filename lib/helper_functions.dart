import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:room_booking/event_model.dart';

// Check if Date is Today
bool isToday(String date) {
  DateTime now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  DateTime dateConvert = DateTime.parse(date);
  final checkDate = DateTime(dateConvert.year, dateConvert.month, dateConvert.day);

  return checkDate == today;
}

// Check if Date is Tomorrow
bool isTomorrow(String date) {
  DateTime now = DateTime.now();
  final tomorrow = DateTime(now.year, now.month, now.day + 1);

  DateTime dateConvert = DateTime.parse(date);
  final checkDate = DateTime(dateConvert.year, dateConvert.month, dateConvert.day);

  return checkDate == tomorrow;
}

// Function to check if date is today or tomorrow
String checkDate(DateTime date) {
  if (isToday(getDate(date))) {
    return "Today";
  } else if (isTomorrow(getDate(date))) {
    return "Tomorrow";
  } else {
    return getDate(date);
  }
}

// Function to get Local time
String getTime(DateTime date) {
  String hour = date.toLocal().hour.toString().padLeft(2, '0');
  String min = date.toLocal().minute.toString().padLeft(2, '0');
  return "$hour:$min";
}

// Function to get Local date
String getDate(DateTime date) {
  return date.toLocal().toIso8601String().split('T')[0];
}

// Send Event Notification To Users
Future<void> sendNotificationToUsers({required Event event}) async {
  try {
    // Retrieve all user tokens from Firestore
    QuerySnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').get();
    List<String> tokens = userSnapshot.docs
        .map((doc) => doc["user-token"] as String?)
        .where((token) => token != null)
        .cast<String>()
        .toList();

    if (tokens.isEmpty) {
      log('No user tokens found.');
      return;
    }

    // Call Firebase Cloud Function
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('sendNotificationToUsers');
    final result = await callable.call(<String, dynamic>{
      'tokens': tokens,
      'title': 'New Event: ${event.name}',
      'body': 'Join us on ${getDate(event.beginTime)} at ${getTime(event.beginTime)} for an exciting event by ${event.club}!',
    });

    log('Notification sent successfully: ${result.data}');
  } catch (e) {
    log('Error sending notification: $e');
  }
}