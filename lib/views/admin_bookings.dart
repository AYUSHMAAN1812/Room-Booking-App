import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:room_booking/constants/routes.dart';
import 'package:room_booking/event_model.dart';
import 'package:room_booking/helper_functions.dart';

final db = FirebaseFirestore.instance;
final bookingCollection = db.collection('bookings');
final userCollection = db.collection('users');

class AdminBookingsPage extends StatefulWidget {
  const AdminBookingsPage({super.key});

  @override
  State<AdminBookingsPage> createState() => _AdminBookingsPage();
}

class _AdminBookingsPage extends State<AdminBookingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.purple.shade50,
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
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height/6,
              decoration: const BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  )),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.0),
                    Text("Welcome Admin,",
                        style: TextStyle(
                            fontSize: 24.0,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    SizedBox(height: 10.0),
                    Text("Here are the bookings waiting for your approval",
                        style: TextStyle(fontSize: 16.0, color: Colors.white)),
                    SizedBox(height: 40.0),
                    Schedule(),
                    SizedBox(height: 30.0),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}

class Schedule extends StatelessWidget {
  const Schedule({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: StreamBuilder(
        stream: getBookings,
        builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            log("Error: ${snapshot.error}"); // Debug log for error
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            log("No data or empty docs"); // Debug log for no data
            return const SizedBox(
              height: 300.0,
              child: Center(child: Text("You do not have any bookings!")),
            );
          }

          if (snapshot.hasData) {
            List<Event> bookings = [];

            for (var doc in snapshot.data!.docs) {
              final booking = Event.fromJson(doc.data() as Map<String, dynamic>);
              // print(booking); // Debug log for each booking
              bookings.add(booking);
            }
            
            return SizedBox(
              height: 300.0,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                      onTap: () => Navigator.of(context)
                          .pushNamed(eventDetails, arguments: bookings[index]),
                      child: ScheduleCard(bookings[index]));
                },
              ),
            );
          }

          return const SizedBox();
        }),
      ),
    );
  }
}

//Stream to get all Events from today
DateTime now = DateTime.now();
DateTime today = DateTime(now.year, now.month, now.day);

final Stream<QuerySnapshot> getBookings = bookingCollection
    // .orderBy('time')
    // .where('time', isGreaterThanOrEqualTo: Timestamp.fromDate(today))
    .snapshots();

class ScheduleCard extends StatelessWidget {
  final Event booking;
  const ScheduleCard(this.booking, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),

      //width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: SizedBox(
              height: 50.0,
              child: Card(
                elevation: 3.0,
                margin: EdgeInsets.zero,
                child: Padding(
                  padding:
                      const EdgeInsets.only(right: 10.0, top: 10.0, left: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                                width: 110.0,
                                child: Column(
                                  children: [
                                    Text(booking.name,
                                        overflow: TextOverflow.ellipsis),
                                    Text(
                                      booking.status,
                                      style: TextStyle(
                                          fontSize: 12.0,
                                          color: booking.status == 'Pending'
                                              ? Colors.red
                                              : booking.status == 'Confirmed'
                                                  ? Colors.green
                                                  : Colors.blue,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                )),

                            //Appointmemt date
                            Text(checkDate(booking.beginTime)),
                            Text(checkDate(booking.endTime)),

                            //Event time
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Text(getTime(booking.beginTime)),
                                    Text(getTime(booking.endTime)),
                                  ],
                                ),
                                Text(booking.room),
                              ],
                            ),
                          ]),
                      
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
