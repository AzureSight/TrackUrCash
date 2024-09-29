import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject_cst9l/notif/notif.dart';
import 'package:finalproject_cst9l/pages/Dashboard.dart';
import 'package:finalproject_cst9l/pages/Budget.dart';
import 'package:finalproject_cst9l/pages/displayrecords.dart';
import 'package:finalproject_cst9l/pages/update.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:finalproject_cst9l/pages/Profile.dart';
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

  Future<void> submit() async {
    final User = FirebaseAuth.instance.currentUser;

    DateTime now = DateTime.now().toUtc().add(Duration(hours: 8));
    // Use the adjusted DateTime to get the milliseconds since epoch
    int timestamp = now.millisecondsSinceEpoch;

    // int timestamp = DateTime.now().millisecondsSinceEpoch;

    String detail = _expensedetailController.text.toString();
    // ignore: non_constant_identifier_names
    var Amount = double.parse(_amountController.text);
    DateTime date = DateTime.now();
    var id = uid.v4();
    String monthyear = DateFormat("MMM y").format(date);
    print(_expensedetailController.text.toString());
    await FirebaseFirestore.instance.collection('Users').doc(User!.uid).get();

    var data = {
      "id": id,
      "detail": detail,
      "amount": Amount,
      "timestamp": timestamp,
      "monthyear": monthyear,
    };
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(User.uid)
        .collection("expenses")
        .doc(id)
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
                            color: Color(0xFF4533EA),
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
  //END OF DIALOG BOX

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF6F61EF),
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
        actions: [],
        centerTitle: false,
        elevation: 2,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openNoteBox,
        //     () {
        //   NotificationService().showNotification(
        //       title: 'Budget Alert', body: 'BUDGET NOTIF TESTING!');
        //   print("pressed");
        // },
        backgroundColor: Color(0xFF23CC71),
        child: const Icon(Icons.add),
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
                                      print('IconButton pressed ...');
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
                                    300, // Replace with an appropriate fixed height
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
                                      print('IconButton pressed ...');
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
                                    300, // Replace with an appropriate fixed height
                                child: Allexpenses(),
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
      //         color: Color(0xFF6F61EF),
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

//TODAY TRANSACTIONS LISTVIEW
class Todaytransactions extends StatelessWidget {
  Todaytransactions({
    super.key,
  });
  final userid = FirebaseAuth.instance.currentUser!.uid;
  Update up = Update();
  @override
  Widget build(BuildContext context) {
    gettotal();
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
            .orderBy("timestamp", descending: false)
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
                  print("tapped");
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
                                children: [
                                  Container(
                                    height: 40,
                                    child: const Text(
                                      'You tapped an item!',
                                      style: TextStyle(
                                        fontFamily: 'Ubuntu',
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF001F3F),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close_rounded),
                                    color: Colors.black,
                                    iconSize: 25,
                                    onPressed: () {
                                      print('IconButton pressed ...');
                                      Navigator.of(context).pop();
                                    },
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
                                    'Would you rather?',
                                    style: TextStyle(
                                      fontFamily: 'Ubuntu',
                                      fontSize: 22,
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
                                    width: 130,
                                    height: 45,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: Color(0xFFFF5963),
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
                                        print("Delete");

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
                                                          width: 130,
                                                          height: 45,
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
                                                                color: Color(
                                                                    0xFF4533EA),
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
                                                          height: 45,
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
                                    width: 130,
                                    height: 45,
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
                                        print("updateee");
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

class Allexpenses extends StatelessWidget {
  Allexpenses({
    super.key,
  });
  final userid = FirebaseAuth.instance.currentUser!.uid;
  Update up = Update();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(userid)
            .collection('expenses')
            .orderBy("timestamp", descending: false)
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
                  print("tapped");
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
                                children: [
                                  Container(
                                    height: 40,
                                    child: const Text(
                                      'You tapped an item!',
                                      style: TextStyle(
                                        fontFamily: 'Ubuntu',
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF001F3F),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close_rounded),
                                    color: Colors.black,
                                    iconSize: 25,
                                    onPressed: () {
                                      print('IconButton pressed ...');
                                      Navigator.of(context).pop();
                                    },
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
                                      fontSize: 22,
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
                                    width: 130,
                                    height: 45,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: Color(0xFFFF5963),
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
                                        print("Delete");

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
                                                            'Delete item',
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
                                                          width: 130,
                                                          height: 45,
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
                                                                color: Color(
                                                                    0xFF4533EA),
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
                                                          height: 45,
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
                                                                  "Deleteddddddddd"); // Close dialog
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
                                    width: 130,
                                    height: 45,
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
                                        print("updateee");
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
                    },
                  );
                  // showDialog(
                  //   context: context,
                  //   builder: (BuildContext context) {
                  //     return AlertDialog(
                  //       title: Text('Update or Delete?'),
                  //       content: Text('You tapped an item!'),
                  //       actions: <Widget>[
                  //         TextButton(
                  //           onPressed: () {
                  //             // Implement logic to update the item

                  //             Navigator.of(context).pop();
                  //           },
                  //           child: Text('Cancel'),
                  //         ),
                  //         TextButton(
                  //           onPressed: () {
                  //             // Implement logic to update the item
                  //             print("updateee");
                  //             Navigator.of(context).pop();
                  //             up.openNoteBox(context, expensedata);
                  //           },
                  //           child: Text('Update'),
                  //         ),
                  //         TextButton(
                  //           onPressed: () {
                  //             // Implement logic to delete the item
                  //             print("Delete");

                  //             Navigator.of(context).pop();
                  //             showDialog(
                  //               context: context,
                  //               builder: (BuildContext context) {
                  //                 return AlertDialog(
                  //                   title: const Text('Delete Item'),
                  //                   content: const Text(
                  //                       'Do you want to delete this item?'),
                  //                   actions: <Widget>[
                  //                     TextButton(
                  //                       onPressed: () {
                  //                         Navigator.of(context)
                  //                             .pop(); // Close dialog
                  //                       },
                  //                       child: Text('Cancel'),
                  //                     ),
                  //                     TextButton(
                  //                       onPressed: () async {
                  //                         // Perform delete operation on tap of Delete button
                  //                         // Use data['id'] or any unique identifier to delete the item
                  //                         await FirebaseFirestore.instance
                  //                             .collection('Users')
                  //                             .doc(userid)
                  //                             .collection("expenses")
                  //                             .doc(expensedata['id'])
                  //                             .delete();

                  //                         Navigator.of(context).pop();
                  //                         print(
                  //                             "Deleteddddddddd"); // Close dialog
                  //                       },
                  //                       child: Text('Delete'),
                  //                     ),
                  //                   ],
                  //                 );
                  //               },
                  //             );
                  //           },
                  //           child: Text('Delete'),
                  //         ),
                  //       ],
                  //     );
                  //   },
                  // );
                  // Implement deletion logic here
                  // For example, use data['id'] to delete the corresponding item from Firestore
                  // FirebaseFirestore.instance.collection('your_collection_path').doc(data['id']).delete();
                },
              );
            },
          );
        });
  }
}
