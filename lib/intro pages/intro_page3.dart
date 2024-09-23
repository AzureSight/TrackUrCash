import 'package:flutter/material.dart';

class intro_page3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 150),
        child: Column(
          children: [
            ClipRRect(
              child: Image.network(
                'https://graphicriver.img.customer.envatousercontent.com/files/435368942/preview.jpg?auto=compress%2Cformat&q=80&fit=crop&crop=top&max-h=8000&max-w=590&s=bfd1b717962020cd354351efb94996e5',
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
                      'Manual Tracking is Gone!',
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
                        "Say goodbye to manual expense tracking. Our application automates the process saving users valuable time.",
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
