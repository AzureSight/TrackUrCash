import 'package:finalproject_cst9l/BottomNavigation.dart';
import 'package:finalproject_cst9l/auth/authpage.dart';
import 'package:finalproject_cst9l/pages/Dashboard.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class authenticator extends StatefulWidget {
  const authenticator({Key? key}) : super(key: key);

  @override
  State<authenticator> createState() => _authenticatorState();
}

class _authenticatorState extends State<authenticator> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong!'),
            );
          }
          if (snapshot.hasData) {
            return NavigatorBar();
          } else {
            return const authpage();
          }
        },
      ),
    );
  }
}
