import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:elrick_trans_app/mainScreens/rate_driver_screen.dart';
import 'package:elrick_trans_app/mainScreens/search_places_screen.dart';
import 'package:elrick_trans_app/mainScreens/select_nearest_active_driver_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../assistants/geofire_assistant.dart';
import '../assistants/passenger_assistance_methods.dart';
import '../global/global.dart';
import '../infoHandler/info_handler.dart';
import '../models/active_nearby_availabledrivers.dart';
import '../models/drawpolyline.dart';
import '../widgets/bitmap.dart';
import '../widgets/blinker.dart';
import '../widgets/my_drawer.dart';
import '../widgets/pay_fare_amount_dialog.dart';
import '../widgets/progress_dialog.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  GlobalKey<ScaffoldState> sKey = GlobalKey<ScaffoldState>();

  double searchLocationContainerHeight = 240;
  double waitingResponseFromDriverContainerHeight = 0;
  double assignedDriverInfoContainerHeight = 0;

  MapController? _mapController;
  String? address;
  final TileLayer darkTileLayerOptions = TileLayer(
    urlTemplate: "https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png",
    subdomains: ['a', 'b', 'c'],
    userAgentPackageName: 'dev.fleaflet.flutter_map.example',

  );
  StreamSubscription<Position>? _positionStreamSubscription;
  Position? userCurrentPosition;
  var geoLocator = Geolocator();
  LocationPermission? _locationPermission;


  bool checkInternet = false;
  bool awaitCoordinates = true;
  bool openNavigationDrawer = true;


  List<ActiveNearByAvailableDrivers> onlineNearByAvailableDriversList = [];
  bool activeNearByDriverKeysLoaded = false;
  DatabaseReference? referenceRideRequest;
  String driverRideStatus = "Driver is Coming";
  StreamSubscription<DatabaseEvent>? tripRideRequestInfoStreamSubscription;


  String userRideRequestStatus = "";
  bool requestPositionInfo = true;


  List<Polyline> polyLineSet = [];

  List<Marker>? markersSet = [];
  List<Circle>? circleSet = [];

  String userName = "";
  String userEmail = "";

  BitmapDescriptor? activeNearbyIcon;

  Image activeNearbyDriverIcon = Image.asset(
    'images/taxi.png'
  );


  checkIfLoadingCoordinates() {
    if (awaitCoordinates == true) {
      Timer(const Duration(seconds: 30), () async {
        if (awaitCoordinates == true) {
          setState(() {
            checkInternet = true;
          });
          print('check your internet');
        }
      });
    }
  }

  Future <void> checkIfLocationPermissionAllowed() async {
    _locationPermission = await Geolocator.requestPermission();

    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
    else {
      locateUserPosition();
    }
  }

  Future <String> locateUserPosition() async {
    Position cPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    userCurrentPosition = cPosition;

    String humanReadableAddress = await PassengerAssistantMethods.searchAddressForGeographicCoOrdinates(userCurrentPosition!, context);
    address = humanReadableAddress.toString();

    print("this is your address = $humanReadableAddress");
    print("THIS IS THE OFFICIAL ADDRESS  $address");
    print("THIS IS THE OFFICIAL ADDRESS  $address");

    if (address != null) {
      setState(() {
        awaitCoordinates = false;
        checkInternet = false;
      });
    }
    else {
      print('ADDRESS NOT FOUND');
    }

    initializeGeoFireListener();

    PassengerAssistantMethods.readTripsKeysForOnlineUser(context);

    return humanReadableAddress;
  }


  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _positionStreamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
          setState(() {
            userCurrentPosition = position;
          });
        });

    PassengerAssistantMethods.readCurrentOnlinePassengerInfo();
    checkIfLocationPermissionAllowed();
    checkIfLoadingCoordinates();
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }




  Widget buildBlinkingMarker() {
    return userCurrentPosition != null ? BlinkingMarker(
      point: LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude),
      color: Colors.red,
      size: 30,
      duration: const Duration(milliseconds: 500),
      child: const Icon(
          Icons.location_on,
          size: 30,
          color: Colors.red
      ),
    ) : Container();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: sKey,
      drawer: SizedBox(
        width: MediaQuery
            .of(context)
            .size
            .width * 0.75,
        child: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors.black,
          ),
          child: MyDrawer(
            name: userModelCurrentInfo?.name,
            email: userModelCurrentInfo?.email,
          ),
        ),
      ),
      body: awaitCoordinates ? Container(
        color: Colors.grey,
        child: Center(
            child: checkInternet
                ? Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .width * 0.6,
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.75,
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
                      size: MediaQuery
                          .of(context)
                          .size
                          .height * 0.099,
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
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.02,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          checkInternet = false;
                          checkIfLoadingCoordinates();
                          locateUserPosition();
                        });
                      },
                      child: Container(
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.04,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.2,
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
          : Stack(
        children: [
          FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                center: LatLng(userCurrentPosition!.latitude,
                    userCurrentPosition!.longitude),
                zoom: 16,
                maxZoom: 40,
                minZoom: 0,
              ),
              children: [
                //Map Theme
                darkTileLayerOptions,

                MarkerLayer(
                  markers: markersSet!,
                ),

                if(userDropOffPosition != null)PolylineLayer(
                  polylineCulling: true,
                  polylines: polyLineSet,
                ),


                //
                // CircleLayer(
                //   circles: [],
                // )
              ]
          ),

          //customer hamburger button for drawer
          Positioned(
            top: MediaQuery
                .of(context)
                .size
                .height * 0.09,
            left: MediaQuery
                .of(context)
                .size
                .width * 0.05,
            child: GestureDetector(
              onTap: () {
                if (openNavigationDrawer) {
                  sKey.currentState!.openDrawer();
                } else {
                  //restart the app programatically to update app stats
                  SystemNavigator.pop();
                }
              },
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: MediaQuery
                    .of(context)
                    .size
                    .width * 0.06,
                child: Icon(
                  openNavigationDrawer
                      ? Icons.menu
                      : Icons.close,

                  color: Colors.black,
                  size: MediaQuery
                      .of(context)
                      .size
                      .width * 0.1,
                ),
              ),
            ),
          ),

          //UI for searching Location
          isDestinationFound
              ? Positioned(
            bottom: MediaQuery
                .of(context)
                .size
                .height * 0.01,
            left: MediaQuery
                .of(context)
                .size
                .height * 0.015,
            right: MediaQuery
                .of(context)
                .size
                .height * 0.015,
            child: AnimatedSize(
              curve: Curves.easeIn,
              duration: const Duration(milliseconds: 120),
              child: Container(
                height: searchLocationContainerHeight,
                decoration: const BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  child: Column(
                    children: [
                      //fromLocation
                      Row(
                        children: [
                          const Icon(
                            Icons.my_location,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.027,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "From:",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              Text(
                                Provider
                                    .of<AppInfo>(context)
                                    .userPickUpLocation !=
                                    null
                                    ? "${(Provider
                                    .of<AppInfo>(context)
                                    .userPickUpLocation!
                                    .locationName!)
                                    .substring(0, 26)}..."
                                    : "Searching your address.....",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                            ],
                          ),
                        ],
                      ),

                      SizedBox(
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.02,
                      ),
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.white,
                      ),
                      SizedBox(
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.02,
                      ),

                      //ToLocation
                      GestureDetector(
                        onTap: () async {
                          //search places screen
                          var responseFromSearchScreen = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (c) => SearchPlacesScreen()));

                          if (responseFromSearchScreen == "obtainedDropoff") {
                              setState(() {
                                openNavigationDrawer = false;
                              });

                              print('OBTAINED DROP OFF LOCATION NOW READY TO DRAW A POLYLINE');

                              //draw routes between pickup and dropOff location
                              await drawPolyLineFromOriginToDestination();
                          }
                        },
                        child: Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.027,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "To:",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                Text(
                                  Provider
                                      .of<AppInfo>(context)
                                      .userDropOffLocation !=
                                      null
                                      ? Provider
                                      .of<AppInfo>(context)
                                      .userDropOffLocation!
                                      .locationName!
                                      : "Your desired Location",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.02,
                      ),
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.white,
                      ),

                      SizedBox(
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.02,
                      ),

                      ElevatedButton(
                        onPressed: () {
                          if (Provider.of<AppInfo>(context, listen: false).userDropOffLocation != null) {

                            saveRideRequestInformation();
                          }
                          else {
                            Fluttertoast.showToast(msg: "Please select destination location");
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery
                                .of(context)
                                .size
                                .width * 0.15,
                            vertical: MediaQuery
                                .of(context)
                                .size
                                .height * 0.015,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                        ),
                        child: const Text(
                          "Request Ride",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
              : Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: () async {
                //search places screen
                var responseFromSearchScreen = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (c) => SearchPlacesScreen()));

                if (responseFromSearchScreen == "obtainedDropoff") {
                  setState(() {
                    openNavigationDrawer = false;
                  });

                  //draw routes between pickup and dropOff location
                  await drawPolyLineFromOriginToDestination();
                }
              },

              child: Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.065,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 7,
                        offset: const Offset(0, 3))
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Icon(Icons.search),
                    SizedBox(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.02
                    ),
                    const Text("Search for pickup location"),
                  ],
                ),
              ),
            ),
          ),
          if(isDestinationFound == false)Positioned(
            bottom: MediaQuery
                .of(context)
                .size
                .height * 0.05,
            left: 0,
            right: 0,
            child: buildBlinkingMarker(),
          ),

          //ui for waiting response from driver
          Positioned(
            bottom: MediaQuery
                .of(context)
                .size
                .height * 0.02,
            left: MediaQuery
                .of(context)
                .size
                .width * 0.03,
            right: MediaQuery
                .of(context)
                .size
                .width * 0.03, child: Container(
            height: waitingResponseFromDriverContainerHeight,
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: AnimatedTextKit(
                  animatedTexts: [
                    FadeAnimatedText(
                      'Waiting for Response\nfrom Driver',
                      duration: const Duration(seconds: 6),
                      textAlign: TextAlign.center,
                      textStyle: const TextStyle(
                          fontSize: 35.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    ScaleAnimatedText(
                      'Please wait...',
                      duration: const Duration(seconds: 10),
                      textAlign: TextAlign.center,
                      textStyle: const TextStyle(
                          fontSize: 40.0,
                          color: Colors.white,
                          fontFamily: 'Canterbury'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ),

          //ui for displaying assigned driver information
          Positioned(
            bottom: MediaQuery
                .of(context)
                .size
                .height * 0.02,
            left: MediaQuery
                .of(context)
                .size
                .width * 0.03,
            right: MediaQuery
                .of(context)
                .size
                .width * 0.03,
            child: Container(
              height: assignedDriverInfoContainerHeight,
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //status of ride
                    Center(
                      child: Text(
                        driverRideStatus,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ),

                    SizedBox(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.01,
                    ),

                    const Divider(
                      height: 2,
                      thickness: 2,
                      color: Colors.white54,
                    ),


                    SizedBox(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.02,
                    ),

                    //driver name
                    Text(
                      driverName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white54,
                      ),
                    ),

                    //driver vehicle details
                    Text(
                      driverCarDetails,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white54,
                      ),
                    ),

                    SizedBox(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.02,
                    ),

                    const Divider(
                      height: 2,
                      thickness: 2,
                      color: Colors.white54,
                    ),

                    SizedBox(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.02,
                    ),

                    //call driver button
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                        ),
                        icon: const Icon(
                          Icons.phone_android,
                          color: Colors.black54,
                          size: 22,
                        ),
                        label: const Text(
                          "Call Driver",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
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



  Future<void> drawPolyLineFromOriginToDestination() async {
    var originPosition = Provider.of<AppInfo>(context, listen: false).userPickUpLocation;
    var destinationPosition = Provider.of<AppInfo>(context, listen: false).userDropOffLocation;

    var originLatLng = LatLng(originPosition!.locationLatitude!, originPosition.locationLongitude!);

    var destinationLatLng = LatLng(destinationPosition!.locationLatitude!, destinationPosition.locationLongitude!);

    showDialog(
      context: context,
      builder: (BuildContext context) => ProgressDialog(
        message: "Please wait...",
      ),
    );

    //Fetch Coordinates and draw polyline
    Future<void> fetchRoute() async {
      routeCoordinates.clear();
      List<LatLng> coordinates = await DrawPolyline().fetchRouteCoordinates(originLatLng, destinationLatLng);
      routeCoordinates = coordinates;

    }

    var directionDetailsInfo = await PassengerAssistantMethods.obtainOriginToDestinationDirectionDetails(originLatLng, destinationLatLng);

    setState(() {
      tripDirectionDetailsInfo = directionDetailsInfo;
    });

    Navigator.pop(context);

    print("These are the points = ");
    print(directionDetailsInfo!.e_points);


    polyLineSet.clear();

    fetchRoute();

    polyLineSet.clear();


    Polyline polyline = Polyline(
      color: Colors.redAccent,
      key: const Key("PolylineID"),
      strokeJoin: StrokeJoin.round,
      points: routeCoordinates,
      strokeCap: StrokeCap.round,

    );


    setState(() {
      polyLineSet.add(polyline);
    });

    LatLngBounds boundsLatLng;

    if (originLatLng.latitude > destinationLatLng.latitude && originLatLng.longitude > destinationLatLng.longitude) {
      boundsLatLng = LatLngBounds(destinationLatLng, originLatLng);

    } else if (originLatLng.longitude > destinationLatLng.longitude) {
      boundsLatLng = LatLngBounds(LatLng(originLatLng.latitude, destinationLatLng.longitude),LatLng(destinationLatLng.latitude, originLatLng.longitude));

    } else if (originLatLng.latitude > destinationLatLng.latitude) {
      boundsLatLng = LatLngBounds(LatLng(destinationLatLng.latitude, originLatLng.longitude),LatLng(originLatLng.latitude, destinationLatLng.longitude));

    } else {
      boundsLatLng = LatLngBounds(originLatLng, destinationLatLng);
    }

    _mapController!.move(boundsLatLng.center, 18);

    Marker originMarker = Marker(
      key: const Key("originID"),
      point: originLatLng,
      builder: (ctx) => IconButton(
        icon: const Icon(Icons.location_on),
        color: primaryColor,
        iconSize: 45.0,
        onPressed: () {
          print('Marker tapped');
        },
      ),
    );

    Marker destinationMarker = Marker(
      key: const Key("destinationID"),
      point: destinationLatLng,
      builder: (ctx) => IconButton(
        icon: const Icon(Icons.location_on),
        color: Colors.redAccent,
        iconSize: 45.0,
        onPressed: () {
          print('Marker tapped');
        },
      ),
    );
    setState(() {
      markersSet!.add(originMarker);
      markersSet!.add(destinationMarker);
    });

  }

  initializeGeoFireListener() {
    Geofire.initialize("activeDrivers");

    Geofire.queryAtLocation(
        userCurrentPosition!.latitude, userCurrentPosition!.longitude, 10)!
        .listen((map) {
      print(map);

      if (map != null) {
        var callBack = map['callBack'];

        //latitude will be retrieved from map['latitude']
        //longitude will be retrieved from map['longitude']

        switch (callBack) {
        //whenever driver becomes online add to the list
          case Geofire.onKeyEntered:
            ActiveNearByAvailableDrivers activeNearByAvailableDrivers =
            ActiveNearByAvailableDrivers();

            activeNearByAvailableDrivers.locationLatitude = map['latitude'];
            activeNearByAvailableDrivers.locationLongitude = map['longitude'];
            activeNearByAvailableDrivers.driverId = map['key'];
            GeoFireAssistant.activeNearByAvailableDriversList
                .add(activeNearByAvailableDrivers);

            if (activeNearByDriverKeysLoaded == true) {
              displayActiveDriversOnUserMap();
            }

            break;

        //whenever driver becomes offline remove from the list
          case Geofire.onKeyExited:
            GeoFireAssistant.deleteOfflineDriverFromList(map['key']);
            displayActiveDriversOnUserMap();
            break;

        //whenever driver moves update location
          case Geofire.onKeyMoved:
            ActiveNearByAvailableDrivers activeNearByAvailableDrivers =
            ActiveNearByAvailableDrivers();

            activeNearByAvailableDrivers.locationLatitude = map['latitude'];
            activeNearByAvailableDrivers.locationLongitude = map['longitude'];
            activeNearByAvailableDrivers.driverId = map['key'];
            displayActiveDriversOnUserMap();

            GeoFireAssistant.updateActiveNearByAvailableDriverLocation(
                activeNearByAvailableDrivers);

            break;

        //display online driver on user map
          case Geofire.onGeoQueryReady:
            activeNearByDriverKeysLoaded = true;
            displayActiveDriversOnUserMap();
            break;
        }
      }

      setState(() {});
    });
  }

  displayActiveDriversOnUserMap() {
    setState(() {
      markersSet!.clear();
      circleSet!.clear();

      List<Marker> driversMarkerSet = [];

      for (ActiveNearByAvailableDrivers eachDriver
      in GeoFireAssistant.activeNearByAvailableDriversList) {
        LatLng eachDriverActivePosition =
        LatLng(eachDriver.locationLatitude!, eachDriver.locationLongitude!);


        Marker marker = Marker(
          key: Key(eachDriver.driverId!),
          point: eachDriverActivePosition,
          builder: (ctx) => activeNearbyDriverIcon
        );

        driversMarkerSet.add(marker);
      }

      setState(() {
        markersSet = driversMarkerSet;
      });
    });
  }

  saveRideRequestInformation() {
    //1. save the RideRequest Information
    referenceRideRequest = FirebaseDatabase.instance.ref().child("All Ride Requests").push();

    var originLocation = Provider.of<AppInfo>(context, listen: false).userPickUpLocation;
    var destinationLocation = Provider.of<AppInfo>(context, listen: false).userDropOffLocation;

    Map originLocationMap = {
      //"key": value,
      "latitude": originLocation!.locationLatitude.toString(),
      "longitude": originLocation.locationLongitude.toString(),
    };

    Map destinationLocationMap = {
      //"key": value,
      "latitude": destinationLocation!.locationLatitude.toString(),
      "longitude": destinationLocation.locationLongitude.toString(),
    };

    Map userInformationMap = {
      "origin": originLocationMap,
      "destination": destinationLocationMap,
      "time": DateTime.now().toString(),
      "userName": userModelCurrentInfo!.name,
      "userPhone": userModelCurrentInfo!.phone,
      "originAddress": originLocation.locationName,
      "destinationAddress": destinationLocation.locationName,
      "driverId": "waiting",
    };

    referenceRideRequest!.set(userInformationMap);

    tripRideRequestInfoStreamSubscription =
        referenceRideRequest!.onValue.listen((eventSnap) async {
          if (eventSnap.snapshot.value == null) {
            return;
          }

          if ((eventSnap.snapshot.value as Map)["car_details"] != null) {
            setState(() {
              driverCarDetails =
                  (eventSnap.snapshot.value as Map)["car_details"].toString();
            });
          }

          if ((eventSnap.snapshot.value as Map)["driverPhone"] != null) {
            setState(() {
              driverPhone =
                  (eventSnap.snapshot.value as Map)["driverPhone"].toString();
            });
          }

          if ((eventSnap.snapshot.value as Map)["driverName"] != null) {
            setState(() {
              driverName =
                  (eventSnap.snapshot.value as Map)["driverName"].toString();
            });
          }

          if ((eventSnap.snapshot.value as Map)["status"] != null) {
            userRideRequestStatus =
                (eventSnap.snapshot.value as Map)["status"].toString();
          }

          if ((eventSnap.snapshot.value as Map)["driverLocation"] != null) {
            double driverCurrentPositionLat = double.parse(
                (eventSnap.snapshot.value as Map)["driverLocation"]["latitude"]
                    .toString());
            double driverCurrentPositionLng = double.parse(
                (eventSnap.snapshot.value as Map)["driverLocation"]["longitude"]
                    .toString());

            LatLng driverCurrentPositionLatLng =
            LatLng(driverCurrentPositionLat, driverCurrentPositionLng);

            //status = accepted
            if (userRideRequestStatus == "accepted") {
              updateArrivalTimeToUserPickupLocation(driverCurrentPositionLatLng);
            }

            //status = arrived
            if (userRideRequestStatus == "arrived") {
              setState(() {
                driverRideStatus = "Driver has Arrived";
              });
            }

            //status = ontrip
            if (userRideRequestStatus == "ontrip") {
              updateReachingTimeToUserDropOffLocation(driverCurrentPositionLatLng);
            }

            //status = ended
            if (userRideRequestStatus == "ended") {
              if ((eventSnap.snapshot.value as Map)["fareAmount"] != null) {
                double fareAmount = double.parse((eventSnap.snapshot.value as Map)["fareAmount"].toString());

                var response = await showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext c) => PayFareAmountDialog(
                    fareAmount: fareAmount,
                  ),
                );

                if (response == "cashPayed") {
                  //user can rate the driver now
                  if ((eventSnap.snapshot.value as Map)["driverId"] != null) {
                    String assignedDriverId = (eventSnap.snapshot.value as Map)["driverId"].toString();

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (c) => RateDriverScreen(
                              assignedDriverId: assignedDriverId,
                            )));

                    referenceRideRequest!.onDisconnect();
                    tripRideRequestInfoStreamSubscription!.cancel();
                  }
                }
              }
            }
          }
        });

    onlineNearByAvailableDriversList = GeoFireAssistant.activeNearByAvailableDriversList;
    searchNearestOnlineDrivers();
  }

  updateArrivalTimeToUserPickupLocation(driverCurrentPositionLatLng) async {
    if (requestPositionInfo == true) {
      requestPositionInfo = false;

      LatLng userPickUpPosition =
      LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);

      var directionDetailsInfo = await PassengerAssistantMethods.obtainOriginToDestinationDirectionDetails(driverCurrentPositionLatLng,userPickUpPosition,);

      if (directionDetailsInfo == null) {
        return;
      }

      setState(() {
        driverRideStatus = "Driver is Coming : ${directionDetailsInfo.duration_text} Mins away";
      });

      requestPositionInfo = true;
    }
  }

  updateReachingTimeToUserDropOffLocation(driverCurrentPositionLatLng) async {
    if (requestPositionInfo == true) {
      requestPositionInfo = false;

      var dropOffLocation = Provider.of<AppInfo>(context, listen: false).userDropOffLocation;

      LatLng userDestinationPosition = LatLng(dropOffLocation!.locationLatitude!, dropOffLocation.locationLongitude!);

      var directionDetailsInfo = await PassengerAssistantMethods.obtainOriginToDestinationDirectionDetails(driverCurrentPositionLatLng,userDestinationPosition,);

      if (directionDetailsInfo == null) {
        return;
      }

      setState(() {
        driverRideStatus = "Going towards Destination : ${directionDetailsInfo.duration_text} Mins away";
      });

      requestPositionInfo = true;
    }
  }

  searchNearestOnlineDrivers() async {
    //if there are no active drivers available
    if (onlineNearByAvailableDriversList.isEmpty) {
      //cancel ride request information
      referenceRideRequest!.remove();

      setState(() {
        markersSet!.clear();
        routeCoordinates.clear();
      });

      Fluttertoast.showToast(msg: "No online nearest drivers are available");

      Fluttertoast.showToast(msg: "Restarting the app Now !!");

      Future.delayed(const Duration(milliseconds: 4000), () {
        // SystemNavigator.pop();
      });

      return;
    }

    //active driver available
    await retrieveOnlineDriversInformation(onlineNearByAvailableDriversList);

    var response = await Navigator.push(context, MaterialPageRoute(builder: (c) => SelectNearestActiveDriversScreen(referenceRideRequest: referenceRideRequest)));

    if (response == "driverChoosed") {
      FirebaseDatabase.instance.ref().child("drivers").child(chosenDriverId!).once().then((snap) {
        if (snap.snapshot.value != null) {
          //send notification to that specific driver
          sendNotificationToDriverNow(chosenDriverId!);

          //Display Waiting Response UI from a Driver
          showWaitingResponseFromDriverUI();

          //Response from a Driver
          FirebaseDatabase.instance.ref().child("drivers").child(chosenDriverId!).child("newRideStatus").onValue.listen((eventSnapshot) {
            //1. driver has cancel the rideRequest :: Push Notification
            // (newRideStatus = idle)
            if (eventSnapshot.snapshot.value == "idle") {
              Fluttertoast.showToast(
                  msg: "The driver has cancelled your request. Please choose another driver."
              );

              Future.delayed(const Duration(milliseconds: 3000), () {
                Fluttertoast.showToast(msg: "Please Restart App Now.");

                SystemNavigator.pop();
              });
            }

            //2. driver has accept the rideRequest :: Push Notification
            // (newRideStatus = accepted)
            if (eventSnapshot.snapshot.value == "accepted") {
              //design and display ui for displaying assigned driver information
              showUIForAssignedDriverInfo();
            }
          });
        } else {
          Fluttertoast.showToast(msg: "This driver do not exist. Try again.");
        }
      });
    }
  }

  showUIForAssignedDriverInfo() {
    setState(() {
      waitingResponseFromDriverContainerHeight = 0;
      searchLocationContainerHeight = 0;
      assignedDriverInfoContainerHeight = 240;
    });
  }

  showWaitingResponseFromDriverUI() {
    setState(() {
      searchLocationContainerHeight = 0;
      waitingResponseFromDriverContainerHeight = 220;
    });
  }

  sendNotificationToDriverNow(String chosenDriverId) {
    //assign/SET rideRequestId to newRideStatus in
    // Drivers Parent node for that specific choosen driver
    FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(chosenDriverId)
        .child("newRideStatus")
        .set(referenceRideRequest!.key);

    //automate the push notification service
    FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(chosenDriverId)
        .child("token")
        .once()
        .then((snap) {
      if (snap.snapshot.value != null) {
        String deviceRegistrationToken = snap.snapshot.value.toString();

        //send Notification Now
        PassengerAssistantMethods.sendNotificationToDriverNow(
          deviceRegistrationToken,
          referenceRideRequest!.key.toString(),
          context,
        );

        Fluttertoast.showToast(msg: "Notification sent Successfully.");
      } else {
        Fluttertoast.showToast(msg: "Please choose another driver.");
        return;
      }
    });
  }

  retrieveOnlineDriversInformation(List onlineNearestDriversList) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref().child("drivers");
    for (int i = 0; i < onlineNearestDriversList.length; i++) {
      await ref
          .child(onlineNearestDriversList[i].driverId.toString())
          .once()
          .then((dataSnapshot) {
        var driverKeyInfo = dataSnapshot.snapshot.value;
        dList.add(driverKeyInfo);
      });
    }
  }


}
