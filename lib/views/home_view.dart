import 'package:flutter/material.dart';
import 'package:room_booking/constants/routes.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

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
              style: TextStyle(color: Colors.white, fontSize: 40,),
              
            ),
            const SizedBox(height: 50.0,),
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
            const SizedBox(height: 50.0,),
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
                  userBookingsRoute,
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