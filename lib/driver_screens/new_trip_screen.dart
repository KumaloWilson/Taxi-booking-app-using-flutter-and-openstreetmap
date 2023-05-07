import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../assistants/driver_assistance_methods.dart';
import '../global/global.dart';
import '../models/passenger_ride_request_information.dart';
import '../widgets/fare_amount_collection_dialog.dart';
import '../widgets/progress_dialog.dart';


class NewTripScreen extends StatefulWidget {
  UserRideRequestInformation? userRideRequestDetails;

  NewTripScreen({super.key, this.userRideRequestDetails, });

  @override
  State<NewTripScreen> createState() => _NewTripScreenState();
}




class _NewTripScreenState extends State<NewTripScreen> {
  MapController? _mapController;
  String? address;
  final TileLayer darkTileLayerOptions = TileLayer(
    urlTemplate: "https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png",
    subdomains: ['a', 'b', 'c'],
  );

  String? buttonTitle = "Arrived";
  Color? buttonColor = Colors.white;



  double mapPadding = 0;
  var geoLocator = Geolocator();
  Position? onlineDriverCurrentPosition;
  String rideRequestStatus = "accepted";
  String durationFromOriginToDestination = "";
  bool isRequestDirectionDetails = false;
  var passengerPickupLatLng;
  var passengerDropOffLatLng;


  //Step 1:: when driver accepts the user ride request
  // originLatLng = driverCurrent Location
  // destinationLatLng = user PickUp Location

  //Step 2:: driver already picked up the user in his/her car
  // originLatLng = user PickUp Location => driver current Location
  // destinationLatLng = user DropOff Location

  Future<void> drawPolyLineFromOriginToDestination(LatLng originLatLng, LatLng destinationLatLng) async
  {
    showDialog(
      context: context,
      builder: (BuildContext context) => ProgressDialog(message: "Please wait...",),
    );

    var directionDetailsInfo = await DriverAssistantMethods.obtainOriginToDestinationDirectionDetails(originLatLng, destinationLatLng);

    Navigator.pop(context);

    print("These are points THAT ARE GOING TO BE FOLLOWED BY THE POLYLINE = ${directionDetailsInfo!.e_points}");

    setState(() {
      routeCoordinates;
    });

    print("These are points THAT ARE GOING TO BE FOLLOWED BY THE POLYLINE = $routeCoordinates");
  }

  @override
  void initState() {
    super.initState();

    _mapController = MapController();
    getDriversLocationUpdatesAtRealTime();
    saveAssignedDriverDetailsToUserRideRequest();
  }


  createDriverIconMarker(){
    // if(iconAnimatedMarker == null)
    // {
    //   ImageConfiguration imageConfiguration = createLocalImageConfiguration(context, size: const Size(2, 2));
    //   BitmapDescriptor.fromAssetImage(imageConfiguration, "images/taxi.png").then((value)
    //   {
    //     iconAnimatedMarker = value;
    //   });
    // }
  }


  getDriversLocationUpdatesAtRealTime()
  {
    LatLng oldLatLng = LatLng(0, 0);

    streamSubscriptionDriverLivePosition = Geolocator.getPositionStream()
        .listen((Position position)
    {
      driverCurrentPosition = position;
      onlineDriverCurrentPosition = position;

      LatLng latLngLiveDriverPosition = LatLng(onlineDriverCurrentPosition!.latitude, onlineDriverCurrentPosition!.longitude);


      setState(() {

      });

      oldLatLng = latLngLiveDriverPosition;
      updateDurationTimeAtRealTime();

      //updating driver location at real time in Database
      Map driverLatLngDataMap = {
        "latitude": onlineDriverCurrentPosition!.latitude.toString(),
        "longitude": onlineDriverCurrentPosition!.longitude.toString(),
      };
      FirebaseDatabase.instance.ref().child("All Ride Requests").child(widget.userRideRequestDetails!.rideRequestId!).child("driverLocation").set(driverLatLngDataMap);
    });
  }

  updateDurationTimeAtRealTime() async
  {
    if(isRequestDirectionDetails == false)
    {
      isRequestDirectionDetails = true;

      if(onlineDriverCurrentPosition == null)
      {
        return;
      }

      var originLatLng = LatLng(
        onlineDriverCurrentPosition!.latitude,
        onlineDriverCurrentPosition!.longitude,
      ); //Driver current Location


      var directionInformation;

      if(rideRequestStatus == "accepted")
      {
        setState(() {
          passengerPickupLatLng = widget.userRideRequestDetails!.originLatLng; //user PickUp Location
        });

        directionInformation = await DriverAssistantMethods.obtainOriginToDestinationDirectionDetails(originLatLng, passengerPickupLatLng);
      }

      else {
        setState(() {
          passengerDropOffLatLng = widget.userRideRequestDetails!.destinationLatLng; //user DropOff Location
          passengerPickupLatLng = null;
        });

        directionInformation = await DriverAssistantMethods.obtainOriginToDestinationDirectionDetails(originLatLng, passengerDropOffLatLng);
      }



      if(directionInformation != null)
      {
        setState(() {
          durationFromOriginToDestination = directionInformation.duration_text!;
        });
      }

      isRequestDirectionDetails = false;
    }
  }


