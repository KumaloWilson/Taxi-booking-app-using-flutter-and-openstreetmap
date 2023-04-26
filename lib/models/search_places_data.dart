class SearchPlacesData {
  final String displayAddressName;
  final double lat;
  final double lon;

  SearchPlacesData({
    required this.displayAddressName,
    required this.lat,
    required this.lon
  });


  @override
  String toString() {

    return '$displayAddressName, $lat, $lon';
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is SearchPlacesData && other.displayAddressName == displayAddressName;
  }

  @override
  int get hashCode => Object.hash(displayAddressName, lat, lon);
}

