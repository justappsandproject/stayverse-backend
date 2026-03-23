import 'package:google_maps_flutter/google_maps_flutter.dart';

class RouteData {
  const RouteData({
    this.points,
    this.distance,
    this.duration,
    this.distanceText,
    this.durationText,
    this.averageSpeed,
  });

  final List<LatLng>? points;
  final int? duration;
  final int? distance;
  final String? durationText;
  final String? distanceText;
  final double? averageSpeed;

  // Convert RouteData to JSON
  Map<String, dynamic> toJson() {
    return {
      // 'points': points?.map((point) => {'lat': point.latitude, 'lng': point.longitude}).toList(),
      'duration': duration,
      'distance': distance,
      'durationText': durationText,
      'distanceText': distanceText,
      'averageSpeed': averageSpeed,
    };
  }

  // Convert JSON to RouteData
  factory RouteData.fromJson(Map<String, dynamic> json) {
    return RouteData(
      points: (json['points'] as List<dynamic>?)
          ?.map((item) => LatLng(item['lat'], item['lng']))
          .toList(),
      duration: json['duration'],
      distance: json['distance'],
      durationText: json['durationText'],
      distanceText: json['distanceText'],
      averageSpeed: json['averageSpeed']?.toDouble(),
    );
  }
}
