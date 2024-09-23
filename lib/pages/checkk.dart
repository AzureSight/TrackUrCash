import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class checkk extends StatefulWidget {
  const checkk({Key? key}) : super(key: key);

  @override
  State<checkk> createState() => _checkkState();
}

class _checkkState extends State<checkk> {
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('signed in as: ' + user.email!),
          MaterialButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            child: Text('signout'),
          )
        ],
      )),
    );
  }
}
