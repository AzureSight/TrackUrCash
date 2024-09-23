import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject_cst9l/pages/Dashboard.dart';
import 'package:finalproject_cst9l/pages/Budget.dart';
import 'package:finalproject_cst9l/pages/displayrecords.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:finalproject_cst9l/pages/Profile.dart';
import 'package:finalproject_cst9l/services/firestore.dart';
import 'package:flutter/material.dart';

class Update {
  int _currentPage = 0;
  final GlobalKey<FormState> _keyform = GlobalKey<FormState>();
  final FirestoreService firestoreService = FirestoreService();
  TextEditingController _expensedetailController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  var uid = Uuid();

  Future<void> submit(expensedata) async {
    // _expensedetailController.text = expensedata['detail'];
    final User = FirebaseAuth.instance.currentUser;
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    String detail = _expensedetailController.text.toString();
    // ignore: non_constant_identifier_names
    var Amount = double.parse(_amountController.text);
    DateTime date = DateTime.now();
    var id = uid.v4();
    String monthyear = DateFormat("MMM y").format(date);
    print(_expensedetailController.text.toString());

    await FirebaseFirestore.instance.collection('Users').doc(User!.uid).get();

    var data = {
      "id": expensedata['id'],
      "detail": detail,
      "amount": Amount,
      "timestamp": expensedata['timestamp'],
      "monthyear": expensedata['monthyear'],
    };
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(User.uid)
        .collection("expenses")
        .doc(expensedata['id'])
        .set(data);
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
    print('Total amount: $total');

    return total;
    // Use the 'total' variable wherever you need it in your code
  }

  //DIALOG BOX TO ADD EXPENSES HERE
  void openNoteBox(context, expensedata) {
    double amount = expensedata['amount'].toDouble();
    String amountAsString = amount.toString();
    _expensedetailController.text = expensedata['detail'].toString();
    _amountController.text = expensedata['amount'].toString();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Form(
          key: _keyform,
          child: Container(
            width: 350,
            height: 320,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 30,
                  child: const Text(
                    'Update Expense',
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
                    ),
                    hintText: expensedata['detail'],
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
                        color: Color(0xFF6F61EF),
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
                    errorBorder: OutlineInputBorder(
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
                  keyboardType: const TextInputType.numberWithOptions(
                      decimal: true), // Set the keyboard type to numeric
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(
                        r'^\d*\.?\d{0,2}')), // Allow up to 2 decimal places
                  ],
                  controller: _amountController,
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
                    ),
                    hintText: amountAsString,
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
                        color: Color(0xFF6F61EF),
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
                const SizedBox(height: 30), // Spacer
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
                            color: Color(0xFF4533EA),
                            fontFamily: 'Ubuntu',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 110,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: const Color(0xFF4533EA),
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
                            submit(expensedata);
                            //CLEAR THE TEXT CONTROLLER
                            _expensedetailController.clear();
                            _amountController.clear();
                            _dateController.clear();

                            //CLOSE THE BOX
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        child: const Text(
                          'Save',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Ubuntu',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
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
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
  //END OF DIALOG BOX
