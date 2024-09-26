//import 'package:finalproj/pages/sample.dart';
import 'dart:async';

import 'package:finalproject_cst9l/main.dart';
import 'package:finalproject_cst9l/pages/Profile.dart';

import 'package:finalproject_cst9l/services/auth.dart';
import 'package:finalproject_cst9l/services/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback showloginpage;
  const RegisterPage({Key? key, required this.showloginpage}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String userName = "";

  String email = "";
  String password = "";
  String confirmPass = "";

  final GlobalKey<FormState> _keyform = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final _userNameController = TextEditingController();
  FocusNode _userNameFocusNode = FocusNode();
  final _emailController = TextEditingController();
  FocusNode _emailFocusNode = FocusNode();
  final _passwordController = TextEditingController();
  FocusNode _passwordFocusNode = FocusNode();
  final _confirmPassController = TextEditingController();
  FocusNode _confirmPassFocusNode = FocusNode();

  bool _isObscure = true;
  bool _isObscureconfrimPass = true;

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
    _userNameController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  // void showLoadingDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (context) {
  //       Future.delayed(Duration(seconds: 2), () {
  //         Navigator.of(context).pop(true); // Dismiss the dialog after 3 seconds
  //       });
  //       return const AlertDialog(
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             CircularProgressIndicator(),
  //             SizedBox(height: 8),
  //             Text('Loading...'),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  void showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  prepareUserData() {
    // Example: Create a Map with user data
    var userData = {
      'name': _userNameController.text.trim(),
      'email': _emailController.text.trim(),
      'username': _userNameController.text.trim(),
    };

    return userData;
  }

  void updateProfileDetails() {
    Profile profile = Profile();
    profile.setname(_userNameController.text.toString());
    profile.setemail(_emailController.text.toString());
  }

  var authservice = Authservice();
  var isloader = false;
  Future signup() async {
    if (_keyform.currentState!.validate()) {
      // showDialog(
      //     context: context,
      //     barrierDismissible: false,
      //     builder: (context) =>
      //         const Center(child: CircularProgressIndicator()));
      // showDialog(
      //   context: context,
      //   barrierDismissible: false,
      //   builder: (context) {
      //     // Set up your timer here
      //     Timer(Duration(seconds: 2), () {
      //       // This function will run after 3 seconds
      //       Navigator.of(context).pop(); // Close the dialog after 3 seconds
      //     });

      //     return Center(
      //       child: CircularProgressIndicator(),
      //     );
      //   },
      // );
      if (passconfirmed()) {
        try {
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
            // email: data['email'],
            // password: data['password'],
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) =>
                  const Center(child: CircularProgressIndicator()));
          updateProfileDetails();
          showErrorMessage('Successfully Logged In');
          await FirestoreService().createUser(
              _userNameController.text.trim(), _emailController.text.trim());
        } on FirebaseAuthException catch (e) {
          String errorMessage = e.code.toString();
          showErrorMessage(errorMessage);
        }
      }
    }

    navigatorkey.currentState!.popUntil((route) => route.isFirst);
  }

  bool passconfirmed() {
    if (_passwordController.text.trim() == _confirmPassController.text.trim()) {
      return true;
    } else {
      showErrorMessage("Passwords do not match!");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _keyform,
          child: Column(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 10, 8, 15),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      //Row for Sign in & Sign up
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 50, 0, 45),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //SIGN IN

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: widget.showloginpage,
                                // () {
                                //   //Code for this so called button.

                                //   Navigator.push(
                                //       context,
                                //       MaterialPageRoute(
                                //           builder: (context) =>
                                //               const LoginPage()));
                                // },
                                child: Container(
                                  width: 100,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: const [
                                      BoxShadow(
                                        blurRadius: 4,
                                        color: Color(0x33000000),
                                        offset: Offset(0, 4),
                                        spreadRadius: 2,
                                      )
                                    ],
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(5),
                                      bottomRight: Radius.circular(0),
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(0),
                                    ),
                                    border: Border.all(
                                      color: const Color(0x93D4D4D4),
                                      width: 2,
                                    ),
                                  ),
                                  alignment:
                                      const AlignmentDirectional(0.00, 0.00),
                                  child: const Text(
                                    'Sign in',
                                    style: TextStyle(
                                      fontFamily: 'Ubuntu',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            //SIGN UP
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
                                  bottomLeft: Radius.circular(0),
                                  bottomRight: Radius.circular(20),
                                  topLeft: Radius.circular(0),
                                  topRight: Radius.circular(5),
                                ),
                                border: Border.all(
                                  color: Color(0x93D4D4D4),
                                  width: 2,
                                ),
                              ),
                              alignment: const AlignmentDirectional(0.00, 0.00),
                              child: const Text(
                                'Sign up',
                                style: TextStyle(
                                  fontFamily: 'Ubuntu',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      //END OF SIGN UP AND SIGN IN BUTTON

                      //LETS CREATE ACCOUNT CONTAINER HERE
                      Container(
                        width: 400,
                        child: const Padding(
                          padding: EdgeInsets.only(left: 25),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Let's create your account!",
                                style: TextStyle(
                                  fontFamily: 'Ubuntu',
                                  color: Color(0xFF001F3F),
                                  fontSize: 25,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      //END OF LETS CREATE ACCOUNT CONTAINER

                      //TextFormField_Name
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: Container(
                          width: 350,
                          child: TextFormField(
                            controller: _userNameController,
                            focusNode: _userNameFocusNode,
                            autofocus: true,
                            obscureText: false,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    _userNameController.clear();
                                  },
                                  icon: const Icon(Icons.clear)),
                              labelText: 'Name',
                              labelStyle: const TextStyle(
                                fontFamily: 'Ubuntu',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              hintText: 'Enter your full name',
                              hintStyle: const TextStyle(
                                fontFamily: 'Ubuntu',
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
                              fontFamily: 'Ubuntu',
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                            keyboardType: TextInputType.name,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null; // Return null if the validation passes
                            },
                          ),
                        ),
                      ),
                      //END of TextFormField_Name

                      //TextFormField_Email
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 15, 8, 15),
                        child: Container(
                          width: 350,
                          child: TextFormField(
                            controller: _emailController,
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
                                fontFamily: 'Ubuntu',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              hintText: 'Enter your email',
                              hintStyle: const TextStyle(
                                fontFamily: 'Ubuntu',
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
                              fontFamily: 'Ubuntu',
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your valid email';
                              }
                              return null; // Return null if the validation passes
                            },
                          ),
                        ),
                      ),
                      //END of TextFormField_Email

                      //TextFormField_Password
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 15),
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
                                fontFamily: 'Ubuntu',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              alignLabelWithHint: false,
                              hintText: 'Enter your password',
                              hintStyle: const TextStyle(
                                fontFamily: 'Ubuntu',
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
                              fontFamily: 'Ubuntu',
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      //END of TextFormField_Password

                      //TextFormField_ConfirmPass
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 15),
                        child: Container(
                          width: 350,
                          child: TextFormField(
                            controller: _confirmPassController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your Password';
                              }
                              return null;
                            },
                            focusNode: _confirmPassFocusNode,
                            autofocus: true,
                            obscureText: _isObscureconfrimPass,
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              labelStyle: const TextStyle(
                                fontFamily: 'Ubuntu',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              alignLabelWithHint: false,
                              hintText: 'Confirm your password',
                              hintStyle: const TextStyle(
                                fontFamily: 'Ubuntu',
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
                                        _isObscureconfrimPass =
                                            !_isObscureconfrimPass;
                                      });
                                    },
                                    focusNode: FocusNode(skipTraversal: true),
                                    child: Icon(
                                      _isObscureconfrimPass
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
                              fontFamily: 'Ubuntu',
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      //END of TextFormField_ConfirmPass

                      //Elevated Button_Register
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                        child: ElevatedButton(
                          onPressed: () {
                            // registerUser(_emailController.text.trim(),
                            //     _passwordController.text.trim());
                            isloader ? print("loading") : signup();

                            // ignore: avoid_print
                            print('Button pressed ...');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF23cc71),
                            padding:
                                EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                            fixedSize: Size(300, 50),
                          ),
                          child: isloader
                              ? const Center(child: CircularProgressIndicator())
                              : const Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    fontFamily: 'Ubuntu',
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                  ),
                                ),
                        ),
                      ),
                      //END of Button_Register

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
                        padding: const EdgeInsets.only(bottom: 8),
                        child: SizedBox(
                          height: 50,
                          width: 300,
                          child: ElevatedButton(
                            onPressed: () {},
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

                      Padding(
                        padding: const EdgeInsets.all(7.0),
                        child: SizedBox(
                          height: 50,
                          width: 300,
                          child: ElevatedButton(
                            onPressed: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ClipOval(
                                  child: Image.network(
                                    'https://img.icons8.com/color/48/facebook-new.png', // Replace with the path to your Google logo image asset
                                    height: 26,
                                    width: 26,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Text('Continue with Facebook'),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     Padding(
                      //       padding: const EdgeInsets.only(right: 20),
                      //       child: Container(
                      //         decoration: BoxDecoration(
                      //           border: Border.all(
                      //               color: Colors.grey.shade300, width: 2),
                      //           borderRadius:
                      //               BorderRadius.all(Radius.circular(15)),
                      //         ),
                      //         child: IconButton(
                      //           onPressed: () {},
                      //           icon: const Image(
                      //             width: 40,
                      //             height: 40,
                      //             // backgroundImage: AssetImage('assets/images/User.png'),
                      //             image: AssetImage('images/google.png'),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //     Padding(
                      //       padding: const EdgeInsets.only(left: 20),
                      //       child: Container(
                      //         decoration: BoxDecoration(
                      //           border: Border.all(
                      //               color: Colors.grey.shade300, width: 2),
                      //           borderRadius:
                      //               BorderRadius.all(Radius.circular(15)),
                      //         ),
                      //         child: IconButton(
                      //           onPressed: () {},
                      //           icon: const Image(
                      //             width: 40,
                      //             height: 40,
                      //             // backgroundImage: AssetImage('assets/images/User.png'),
                      //             image: AssetImage('images/facebook.png'),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      //END OF GOOGLE AND FACEBOOK SIGN IN
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
