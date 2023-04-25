import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';
import '../global/global.dart';
import '../passenger_assistants/assistance_methods.dart';


class SelectNearestActiveDriversScreen extends StatefulWidget
{
 DatabaseReference? referenceRideRequest;

 SelectNearestActiveDriversScreen({this.referenceRideRequest});

  @override
  State<SelectNearestActiveDriversScreen> createState() => _SelectNearestActiveDriversScreenState();
}



class _SelectNearestActiveDriversScreenState extends State<SelectNearestActiveDriversScreen>
{
  String fareAmount = "";

  getFareAmountAccordingToVehicleType(int index)
  {
    if(tripDirectionDetailsInfo != null)
      {
        if(dList[index]["car_details"]["type"].toString() == "Elrik-Economy")
          {
            fareAmount = (PassengerAssistantMethods.calculateFareAmountFromOriginToDestination(tripDirectionDetailsInfo!) / 2).toStringAsFixed(2);
          }
        
        if(dList[index]["car_details"]["type"].toString() == "Elrik-Standard")
          {
            fareAmount = (PassengerAssistantMethods.calculateFareAmountFromOriginToDestination(tripDirectionDetailsInfo!)).toStringAsFixed(2);
          }
        
        if(dList[index]["car_details"]["type"].toString() == "Elrik-Mbinga")
          {
            fareAmount = (PassengerAssistantMethods.calculateFareAmountFromOriginToDestination(tripDirectionDetailsInfo!) * 2).toStringAsFixed(2);
          }
      }
    return fareAmount;
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
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: const Text(
              "Nearest Online Drivers",
              style: TextStyle(
                fontSize: 18,
              ),
          ),
            leading: IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.white,
              ),
              onPressed: ()
              {
                //delete ride request from database
                widget.referenceRideRequest!.remove();
                Fluttertoast.showToast(msg: "You have cancelled your ride request");

                SystemNavigator.pop();
              },
            ),
        ),
          body: ListView.builder(
            itemCount: dList.length,
            itemBuilder: (BuildContext context, int index)
              {
                return GestureDetector(
                  onTap: ()
                  {
                    setState(() {
                      chosenDriverId = dList[index]["id"].toString();
                    });

                    Navigator.pop(context, "driverChoosed");

                  },
                  child: Card(
                    color: Colors.grey,
                    elevation: 3,
                    shadowColor: Colors.yellow,
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      leading: Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: Image.asset(
                          "images/" + dList[index]["car_details"]["type"].toString() + ".png",
                          width: 70,
                        ),
                      ),
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            dList[index]["name"],
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            dList[index]["car_details"]["car_model"],
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                          SmoothStarRating(
                            rating: dList[index]["ratings"] == null ? 0.0 : double.parse(dList[index]["ratings"]),
                            color: Colors.amber,
                            borderColor: Colors.amber,
                            allowHalfRating: true,
                            starCount: 5,
                            size: 15,
                          ),
                        ],
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Z\$ " + getFareAmountAccordingToVehicleType(index),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.redAccent,
                            ),
                          ),
                         const SizedBox(height: 2.0,),
                          Text(
                            tripDirectionDetailsInfo != null
                                ? tripDirectionDetailsInfo!.duration_text!
                                : "",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 2.0,),
                          Text(
                            tripDirectionDetailsInfo != null
                                ? tripDirectionDetailsInfo!.distance_text!
                                : "",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
          ),
      ),
    );
  }
}
