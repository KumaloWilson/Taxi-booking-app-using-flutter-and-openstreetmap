import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../splashScreen/splash_screen.dart';

String introText = "Congratulations, you are now ready to use the app. Double Tap the screen to proceed.";

class IntroPage8 extends StatelessWidget {
  const IntroPage8({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () async{

        final prefs =await SharedPreferences.getInstance();
        prefs.setBool("ON_BOARDING", false);

        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (c) => const MySplashScreen()));
      },
      child: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.15,
              ),
              const Center(
                child: Text(
                  "You're All Set",
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
                  "images/all_set.png",
                  width: MediaQuery.of(context).size.width * 0.80,
                  height: MediaQuery.of(context).size.height * 0.33,
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
      ),
    );
  }
}
