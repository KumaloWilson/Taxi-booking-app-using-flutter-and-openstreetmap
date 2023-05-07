import 'package:elrick_trans_app/global/global.dart';
import 'package:flutter/material.dart';

import '../widgets/passenger_info_design_ui.dart';




class PassengerProfileScreen extends StatefulWidget
{
  const PassengerProfileScreen({Key? key}) : super(key: key);

  @override
  State<PassengerProfileScreen> createState() => _PassengerProfileScreenState();
}

class _PassengerProfileScreenState extends State<PassengerProfileScreen>
{
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
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.06,
              ),

              CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.2,
              ),

              //name
              Text(
                userModelCurrentInfo!.name!,
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
                textInfo: userModelCurrentInfo!.phone,
                iconData: Icons.phone_iphone,
              ),

              //email
              InfoDesignUIWidget(
                textInfo: userModelCurrentInfo!.email,
                iconData: Icons.email,
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
          ),
        ),
      ),
    );
  }
}
