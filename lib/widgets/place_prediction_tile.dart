import 'package:elrick_trans_app/widgets/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../global/global.dart';
import '../infoHandler/info_handler.dart';
import '../models/directions.dart';
import '../models/drawpolyline.dart';
import '../models/predicted_places.dart';
import '../assistants/request_assistant.dart';

class PlacePredictionTileDesign extends StatefulWidget
{
  final SearchPlacesData? predictedPlaces;

  PlacePredictionTileDesign({this.predictedPlaces});

  @override
  State<PlacePredictionTileDesign> createState() => _PlacePredictionTileDesignState();
}

class _PlacePredictionTileDesignState extends State<PlacePredictionTileDesign> {
  Future<void> getPlaceDirectionDetails(String? placeId, context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => ProgressDialog(
        message: "Setting Up your Destination..",
      ),
    );

    String placeDirectionDetailsUrl = "https://nominatim.openstreetmap.org/details.php?osmtype=R&place_id=$placeId&format=json";

    var responseApi = await RequestAssistant.receiveRequest(placeDirectionDetailsUrl);

    print('RESPONSE FROM API $responseApi');
    Navigator.pop(context);

    if (responseApi == "Some error occurred. Please try again") {
      return;
    } else {
      Directions directions = Directions();

      // Check for localname address
      if (responseApi['localname'] != null) {
        directions.locationName = responseApi['localname'];
      }
      else if (responseApi['result'] != null && responseApi['result']['localname'] != null) {
        directions.locationName = responseApi['result']['localname'];
      }

      print("THIS IS THE LOCATION NAME ${directions.locationName}");

      directions.locationId = placeId;
      print("THIS IS THE PLACE ID ${directions.locationId}");

      directions.locationLatitude = responseApi["centroid"]["coordinates"][1];
      print("THIS IS THE LATITUDE ${directions.locationLatitude}");

      directions.locationLongitude = responseApi["centroid"]["coordinates"][0];
      print("THIS IS THE LONGITUDE ${directions.locationLongitude}");

      print("THESE ARE THE DIRECTIONS $directions");

      Provider.of<AppInfo>(context, listen: false)
          .updateDropOffLocationAddress(directions);

      setState(() {
        userDropOffAddress = directions.locationName!;
        userDropOffPosition = LatLng(directions.locationLatitude!.toDouble(), directions.locationLongitude!.toDouble());
        isDestinationFound = true;
      });

      Navigator.pop(context, "obtainedDropoff");
      await fetchRoute();
    }
  }

  //Fetch Coordinates and draw polyline
  Future<void> fetchRoute() async {
    List<LatLng> coordinates = await DrawPolyline().fetchRouteCoordinates(polyLineStartingPoint, userDropOffPosition!);
    routeCoordinates = coordinates;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:()
      {
        getPlaceDirectionDetails(widget.predictedPlaces!.placeId, context);
      },

      child: Container(
        color: Colors.black45,
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            const Icon(
              Icons.add_location,
              color: Colors.black,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.025,
            ),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.018,
                  ),
                  Text(
                    widget.predictedPlaces!.displayAddressName,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.white54
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.018,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
