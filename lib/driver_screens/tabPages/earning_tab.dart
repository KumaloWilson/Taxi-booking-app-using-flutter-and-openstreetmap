import 'package:elrick_trans_app/global/global.dart';
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
            color: primaryColor,
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.08
              ),
              child: Column(
                children: [

                  Text(
                    "Total Earnings:",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: MediaQuery.of(context).size.width * 0.08,
                    ),
                  ),

                  Text(
                    "USD\$ ${Provider.of<AppInfo>(context, listen: false).driverTotalEarnings}",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: MediaQuery.of(context).size.width * 0.1,
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
                backgroundColor: Colors.transparent,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.02,
                  vertical: MediaQuery.of(context).size.height * 0.01
              ),
              child: Row(
                children: [

                  Image.asset(
                    "images/car_logo.png",
                    width: MediaQuery.of(context).size.width * 0.3,
                  ),

                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.1,
                  ),

                  const Text(
                    "Trips Completed",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),

                  Expanded(
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


                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}
