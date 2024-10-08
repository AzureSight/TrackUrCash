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

  Future<User?> signInWithGoogle() async {
    try {
      // Attempt to sign in with Google
      final GoogleSignInAccount? gUser = await _googleSignIn.signIn();

      if (gUser == null) return null; // If sign-in is canceled, return null.

      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      // Create credentials for Firebase authentication using Google sign-in tokens.
      final AuthCredential cred = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      // Sign in to Firebase with the generated credentials.
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

        await saveUserToFirestore(user);
      } else {
        print("Sign-in failed: No user returned.");
      }

      return user; // Return the authenticated Firebase user.
    } catch (e) {
      // Handle any errors during the sign-in process.
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
