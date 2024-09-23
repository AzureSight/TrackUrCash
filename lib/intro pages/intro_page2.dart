import 'package:flutter/material.dart';

class intro_page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 150),
        child: Column(
          children: [
            ClipRRect(
              child: Image.network(
                'https://clickup.com/blog/wp-content/uploads/2022/11/managing-project-budgets-blog-feature.png',
                height: 300,
                width: 300,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 45,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Creating a Budget',
                      style: TextStyle(
                          fontFamily: 'Ubuntu',
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          decoration: TextDecoration.none),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        "Craft a comprehensive roadmap detailing the cash flowing in and the parade of anticipated expenses.",
                        style: TextStyle(
                            fontFamily: 'Ubuntu',
                            fontSize: 14,
                            color: Colors.black,
                            decoration: TextDecoration.none),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
