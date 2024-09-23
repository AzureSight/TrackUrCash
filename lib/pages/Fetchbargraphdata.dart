import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyBarGraph extends StatelessWidget {
  final double sun;
  final double sat;
  final double fri;
  final double thur;
  final double wed;
  final double tue;
  final double mon;

  MyBarGraph({
    required this.sun,
    required this.sat,
    required this.fri,
    required this.thur,
    required this.wed,
    required this.tue,
    required this.mon,
  });

  @override
  Widget build(BuildContext context) {
    double Suns = sun;
    double Sat = sat;
    double Fri = fri;
    double Thur = thur;
    double Wed = wed;
    double Tue = tue;
    double Mon = mon;
    return Scaffold(
      backgroundColor: Colors.white,
      body: BarChart(
        BarChartData(
            gridData: FlGridData(show: false),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              show: true,
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true, getTitlesWidget: getBottomTitles),
              ),
            ),
            barGroups: [
              BarChartGroupData(x: 1, barRods: [
                BarChartRodData(
                  fromY: 0,
                  toY: Mon,
                  width: 20,
                  color: Color(0xFF23CC71),
                  borderRadius: BorderRadius.circular(4),
                ),
              ]),
              BarChartGroupData(x: 2, barRods: [
                BarChartRodData(
                  fromY: 0,
                  toY: Tue,
                  width: 20,
                  color: Color(0xFF23CC71),
                  borderRadius: BorderRadius.circular(4),
                ),
              ]),
              BarChartGroupData(x: 3, barRods: [
                BarChartRodData(
                  fromY: 0,
                  toY: Wed,
                  width: 20,
                  color: Color(0xFF23CC71),
                  borderRadius: BorderRadius.circular(4),
                ),
              ]),
              BarChartGroupData(x: 4, barRods: [
                BarChartRodData(
                  fromY: 0,
                  toY: Thur,
                  width: 20,
                  color: Color(0xFF23CC71),
                  borderRadius: BorderRadius.circular(4),
                ),
              ]),
              BarChartGroupData(x: 5, barRods: [
                BarChartRodData(
                  fromY: 0,
                  toY: Fri,
                  width: 20,
                  color: Color(0xFF23CC71),
                  borderRadius: BorderRadius.circular(4),
                ),
              ]),
              BarChartGroupData(x: 6, barRods: [
                BarChartRodData(
                  fromY: 0,
                  toY: Sat,
                  width: 20,
                  color: Color(0xFF23CC71),
                  borderRadius: BorderRadius.circular(4),
                ),
              ]),
              BarChartGroupData(x: 7, barRods: [
                BarChartRodData(
                  fromY: 0,
                  toY: Suns,
                  width: 20,
                  color: Color(0xFF23CC71),
                  borderRadius: BorderRadius.circular(4),
                ),
              ]),
            ]),
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
      text = const Text('Mon', style: style);
      break;

    case 2:
      text = const Text('Tue', style: style);
      break;

    case 3:
      text = const Text('Wed', style: style);
      break;

    case 4:
      text = const Text('Thur', style: style);
      break;

    case 5:
      text = const Text('Fri', style: style);
      break;

    case 6:
      text = const Text('Sat', style: style);
      break;

    case 7:
      text = const Text('Sun', style: style);
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

// double mons = 0.0;
// double tues = 0.0;
// double weds = 0.0;
// double thurs = 0.0;
// double fris = 0.0;
// double sats = 0.0;
// double suns = 0.0;
// setvars() {
//   mons = 0.0;
//   tues = 0.0;
//   weds = 0.0;
//   thurs = 0.0;
//   fris = 0.0;
//   sats = 0.0;
//   suns = 0.0;
// }

// Future getExpensesForCurrentWeek() async {
//   final uid = FirebaseAuth.instance.currentUser!.uid;
//   DateTime now = DateTime.now();
//   DateTime startOfThisWeek = now.subtract(Duration(
//       days: now.weekday - 1)); // Assuming Monday is the start of the week
//   DateTime endOfThisWeek = startOfThisWeek.add(Duration(days: 6));
//   try {
//     QuerySnapshot snapshot = await FirebaseFirestore.instance
//         .collection('Users')
//         .doc(uid)
//         .collection('expenses')
//         .where('timestamp',
//             isGreaterThanOrEqualTo: startOfThisWeek.millisecondsSinceEpoch)
//         .where('timestamp',
//             isLessThanOrEqualTo: endOfThisWeek.millisecondsSinceEpoch)
//         .orderBy("timestamp", descending: false)
//         .get();

//     var data = snapshot.docs;

//     data.forEach((expenseDoc) {
//       int expenseTimestamp = (expenseDoc['timestamp'] as int?) ?? 0;
//       double expenseAmount = (expenseDoc['amount'] as num?)?.toDouble() ?? 0.0;

//       DateTime expenseDate =
//           DateTime.fromMillisecondsSinceEpoch(expenseTimestamp);
//       switch (expenseDate.weekday) {
//         case DateTime.monday:
//           mons += expenseAmount;
//           break;
//         case DateTime.tuesday:
//           tues += expenseAmount;
//           break;
//         case DateTime.wednesday:
//           weds += expenseAmount;
//           break;
//         case DateTime.thursday:
//           thurs += expenseAmount;
//           break;
//         case DateTime.friday:
//           fris += expenseAmount;
//           break;
//         case DateTime.saturday:
//           sats += expenseAmount;
//           break;
//         case DateTime.sunday:
//           suns += expenseAmount;
//           break;
//         default:
//           break;
//       }
//     });
//   } catch (e) {
//     print('Error: $e');
//   }
//   print(mons);
//   print(tues);
//   print(weds);
// }
