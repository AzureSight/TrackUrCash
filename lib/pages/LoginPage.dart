import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject_cst9l/auth/auth_service.dart';
import 'package:finalproject_cst9l/pages/Profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:finalproject_cst9l/main.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback showregisterpage;
  const LoginPage({Key? key, required this.showregisterpage}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

//UI BELOW

class _LoginPageState extends State<LoginPage> {
  //final  = GlobalKey<FormState>();

  final GlobalKey<FormState> keyform = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  String email = "";
  String password = "";
  final _emailController = TextEditingController();
  FocusNode _emailFocusNode = FocusNode();
  final _passwordController = TextEditingController();
  FocusNode _passwordFocusNode = FocusNode();
  bool _isObscure = true;
  late String errormessage;
  late bool isError;

  @override
  void initState() {
    errormessage = "This is an error";
    isError = false;
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Future checklogin(email, password) async {
  //   showDialog(
  //     context: context,
  //     useRootNavigator: false,
  //     barrierDismissible: false,
  //     builder: (context) => const Center(
  //       child: CircularProgressIndicator(),
  //     ),
  //   );
  //   try {
  //     await FirebaseAuth.instance
  //         .signInWithEmailAndPassword(email: email, password: password);
  //     setState(() {
  //       errormessage = "";
  //     });
  //   } on FirebaseAuthException catch (e) {
  //     print(e);
  //     setState(() {
  //       errormessage = e.message.toString();
  //     });
  //     // TODO
  //   }
  //   Navigator.pop(context);
  // }

  // Future login() async {
  //   showLoadingDialog(context);
  //   await FirebaseAuth.instance.signInWithEmailAndPassword(
  //     email: _emailController.text.trim(),
  //     password: _passwordController.text.trim(),
  //   );
  // }

  // Future login() async {
  //   // Trigger form validation
  //   if (keyform.currentState!.validate()) {
  //     showLoadingDialog(context);
  //     try {
  //       await FirebaseAuth.instance.signInWithEmailAndPassword(
  //         email: _emailController.text.trim(),
  //         password: _passwordController.text.trim(),
  //       );
  //     } catch (e) {
  //       // Handle login errors here
  //       print(e);
  //     } finally {
  //       Navigator.of(context).pop(); // Close the dialog
  //     }
  //   }
  // }
  // Future login() async {
  //   if (keyform.currentState!.validate()) {
  //     showLoadingDialog(context);
  //     try {
  //       await FirebaseAuth.instance.signInWithEmailAndPassword(
  //         email: _emailController.text.trim(),
  //         password: _passwordController.text.trim(),
  //       );
  //     } on FirebaseAuthException catch (e) {
  //       // Display the error message to the user if the widget is still active
  //       if (mounted) {
  //         String errorMessage = 'An error occurred';
  //         if (e.code == 'user-not-found') {
  //           errorMessage = 'No user found for that email.';
  //         } else if (e.code == 'wrong-password') {
  //           errorMessage = 'Wrong password provided for that user.';
  //         } else if (e.code == 'invalid-email') {
  //           errorMessage = 'Invalid email format.';
  //         }

  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text(errorMessage)),
  //         );
  //         keyform.currentState!.reset();
  //         _emailController.clear();
  //         _passwordController.clear();

  //         // Navigate only if the widget is still active
  //         if (mounted) {
  //           Navigator.pushReplacement(
  //             context,
  //             MaterialPageRoute(
  //               builder: (BuildContext context) => LoginPage(
  //                 showregisterpage: () {},
  //               ),
  //             ),
  //           );
  //         }
  //       }
  //     } catch (e) {
  //       print('Login Error: $e');
  //     } finally {
  //       await Future.delayed(Duration(milliseconds: 500));
  //       if (mounted) {
  //         Navigator.of(context).pop(); // Close the dialog
  //       }
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: keyform,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 100, 8, 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //Text App Title
                  const Text(
                    'Track urCash',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      color: Color(0xFF001F3F),
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  //Row for Sign in & Sign up
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 15),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //SIGN IN
                        Container(
                          width: 100,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                blurRadius: 4,
                                color: Color(0xFF23cc71),
                                offset: Offset(0, 6),
                                spreadRadius: 2,
                              )
                            ],
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(0),
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(0),
                            ),
                            border: Border.all(
                              color: const Color(0x93D4D4D4),
                              width: 2,
                            ),
                          ),
                          alignment: const AlignmentDirectional(0.00, 0.00),
                          child: const Text(
                            'Sign in',
                            style: TextStyle(
                              fontFamily: 'Readex Pro',
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        //SIGN UP
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: widget.showregisterpage,
                            // () {
                            //   //Code for this so called button.

                            //   Navigator.push(
                            //       context,
                            //       MaterialPageRoute(
                            //           builder: (context) =>
                            //               const RegisterPage()));
                            // },
                            child: Container(
                              width: 100,
                              height: 50,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 4,
                                    color: Color(0x33000000),
                                    offset: Offset(0, 4),
                                    spreadRadius: 2,
                                  )
                                ],
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(0),
                                  bottomRight: Radius.circular(5),
                                  topLeft: Radius.circular(0),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              alignment: const AlignmentDirectional(0.00, 0.00),
                              child: const Text(
                                'Sign up',
                                style: TextStyle(
                                  fontFamily: 'Readex Pro',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //TextFormField_Email
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(8, 70, 8, 0),
                    child: SizedBox(
                      width: 350,
                      child: TextFormField(
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Email';
                          }

                          return null;
                        },
                        focusNode: _emailFocusNode,
                        autofocus: true,
                        obscureText: false,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () {
                                _emailController.clear();
                              },
                              icon: const Icon(Icons.clear)),
                          labelText: 'Email',
                          labelStyle: const TextStyle(
                            fontFamily: 'Readex Pro',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          hintText: 'Enter your email',
                          hintStyle: const TextStyle(
                            fontFamily: 'Readex Pro',
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xFF23cc71),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xFFFF5963),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xFFFF5963),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        style: const TextStyle(
                          fontFamily: 'Readex Pro',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                  ),
                  //END of TextFormField_Email

                  //TextFormField_Password
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(8, 25, 8, 0),
                    child: Container(
                      width: 350,
                      child: TextFormField(
                        controller: _passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Password';
                          }

                          return null;
                        },
                        focusNode: _passwordFocusNode,
                        autofocus: true,
                        obscureText: _isObscure,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: const TextStyle(
                            fontFamily: 'Readex Pro',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          alignLabelWithHint: false,
                          hintText: 'Enter your password',
                          hintStyle: const TextStyle(
                            fontFamily: 'Readex Pro',
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xFF23cc71),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xFFFF5963),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xFFFF5963),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Container(
                              padding: const EdgeInsets.all(0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: Colors.white,
                              ),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _isObscure = !_isObscure;
                                  });
                                },
                                focusNode: FocusNode(skipTraversal: true),
                                child: Icon(
                                  _isObscure
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: const Color(0xFF57636C),
                                  size: 25,
                                ),
                              ),
                            ),
                          ),
                        ),
                        style: const TextStyle(
                          fontFamily: 'Readex Pro',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  //END of TextFormField_Password

                  //Login Button

                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 35, 0, 25),
                    child: ElevatedButton(
                      onPressed: () {
                        print('Button pressed ...');
                        // checklogin(
                        //     _emailController.text, _passwordController.text);
                        //dispose();

                        login();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF23cc71),
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                        fixedSize: const Size(300, 50),
                      ),
                      child: const Text(
                        'Sign In',
                        style: TextStyle(
                          fontFamily: 'Ubuntu',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ),
                  //END of Login Button

                  //DIVIDER HERE
                  const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                            child: Divider(
                                color: Colors.grey,
                                thickness: 0.5,
                                indent: 20,
                                endIndent: 5)),
                        Text(
                          'Or',
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Ubuntu',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                        Flexible(
                            child: Divider(
                                color: Colors.grey,
                                thickness: 0.5,
                                indent: 5,
                                endIndent: 20)),
                      ],
                    ),
                  ),
                  //END OF DIVIDER

                  //GOOGLE AND FACEBOOK SIGN IN
                  Padding(
                    padding: const EdgeInsets.only(top: 25, bottom: 8),
                    child: SizedBox(
                      height: 50,
                      width: 300,
                      child: ElevatedButton(
                        onPressed: () async {
                          // await _authService.signInWithGoogle();
                          googlelogin();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipOval(
                              child: Image.network(
                                'https://cdn-teams-slug.flaticon.com/google.jpg', // Replace with the path to your Google logo image asset
                                height: 28,
                                width: 28,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            const Text('Continue with Google'),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Padding(
                  //   padding: const EdgeInsets.all(7.0),
                  //   child: SizedBox(
                  //     height: 50,
                  //     width: 300,
                  //     child: ElevatedButton(
                  //       onPressed: () {},
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           ClipOval(
                  //             child: Image.network(
                  //               'https://img.icons8.com/color/48/facebook-new.png', // Replace with the path to your Google logo image asset
                  //               height: 26,
                  //               width: 26,
                  //             ),
                  //           ),
                  //           const SizedBox(
                  //             width: 5,
                  //           ),
                  //           const Text('Continue with Facebook'),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future login() async {
    if (keyform.currentState!.validate()) {
      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) =>
              const Center(child: CircularProgressIndicator()));
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim());

        ///set the profile details on profile para di mag same before
        userprofile();
        // String email = _emailController.text.trim();
        // showErrorMessage('Successfully Logged In! User email: $email');
      } on FirebaseAuthException catch (e) {
        String errorMessage = e.code.toString();
        showErrorMessage(errorMessage);
      }
      navigatorkey.currentState!.popUntil((route) => route.isFirst);
    }
  }

  Future googlelogin() async {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => const Center(child: CircularProgressIndicator()));
    User? user = await _authService.signInWithGoogle();

    if (user != null) {
      print('User signed in: ${user.displayName}');
      // showErrorMessage('Successfully Logged In! User: ${user.displayName}');
    } else {
      print('Sign-in failed');
    }
    navigatorkey.currentState!.popUntil((route) => route.isFirst);
  }

  Future<void> userprofile() async {
    final User = FirebaseAuth.instance.currentUser;

    if (User != null) {
      try {
        // Retrieve all documents from the 'Users' collection
        DocumentSnapshot userDocument = await FirebaseFirestore.instance
            .collection("Users")
            .doc(User.uid)
            .get();

        // Iterate through each document in the collection
        if (userDocument.exists) {
          Map<String, dynamic> userData =
              userDocument.data() as Map<String, dynamic>;
          Profile profile = Profile();
          profile.setname(userData['name']);
          profile.setemail(userData['email']);

          // Retrieve 'name' field from the document
          // Here, you might want to match the user ID with the current user's ID
        }
      } catch (e) {
        print("Error retrieving data: $e");
      }
    } else {
      print("User not logged in");
    }
  }
}
