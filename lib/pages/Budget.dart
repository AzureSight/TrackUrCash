// ignore: file_names

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject_cst9l/notif/notif.dart';
import 'package:finalproject_cst9l/pages/AllExpenses.dart';
import 'package:finalproject_cst9l/pages/Refreshamount.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

//import 'package:percent_indicator/linear_percent_indicator.dart';
class Budget extends StatefulWidget {
  const Budget({super.key});

  @override
  State<Budget> createState() => _BudgetState();
}

class _BudgetState extends State<Budget> {
  final GlobalKey<FormState> _keyform = GlobalKey<FormState>();
//  int _currentPage = 2;
  final TextEditingController _budgetController = TextEditingController();
  double budget = 0.0;
  var uid = Uuid();
  //DIALOG BOX TO ADD EXPENSES HERE

  // void refreshPage() {
  //   setState(() {
  //     // Update your state here to refresh the page
  //   });
  // }
  void openNoteBox() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Container(
          width: 500,
          height: 250,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //DIALOG TITLE HERE
              Container(
                height: 35,
                child: const Text(
                  'Set Budget',
                  style: TextStyle(
                    fontFamily: 'Ubuntu',
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF001F3F),
                  ),
                ),
              ),
              //END OF DIALOG TITLE
              const Divider(
                color: Colors.black87,
                thickness: 1.5,
              ),
              const SizedBox(height: 10),
              //EXPENSE AMOUNT BUDGET TEXTFIELD HERE
              Form(
                key: _keyform,
                child: TextFormField(
                  controller: _budgetController,
                  keyboardType: const TextInputType.numberWithOptions(
                      decimal: true), // Set the keyboard type to numeric
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(
                        r'^\d*\.?\d{0,2}')), // Allow up to 2 decimal places
                  ],
                  autofocus: true,
                  obscureText: false,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () {
                          _budgetController.clear();
                        },
                        icon: const Icon(Icons.clear)),
                    labelText: 'Budget',
                    labelStyle: const TextStyle(
                      fontFamily: 'Ubuntu',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    hintText: 'Set your Budget',
                    hintStyle: const TextStyle(
                      fontFamily: 'Ubuntu',
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0xFF15161E),
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0xFF23cc71),
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0xFFFF5963),
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0xFFFF5963),
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  style: const TextStyle(
                    fontFamily: 'Ubuntu',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter desired Budget';
                    }
                    return null; // Return null if the validation passes
                  },
                  // validator: _model.textController1Validator.asValidator(context),
                ),
              ),
              const SizedBox(height: 10), // Spacer
              //END OF AMOUNT BUDGET TEXTFIELD

              //ADD & CANCEL BUTTON HERE
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 110,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xFF33000000),
                          offset: Offset(0, 2),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 110,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xFF33000000),
                          offset: Offset(0, 2),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_keyform.currentState!.validate()) {
                          // Add your Elevated Button functionality here
                          submit();
                          NotificationService().checkBudget();
                          Navigator.pop(context);
                        }
                        //
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF23cc71),
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child: const Text(
                        'Set',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              //END OF ADD & CANCEL BUTTON
            ],
          ),
        ),
      ),
    ).then((value) {
      // This code executes after the dialog is closed
      // Refresh the page by calling the refresh method
      // getbudget();
      //refreshPage();
    });
  }

  Future<void> getbudget() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        // Retrieve all documents from the 'users' collection
        DocumentSnapshot userDocument = await FirebaseFirestore.instance
            .collection("Users")
            .doc(user.uid)
            .get();

        // Iterate through each document in the collection
        if (userDocument.exists) {
          Map<String, dynamic> userData =
              userDocument.data() as Map<String, dynamic>;
          // Retrieve 'name' field from the document
          //  String? userName = userData['name'];
          double newBudget = userData['budget'];
          setState(() {
            budget = newBudget; // Update the 'budget' variable
          });
          // Here, you might want to match the user ID with the current user's ID
        }
      } catch (e) {
        print("Error retrieving data: $e");
      }
    }
  }

  var reff = Refresh();
  Future<void> initializeTotal() async {
    double total = await reff.taketotal();
    tot = total;
  }

  Future<void> submit() async {
    final user = FirebaseAuth.instance.currentUser;
    // int timestamp = DateTime.now().millisecondsSinceEpoch;

    // // ignore: non_constant_identifier_names
    // var Amount = double.parse(_budgetController.text);
    // DateTime date = DateTime.now();

    if (user != null) {
      try {
        var amount = double.parse(_budgetController.text);
        var id = uid.v4();

        QuerySnapshot existingBudgets = await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .collection('budget')
            .get();

        WriteBatch batch = FirebaseFirestore.instance.batch();

        for (var doc in existingBudgets.docs) {
          batch.update(doc.reference, {'status': 'completed'});
        }

        await batch.commit();

        var data = {
          "id": id,
          "budget_amount": amount,
          "budget_desc": "last",
          "status": "active",
          "created_at": FieldValue.serverTimestamp(),
        };

        await FirebaseFirestore.instance
            .collection("Users")
            .doc(user.uid)
            .collection("budget")
            .doc(id)
            .set(data);

        _budgetController.clear();

        print("New budget added and existing budgets updated to 'completed'.");
      } catch (e) {
        print("Error retrieving data: $e");
      }
    } else {
      print("User not logged in");
    }
    initializeTotal();
    getbudget();
  }

  Future<void> submitreset() async {
    final user = FirebaseAuth.instance.currentUser;
    // int timestamp = DateTime.now().millisecondsSinceEpoch;

    // // ignore: non_constant_identifier_names

    // DateTime date = DateTime.now();

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
          String? userName = userData['name'];

          // Here, you might want to match the user ID with the current user's ID
          if (userName != null) {
            double resetbudget = 0;
            // DateTime date = DateTime.now();

            var data = {
              "email":
                  user.email ?? "", // Using email from Firebase Authentication
              "name": userName, // Using the 'name' field from Firestore
              "budget": resetbudget,
              // Other fields you want to add to Firestore
            };

            // Update Firestore document
            await FirebaseFirestore.instance
                .collection("Users")
                .doc(user.uid)
                .set(data);
            getbudget();
            _budgetController.clear();
          }
        }
      } catch (e) {
        print("Error retrieving data: $e");
      }
    } else {
      print("User not logged in");
    }
  }

  double tot = 0;

  @override
  void initState() {
    super.initState();
    initializeTotal();
    getbudget();
    NotificationService().checkBudget();
  }

  double remaining = 0.0;

  @override
  Widget build(BuildContext context) {
    if (budget == 0) {
      remaining = 0;
    } else {
      remaining = budget - tot;
    }

    double roundedRemaining = double.parse(remaining.toStringAsFixed(2));
    double savings = remaining;
    double expensePercentage = (tot / budget) * 100;
    // Lists of messages
    List<String> withinBudgetMessages = [
      "Great job! You've stayed within your budget and saved {savings} pesos.",
      "Awesome work! You also saved {savings} pesos. Keep it up!",
      "You're doing fantastic! You've managed to save {savings} pesos. Save it for something bigger!"
    ];

    List<String> exceedBudgetMessages = [
      "Uh-oh! Your expenses have exceeded your budget.",
      "Looks like you're over your budget.",
      "Your current expenses are over your budget limit. Don’t worry!"
    ];

    // Function to get a random message
    String getRandomMessage(List<String> messages, savings) {
      final random = Random();
      String message = messages[random.nextInt(messages.length)];
      // Replace "{savings}" in the message with the actual savings value
      return message.replaceAll("{savings}", savings.toStringAsFixed(2));
    }

    // Determine which list of messages to use
    String message;
    if (roundedRemaining >= 0) {
      message = getRandomMessage(withinBudgetMessages, remaining);
    } else {
      message = getRandomMessage(exceedBudgetMessages, remaining);
    }
    void openReminderBox(BuildContext context) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "Reminder!",
              style: TextStyle(
                fontFamily: 'Ubuntu',
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Color(0xFF001F3F),
              ),
            ),
            content: Text(
              message,
              style: TextStyle(
                fontFamily: 'Ubuntu',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF23CC71), // Green background
                  foregroundColor: Colors.white, // White text
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 12), // Add padding if needed
                ),
                child: Text(
                  "Got it!",
                  style: TextStyle(
                    fontFamily: 'Ubuntu', // Use Ubuntu font
                    fontSize: 16, // Adjust font size as needed
                  ),
                ),
              ),
            ],
          );
        },
      );
    }

    print(roundedRemaining);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF23cc71),
        automaticallyImplyLeading: false,
        title: const Text(
          'Budget',
          style: TextStyle(
            fontFamily: 'Nunito',
            color: Colors.white,
            fontSize: 35,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: const [],
        centerTitle: false,
        elevation: 2,
      ),
      body: ListView(
        children: [
          //SET BUDGET BUTTON
          Align(
            alignment: const AlignmentDirectional(0.00, 0.00),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
              child: SizedBox(
                width: 390,
                height: 80,
                child: Align(
                  alignment: const AlignmentDirectional(-1.00, -1.00),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(45, 0, 45, 0),
                              child: ElevatedButton(
                                onPressed: openNoteBox,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF23CC71),
                                  elevation: 10,
                                  padding:
                                      const EdgeInsets.fromLTRB(24, 0, 24, 0),
                                  fixedSize: const Size(300, 60),
                                ),
                                child: const Text(
                                  "Set Budget",
                                  style: TextStyle(
                                    fontFamily: 'Readex Pro',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 22,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          //END OF SET BUDGET BUTTON

          //BUDGET FOR THE DAY CONTAINER
          Align(
            alignment: const AlignmentDirectional(0.00, -1.00),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 15),
              child: Container(
                width: 390,
                height: 600,
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
                alignment: const AlignmentDirectional(-1.00, -1.00),
                child: Align(
                  alignment: const AlignmentDirectional(0.00, 0.00),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Align(
                              alignment: AlignmentDirectional(-1.00, -1.00),
                              child: Text(
                                'My Budget',
                                style: TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  color: Color(0xFF001F3F),
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              '₱$budget',
                              //
                              style: const TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                color: Color(0xFF1fb765),
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        //PORGRASS BAR HERE

                        //END OF PROGRESS BAR
                        const Divider(
                          thickness: 2,
                          color: Color(0xFFBDC3C7),
                        ),
                        Container(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          height:
                              300, // Replace with an appropriate fixed height
                          child: AllExpensesDashboard(),
                        ),

                        const Divider(
                          thickness: 2,
                          color: Color(0xFFBDC3C7),
                        ),
                        Container(
                          width: double.infinity,
                          height: 36,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Padding(
                                padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
                                child: Text(
                                  'Budget',
                                  style: TextStyle(
                                    fontFamily: 'Ubuntu',
                                    color: Color(0xFF001F3F),
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
                                child: Text(
                                  '₱$budget',
                                  // ₱
                                  style: const TextStyle(
                                    fontFamily: 'Ubuntu',
                                    color: Color(0xFF23CC71),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 33,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Padding(
                                padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
                                child: Text(
                                  'Expenses',
                                  style: TextStyle(
                                    fontFamily: 'Ubuntu',
                                    color: Color(0xFF001F3F),
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 25, 0),
                                child: Text(
                                  '₱$tot',
                                  // ₱
                                  style: const TextStyle(
                                    fontFamily: 'Ubuntu',
                                    color: Color(0xFF23CC71),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 36,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Padding(
                                padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
                                child: Text(
                                  'Remaining  ',
                                  style: TextStyle(
                                    fontFamily: 'Ubuntu',
                                    color: Color(0xFF001F3F),
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 25, 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '₱$roundedRemaining',
                                      style: const TextStyle(
                                        fontFamily: 'Ubuntu',
                                        color: Color(0xFF1fb765),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    // Add your icon here (e.g., a currency icon)
                                    if (expensePercentage >= 90 &&
                                        remaining > 0) ...[
                                      const Icon(
                                        Icons
                                            .warning_amber_rounded, // Warning icon
                                        size: 20, // Set the icon size to 20
                                        color:
                                            Color(0xFFFF5963), // Warning color
                                      ),
                                      const SizedBox(
                                        width:
                                            4, // Spacing between icon and text
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        //OPERATION BUTTONs HERE
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                child: ElevatedButton(
                                  onPressed: () {
                                    submitreset();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFFF5963),
                                    elevation: 10,
                                    padding:
                                        const EdgeInsets.fromLTRB(24, 0, 24, 0),
                                    fixedSize: const Size(140, 50),
                                  ),
                                  child: const Text(
                                    'Reset',
                                    style: TextStyle(
                                      fontFamily: 'Readex Pro',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                child: ElevatedButton(
                                  onPressed: () {
                                    submitreset();
                                    openReminderBox(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF23CC71),
                                    elevation: 10,
                                    padding:
                                        const EdgeInsets.fromLTRB(24, 0, 24, 0),
                                    fixedSize: const Size(170, 50),
                                  ),
                                  child: const Text(
                                    'Complete',
                                    style: TextStyle(
                                      fontFamily: 'Readex Pro',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
          //END OF OPERATION BUTTONs HERE
          //END OF BUDGET FOR THE DAY CONTAINER
        ],
      ),
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
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(builder: (context) => const Dashboard()),
      //         );
      //         break;

      //       case 2:
      //         // Budget page (current page)
      //         break;

      //       case 3:
      //         Navigator.push(context,
      //             MaterialPageRoute(builder: (context) => const Profile()));
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
      //         color: Color(0xFF6F61EF),
      //       ),
      //     ),
      //     BottomNavigationBarItem(
      //       label: 'Profile',
      //       icon: Icon(
      //         Icons.person_2_rounded,
      //         size: 32,
      //         color: Color(0xFF8A000000),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
