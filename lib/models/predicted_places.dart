class PredictedPlaces
{
  String? placeId;
  String? mainText;
  String? secondaryText;

  PredictedPlaces
  ({
    this.placeId,
    this.mainText,
    this.secondaryText,

  });
  PredictedPlaces.fromJson(Map<String, dynamic> jsonData)
  {
    placeId = jsonData["place_id"];
    mainText = jsonData["structured_formatting"]["main_text"];
    secondaryText = jsonData["structured_formatting"]["secondary_text"];
  }

}