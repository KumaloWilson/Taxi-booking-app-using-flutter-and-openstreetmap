import 'package:elrick_trans_app/widgets/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../global/global.dart';
import '../global/map_key.dart';
import '../infoHandler/app_info.dart';
import '../models/directions.dart';
import '../models/predicted_places.dart';
import '../passenger_assistants/request_assistant.dart';

class PlacePredictionTileDesign extends StatefulWidget
{
  final PredictedPlaces? predictedPlaces;

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
          });

          Navigator.pop(context, "obtainedDropoff");
        }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed:()
            {
              getPlaceDirectionDetails(widget.predictedPlaces!.place_id, context);
            },
      style: ElevatedButton.styleFrom(
        primary: Colors.black45,
      ),

      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            Icon(
              Icons.add_location,
              color: Colors.black,
            ),
            const SizedBox(width: 14.0,),

            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8.0,),
                    Text(
                      widget.predictedPlaces!.main_text!,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.white54
                      ),
                    ),
                    const SizedBox(height: 8.0,),
                  ],
                ),
            ),
          ],
        ),
      ),
    );
  }
}
