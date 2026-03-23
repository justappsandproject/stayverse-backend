
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceDetailsResponse {
  final LatLng? location;

  PlaceDetailsResponse({this.location});

  factory PlaceDetailsResponse.fromJson(Map<String, dynamic> json) {
    final locationJson = json['result']['geometry']['location'];
    return PlaceDetailsResponse(
      location: LatLng(locationJson['lat'], locationJson['lng']),
    );
  }
}