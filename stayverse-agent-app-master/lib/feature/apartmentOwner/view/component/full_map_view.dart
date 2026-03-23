import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/util/map/map_utility.dart';

class FullMapView extends StatefulWidget {
  const FullMapView({super.key});

  @override
  State<FullMapView> createState() => _FullMapViewState();
}

class _FullMapViewState extends State<FullMapView> {
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    // _createMarkers();
  }

  // Future<void> _createMarkers() async {
  //   for (var data in markerDataList) {
  //     final BitmapDescriptor markerIcon =
  //         await MapUtility.instance.creatPriceBitMapMarker(data.icon);
  //     final marker = Marker(
  //       markerId: MarkerId(data.id),
  //       position: data.position,
  //       onTap: () {},
  //       icon: markerIcon,
  //     );

  //     setState(() {
  //       _markers.add(marker);
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      style: MapUtility.instance.mapStyle,
      myLocationButtonEnabled: false,
      padding: EdgeInsets.only(bottom: 0.05.sh),
      myLocationEnabled: true,
      markers: _markers,
      mapType: MapType.normal,
      zoomControlsEnabled: false,
      zoomGesturesEnabled: true,
      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
        Factory<PanGestureRecognizer>(() => PanGestureRecognizer()),
        Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()),
      },
      initialCameraPosition: const CameraPosition(
        target: LatLng(6.605874, 3.349149),
        zoom: 18,
      ),
    );
  }
}

class MarkerData {
  final LatLng position;
  final String icon;
  final String id;

  MarkerData(this.position, this.icon, this.id);
}
