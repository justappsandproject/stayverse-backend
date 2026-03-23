import 'package:geolocator/geolocator.dart';

class LocationPermissonManager {
  LocationPermissonManager._();

  static final _instance = LocationPermissonManager._();

  static final internal = _instance;

  factory LocationPermissonManager() {
    return _instance;
  }

  Future<LocationPermission> requestLocationPermssion() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission;
  }

  Future<bool> hasAccepted() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  Future<bool> checkAndRequestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return false;
      }
    }

    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  Stream<ServiceStatus> status() {
    return Geolocator.getServiceStatusStream();
  }
}
