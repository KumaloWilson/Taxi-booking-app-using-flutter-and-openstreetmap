import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../authentication/login_screen.dart';
import '../authentication/userType.dart';
import '../global/global.dart';
import '../mainScreens/main_screen.dart';
import '../passenger_assistants/assistance_methods.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  late double _loading_progressValue;

  void _updateProgress() {
    const oneSec = Duration(milliseconds: 600);
    Timer.periodic(oneSec, (Timer t) {
      setState(() {
        _loading_progressValue += 0.1;
        // we "finish" downloading here
        if (_loading_progressValue.toStringAsFixed(1) == '1.0') {
          t.cancel();
          return;
        }
      });
    });
  }

  void getUserMode() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    driverMode = (prefs.getBool('driver') ?? false);
    passengerMode = (prefs.getBool('passenger') ?? false);

    if(driverMode == true){
      userType = UserType.driver;

      asUser = 'Driver';
      print("THE CURRENT USER TYPE IS $userType");

    }

    if(passengerMode == true){
      userType = UserType.passenger;

      asUser = 'Passenger';
      print("THE CURRENT USER TYPE IS $userType");


    }

    if(passengerMode == false && driverMode == false){
      asUser = 'BUG DETECTED';
      userType = null;
      print("THE CURRENT USER TYPE IS $userType");

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (c) => selectUserType()));
    }
  }


  startTimer() {
    if(userType == UserType.passenger){
      fAuth.currentUser != null ? PassengerAssistantMethods.readCurrentOnlinePassengerInfo() : null;
    }

    else if(userType == UserType.driver){
      // fAuth.currentUser != null ? BlindUserAssistantMethods.readCurrentOnlineBlindUserInfo(): null;
    }



    Timer(const Duration(seconds: 6), () async {
      if (fAuth.currentUser != null && userType == UserType.passenger) {
        currentFirebaseUser = fAuth.currentUser;

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (c) => MainScreen()));


      }else if (fAuth.currentUser != null && userType == UserType.driver) {
        currentFirebaseUser = fAuth.currentUser;
        //
        // Navigator.pushReplacement(
        //     context, MaterialPageRoute(builder: (c) => AssistantHomeScreen()));
        //

      }
      else {
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => LoginScreen()));
      }
    });
    _updateProgress();
  }

  @override
  void initState() {
    super.initState();
    getUserMode();
    startTimer();
    _loading_progressValue = 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                        "images/Absolute_BG.jpg"
                      ),
              fit: BoxFit.cover
          ),
        ),
        child:Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.20,
            ),
            Image.asset(
              "images/Elrik.png",
              width: MediaQuery.of(context).size.width * 0.86,
              height: MediaQuery.of(context).size.height * 0.46,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.20,
            ),

            SizedBox(
              width: MediaQuery.of(context).size.width * 0.70,
              child: LinearProgressIndicator(
                color: primaryColor,
                backgroundColor: Colors.black,
                valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                value: _loading_progressValue,
              ),
            ),
            Text('${(_loading_progressValue * 100).round()}%'),
          ],
        ),
      ),
    );
  }

}
