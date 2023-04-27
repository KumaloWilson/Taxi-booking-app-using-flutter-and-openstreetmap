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

    Fluttertoast.showToast(msg: "Congratulations you're now a driver @ Elrik Trans");
  }

  void getCarDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isCarDetailsSet = (prefs.getBool('car') ?? false);

    if (isCarDetailsSet == false) {
      print('PLEASE SET YOUR CAR DETAILS');
      Navigator.push(context, MaterialPageRoute(builder: (c) => CarInfoScreen()));
    }
    else{
      print('CAR DETAILS ARE SET NOW PROCEEDING TO NEXT SCREEN');
      print('CAR DETAILS ARE SET NOW PROCEEDING TO NEXT SCREEN');
      print('CAR DETAILS ARE SET NOW PROCEEDING TO NEXT SCREEN');
      print('CAR DETAILS ARE SET NOW PROCEEDING TO NEXT SCREEN');
      print('CAR DETAILS ARE SET NOW PROCEEDING TO NEXT SCREEN');
    }
  }

  void setCarDetails() async{
    SharedPreferences signPrefs = await SharedPreferences.getInstance();
    signPrefs.setBool('car', true);

    getCarDetails();
  }

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
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [

                const SizedBox(height: 10,),

                CircleAvatar(
                  radius: 111,
                  child: ClipOval(
                    child:  Image.asset("images/Elrik.png",
                      height: 400,
                    ),
                  ),
                ),


                const SizedBox(height: 40,),

                const Text(
                  "Enter Your Car Details",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20,),

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

                const SizedBox(height: 15,),

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

                const SizedBox(height: 15,),

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

                const SizedBox(height: 20,),

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



                const SizedBox(height: 20,),

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
                    primary: Colors.black,
                    padding: EdgeInsets.symmetric(horizontal: 110, vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)
                    ),
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
