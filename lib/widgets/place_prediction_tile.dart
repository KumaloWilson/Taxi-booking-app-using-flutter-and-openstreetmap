import 'package:elrick_trans_app/models/search_places_data.dart';
import 'package:elrick_trans_app/widgets/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../global/global.dart';
import '../global/map_key.dart';
import '../infoHandler/app_info.dart';
import '../models/directions.dart';
import '../passenger_assistants/request_assistant.dart';

class PlacePredictionTileDesign extends StatefulWidget
{
  final SearchPlacesData? predictedPlaces;

  PlacePredictionTileDesign({this.predictedPlaces});

  @override
  State<PlacePredictionTileDesign> createState() => _PlacePredictionTileDesignState();
}

class _PlacePredictionTileDesignState extends State<PlacePredictionTileDesign> {
  getPlaceDirectionDetails(String? placeId, context) async
  {
      showDialog(
          context: context,
          builder: (BuildContext context) => ProgressDialog(
            message: "Setting Up your Destination..",
          ),
      );

      String placeDirectionDetailsUrl = "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapkey";

      var responseApi = await RequestAssistant.receiveRequest(placeDirectionDetailsUrl);

      Navigator.pop(context);

      if(responseApi == "Some error occurred. Please try again")
        {
          return;
        }
      if(responseApi["status"] == "OK")
        {
          Directions directions = Directions();
          directions.locationName = responseApi["result"]["name"];
          directions.locationId = placeId;
          directions.locationLatitude = responseApi["result"]["geometry"]["location"]["lat"];
          directions.locationLongitude = responseApi["result"]["geometry"]["location"]["lng"];

          Provider.of<AppInfo>(context, listen: false).updateDropOffLocationAddress(directions);

          setState(() {
            userDropOffAddress = directions.locationName!;
            print("USER DROPOFF LOCATION $userDropOffAddress");
          });

          Navigator.pop(context, "obtainedDropoff");
        }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap:()
            {
              getPlaceDirectionDetails(widget.predictedPlaces!.displayAddressName, context);
            },



      child: Container(
        color: Colors.black45,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.02,
              vertical: MediaQuery.of(context).size.height * 0.009
          ),
          child: Row(
            children: [
              const Icon(
                Icons.add_location,
                color: Colors.black,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.012,
              ),

              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Text(
                        widget.predictedPlaces!.displayAddressName,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: primaryColor
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                    ],
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
