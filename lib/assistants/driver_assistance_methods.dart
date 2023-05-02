
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../global/global.dart';
import '../global/map_key.dart';
import '../infoHandler/info_handler.dart';
import '../models/direction_details_info.dart';
import '../models/directions.dart';
import '../models/driver_trips_history_model.dart';
import 'driver_request_assistant.dart';



class DriverAssistantMethods
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

    directionDetailsInfo.distance_text = (responseDirectionApi['routes'][0]['distance'] / 1000).toString();
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

  static pauseLiveLocationUpdates()
  {
    streamSubscriptionPosition!.pause();
    Geofire.removeLocation(currentFirebaseUser!.uid);
  }

  static resumeLiveLocationUpdates()
  {
    streamSubscriptionPosition!.resume();
    Geofire.setLocation(
        currentFirebaseUser!.uid,
        driverCurrentPosition!.latitude,
        driverCurrentPosition!.longitude
    );
  }

  //Prices for taxis
  static double calculateFareAmountFromOriginToDestination(DirectionDetailsInfo directionDetailsInfo)
  {
    double timeTraveledFareAmountPerMinute = (directionDetailsInfo.duration_value! / 60) * 0.2;
    double distanceTraveledFareAmountPerKilometer = (directionDetailsInfo.duration_value! / 1000) * 0.2;

    //1 USD = 650 RTGS
    double totalFareAmount = timeTraveledFareAmountPerMinute + distanceTraveledFareAmountPerKilometer;
    double localCurrencyTotalFare = totalFareAmount * 650;

    if(driverVehicleType == "Elrik-Economy")
    {
      double resultFareAmount = (totalFareAmount.truncate()) / 2.0;
      return resultFareAmount;
    }
    else if(driverVehicleType == "Elrik-Standard")
    {
      return totalFareAmount.truncate().toDouble();
    }
    else if(driverVehicleType == "Elrik-Mbinga")
    {
      double resultFareAmount = (totalFareAmount.truncate()) * 2.0;
      return resultFareAmount;
    }
    else
    {
      return totalFareAmount.truncate().toDouble();
    }

    return double.parse(localCurrencyTotalFare.toStringAsFixed(2));
  }


  //retrieve the trips KEYS for online user
  //trip key = ride request key
  static void readTripsKeysForOnlineDriver(context)
  {
    FirebaseDatabase.instance.ref()
        .child("All Ride Requests")
        .orderByChild("driverId")
        .equalTo(fAuth.currentUser!.uid)
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
        var eachTripHistory = DriverTripsHistoryModel.fromSnapshot(snap.snapshot);

        if((snap.snapshot.value as Map)["status"] == "ended")
        {
          //update-add each history to OverAllTrips History Data List
          Provider.of<AppInfo>(context, listen: false).updateOverAllDriverTripsHistoryInformation(eachTripHistory);
        }
      });
    }
  }

  //readDriverEarnings
  static void readDriverEarnings(context)
  {
    FirebaseDatabase.instance.ref()
        .child("drivers")
        .child(fAuth.currentUser!.uid)
        .child("earnings")
        .once()
        .then((snap)
    {
      if(snap.snapshot.value != null)
      {
        String driverEarnings = snap.snapshot.value.toString();
        Provider.of<AppInfo>(context, listen: false).updateDriverTotalEarnings(driverEarnings);
      }
    });

    readTripsKeysForOnlineDriver(context);
  }

  static void readDriverRatings(context)
  {
    FirebaseDatabase.instance.ref()
        .child("drivers")
        .child(fAuth.currentUser!.uid)
        .child("ratings")
        .once()
        .then((snap)
    {
      if(snap.snapshot.value != null)
      {
        String driverRatings = snap.snapshot.value.toString();
        Provider.of<AppInfo>(context, listen: false).updateDriverAverageRatings(driverRatings);
      }
    });
  }

}