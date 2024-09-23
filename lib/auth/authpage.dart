import 'package:finalproject_cst9l/pages/LoginPage.dart';
import 'package:finalproject_cst9l/pages/RegisterPage.dart';
import 'package:flutter/material.dart';

class authpage extends StatefulWidget {
  const authpage({Key? key}) : super(key: key);

  @override
  State<authpage> createState() => _authpageState();
}

class _authpageState extends State<authpage> {
  bool showloginpage = true;

  void toggleloginsigup() {
    setState(() {
      showloginpage = !showloginpage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showloginpage) {
      return LoginPage(showregisterpage: toggleloginsigup);
    }
    return RegisterPage(showloginpage: toggleloginsigup);
  }
}
