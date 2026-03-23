import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stayverse/core/data/enum/enums.dart';

abstract class HomeDataSource<T> {
  Future<T?> getRecommendations(ServiceType serviceType,LatLng latLng);
  Future<T?> getTopLocation();
  Future<T?> getTopChefs();
  Future<T?> getNewlyListed(ServiceType serviceType);
}
