import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Refresh {
  Future<double> caltotal() async {
    final User? user = FirebaseAuth.instance.currentUser;
    DateTime now = DateTime.now();
    DateTime startOfToday =
        DateTime(now.year, now.month, now.day); // Start of current day
    DateTime endOfToday = DateTime(
        now.year, now.month, now.day, 23, 59, 59); // End of current day
    double totalAmount = 0;
    if (user != null) {
      QuerySnapshot expenseSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .collection('expenses')
          .where('timestamp',
              isGreaterThanOrEqualTo: startOfToday.millisecondsSinceEpoch)
          .where('timestamp',
              isLessThanOrEqualTo: endOfToday.millisecondsSinceEpoch)
          .get();

      List<QueryDocumentSnapshot> expenses = expenseSnapshot.docs;

      for (var expense in expenses) {
        totalAmount += (expense['amount'] as num).toDouble();
      }
    }

    return totalAmount;
  }

  double total = 0.0;
  Future<double> taketotal() async {
    total = await caltotal();
    return total;
    // Use the 'total' variable wherever you need it in your code
  }
}
