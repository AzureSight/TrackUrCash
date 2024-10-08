// ignore: file_names

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject_cst9l/notif/notif.dart';
import 'package:finalproject_cst9l/pages/Transactions_budget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uuid/uuid.dart';

//import 'package:percent_indicator/linear_percent_indicator.dart';
class Budget extends StatefulWidget {
  // ignore: library_private_types_in_public_api
  static final GlobalKey<_BudgetState> globalKey = GlobalKey<_BudgetState>();

  // const Budget({super.key});
  Budget({Key? key}) : super(key: globalKey); // Pass globalKey here

  @override
  State<Budget> createState() => _BudgetState();
  void refreshPage() {
    // print("IM HERE NOWWWWWWWWWWWWWWWW");
    globalKey.currentState?.refreshPage();
    // print("IM HERE below NOWWWWWWWWWWWWWWWW");
    // Access the state using the global key and call refreshPage in _BudgetState
  }
}

class _BudgetState extends State<Budget> {
  final GlobalKey<FormState> _keyform = GlobalKey<FormState>();
//  int _currentPage = 2;
  final TextEditingController _budgetController = TextEditingController();
  final TextEditingController _budgetdetailController = TextEditingController();
  double budget = 0.0;
  String budgetdesc = "";
  double tot = 0.0;
  var uid = Uuid();

  //DIALOG BOX TO ADD EXPENSES HERE

  void refreshPage() {
    print("imhereFINALLY");
    initialize();
  }

  // String? selectedBudget;
  // List<String> budgetOptions = [
  //   'Budget for Food',
  //   'Budget for Travel',
  //   'Budget for Entertainment',
  //   'Budget for Utilities',
  //   'Budget for Others',
  // ]; // Add y
  String? selectedBudget; // Holds the selected budget option
  List<String> budgetOptions = [];

  Future<void> fetchBudgetOptions() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        QuerySnapshot userDocument = await FirebaseFirestore.instance
            .collection("Users")
            .doc(user.uid)
            .collection("budget")
            .orderBy('created_at', descending: true)
            .limit(5)
            .get();

        // Clear existing options
        budgetOptions.clear();

        // Iterate through the documents and add budget_desc to the options list
        for (var doc in userDocument.docs) {
          // Assuming each document has a field named 'budget_desc'
          String budgetDesc = doc['budget_desc'] ??
              'No description'; // Fallback if field is null
          budgetOptions.add(budgetDesc);
          print(budgetDesc);
        }

