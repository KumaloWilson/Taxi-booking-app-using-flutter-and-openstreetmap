import 'dart:async';
import 'dart:ui';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../models/driver_data.dart';
import '../models/direction_details_info.dart';
import '../models/user_model.dart';

//Passenger Global Variables
final FirebaseAuth fAuth = FirebaseAuth.instance;
User? currentFirebaseUser;
UserModel? userModelCurrentInfo;
List dList = []; // driverKeyInfo List
DirectionDetailsInfo? tripDirectionDetailsInfo;
String? chosenDriverId = "";
String cloudMessagingServerToken = "key=AAAAwfCH6HE:APA91bFNHn9YlqNeg3hYULNmi2yWmc5UeSE6sk0cBqZQeb3PPQwEghZEDeYaYjxm57zbyI5Ffimy0O3uQdd0AuKFrvIPlWldG9XA9tdFq9MwiZf2_3gb6juxetKvTS-LmXsnrp9QlQja";
LatLng? userDropOffPosition;
String userDropOffAddress = "";
String driverCarDetails = "";
String driverName = "";
String driverPhone = "";
double countRatingStars = 0.0;



//Driver Global Variables
StreamSubscription<Position>? streamSubscriptionPosition;
StreamSubscription<Position>? streamSubscriptionDriverLivePosition;
AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();
Position? driverCurrentPosition;
DriverData onlineDriverData = DriverData();
String? driverVehicleType = "";
bool isDriverActive = false;
String statusText = "Offline";
Color buttonColor = primaryColor;



//Overall Global Variables
enum UserType{passenger, driver}
UserType? userType;
String? asUser;
bool driverMode = false;
bool passengerMode = false;
bool isAssistantActive = false;
bool isDestinationFound = false;
bool isCarDetailsProvided = false;
Color primaryColor = const Color.fromARGB(255, 220, 171, 27);
String titleStarsRating = "";

List<LatLng> routeCoordinates = [];
late LatLng polyLineStartingPoint;