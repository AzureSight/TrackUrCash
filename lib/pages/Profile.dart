import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject_cst9l/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// import 'package:finalproject_cst9l/main.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();

  void setname(String name) {
    userName = name; // Assign the new value to the private variable
  }

  void setemail(String nemail) {
    email = nemail; // Assign the new value to the private variable
  }
}

String userName = "";
String email = "";

Future<void> userdetails() async {
  final user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    try {
      // Retrieve all documents from the 'Users' collection
      DocumentSnapshot userDocument = await FirebaseFirestore.instance
          .collection("Users")
          .doc(user.uid)
          .get();

      // Iterate through each document in the collection
      if (userDocument.exists) {
        Map<String, dynamic> userData =
            userDocument.data() as Map<String, dynamic>;
        // Retrieve 'name' field from the document
        userName = userData['name'];
        email = userData['email'];
        // Here, you might want to match the user ID with the current user's ID
      }
    } catch (e) {
      print("Error retrieving data: $e");
    }
  } else {
    print("User not logged in");
  }
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    super.initState();
    userdetails();
  }

  int _currentPage = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF23cc71),
        automaticallyImplyLeading: false,
        title: const Text(
          'Profile',
          style: TextStyle(
            fontFamily: 'Ubuntu',
            color: Colors.white,
            fontSize: 35,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: const [],
        centerTitle: false,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //INFORMATION CONTAINER HERE
            Align(
              alignment: const AlignmentDirectional(0.00, 0.00),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 60, 0, 10),
                child: Container(
                  width: 350,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 4,
                        color: Color(0x33000000),
                        offset: Offset(0, 2),
                        spreadRadius: 2,
                      )
                    ],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.white,
                      width: 0,
                    ),
                  ),
                  child: Align(
                    alignment: const AlignmentDirectional(-1.00, -1.00),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const SizedBox(height: 15),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey.shade300, width: 2),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(100)),
                            ),
                            child: ClipOval(
                              child: Image.network(
                                "https://image.winudf.com/v2/image1/bmV0LndsbHBwci5ib3lzX3Byb2ZpbGVfcGljdHVyZXNfc2NyZWVuXzJfMTY2NzUzNzYxOF8wNDY/screen-2.webp?fakeurl=1&type=.webp",
                                width: 125,
                                height: 125,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const SizedBox(
                            width: 200,
                            child: Divider(
                              color: Color.fromARGB(221, 85, 85, 85),
                              thickness: 0.5,
                            ),
                          ),
                          Container(
                            alignment: const AlignmentDirectional(0, 0),
                            // decoration: BoxDecoration(
                            //   border: Border.all(
                            //       color: Colors.grey.shade300, width: 2),
                            //   borderRadius: BorderRadius.circular(12),
                            // ),
                            padding: const EdgeInsets.all(16),
                            child: const Text(
                              '"A little saved today builds a lot for tomorrow."',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(height: 80),
                          itemProfile(
                              'Name', userName, CupertinoIcons.person_circle),
                          const SizedBox(
                            height: 20,
                          ),
                          itemProfile(
                            'Email',
                            email,
                            CupertinoIcons.mail,
                          ),
                          const SizedBox(height: 40),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 80, 0, 0),
                            child: Container(
                              width: MediaQuery.sizeOf(context).width,
                              height: 100,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 20, 20, 20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(5, 5, 5, 5),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          // print('Button pressed baa...');

                                          FirebaseAuth.instance.signOut();
                                          navigatorkey.currentState!.popUntil(
                                              (route) => route.isFirst);
                                          //     Navigator.pop(context);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFF4B39EF),
                                          padding: const EdgeInsets.fromLTRB(
                                              24, 0, 24, 0),
                                          fixedSize: const Size(200, 50),
                                        ),
                                        child: const Text(
                                          'Logout',
                                          style: TextStyle(
                                            fontFamily: 'Ubuntu',
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 22,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      //   child: GNav(
      //     selectedIndex: _currentPage,
      //     onTabChange: (index) {
      //       setState(() {
      //         _currentPage = index;
      //       });
      //       // Navigate to the corresponding page
      //       switch (index) {
      //         case 0:
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(builder: (context) => const Expenses()),
      //           );
      //           break;

      //         case 1:
      //           Navigator.push(context,
      //               MaterialPageRoute(builder: (context) => const Dashboard()));
      //           break;

      //         case 2:
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(builder: (context) => const Budget()),
      //           );
      //           break;

      //         case 3:
      //           // Profile page (current page)
      //           break;
      //       }
      //     },
      //     backgroundColor: Colors.white,
      //     color: Colors.grey,
      //     activeColor: Color(0xFF6F61EF),
      //     // tabActiveBorder: Border.all(
      //     //   color: Color(0xFF6F61EF),
      //     //   width: 2.0,
      //     // ),
      //     gap: 8,
      //     iconSize: 35,
      //     padding: EdgeInsets.all(16),
      //     tabs: [
      //       GButton(
      //         icon: Icons.dashboard,
      //         text: 'Dashboard',
      //         textStyle: TextStyle(
      //           fontFamily: 'Ubuntu',
      //           fontWeight: FontWeight.bold,
      //           fontSize: 18,
      //           color: Color(0xFF6F61EF),
      //         ),
      //       ),
      //       GButton(
      //         icon: Icons.wallet,
      //         text: 'Expenses',
      //         textStyle: TextStyle(),
      //       ),
      //       GButton(
      //         icon: Icons.savings_rounded,
      //         text: 'Budget',
      //         textStyle: TextStyle(),
      //       ),
      //       GButton(
      //         icon: Icons.person_2_rounded,
      //         text: 'Profile',
      //         textStyle: TextStyle(
      //           fontFamily: 'Ubuntu',
      //           fontWeight: FontWeight.bold,
      //           fontSize: 15,
      //           color: Color(0xFF6F61EF),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),

      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: _currentPage,
      //   onTap: (int newPage) {
      //     setState(() {
      //       _currentPage = newPage;
      //     });
      //     // Navigate to the corresponding page
      //     switch (newPage) {
      //       case 0:
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(builder: (context) => const Expenses()),
      //         );
      //         break;

      //       case 1:
      //         Navigator.push(context,
      //             MaterialPageRoute(builder: (context) => const Dashboard()));
      //         break;

      //       case 2:
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(builder: (context) => const Budget()),
      //         );
      //         break;

      //       case 3:
      //         // Profile page (current page)
      //         break;
      //     }
      //   },
      //   items: const [
      //     BottomNavigationBarItem(
      //       label: 'Expenses',
      //       icon: Icon(
      //         Icons.wallet_rounded,
      //         size: 32,
      //         color: Color(0xFF8A000000),
      //       ),
      //     ),
      //     BottomNavigationBarItem(
      //       label: 'Home',
      //       icon: Icon(
      //         Icons.home_rounded,
      //         size: 32,
      //         color: Color(0xFF8A000000),
      //       ),
      //     ),
      //     BottomNavigationBarItem(
      //       label: 'Budget',
      //       icon: Icon(
      //         Icons.savings_rounded,
      //         size: 32,
      //         color: Color(0xFF8A000000),
      //       ),
      //     ),
      //     BottomNavigationBarItem(
      //       label: 'Profile',
      //       icon: Icon(
      //         Icons.person_2_rounded,
      //         size: 32,
      //         color: Color(0xFF6F61EF),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}

itemProfile(String title, String subtitle, IconData iconData) {
  return Container(
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
              offset: const Offset(0, 5),
              color: Color(0xFF4B39EF).withOpacity(.2),
              spreadRadius: 5,
              blurRadius: 10),
        ]),
    child: ListTile(
      title: Text(
        title,
        style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
            fontFamily: 'Ubuntu',
            color: Colors.black87),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontFamily: 'Ubuntu'),
      ),
      leading: Icon(
        iconData,
        size: 30,
        color: Colors.black54,
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios_rounded,
        color: Colors.grey,
      ),
      tileColor: Colors.white,
    ),
  );
}
