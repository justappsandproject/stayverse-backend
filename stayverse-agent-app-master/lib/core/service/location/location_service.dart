import 'package:dio/dio.dart';
import 'package:stayvers_agent/core/config/constant.dart';
import 'package:stayvers_agent/core/service/permission/permission_manager.dart';
import 'package:stayvers_agent/core/util/app/logger.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_utils/poly_utils.dart';
import 'dart:math' as math;

import 'package:google_maps_utils/spherical_utils.dart';

class LocationService {
  static final _log = BrimLogger.load(LocationService);

  ///Get current location
  static Future<LatLng?> currentLocation() async {
    final permissionGranted =
        await PermissionManager.isLocationPermissionEnable();

    if (!permissionGranted) {
      await PermissionManager.requestLocationPermission();
    }
    return _myLocation();
  }

  ///This listen to user location and send back the
  ///[LatLng] - [distanceFilter] is 20m by default
  static Stream<LatLng> listenToLocationUpdate({
    int distanceFilter = 10,
  }) {
    return Geolocator.getPositionStream(
        locationSettings: LocationSettings(
      distanceFilter: distanceFilter,
    )).map((event) => LatLng(event.latitude, event.longitude));
  }

  static Stream<Position> listenToPositionUpdate({
    int distanceFilter = 10,
  }) {
    return Geolocator.getPositionStream(
        locationSettings: LocationSettings(distanceFilter: distanceFilter));
  }

  static Future<LatLng?> _myLocation() async {
    Position? position;
    try {
      final currentPostion = await Geolocator.getCurrentPosition(
          timeLimit: 10.seconds,
          desiredAccuracy: LocationAccuracy.bestForNavigation);

      position = currentPostion;
    } catch (_) {
      position = await Geolocator.getLastKnownPosition();
    }

    return position != null
        ? LatLng(position.latitude, position.longitude)
        : null;
  }

  static Future<Position?> lastKnowPosition() async {
    return await Geolocator.getLastKnownPosition();
  }

  static int distanceBetweenPoints(LatLng origin, LatLng dest) {
    final distance = SphericalUtils.computeDistanceBetween(
        math.Point(origin.longitude, origin.latitude),
        math.Point(dest.longitude, dest.latitude));
    return distance.toInt();
  }

  static double calculateHeading(LatLng origin, LatLng dest) {
    final distance = SphericalUtils.computeHeading(
        math.Point(origin.longitude, origin.latitude),
        math.Point(dest.longitude, dest.latitude));
    return distance.toDouble();
  }

  static String encodePolyline(List<LatLng> points) {
    List<math.Point> pointList = points
        .map((point) => math.Point(point.longitude, point.latitude))
        .toList();
    return PolyUtils.encode(pointList);
  }

  static List<LatLng> decodePolyline(String encoded) {
    List<math.Point> decodedPoints = PolyUtils.decode(encoded);
    return decodedPoints
        .map((point) => LatLng(point.y.toDouble(), point.x.toDouble()))
        .toList();
  }

  static LatLngBounds boundFromPolyline(List<LatLng> polylinePoints) {
    return LatLngBounds(
      southwest: LatLng(
        polylinePoints.map((e) => e.latitude).reduce((a, b) => a < b ? a : b),
        polylinePoints.map((e) => e.longitude).reduce((a, b) => a < b ? a : b),
      ),
      northeast: LatLng(
        polylinePoints.map((e) => e.latitude).reduce((a, b) => a > b ? a : b),
        polylinePoints.map((e) => e.longitude).reduce((a, b) => a > b ? a : b),
      ),
    );
  }

  static Future<void> sendMyCurrentLocation(
      {required double latitude,
      required double longitude,
      required String token}) async {
    try {
      final response = await Dio().post(
        '${Constant.host}/user/update-location',
        data: {
          'location': {
            'lat': latitude,
            'lng': longitude,
          }
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        _log.i('Location sent successfully. ${response.data}');
      } else {
        _log.i('Failed to send location. Status code: ${response.statusCode}');
      }
    } catch (e) {
      _log.i('Error sending location: $e');
    }
  }
}
