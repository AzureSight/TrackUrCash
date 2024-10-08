import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject_cst9l/pages/Profile.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // Singleton pattern to ensure only one instance of AuthService is created
  static final AuthService _instance = AuthService._internal();

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

  // FirebaseAuth instance
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // GoogleSignIn instance
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Method to handle Google Sign-In
  // signInWithGoogle() async {
  //   try {
  //     // Attempt to sign in with Google
  //     final GoogleSignInAccount? gUser = await _googleSignIn.signIn();
  //     if (gUser == null) return;

  //     final GoogleSignInAuthentication gAuth = await gUser.authentication;

  //     final cred = GoogleAuthProvider.credential(
  //       accessToken: gAuth.accessToken,
  //       idToken: gAuth.idToken,
  //     );
  //     return await _firebaseAuth.signInWithCredential(cred);
  //   } catch (e) {
  //     // Handle error (log, show message, etc.)
  //     print('Error during Google sign-in: $e');
  //     return null;
  //   }
  // }

  // Future<User?> signInWithGoogle() async {
  //   try {
  //     // Attempt to sign in with Google
  //     final GoogleSignInAccount? gUser = await _googleSignIn.signIn();

  //     if (gUser == null) return null; // If sign-in is canceled, return null.

  //     final GoogleSignInAuthentication gAuth = await gUser.authentication;

  //     // Create credentials for Firebase authentication using Google sign-in tokens.
  //     final AuthCredential cred = GoogleAuthProvider.credential(
  //       accessToken: gAuth.accessToken,
  //       idToken: gAuth.idToken,
  //     );

  //     // Sign in to Firebase with the generated credentials.
  //     UserCredential userCredential =
  //         await _firebaseAuth.signInWithCredential(cred);
  //     User? user = userCredential.user;

  //     // Now retrieve the name and email directly from Google and Firebase user
  //     if (user != null) {
  //       // Google user info (retrieved directly from GoogleSignInAccount)
  //       String? googleName = gUser.displayName;
  //       String? googleEmail = gUser.email;

  //       // Firebase user info (retrieved directly from FirebaseUser object)
  //       String? firebaseName = user.displayName;
  //       String? firebaseEmail = user.email;

  //       // Assuming you have a Profile class to store this information
  //       Profile profile = Profile();
  //       profile.setname(googleName ?? firebaseName ?? 'No Name');
  //       profile.setemail(googleEmail ?? firebaseEmail ?? 'No Email');

  //       await saveUserToFirestore(user);
  //     } else {
  //       print("Sign-in failed: No user returned.");
  //     }

  //     return user; // Return the authenticated Firebase user.
  //   } catch (e) {
  //     // Handle any errors during the sign-in process.
  //     print('Error during Google sign-in: $e');
  //     return null;
  //   }
  // }
  Future<bool> doesEmailExistInFirestore(String email) async {
    try {
      // Query Firestore to check if the email exists in the users collection
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Users') // Assuming you store users in this collection
          .where('email', isEqualTo: email)
          .get();

      // If any document exists with this email, it means the email is already registered
      if (querySnapshot.docs.isNotEmpty) {
        print("Email exists in Firestore: $email");
        return true;
      } else {
        print("No account found for this email in Firestore.");
        return false;
      }
    } catch (e) {
      print("Error checking email in Firestore: $e");
      return false;
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      // Attempt to sign in with Google
      final GoogleSignInAccount? gUser = await _googleSignIn.signIn();

      if (gUser == null) return null; // If sign-in is canceled, return null.

      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      // Get the email from GoogleSignInAccount
      String? googleEmail = gUser.email;

      // Check if the user exists in Firebase Authentication
      // final signInMethods =
      //     await _firebaseAuth.fetchSignInMethodsForEmail(googleEmail);

      // print(
      //     'Sign-in methods for $googleEmail: $signInMethods'); // DEBUG: Print the sign-in methods

      // if (signInMethods.isEmpty) {
      //   // No account found for this email, sign out from Google to prompt again next time
      //   print('No account found for this email in Firebase Authentication.');
      //   await _googleSignIn
      //       .signOut(); // This forces the sign-in flow to prompt again next time
      //   return null;
      // }
      bool emailExistsInFirestore =
          await doesEmailExistInFirestore(googleEmail);

      if (!emailExistsInFirestore) {
        await _googleSignIn.signOut();
        return null;
      } else {
        // Create credentials for Firebase authentication using Google sign-in tokens
        final AuthCredential cred = GoogleAuthProvider.credential(
          accessToken: gAuth.accessToken,
          idToken: gAuth.idToken,
        );
        // Sign in to Firebase with the generated credentials
        UserCredential userCredential =
            await _firebaseAuth.signInWithCredential(cred);

        User? user = userCredential.user;

        // Now retrieve the name and email directly from Google and Firebase user
        if (user != null) {
          // Google user info (retrieved directly from GoogleSignInAccount)
          String? googleName = gUser.displayName;

          // Firebase user info (retrieved directly from FirebaseUser object)
          String? firebaseName = user.displayName;

          // Assuming you have a Profile class to store this information
          Profile profile = Profile();
          profile.setname(googleName ?? firebaseName ?? 'No Name');
          profile.setemail(googleEmail ?? firebaseName ?? 'No Email');

          await saveUserToFirestore(user);
        } else {
          print("Sign-in failed: No user returned.");
        }

        return user; // Return the authenticated Firebase user.
      }
    } catch (e) {
      // Handle any errors during the sign-in process.
      print('Error during Google sign-in: $e');
      return null;
    }
  }

  Future<User?> signUPWithGoogle() async {
    try {
      // Attempt to sign in with Google
      final GoogleSignInAccount? gUser = await _googleSignIn.signIn();

      if (gUser == null) return null; // If sign-in is canceled, return null.

      final GoogleSignInAuthentication gAuth = await gUser.authentication;
      String? googleEmail = gUser.email;
      // Check if the Google email is already in use by another Firebase account
      bool emailExistsInFirestore =
          await doesEmailExistInFirestore(googleEmail);
      // Check if Google is one of the sign-in methods for this email
      if (!emailExistsInFirestore) {
        // If no Firebase account exists for the email, proceed with sign-up
        final AuthCredential cred = GoogleAuthProvider.credential(
          accessToken: gAuth.accessToken,
          idToken: gAuth.idToken,
        );

        UserCredential userCredential =
            await _firebaseAuth.signInWithCredential(cred);
        User? user = userCredential.user;

        // Now retrieve the name and email directly from Google and Firebase user
        if (user != null) {
          // Google user info (retrieved directly from GoogleSignInAccount)
          String? googleName = gUser.displayName;
          String? googleEmail = gUser.email;

          // Firebase user info (retrieved directly from FirebaseUser object)
          String? firebaseName = user.displayName;
          String? firebaseEmail = user.email;

          // Assuming you have a Profile class to store this information
          Profile profile = Profile();
          profile.setname(googleName ?? firebaseName ?? 'No Name');
          profile.setemail(googleEmail ?? firebaseEmail ?? 'No Email');

          // Save the user to Firestore
          await saveUserToFirestore(user);
        } else {
          print("Sign-in failed: No user returned.");
        }

        return user; // Return the authenticated Firebase user.
      } else {
        await _googleSignIn.signOut();
        return null;
      }
    } catch (e) {
      print('Error during Google sign-in: $e');
      return null;
    }
  }

  Future<void> saveUserToFirestore(User user) async {
    try {
      // Get reference to Firestore collection
      CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('Users');

      // Prepare user data to save
      Map<String, dynamic> userData = {
        'name': user.displayName ?? 'No Name',
        'email': user.email ?? 'No Email',
      };

      // Save user data to Firestore
      await usersCollection.doc(user.uid).set(userData);

      print("User saved to Firestore: ${user.displayName}");
    } catch (e) {
      print('Error saving user to Firestore: $e');
    }
  }

  // Method to sign out from Google and Firebase
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
    } catch (e) {
      print('Error during sign-out: $e');
    }
  }

  // Check if a user is signed in
  User? get currentUser {
    return _firebaseAuth.currentUser;
  }

  // Stream to listen for authentication state changes
  Stream<User?> get authStateChanges {
    return _firebaseAuth.authStateChanges();
  }
}
