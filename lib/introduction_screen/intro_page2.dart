import 'package:flutter/material.dart';
String introText = "To navigate the app, use the navigation bar at the bottom of your screen. When you navigate to another screen, The phone will vibrate and then state your current Screen";


class IntroPage2 extends StatelessWidget {
  const IntroPage2({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.20,
            ),
            const Center(
              child: Text(
                "Navigation",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 30,
                    color: Color.fromARGB(255, 3, 152, 158),
                    fontWeight: FontWeight.bold

                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Center(
              child: Image.asset(
                "images/navigation.png",
                width: MediaQuery.of(context).size.width * 0.70,
                height: MediaQuery.of(context).size.height * 0.30,
              ),
            ),

            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(
                  introText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 3, 152, 158),
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
