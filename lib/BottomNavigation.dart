import 'package:finalproject_cst9l/pages/Budget.dart';
import 'package:finalproject_cst9l/pages/Dashboard.dart';
import 'package:finalproject_cst9l/pages/Expenses.dart';
import 'package:finalproject_cst9l/pages/Profile.dart';

import 'package:flutter/material.dart';

class NavigatorBar extends StatefulWidget {
  NavigatorBar({super.key});

  @override
  State<NavigatorBar> createState() => _NavigatorBarState();
}

class _NavigatorBarState extends State<NavigatorBar> {
  int selectedPage = 0;
  static const IconData account_balance_wallet =
      IconData(0xe041, fontFamily: 'MaterialIcons');
  static const IconData account_circle_rounded =
      IconData(0xf522, fontFamily: 'MaterialIcons');
  void tapped(int index) {
    setState(() {
      selectedPage = index;
    });
  }

  var pages = [const Dashboard(), const Expenses(), Budget(), const Profile()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedPage],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet),
            label: 'Expenses',
          ),
          BottomNavigationBarItem(
            icon: Icon(account_balance_wallet),
            label: 'Budget',
          ),
          BottomNavigationBarItem(
            icon: Icon(account_circle_rounded),
            label: 'Profile',
          )
        ],
        currentIndex: selectedPage,
        onTap: tapped,
        selectedItemColor: Color.fromARGB(
            255, 31, 178, 100), // Set your desired color for selected icons
        unselectedItemColor:
            Colors.grey, // Set your desired color for unselected icons
      ),
    );
  }
}
