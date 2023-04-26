import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/search_places_data.dart';
import '../widgets/place_prediction_tile.dart';

class SearchPlacesScreen extends StatefulWidget
{

  @override
  State<SearchPlacesScreen> createState() => _SearchPlacesScreenState();
}



class _SearchPlacesScreenState extends State<SearchPlacesScreen>
{
  Timer? _debounce;
  List<SearchPlacesData> _options = <SearchPlacesData>[];

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
              height: MediaQuery.of(context).size.height * 0.23,
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
                padding: EdgeInsets.all(
                  MediaQuery.of(context).size.height * 0.02,
                ),
                child: Column(
                  children: [

                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),

                    Stack(
                      children: [
                        GestureDetector(
                          onTap: ()
                          {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.black,
                          ),
                        ),
                        const Center(
                          child: Text(
                            "Search & Set DropOff Location",
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),

                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),

                    Row(
                      children: [
                        const Icon(
                          Icons.adjust_sharp,
                          color: Colors.black,
                        ),


                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.02,
                        ),

                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              onChanged: (String value) async {
                                if (_debounce?.isActive ?? false) _debounce?.cancel();

                                _debounce =
                                    Timer(const Duration(milliseconds: 2000), () async {
                                      if (kDebugMode) {
                                        print(value);
                                      }
                                      var client = http.Client();
                                      try {
                                        String url = 'https://nominatim.openstreetmap.org/search?q=$value&format=json&polygon_geojson=1&addressdetails=1';
                                        if (kDebugMode) {
                                          print(url);
                                        }
                                        var response = await client.post(Uri.parse(url));
                                        var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
                                        if (kDebugMode) {
                                          print(decodedResponse);
                                        }
                                        _options = decodedResponse
                                            .map((jsonData) => SearchPlacesData(
                                            displayAddressName: jsonData['display_name'],
                                            lat: double.parse(jsonData['lat']),
                                            lon: double.parse(jsonData['lon'])))
                                            .toList();
                                        _options = _options.reversed.toList();
                                        setState(() {});
                                      } finally {
                                        client.close();
                                      }
                                      setState(() {});
                                    });

                              },
                              decoration: const InputDecoration(
                                hintText: "Search Location here",
                                fillColor: Colors.white,
                                filled: true,
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(
                                  left: 11.0,
                                  top: 8.0,
                                  bottom: 8.0,
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
            (_options.isNotEmpty)
                ? Expanded
                  (
                    child: ListView.separated
                      (

                        itemCount: _options.length,
                        physics: const ClampingScrollPhysics(),
                        itemBuilder: (context, index)
                        {
                          return PlacePredictionTileDesign(
                            predictedPlaces: _options[index],
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
