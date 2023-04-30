import 'package:elrick_trans_app/splashScreen/splash_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../global/global.dart';

class CarInfoScreen extends StatefulWidget {

  @override
  State<CarInfoScreen> createState() => _CarInfoScreenState();
}

class _CarInfoScreenState extends State<CarInfoScreen> {
  TextEditingController carModelTextEditingController = TextEditingController();
  TextEditingController carNumberTextEditingController = TextEditingController();
  TextEditingController carColorTextEditingController = TextEditingController();

  List<String> carTypeList = ["Elrik-Economy", "Elrik-Standard", "Elrik-Mbinga"];
  String? selectedCarType;

  saveCarInfo()
  {
    Map driverCarInfoMap =
    {
      "car_color": carColorTextEditingController.text.trim(),
      "car_number": carNumberTextEditingController.text.trim(),
      "car_model": carModelTextEditingController.text.trim(),
      "type": selectedCarType,
    };

    DatabaseReference driversRef = FirebaseDatabase.instance.ref().child("drivers");
    driversRef.child(currentFirebaseUser!.uid).child("car_details").set(driverCarInfoMap);


    setCarDetailsStatus();

    Fluttertoast.showToast(msg: "Congratulations you're now a driver @ Elrik Trans");

  }

  void setCarDetailsStatus() async{
    SharedPreferences signPrefs = await SharedPreferences.getInstance();
    signPrefs.setBool('car', true);

    getCarDetailsStatus();
  }

  void getCarDetailsStatus() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isCarDetailsProvided = (prefs.getBool('car') ?? false);

    if(isCarDetailsProvided == true){
      print("CAR DETAILS ARE PROVIDED NOW PROCEEDING TO SPLASHSCREEN");
      print("CAR DETAILS ARE PROVIDED NOW PROCEEDING TO SPLASHSCREEN");
      print("CAR DETAILS ARE PROVIDED NOW PROCEEDING TO SPLASHSCREEN");
      print("CAR DETAILS ARE PROVIDED NOW PROCEEDING TO SPLASHSCREEN");

      proceedToSplashOnBoardingScreensIfUserModeIsSet();
    }
    else{
      print('PLEASE ENTER YOUR CAR DETAILS');
      print('PLEASE ENTER YOUR CAR DETAILS');
      print('PLEASE ENTER YOUR CAR DETAILS');
      print('PLEASE ENTER YOUR CAR DETAILS');
    }
  }

  void proceedToSplashOnBoardingScreensIfUserModeIsSet() async{
     await Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const MySplashScreen()));
  }


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context)
  {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/Absolute_BG.png"), fit: BoxFit.fill)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(
                MediaQuery.of(context).size.height * 0.02
            ),
            child: Column(
              children: [

                CircleAvatar(
                  backgroundImage: const AssetImage('images/Elrik.png'),
                  radius: MediaQuery.of(context).size.height * 0.15,
                ),

                const Text(
                  "Enter Car Details",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),

                TextField(
                  controller: carModelTextEditingController,
                  style: const TextStyle(
                      color: Colors.black
                  ),
                  decoration:const InputDecoration(
                    hintText: "Car Model",
                    fillColor: Colors.white,
                    filled: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(
                      left: 11.0,
                      top: 8.0,
                      bottom: 8.0,
                    ),

                  ),
                ),


                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.018,
                ),
                TextField(
                  controller: carNumberTextEditingController,
                  style: const TextStyle(
                      color: Colors.black
                  ),
                  decoration:const InputDecoration(
                    hintText: "Registration Number",
                    fillColor: Colors.white,
                    filled: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(
                      left: 11.0,
                      top: 8.0,
                      bottom: 8.0,
                    ),

                  ),
                ),

                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.018,
                ),
                TextField(
                  controller: carColorTextEditingController,
                  style: const TextStyle(
                      color: Colors.black
                  ),
                  decoration:const InputDecoration(
                    hintText: "Color",
                    fillColor: Colors.white,
                    filled: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(
                      left: 11.0,
                      top: 8.0,
                      bottom: 8.0,
                    ),

                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.008,
                ),
                DropdownButton<String>(
                  dropdownColor: const Color.fromARGB(255, 3, 152, 158),
                  hint: const Text(
                    "Please your avatar",
                    style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black
                    ),
                  ),
                  value: selectedCarType,
                  onChanged: (newValue)
                  {
                    setState((){
                      selectedCarType = newValue.toString();
                    });
                  },
                  items: carTypeList.map((car){
                    return DropdownMenuItem(
                      value: car,
                      child: Row(
                        children: [
                          Image.asset("images/$car.png"),
                          Text(
                            car,
                            style: const TextStyle(
                                color: Colors.white
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  isExpanded: true, //make true to take width of parent widget
                  underline: Container(), //empty line
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                  iconEnabledColor: Colors.white,
                ),



                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.008,
                ),

                ElevatedButton(
                  onPressed: ()
                  {
                    if(carColorTextEditingController.text.isNotEmpty
                        && carNumberTextEditingController.text.isNotEmpty
                        && carModelTextEditingController.text.isNotEmpty
                        && selectedCarType != null)
                    {
                      saveCarInfo();
                    }
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
                    "Register Vehicle",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
