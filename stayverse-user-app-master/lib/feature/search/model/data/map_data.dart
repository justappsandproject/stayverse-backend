import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stayverse/core/data/base_service.dart';

class MapData {
  final String? id;
  final String? price;
  final String? imageUrl;
  final String? title;
  final String? location;
  final String? period;
  final LatLng? position;
  final BaseService? searchResult;

  MapData({
    this.id,
    this.price,
    this.imageUrl,
    this.title,
    this.location,
    this.period,
    this.position,
    this.searchResult,
  });
}
