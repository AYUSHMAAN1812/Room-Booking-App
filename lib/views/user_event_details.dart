import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:room_booking/constants/routes.dart';
import 'package:room_booking/event_model.dart';
import 'package:room_booking/views/user_bookings_page.dart';
import '../helper_functions.dart';

class UserEventDetails extends StatefulWidget {
  final Event event;
  const UserEventDetails(this.event, {super.key});

  @override
  State<UserEventDetails> createState() => _UserEventDetailsState();
}

class _UserEventDetailsState extends State<UserEventDetails> {
  late Event _eventCopy;

  @override
  void initState() {
    super.initState();
    _eventCopy = Event(
      name: widget.event.name,
      beginTime: widget.event.beginTime,
      endTime: widget.event.endTime,
      club: widget.event.club,
      purpose: widget.event.purpose,
      room: widget.event.room,
      status: widget.event.status,
      id: widget.event.id,
    );
  }

  void editBooking(Event event) {
    setState(() {
      _eventCopy.status = event.status;
    });
  }

  @override
  Widget build(BuildContext context) {
    log(_eventCopy.status);

    const txtHeader = Center(
        child: Text("Booking Details",
            style: TextStyle(fontSize: 24.0, color: Colors.white)));

    
    
    return Scaffold(
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
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 12,
            decoration: const BoxDecoration(
                color: Colors.purple,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0),
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: [
              txtHeader,
              const SizedBox(height: 20.0),
              BuildRow(title: "Name", details: widget.event.name),
              BuildRow(title: "Club", details: widget.event.club),
              BuildRow(title: "Purpose", details: widget.event.purpose),
              BuildRow(
                  title: "Start Date",
                  details: getDate(widget.event.beginTime)),
              BuildRow(
                  title: "Start Time",
                  details: getTime(widget.event.beginTime)),
              BuildRow(
                  title: "End Date", details: getDate(widget.event.beginTime)),
              BuildRow(
                  title: "End Time", details: getTime(widget.event.beginTime)),
              BuildRow(title: "Venue", details: widget.event.room),
              BuildRow(title: "Status", details: _eventCopy.status),
              const SizedBox(height: 20.0),
              
            ]),
          ),
        ],
      ),
    );
  }
}

Future<void> confirmBooking(Event event, ValueChanged<Event> update) async {
  event.status = "Confirm";

  await bookingCollection.doc(event.id).set(event.toJson()).then((value) {
    sendNotificationToUsers(event: event);
    update(event);
  });
}

Future<void> unavailableBooking(Event event, ValueChanged<Event> update) async {
  event.status = "Unavailable";

  await bookingCollection.doc(event.id).set(event.toJson()).then((value) {
    sendNotificationToUsers(event: event);
    update(event);
  });
}

class BuildRow extends StatelessWidget {
  final String title;
  final String details;
  const BuildRow({required this.title, required this.details, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Row(
        children: [
          Text("$title:",
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.purple)),
          const SizedBox(width: 10.0),
          Text(details),
        ],
      ),
    );
  }
}
