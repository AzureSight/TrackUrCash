import 'package:flutter/material.dart';

class intro_page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 150),
        child: Column(
          children: [
            ClipRRect(
              child: Image.network(
                'https://graphicriver.img.customer.envatousercontent.com/files/312966725/preview.jpg?auto=compress%2Cformat&q=80&fit=crop&crop=top&max-h=8000&max-w=590&s=3ffe9a1b8df578e4974dea7437e11636',
                //'https://clickup.com/blog/wp-content/uploads/2020/10/workload-management-blog-feature.png',
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
                      'Track your Expenses',
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
                        "Track urCash, a cutting-edge application is designed to streamline and simplify the process of managing personal expense.",
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
