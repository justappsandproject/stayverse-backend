import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stayverse/core/service/location/location_service.dart';
import 'package:stayverse/core/util/map/map_utility.dart';
import 'package:stayverse/feature/search/model/data/map_data.dart';
import 'package:stayverse/feature/search/view/uistate/map_ui_state.dart';

class MapController extends StateNotifier<MapUiState> {
  MapController() : super(MapUiState());

  GoogleMapController? _directController;

  void onMapCreated(GoogleMapController controller) {
    _directController = controller;
    if (state.mapDataList.isNotEmpty) {
      _processPendingMapData();
    }
  }

  void _processPendingMapData() {
    adjustFromMapData(state.mapDataList);
  }

  void adjustLatLngBoundsForPolyline(List<LatLng>? polylinePoints) async {
    if (polylinePoints == null || polylinePoints.isEmpty) return;

    final bounds = LocationService.boundFromPolyline(polylinePoints);

    if (_directController != null) {
      _directController!
          .animateCamera(CameraUpdate.newLatLngBounds(bounds, 40));
    }
  }

  Future<void> flushInData(List<MapData> mapDataList) async {
    state = state.copyWith(mapDataList: mapDataList);

    await createMarkers(mapDataList);

    if (_directController != null) {
      adjustFromMapData(mapDataList);
    }
  }

  void adjustFromMapData(List<MapData> mapDataList) async {
    final validPositions = mapDataList
        .where((e) => e.position != null)
        .map((e) => e.position!)
        .toList();

    if (validPositions.isNotEmpty) {
      adjustLatLngBoundsForPolyline(validPositions);
    }
  }

  Future<void> createMarkers(List<MapData> mapDataList) async {
    final Set<Marker> markers = {};

    for (var data in mapDataList) {
      if (data.position == null) continue;

      try {
        final BitmapDescriptor markerIcon =
            await MapUtility.instance.creatPriceBitMapMarker(data.price ?? '');

        final marker = Marker(
          consumeTapEvents: true,
          markerId: MarkerId(data.id ?? ''),
          position: data.position!,
       
          icon: markerIcon,
        );

        markers.add(marker);
      } catch (_) {}
    }

    state = state.copyWith(markers: markers);
  }


  @override
  void dispose() {
    _directController?.dispose();

    super.dispose();
  }
}

final mapController = StateNotifierProvider<MapController, MapUiState>((ref) {
  return MapController();
});
