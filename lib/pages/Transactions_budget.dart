import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject_cst9l/pages/Budget.dart';
import 'package:finalproject_cst9l/pages/Dashboard.dart';
import 'package:finalproject_cst9l/pages/displayrecords.dart';
import 'package:finalproject_cst9l/pages/update.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Transactions_Budget extends StatelessWidget {
  var data = "";

  Transactions_Budget({
    super.key,
    required this.data,
  });

  final userid = FirebaseAuth.instance.currentUser!.uid;
  Update up = Update();
  @override
  Widget build(BuildContext context) {
    // gettotal();
    // DateTime now = DateTime.now();
    // DateTime startOfToday =
    //     DateTime(now.year, now.month, now.day); // Start of current day
    // DateTime endOfToday = DateTime(
    //     now.year, now.month, now.day, 23, 59, 59); // End of current day
    String desc = data.toString();
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(userid)
            .collection('expenses')
            // .where('timestamp',
            //     isGreaterThanOrEqualTo: startOfToday.millisecondsSinceEpoch)
            // .where('timestamp',
            //     isLessThanOrEqualTo: endOfToday.millisecondsSinceEpoch)
            .where('budget', isEqualTo: desc)
            .orderBy("timestamp", descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            // return Center(child: Text('${snapshot.error}'));
            return const Center(child: Text("Something went wrong"));
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
                                    alignment: Alignment(0, 0),
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
                                  IconButton(
                                    icon: const Icon(Icons.close_rounded),
                                    color: Colors.black,
                                    iconSize: 18,
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
                                                                color: Color(
                                                                    0xFF23cc71),
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

                                                              Budget.globalKey
                                                                  .currentState
                                                                  ?.refreshPage(); // Close dialog
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
                },
              );
            },
          );
        });
  }
}
