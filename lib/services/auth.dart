import 'package:finalproject_cst9l/services/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authservice {
  createuser(data, context) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: data['email'],
        password: data['password'],
      );
      await FirestoreService().createUser(data['name'], data['email']);

      // var Db = db();
      // await Db.addUser(data);
      // Navigator.of(context).pushReplacement(
      //     MaterialPageRoute(builder: ((context) => Dashboard())));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-psassword') {
        print('Weak password');
      } else if (e.code == 'email-already-in-use') {
        print('Email Already in Use');
      } else if (e.code == 'invalid-email') {
        print('Invalid email format.');
      } else {
        print('An error has occured');
      }
    }
  }
}
// on FirebaseAuthException catch (e) {
//       if (e.code == 'weak-psassword') {
//         print('Weak password');
//       } else if (e.code == 'email-already-in-use') {
//         print('Email Already in Use');
//       } else if (e.code == 'invalid-email') {
//         print('Invalid email format.');
//       } else {
//         print('An error has occured');
//       }

// showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: Text("Signup failed"),
//             content: Text(e.toString()),
//           );
//         },
//       );