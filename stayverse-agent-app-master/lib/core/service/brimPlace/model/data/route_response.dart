// To parse this JSON data, do
//

import 'package:stayvers_agent/core/util/app/helper.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_utils/poly_utils.dart';
import 'dart:math';

class RouteResponse {
  final List<Route>? routes;

  RouteResponse({
    this.routes,
  });

  RouteResponse copyWith({
    List<Route>? routes,
  }) =>
      RouteResponse(
        routes: routes ?? this.routes,
      );

  factory RouteResponse.fromJson(Map<String, dynamic> json) => RouteResponse(
        routes: json["routes"] == null
            ? []
            : List<Route>.from(json["routes"]!.map((x) => Route.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "routes": routes == null
            ? []
            : List<dynamic>.from(routes!.map((x) => x.toJson())),
      };
}

class Route {
  final int? distanceMeters;
  final String? duration;
  final Polyline? polyline;
  final LocalizedValues? localizedValues;

  int? get durationInSeconds =>
      duration != null ? int.tryParse(duration!.replaceAll('s', '')) : null;

  Route({
    this.distanceMeters,
    this.duration,
    this.polyline,
    this.localizedValues,
  });

  Route copyWith({
    int? distanceMeters,
    String? duration,
    Polyline? polyline,
    LocalizedValues? localizedValues,
  }) =>
      Route(
        distanceMeters: distanceMeters ?? this.distanceMeters,
        duration: duration ?? this.duration,
        polyline: polyline ?? this.polyline,
        localizedValues: localizedValues ?? this.localizedValues,
      );

  factory Route.fromJson(Map<String, dynamic> json) => Route(
        distanceMeters: json["distanceMeters"],
        duration: json["duration"],
        polyline: json["polyline"] == null
            ? null
            : Polyline.fromJson(json["polyline"]),
        localizedValues: json["localizedValues"] == null
            ? null
            : LocalizedValues.fromJson(json["localizedValues"]),
      );

  Map<String, dynamic> toJson() => {
        "distanceMeters": distanceMeters,
        "duration": duration,
        "polyline": polyline?.toJson(),
        "localizedValues": localizedValues?.toJson(),
      };
}

class LocalizedValues {
  final Distance? distance;
  final Distance? duration;
  final Distance? staticDuration;

  LocalizedValues({
    this.distance,
    this.duration,
    this.staticDuration,
  });

  LocalizedValues copyWith({
    Distance? distance,
    Distance? duration,
    Distance? staticDuration,
  }) =>
      LocalizedValues(
        distance: distance ?? this.distance,
        duration: duration ?? this.duration,
        staticDuration: staticDuration ?? this.staticDuration,
      );

  factory LocalizedValues.fromJson(Map<String, dynamic> json) =>
      LocalizedValues(
        distance: json["distance"] == null
            ? null
            : Distance.fromJson(json["distance"]),
        duration: json["duration"] == null
            ? null
            : Distance.fromJson(json["duration"]),
        staticDuration: json["staticDuration"] == null
            ? null
            : Distance.fromJson(json["staticDuration"]),
      );

  Map<String, dynamic> toJson() => {
        "distance": distance?.toJson(),
        "duration": duration?.toJson(),
        "staticDuration": staticDuration?.toJson(),
      };
}

class Distance {
  final String? text;

  Distance({
    this.text,
  });

  Distance copyWith({
    String? text,
  }) =>
      Distance(
        text: text ?? this.text,
      );

  factory Distance.fromJson(Map<String, dynamic> json) => Distance(
        text: json["text"],
      );

  Map<String, dynamic> toJson() => {
        "text": text,
      };
}

class Polyline {
  final String? encodedPolyline;

  Polyline({
    this.encodedPolyline,
  });

  Polyline copyWith({
    String? encodedPolyline,
  }) =>
      Polyline(
        encodedPolyline: encodedPolyline ?? this.encodedPolyline,
      );

  factory Polyline.fromJson(Map<String, dynamic> json) => Polyline(
        encodedPolyline: json["encodedPolyline"],
      );

  Map<String, dynamic> toJson() => {
        "encodedPolyline": encodedPolyline,
      };

  List<LatLng>? get points => isEmpty(encodedPolyline)
      ? null
      : PolyUtils.decode(encodedPolyline!)
          .map((Point value) => LatLng(
                value.x.toDouble(),
                value.y.toDouble(),
              ))
          .toList();
}
