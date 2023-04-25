import 'package:flutter/material.dart';

String introText = "With arti-eyes you can also use voice commands, to, navigate between screens, to get time and date, and even to send the SOS message. To issue a voice command say, 'Hey Vanessa', then issue your command. To get available commands say, 'Hey Vannessa, What does this app do?'";


class IntroPage7 extends StatelessWidget {
  const IntroPage7({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
            ),
            const Center(
              child: Text(
                "Speech Commands",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 25,
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
                "images/speech commands.png",
                width: MediaQuery.of(context).size.width * 0.80,
                height: MediaQuery.of(context).size.height * 0.33,
              ),
            ),

            Container(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(
                  introText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 15,
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
