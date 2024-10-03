import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject_cst9l/pages/Refreshamount.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

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

  Future<void> requestExactAlarmPermission() async {
    // Check if permission is granted
    var status = await Permission.scheduleExactAlarm.status;
    if (!status.isGranted) {
      // Request permission
      await Permission.scheduleExactAlarm.request();
    }
  }

  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'default_channel', // Replace with your channel ID
        'Default Channel', // Replace with your channel name
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false,
      ),
    );
  }

  NotificationDetails scheduledNotificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'scheduled_channel', // Unique channel ID for scheduled notifications
        'Scheduled Notifications',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  NotificationDetails repeatingnotificationdetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'repeating_channel', // Unique channel ID for repeating notifications
        'Scheduled Notifications',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        styleInformation: BigTextStyleInformation(
          'Stayss on top of your finances by logging your expenses today. Every small step counts! Take control with a quick update now!',
          contentTitle: 'Time to Track Your Expenses!',
          htmlFormatContent: true,
          htmlFormatContentTitle: true,
        ),
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    return notificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails(),
    );
  }

  Future<void> scheduleNotification({
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    await notificationsPlugin.zonedSchedule(
      2, // Notification ID
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      scheduledNotificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
    print("Current time: ${DateTime.now()}");
    print("Scheduled time: $scheduledTime");
    print("Converted time: ${tz.TZDateTime.from(scheduledTime, tz.local)}");
    print("CAME HERE");
  }

  Future<void> repeatingscheduleNotification({
    required String title,
    required String body,
    required Duration duration,
  }) async {
    await notificationsPlugin.periodicallyShowWithDuration(
      4,
      title,
      body,
      duration,
      repeatingnotificationdetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> notify() async {
    double total = await fetchexpenses();
    double budget = await fetchbudget();
    double remaining = budget - total;

    if (remaining < budget * 0.5 && remaining > budget * 0.2) {
      await showNotification(
          title: 'Budget Alert!',
          body: 'You have exceeded 50% of your budget!');
      print("NOTIFIED 50");
    } else if (remaining <= budget * 0.2 && remaining > 0) {
      await showNotification(
          title: 'Budget Alert!',
          body: 'You have exceeded 80% of your budget!');
      print("NOTIFIED 80");
    } else if (remaining < 0) {
      await showNotification(
          title: 'Budget Alert!', body: 'You have exceeded your budget!');
      print("NOTIFIED 100");
    } else if (budget == 0) {
      await showNotification(
          title: 'Budget Alert!', body: 'You have no budget set!');
      print("NOTIFIED NO BUDGET");
    } else if (remaining < 0) {
      await showNotification(
          title: 'Budget Alert!', body: 'You have exceeded your budget!');
      print("NOTIFIED NEGATIVE");
    }
  }

  Future<void> schedulenotify() async {
    double total = await fetchexpenses();
    double budget = await fetchbudget();
    double remaining = budget - total;

    if (remaining < budget * 0.5 && remaining > budget * 0.2) {
      schedulebudgetnotif(
        title: 'Budget Reminder',
        body: 'You have exceeded 50% of your budget!',
      );
    } else if (remaining <= budget * 0.2 && remaining > 0) {
      schedulebudgetnotif(
        title: 'Budget Reminder',
        body: 'You have exceeded 80% of your budget!',
      );
    } else if (remaining < 0) {
      schedulebudgetnotif(
        title: 'Budget Reminder',
        body: 'You have exceeded your budget! Hinay Hinay!',
      );
    } else if (budget == 0) {
      schedulebudgetnotif(
        title: 'Budget Reminder',
        body: 'You have no budget set!',
      );
    } else if (remaining < 0) {
      schedulebudgetnotif(
        title: 'Budget Reminder',
        body: 'You have exceeded your budget! Hinay Hinay!',
      );
    }
  }

  void scheduleMyNotification() {
    DateTime scheduledTime = DateTime.now()
        .add(const Duration(seconds: 30)); // Change to your desired time
    NotificationService().scheduleNotification(
      title: 'Time to Review Your Expenses!',
      body:
          'Did you know? Tracking your expenses can help you save more. Start today!',
      scheduledTime: scheduledTime,
    );
  }

  void schedulebudgetnotif({
    required String title,
    required String body,
  }) {
    DateTime scheduledTime = DateTime.now().add(const Duration(seconds: 5));
    NotificationService().scheduleNotification(
      title: title,
      body: body,
      scheduledTime: scheduledTime,
    );
  }

  Future<void> repeatNotification() async {
    NotificationService().repeatingscheduleNotification(
      title: 'Time to Track Your Expenses!',
      body:
          "Stay on top of your finances by logging your expenses today. Every small step counts!",
      duration: const Duration(minutes: 5),
    );
  }

  Future<void> daily() async {
    DateTime scheduledTime = _nextInstanceOfTenAM();
    NotificationService().scheduleNotification(
      title: 'Daily Expense Reminder',
      body:
          "Financial success starts with awareness. Don't forget to track your expenses today!",
      scheduledTime: scheduledTime,
    );
    print("SCHED Current time: ${DateTime.now()}");
    print("SCHED Scheduled time: $scheduledTime");
    print(
        "SCHED Converted time: ${tz.TZDateTime.from(scheduledTime, tz.local)}");
  }

  tz.TZDateTime _nextInstanceOfTenAM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, 02, 30);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  void pendingNotification() async {
    final List<PendingNotificationRequest> pendingNotificationRequests =
        await notificationsPlugin.pendingNotificationRequests();
    print('${pendingNotificationRequests.length} pending notification '
        'requests');
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

    // DateTime now = DateTime.now();
    // DateTime startOfToday =
    //     DateTime(now.year, now.month, now.day); // Start of current day
    // DateTime endOfToday = DateTime(
    //     now.year, now.month, now.day, 23, 59, 59); // End of current day

    if (activeBudgetQuery.docs.isNotEmpty) {
      QuerySnapshot expenseSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .collection('expenses')
          // .where('timestamp',
          //     isGreaterThanOrEqualTo: startOfToday.millisecondsSinceEpoch)
          // .where('timestamp',
          //     isLessThanOrEqualTo: endOfToday.millisecondsSinceEpoch)
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
      return newBudget;
    } else {
      return newBudget;
    }
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
}
