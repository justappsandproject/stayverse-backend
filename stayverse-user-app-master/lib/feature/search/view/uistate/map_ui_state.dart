import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stayverse/feature/search/model/data/map_data.dart';

class MapUiState {
  final Set<Marker> markers;
  final List<MapData> mapDataList;
  final bool isLoading;

  MapUiState({
    this.markers = const {},
    this.mapDataList = const [],
    this.isLoading = false,
  });

  MapUiState copyWith({
    Set<Marker>? markers,
    List<MapData>? mapDataList,
    bool? isLoading,
  }) {
    return MapUiState(
      markers: markers ?? this.markers,
      mapDataList: mapDataList ?? this.mapDataList,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}