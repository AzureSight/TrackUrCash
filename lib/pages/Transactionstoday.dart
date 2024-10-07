import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject_cst9l/pages/Dashboard.dart';
import 'package:finalproject_cst9l/pages/displayrecords.dart';
import 'package:finalproject_cst9l/pages/update.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TodaytransactionsDashboard extends StatelessWidget {
  TodaytransactionsDashboard({
    super.key,
  });

  final userid = FirebaseAuth.instance.currentUser!.uid;
  Update up = Update();
  @override
  Widget build(BuildContext context) {
    // gettotal();
    DateTime now = DateTime.now();
    DateTime startOfToday =
        DateTime(now.year, now.month, now.day); // Start of current day
    DateTime endOfToday = DateTime(
        now.year, now.month, now.day, 23, 59, 59); // End of current day

    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(userid)
            .collection('expenses')
            .where('timestamp',
                isGreaterThanOrEqualTo: startOfToday.millisecondsSinceEpoch)
            .where('timestamp',
                isLessThanOrEqualTo: endOfToday.millisecondsSinceEpoch)
            .orderBy("timestamp", descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text("loading"));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No Records"));
          }

          // return ListView(
          //   children: snapshot.data!.docs.map((DocumentSnapshot document) {
          //   Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
          //     return ListTile(
          //       title: Text(data['full_name']),
          //       subtitle: Text(data['company']),
          //     );
          //   }).toList(),
          // );
          var data = snapshot.data!.docs;
          return ListView.builder(
            shrinkWrap: true,
            itemCount: data.length,
            // /physics: NeverScrollableScrollPhysics(),
            //   itemCount: yourItemList.length, // Replace with your actual item list length
            itemBuilder: (context, index) {
              var expensedata = data[index];
              return displayrecords(
                data: expensedata,
                onSelect: () {
                  // print("tapped");
                },
              );
            },
          );
        });
  }
}
