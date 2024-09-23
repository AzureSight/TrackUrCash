import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  //GET COLLECTION OF NOTES
  final CollectionReference notes =
      FirebaseFirestore.instance.collection('expenses');
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('Users');

  //Future<void> addTask(String taskName) async {
  // if (user != null) {
  // } else {
  //   // User is not logged in
  //   // Handle this case as needed
  // }

  //CREATE: add a new note

  Future<void> addExpenseDetail(String note, int amount) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    String uid = user!.uid;
    return notes.add({
      'UID': uid,
      'note': note,
      'amount': amount,
      'timestamp': Timestamp.now()
    });
  }

  Future<void> addAmount(int note) {
    return notes.add({'note': note, 'timestamp': Timestamp.now()});
  }

  //READ: get notes from database
  Stream<QuerySnapshot> getNotesStream() {
    final notesStream =
        notes.orderBy('timestamp', descending: true).snapshots();

    return notesStream;
  }

  Future addexpense() async {}

  addUser() {}

  Future<void> createUser(
      String username, String email /* add other necessary data */) async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      await usersCollection.doc(uid).set({
        'name': username,
        'email': email,
        // Add other necessary fields
      });
      print('User added to Firestore');
    } catch (e) {
      print('Error adding user to Firestore: $e');
      throw e; // Handle this error as needed
    }
  }
  //UPDATE: update notes given a doc id

  //DELETE: delete notes given a doc id
}

getNotesStream() {}
