import 'package:flutter/material.dart';

String introText = "Welcome to arti-eyes, an app for people with low vision, or blind-ness. Arti-eyes uses your camera to find objects, read text and detect bank notes.";
String nextTip = "Please swipe the screen to the left to go Next";

class IntroPage1 extends StatelessWidget {
  const IntroPage1({Key? key}) : super(key: key);



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
                "Welcome",
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
                "images/pngegg.png",
                width: MediaQuery.of(context).size.width * 0.80,
                height: MediaQuery.of(context).size.height * 0.32,
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
