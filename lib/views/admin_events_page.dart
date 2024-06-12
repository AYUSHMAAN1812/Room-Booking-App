import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:room_booking/constants/routes.dart';
import 'package:room_booking/event_model.dart';
import 'package:room_booking/utilities/show_error_dialog.dart';
import 'package:room_booking/views/user_events_page.dart';

import '../helper_functions.dart';

String _name = "";
  bool _editForm = false;
  String _editEventId = "";

  String? _club;
  DateTime beginTime = DateTime.now();
  DateTime endTime = DateTime.now();
  bool showDate = false;
class AdminEventsPage extends StatefulWidget {
  const AdminEventsPage({super.key});

  @override
  State<AdminEventsPage> createState() => _AdminEventsPageState();
}

class _AdminEventsPageState extends State<AdminEventsPage> {
  

  final _clubList = ["Kludge", "Lambda", "Robotix", "Torque"];

  final _nameController = TextEditingController();
  final _purposeController = TextEditingController();
  final _roomController = TextEditingController();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _purposeController.dispose();
    _roomController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    if (args != null ) {
      _name = args['name'];
    }

    final nameField = Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: Colors.purple),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: TextFormField(
        autofocus: false,
        controller: _nameController,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.event, color: Colors.purple,),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Name",
          hintStyle: TextStyle(color: Colors.purple),
          border: InputBorder.none,
        ),
        style: const TextStyle(color: Colors.purple)
      ),
    );
    final purposeField = Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: Colors.purple),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: TextFormField(
        autofocus: false,
        controller: _purposeController,
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.description, color: Colors.purple,),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Purpose",
          hintStyle: TextStyle(color: Colors.purple),
          border: InputBorder.none,
        ),
        style: const TextStyle(color: Colors.purple)
      ),
    );
    
    final roomField = Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: Colors.purple),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: TextFormField(
        autofocus: false,
        controller: _roomController,
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.place, color: Colors.purple,),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Room",
          hintStyle: TextStyle(color: Colors.purple),
          border: InputBorder.none,
        ),
        style: const TextStyle(color: Colors.purple)
      ),
    );

    final searchField = Container(
      height: 50.0,
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: Colors.purple),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: TextFormField(
        autofocus: false,
        controller: _searchController,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.search),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Search for your Bookings",
          hintStyle: TextStyle(color: Colors.purple),
          border: InputBorder.none,
        ),
        style: const TextStyle(color: Colors.purple)
      ),
    );

    final clubDropDown = SizedBox(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          height: 50.0,
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          decoration: BoxDecoration(
            border: Border.all(width: 1.0, color: Colors.purple),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: DropdownButton<String>(
            dropdownColor: Colors.purple,
            icon: const Icon(Icons.arrow_drop_down),
            iconSize: 28,
            iconEnabledColor: Colors.purple,
            hint: const Text("Select club", style: TextStyle(color: Colors.purple),),
            disabledHint: const Text("Select club"),
            underline: const SizedBox(),
            isExpanded: true,
            value: _club,
            onChanged: (newValue) {
              setState(() {
                _club = newValue;
              });
            },
            items: _clubList.toSet().toList().map((valueItem) {
              return DropdownMenuItem(value: valueItem, child: Text(valueItem));
            }).toList(),
          ),
        ),
      ]),
    );

    final beginDatePicker = Visibility(
      visible: showDate,
      child: SizedBox(
        height: 220.0,
        child: CupertinoDatePicker(
          initialDateTime: DateTime.now(),
          onDateTimeChanged: ((value) => setState(() {
                beginTime = value;
              })),
        ),
      ),
    );
    final endDatePicker = Visibility(
      visible: showDate,
      child: SizedBox(
        height: 220.0,
        child: CupertinoDatePicker(
          initialDateTime: DateTime.now(),
          onDateTimeChanged: ((value) => setState(() {
                endTime = value;
              })),
        ),
      ),
    );

    final beginSelectedDateAndTime = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text("Start Date: ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple)),
            const SizedBox(width: 10.0),
            Text(DateFormat('yyyy-MM-dd').format(beginTime), style: const TextStyle(color: Colors.purple),),
          ],
        ),
        const SizedBox(height: 20.0),
        Row(
          children: [
            const Text("Start Time: ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple)),
            const SizedBox(width: 10.0),
            Text(DateFormat('HH:mm').format(beginTime), style: const TextStyle(color: Colors.purple),),
          ],
        ),
        const SizedBox(height: 15.0),
      ],
    );
    final endSelectedDateAndTime = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text("End Date: ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple)),
            const SizedBox(width: 10.0),
            Text(DateFormat('yyyy-MM-dd').format(endTime), style: const TextStyle(color: Colors.purple),),
          ],
        ),
        const SizedBox(height: 20.0),
        Row(
          children: [
            const Text("End Time: ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple)),
            const SizedBox(width: 10.0),
            Text(DateFormat('HH:mm').format(endTime), style: const TextStyle(color: Colors.purple),),
          ],
        ),
        const SizedBox(height: 15.0),
      ],
    );

    const txtHeader =
        Center(child: Text("Book Room", style: TextStyle(color: Colors.white,fontSize: 24.0)));

    final btnShowDate = Material(
      color: Colors.purple.shade50,
      child: MaterialButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          setState(() {
            showDate = !showDate;
          });
        },
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Say when",
              style: TextStyle(
                color: Colors.purple,
              ),
            ),
            SizedBox(width: 10.0),
            Icon(Icons.alarm, color: Colors.purple)
          ],
        ),
      ),
    );

    final btnSubmit = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(15),
      color: Colors.purple,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          if (_nameController.text.isNotEmpty &&
              _club != null &&
               _roomController.text.isNotEmpty) {
            Event event = Event(
              name: _nameController.text,
              club: _club!,
              status: "Pending",
              purpose: _purposeController.text,
              room: _roomController.text,
              beginTime: beginTime,
              endTime: endTime,
            );

            if (!_editForm) {
              bookSession(event: event);
            } else {
              updateEvent(Event(
                name: _nameController.text,
                club: _club!,
                status: "Pending",
                purpose: _purposeController.text,
                room: _roomController.text,
                beginTime: beginTime,
                endTime: endTime,
                id: _editEventId,
              ));
              setState(() {
                _editForm = false;
              });
            }
            setState(() {
              _name = _nameController.text;
              _nameController.clear();
              _purposeController.clear();
              _roomController.clear();
              _club = null;
              beginTime = DateTime.now();
              endTime = DateTime.now();
            });
          } else {
            log("Please enter all fields!");
            showErrorDialog(context, "Please enter all fields!");
          }
        },
        child: Text(
          !_editForm ? "Book" : "Update",
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );

    final btnSearch = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(15),
      color: Colors.purple,
      child: MaterialButton(
        onPressed: () {
          if (_searchController.text.isNotEmpty) {
            setState(() {
              _name = _searchController.text;
            });
          }
        },
        child: const Text(
          "Search",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );

    void editEvent(Event event) {
      setState(() {
        _nameController.text = event.name;
        _club = event.club;
        
        _purposeController.text = event.purpose;
        _roomController.text = event.room;
        beginTime = event.beginTime;
        endTime = event.endTime;
        _editForm = true;
        _editEventId = event.id!;
      });
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
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
        physics: const ClampingScrollPhysics(),
        child: Stack(
          
          children: [
            Container(
              height: MediaQuery.of(context).size.height/13,
              decoration: const BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  txtHeader,
                  const SizedBox(height: 20.0),
                  nameField,
                  const SizedBox(height: 30.0),
                  clubDropDown,
                  const SizedBox(height: 30.0),
                  purposeField,
                  const SizedBox(height: 30.0),
                  roomField,
                  const SizedBox(height: 30.0),
                  beginSelectedDateAndTime,
                  endSelectedDateAndTime,
                  beginDatePicker,
                  endDatePicker,
                  btnShowDate,
                  const SizedBox(height: 30.0),
                  btnSubmit,
                  const SizedBox(height: 30.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: searchField),
                      const SizedBox(width: 20.0),
                      btnSearch
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  GetMyEvents(eventName: _name, update: editEvent),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> bookSession({required Event event}) async {
  final docRef = bookingCollection.doc();
  event = Event(
    name: event.name,
    beginTime: event.beginTime,
    endTime: event.endTime,
    club: event.club,
    purpose: event.purpose,
    room: event.room,
    status: "Pending",
    id: docRef.id,
  );

  try {
    await docRef.set(event.toJson());
    log("Event booked successfully!");
  } catch (e) {
    log('Error booking event: $e');
  }

  await sendNotificationToUsers(event: event);
}

Future<void> updateEvent(Event event) async {
  try {
    await bookingCollection.doc(event.id).set(event.toJson());
    log("Event updated successfully!");
  } catch (e) {
    log("Error updating event: $e");
  }
  await sendNotificationToUsers(event: event);
}

Future<void> deleteEvent(Event event) async {
  try {
    await bookingCollection.doc(event.id).delete();
    log("Event deleted successfully!");
  } catch (e) {
    log("Error deleting event: $e");
  }
  await sendNotificationToUsers(event: event);
}

class GetMyEvents extends StatelessWidget {
  final String eventName;
  final ValueChanged<Event> update;
  const GetMyEvents({required this.eventName, required this.update, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300.0,
      child: StreamBuilder<QuerySnapshot>(
        stream: getMyEvents(eventName),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data == null) {
            return const SizedBox();
          }

          if (snapshot.data!.docs.isEmpty) {
            return const SizedBox(
              child: Center(child: Text("You haven't booked any event yet!",style: TextStyle(color: Colors.purple),)),
            );
          }

          if (snapshot.hasData) {
            List<Event> events = [];

            for (var doc in snapshot.data!.docs) {
              final event = Event.fromJson(doc.data() as Map<String, dynamic>);
              events.add(event);
            }

            return ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                return UserScheduleCard(events[index], update: update);
              },
            );
          }

          return const SizedBox();
        }),
      ),
    );
  }
}

getMyEvents(String eventName) {
  if (eventName.isEmpty) {
    return null;
  }
  return bookingCollection.where('name', isEqualTo: _name).snapshots();
}

class UserScheduleCard extends StatelessWidget {
  final Event event;
  final ValueChanged<Event> update;

  const UserScheduleCard(this.event, {required this.update, super.key});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => update(event),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit',
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => deleteEvent(event),
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: ListTile(
        tileColor: Colors.purple,
        title: Text(event.name, style: const TextStyle(color: Colors.white),),
        subtitle: Text('${event.club} - ${event.beginTime.toLocal()} - ${event.endTime.toLocal()}', style: const TextStyle(color: Colors.white),),
      ),
    );
  }
}
