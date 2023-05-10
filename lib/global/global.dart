import 'dart:async';
import 'dart:ui';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
String cloudMessagingServerToken = "key=<YOUR API KEY HERE>";
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
Color primaryColor = Colors.amber;
String titleStarsRating = "";

List<LatLng> routeCoordinates = [];
