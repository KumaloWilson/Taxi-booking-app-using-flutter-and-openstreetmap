import 'package:firebase_database/firebase_database.dart';

class DriverTripsHistoryModel
{
  String? time;
  String? originAddress;
  String? destinationAddress;
  String? status;
  String? fareAmount;
  String? userName;
  String? userPhone;

  DriverTripsHistoryModel({
    this.time,
    this.originAddress,
    this.destinationAddress,
    this.status,
    this.userName,
    this.userPhone,
  });

  DriverTripsHistoryModel.fromSnapshot(DataSnapshot dataSnapshot)
  {
    time = (dataSnapshot.value as Map)["time"];
    originAddress = (dataSnapshot.value as Map)["originAddress"];
    destinationAddress = (dataSnapshot.value as Map)["destinationAddress"];
    status = (dataSnapshot.value as Map)["status"];
    fareAmount = (dataSnapshot.value as Map)["fareAmount"];
    userName = (dataSnapshot.value as Map)["userName"];
    userPhone = (dataSnapshot.value as Map)["userPhone"];
  }
}