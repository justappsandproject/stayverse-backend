import 'package:google_maps_flutter/google_maps_flutter.dart';

class RoutesRequest {
  final LocationHeading? origin;
  final LocationHeading? destination;
  final String? travelMode;
  final String? routingPreference;
  final bool? computeAlternativeRoutes;
  final RouteModifiers? routeModifiers;
  final String? languageCode;
  final String? units;

  RoutesRequest({
    this.origin,
    this.destination,
    this.travelMode,
    this.routingPreference,
    this.computeAlternativeRoutes,
    this.routeModifiers,
    this.languageCode,
    this.units,
  });

  RoutesRequest copyWith({
    LocationHeading? origin,
    LocationHeading? destination,
    String? travelMode,
    String? routingPreference,
    bool? computeAlternativeRoutes,
    RouteModifiers? routeModifiers,
    String? languageCode,
    String? units,
  }) =>
      RoutesRequest(
        origin: origin ?? this.origin,
        destination: destination ?? this.destination,
        travelMode: travelMode ?? this.travelMode,
        routingPreference: routingPreference ?? this.routingPreference,
        computeAlternativeRoutes:
            computeAlternativeRoutes ?? this.computeAlternativeRoutes,
        routeModifiers: routeModifiers ?? this.routeModifiers,
        languageCode: languageCode ?? this.languageCode,
        units: units ?? this.units,
      );

  factory RoutesRequest.fromJson(Map<String, dynamic> json) => RoutesRequest(
        origin: json["origin"] == null
            ? null
            : LocationHeading.fromJson(json["origin"]),
        destination: json["destination"] == null
            ? null
            : LocationHeading.fromJson(json["destination"]),
        travelMode: json["travelMode"],
        routingPreference: json["routingPreference"],
        computeAlternativeRoutes: json["computeAlternativeRoutes"],
        routeModifiers: json["routeModifiers"] == null
            ? null
            : RouteModifiers.fromJson(json["routeModifiers"]),
        languageCode: json["languageCode"],
        units: json["units"],
      );

  Map<String, dynamic> toJson() => {
        "origin": origin?.toJson(),
        "destination": destination?.toJson(),
        "travelMode": travelMode,
        "routingPreference": routingPreference,
        "computeAlternativeRoutes": computeAlternativeRoutes,
        "routeModifiers": routeModifiers?.toJson(),
        "languageCode": languageCode,
        "units": units,
      };

  factory RoutesRequest.withDefaultValues({
    required LatLng origin,
    required LatLng destination,
  }) {
    return RoutesRequest(
      origin: LocationHeading(
        location: Location(
          latLng: LatLngRoute(
            latitude: origin.latitude,
            longitude: origin.longitude,
          ),
        ),
      ),
      destination: LocationHeading(
        location: Location(
          latLng: LatLngRoute(
            latitude: destination.latitude,
            longitude: destination.longitude,
          ),
        ),
      ),
      travelMode: "DRIVE",
      routingPreference: "TRAFFIC_AWARE",
      computeAlternativeRoutes: false,
      routeModifiers: RouteModifiers(
        avoidTolls: false,
        avoidHighways: false,
        avoidFerries: false,
      ),
      languageCode: "en-US",
      units: "IMPERIAL",
    );
  }
}

class LocationHeading {
  final Location? location;

  LocationHeading({
    this.location,
  });

  LocationHeading copyWith({
    Location? location,
  }) =>
      LocationHeading(
        location: location ?? this.location,
      );

  factory LocationHeading.fromJson(Map<String, dynamic> json) =>
      LocationHeading(
        location: json["location"] == null
            ? null
            : Location.fromJson(json["location"]),
      );

  Map<String, dynamic> toJson() => {
        "location": location?.toJson(),
      };
}

class Location {
  final LatLngRoute? latLng;

  Location({
    this.latLng,
  });

  Location copyWith({
    LatLngRoute? latLng,
  }) =>
      Location(
        latLng: latLng ?? this.latLng,
      );

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        latLng: json["latLng"] == null
            ? null
            : LatLngRoute.fromJson(json["latLng"]),
      );

  Map<String, dynamic> toJson() => {
        "latLng": latLng?.toJson(),
      };
}

class LatLngRoute {
  final double? latitude;
  final double? longitude;

  LatLngRoute({
    this.latitude,
    this.longitude,
  });

  LatLngRoute copyWith({
    double? latitude,
    double? longitude,
  }) =>
      LatLngRoute(
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
      );

  factory LatLngRoute.fromJson(Map<String, dynamic> json) => LatLngRoute(
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
      };
}

class RouteModifiers {
  final bool? avoidTolls;
  final bool? avoidHighways;
  final bool? avoidFerries;

  RouteModifiers({
    this.avoidTolls,
    this.avoidHighways,
    this.avoidFerries,
  });

  RouteModifiers copyWith({
    bool? avoidTolls,
    bool? avoidHighways,
    bool? avoidFerries,
  }) =>
      RouteModifiers(
        avoidTolls: avoidTolls ?? this.avoidTolls,
        avoidHighways: avoidHighways ?? this.avoidHighways,
        avoidFerries: avoidFerries ?? this.avoidFerries,
      );

  factory RouteModifiers.fromJson(Map<String, dynamic> json) => RouteModifiers(
        avoidTolls: json["avoidTolls"],
        avoidHighways: json["avoidHighways"],
        avoidFerries: json["avoidFerries"],
      );

  Map<String, dynamic> toJson() => {
        "avoidTolls": avoidTolls,
        "avoidHighways": avoidHighways,
        "avoidFerries": avoidFerries,
      };
}
