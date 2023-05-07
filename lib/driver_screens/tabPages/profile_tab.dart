import 'dart:async';

import 'package:elrick_trans_app/widgets/progress_dialog.dart';
import 'package:flutter/material.dart';
import '../../global/global.dart';
import '../../widgets/driver_info_design_ui.dart';




class DriverProfileTabPage extends StatefulWidget
{
  const DriverProfileTabPage({Key? key}) : super(key: key);

  @override
  State<DriverProfileTabPage> createState() => _DriverProfileTabPageState();
}

class _DriverProfileTabPageState extends State<DriverProfileTabPage>
{
  bool checkInternet = false;
  bool awaitDriverInfo = true;

  checkIfLoadingDriverInfo(){
    if(awaitDriverInfo == true) {
      Timer(const Duration(seconds: 30), () async {
        if(awaitDriverInfo == true){
          setState(() {
            checkInternet = true;
          });
          print('check your internet');
        }
      });
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(onlineDriverData.name != null){
      setState(() {
        awaitDriverInfo = false;
        checkInternet = false;
      });
    }

    checkIfLoadingDriverInfo();

  }
  @override
  Widget build(BuildContext context)
  {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/Absolute_BG.png"),
              fit: BoxFit.fill)
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: awaitDriverInfo ? ProgressDialog(
          message: 'Loading Driver Profile',
        ):SingleChildScrollView(
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.06,
              ),

              CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.25,
              ),

              //name
              Text(
                onlineDriverData.name!,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.055,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(
                height: 0,
                width: MediaQuery.of(context).size.width * 0.7,
                child: const Divider(
                  color: Colors.white,
                  height: 2,
                  thickness: 2,
                ),
              ),

              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),

              //phone
              InfoDesignUIWidget(
                textInfo: onlineDriverData.phone,
                iconData: Icons.phone_iphone,
              ),

              //email
              InfoDesignUIWidget(
                textInfo: onlineDriverData.email,
                iconData: Icons.email,
              ),

              InfoDesignUIWidget(
                textInfo: onlineDriverData.car_model,
                iconData: Icons.car_repair,
              ),

              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),

              GestureDetector(
                onTap: (){
                  fAuth.signOut();
                },
                child: Container(
                  height: 45,
                  width: MediaQuery.of(context).size.width * 0.75,
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Text(
                      'Sign Out',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ),
            ],
          )
              )
        ),
    );
  }
}
