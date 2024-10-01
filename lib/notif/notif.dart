import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject_cst9l/pages/Refreshamount.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    // Android Settings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS Settings with explicit permission requests
    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {
          // Handle iOS local notifications if needed
        });

    // Combine Android and iOS settings
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    // Initialize the plugin with settings
    await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {});

    // Request iOS Permissions explicitly after initialization
    await _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    // Request iOS permissions
    await notificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    // Request Android 13+ notification permissions
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails('channelId', 'channelName',
            importance: Importance.max),
        iOS: DarwinNotificationDetails());
  }

  Future showNotification(
      {int id = 0, String? title, String? body, String? payLoad}) async {
    return notificationsPlugin.show(
        id, title, body, await notificationDetails());
  }

  Future<double> getbudget() async {
    final User? user = FirebaseAuth.instance.currentUser; // Use nullable type
    double newBudget = 0.0;
    if (user != null) {
      try {
        // Retrieve the user's document from the 'Users' collection
        DocumentSnapshot userDocument = await FirebaseFirestore.instance
            .collection("Users")
            .doc(user.uid)
            .get();

        if (userDocument.exists) {
          Map<String, dynamic> userData =
              userDocument.data() as Map<String, dynamic>;
          newBudget =
              userData['budget'] ?? 0.0; // Default to 0.0 if 'budget' is null
        }
      } catch (e) {
        print("Error retrieving data: $e");
      }
    }
    return newBudget;
  }

  Future<void> checkBudget() async {
    var reff = Refresh();

    double total = await reff.taketotal();
    double budget = await getbudget();
    double remaining = budget - total;

    if (remaining < budget * 0.5) {
      await showNotification(
          title: 'Budget Alert', body: 'BUDGET NOTIF TESTING!');
      print("NOTIFIED");
    }
  }
}
