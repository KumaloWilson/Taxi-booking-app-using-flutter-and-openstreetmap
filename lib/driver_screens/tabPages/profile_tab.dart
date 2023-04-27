import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../global/global.dart';
import '../../widgets/driver_info_design_ui.dart';




class ProfileTabPage extends StatefulWidget
{
  const ProfileTabPage({Key? key}) : super(key: key);

  @override
  State<ProfileTabPage> createState() => _ProfileTabPageState();
}

class _ProfileTabPageState extends State<ProfileTabPage>
{
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            //name
            Text(
              "Norman Kumalo",
              style: const TextStyle(
                fontSize: 50.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),


            Text(
              titleStarsRating + " driver",
              style: const TextStyle(
                fontSize: 18.0,
                color: Colors.grey,
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
              textInfo: "0771910924",
              iconData: Icons.phone_iphone,
            ),

            //email
            InfoDesignUIWidget(
              textInfo: "normankumz26@gmail.com",
              iconData: Icons.email,
            ),

            InfoDesignUIWidget(
              textInfo: "Toyota Wish",
              iconData: Icons.car_repair,
            ),

            const SizedBox(
              height: 20,
            ),

            ElevatedButton(
              onPressed: ()
              {
                fAuth.signOut();
                SystemNavigator.pop();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.redAccent,
              ),
              child: const Text(
                "Logout",
                style: TextStyle(color: Colors.white),
              ),
            )

          ],
        ),
      ),
    );
  }
}
