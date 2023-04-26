// import 'dart:async';
// import 'package:elrick_trans_app/mainScreens/search_places_screen.dart';
// import 'package:elrick_trans_app/passenger_assistants/assistance_methods.dart';
// import 'package:elrick_trans_app/widgets/progress_dialog.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:provider/provider.dart';
// import '../global/global.dart';
// import '../infoHandler/app_info.dart';
// import '../widgets/my_drawer.dart';
//
// class MainScreen extends StatefulWidget {
//   const MainScreen({Key? key}) : super(key: key);
//
//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }
//
// class _MainScreenState extends State<MainScreen> {
//
//   GlobalKey<ScaffoldState> sKey = GlobalKey<ScaffoldState>();
//   double searchLocationContainerHeight = 240;
//   double waitingResponseFromDriverContainerHeight = 0;
//   double assignedDriverInfoContainerHeight = 0;
//
//   MapController? _mapController;
//   String? address;
//   final TileLayer darkTileLayerOptions = TileLayer(
//     urlTemplate: "https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png",
//     subdomains: ['a', 'b', 'c'],
//   );
//   StreamSubscription<Position>? _positionStreamSubscription;
//   Position? userCurrentPosition;
//   var geoLocator = Geolocator();
//
//   LocationPermission? _locationPermission;
//
//   bool checkInternet = false;
//   bool awaitCoordinates = true;
//   bool openNavigationDrawer = true;
//   String? userName;
//   String? userEmail;
//
//   checkIfLoadingCoordinates(){
//     if(awaitCoordinates == true) {
//       Timer(const Duration(seconds: 30), () async {
//         if(awaitCoordinates == true){
//           setState(() {
//             checkInternet = true;
//           });
//           print('check your internet');
//         }
//       });
//     }
//   }
//
//   Future <void> checkIfLocationPermissionAllowed() async {
//     _locationPermission = await Geolocator.requestPermission();
//
//     if (_locationPermission == LocationPermission.denied) {
//       _locationPermission = await Geolocator.requestPermission();
//     }
//     else{
//       locateUserPosition();
//     }
//   }
//
//   Future <String> locateUserPosition() async {
//     Position cPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//
//     userCurrentPosition = cPosition;
//
//     String humanReadableAddress = await PassengerAssistantMethods.searchAddressForGeographicCoOrdinates(userCurrentPosition!, context);
//     address = humanReadableAddress.toString();
//
//     print("this is your address = $humanReadableAddress");
//     print("THIS IS THE OFFICIAL ADDRESS  $address");
//     print("THIS IS THE OFFICIAL ADDRESS  $address");
//
//     if(address != null){
//       setState(() {
//         awaitCoordinates = false;
//         checkInternet = false;
//       });
//     }
//     else{
//       print('ADDRESS NOT FOUND');
//     }
//
//     setState(() {
//       userName = userModelCurrentInfo!.name!;
//       userEmail = userModelCurrentInfo!.email!;
//     });
//
//     // initializeGeoFireListener();
//
//
//
//
//     PassengerAssistantMethods.readTripsKeysForOnlineUser(context);
//
//     return humanReadableAddress;
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _mapController = MapController();
//
//     // subscribe to position stream updates
//     _positionStreamSubscription =
//         Geolocator.getPositionStream().listen((Position position) {
//           setState(() {
//             userCurrentPosition = position;
//             _mapController!.move(LatLng(position.latitude, position.longitude), 16.0);
//           });
//         });
//
//     checkIfLocationPermissionAllowed();
//     checkIfLoadingCoordinates();
//   }
//
//   @override
//   void dispose() {
//     // cancel subscription to position stream updates
//     _positionStreamSubscription?.cancel();
//     super.dispose();
//   }
//
//   Widget buildBlinkingMarker() {
//     return userCurrentPosition != null ? BlinkingMarker(
//       point: LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude),
//       color: Colors.blue,
//       size: 30,
//       duration: const Duration(milliseconds: 500),
//       child: Icon(Icons.location_on, size: 30, color: Colors.blue),
//     ) : Container();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: sKey,
//       drawer: SizedBox(
//         width: MediaQuery.of(context).size.width * 0.75,
//         child: Theme(
//           data: Theme.of(context).copyWith(
//             canvasColor: Colors.black, // set the background color of the drawer
//           ),
//           child: MyDrawer(),
//         ),
//       ),
//       body: Stack(
//         children: [
//           FlutterMap(
//             mapController: _mapController,
//             options: MapOptions(
//               center: LatLng(6.5244, 3.3792),
//               zoom: 13.0,
//             ),
//             children: [
//               //MapTheme
//               darkTileLayerOptions,
//
//               MarkerLayer(
//                   markers: [
//                     if (userCurrentPosition != null)
//                       Marker(
//                         width: 40.0,
//                         height: 40.0,
//                         point: LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude),
//                         builder: (ctx) => Container(
//                         child: Icon(
//                             Icons.location_on,
//                             size: 30,
//                             color: Colors.blue
//                         ),
//                       ),
//                     ),
//                   ]
//               ),
//             ],
//           ),
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => SearchPlacesScreen()),
//                 );
//               },
//               child: Container(
//                 height: 50,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
//                   boxShadow: [
//                     BoxShadow(
//                         color: Colors.grey.withOpacity(0.3),
//                         spreadRadius: 1,
//                         blurRadius: 7,
//                         offset: Offset(0, 3))
//                   ],
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     Icon(Icons.search),
//                     SizedBox(width: 10),
//                     Text("Search for pickup location"),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             bottom: 40,
//             left: 0,
//             right: 0,
//             child: buildBlinkingMarker(),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class BlinkingMarker extends StatefulWidget {
//   const BlinkingMarker({
//     required this.point,
//     required this.color,
//     required this.size,
//     required this.duration,
//     required this.child,
//   });
//
//   final LatLng point;
//   final Color color;
//   final double size;
//   final Duration duration;
//   final Widget child;
//
//   @override
//   _BlinkingMarkerState createState() => _BlinkingMarkerState();
// }
//
// class _BlinkingMarkerState extends State<BlinkingMarker>
//     with SingleTickerProviderStateMixin {
//
//   late AnimationController controller;
//
//   @override
//   void initState() {
//     super.initState();
//
//     controller = AnimationController(
//       vsync: this,
//       duration: widget.duration,
//     )..repeat(reverse: true);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: controller,
//       builder: (BuildContext context, Widget? child) {
//         return Transform.rotate(
//           angle: controller.value * 2.0 * 3.14159265358979323846,
//           child: Icon(
//             Icons.location_on,
//             color: widget.color.withOpacity(controller.value),
//             size: widget.size,
//           ),
//         );
//       },
//     );
//   }
//
//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }
// }