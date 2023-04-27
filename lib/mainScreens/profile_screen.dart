import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../global/global.dart';
import '../widgets/passenger_info_design_ui.dart';


class ProfileScreen extends StatefulWidget
{
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}




class _ProfileScreenState extends State<ProfileScreen>
{
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
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                //name
                Text(
                  userModelCurrentInfo!.name!,
                  style: const TextStyle(
                    fontSize: 30.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 20,
                  width: 200,
                  child: Divider(
                    color: Colors.white,
                    height: 2,
                    thickness: 2,
                  ),
                ),

                const SizedBox(height: 38.0,),

                //phone
                InfoDesignUIWidget(
                  textInfo: userModelCurrentInfo!.phone!,
                  iconData: Icons.phone_iphone,
                ),

                //email
                InfoDesignUIWidget(
                  textInfo: userModelCurrentInfo!.email!,
                  iconData: Icons.email,
                ),

                const SizedBox(
                  height: 20,
                ),

                ElevatedButton(
                  onPressed: ()
                  {
                    SystemNavigator.pop();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.redAccent,
                    padding: EdgeInsets.symmetric(horizontal: 100, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)
                    ),
                  ),
                  child: const Text(
                    "Exit",
                    style: TextStyle(color: Colors.white),
                  ),
                ),

              ],
            ),
          ),
        ),
    );
  }
}
