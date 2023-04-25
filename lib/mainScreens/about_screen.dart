import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class AboutScreen extends StatefulWidget
{
  @override
  State<AboutScreen> createState() => _AboutScreenState();
}




class _AboutScreenState extends State<AboutScreen>
{
  @override
  Widget build(BuildContext context)
  {
    return Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/Absolute_BG.png"), fit: BoxFit.fill)),
        child:  Scaffold(
          backgroundColor: Colors.transparent,
          body: ListView(

            children: [

              //image
              Container(
                height: 230,
                child: Center(
                  child: Image.asset(
                    "images/Elrik.png",
                    width: 260,
                  ),
                ),
              ),

              Column(
                children: [

                  //company name
                  const Text(
                    "About Us",
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  //about you & your company - write some info
                  const Text(
                    "This app was developed by a group of young developers, "
                        "This is the world's number 1 ride sharing app. Available for all. "
                        "2M+ Zimbabwean people are already using this app.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  const Text(
                    "Don't be selfish tell a friend to tell a friend, "
                        "about the best, convenient and efficient taxi booking app "
                        " \n"
                        " \n"
                        "Download the app on\nGoogle PlayStore and AppStore",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(
                    height: 80,
                  ),

                  //close
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

            ],

          ),
        )


    );

  }
}