  @override
  Widget build(BuildContext context)
  {
    createDriverIconMarker();

    return Scaffold(
      body: Stack(
        children: [

          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: LatLng(driverCurrentPosition!.latitude, driverCurrentPosition!.longitude),
              zoom: 16,
              maxZoom: 25,
              minZoom: 0,
            ),
            children: [
              //Map Theme
              darkTileLayerOptions,

              PolylineLayer(
                polylineCulling: true,
                polylines: [
                  Polyline(
                    points: routeCoordinates,
                    color: Colors.blueAccent,
                    borderColor: Colors.blueAccent,
                    borderStrokeWidth: 3,
                    strokeWidth: 3,
                  ),
                ],
              ),

              // Layer that adds points the map
              MarkerLayer(
                markers: [
                  if (driverCurrentPosition != null)
                    Marker(
                        point: LatLng(driverCurrentPosition!.latitude, driverCurrentPosition!.longitude),
                        builder: (ctx) => Image.asset(
                          'images/taxi.png',
                        )
                    ),
                ],
              ),

              MarkerLayer(
                markers: [
                  if (passengerPickupLatLng != null && passengerDropOffLatLng == null)
                    Marker(
                        point: LatLng(passengerPickupLatLng!.latitude, passengerPickupLatLng!.longitude),
                        builder: (ctx) => Image.asset(
                          'images/passenger.png',
                        )
                    ),

                  if (passengerPickupLatLng == null && passengerDropOffLatLng != null)
                    Marker(
                        point: LatLng(passengerDropOffLatLng!.latitude, passengerDropOffLatLng!.longitude),
                        builder: (ctx) => Image.asset(
                          'images/destination.png',
                        )
                    ),

                  if (passengerPickupLatLng == null && passengerDropOffLatLng != null)
                  Marker(
                      point: LatLng(driverCurrentPosition!.latitude, driverCurrentPosition!.longitude),
                      builder: (ctx) => Image.asset(
                        'images/passenger.png',
                      )
                  ),
                ],
              ),
            ],
          ),

          //ui
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0,
            left: MediaQuery.of(context).size.width * 0.03,
            right: MediaQuery.of(context).size.width * 0.03,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18)
                ),
                boxShadow:
                [
                  BoxShadow(
                    color: Colors.white30,
                    blurRadius: 18,
                    spreadRadius: .5,
                    offset: Offset(0.6, 0.6),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                child: Column(
                  children: [
                    //duration
                    Text(
                      "$durationFromOriginToDestination minutes away",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.yellow,
                      ),
                    ),

                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),

                    const Divider(
                      thickness: 2,
                      height: 2,
                      color: Colors.white,
                    ),

                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    //user name - icon
                    Text(
                      widget.userRideRequestDetails!.userName!,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),

                    //user PickUp Address with icon
                    Row(
                      children: [
                        Image.asset(
                          "images/origin.png",
                          width: MediaQuery.of(context).size.width * 0.06,
                          height: MediaQuery.of(context).size.height * 0.04,
                        ),

                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.03,
                        ),

                        Expanded(
                          child: Text(
                            widget.userRideRequestDetails!.originAddress!,
                            style: const TextStyle(
                              fontSize: 16,
                              overflow: TextOverflow.ellipsis,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),

                    //user DropOff Address with icon
                    Row(
                      children: [
                        Image.asset(
                          "images/destination.png",
                          width: MediaQuery.of(context).size.width * 0.06,
                          height: MediaQuery.of(context).size.height * 0.04,
                        ),

                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.03,
                        ),

                        Expanded(
                          child: Text(
                            widget.userRideRequestDetails!.destinationAddress!,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),

                    const Divider(
                      thickness: 2,
                      height: 2,
                      color: Colors.white,
                    ),

                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),

                    ElevatedButton.icon(
                      onPressed: () async
                      {
                        //[driver has arrived at user PickUp Location] - Arrived Button
                        if(rideRequestStatus == "accepted")
                        {
                          rideRequestStatus = "arrived";

                          FirebaseDatabase.instance.ref()
                              .child("All Ride Requests")
                              .child(widget.userRideRequestDetails!.rideRequestId!)
                              .child("status")
                              .set(rideRequestStatus);

                          setState(() {
                            buttonTitle = "Start Trip"; //start the trip
                            buttonColor = primaryColor;
                          });

                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext c)=> ProgressDialog(
                              message: "Loading...",
                            ),
                          );

                          await drawPolyLineFromOriginToDestination(
                              widget.userRideRequestDetails!.originLatLng!,
                              widget.userRideRequestDetails!.destinationLatLng!
                          );

                          Navigator.pop(context);
                        }
                        //[user has already sit in driver's car. Driver start trip now] - Lets Go Button
                        else if(rideRequestStatus == "arrived")
                        {
                          rideRequestStatus = "ontrip";

                          FirebaseDatabase.instance.ref()
                              .child("All Ride Requests")
                              .child(widget.userRideRequestDetails!.rideRequestId!)
                              .child("status")
                              .set(rideRequestStatus);

                          setState(() {
                            buttonTitle = "End Trip"; //end the trip
                            buttonColor = Colors.redAccent;
                          });
                        }
                        //[user/Driver reached to the dropOff Destination Location] - End Trip Button
                        else if(rideRequestStatus == "ontrip")
                        {
                          endTripNow();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)
                        ),
                      ),
                      icon: const Icon(
                        Icons.directions_car,
                        color: Colors.black,
                        size: 25,
                      ),
                      label: Text(
                        buttonTitle!,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  endTripNow() async
  {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context)=> ProgressDialog(message: "Please wait...",),
    );

    //get the tripDirectionDetails = distance travelled
    var currentDriverPositionLatLng = LatLng(
      onlineDriverCurrentPosition!.latitude,
      onlineDriverCurrentPosition!.longitude,
    );

    var tripDirectionDetails = await DriverAssistantMethods.obtainOriginToDestinationDirectionDetails(
        currentDriverPositionLatLng,
        widget.userRideRequestDetails!.originLatLng!
    );

    //fare amount
    double totalFareAmount = DriverAssistantMethods.calculateFareAmountFromOriginToDestination(tripDirectionDetails!);

    FirebaseDatabase.instance.ref().child("All Ride Requests").child(widget.userRideRequestDetails!.rideRequestId!).child("fareAmount").set(totalFareAmount.toString());

    FirebaseDatabase.instance.ref().child("All Ride Requests").child(widget.userRideRequestDetails!.rideRequestId!).child("status").set("ended");

    streamSubscriptionDriverLivePosition!.cancel();

    Navigator.pop(context);


    //display fare amount in dialog box
    showDialog(
      context: context,
      builder: (BuildContext c)=> FareAmountCollectionDialog(
        totalFareAmount: totalFareAmount,
      ),
    );

    //save fare amount to driver total earnings
    saveFareAmountToDriverEarnings(totalFareAmount);
  }

  saveFareAmountToDriverEarnings(double totalFareAmount)
  {
    FirebaseDatabase.instance.ref().child("drivers").child(currentFirebaseUser!.uid).child("earnings").once().then((snap)
    {
      if(snap.snapshot.value != null) //earnings sub Child exists
        {
          //12
          double oldEarnings = double.parse(snap.snapshot.value.toString());
          double driverTotalEarnings = totalFareAmount + oldEarnings;

          FirebaseDatabase.instance.ref().child("drivers").child(currentFirebaseUser!.uid).child("earnings").set(driverTotalEarnings.toString());
       }
      else //earnings sub Child do not exists
          {
            FirebaseDatabase.instance.ref().child("drivers").child(currentFirebaseUser!.uid).child("earnings").set(totalFareAmount.toString());
          }
    });
  }

  saveAssignedDriverDetailsToUserRideRequest()
  {
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child("All Ride Requests").child(widget.userRideRequestDetails!.rideRequestId!);

    Map driverLocationDataMap = {
      "latitude": driverCurrentPosition!.latitude.toString(),
      "longitude": driverCurrentPosition!.longitude.toString(),
    };

    databaseReference.child("driverLocation").set(driverLocationDataMap);
    databaseReference.child("status").set("accepted");
    databaseReference.child("driverId").set(onlineDriverData.id);
    databaseReference.child("driverName").set(onlineDriverData.name);
    databaseReference.child("driverPhone").set(onlineDriverData.phone);
    databaseReference.child("car_details").set("${onlineDriverData.car_color} ${onlineDriverData.car_model} ${onlineDriverData.car_number}");

  }

}