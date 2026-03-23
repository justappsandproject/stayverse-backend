import 'package:dart_extensions/dart_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/config/constant.dart';
import 'package:stayverse/core/util/map/map_utility.dart';
import 'package:stayverse/feature/search/controller/map_controller.dart';
import 'package:stayverse/feature/search/model/data/map_data.dart';
import 'package:stayverse/feature/search/view/component/search_result_dialog.dart';

class SearchMapView extends ConsumerStatefulWidget {
  const SearchMapView({super.key});

  @override
  ConsumerState<SearchMapView> createState() => _SearchMapViewState();
}

class _SearchMapViewState extends ConsumerState<SearchMapView>
    with AutomaticKeepAliveClientMixin {
  final scaffoldState = GlobalKey<ScaffoldState>();
  void _onMarkerTap(
      BuildContext context, String id, List<MapData> mapDataList) {
    final mapData = mapDataList.firstOrNullWhere((data) => data.id == id);
    if (mapData != null) {
      SearchResultDialog.showSearchResult(scaffoldState, mapData);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final mapState = ref.watch(mapController);
    final controller = ref.read(mapController.notifier);
    return Scaffold(
      key: scaffoldState,
      body: Stack(
        children: [
          Positioned.fill(
            child: GoogleMap(
              style: MapUtility.instance.mapStyle,
              myLocationButtonEnabled: false,
              padding: EdgeInsets.only(bottom: 0.03.sh),
              myLocationEnabled: true,
              onMapCreated: (GoogleMapController mapCtrl) {
                controller.onMapCreated(mapCtrl);
              },
              markers: mapState.markers.map((marker) {
                final markerId = marker.markerId.value;
                return marker.copyWith(
                  onTapParam: () =>
                      _onMarkerTap(context, markerId, mapState.mapDataList),
                );
              }).toSet(),
              mapType: MapType.normal,
              initialCameraPosition: const CameraPosition(
                target: Constant.defaultLocation,
                zoom: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
