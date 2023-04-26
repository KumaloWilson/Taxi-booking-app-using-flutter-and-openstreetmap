import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../global/global.dart';

class DrawPolyline{
  //Fetch route to draw a polyline
  Future<List<LatLng>> fetchRouteCoordinates(LatLng start, LatLng end) async {
    String url = 'http://router.project-osrm.org/route/v1/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?geometries=geojson';

    print("URL: $url");
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);

      print(jsonResponse);

      var steps = jsonResponse['routes'][0]['legs'][0]['steps'];
      var geometry = jsonResponse['routes'][0]['geometry']['coordinates'];
      var totalDistance = jsonResponse['routes'][0]['distance'] / 1000;

      for (var i = 0; i < geometry.length; i++) {
        routeCoordinates.add(LatLng(geometry[i][1], geometry[i][0]));
      }

      print("ROUTE COORDINATES: $routeCoordinates");

      return routeCoordinates;

    } else {
      throw Exception('Failed to load route.');
    }
  }
}