// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';

// class MyBarGraphweek extends StatefulWidget {
//   @override
//   _MyBarGraphweekState createState() => _MyBarGraphweekState();
// }

// class _MyBarGraphweekState extends State<MyBarGraphweek> {
//   double week1 = 0;
//   double week2 = 0;
//   double week3 = 0;
//   double week4 = 0;
//   double week5 = 0; // Some months may have a partial 5th week

//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(Duration(milliseconds: 500), () {
//       getExpensesForCurrentMonth();
//     }); // Fetch the expenses when the widget is initialized
//   }

//   void updateBarGraph(double newWeek1, double newWeek2, double newWeek3,
//       double newWeek4, double newWeek5) {
//     setState(() {
//       week1 = newWeek1;
//       week2 = newWeek2;
//       week3 = newWeek3;
//       week4 = newWeek4;
//       week5 = newWeek5;
//     });
//   }

//   // Future<void> getExpensesForCurrentMonth() async {
//   //   final uid = FirebaseAuth.instance.currentUser!.uid;
//   //   DateTime now = DateTime.now(); // Local time
//   //   DateTime startOfMonth =
//   //       DateTime(now.year, now.month, 1); // Start of the current month
//   //   DateTime endOfMonth =
//   //       DateTime(now.year, now.month + 1, 0); // End of the current month

//   //   try {
//   //     print("Querying for expenses of the month");

//   //     QuerySnapshot snapshot = await FirebaseFirestore.instance
//   //         .collection('Users')
//   //         .doc(uid)
//   //         .collection('expenses')
//   //         .where('timestamp',
//   //             isGreaterThanOrEqualTo: startOfMonth.millisecondsSinceEpoch)
//   //         .where('timestamp',
//   //             isLessThanOrEqualTo: endOfMonth.millisecondsSinceEpoch)
//   //         .orderBy("timestamp", descending: false)
//   //         .get();

//   //     // Accumulate expenses for each week
//   //     List<double> weeklyExpenses =
//   //         List.filled(5, 0.0); // Assuming max 5 weeks in a month

//   //     snapshot.docs.forEach((expenseDoc) {
//   //       int expenseTimestamp = expenseDoc['timestamp'];
//   //       double expenseAmount = (expenseDoc['amount'] as num).toDouble();

//   //       DateTime expenseDate =
//   //           DateTime.fromMillisecondsSinceEpoch(expenseTimestamp);

//   //       // Calculate the week number (1-indexed) of the month
//   //       int weekOfMonth = ((expenseDate.day - 1) ~/ 7) + 1;

//   //       if (weekOfMonth <= 5) {
//   //         weeklyExpenses[weekOfMonth - 1] +=
//   //             expenseAmount; // Increment the corresponding week
//   //       }
//   //     });

//   //     // Update the bar graph with the new values
//   //     updateBarGraph(weeklyExpenses[0], weeklyExpenses[1], weeklyExpenses[2],
//   //         weeklyExpenses[3], weeklyExpenses[4]);
//   //   } catch (e) {
//   //     print('Error fetching expenses: $e');
//   //   }
//   // }

//   // Future<void> getExpensesForCurrentMonth() async {
//   //   final uid = FirebaseAuth.instance.currentUser!.uid;
//   //   DateTime now = DateTime.now(); // Local time
//   //   DateTime startOfMonth =
//   //       DateTime(now.year, now.month, 1); // Start of the current month
//   //   DateTime endOfMonth =
//   //       DateTime(now.year, now.month + 1, 0); // End of the current month

//   //   try {
//   //     print("Querying for expenses of the month");

//   //     QuerySnapshot snapshot = await FirebaseFirestore.instance
//   //         .collection('Users')
//   //         .doc(uid)
//   //         .collection('expenses')
//   //         .where('timestamp',
//   //             isGreaterThanOrEqualTo: startOfMonth.millisecondsSinceEpoch)
//   //         .where('timestamp',
//   //             isLessThanOrEqualTo: endOfMonth.millisecondsSinceEpoch)
//   //         .orderBy("timestamp", descending: false)
//   //         .get();

//   //     // Accumulate expenses for each week
//   //     double tempWeek1 = 0,
//   //         tempWeek2 = 0,
//   //         tempWeek3 = 0,
//   //         tempWeek4 = 0,
//   //         tempWeek5 = 0;

