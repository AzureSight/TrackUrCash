import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject_cst9l/BottomNavigation.dart';
import 'package:finalproject_cst9l/auth/authpage.dart';
import 'package:finalproject_cst9l/pages/Dashboard.dart';
import 'package:finalproject_cst9l/pages/Profile.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class authenticator extends StatefulWidget {
  const authenticator({Key? key}) : super(key: key);

  @override
  State<authenticator> createState() => _authenticatorState();
}

Future<String> getUserName(User user) async {
  if (user.displayName != null) {
    return user.displayName!; // Return Google Display Name if available
  }

  // If the user doesn't have a display name (non-Google users), fetch from Firestore
  try {
    DocumentSnapshot userDocument = await FirebaseFirestore.instance
        .collection("Users")
        .doc(user.uid)
        .get();

    if (userDocument.exists) {
      // Fetch 'name' from Firestore
      Map<String, dynamic> userData =
          userDocument.data() as Map<String, dynamic>;
      return userData['name'] ??
          'Guest'; // If 'name' is not found, return 'Guest'
    } else {
      return 'Guest'; // If user document does not exist, return 'Guest'
    }
  } catch (e) {
    print('Error retrieving user data from Firestore: $e');
    return 'Guest'; // In case of an error, return 'Guest'
  }
}

Future<String> userprofile() async {
  final user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    try {
      // Retrieve the document for the current user from the 'Users' collection
      DocumentSnapshot userDocument = await FirebaseFirestore.instance
          .collection("Users")
          .doc(user.uid)
          .get();

      // Check if the document exists
      if (userDocument.exists) {
        Map<String, dynamic> userData =
            userDocument.data() as Map<String, dynamic>;

        // Set the user profile data
        Profile profile = const Profile();
        profile.setname(userData['name']);
        profile.setemail(userData['email']);

        // Return the 'name' field from the document
        return userData['name'] as String;
      } else {
        // Return a default value if the document doesn't exist
        print("No user document found");
        return "Unknown User";
      }
    } catch (e) {
      // Handle any errors that occur during data retrieval
      print("Error retrieving data: $e");
      return "Error retrieving user data";
    }
  } else {
    // Return "Guest" if the user is not logged in
    print("User not logged in");
    return "Guest";
  }
}

class _authenticatorState extends State<authenticator> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong!'));
          }

          // if (snapshot.hasData) {
          //   User? user = snapshot.data;
          //   // Fetch user name (either from Google or Firestore)
          //   return FutureBuilder<String>(
          //     future: getUserName(user!),
          //     builder: (context, nameSnapshot) {
          //       if (nameSnapshot.connectionState == ConnectionState.waiting) {
          //         return const Center(child: CircularProgressIndicator());
          //       } else if (nameSnapshot.hasError) {
          //         return const Center(child: Text('Error loading user data'));
          //       }

          //       // String userName = nameSnapshot.data ?? 'Guest';
          //       userprofile().then((userName) {
          //         // Show success message (SnackBar) after user is authenticated
          //         Future.delayed(Duration.zero, () {
          //           ScaffoldMessenger.of(context).showSnackBar(
          //             SnackBar(
          //               content: Text('Successfully signed in, $userName!'),
          //               duration: const Duration(seconds: 3),
          //             ),
          //           );
          //         });
          //       }).catchError((error) {
          //         print("Error: $error");
          //       });
          //       // Return the main content (Dashboard)
          //       return NavigatorBar();
          //     },
          //   );
          // } else {
          //   // If not authenticated, show the login page
          //   return const authpage();
          // }

          if (snapshot.hasData) {
            User? user = snapshot.data;

            return FutureBuilder<String>(
              future: userprofile(),
              builder: (context, nameSnapshot) {
                if (nameSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (nameSnapshot.hasError) {
                  return const Center(child: Text('Error loading user data'));
                }

                Future.delayed(Duration.zero, () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('Successfully signed in, ${nameSnapshot.data}!'),
                      duration: const Duration(seconds: 3),
                    ),
                  );
                });

                return NavigatorBar();
              },
            );
          } else {
            return const authpage();
          }
        },
      ),
    );
  }
}
