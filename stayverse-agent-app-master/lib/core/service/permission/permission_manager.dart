import 'dart:io';

import 'package:stayvers_agent/core/service/location/permission/location_permission.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart'
    as permisssion_handler;

///Manage Permisssion in the app
///Support only [LocationPermissonManager]
class PermissionManager {
  static Future<bool> isLocationPermissionEnable() {
    return LocationPermissonManager.internal.hasAccepted();
  }

  static Future<bool> checkAndRequestForLocationPermission() {
    return LocationPermissonManager.internal
        .checkAndRequestLocationPermission();
  }

  static Future<LocationPermission> requestLocationPermission() {
    return LocationPermissonManager.internal.requestLocationPermssion();
  }

  static Stream<ServiceStatus>? locationStatus() =>
      LocationPermissonManager.internal.status();

  static Future<void> requestForNotificationPermission() async {
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      var isPermissionGranted =
          await permisssion_handler.Permission.notification.isGranted;

      if (!isPermissionGranted) {
        await permisssion_handler.Permission.notification.request();
      }
    }
  }
}
