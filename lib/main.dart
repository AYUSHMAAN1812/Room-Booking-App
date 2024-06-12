import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:room_booking/constants/routes.dart';
import 'package:room_booking/event_model.dart';
import 'package:room_booking/views/admin_bookings.dart';
import 'package:room_booking/views/admin_events_page.dart';
import 'package:room_booking/views/event_details.dart';
import 'package:room_booking/views/home_view.dart';
import 'package:room_booking/views/login_admin_view.dart';
import 'package:room_booking/views/login_user_view.dart';
import 'package:room_booking/views/register_user_view.dart';
import 'package:room_booking/views/user_events_page.dart';
import 'package:room_booking/views/verify_email_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await setupFlutterNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple.shade400),
        useMaterial3: true,
      ),
      home: const Homepage(),
      routes: {
        homePage: (context) => const Homepage(),
        userLoginRoute: (context) => const LoginUserView(),
        adminLoginRoute: (context) => const LoginAdminView(),
        userRegisterRoute: (context) => const RegisterView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
        adminEventsRoute: (context) => const AdminEventsPage(),
        homeView: (context) => const HomeView(),
        adminBookingsRoute: (context) => const AdminBookingsPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == eventDetails) {
          final event = settings.arguments as Event;
          return MaterialPageRoute(
            builder: (context) => EventDetails(event),
          );
        }
        if (settings.name == userEventsRoute) {
          final email = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => UserEventsPage(email),
          );
        }

        return null;
      },
    );
  }
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});
  static const primaryColor = Colors.white;

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    super.initState();
    setUpInteractedMessage();
  }
  Future<void> setUpInteractedMessage() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Configure notification permissions for iOS
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );

    // Request permissions for Android
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    log('User granted permission: ${settings.authorizationStatus}');

    // Get the message from tapping on the notification when app is not in foreground
    RemoteMessage? initialMessage = await messaging.getInitialMessage();

    // If the message contains a club, navigate to the admin
    if (initialMessage != null) {
      await _mapMessageToUser(initialMessage);
    }

    // This listens for messages when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen(_mapMessageToUser);

    // Listen to messages in Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      // Initialize FlutterLocalNotifications
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'events_channel',
              'Events Notifications',
              channelDescription:
                  'This channel is used for Events app notifications.',
              icon: "@mipmap/ic_launcher",
              importance: Importance.max,
            ),
          ),
        );
      }
    });
  }

  Future<void> _mapMessageToUser(RemoteMessage message) async {
    Map<String, dynamic> json = message.data;

    try {
      if (message.data['club'] != null) {
        Event event = Event(
          name: json['name'],
          beginTime: DateTime.parse(json['beginTime']),
          endTime: DateTime.parse(json['endTime']),
          club: json['club'],
          purpose: json['purpose'],
          room: json['room'],
          status: json['status'],
          id: json['id'],
        );
        Navigator.of(context).pushNamed(eventDetails, arguments: event);
      } else {
        Navigator.of(context).pushNamed(userLoginRoute, arguments: json);
      }
    } catch (e) {
      log('Error processing message: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple,
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
                  userRegisterRoute,
                );
              },
              child: const Text('Register as a User'),
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
                  userLoginRoute,
                );
              },
              child: const Text('Login as a User'),
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
                  adminLoginRoute,
                );
              },
              child: const Text('Login as an Admin'),
            ),
          ],
        ),
      ),
    );
  }
}

Future<bool> showLogOutDialogBox(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure to sign out?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Log Out'),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> setupFlutterNotifications() async {
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'events_channel',
    'Events Notifications',
    description: 'This channel is used for Events app notifications.',
    importance: Importance.max,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}
