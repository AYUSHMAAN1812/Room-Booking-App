import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:room_booking/constants/routes.dart';
import 'package:room_booking/services/event/event_service.dart';
import 'package:room_booking/utilities/show_error_dialog.dart';

class HomeView extends StatefulWidget {
  final String email;
  const HomeView(this.email, {super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
   Future<String?> getUserName(String email) async {
    try {
      final token = await MessagingService().getToken();
      if (token != null) {
        DocumentSnapshot doc = await FirestoreService().getUserDocument(email);
        return doc["name"];
      }
    } catch (e) {
      if (!mounted) return null;
      showErrorDialog(context, 'Failed to get user data');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.purple,
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () async {
              await Navigator.of(context).pushNamedAndRemoveUntil(
                homePage,
                (route) => false,
              );
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'ROOM BOOKINGS OF IITH',
              style: TextStyle(color: Colors.white, fontSize: 40),
            ),
            const SizedBox(height: 50.0),
            ElevatedButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.purple,
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                textStyle: const TextStyle(fontSize: 20.0),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  bookARoom,
                );
              },
              child: const Text('Book A Room'),
            ),
            const SizedBox(height: 50.0),
            ElevatedButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.purple,
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                textStyle: const TextStyle(fontSize: 20.0),
              ),
              onPressed: () {
                // Pass userName if needed
                Navigator.of(context).pushNamed(
                  userBookingsRoute,
                  arguments: getUserName(widget.email),
                );
              },
              child: const Text('View Room Bookings'),
            ),
          ],
        ),
      ),
    );
  }
}
