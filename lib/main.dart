import 'package:finalproject_cst9l/firebase_options.dart';
import 'package:finalproject_cst9l/notif/notif.dart';
import 'package:finalproject_cst9l/pages/Onboarding.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // NotificationService().requestExactAlarmPermission();
  // NotificationService().initNotification();
  await initializeNotifications();
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Manila'));

  runApp(const MyApp());
}

// Ensure requestExactAlarmPermission is asynchronous and properly awaited.
Future<void> initializeNotifications() async {
  await NotificationService().initNotification();
  await NotificationService()
      .requestExactAlarmPermission(); // Await this method
  // Then call initNotification
}

final navigatorkey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorkey,
      debugShowCheckedModeBanner: false,
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home: const Onboarding(),
    );
  }
}
