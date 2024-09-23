import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject_cst9l/pages/Fetchbargraphdata.dart';
import 'package:firebase_auth/firebase_auth.dart';

class bargraphquery {
  getExpensesForCurrentWeeks() {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    DateTime now = DateTime.now();
    DateTime startOfThisWeek = now.subtract(Duration(
        days: now.weekday - 1)); // Assuming Monday is the start of the week
    DateTime endOfThisWeek = startOfThisWeek.add(Duration(days: 6));

    FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('expenses')
        .where('timestamp',
            isGreaterThanOrEqualTo: startOfThisWeek.millisecondsSinceEpoch)
        .where('timestamp',
            isLessThanOrEqualTo: endOfThisWeek.millisecondsSinceEpoch)
        .orderBy("timestamp", descending: false)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      var data = snapshot.docs;

      double Mon = 0.0;
      double Tue = 0.0;
      double Wed = 0.0;
      double Thur = 0.0;
      double Fri = 0.0;
      double Sat = 0.0;
      double Sun = 0.0;

      data.forEach((expenseDoc) {
        // Assuming 'timestamp' is a field in your Firestore document
        int expenseTimestamp = expenseDoc['timestamp'];
        double expenseAmount = expenseDoc['amount'];

        DateTime expenseDate =
            DateTime.fromMillisecondsSinceEpoch(expenseTimestamp);

        // Check the day of the week and add the expense amount to the respective day
        switch (expenseDate.weekday) {
          case DateTime.monday:
            Mon += expenseAmount;
            break;
          case DateTime.tuesday:
            Tue += expenseAmount;
            break;
          case DateTime.wednesday:
            Wed += expenseAmount;
            break;
          case DateTime.thursday:
            Thur += expenseAmount;
            break;
          case DateTime.friday:
            Fri += expenseAmount;
            break;
          case DateTime.saturday:
            Sat += expenseAmount;
            break;
          case DateTime.sunday:
            Sun += expenseAmount;
            break;
          default:
            break;
        }
      });
      MyBarGraph(
        mon: Mon,
        tue: Tue,
        wed: Wed,
        thur: Thur,
        fri: Fri,
        sat: Sat,
        sun: Sun,
      );
      // Now you have the expenses for each day of the week
      // You can use these values to update your UI or wherever required
      // For instance, update your MyBarGraph widget with these values
    });
  }
  //GET COLLECTION OF NOTES
}