//   //     snapshot.docs.forEach((expenseDoc) {
//   //       int expenseTimestamp = expenseDoc['timestamp'];
//   //       double expenseAmount = (expenseDoc['amount'] as num).toDouble();

//   //       DateTime expenseDate =
//   //           DateTime.fromMillisecondsSinceEpoch(expenseTimestamp);
//   //       int dayOfMonth = expenseDate.day;

//   //       if (dayOfMonth <= 7) {
//   //         tempWeek1 += expenseAmount;
//   //       } else if (dayOfMonth <= 14) {
//   //         tempWeek2 += expenseAmount;
//   //       } else if (dayOfMonth <= 21) {
//   //         tempWeek3 += expenseAmount;
//   //       } else if (dayOfMonth <= 28) {
//   //         tempWeek4 += expenseAmount;
//   //       } else {
//   //         tempWeek5 += expenseAmount; // If the month has more than 28 days
//   //       }
//   //     });

//   //     // Update the bar graph with the new values
//   //     updateBarGraph(tempWeek1, tempWeek2, tempWeek3, tempWeek4, tempWeek5);
//   //   } catch (e) {
//   //     print('Error fetching expenses: $e');
//   //   }
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: BarChart(
//         BarChartData(
//             gridData: FlGridData(show: false),
//             borderData: FlBorderData(show: false),
//             titlesData: const FlTitlesData(
//               show: true,
//               topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//               bottomTitles: AxisTitles(
//                 sideTitles: SideTitles(
//                   showTitles: true,
//                   getTitlesWidget:
//                       getBottomTitles, // Update bottom titles for weeks
//                 ),
//               ),
//               leftTitles: AxisTitles(
//                 sideTitles: SideTitles(
//                   showTitles: true,
//                   getTitlesWidget:
//                       getLeftTitles, // You can define a custom widget for left titles
//                   reservedSize: 30,
//                 ),
//               ),
//               rightTitles: AxisTitles(
//                 sideTitles: SideTitles(
//                   showTitles: false,
//                   reservedSize: 60,
//                 ),
//               ),
//             ),
//             barGroups: [
//               BarChartGroupData(x: 1, barRods: [
//                 BarChartRodData(
//                   fromY: 0,
//                   toY: week1,
//                   width: 20,
//                   color: Color(0xFF23CC71),
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//               ]),
//               BarChartGroupData(x: 2, barRods: [
//                 BarChartRodData(
//                   fromY: 0,
//                   toY: week2,
//                   width: 20,
//                   color: Color(0xFF23CC71),
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//               ]),
//               BarChartGroupData(x: 3, barRods: [
//                 BarChartRodData(
//                   fromY: 0,
//                   toY: week3,
//                   width: 20,
//                   color: Color(0xFF23CC71),
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//               ]),
//               BarChartGroupData(x: 4, barRods: [
//                 BarChartRodData(
//                   fromY: 0,
//                   toY: week4,
//                   width: 20,
//                   color: Color(0xFF23CC71),
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//               ]),
//               BarChartGroupData(x: 5, barRods: [
//                 BarChartRodData(
//                   fromY: 0,
//                   toY: week5,
//                   width: 20,
//                   color: Color(0xFF23CC71),
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//               ]),
//             ]),
//       ),
//     );
//   }
// }

// Widget getBottomTitles(double value, TitleMeta meta) {
//   const style =
//       TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12);

//   Widget text;
//   switch (value.toInt()) {
//     case 1:
//       text = const Text('Week 1', style: style);
//       break;
//     case 2:
//       text = const Text('Week 2', style: style);
//       break;
//     case 3:
//       text = const Text('Week 3', style: style);
//       break;
//     case 4:
//       text = const Text('Week 4', style: style);
//       break;
//     case 5:
//       text = const Text('Week 5', style: style);
//       break;
//     default:
//       text = const Text('', style: style);
//       break;
//   }
//   return SideTitleWidget(
//     axisSide: meta.axisSide,
//     child: text,
//   );
// }

// String getFormattedValue(double value) {
//   // Format the value similar to how fl_chart does it
//   if (value >= 1000) {
//     return '${(value / 1000).toStringAsFixed(1)}k'; // Convert to k format
//   }
//   return value.toString(); // Return as is for lower values
// }

// Widget getLeftTitles(double value, TitleMeta meta) {
//   return Text(
//     getFormattedValue(value), // Use the custom formatting function
//     style: const TextStyle(
//       color: Colors.black, // Set your desired text color
//       fontSize: 11, // Set the desired smaller font size
//       fontWeight: FontWeight.normal, // Keep the default font weight
//     ),
//   );
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyBarGraphweek extends StatefulWidget {
  @override
  _MyBarGraphweekState createState() => _MyBarGraphweekState();
}

class _MyBarGraphweekState extends State<MyBarGraphweek> {
  List<double> weekExpenses = [0, 0, 0, 0, 0];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 50), () {
      getExpensesForMonth();
    });
  }

  void updateBarGraph(List<double> newWeekExpenses) {
    setState(() {
      weekExpenses = newWeekExpenses;
    });
  }

  Future<void> getExpensesForMonth() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    DateTime now = DateTime.now();
    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
    DateTime lastDayOfMonth =
        DateTime(now.year, now.month + 1, 0); // Last day of the current month

    try {
      // print("Querying for expenses in the current month");

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .collection('expenses')
          .where('timestamp',
              isGreaterThanOrEqualTo: firstDayOfMonth.millisecondsSinceEpoch)
          .where('timestamp',
              isLessThanOrEqualTo: lastDayOfMonth.millisecondsSinceEpoch)
          .orderBy("timestamp", descending: false)
          .get();

      List<double> tempWeekExpenses = [
        0,
        0,
        0,
        0,
        0
      ]; // One entry for each week

      snapshot.docs.forEach((expenseDoc) {
        int expenseTimestamp = expenseDoc['timestamp'];
        double expenseAmount = (expenseDoc['amount'] as num).toDouble();
        DateTime expenseDate =
            DateTime.fromMillisecondsSinceEpoch(expenseTimestamp);

        int weekOfMonth = getWeekOfMonth(expenseDate);
        if (weekOfMonth >= 1 && weekOfMonth <= 5) {
          tempWeekExpenses[weekOfMonth - 1] += expenseAmount;
        }
      });

      // Update the bar graph with the new weekly values
      updateBarGraph(tempWeekExpenses);
    } catch (e) {
      print('Error fetching expenses: $e');
    }
  }

  int getWeekOfMonth(DateTime date) {
    int dayOfMonth = date.day;
    int firstDayOfMonthWeekday = DateTime(date.year, date.month, 1).weekday;

    // Calculate week of the month (ISO 8601 starts Monday as weekday 1)
    int adjustedDayOfMonth = dayOfMonth + (firstDayOfMonthWeekday - 1);
    return ((adjustedDayOfMonth) / 7).ceil();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BarChart(
        BarChartData(
            gridData: const FlGridData(show: false),
            borderData: FlBorderData(show: false),
            titlesData: const FlTitlesData(
              show: true,
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: getBottomTitles,
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: getLeftTitles,
                  reservedSize: 30,
                ),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                  reservedSize: 60,
                ),
              ),
            ),
            barGroups: List.generate(weekExpenses.length, (i) {
              return BarChartGroupData(x: i + 1, barRods: [
                BarChartRodData(
                  fromY: 0,
                  toY: weekExpenses[i],
                  width: 25,
                  color: const Color(0xFF23CC71),
                  borderRadius: BorderRadius.circular(4),
                ),
              ]);
            })),
      ),
    );
  }
}

Widget getBottomTitles(double value, TitleMeta meta) {
  const style =
      TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12);

  Widget text;
  switch (value.toInt()) {
    case 1:
      text = const Text('Week 1', style: style);
      break;
    case 2:
      text = const Text('Week 2', style: style);
      break;
    case 3:
      text = const Text('Week 3', style: style);
      break;
    case 4:
      text = const Text('Week 4', style: style);
      break;
    case 5:
      text = const Text('Week 5', style: style);
      break;
    default:
      text = const Text('', style: style);
      break;
  }
  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: text,
  );
}

String getFormattedValue(double value) {
  if (value >= 1000) {
    return '${(value / 1000).toStringAsFixed(1)}k'; // Convert to k format
  }
  return value.toString(); // Return as is for lower values
}

Widget getLeftTitles(double value, TitleMeta meta) {
  return Text(
    getFormattedValue(value),
    style: const TextStyle(
      color: Colors.black,
      fontSize: 11,
      fontWeight: FontWeight.normal,
    ),
  );
}
