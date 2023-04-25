
import 'package:elrick_trans_app/introduction_screen/_driver_onboarding_screen.dart';
import 'package:elrick_trans_app/introduction_screen/_passenger_onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../global/global.dart';

class selectUserType extends StatefulWidget {
  const selectUserType({super.key});

  @override
  _selectUserTypeState createState() => _selectUserTypeState();
}

class _selectUserTypeState extends State<selectUserType> {


  void setPassengerUser() async{
    SharedPreferences signPrefs = await SharedPreferences.getInstance();
    signPrefs.setBool('passenger', true);
    signPrefs.setBool('driver', false);

    getUserMode();
  }

  void setDriverUser() async{
    SharedPreferences signPrefs = await SharedPreferences.getInstance();
    signPrefs.setBool('driver', true);
    signPrefs.setBool('passenger', false);

    getUserMode();
  }

  void getUserMode() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    driverMode = (prefs.getBool('driver') ?? false);
    passengerMode = (prefs.getBool('passenger') ?? false);

    if(driverMode == true){
      userType = UserType.driver;
      print("THE CURRENT USER TYPE IS $userType");

      proceedToSplashOnBoardingScreensIfUserModeIsSet();
    }

    if(passengerMode == true){
      userType = UserType.passenger;
      print("THE CURRENT USER TYPE IS $userType");

      proceedToSplashOnBoardingScreensIfUserModeIsSet();
    }

    if(passengerMode == false && driverMode == false){
      userType = null;
      print("THE CURRENT USER TYPE IS $userType");
    }
  }

  void proceedToSplashOnBoardingScreensIfUserModeIsSet() async{
    if(userType == UserType.passenger){
      await Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => PassengerOnBoardingPage()));
      print("Proceeded With Extreme Caution Now In Passenger User Mode");
    }

    if(userType == UserType.driver){
      await Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => DriverOnBoardingPage()));
      print("Proceeded With Extreme Caution Now In Driver Mode");
    }
  }



  @override
  Widget build(BuildContext context) {
    getUserMode();
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage("images/Absolute_BG.png"), fit: BoxFit.cover),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Center(
              child: Text(
               'Elrick Trans',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ),
        ), //AppBar
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              const Center(
                child: Text(
                  "Join the Elrick Trans Community",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.08,
              ),
              SizedBox(
                child: Lottie.asset("images/136305-taxi-app.json",
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.4
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.10,
              ),

              Column(
                children: [
                  const Text(
                    "Join as..",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setDriverUser();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: const StadiumBorder(),
                      side: BorderSide(
                          color: primaryColor,
                          width: 2
                      ),
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: const Text(
                      "Driver",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.015,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setPassengerUser();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: const StadiumBorder(),
                      side: BorderSide(
                              color: primaryColor,
                              width: 2
                      ),
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: const Text(
                      "Passenger",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
