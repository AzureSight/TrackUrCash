import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ExpenseService {
  Future<double> getExpensesForCurrentWeek() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    DateTime now = DateTime.now(); // Local time

    DateTime startOfThisWeek = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: now.weekday - 1)); // Start of week (Monday)
    DateTime endOfThisWeek = startOfThisWeek.add(const Duration(
        days: 6, hours: 23, minutes: 59, seconds: 59)); // End of week

    double total = 0;
    try {
      // print("Querying for expenses");

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .collection('expenses')
          .where('timestamp',
              isGreaterThanOrEqualTo: startOfThisWeek.millisecondsSinceEpoch)
          .where('timestamp',
              isLessThanOrEqualTo: endOfThisWeek.millisecondsSinceEpoch)
          .orderBy("timestamp", descending: false)
          .get();

      snapshot.docs.forEach((expenseDoc) {
        double expenseAmount = (expenseDoc['amount'] as num).toDouble();
        total += expenseAmount;
      });
    } catch (e) {
      print('Error fetching expenses: $e');
    }
    // print("Total expenses for the week: $total");
    return total;
  }
}
