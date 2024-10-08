import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BudgetGetter {
  Future<double> fetchbudget() async {
    final user = FirebaseAuth.instance.currentUser;

    await FirebaseFirestore.instance.collection('Users').doc(user!.uid).get();

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
    double totalAmount = 0;
    if (user != null) {
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
    }
    // print("HOW MUCH: $totalAmount");
    return totalAmount;
  }

  // double total = 0.0;
  // Future<double> taketotalexpense() async {
  //   total = await fetchbudget();
  //   return total;
  //   // Use the 'total' variable wherever you need it in your code
  // }
}
