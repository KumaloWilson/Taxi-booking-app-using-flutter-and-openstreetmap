import 'package:firebase_database/firebase_database.dart';

class PassengerTripsHistoryModel
{
  String? time;
  String? originAddress;
  String? destinationAddress;
  String? status;
  String? fareAmount;
  String? car_details;
  String? driverName;

  PassengerTripsHistoryModel({
    this.time,
    this.originAddress,
    this.destinationAddress,
    this.status,
    this.car_details,
    this.driverName,
  });

  PassengerTripsHistoryModel.fromSnapshot(DataSnapshot dataSnapshot)
  {
    time = (dataSnapshot.value as Map)["time"];
    originAddress = (dataSnapshot.value as Map)["originAddress"];
    destinationAddress = (dataSnapshot.value as Map)["destinationAddress"];
    status = (dataSnapshot.value as Map)["status"];
    fareAmount = (dataSnapshot.value as Map)["fareAmount"];
    car_details = (dataSnapshot.value as Map)["car_details"];
    driverName = (dataSnapshot.value as Map)["driverName"];
  }
}