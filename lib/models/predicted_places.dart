// class PredictedPlaces
// {
//   String? placeId;
//   String? mainText;
//   String? secondaryText;
//
//   PredictedPlaces
//   ({
//     this.placeId,
//     this.mainText,
//     this.secondaryText,
//
//   });
//   PredictedPlaces.fromJson(Map<String, dynamic> jsonData)
//   {
//     placeId = jsonData["place_id"];
//     mainText = jsonData["structured_formatting"]["main_text"];
//     secondaryText = jsonData["structured_formatting"]["secondary_text"];
//   }
// }

class SearchPlacesData {
  final String placeId;
  final String displayAddressName;
  final double lat;
  final double lon;

  SearchPlacesData({
    required this.placeId,
    required this.displayAddressName,
    required this.lat,
    required this.lon
  });


  @override
  String toString() {

    return '$placeId $displayAddressName, $lat, $lon';
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is SearchPlacesData && other.displayAddressName == displayAddressName;
  }

  @override
  int get hashCode => Object.hash(placeId, displayAddressName, lat, lon);
}

