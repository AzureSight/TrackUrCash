import 'package:finalproject_cst9l/auth/authenticator.dart';
import 'package:finalproject_cst9l/intro%20pages/intro_page1.dart';
import 'package:finalproject_cst9l/intro%20pages/intro_page2.dart';
import 'package:finalproject_cst9l/intro%20pages/intro_page3.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  PageController _controller = PageController();

  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 2);
              });
            },
            children: [
              intro_page1(),
              intro_page2(),
              intro_page3(),
            ],
          ),

          //NAVIGATION BAR HERE
          Container(
            alignment: Alignment(0, 0.65),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //SKIP BUTTON HERE
                onLastPage
                    ? GestureDetector(
                        onTap: () {
                          _controller.jumpToPage(2);
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(left: 50),
                          child: Text(
                            '',
                            style: TextStyle(
                              fontFamily: 'Ubuntu',
                              fontSize: 22,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          _controller.jumpToPage(2);
                        },
                        child: const Text(
                          'Skip',
                          style: TextStyle(
                            fontFamily: 'Ubuntu',
                            fontSize: 22,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                //DOT INDICATOR HERE
                SmoothPageIndicator(controller: _controller, count: 3),

                //NEXT OR DONE BUTTON HERE
                onLastPage
                    ? GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const authenticator();
                              },
                            ),
                          );
                        },
                        child: const Text(
                          'Done',
                          style: TextStyle(
                            fontFamily: 'Ubuntu',
                            fontSize: 22,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          _controller.nextPage(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeIn);
                        },
                        child: const Text(
                          'Next',
                          style: TextStyle(
                            fontFamily: 'Ubuntu',
                            fontSize: 22,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
              ],
            ),
          )
          //END OF NAVIGATION BAR
        ],
      ),
    );
  }
}
