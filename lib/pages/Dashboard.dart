import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject_cst9l/pages/Transactionstoday.dart';
import 'package:finalproject_cst9l/pages/Fetchbargraphdata.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

// getTotalAmountFromTodayTransactions() async {
//   Todaytransactions todaytransactions = Todaytransactions();
//   double totalAmount = await todaytransactions.getTotalAmount();
//   String totalAsString = totalAmount.toStringAsFixed(2);
//   return totalAsString;
// }

Future<double> Caltotal() async {
  final User? user = FirebaseAuth.instance.currentUser;
  DateTime now = DateTime.now();
  DateTime startOfToday =
      DateTime(now.year, now.month, now.day); // Start of current day
  DateTime endOfToday =
      DateTime(now.year, now.month, now.day, 23, 59, 59); // End of current day
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
Future<double> gettotal() async {
  total = await Caltotal();
  // print('Total amount: $total');

  return total;
  // Use the 'total' variable wherever you need it in your code
}

class _DashboardState extends State<Dashboard> {
  int _currentPage = 1;
  double tot = 0;

  @override
  void initState() {
    super.initState();
    initializeTotal();
  }

  Future<void> initializeTotal() async {
    double total = await gettotal();
    setState(() {
      tot = total;
    });
  }

//  String total = getTotalAmountFromTodayTransactions();
  @override
  Widget build(BuildContext context) {
    //Caltotal();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF23cc71),
        automaticallyImplyLeading: false,
        title: const Text(
          'Dashboard',
          style: TextStyle(
            fontFamily: 'Nunito',
            color: Colors.white,
            fontSize: 35,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [],
        centerTitle: false,
        elevation: 2,
      ),
      body: ListView(
        children: [
          //MY EXPENSES CONTAINER HERE
          Align(
            alignment: AlignmentDirectional(0.00, 0.00),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
              child: Container(
                width: 500,
                height: 179,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 4,
                      color: Color(0x33000000),
                      offset: Offset(0, 2),
                      spreadRadius: 2,
                    )
                  ],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.white,
                    width: 0,
                  ),
                ),
                child: Align(
                  alignment: const AlignmentDirectional(-1.00, -1.00),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Align(
                              alignment: AlignmentDirectional(-1.00, -1.00),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: Text(
                                  'My Expenses',
                                  style: TextStyle(
                                    fontFamily: 'Raleway',
                                    color: Color(0xFF001F3F),
                                    fontSize: 30,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(-1.00, -1.00),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                child: Text(
                                  'This day',
                                  style: TextStyle(
                                    fontFamily: 'Manrope',
                                    color: Color(0xFF2E2863),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(
                          thickness: 1.5,
                          color: Color(0xFFBDC3C7),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Padding(
                                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: Text(
                                  'Total Expenses',
                                  style: TextStyle(
                                    fontFamily: 'Manrope',
                                    color: Color(0xFF2E2863),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                '₱$tot',
                                //'₱'
                                style: const TextStyle(
                                  fontFamily: 'Manrope',
                                  color: Color(0xFF23cc71),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          //END OF MY EXPENSES CONTAINER

          //MY SPENDING REPORT CONTAINER HERE
          Align(
            alignment: const AlignmentDirectional(0.00, 0.00),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
              child: Container(
                width: 500,
                height: 415,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 4,
                      color: Color(0x33000000),
                      offset: Offset(0, 2),
                      spreadRadius: 2,
                    )
                  ],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.white,
                    width: 0,
                  ),
                ),
                child: Align(
                  alignment: const AlignmentDirectional(-1.00, -1.00),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: Text(
                                'Spending Report',
                                style: TextStyle(
                                  fontFamily: 'Raleway',
                                  color: Color(0xFF001F3F),
                                  fontSize: 30,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            // Add some spacing or divider between the title and container if needed
                            // const SizedBox(width: 10),
                            // Container(
                            //   width: 245,
                            //   padding:
                            //       const EdgeInsets.symmetric(horizontal: 10),
                            //   decoration: BoxDecoration(
                            //     borderRadius: BorderRadius.circular(8),
                            //     color: Colors.grey[
                            //         200], // Optional: Background color for the container
                            //   ),
                            //   child: Row(
                            //     mainAxisAlignment: MainAxisAlignment.center,
                            //     children: [
                            //       // IconButton(
                            //       //   icon: const Icon(Icons.chevron_left),
                            //       //   onPressed: () {
                            //       //     // Your left button logic
                            //       //   },
                            //       // ),
                            //       const Text(
                            //         'Weekly Report',
                            //         style: TextStyle(
                            //           fontFamily: 'Raleway',
                            //           fontSize: 18,
                            //           fontWeight: FontWeight.bold,
                            //         ),
                            //       ),
                            //       // IconButton(
                            //       //   icon: const Icon(Icons.chevron_right),
                            //       //   onPressed: () {
                            //       //     // Your right button logic
                            //       //   },
                            //       // ),
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),
                        const Divider(
                          thickness: 1.5,
                          color: Color(0xFFBDC3C7),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: SizedBox(
                            height: 290,
                            child: MyBarGraph(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          //END OF MY SPENDING REPORT
          //END OF MY SPENDING REPORT

          //EXPENSES FOR THE DAY CONTAINER HERE
          Align(
            alignment: const AlignmentDirectional(0.00, 0.00),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
              child: Container(
                width: 500,
                height: 360,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 4,
                      color: Color(0x33000000),
                      offset: Offset(0, 2),
                      spreadRadius: 2,
                    )
                  ],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.white,
                    width: 0,
                  ),
                ),
                child: Align(
                  alignment: const AlignmentDirectional(-1.00, -1.00),
                  child: Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                    child: ListView(
                      children: [
                        const Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                              alignment: AlignmentDirectional(-1.00, -1.00),
                              child: Text(
                                'Expenses for the day',
                                style: TextStyle(
                                  fontFamily: 'Raleway',
                                  color: Color(0xFF001F3F),
                                  fontSize: 30,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(
                          thickness: 1.5,
                          color: Color(0xFFBDC3C7),
                        ),
                        Container(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          height:
                              230, // Replace with an appropriate fixed height
                          child: TodaytransactionsDashboard(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          //END OF FOR THE DAY CONTAINER
        ],
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: _currentPage,
      //   onTap: (int newPage) {
      //     setState(() {
      //       _currentPage = newPage;
      //     });
      //     // Navigate to the corresponding page
      //     switch (newPage) {
      //       case 0:
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(builder: (context) => const Expenses()),
      //         );
      //         break;

      //       case 1:
      //         // Dashboard page (current page)
      //         break;

      //       case 2:
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(builder: (context) => const Budget()),
      //         );
      //         break;

      //       case 3:
      //         Navigator.push(context,
      //             MaterialPageRoute(builder: (context) => const Profile()));
      //         break;
      //     }
      //   },
      //   items: const [
      //     BottomNavigationBarItem(
      //       label: 'Expenses',
      //       icon: Icon(
      //         Icons.wallet_rounded,
      //         size: 32,
      //         color: Color(0xFF8A000000),
      //       ),
      //     ),
      //     BottomNavigationBarItem(
      //       label: 'Home',
      //       icon: Icon(
      //         Icons.home_rounded,
      //         size: 32,
      //         color: Color(0xFF6F61EF),
      //       ),
      //     ),
      //     BottomNavigationBarItem(
      //       label: 'Budget',
      //       icon: Icon(
      //         Icons.savings_rounded,
      //         size: 32,
      //         color: Color(0xFF8A000000),
      //       ),
      //     ),
      //     BottomNavigationBarItem(
      //       label: 'Profile',
      //       icon: Icon(
      //         Icons.person_2_rounded,
      //         size: 32,
      //         color: Color(0xFF8A000000),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