        // Update the state to reflect changes in the UI
        setState(() {});
      } catch (e) {
        print(
            "Error fetching budget options: $e"); // Handle errors appropriately
      }
    }
  }

  void openNoteBox() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Container(
          width: 500,
          height: 259,
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

//EXPENSE DETAIL TEXTFIELD HERE
              TextFormField(
                controller: _budgetdetailController,
                autofocus: true,
                obscureText: false,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: () {
                        _budgetdetailController.clear();
                      },
                      icon: const Icon(Icons.clear)),
                  labelText: 'Budget Description',
                  labelStyle: const TextStyle(
                    fontFamily: 'Ubuntu',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  hintText: 'Provide a description',
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
                    return 'Please provide budget detail';
                  }
                  return null; // Return null if the validation passes
                },
                // validator: _model.textController1Validator.asValidator(context),
              ),
              //EXPENSE AMOUNT BUDGET TEXTFIELD HERE
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
                    labelText: 'Amount',
                    labelStyle: const TextStyle(
                      fontFamily: 'Ubuntu',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    hintText: 'Set your budget amount',
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
                          NotificationService().schedulenotify();
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

  void updatebudget() {
    _budgetController.text = budget.toString();
    _budgetdetailController.text = budgetdesc.toString();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SizedBox(
          width: 500,
          height: 259,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //DIALOG TITLE HERE
              const SizedBox(
                height: 35,
                child: Text(
                  'Update Budget',
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

//EXPENSE DETAIL TEXTFIELD HERE
              TextFormField(
                controller: _budgetdetailController,
                autofocus: true,
                obscureText: false,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: () {
                        _budgetdetailController.clear();
                      },
                      icon: const Icon(Icons.clear)),
                  labelText: 'Budget Description',
                  labelStyle: const TextStyle(
                    fontFamily: 'Ubuntu',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  hintText: 'Provide a description',
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
                    return 'Please provide budget detail';
                  }
                  return null; // Return null if the validation passes
                },
                // validator: _model.textController1Validator.asValidator(context),
              ),
              //EXPENSE AMOUNT BUDGET TEXTFIELD HERE
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
                    labelText: 'Amount',
                    labelStyle: const TextStyle(
                      fontFamily: 'Ubuntu',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    hintText: 'Set your budget amount',
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
                          submitreset();
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
        QuerySnapshot userDocument = await FirebaseFirestore.instance
            .collection("Users")
            .doc(user.uid)
            .collection("budget")
            .where("status", isEqualTo: "active")
            .get();

        if (userDocument.docs.isNotEmpty) {
          var activeBudget = userDocument.docs.first;
          // print("Active Budget Data: ${activeBudget.data()}");
          Map<String, dynamic> userData =
              activeBudget.data() as Map<String, dynamic>;

          // Check if the value is stored as an int, and convert it to double if necessary
          double newBudget = userData['budget_amount'] is int
              ? (userData['budget_amount'] as int)
                  .toDouble() // Convert int to double
              : userData['budget_amount']
                  as double; // If it's already a double, no need to convert

          String newbudgetdesc = userData['budget_desc'];
          setState(() {
            budget = newBudget;
            budgetdesc = newbudgetdesc;
          });
        } else {
          setState(() {
            budget = 0.0;
            budgetdesc = "";
          });
        }
      } catch (e) {
        print("Error retrieving data: $e");
      }
    }
  }

  // var budamount = BudgetGetter();
  // Future<void> initializeTotal() async {
  //   print("budget description: $budgetdesc");
  //   double total = await budamount.fetchbudget();
  //   tot = total;
  //   print("expense AMOUNT IN BUDGET: $tot");
  // }

  Future<void> fetchexpenses() async {
    final user = FirebaseAuth.instance.currentUser;

    await FirebaseFirestore.instance.collection('Users').doc(user!.uid).get();

    QuerySnapshot activeBudgetQuery = await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .collection('budget')
        .where('status', isEqualTo: 'active')
        .limit(1) // We expect only one active budget at a time
        .get();

    String activeBudgetDescription = " ";

    if (activeBudgetQuery.docs.isNotEmpty) {
      var activeBudgetDoc = activeBudgetQuery.docs.first;
      activeBudgetDescription = activeBudgetDoc['budget_desc'];
    }

    // DateTime now = DateTime.now();
    // DateTime startOfToday =
    //     DateTime(now.year, now.month, now.day); // Start of current day
    // DateTime endOfToday = DateTime(
    //     now.year, now.month, now.day, 23, 59, 59); // End of current day
    double totalAmount = 0;
    if (activeBudgetQuery.docs.isNotEmpty) {
      QuerySnapshot expenseSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .collection('expenses')
          // .where('timestamp',
          //     isGreaterThanOrEqualTo: startOfToday.millisecondsSinceEpoch)
          // .where('timestamp',
          //     isLessThanOrEqualTo: endOfToday.millisecondsSinceEpoch)
          .where('budget', isEqualTo: activeBudgetDescription)
          .get();

      List<QueryDocumentSnapshot> expenses = expenseSnapshot.docs;

      for (var expense in expenses) {
        totalAmount += (expense['amount'] as num).toDouble();
      }

      setState(() {
        tot = totalAmount.toDouble();
      });
    } else {
      setState(() {
        tot = 0.0;
      });
    }
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
        var desc = _budgetdetailController.text;
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
          "budget_desc": desc,
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
        _budgetdetailController.clear();

        // print("New budget added and existing budgets updated to 'completed'.");
      } catch (e) {
        print("Error retrieving data: $e");
      }
    } else {
      print("User not logged in");
    }
    fetchexpenses();
    getbudget();
  }

  Future<void> submitreset() async {
    final user = FirebaseAuth.instance.currentUser;
    // int timestamp = DateTime.now().millisecondsSinceEpoch;

    // // ignore: non_constant_identifier_names

    // DateTime date = DateTime.now();

    if (user != null) {
      try {
        var amount = double.parse(_budgetController.text);
        var desc = _budgetdetailController.text;
        String olddesc;
        // Query for the active budget
        QuerySnapshot activeBudgetQuery = await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .collection('budget')
            .where('status', isEqualTo: 'active')
            .limit(1) // We expect only one active budget at a time
            .get();

        // Check if we found an active budget
        if (activeBudgetQuery.docs.isNotEmpty) {
          // Retrieve the first (and only) active budget document
          DocumentSnapshot activeBudgetDoc = activeBudgetQuery.docs.first;
          olddesc = activeBudgetDoc['budget_desc'];
          // print("THIS IS THE OLD DESCRIPTION$olddesc");
          // Update the active budget's amount and description
          await activeBudgetDoc.reference.update({
            'budget_amount': amount,
            'budget_desc': desc,
          });

          QuerySnapshot existingBudgetsExpense = await FirebaseFirestore
              .instance
              .collection('Users')
              .doc(user.uid)
              .collection('expenses')
              .where('budget', isEqualTo: olddesc)
              .get();

          WriteBatch batch2 = FirebaseFirestore.instance.batch();

          for (var doc in existingBudgetsExpense.docs) {
            batch2.update(doc.reference, {'budget': desc});
          }
          await batch2.commit();

          _budgetController.clear();
          _budgetdetailController.clear();
          // print("Active budget updated successfully.");
        } else {
          print("No active budget found.");
        }

        getbudget();
        _budgetController.clear();
      } catch (e) {
        print("Error retrieving data: $e");
      }
    } else {
      print("User not logged in");
    }
  }

  Future<void> completed() async {
    final user = FirebaseAuth.instance.currentUser;
    // int timestamp = DateTime.now().millisecondsSinceEpoch;

    // // ignore: non_constant_identifier_names

    // DateTime date = DateTime.now();

    if (user != null) {
      try {
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
        QuerySnapshot existingBudgetsExpense = await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .collection('expenses')
            // .where('budget', isNotEqualTo: 'asd')
            .get();

        WriteBatch batch2 = FirebaseFirestore.instance.batch();
        for (var doc in existingBudgetsExpense.docs) {
          String expenseBudgetDesc = doc['budget'];

          // String cleanedBudgetDesc = expenseBudgetDesc.replaceAll(' + - ', '');

          // if (expenseBudgetDesc.length > 12) {
          //   // Remove the last 12 characters from the budget description
          //   expenseBudgetDesc =
          //       expenseBudgetDesc.substring(0, expenseBudgetDesc.length - 12);
          // }

          // batch2.update(
          //     doc.reference, {'budget': '$expenseBudgetDesc - completed'});
          // // doc.reference,
          // // {
          // //   'budget': expenseBudgetDesc,
          // //   // 'budget_id': null, // gigamit para lang sa kulang na field if nagupdate sa database
          // // });

          if (expenseBudgetDesc.endsWith(' - completed')) {
            expenseBudgetDesc =
                expenseBudgetDesc.substring(0, expenseBudgetDesc.length - 12);
          }

          batch2.update(
              doc.reference, {'budget': '$expenseBudgetDesc - completed'});
        }
        await batch2.commit();
        getbudget();
        _budgetController.clear();
      } catch (e) {
        print("Error retrieving data: $e");
      }
    } else {
      print("User not logged in");
    }
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    await getbudget();
    await fetchexpenses();
    // await fetchBudgetOptions();
    NotificationService().schedulenotify();
    // NotificationService().scheduleMyNotification();
  }

  double remaining = 0.0;

  @override
  Widget build(BuildContext context) {
    // print("Expenses$tot");
    if (budget == 0) {
      remaining = 0;
    } else {
      remaining = budget - tot;
    }

    String formattedbudget = NumberFormat.currency(
      locale: 'en_PH',
      symbol: '₱',
      decimalDigits: 2,
    ).format(budget);

    String formattedexp = NumberFormat.currency(
      locale: 'en_PH',
      symbol: '₱',
      decimalDigits: 2,
    ).format(tot);

    String formattedremaining = NumberFormat.currency(
      locale: 'en_PH',
      symbol: '₱',
      decimalDigits: 2,
    ).format(remaining);

    double roundedRemaining = double.parse(remaining.toStringAsFixed(2));
    // double savings = remaining;
    double expensePercentage = (tot / budget) * 100;
    // Lists of messages
    List<String> withinBudgetMessages = [
      "Great job! You've stayed within your budget and saved {savings} pesos.",
      "Awesome work! You also saved {savings} pesos. Keep it up!",
      "You're doing fantastic! You've managed to save {savings} pesos. Save it for something bigger!"
    ];
    List<String> equaltobudget = [
      "You haven't saved a penny. Try to save next time!",
      "Awesome work! you are within your budget!",
      "Keep it up!"
    ];

    List<String> exceedBudgetMessages = [
      "Uh-oh! Your expenses have exceeded your budget.",
      "Looks like you're over your budget.",
      "Your current expenses are over your budget limit. Save More!"
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
    if (roundedRemaining > 0) {
      message = getRandomMessage(withinBudgetMessages, remaining);
    } else if (roundedRemaining == 0) {
      message = getRandomMessage(equaltobudget, remaining);
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
              style: const TextStyle(
                fontFamily: 'Ubuntu',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  completed();
                  getbudget();
                  fetchexpenses();
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF23CC71), // Green background
                  foregroundColor: Colors.white, // White text
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 12), // Add padding if needed
                ),
                child: const Text(
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
                                onPressed: () {
                                  if (budgetdesc == "") {
                                    openNoteBox();
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          content: SizedBox(
                                            width: 300,
                                            height: 201,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                //DIALOG TITLE HERE

                                                const SizedBox(
                                                  height: 40,
                                                  child: Center(
                                                    child: Text(
                                                      'Set Budget?',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontFamily: 'Ubuntu',
                                                        fontSize: 26,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Color(0xFF001F3F),
                                                      ),
                                                    ),
                                                  ),
                                                ),

                                                const SizedBox(
                                                  height: 30,
                                                  child: Center(
                                                    child: Text(
                                                      'You have an active budget!',
                                                      style: TextStyle(
                                                        fontFamily: 'Ubuntu',
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Color.fromARGB(
                                                            221, 255, 0, 0),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                //END OF DIALOG TITLE
                                                const Divider(
                                                  color: Colors.black87,
                                                  thickness: 1,
                                                ),

                                                const SizedBox(
                                                  height: 50,
                                                  child: Center(
                                                    child: Text(
                                                      'Complete active budget first before setting a new one.',
                                                      textAlign: TextAlign
                                                          .center, // Align text to the center
                                                      style: TextStyle(
                                                        fontFamily: 'Ubuntu',
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                  ),
                                                ),

                                                //END OF TEXT BODY DIALOG
                                                const SizedBox(height: 10),

                                                //DELETE & CANCEL BUTTON HERE
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      width: 115,
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                        color: Colors.white,
                                                        boxShadow: const [
                                                          BoxShadow(
                                                            color: Color(
                                                                0xFF33000000),
                                                            offset:
                                                                Offset(0, 2),
                                                            blurRadius: 0,
                                                          ),
                                                        ],
                                                      ),
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              const Color
                                                                  .fromARGB(255,
                                                                  1, 162, 255),
                                                          elevation: 0,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100),
                                                          ),
                                                        ),
                                                        child: const Text(
                                                          'Ok',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Ubuntu',
                                                            color:
                                                                Color.fromARGB(
                                                                    221,
                                                                    255,
                                                                    255,
                                                                    255),
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 5),
                                                //END OF DELETE & CANCEL BUTTOM
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }
                                }
                                // openNoteBox,

                                ,
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
                height: 630,
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
                        Column(
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
                                IconButton(
                                  icon:
                                      const Icon(Icons.account_balance_wallet),
                                  iconSize: 40,
                                  color: const Color.fromARGB(255, 52, 52, 52),
                                  onPressed: () {},
                                ),
                                // IconButton(
                                //   icon: SvgPicture.asset(
                                //     'assets/images/coin.svg', // Path to your paper money SVG asset
                                //     width: 40,
                                //     height: 40,
                                //     // color: Colors.green,
                                //   ),
                                //   iconSize: 40,
                                //   onPressed: () {},
                                // ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                  child: Text(
                                    budgetdesc, // Make sure 'budgetdesc' is a valid variable
                                    style: const TextStyle(
                                      fontFamily: 'Manrope',
                                      color: Color(0xFF2E2863),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                // Padding(
                                //   padding:
                                //       const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                //   child: DropdownButton<String>(
                                //     // Display the selected value or hint if none is selected
                                //     value: selectedBudget,
                                //     hint:
                                //         const Text("Select Budget Description"),
                                //     onChanged: (String? newValue) {
                                //       setState(() {
                                //         print(newValue);
                                //         selectedBudget =
                                //             newValue; // Update the selected value
                                //         // budgetdesc = newValue ??
                                //         //     ""; // Update the budgetdesc
                                //       });
                                //     },
                                //     items: budgetOptions
                                //         .map<DropdownMenuItem<String>>(
                                //             (String value) {
                                //       return DropdownMenuItem<String>(
                                //         value: value,
                                //         child: Text(value),
                                //       );
                                //     }).toList(),
                                //   ),
                                // ),
                                Text(
                                  // '₱$budget', // Ensure 'tot' is passed to the widget
                                  formattedbudget,
                                  style: const TextStyle(
                                    fontFamily: 'Manrope',
                                    color: Color(0xFF23cc71),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )
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
                          child: Transactions_Budget(
                            data: budgetdesc,
                          ),
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
                                padding: const EdgeInsets.fromLTRB(0, 0, 25, 0),
                                child: Text(
                                  // '₱$budget',
                                  formattedbudget,
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
                                  // '₱$tot',
                                  formattedexp,
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
                                      // '₱$roundedRemaining',
                                      formattedremaining,
                                      style: const TextStyle(
                                        fontFamily: 'Ubuntu',
                                        color: Color(0xFF1fb765),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    // Add your icon here (e.g., a currency icon)
                                    if (expensePercentage >= 80 &&
                                        remaining > 0) ...[
                                      const Icon(
                                        Icons
                                            .warning_amber_rounded, // Warning icon
                                        size: 20, // Set the icon size to 20
                                        color: Color.fromARGB(
                                            255, 236, 67, 0), // Warning color
                                      ),
                                      const SizedBox(
                                        width:
                                            4, // Spacing between icon and text
                                      ),
                                    ] else if (expensePercentage < 80) ...[
                                      const Icon(
                                        Icons.check_circle, // Warning icon
                                        size: 20, // Set the icon size to 20
                                        color: Color.fromARGB(
                                            255, 11, 255, 3), // Warning color
                                      ),
                                      const SizedBox(
                                        width:
                                            4, // Spacing between icon and text
                                      ),
                                    ] else if (remaining < 0) ...[
                                      const Icon(
                                        Icons.money_off, // Thumbs down icon
                                        size: 20, // Set the icon size to 20
                                        color: Color.fromARGB(255, 233, 0,
                                            0), // Neutral warning color
                                      ),
                                      const SizedBox(
                                        width:
                                            4, // Spacing between icon and text
                                      ),
                                      // ] else ...[
                                      //   const Icon(
                                      //     Icons.check_circle,
                                      //     // Alternative icon for the else case
                                      //     size: 20, // Set the icon size to 20
                                      //     color: Color.fromARGB(
                                      //         255, 0, 255, 0), // Success color
                                      //   ),
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
                                    // updatebudget();
                                    if (budgetdesc == "") {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            content: SizedBox(
                                              width: 300,
                                              height: 201,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  //DIALOG TITLE HERE

                                                  const SizedBox(
                                                    height: 40,
                                                    child: Center(
                                                      child: Text(
                                                        'No Active Budget!',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontFamily: 'Ubuntu',
                                                          fontSize: 26,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Color(0xFF001F3F),
                                                        ),
                                                      ),
                                                    ),
                                                  ),

                                                  const SizedBox(
                                                    height: 30,
                                                    child: Center(
                                                      child: Text(
                                                        'Set Budget First!',
                                                        style: TextStyle(
                                                          fontFamily: 'Ubuntu',
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Color.fromARGB(
                                                              221, 255, 0, 0),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  //END OF DIALOG TITLE
                                                  const Divider(
                                                    color: Colors.black87,
                                                    thickness: 1,
                                                  ),

                                                  const SizedBox(
                                                    height: 50,
                                                    child: Center(
                                                      child: Text(
                                                        'Setting a budget can help you save more.',
                                                        textAlign: TextAlign
                                                            .center, // Align text to the center
                                                        style: TextStyle(
                                                          fontFamily: 'Ubuntu',
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black87,
                                                        ),
                                                      ),
                                                    ),
                                                  ),

                                                  //END OF TEXT BODY DIALOG
                                                  const SizedBox(height: 10),

                                                  //DELETE & CANCEL BUTTON HERE
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        width: 115,
                                                        height: 40,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      100),
                                                          color: Colors.white,
                                                          boxShadow: const [
                                                            BoxShadow(
                                                              color: Color(
                                                                  0xFF33000000),
                                                              offset:
                                                                  Offset(0, 2),
                                                              blurRadius: 0,
                                                            ),
                                                          ],
                                                        ),
                                                        child: ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                const Color
                                                                    .fromARGB(
                                                                    255,
                                                                    1,
                                                                    162,
                                                                    255),
                                                            elevation: 0,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          100),
                                                            ),
                                                          ),
                                                          child: const Text(
                                                            'Ok',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Ubuntu',
                                                              color: Color
                                                                  .fromARGB(
                                                                      221,
                                                                      255,
                                                                      255,
                                                                      255),
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 5),
                                                  //END OF DELETE & CANCEL BUTTOM
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    } else {
                                      updatebudget();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 1, 162, 255),
                                    elevation: 10,
                                    padding:
                                        const EdgeInsets.fromLTRB(24, 0, 24, 0),
                                    fixedSize: const Size(140, 50),
                                  ),
                                  child: const Text(
                                    'Update',
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
                                    // openReminderBox(context);
                                    if (budgetdesc == "") {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            content: SizedBox(
                                              width: 300,
                                              height: 201,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  //DIALOG TITLE HERE

                                                  const SizedBox(
                                                    height: 40,
                                                    child: Center(
                                                      child: Text(
                                                        'No Active Budget!',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontFamily: 'Ubuntu',
                                                          fontSize: 26,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Color(0xFF001F3F),
                                                        ),
                                                      ),
                                                    ),
                                                  ),

                                                  const SizedBox(
                                                    height: 30,
                                                    child: Center(
                                                      child: Text(
                                                        'Set Budget First!',
                                                        style: TextStyle(
                                                          fontFamily: 'Ubuntu',
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Color.fromARGB(
                                                              221, 255, 0, 0),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  //END OF DIALOG TITLE
                                                  const Divider(
                                                    color: Colors.black87,
                                                    thickness: 1,
                                                  ),

                                                  const SizedBox(
                                                    height: 50,
                                                    child: Center(
                                                      child: Text(
                                                        'Setting a budget can help you save more.',
                                                        textAlign: TextAlign
                                                            .center, // Align text to the center
                                                        style: TextStyle(
                                                          fontFamily: 'Ubuntu',
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black87,
                                                        ),
                                                      ),
                                                    ),
                                                  ),

                                                  //END OF TEXT BODY DIALOG
                                                  const SizedBox(height: 10),

                                                  //DELETE & CANCEL BUTTON HERE
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        width: 115,
                                                        height: 40,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      100),
                                                          color: Colors.white,
                                                          boxShadow: const [
                                                            BoxShadow(
                                                              color: Color(
                                                                  0xFF33000000),
                                                              offset:
                                                                  Offset(0, 2),
                                                              blurRadius: 0,
                                                            ),
                                                          ],
                                                        ),
                                                        child: ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                const Color
                                                                    .fromARGB(
                                                                    255,
                                                                    1,
                                                                    162,
                                                                    255),
                                                            elevation: 0,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          100),
                                                            ),
                                                          ),
                                                          child: const Text(
                                                            'Ok',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Ubuntu',
                                                              color: Color
                                                                  .fromARGB(
                                                                      221,
                                                                      255,
                                                                      255,
                                                                      255),
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 5),
                                                  //END OF DELETE & CANCEL BUTTOM
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            content: SizedBox(
                                              width: 300,
                                              height: 200,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  //DIALOG TITLE HERE
                                                  const Row(
                                                    children: [
                                                      SizedBox(
                                                        height: 40,
                                                        child: Text(
                                                          'Complete Budget?',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Ubuntu',
                                                            fontSize: 26,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Color(
                                                                0xFF001F3F),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  //END OF DIALOG TITLE
                                                  const Divider(
                                                    color: Colors.black87,
                                                    thickness: 1.5,
                                                  ),
                                                  const SizedBox(height: 10),
                                                  //TEXT BODY DIALOG
                                                  const SizedBox(
                                                    height: 50,
                                                    child: Center(
                                                      child: Text(
                                                        'Do you want to complete this budget?',
                                                        style: TextStyle(
                                                          fontFamily: 'Ubuntu',
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black87,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  //END OF TEXT BODY DIALOG
                                                  const SizedBox(height: 30),

                                                  //DELETE & CANCEL BUTTON HERE
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                        width: 115,
                                                        height: 40,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      100),
                                                          color: Colors.white,
                                                          boxShadow: const [
                                                            BoxShadow(
                                                              color: Color(
                                                                  0xFF33000000),
                                                              offset:
                                                                  Offset(0, 2),
                                                              blurRadius: 0,
                                                            ),
                                                          ],
                                                        ),
                                                        child: ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            elevation: 0,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          100),
                                                            ),
                                                          ),
                                                          child: const Text(
                                                            'Cancel',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Ubuntu',
                                                              color: Colors
                                                                  .black87,
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        width: 130,
                                                        height: 40,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      100),
                                                          color: const Color(
                                                              0xFF23CC71),
                                                          boxShadow: const [
                                                            BoxShadow(
                                                              color: Color(
                                                                  0xFF33000000),
                                                              offset:
                                                                  Offset(0, 2),
                                                              blurRadius: 0,
                                                            ),
                                                          ],
                                                        ),
                                                        child: ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            openReminderBox(
                                                                context);
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            elevation: 0,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          100),
                                                            ),
                                                          ),
                                                          child: const Text(
                                                            'Complete',
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xFFFFFFFF),
                                                              fontFamily:
                                                                  'Ubuntu',
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 5),
                                                  //END OF DELETE & CANCEL BUTTOM
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    }
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
