import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import '../models/direction_details_info.dart';
import '../models/user_model.dart';

//Passenger Global Variables
final FirebaseAuth fAuth = FirebaseAuth.instance;
User? currentFirebaseUser;
UserModel? userModelCurrentInfo;
List dList = []; // driverKeyInfo List
DirectionDetailsInfo? tripDirectionDetailsInfo;
String? chosenDriverId = "";
String cloudMessagingServerToken = "key=AAAAhShY2gI:APA91bFw5Beq15NE2QUOY4e375j0c3yJLgsjP-0FYRR0G_hriOlJzONfnh4voAVMeLG-nlEAmOw07znZtWP9ng_PxMktVszjaanMbD-dRYkZgMWQBuWrOe_lllrNsWD43inyPHvpFbqZ";
String userDropOffAddress = "";
String driverCarDetails = "";
String driverName = "";
String driverPhone = "";
double countRatingStars = 0.0;
String titleStarsRating = "";

//Driver Global Variables

//Overall Global Variables
enum UserType{passenger, driver}
UserType? userType;
String? asUser;
bool driverMode = false;
bool passengerMode = false;
bool isAssistantActive = false;
Color primaryColor = const Color.fromARGB(255, 220, 171, 27);