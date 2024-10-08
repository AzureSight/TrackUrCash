import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject_cst9l/notif/notif.dart';
import 'package:finalproject_cst9l/pages/Dashboard.dart';
import 'package:finalproject_cst9l/pages/displayrecords.dart';
import 'package:finalproject_cst9l/pages/update.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:finalproject_cst9l/services/firestore.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final GlobalKey<FormState> _keyform = GlobalKey<FormState>();
  int _currentPage = 0;
  final FirestoreService firestoreService = FirestoreService();
  final TextEditingController _expensedetailController =
      TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  var uid = Uuid();
  double? selectedtotalAmount;
  Future<void> submit() async {
    final User = FirebaseAuth.instance.currentUser;

    // DateTime now = DateTime.now().toUtc().add(Duration(hours: 8));
    // // Use the adjusted DateTime to get the milliseconds since epoch
    // int timestamp = now.millisecondsSinceEpoch;

    int timestamp = DateTime.now().millisecondsSinceEpoch;
    print(timestamp);
    String detail = _expensedetailController.text.toString();
    // ignore: non_constant_identifier_names
    var Amount = double.parse(_amountController.text);
    DateTime date = DateTime.now();
    var id = uid.v4();
    String monthyear = DateFormat("MMM y").format(date);
    print(_expensedetailController.text.toString());
    await FirebaseFirestore.instance.collection('Users').doc(User!.uid).get();

    // QuerySnapshot activeBudgetQuery = await FirebaseFirestore.instance
    //     .collection('Users')
    //     .doc(User.uid)
    //     .collection('budget')
    //     .where('status', isEqualTo: 'active')
    //     .limit(1) // We expect only one active budget at a time
    //     .get();

    // String activeBudgetDescription;

    // if (activeBudgetQuery.docs.isNotEmpty) {
    //   var activeBudgetDoc = activeBudgetQuery.docs.first;
    //   activeBudgetDescription = activeBudgetDoc['budget_desc'];
    //   NotificationService().notify();
    // } else {
    //   // If no active budget is found, set to "Uncategorized"
    //   activeBudgetDescription = "Uncategorized";
    // }

    QuerySnapshot activeBudgetQuery = await FirebaseFirestore.instance
        .collection('Users')
        .doc(User.uid)
        .collection('budget')
        .where('status', isEqualTo: 'active')
        .limit(1) // We expect only one active budget at a time
        .get();

    String activeBudgetDescription;
    String activeBudgetID;

    if (activeBudgetQuery.docs.isNotEmpty) {
      var activeBudgetDoc = activeBudgetQuery.docs.first;

      activeBudgetDescription = activeBudgetDoc['budget_desc'];
      activeBudgetID = activeBudgetDoc.id;
    } else {
      // If no active budget is found, set to "Uncategorized"
      activeBudgetDescription = "Uncategorized";
      activeBudgetID = "No available id";
    }

    var data = {
      "id": id,
      "detail": detail,
      "amount": Amount,
      "timestamp": timestamp,
      "monthyear": monthyear,
      "budget": activeBudgetDescription,
      "budget_id": activeBudgetID,
    };
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(User.uid)
        .collection("expenses")
        .doc(id)
        .set(data);

    NotificationService().notify();
  }

  Future<double> computeTotalAmount() async {
    final User? user = FirebaseAuth.instance.currentUser;
    double totalAmount = 0;

    if (user != null) {
      QuerySnapshot expenseSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .collection('expenses')
          .get();

      List<QueryDocumentSnapshot> expenses = expenseSnapshot.docs;

      for (var expense in expenses) {
        totalAmount += expense['amount'] as double;
      }
    }

    return totalAmount;
  }

  Future<double> getTotalAmount() async {
    double total = await computeTotalAmount();
    return total;
    // Use the 'total' variable wherever you need it in your code
  }

  //DIALOG BOX TO ADD EXPENSES HERE
  void openNoteBox() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Form(
          key: _keyform,
          child: Container(
            width: 350,
            height: 300,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //DIALOG TITLE HERE
                Container(
                  height: 30,
                  child: const Text(
                    'Add Expense',
                    style: TextStyle(
                      fontFamily: 'Ubuntu',
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF001F3F),
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.black87,
                  thickness: 1.5,
                ),
                const SizedBox(height: 10),
                //EXPENSE DETAIL TEXTFIELD HERE
                TextFormField(
                  controller: _expensedetailController,
                  autofocus: true,
                  obscureText: false,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () {
                          _expensedetailController.clear();
                        },
                        icon: const Icon(Icons.clear)),
                    labelText: 'Expense Details',
                    labelStyle: const TextStyle(
                      fontFamily: 'Ubuntu',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    hintText: 'Specify your Expenses',
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
                      return 'Please specify expense detail';
                    }
                    return null; // Return null if the validation passes
                  },
                  // validator: _model.textController1Validator.asValidator(context),
                ),
                const SizedBox(height: 10), // Spacer
                //END OF EXPENSE DETAIL TEXTFIELD

                //AMOUNT DETAIL TEXTFIELD HERE
                TextFormField(
                  onChanged: (total) {
                    setState(() {});
                  },
                  controller: _amountController,
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
                          _amountController.clear();
                        },
                        icon: const Icon(Icons.clear)),
                    labelText: 'Amount',
                    labelStyle: const TextStyle(
                      fontFamily: 'Ubuntu',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    hintText: 'Enter the Amount',
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
                      return 'Please specify expense amount';
                    }
                    return null; // Return null if the validation passes
                  },
                  // validator: _model.textController1Validator.asValidator(context),
                ),
                const SizedBox(height: 10), // Spacer
                //END OF AMOUNT DETAIL TEXTFIELD

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
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontFamily: 'Ubuntu',
                            color: Colors.black87,
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
                        color: const Color(0xFF23cc71),
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
                          // ADD NEW NOTE
                          // ADD NEW NOTE
                          // firestoreService.addExpenseDetail(
                          //     _expensedetailController.text,
                          //     int.parse(_amountController.text));
                          // firestoreService
                          //     .addAmount(int.parse(_amountController.text));
                          if (_keyform.currentState!.validate()) {
                            submit();
                            _expensedetailController.clear();
                            _amountController.clear();
                            _dateController.clear();

                            Navigator.pop(context);
                          }
                          //CLEAR THE TEXT CONTROLLER

                          //CLOSE THE BOX
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        child: const Text(
                          'Add',
                          style: TextStyle(
                            fontFamily: 'Ubuntu',
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
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    await fetchBudgetOptions();
    await _fetchTotalAmount();
    setState(() {});
  }

  // //END OF DIALOG BOX
  // String? selectedBudget; // Holds the selected budget option
  // List<String> budgetOptions = [];

  // Future<void> fetchBudgetOptions() async {
  //   final user = FirebaseAuth.instance.currentUser;
  //   if (user != null) {
  //     try {
  //       QuerySnapshot userDocument = await FirebaseFirestore.instance
  //           .collection("Users")
  //           .doc(user.uid)
  //           .collection("budget")
  //           .orderBy('created_at', descending: true)
  //           .limit(5)
  //           .get();

  //       setState(() {
  //         // Clear existing options
  //         budgetOptions.clear();
  //         budgetOptions.add("Default - all");
  //         // Iterate through the documents and add budget_desc to the options list
  //         for (var doc in userDocument.docs) {
  //           // Assuming each document has a field named 'budget_desc'
  //           String budgetDesc = doc['budget_desc'] ??
  //               'No description'; // Fallback if field is null
  //           budgetOptions.add(budgetDesc);
  //           print(budgetDesc);
  //         }
  //       });
  //       // Update the state to reflect changes in the UI
  //     } catch (e) {
  //       print(
  //           "Error fetching budget options: $e"); // Handle errors appropriately
  //     }
  //   }
  // }
  String? selectedBudget = 'null';
  List<Map<String, String>> budgetOptions =
      []; // Holds both budget_desc and docId

  Future<void> fetchBudgetOptions() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        QuerySnapshot userDocument = await FirebaseFirestore.instance
            .collection("Users")
            .doc(user.uid)
            .collection("budget")
            .orderBy('created_at', descending: true)
            // .limit(5)
            .get();

        setState(() {
          // Clear existing options
          budgetOptions.clear();

          // Add a default value with null id
          budgetOptions.add({
            "budget_desc": "Default - all",
            "doc_id": "null"
          }); // di mugana kay way doc id ang static
          budgetOptions.add({"budget_desc": "Uncategorized", "doc_id": "0"});
          // Iterate through the documents and add both budget_desc and docId
          for (var doc in userDocument.docs) {
            String budgetDesc = doc['budget_desc'] ??
                'No description'; // Fallback if field is null
            String docId = doc.id; // Get the document ID

            // Add both budget_desc and docId to the budgetOptions list
            budgetOptions.add({
              "budget_desc": budgetDesc,
              "doc_id": docId,
            });

            // print("Budget Desc: $budgetDesc, Doc ID: $docId");
          }
        });
      } catch (e) {
        print(
            "Error fetching budget options: $e"); // Handle errors appropriately
      }
    }
  }

  Future<void> _fetchTotalAmount() async {
    String? budgetId = selectedBudget;

    TotalExpense totalExpense = TotalExpense(id: budgetId);
    try {
      double total = await totalExpense.getTotal();
      setState(() {
        selectedtotalAmount = total;
      });
    } catch (e) {
      print('Failed to get total amount: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedSelectedTotalExpense = NumberFormat.currency(
      locale: 'en_PH',
      symbol: '₱',
      decimalDigits: 2,
    ).format(selectedtotalAmount ?? 0.0);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF23cc71),
        automaticallyImplyLeading: false,
        title: const Text(
          'Expenses',
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
      floatingActionButton: FloatingActionButton(
        onPressed: openNoteBox,
        backgroundColor: const Color(0xFF23CC71),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: StreamBuilder<Object>(
          stream: firestoreService.getNotesStream(),
          builder: (context, snapshot) {
            return ListView(
              children: [
                //ADD EXPENSES BUTTON HERE
                // Padding(
                //   padding: const EdgeInsets.fromLTRB(100, 35, 100, 10),
                //   child: ElevatedButton(
                //     onPressed: () {
                //       print('Button pressed ...');
                //     },
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: const Color(0xFF4B39EF),
                //       padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                //       fixedSize: const Size(150, 50),
                //     ),
                //     child: const Text(
                //       'Add Expenses',
                //       style: TextStyle(
                //         fontFamily: 'Readex Pro',
                //         color: Colors.white,
                //         fontSize: 20,
                //       ),
                //     ),
                //   ),
                // ),
                //END OF ADD EXPENSES BUTTON

                //TODAYS EXPENSES TABLE......
                Align(
                  alignment: const AlignmentDirectional(0.00, 0.00),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                    child: Container(
                      width: 500,
                      height: 420,
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
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              10, 10, 10, 10),
                          child: ListView(
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Align(
                                    alignment:
                                        AlignmentDirectional(-1.00, -1.00),
                                    child: Text(
                                      'Today',
                                      style: TextStyle(
                                        fontFamily: 'Ubuntu',
                                        color: Color(0xFF001F3F),
                                        fontSize: 30,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    iconSize: 40,
                                    onPressed: () {
                                      // print('IconButton pressed ...');
                                    },
                                  ),
                                ],
                              ),
                              const Divider(
                                thickness: 1.5,
                                color: Color(0xFFBDC3C7),
                              ),
                              Container(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                height:
                                    330, // Replace with an appropriate fixed height
                                child: Todaytransactions(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                //END OF TODAYS EXPENSES TABLE

                //All  EXPENSES TABLE
                Align(
                  alignment: const AlignmentDirectional(0.00, 0.00),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                    child: Container(
                      width: 500,
                      height: 420,
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
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              10, 10, 10, 10),
                          child: ListView(
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Align(
                                    alignment:
                                        AlignmentDirectional(-1.00, -1.00),
                                    child: Text(
                                      'Recent Expenses',
                                      style: TextStyle(
                                        fontFamily: 'Ubuntu',
                                        color: Color(0xFF001F3F),
                                        fontSize: 30,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    iconSize: 40,
                                    onPressed: () {
                                      // print('IconButton pressed ...');
                                    },
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Padding(
                                  //   padding:
                                  //       const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                  //   child: Text(
                                  //     budgetdesc, // Make sure 'budgetdesc' is a valid variable
                                  //     style: const TextStyle(
                                  //       fontFamily: 'Manrope',
                                  //       color: Color(0xFF2E2863),
                                  //       fontSize: 16,
                                  //       fontWeight: FontWeight.bold,
                                  //     ),
                                  //   ),
                                  // ),

                                  // //dropdown
                                  // Padding(
                                  //   padding:
                                  //       const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                  //   child: DropdownButton<String>(
                                  //     // Display the selected value or hint if none is selected
                                  //     value: selectedBudget,
                                  //     hint: const Text(
                                  //         "Select Budget Description"),
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
                                  // //dropdownold

                                  // Padding(
                                  //   padding:
                                  //       const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                  //   child: DropdownButton<String>(
                                  //     // Display the selected value or hint if none is selected
                                  //     value: selectedBudget,
                                  //     hint: const Text(
                                  //         "Select Budget Description"),
                                  //     onChanged: (String? newValue) {
                                  //       setState(() {
                                  //         // print("$newValue");
                                  //         selectedBudget = newValue;

                                  //         // Update the selected value (doc_id)
                                  //       });
                                  //     },
                                  //     items: budgetOptions
                                  //         .map<DropdownMenuItem<String>>(
                                  //             (Map<String, String> budget) {
                                  //       return DropdownMenuItem<String>(
                                  //         value: budget[
                                  //             'doc_id'], // Use doc_id as the value
                                  //         child: Text(budget[
                                  //             'budget_desc']!), // Display the budget_desc in the dropdown
                                  //       );
                                  //     }).toList(),
                                  //   ),
                                  // ),

                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    child: GestureDetector(
                                      onTap: () async {
                                        final RenderBox button = context
                                            .findRenderObject() as RenderBox;
                                        final Offset buttonPosition =
                                            button.localToGlobal(Offset.zero);
                                        final Size buttonSize = button.size;

                                        final double dropdownX =
                                            buttonPosition.dx + 30;
                                        final double dropdownY =
                                            buttonPosition.dy + 318;

                                        final selected = await showMenu(
                                          context: context,
                                          position: RelativeRect.fromLTRB(
                                            dropdownX, // Adjusted x position
                                            dropdownY, // Position below the button
                                            buttonPosition.dx +
                                                buttonSize
                                                    .width, // Set width based on button size
                                            0, // No bottom position needed
                                          ),
                                          items: [
                                            PopupMenuItem<String>(
                                              child: SizedBox(
                                                height: 250,
                                                width: 200,
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    children: budgetOptions.map(
                                                        (Map<String, String>
                                                            budget) {
                                                      return ListTile(
                                                        title: Text(budget[
                                                            'budget_desc']!),
                                                        onTap: () {
                                                          Navigator.pop(context,
                                                              budget['doc_id']);
                                                        },
                                                      );
                                                    }).toList(),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );

                                        if (selected != null) {
                                          setState(() {
                                            selectedBudget = selected;
                                            _fetchTotalAmount();
                                          });
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          // children: [
                                          //   Text(
                                          //     selectedBudget == 'null'
                                          //         ? "All Budgets"
                                          //         : budgetOptions.firstWhere(
                                          //             (option) =>
                                          //                 option['doc_id'] ==
                                          //                 selectedBudget,
                                          //             orElse: () => {
                                          //                   'budget_desc':
                                          //                       'Unknown Budget'
                                          //                 })['budget_desc']!,
                                          //   ),
                                          //   const Icon(Icons.arrow_drop_down),
                                          // ],
                                          children: [
                                            Text(
                                              budgetOptions.firstWhere(
                                                  (option) =>
                                                      option['doc_id'] ==
                                                      selectedBudget,
                                                  orElse: () => {
                                                        'budget_desc':
                                                            'Unknown Budget'
                                                      })['budget_desc']!,
                                            ),
                                            const Icon(Icons.arrow_drop_down),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    // '₱$budget', // Ensure 'tot' is passed to the widget
                                    formattedSelectedTotalExpense,
                                    style: const TextStyle(
                                      fontFamily: 'Manrope',
                                      color: Color(0xFF23cc71),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(
                                thickness: 1.5,
                                color: Color(0xFFBDC3C7),
                              ),
                              Container(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                height:
                                    290, // Replace with an appropriate fixed height
                                child: BudgetExpenses(id: selectedBudget),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                //END OF YESTERDAYS EXPENSES TABLE

                // //SHOW ALL EXPENSES BUTTON HERE
                // Padding(
                //   padding: const EdgeInsets.fromLTRB(45, 35, 35, 45),
                //   child: ElevatedButton(
                //     onPressed: () {
                //       print('Button pressed ...');
                //     },
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: const Color(0xFF4B39EF),
                //       padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                //       fixedSize: const Size(300, 50),
                //     ),
                //     child: const Text(
                //       'Show All Expenses',
                //       style: TextStyle(
                //         fontFamily: 'Readex Pro',
                //         color: Colors.white,
                //         fontSize: 20,
                //       ),
                //     ),
                //   ),
                // ),
                // //END OF SHOW ALL EXPENSES BUTTON
              ],
            );
          }),
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: _currentPage,
      //   onTap: (int newPage) {
      //     setState(() {
      //       _currentPage = newPage;
      //     });

      //     // Navigate to the corresponding page
      //     switch (newPage) {
      //       case 0:
      //         // Expenses page (current page)
      //         break;
      //       case 1:
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(builder: (context) => const Dashboard()),
      //         );
      //         break;
      //       case 2:
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(builder: (context) => const Budget()),
      //         );
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
      //         color: Color(0xFF23cc71),
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
      //         color: Color(0xFF8A000000),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}

//TODAY TRANSACTIONS LISTVIEW1
class Todaytransactions extends StatelessWidget {
  Todaytransactions({
    super.key,
  });
  final userid = FirebaseAuth.instance.currentUser!.uid;
  Update up = Update();
  @override
  Widget build(BuildContext context) {
    // gettotal();
    DateTime now = DateTime.now();
    DateTime startOfToday =
        DateTime(now.year, now.month, now.day); // Start of current day
    DateTime endOfToday = DateTime(
        now.year, now.month, now.day, 23, 59, 59); // End of current day

    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(userid)
            .collection('expenses')
            .where('timestamp',
                isGreaterThanOrEqualTo: startOfToday.millisecondsSinceEpoch)
            .where('timestamp',
                isLessThanOrEqualTo: endOfToday.millisecondsSinceEpoch)
            .orderBy("timestamp", descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text("loading"));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No Records"));
          }

          // return ListView(
          //   children: snapshot.data!.docs.map((DocumentSnapshot document) {
          //   Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
          //     return ListTile(
          //       title: Text(data['full_name']),
          //       subtitle: Text(data['company']),
          //     );
          //   }).toList(),
          // );
          var data = snapshot.data!.docs;
          return ListView.builder(
            shrinkWrap: true,
            itemCount: data.length,
            // /physics: NeverScrollableScrollPhysics(),
            //   itemCount: yourItemList.length, // Replace with your actual item list length
            itemBuilder: (context, index) {
              var expensedata = data[index];
              return displayrecords(
                data: expensedata,
                onSelect: () {
                  // print("tapped");
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Container(
                          width: 300,
                          height: 200,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              //DIALOG TITLE HERE
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 40,
                                    alignment: const Alignment(0, 0),
                                    child: const Text(
                                      'You tapped an item!',
                                      style: TextStyle(
                                        fontFamily: 'Ubuntu',
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF001F3F),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: IconButton(
                                      icon: const Icon(Icons.close_rounded),
                                      color: Colors.black,
                                      iconSize: 18,
                                      onPressed: () {
                                        // print('IconButton pressed ...');
                                        Navigator.of(context).pop();
                                      },
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
                              Container(
                                height: 30,
                                child: const Center(
                                  child: Text(
                                    'Would you like to:',
                                    style: TextStyle(
                                      fontFamily: 'Ubuntu',
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ),
                              //END OF TEXT BODY DIALOG
                              const SizedBox(height: 30),
                              //ADD & CANCEL BUTTON HERE
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 115,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: const Color(0xFFFF5963),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color(0xFF33000000),
                                          offset: Offset(0, 2),
                                          blurRadius: 0,
                                        ),
                                      ],
                                    ),
                                    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // Implement logic to delete the item
                                        // print("Delete");

                                        Navigator.of(context).pop();
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              content: Container(
                                                width: 300,
                                                height: 200,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    //DIALOG TITLE HERE
                                                    Row(
                                                      children: [
                                                        Container(
                                                          height: 40,
                                                          child: const Text(
                                                            'Delete Item?',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Ubuntu',
                                                              fontSize: 26,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
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
                                                    Container(
                                                      height: 50,
                                                      child: const Center(
                                                        child: Text(
                                                          'Do you want to delete this item?',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Ubuntu',
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black87,
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
                                                                offset: Offset(
                                                                    0, 2),
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
                                                            style:
                                                                ElevatedButton
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
                                                          width: 115,
                                                          height: 40,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100),
                                                            color: const Color(
                                                                0xFFFF5963),
                                                            boxShadow: const [
                                                              BoxShadow(
                                                                color: Color(
                                                                    0xFF33000000),
                                                                offset: Offset(
                                                                    0, 2),
                                                                blurRadius: 0,
                                                              ),
                                                            ],
                                                          ),
                                                          child: ElevatedButton(
                                                            onPressed:
                                                                () async {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              // Perform delete operation on tap of Delete button
                                                              // Use data['id'] or any unique identifier to delete the item
                                                              await FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'Users')
                                                                  .doc(userid)
                                                                  .collection(
                                                                      "expenses")
                                                                  .doc(
                                                                      expensedata[
                                                                          'id'])
                                                                  .delete();

                                                              print(
                                                                  "Deleteddddddddd");
                                                              // Close dialog
                                                            },
                                                            style:
                                                                ElevatedButton
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
                                                              'Delete',
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
                                      },
                                      ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                      ),
                                      child: const Text(
                                        'Delete',
                                        style: TextStyle(
                                          color: Color(0xFFFFFFFF),
                                          fontFamily: 'Ubuntu',
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 115,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: const Color(0xFF23cc71),
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
                                        // print("updateee");
                                        Navigator.of(context).pop();
                                        up.openNoteBox(context, expensedata);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                      ),
                                      child: const Text(
                                        'Update',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Ubuntu',
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              //END OF ADD & CANCEL BUTTON
                            ],
                          ),
                        ),
                      );
                      // return AlertDialog(
                      //   title: Text('Update or Delete?'),
                      //   content: Text('You tapped an item!'),
                      //   actions: <Widget>[
                      //     TextButton(
                      //       onPressed: () {
                      //         // Implement logic to update the item

                      //         Navigator.of(context).pop();
                      //       },
                      //       child: Text('Cancel'),
                      //     ),
                      //     TextButton(
                      //       onPressed: () {
                      //         // Implement logic to update the item
                      //         print("updateee");
                      //         Navigator.of(context).pop();
                      //         up.openNoteBox(context, expensedata);
                      //       },
                      //       child: Text('Update'),
                      //     ),
                      //     TextButton(
                      //       onPressed: () {
                      //         // Implement logic to delete the item
                      //         print("Delete");

                      //         Navigator.of(context).pop();
                      //         showDialog(
                      //           context: context,
                      //           builder: (BuildContext context) {
                      //             return AlertDialog(
                      //               title: const Text('Delete Item'),
                      //               content: const Text(
                      //                   'Do you want to delete this item?'),
                      //               actions: <Widget>[
                      //                 TextButton(
                      //                   onPressed: () {
                      //                     Navigator.of(context)
                      //                         .pop(); // Close dialog
                      //                   },
                      //                   child: Text('Cancel'),
                      //                 ),
                      //                 TextButton(
                      //                   onPressed: () async {
                      //                     // Perform delete operation on tap of Delete button
                      //                     // Use data['id'] or any unique identifier to delete the item
                      //                     await FirebaseFirestore.instance
                      //                         .collection('Users')
                      //                         .doc(userid)
                      //                         .collection("expenses")
                      //                         .doc(expensedata['id'])
                      //                         .delete();

                      //                     Navigator.of(context).pop();
                      //                     print(
                      //                         "Deleteddddddddd"); // Close dialog
                      //                   },
                      //                   child: Text('Delete'),
                      //                 ),
                      //               ],
                      //             );
                      //           },
                      //         );
                      //       },
                      //       child: Text('Delete'),
                      //     ),
                      //   ],
                      // );
                    },
                  );
                },
              );
            },
          );
        });
  }
}
// ------------------------------------------------------------------------------ WITH UPDATE TO SIYA AND ALL EXPENSE LANG ------------------------------------------------------------------------------
// class Allexpenses extends StatelessWidget {
//   Allexpenses({
//     super.key,
//   });
//   final userid = FirebaseAuth.instance.currentUser!.uid;
//   Update up = Update();
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('Users')
//             .doc(userid)
//             .collection('expenses')
//             .orderBy("timestamp", descending: false)
//             .snapshots(),
//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.hasError) {
//             return const Center(child: Text('Something went wrong'));
//           } else if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: Text("loading"));
//           } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(child: Text("No Records"));
//           }
//           var data = snapshot.data!.docs;
//           return ListView.builder(
//             shrinkWrap: true,
//             itemCount: data.length,
//             itemBuilder: (context, index) {
//               var expensedata = data[index];
//               return displayrecords(
//                 data: expensedata,
//                 onSelect: () {
//                   print("tapped");
//                   showDialog(
//                     context: context,
//                     builder: (BuildContext context) {
//                       return AlertDialog(
//                         content: Container(
//                           width: 300,
//                           height: 200,
//                           child: Column(
//                             mainAxisSize: MainAxisSize.max,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               //DIALOG TITLE HERE
//                               Row(
//                                 children: [
//                                   Container(
//                                     height: 40,
//                                     alignment: Alignment(0, 0),
//                                     child: const Text(
//                                       'You tapped an item!',
//                                       style: TextStyle(
//                                         fontFamily: 'Ubuntu',
//                                         fontSize: 22,
//                                         fontWeight: FontWeight.bold,
//                                         color: Color(0xFF001F3F),
//                                       ),
//                                     ),
//                                   ),
//                                   IconButton(
//                                     icon: const Icon(Icons.close_rounded),
//                                     color: Colors.black,
//                                     iconSize: 18,
//                                     onPressed: () {
//                                       print('IconButton pressed ...');
//                                       Navigator.of(context).pop();
//                                     },
//                                   ),
//                                 ],
//                               ),
//                               //END OF DIALOG TITLE
//                               const Divider(
//                                 color: Colors.black87,
//                                 thickness: 1.5,
//                               ),
//                               const SizedBox(height: 10),
//                               //TEXT BODY DIALOG
//                               Container(
//                                 height: 30,
//                                 child: const Center(
//                                   child: Text(
//                                     'Would you like to:',
//                                     style: TextStyle(
//                                       fontFamily: 'Ubuntu',
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.black87,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               //END OF TEXT BODY DIALOG
//                               const SizedBox(height: 30),
//                               //ADD & CANCEL BUTTON HERE
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Container(
//                                     width: 115,
//                                     height: 40,
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(100),
//                                       color: Color(0xFFFF5963),
//                                       boxShadow: const [
//                                         BoxShadow(
//                                           color: Color(0xFF33000000),
//                                           offset: Offset(0, 2),
//                                           blurRadius: 0,
//                                         ),
//                                       ],
//                                     ),
//                                     ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                     child: ElevatedButton(
//                                       onPressed: () {
//                                         // Implement logic to delete the item
//                                         print("Delete");

//                                         Navigator.of(context).pop();
//                                         showDialog(
//                                           context: context,
//                                           builder: (BuildContext context) {
//                                             return AlertDialog(
//                                               content: Container(
//                                                 width: 300,
//                                                 height: 200,
//                                                 child: Column(
//                                                   mainAxisSize:
//                                                       MainAxisSize.max,
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment
//                                                           .spaceEvenly,
//                                                   children: [
//                                                     //DIALOG TITLE HERE
//                                                     Row(
//                                                       children: [
//                                                         Container(
//                                                           height: 40,
//                                                           child: const Text(
//                                                             'Delete item',
//                                                             style: TextStyle(
//                                                               fontFamily:
//                                                                   'Ubuntu',
//                                                               fontSize: 26,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .bold,
//                                                               color: Color(
//                                                                   0xFF001F3F),
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                     //END OF DIALOG TITLE
//                                                     const Divider(
//                                                       color: Colors.black87,
//                                                       thickness: 1.5,
//                                                     ),
//                                                     const SizedBox(height: 10),
//                                                     //TEXT BODY DIALOG
//                                                     Container(
//                                                       height: 50,
//                                                       child: const Center(
//                                                         child: Text(
//                                                           'Do you want to delete this item?',
//                                                           style: TextStyle(
//                                                             fontFamily:
//                                                                 'Ubuntu',
//                                                             fontSize: 20,
//                                                             fontWeight:
//                                                                 FontWeight.bold,
//                                                             color:
//                                                                 Colors.black87,
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     //END OF TEXT BODY DIALOG
//                                                     const SizedBox(height: 30),

//                                                     //DELETE & CANCEL BUTTON HERE
//                                                     Row(
//                                                       mainAxisAlignment:
//                                                           MainAxisAlignment
//                                                               .spaceBetween,
//                                                       children: [
//                                                         Container(
//                                                           width: 115,
//                                                           height: 40,
//                                                           decoration:
//                                                               BoxDecoration(
//                                                             borderRadius:
//                                                                 BorderRadius
//                                                                     .circular(
//                                                                         100),
//                                                             color: Colors.white,
//                                                             boxShadow: const [
//                                                               BoxShadow(
//                                                                 color: Color(
//                                                                     0xFF33000000),
//                                                                 offset: Offset(
//                                                                     0, 2),
//                                                                 blurRadius: 0,
//                                                               ),
//                                                             ],
//                                                           ),
//                                                           child: ElevatedButton(
//                                                             onPressed: () {
//                                                               Navigator.of(
//                                                                       context)
//                                                                   .pop();
//                                                             },
//                                                             style:
//                                                                 ElevatedButton
//                                                                     .styleFrom(
//                                                               backgroundColor:
//                                                                   Colors
//                                                                       .transparent,
//                                                               elevation: 0,
//                                                               shape:
//                                                                   RoundedRectangleBorder(
//                                                                 borderRadius:
//                                                                     BorderRadius
//                                                                         .circular(
//                                                                             100),
//                                                               ),
//                                                             ),
//                                                             child: const Text(
//                                                               'Cancel',
//                                                               style: TextStyle(
//                                                                 fontFamily:
//                                                                     'Ubuntu',
//                                                                 color: Color(
//                                                                     0xFF23cc71),
//                                                                 fontSize: 18,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w600,
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         ),
//                                                         Container(
//                                                           width: 115,
//                                                           height: 40,
//                                                           decoration:
//                                                               BoxDecoration(
//                                                             borderRadius:
//                                                                 BorderRadius
//                                                                     .circular(
//                                                                         100),
//                                                             color: const Color(
//                                                                 0xFFFF5963),
//                                                             boxShadow: const [
//                                                               BoxShadow(
//                                                                 color: Color(
//                                                                     0xFF33000000),
//                                                                 offset: Offset(
//                                                                     0, 2),
//                                                                 blurRadius: 0,
//                                                               ),
//                                                             ],
//                                                           ),
//                                                           child: ElevatedButton(
//                                                             onPressed:
//                                                                 () async {
//                                                               Navigator.of(
//                                                                       context)
//                                                                   .pop();
//                                                               // Perform delete operation on tap of Delete button
//                                                               // Use data['id'] or any unique identifier to delete the item
//                                                               await FirebaseFirestore
//                                                                   .instance
//                                                                   .collection(
//                                                                       'Users')
//                                                                   .doc(userid)
//                                                                   .collection(
//                                                                       "expenses")
//                                                                   .doc(
//                                                                       expensedata[
//                                                                           'id'])
//                                                                   .delete();

//                                                               print(
//                                                                   "Deleteddddddddd"); // Close dialog
//                                                             },
//                                                             style:
//                                                                 ElevatedButton
//                                                                     .styleFrom(
//                                                               backgroundColor:
//                                                                   Colors
//                                                                       .transparent,
//                                                               elevation: 0,
//                                                               shape:
//                                                                   RoundedRectangleBorder(
//                                                                 borderRadius:
//                                                                     BorderRadius
//                                                                         .circular(
//                                                                             100),
//                                                               ),
//                                                             ),
//                                                             child: const Text(
//                                                               'Delete',
//                                                               style: TextStyle(
//                                                                 color: Color(
//                                                                     0xFFFFFFFF),
//                                                                 fontFamily:
//                                                                     'Ubuntu',
//                                                                 fontSize: 18,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w600,
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                     const SizedBox(height: 5),
//                                                     //END OF DELETE & CANCEL BUTTOM
//                                                   ],
//                                                 ),
//                                               ),
//                                             );
//                                           },
//                                         );
//                                       },
//                                       ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                       style: ElevatedButton.styleFrom(
//                                         backgroundColor: Colors.transparent,
//                                         elevation: 0,
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(100),
//                                         ),
//                                       ),
//                                       child: const Text(
//                                         'Delete',
//                                         style: TextStyle(
//                                           color: Color(0xFFFFFFFF),
//                                           fontFamily: 'Ubuntu',
//                                           fontSize: 18,
//                                           fontWeight: FontWeight.w600,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   Container(
//                                     width: 115,
//                                     height: 40,
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(100),
//                                       color: const Color(0xFF23cc71),
//                                       boxShadow: const [
//                                         BoxShadow(
//                                           color: Color(0xFF33000000),
//                                           offset: Offset(0, 2),
//                                           blurRadius: 0,
//                                         ),
//                                       ],
//                                     ),
//                                     child: ElevatedButton(
//                                       onPressed: () {
//                                         print("updateee");
//                                         Navigator.of(context).pop();
//                                         up.openNoteBox(context, expensedata);
//                                       },
//                                       style: ElevatedButton.styleFrom(
//                                         backgroundColor: Colors.transparent,
//                                         elevation: 0,
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(100),
//                                         ),
//                                       ),
//                                       child: const Text(
//                                         'Update',
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                           fontFamily: 'Ubuntu',
//                                           fontSize: 20,
//                                           fontWeight: FontWeight.w700,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(height: 5),
//                               //END OF ADD & CANCEL BUTTON
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                   // showDialog(
//                   //   context: context,
//                   //   builder: (BuildContext context) {
//                   //     return AlertDialog(
//                   //       title: Text('Update or Delete?'),
//                   //       content: Text('You tapped an item!'),
//                   //       actions: <Widget>[
//                   //         TextButton(
//                   //           onPressed: () {
//                   //             // Implement logic to update the item

//                   //             Navigator.of(context).pop();
//                   //           },
//                   //           child: Text('Cancel'),
//                   //         ),
//                   //         TextButton(
//                   //           onPressed: () {
//                   //             // Implement logic to update the item
//                   //             print("updateee");
//                   //             Navigator.of(context).pop();
//                   //             up.openNoteBox(context, expensedata);
//                   //           },
//                   //           child: Text('Update'),
//                   //         ),
//                   //         TextButton(
//                   //           onPressed: () {
//                   //             // Implement logic to delete the item
//                   //             print("Delete");

//                   //             Navigator.of(context).pop();
//                   //             showDialog(
//                   //               context: context,
//                   //               builder: (BuildContext context) {
//                   //                 return AlertDialog(
//                   //                   title: const Text('Delete Item'),
//                   //                   content: const Text(
//                   //                       'Do you want to delete this item?'),
//                   //                   actions: <Widget>[
//                   //                     TextButton(
//                   //                       onPressed: () {
//                   //                         Navigator.of(context)
//                   //                             .pop(); // Close dialog
//                   //                       },
//                   //                       child: Text('Cancel'),
//                   //                     ),
//                   //                     TextButton(
//                   //                       onPressed: () async {
//                   //                         // Perform delete operation on tap of Delete button
//                   //                         // Use data['id'] or any unique identifier to delete the item
//                   //                         await FirebaseFirestore.instance
//                   //                             .collection('Users')
//                   //                             .doc(userid)
//                   //                             .collection("expenses")
//                   //                             .doc(expensedata['id'])
//                   //                             .delete();

//                   //                         Navigator.of(context).pop();
//                   //                         print(
//                   //                             "Deleteddddddddd"); // Close dialog
//                   //                       },
//                   //                       child: Text('Delete'),
//                   //                     ),
//                   //                   ],
//                   //                 );
//                   //               },
//                   //             );
//                   //           },
//                   //           child: Text('Delete'),
//                   //         ),
//                   //       ],
//                   //     );
//                   //   },
//                   // );
//                   // Implement deletion logic here
//                   // For example, use data['id'] to delete the corresponding item from Firestore
//                   // FirebaseFirestore.instance.collection('your_collection_path').doc(data['id']).delete();
//                 },
//               );
//             },
//           );
//         });
//   }
// }

class BudgetExpenses extends StatelessWidget {
  final String? id;
  BudgetExpenses({super.key, required this.id});

  final userid = FirebaseAuth.instance.currentUser!.uid;
  Update up = Update();
  double totalAmount = 0.0;
  @override
  Widget build(BuildContext context) {
    // print('THE SELECTED is $id');

    // Determine the query based on whether id is null or not

    final query = (id == 'null' || id == null)
        ? FirebaseFirestore.instance
            .collection('Users')
            .doc(userid)
            .collection('expenses')
            .orderBy("timestamp", descending: false)
        : (id == '0')
            ? FirebaseFirestore.instance
                .collection('Users')
                .doc(userid)
                .collection('expenses')
                .where('budget_id',
                    isEqualTo:
                        'No available id') // Modify as per your requirement
                .orderBy("timestamp", descending: true)
            : FirebaseFirestore.instance
                .collection('Users')
                .doc(userid)
                .collection('expenses')
                .where('budget_id', isEqualTo: id)
                .orderBy("timestamp", descending: true);

    return StreamBuilder<QuerySnapshot>(
        stream: query.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text("loading"));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No Records"));
          }

          var data = snapshot.data!.docs;

          // for (var expensedata in data) {
          //   final amount = (expensedata['amount'] as num).toDouble();

          //   totalAmount += amount;
          // }

          // TotalExpense(totalAmount: totalAmount);

          return ListView.builder(
            shrinkWrap: true,
            itemCount: data.length,
            itemBuilder: (context, index) {
              var expensedata = data[index];
              return displayrecords(
                data: expensedata,
                onSelect: () {
                  // print("tapped");
                },
              );
            },
          );
        });
  }
}

// class TotalExpense {
//   final double totalAmount;

//   TotalExpense({required this.totalAmount});

//   double getTotal() {
//     return totalAmount;
//   }
// }

class TotalExpense {
  final String? id;

  TotalExpense({required this.id});

  final String userid = FirebaseAuth.instance.currentUser!.uid;

  Future<double> getTotal() async {
    double totalAmount = 0.0;

    try {
      // Determine the query based on the id
      final query = (id == 'null' || id == null)
          ? FirebaseFirestore.instance
              .collection('Users')
              .doc(userid)
              .collection('expenses')
              .orderBy("timestamp", descending: false)
          : (id == '0')
              ? FirebaseFirestore.instance
                  .collection('Users')
                  .doc(userid)
                  .collection('expenses')
                  .where('budget_id', isEqualTo: 'No available id')
                  .orderBy("timestamp", descending: true)
              : FirebaseFirestore.instance
                  .collection('Users')
                  .doc(userid)
                  .collection('expenses')
                  .where('budget_id', isEqualTo: id)
                  .orderBy("timestamp", descending: true);

      // Fetch the snapshots
      QuerySnapshot snapshot = await query.get();

      // Check if snapshot contains any documents
      if (snapshot.docs.isEmpty) {
        throw Exception("No records found for the given budget ID.");
      }

      // Calculate the total amount
      for (var expensedata in snapshot.docs) {
        final amount = (expensedata['amount'] as num?)
            ?.toDouble(); // Cast to double and handle null
        if (amount != null) {
          totalAmount += amount; // Sum the amounts
        }
      }
    } catch (e) {
      print('Error retrieving total amount: $e');
    }

    return totalAmount;
  }
}
