import 'dart:math' as math;

import 'package:dart_extensions/dart_extensions.dart';
import 'package:stayvers_agent/core/data/measurment.dart';
import 'package:stayvers_agent/core/service/brimPlace/brim_place.dart';
import 'package:stayvers_agent/core/service/brimPlace/model/data/route_headers.dart';
import 'package:stayvers_agent/core/service/brimPlace/model/data/route_request.dart';
import 'package:stayvers_agent/core/service/location/location_service.dart';
import 'package:stayvers_agent/core/service/map/route_data.dart';
import 'package:stayvers_agent/core/service/storage/brim_memory_cache.dart';
import 'package:stayvers_agent/core/util/app/logger.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_utils/google_maps_utils.dart';

class DirectionRouteManage {
  static final _log = BrimLogger.load(DirectionRouteManage);

  static Future<RouteData?> getRoute(String cacheKey,
      {required LatLng origin, required LatLng destination}) async {
    final route = await routeFromCache(cacheKey,
        origin: origin, destination: destination);
    return route ??
        await routeFromGoogle(
            cacheKey: cacheKey, origin: origin, destination: destination);
  }

  static Future<RouteData?> routeFromCache(String cacheKey,
      {required LatLng origin, required LatLng destination}) async {
    final previousRoute = BrimMemoryCache.instance.read(cacheKey) as RouteData?;

    if (previousRoute == null || previousRoute.points?.isEmpty == true) {
      return null;
    }

    final currentPoint = math.Point(origin.longitude, origin.latitude);

    final originalPoints = previousRoute.points!
        .map((e) => math.Point(e.longitude, e.latitude))
        .toList();

    final isOnPath = PolyUtils.isLocationOnPathTolerance(
        currentPoint, originalPoints, false, 5);
    if (!isOnPath) return null;

    List<math.Point<double>> polylineCoordinates = List.from(originalPoints);

    if (polylineCoordinates.length > 1) {
      var index = polylineCoordinates.indexWhere((value) {
        var distance = SphericalUtils.computeDistanceBetween(
          currentPoint,
          math.Point(value.x, value.y),
        );
        return (distance <= 5 && distance >= 0);
      });

      if (index == 0) {
        polylineCoordinates.removeAt(0);
      } else if (index != -1) {
        polylineCoordinates.removeRange(0, index);
      }
    }

    final finalPoints = [currentPoint, ...polylineCoordinates];

    final distanceInMeters =
        LocationService.distanceBetweenPoints(origin, destination);

    int duration = 0;
    if (previousRoute.averageSpeed != null && previousRoute.averageSpeed! > 0) {
      // Duration in seconds
      duration = (distanceInMeters / previousRoute.averageSpeed!).round();

      // Convert duration to minutes
      duration = (duration / 60).round();
    }

    final routeData = RouteData(
      points: finalPoints.map((e) => LatLng(e.y, e.x)).toList(),
      distance: distanceInMeters,
      duration: duration,
      averageSpeed: previousRoute.averageSpeed,
      distanceText:
          '${distanceInMeters.toDouble().toMeasurement(Measurement.km)} m',
      durationText: '$duration mins',
    );

    BrimMemoryCache.instance.set(cacheKey, routeData);

    // _log.i('Route From Cache: ${routeData.toJson()}');
    return routeData;
  }

  static Future<RouteData?> routeFromGoogle({
    required LatLng origin,
    required LatLng destination,
    String? cacheKey,
  }) async {
    final res = await BrimPlace.getRoutes(
      RoutesRequest.withDefaultValues(origin: origin, destination: destination),
      RouteHeaders.routes(),
    );
    if (res == null || res.routes?.isEmpty == true) return null;
    final firstRoute = res.routes?.firstOrNull;

    final distance = firstRoute?.distanceMeters;
    final duration = firstRoute?.durationInSeconds;

    double? avgSpeed;

    if (distance != null && duration != null && duration > 0) {
      avgSpeed = (distance / duration).toStringAsFixed(2).toDoubleOrNull();
    }

    final routes = RouteData(
      points: firstRoute?.polyline?.points ?? [],
      distance: distance,
      duration: duration,
      averageSpeed: avgSpeed,
      distanceText: firstRoute?.localizedValues?.distance?.text,
      durationText: firstRoute?.localizedValues?.duration?.text,
    );

    if (cacheKey != null) {
      BrimMemoryCache.instance.set(cacheKey, routes);
    }
    // _log.i('Google Route: ${routes.toJson()}');

    return routes;
  }

  static void clearRouteCache(String cacheKey) {
    _log.i('Clear Route Cache: $cacheKey');
    BrimMemoryCache.instance.delete(cacheKey);
  }
}
