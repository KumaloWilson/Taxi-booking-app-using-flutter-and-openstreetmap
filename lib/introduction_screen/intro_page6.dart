import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

String introText = "Setup your emergency contacts in the SOS Tab. Whenever you need assistance or when there is an emergency, Shake your phone continuosly for 5 seconds to send out a SOS message";


class IntroPage6 extends StatelessWidget {
  const IntroPage6({Key? key}) : super(key: key);

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
                "Emergency",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 30,
                    color: Color.fromARGB(255, 3, 152, 158),
                    fontWeight: FontWeight.bold

                ),
              ),
            ),

            Center(
              child: Lottie.asset("images/4096-heal.json",
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.34

              ),
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
