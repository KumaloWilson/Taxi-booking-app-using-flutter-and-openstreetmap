import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../infoHandler/info_handler.dart';
import '../../mainScreens/trips_history_screen.dart';

class EarningsTabPage extends StatefulWidget {
  const EarningsTabPage({Key? key}) : super(key: key);

  @override
  _EarningsTabPageState createState() => _EarningsTabPageState();
}



class _EarningsTabPageState extends State<EarningsTabPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/Absolute_BG.png"), fit: BoxFit.fill)),
      child: Column(
        children: [
          //earnings
          Container(
            color: Colors.yellow,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 80),
              child: Column(
                children: [

                  const Text(
                    "Total Earnings:",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                    ),
                  ),

                  const SizedBox(height: 5,),

                  Text(
                    "Z\$ " + Provider.of<AppInfo>(context, listen: false).driverTotalEarnings,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                ],
              ),
            ),
          ),

          //total number of trips
          ElevatedButton(
            onPressed: ()
            {
              Navigator.push(context, MaterialPageRoute(builder: (c)=> TripsHistoryScreen()));
            },
            style: ElevatedButton.styleFrom(
                primary: Colors.transparent,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: [

                  Image.asset(
                    "images/car_logo.png",
                    width: 100,
                  ),

                  const SizedBox(
                    width: 6,
                  ),

                  const Text(
                    "Trips Completed",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),

                  Expanded(
                    child: Container(
                      child: Text(
                        Provider.of<AppInfo>(context, listen: false).allDriverTripsHistoryInformationList.length.toString(),
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),


                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}
