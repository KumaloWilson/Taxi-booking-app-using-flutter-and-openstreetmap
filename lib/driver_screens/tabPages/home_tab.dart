import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../../assistants/driver_assistance_methods.dart';
import '../../global/global.dart';
import '../../push_notifications/push_notification system.dart';
import '../../widgets/progress_dialog.dart';

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({Key? key}) : super(key: key);

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {

  MapController? _mapController;
  String? address;
  final TileLayer darkTileLayerOptions = TileLayer(
    urlTemplate: "https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png",
    subdomains: ['a', 'b', 'c'],
  );
  StreamSubscription<Position>? _positionStreamSubscription;
  var geoLocator = Geolocator();
  LocationPermission? _locationPermission;

  bool checkInternet = false;
  bool awaitCoordinates = true;


  checkIfLoadingCoordinates(){
    if(awaitCoordinates == true) {
      Timer(const Duration(seconds: 30), () async {
        if(awaitCoordinates == true){
          setState(() {
            checkInternet = true;
          });
          print('check your internet');
        }
      });
    }
  }

  Future <void> driverIsOnLineNow() async
  {
    Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    driverCurrentPosition = pos;

    Geofire.initialize("activeDrivers");
    Geofire.setLocation(
        currentFirebaseUser!.uid,
        driverCurrentPosition!.latitude,
        driverCurrentPosition!.longitude
    );
    DatabaseReference ref = FirebaseDatabase.instance.ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid)
        .child("newRideStatus");

    ref.set("idle");//Waiting for new ride request
    ref.onValue.listen((event) { });
  }

  updateDriversLocationAtRealTime()
  {
    streamSubscriptionPosition = Geolocator.getPositionStream()
        .listen((Position position)
    {
      driverCurrentPosition = position;

      if(isDriverActive == true)
      {
        Geofire.setLocation(
            currentFirebaseUser!.uid,
            driverCurrentPosition!.latitude,
            driverCurrentPosition!.longitude
        );
      }
    });
  }

  Future<void> _refresh() async {
    // code to update data goes here
  }

  driverIsOfflineNow()
  {
    Geofire.removeLocation(currentFirebaseUser!.uid);
    DatabaseReference? ref = FirebaseDatabase.instance.ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid)
        .child("newRideStatus");

    ref.onDisconnect();
    ref.remove();
    ref = null;

    Future.delayed(const Duration(milliseconds: 2000), ()
    {
      _refresh();
    });
  }

  Future <void> checkIfLocationPermissionAllowed() async {
    _locationPermission = await Geolocator.requestPermission();

    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
    else{
      locateDriverPosition();
    }
  }

  Future <String> locateDriverPosition() async {
    Position cPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    driverCurrentPosition = cPosition;

    String humanReadableAddress = await DriverAssistantMethods.searchAddressForGeographicCoOrdinates(driverCurrentPosition!, context);
    address = humanReadableAddress.toString();


    DriverAssistantMethods.readDriverRatings(context);

    print("this is your address = $humanReadableAddress");
    print("THIS IS THE OFFICIAL ADDRESS  $address");
    print("THIS IS THE OFFICIAL ADDRESS  $address");

    if(address != null){
      setState(() {
        awaitCoordinates = false;
        checkInternet = false;
      });
    }
    else{
      print('ADDRESS NOT FOUND');
    }

    return humanReadableAddress;
  }

  readCurrentDriverInformation() async
  {
    currentFirebaseUser = fAuth.currentUser;

    FirebaseDatabase.instance.ref().child("drivers")
        .child(currentFirebaseUser!.uid)
        .once()
        .then((snap)
    {
      if(snap.snapshot.value != null)
      {
        onlineDriverData.id = (snap.snapshot.value as Map)["id"];
        onlineDriverData.name = (snap.snapshot.value as Map)["name"];
        onlineDriverData.phone = (snap.snapshot.value as Map)["phone"];
        onlineDriverData.email = (snap.snapshot.value as Map)["email"];
        onlineDriverData.car_color = (snap.snapshot.value as Map)["car_details"]["car_color"];
        onlineDriverData.car_model = (snap.snapshot.value as Map)["car_details"]["car_model"];
        onlineDriverData.car_number = (snap.snapshot.value as Map)["car_details"]["car_number"];

        driverVehicleType = onlineDriverData.car_number = (snap.snapshot.value as Map)["car_details"]["type"];

      }
    });

    PushNotificationSystem pushNotificationSystem = PushNotificationSystem();
    pushNotificationSystem.initializeCloudMessaging(context);
    pushNotificationSystem.generatingAndGetToken();

    DriverAssistantMethods.readDriverEarnings(context);
  }


  @override
  void initState() {
    super.initState();
    _mapController = MapController();

    checkIfLocationPermissionAllowed();
    checkIfLoadingCoordinates();
    readCurrentDriverInformation();
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return awaitCoordinates? Container(
      color: Colors.grey,
      child: Center(
          child: checkInternet
              ? Container(
            height: MediaQuery.of(context).size.width * 0.6,
            width: MediaQuery.of(context).size.width * 0.75,
            padding: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20)
            ),

            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.wifi_off,
                    size: MediaQuery.of(context).size.height * 0.099,
                    color: primaryColor,
                  ),
                  const Text(
                    'No Internet! \nPlease Check your Internet Connection',
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.white
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  GestureDetector(
                    onTap: ()
                    {
                      setState(() {
                        checkInternet = false;
                        checkIfLoadingCoordinates();
                        locateDriverPosition();
                      });
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.04,
                      width: MediaQuery.of(context).size.width * 0.2,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)
                      ),

                      child: const Center(
                        child: Text(
                          'Retry',
                          style: TextStyle(
                              fontSize: 12
                          ),
                        ),
                      ),

                    ),
                  ),
                ],
              ),
            ),

          )
              : ProgressDialog(
            message: 'Loading Map',
          )
      ),
    )

        :Stack(
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
          ],
        ),




        //UI for online and offline mode
        statusText != "Online"
            ? Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          color: Colors.black87,
        )
            : Container(),

        //button for online offline mode
        Positioned(
          top: statusText != "Online"
              ? MediaQuery.of(context).size.height * 0.46
              :25,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: ()
                {

                  if(isDriverActive != true){
                      driverIsOnLineNow();
                      updateDriversLocationAtRealTime();

                    setState(()
                    {
                      statusText = "Online";
                      isDriverActive = true;
                      buttonColor = Colors.transparent;
                    });
                    //display Toast
                    Fluttertoast.showToast(msg: "You are now Online!");

                  }
                  else
                  {
                    driverIsOfflineNow();
                    setState(()
                    {
                      statusText = "Offline";
                      isDriverActive = false;
                      buttonColor = primaryColor;
                    });
                    Fluttertoast.showToast(msg: "You are Now Offline!");
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: buttonColor,
                  padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)
                  ),
                ),
                child: statusText != "Online"
                    ? Row(
                  children: [
                    Text(
                      statusText,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const Icon(
                      Icons.wifi_off,
                      color: Colors.black,
                    ),
                  ],
                )
                    : Row(
                  children: [
                    Text(
                      statusText,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),

                    const Icon(
                      Icons.wifi,
                      color: Colors.green,
                      size: 26,
                    ),
                  ],
                ),

              ),
            ],
          ),
        ),
      ],
    );
  }
}

// List<Marker> markers = [
//   Marker(
//     width: 80.0,
//     height: 80.0,
//     point: LatLng(51.5, -0.09),
//     builder: (ctx) => Container(
//       child: IconButton(
//         icon: Icon(Icons.location_on),
//         color: Colors.red,
//         iconSize: 45.0,
//         onPressed: () {
//           print('Marker tapped');
//         },
//       ),
//     ),
//   ),
//   Marker(
//     width: 80.0,
//     height: 80.0,
//     point: LatLng(51.51, -0.1),
//     builder: (ctx) => Container(
//       child: IconButton(
//         icon: Icon(Icons.location_on),
//         color: Colors.red,
//         iconSize: 45.0,
//         onPressed: () {
//           print('Marker tapped');
//         },
//       ),
//     ),
//   ),
// ];
//
// FlutterMap(
// mapController: _mapController,
// options: MapOptions(
// center: LatLng(51.5, -0.09),
// zoom: 13.0,
// ),
// layers: [
// TileLayerOptions(
// urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
// subdomains: ['a', 'b', 'c'],
// ),
// MarkerLayerOptions(
// markers: markers,
// ),
// ],
// ),
