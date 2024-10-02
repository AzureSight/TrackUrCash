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
    double total = await fetchexpenses();
    double budget = await fetchbudget();
    double remaining = budget - total;

    if (remaining < budget * 0.5) {
      await showNotification(
          title: 'Budget Alert!',
          body: 'You have exceeded half of your budget!');
      print("NOTIFIED");
    }
  }

  Future<double> fetchexpenses() async {
    final user = FirebaseAuth.instance.currentUser;

    await FirebaseFirestore.instance.collection('Users').doc(user!.uid).get();
    double totalAmount = 0;

    QuerySnapshot activeBudgetQuery = await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .collection('budget')
        .where('status', isEqualTo: 'active')
        .limit(1) // We expect only one active budget at a time
        .get();

    String activeBudgetDescription = " ";

    if (activeBudgetQuery.docs.isNotEmpty) {
      var activeBudgetDoc = activeBudgetQuery.docs.first;
      activeBudgetDescription = activeBudgetDoc['budget_desc'];
    }

    DateTime now = DateTime.now();
    DateTime startOfToday =
        DateTime(now.year, now.month, now.day); // Start of current day
    DateTime endOfToday = DateTime(
        now.year, now.month, now.day, 23, 59, 59); // End of current day

    if (activeBudgetQuery.docs.isNotEmpty) {
      QuerySnapshot expenseSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .collection('expenses')
          .where('timestamp',
              isGreaterThanOrEqualTo: startOfToday.millisecondsSinceEpoch)
          .where('timestamp',
              isLessThanOrEqualTo: endOfToday.millisecondsSinceEpoch)
          .where('budget', isEqualTo: activeBudgetDescription)
          .get();

      List<QueryDocumentSnapshot> expenses = expenseSnapshot.docs;

      for (var expense in expenses) {
        totalAmount += (expense['amount'] as num).toDouble();
      }
    } else {}
    return totalAmount;
  }

  Future<double> fetchbudget() async {
    final user = FirebaseAuth.instance.currentUser;
    double newBudget = 0;
    if (user != null) {
      try {
        // Retrieve all documents from the 'users' collection
        QuerySnapshot userDocument = await FirebaseFirestore.instance
            .collection("Users")
            .doc(user.uid)
            .collection("budget")
            .where("status", isEqualTo: "active")
            .get();

        if (userDocument.docs.isNotEmpty) {
          var activeBudget = userDocument.docs.first;
          print("Active Budget Data: ${activeBudget.data()}");
          Map<String, dynamic> userData =
              activeBudget.data() as Map<String, dynamic>;

          // Check if the value is stored as an int, and convert it to double if necessary
          newBudget = userData['budget_amount'] is int
              ? (userData['budget_amount'] as int)
                  .toDouble() // Convert int to double
              : userData['budget_amount']
                  as double; // If it's already a double, no need to convert
        } else {}
      } catch (e) {
        print("Error retrieving data: $e");
      }
    }
    return newBudget;
  }
}
