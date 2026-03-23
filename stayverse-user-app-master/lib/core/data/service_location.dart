import 'package:google_maps_flutter/google_maps_flutter.dart';

class ServiceLocation {
  final String? type;
  final List<double>? coordinates;

  LatLng? get latLng => (coordinates == null || coordinates!.length != 2)
      ? null
      : LatLng(coordinates![1], coordinates![0]);

  ServiceLocation({
    this.type,
    this.coordinates,
  });

  ServiceLocation copyWith({
    String? type,
    List<double>? coordinates,
  }) =>
      ServiceLocation(
        type: type ?? this.type,
        coordinates: coordinates ?? this.coordinates,
      );

  factory ServiceLocation.fromJson(Map<String, dynamic> json) =>
      ServiceLocation(
        type: json["type"],
        coordinates: json["coordinates"] == null
            ? []
            : List<double>.from(json["coordinates"]!.map((x) => x?.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": coordinates == null
            ? []
            : List<dynamic>.from(coordinates!.map((x) => x)),
      };
}
