import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:elrick_trans_app/assistants/driver_assistance_methods.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../driver_screens/new_trip_screen.dart';
import '../global/global.dart';
import '../models/passenger_ride_request_information.dart';


class NotificationDialogBox extends StatefulWidget
{
  UserRideRequestInformation? userRideRequestDetails;

  NotificationDialogBox({super.key, this.userRideRequestDetails});

  @override
  State<NotificationDialogBox> createState() => _NotificationDialogBoxState();
}




class _NotificationDialogBoxState extends State<NotificationDialogBox>
{
  @override
  Widget build(BuildContext context) 
  {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      backgroundColor: Colors.transparent,
      elevation: 2,
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.black,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Image.asset(
              "images/cab1.png",
              width: MediaQuery.of(context).size.width * 0.4,
            ),


            //title
            Text(
              "New Ride Request",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: MediaQuery.of(context).size.width * 0.055,
                color: Colors.white
              ),
            ),

            //addresses origin destination
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  //origin location with icon
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05
                  ),


                  Column(
                    children: [
                      const Text(
                          'PICKING POINT',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),

                      Text(
                        widget.userRideRequestDetails!.originAddress!,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  //destination location with icon
                  Column(
                    children: [
                      const Text(
                        'DROPPING POINT',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        widget.userRideRequestDetails!.destinationAddress!,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),


            //buttons cancel accept
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: (){
                      audioPlayer.pause();
                      audioPlayer.stop();
                      audioPlayer = AssetsAudioPlayer();

                      //cancel the rideRequest
                      FirebaseDatabase.instance.ref()
                          .child("All Ride Requests")
                          .child(widget.userRideRequestDetails!.rideRequestId!)
                          .remove().then((value)
                      {
                        FirebaseDatabase.instance.ref()
                            .child("drivers")
                            .child(currentFirebaseUser!.uid)
                            .child("newRideStatus")
                            .set("idle");
                      }).then((value)
                      {
                        FirebaseDatabase.instance.ref()
                            .child("drivers")
                            .child(currentFirebaseUser!.uid)
                            .child("tripsHistory")
                            .child(widget.userRideRequestDetails!.rideRequestId!)
                            .remove();
                      }).then((value)
                      {
                        Fluttertoast.showToast(msg: "Ride Request has been Cancelled, Successfully. Restart App Now.");
                      });

                      Future.delayed(const Duration(milliseconds: 3000), ()
                      {
                        SystemNavigator.pop();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent
                    ),
                    child: const Text(
                      "Reject",
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.08,
                  ),


                  ElevatedButton(
                    onPressed: ()
                    {
                      audioPlayer.pause();
                      audioPlayer.stop();
                      audioPlayer = AssetsAudioPlayer();

                      //accept the rideRequest
                      acceptRideRequest(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor
                    ),
                    child: const Text(
                      "Accept",
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  acceptRideRequest(BuildContext context)
  {
    print('RIDE REQUEST ACCEPT BUTTON CLICKED');

    String getRideRequestId = "";

    FirebaseDatabase.instance.ref().child("drivers").child(currentFirebaseUser!.uid).child("newRideStatus").once().then((snap){
      if(snap.snapshot.value != null){
          getRideRequestId = snap.snapshot.value.toString();

          print('THE RIDE REQUEST ID IS $getRideRequestId');
        }
      else{
          Fluttertoast.showToast(msg: "Invalid Ride Request");
        }



      print('THE RIDE REQUEST ID IS $getRideRequestId');
      print('THE RIDE REQUEST ID IS  ${widget.userRideRequestDetails!.rideRequestId}');

      if(getRideRequestId == widget.userRideRequestDetails!.rideRequestId ||  getRideRequestId == 'idle'){
          FirebaseDatabase.instance.ref().child("drivers").child(currentFirebaseUser!.uid).child("newRideStatus").set("accepted");

          DriverAssistantMethods.pauseLiveLocationUpdates();

          //send new Ride Screen to TripScreen
          Navigator.push(context, MaterialPageRoute(builder: (c) => NewTripScreen(
            userRideRequestDetails: widget.userRideRequestDetails,
          )));
        }

      else
        {
          Fluttertoast.showToast(msg: "This ride request got deleted by the user");
        }

    });
  }

}
