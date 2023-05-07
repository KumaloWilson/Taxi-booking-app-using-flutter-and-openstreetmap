import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../global/global.dart';
import '../infoHandler/info_handler.dart';
import '../models/direction_details_info.dart';
import '../models/directions.dart';
import '../models/passenger_trips_history_model.dart';
import '../models/user_model.dart';
import 'driver_request_assistant.dart';

class PassengerAssistantMethods
{

  //decode userCurrentAddress
  static Future<String> searchAddressForGeographicCoOrdinates(Position myPosition, context) async
  {
    String apiUrl ='https://nominatim.openstreetmap.org/reverse?format=json&lat=${myPosition.latitude}&lon=${myPosition.longitude}&zoom=18&addressdetails=1';
    String humanReadableAddress = "";

    var requestResponse = await RequestAssistant.receiveRequest(apiUrl);

    if(requestResponse != "Error Occurred, Failed. No Response.")
      {
        humanReadableAddress = requestResponse['display_name'];

        Directions userPickUpAddress = Directions();
        userPickUpAddress.locationLatitude = myPosition.latitude;
        userPickUpAddress.locationLongitude = myPosition.longitude;
        userPickUpAddress.locationName = humanReadableAddress;

        Provider.of<AppInfo>(context, listen: false).updatePickUpLocationAddress(userPickUpAddress);
      }

    return humanReadableAddress;
  }


  static void readCurrentOnlinePassengerInfo() async
  {
    currentFirebaseUser = fAuth.currentUser;

    DatabaseReference userRef = FirebaseDatabase.instance
      .ref()
      .child("users")
        .child(currentFirebaseUser!.uid);

    userRef.once().then((snap)
    {
      if(snap.snapshot.value != null)
        {

         userModelCurrentInfo = UserModel.fromSnapShot(snap.snapshot);
        }
    });

    }


  static Future<DirectionDetailsInfo?> obtainOriginToDestinationDirectionDetails(LatLng originPosition, LatLng destinationPosition) async
  {
    String urlOriginToDestinationDirectionDetails = "http://router.project-osrm.org/route/v1/driving/${originPosition.longitude},${originPosition.latitude};${destinationPosition.longitude},${destinationPosition.latitude}?geometries=geojson";

    var responseDirectionApi = await RequestAssistant.receiveRequest(urlOriginToDestinationDirectionDetails);

    print('THIS IS THE API RESPONSE FROM OSRM $responseDirectionApi');

    if(responseDirectionApi == "Error Occurred, Failed. No Response.")
    {
      return null;
    }

    DirectionDetailsInfo directionDetailsInfo = DirectionDetailsInfo();

    directionDetailsInfo.e_points = responseDirectionApi['routes'][0]['geometry']['coordinates'];

    directionDetailsInfo.distance_text = (responseDirectionApi['routes'][0]['distance'] / 1000).toStringAsFixed(2);
    directionDetailsInfo.distance_value = (responseDirectionApi['routes'][0]['distance'] / 1000);

    directionDetailsInfo.duration_text = ((responseDirectionApi["routes"][0]['duration']/60) as double).ceil().toString();
    directionDetailsInfo.duration_value = responseDirectionApi["routes"][0]['duration']/60.ceil();



    print("THIS IS THE e_points value ${directionDetailsInfo.e_points}");
    print("THIS IS DISTANCE TEXT AS A STRING ${directionDetailsInfo.distance_text}");
    print("THIS IS DISTANCE VALUE ${directionDetailsInfo.distance_value}");
    print("THIS IS DURATION TEXT AS A STRING ${directionDetailsInfo.duration_text}");
    print("THIS IS DURATION VALUE ${directionDetailsInfo.duration_value}");

    List<dynamic>? ePoints = directionDetailsInfo.e_points;


    for (dynamic point in ePoints!) {
      if (point is List<dynamic>) {

        double lat = point[0];
        double lng = point[1];
        LatLng latLng = LatLng(lat, lng);
        routeCoordinates.add(latLng);
      }
    }

    print('THESE ARE ALL THE POINTS EXTRACTED FROM THE DIRECTION INFORMATION CLASS: $routeCoordinates');


    return directionDetailsInfo;
  }

  //Prices for taxis
    static double calculateFareAmountFromOriginToDestination(DirectionDetailsInfo directionDetailsInfo)
    {
      double timeTraveledFareAmountPerMinute = (directionDetailsInfo.duration_value! / 60) * 0.5;

      double distanceTraveledFareAmountPerKilometer = (directionDetailsInfo.distance_value! ) * 0.5;


      double totalFareAmount = timeTraveledFareAmountPerMinute + distanceTraveledFareAmountPerKilometer;
      double localCurrencyTotalFare = totalFareAmount;

      return double.parse(localCurrencyTotalFare.toStringAsFixed(2));
    }


  static sendNotificationToDriverNow(String deviceRegistrationToken, String userRideRequestId, context) async
  {
    String destinationAddress = userDropOffAddress;

    Map<String, String> headerNotification =
    {
      'Content-Type': 'application/json',
      'Authorization': cloudMessagingServerToken,
    };

    Map bodyNotification =
    {
      "body":"Destination Address: \n$destinationAddress.",
      "title":"New Ride Request Alert!!!"
    };

    Map dataMap =
    {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "id": "1",
      "status": "done",
      "rideRequestId": userRideRequestId
    };

    Map officialNotificationFormat =
    {
      "notification": bodyNotification,
      "data": dataMap,
      "priority": "high",
      "to": deviceRegistrationToken,
    };

    var responseNotification = http.post(
      Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: headerNotification,
      body: jsonEncode(officialNotificationFormat),
    );
  }


  //retrieve the trips KEYS for online user
  //trip key = ride request key
  static void readTripsKeysForOnlineUser(context)
  {
    FirebaseDatabase.instance.ref()
        .child("All Ride Requests")
        .orderByChild("userName")
        .equalTo(userModelCurrentInfo!.name)
        .once()
        .then((snap)
    {
      if(snap.snapshot.value != null)
      {
        Map keysTripsId = snap.snapshot.value as Map;

        //count total number trips and share it with Provider
        int overAllTripsCounter = keysTripsId.length;
        Provider.of<AppInfo>(context, listen: false).updateOverAllTripsCounter(overAllTripsCounter);

        //share trips keys with Provider
        List<String> tripsKeysList = [];
        keysTripsId.forEach((key, value)
        {
          tripsKeysList.add(key);
        });
        Provider.of<AppInfo>(context, listen: false).updateOverAllTripsKeys(tripsKeysList);

        //get trips keys data - read trips complete information
        readTripsHistoryInformation(context);
      }
    });
  }

  static void readTripsHistoryInformation(context)
  {
    var tripsAllKeys = Provider.of<AppInfo>(context, listen: false).historyTripsKeysList;

    for(String eachKey in tripsAllKeys)
    {
      FirebaseDatabase.instance.ref()
          .child("All Ride Requests")
          .child(eachKey)
          .once()
          .then((snap)
      {
        var eachTripHistory = PassengerTripsHistoryModel.fromSnapshot(snap.snapshot);

        if((snap.snapshot.value as Map)["status"] == "ended")
        {
          //update-add each history to OverAllTrips History Data List
          Provider.of<AppInfo>(context, listen: false).updateOverAllPassengerTripsHistoryInformation(eachTripHistory);
        }
      });
    }
  }

}