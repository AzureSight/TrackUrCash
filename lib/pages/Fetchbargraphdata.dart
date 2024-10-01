import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyBarGraph extends StatefulWidget {
  @override
  _MyBarGraphState createState() => _MyBarGraphState();
}

class _MyBarGraphState extends State<MyBarGraph> {
  double sun = 0;
  double mon = 0;
  double tue = 0;
  double wed = 0;
  double thur = 0;
  double fri = 0;
  double sat = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      getExpensesForCurrentWeek();
    }); // Fetch the expenses when the widget is initialized
  }

  void updateBarGraph(double newMon, double newTue, double newWed,
      double newThur, double newFri, double newSat, double newSun) {
    setState(() {
      mon = newMon;
      tue = newTue;
      wed = newWed;
      thur = newThur;
      fri = newFri;
      sat = newSat;
      sun = newSun;
    });
  }

  Future<void> getExpensesForCurrentWeek() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    DateTime now = DateTime.now(); // Local time

    DateTime startOfThisWeek = DateTime(now.year, now.month, now.day).subtract(
        Duration(days: now.weekday - 1)); // Move back to Monday at 12:00 AM
    print(startOfThisWeek);

    DateTime endOfThisWeek = startOfThisWeek
        .add(Duration(days: 6, hours: 23, minutes: 59, seconds: 59));
    print(endOfThisWeek);

    // DateTime startOfThisWeekUTC = startOfThisWeek.toUtc();
    // DateTime endOfThisWeekUTC = endOfThisWeek.toUtc();
    // print(startOfThisWeekUTC);
    // print(endOfThisWeekUTC);
    try {
      print("Querying for expenses");

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

      // Process snapshot as usual

      double tempMon = 0,
          tempTue = 0,
          tempWed = 0,
          tempThur = 0,
          tempFri = 0,
          tempSat = 0,
          tempSun = 0;

      snapshot.docs.forEach((expenseDoc) {
        int expenseTimestamp = expenseDoc['timestamp'];
        double expenseAmount = (expenseDoc['amount'] as num).toDouble();

        DateTime expenseDate =
            DateTime.fromMillisecondsSinceEpoch(expenseTimestamp);

        switch (expenseDate.weekday) {
          case DateTime.monday:
            tempMon += expenseAmount;
            print("tempMon: $tempMon");
            break;
          case DateTime.tuesday:
            tempTue += expenseAmount;
            break;
          case DateTime.wednesday:
            tempWed += expenseAmount;
            break;
          case DateTime.thursday:
            tempThur += expenseAmount;
            break;
          case DateTime.friday:
            tempFri += expenseAmount;
            break;
          case DateTime.saturday:
            tempSat += expenseAmount;
            break;
          case DateTime.sunday:
            tempSun += expenseAmount;
            print("tempSun: $tempSun");
            break;
          default:
            break;
        }
      });

      // Update the bar graph with the new values
      updateBarGraph(
          tempMon, tempTue, tempWed, tempThur, tempFri, tempSat, tempSun);
    } catch (e) {
      print('Error fetching expenses: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  showTitles: true,
                  getTitlesWidget: getBottomTitles,
                ),
              ),
            ),
            barGroups: [
              BarChartGroupData(x: 1, barRods: [
                BarChartRodData(
                  fromY: 0,
                  toY: mon,
                  width: 20,
                  color: Color(0xFF23CC71),
                  borderRadius: BorderRadius.circular(4),
                ),
              ]),
              BarChartGroupData(x: 2, barRods: [
                BarChartRodData(
                  fromY: 0,
                  toY: tue,
                  width: 20,
                  color: Color(0xFF23CC71),
                  borderRadius: BorderRadius.circular(4),
                ),
              ]),
              BarChartGroupData(x: 3, barRods: [
                BarChartRodData(
                  fromY: 0,
                  toY: wed,
                  width: 20,
                  color: Color(0xFF23CC71),
                  borderRadius: BorderRadius.circular(4),
                ),
              ]),
              BarChartGroupData(x: 4, barRods: [
                BarChartRodData(
                  fromY: 0,
                  toY: thur,
                  width: 20,
                  color: Color(0xFF23CC71),
                  borderRadius: BorderRadius.circular(4),
                ),
              ]),
              BarChartGroupData(x: 5, barRods: [
                BarChartRodData(
                  fromY: 0,
                  toY: fri,
                  width: 20,
                  color: Color(0xFF23CC71),
                  borderRadius: BorderRadius.circular(4),
                ),
              ]),
              BarChartGroupData(x: 6, barRods: [
                BarChartRodData(
                  fromY: 0,
                  toY: sat,
                  width: 20,
                  color: Color(0xFF23CC71),
                  borderRadius: BorderRadius.circular(4),
                ),
              ]),
              BarChartGroupData(x: 7, barRods: [
                BarChartRodData(
                  fromY: 0,
                  toY: sun,
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
