import 'package:flutter/material.dart';
import '../models/predicted_places.dart';
import '../assistants/request_assistant.dart';
import '../widgets/place_prediction_tile.dart';

class SearchPlacesScreen extends StatefulWidget {
  const SearchPlacesScreen({super.key});

  @override
  State<SearchPlacesScreen> createState() => _SearchPlacesScreenState();
}

class _SearchPlacesScreenState extends State<SearchPlacesScreen> {
  List<SearchPlacesData> placesPredictedList = [];

  Future<void> findPlaceAutoCompleteSearch(String inputText) async {
    if (inputText.isNotEmpty) {
      String urlAutoCompleteSearch = 'https://nominatim.openstreetmap.org/search?q=$inputText&format=json&polygon_geojson=1&addressdetails=1&countrycodes=zw';

      var responseAutoCompleteSearch = await RequestAssistant.receiveRequest(urlAutoCompleteSearch);

      print('RESPONSE DATA {$responseAutoCompleteSearch}');

      if (responseAutoCompleteSearch.runtimeType == String && responseAutoCompleteSearch == "Some error occurred. Please try again") {
        return;
      }

      if (responseAutoCompleteSearch is List<dynamic>) {
        try {
          placesPredictedList = responseAutoCompleteSearch
              .map((jsonData) => SearchPlacesData(
              placeId: jsonData['place_id'].toString(),
              displayAddressName: jsonData['display_name'],
              lat: double.parse(jsonData['lat'].toString()),
              lon: double.parse(jsonData['lon'].toString())))
              .toList();

          setState(() {

          });
        } catch (e) {
          print('Error mapping response data: $e');
        }
      }
    }
  }
  @override
  Widget build(BuildContext context)
  {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/Absolute_BG.png"), fit: BoxFit.fill)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [

            //Search Places UI
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              decoration: const BoxDecoration(
                color: Colors.grey,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black54,
                      blurRadius: 8,
                      spreadRadius: 0.5,
                      offset: Offset(
                        0.7,
                        0.7,
                      )
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal : MediaQuery.of(context).size.height * 0.02,
                ),
                child: Column(
                  children: [

                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.07,
                    ),

                    Row(
                      children: [
                        const Icon(
                          Icons.adjust_sharp,
                          color: Colors.black,
                        ),

                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.01,
                        ),


                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width * 0.02,
                            ),
                            child: TextField(
                              onChanged: (valueTyped)
                              {
                                findPlaceAutoCompleteSearch(valueTyped);

                              },
                              decoration: InputDecoration(
                                hintText: "Search Location here",
                                fillColor: Colors.white,
                                filled: true,
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.width * 0.03,
                                  top: MediaQuery.of(context).size.height * 0.01,
                                  bottom: MediaQuery.of(context).size.height * 0.01,
                                ),

                              ),
                            ),
                          ),
                        ),

                      ],
                    )
                  ],
                ),
              ),
            ),

            //place predictions results
            (placesPredictedList.isNotEmpty)
                ? Expanded
              (
              child: ListView.separated
                (

                itemCount: placesPredictedList.length,
                physics: const ClampingScrollPhysics(),
                itemBuilder: (context, index)
                {
                  return PlacePredictionTileDesign(
                    predictedPlaces: placesPredictedList[index],
                  );
                },
                separatorBuilder: (BuildContext context, int index)
                {
                  return const Divider(
                    height: 1,
                    color: Colors.black,
                    thickness: 1,
                  );
                },

              ),
            )
                : Container(),
          ],
        ),
      ),

    );
  }
}
