import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class db {
  CollectionReference Users = FirebaseFirestore.instance.collection('Users');
  final uid = FirebaseAuth.instance.currentUser!.uid;
  Future<void> addUser(data, context) {
    return Users.doc(uid)
        .set(data)
        .then((value) => print("User Added"))
        .catchError((error) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("sign up failed"),
              content: Text(error.toString()),
            );
          });
    });
  }
}
