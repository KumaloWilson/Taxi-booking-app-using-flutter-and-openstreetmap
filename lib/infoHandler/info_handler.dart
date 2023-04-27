import 'package:elrick_trans_app/models/driver_trips_history_model.dart';
import 'package:flutter/cupertino.dart';
import '../models/directions.dart';
import '../models/passenger_trips_history_model.dart';


class AppInfo extends ChangeNotifier
{
  Directions? userPickUpLocation, userDropOffLocation;
  int countTotalTrips = 0;
  String driverTotalEarnings = "0";
  String driverAverageRatings = "0";
  List<String> historyTripsKeysList = [];
  List<DriverTripsHistoryModel> allDriverTripsHistoryInformationList = [];
  List<PassengerTripsHistoryModel> allPassengersTripsHistoryInformationList = [];



  void updatePickUpLocationAddress(Directions userPickUpAddress)
  {
    userPickUpLocation = userPickUpAddress;
    notifyListeners();
  }


  void updateDropOffLocationAddress(Directions dropOffAddress)
  {
    userDropOffLocation = dropOffAddress;
    notifyListeners();
  }


  updateOverAllTripsCounter(int overAllTripsCounter)
  {
    countTotalTrips = overAllTripsCounter;
    notifyListeners();
  }

  updateOverAllTripsKeys(List<String> tripsKeysList)
  {
    historyTripsKeysList = tripsKeysList;
    notifyListeners();
  }

  updateOverAllDriverTripsHistoryInformation(DriverTripsHistoryModel eachTripHistory)
  {
    allDriverTripsHistoryInformationList.add(eachTripHistory);
    notifyListeners();
  }

  updateOverAllPassengerTripsHistoryInformation(PassengerTripsHistoryModel eachTripHistory)
  {
    allPassengersTripsHistoryInformationList.add(eachTripHistory);
    notifyListeners();
  }

  updateDriverTotalEarnings(String driverEarnings)
  {
    driverTotalEarnings = driverEarnings;
  }

  updateDriverAverageRatings(String driverRatings)
  {
    driverAverageRatings = driverRatings;
  }

}