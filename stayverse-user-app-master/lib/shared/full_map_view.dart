// import 'package:dart_extensions/dart_extensions.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:stayverse/core/commonLibs/common_libs.dart';
// import 'package:stayverse/core/util/image/app_assets.dart';
// import 'package:stayverse/core/util/map/map_utility.dart';

// import 'package:stayverse/feature/search/view/component/map_item_card.dart';

// class FullMapView extends StatefulWidget {
//   const FullMapView({super.key});

//   @override
//   State<FullMapView> createState() => _FullMapViewState();
// }

// class _FullMapViewState extends State<FullMapView> {
//   final Set<Marker> _markers = {};

//   @override
//   void initState() {
//     super.initState();
//     _createMarkers();
//   }

//   void _onMarkerTap(String id) {
//     showBottomSheet(
//       context: context,

//       backgroundColor: Colors.transparent, // No default white background
//       builder: (context) {
//         return Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
//           child: MapItemCard(
//             imageUrl: AppAsset.apartment,
//             title: '1 bedroom apartment',
//             location: 'Lekki Phase 1, Lagos',
//             price: (markerDataList.firstOrNullWhere((data) => data.id == id))
//                     ?.price ??
//                 '',
//             period: 'night',
//           ).animate().scaleXY(
//                 begin: 0.8,
//                 end: 1.0,
//                 duration: 500.ms,
//                 curve: Curves.elasticOut, // Bouncing effect
//               ),
//         );
//       },
//     );
//   }

//   Future<void> _createMarkers() async {
//     for (var data in markerDataList) {
//       final BitmapDescriptor markerIcon =
//           await MapUtility.instance.creatPriceBitMapMarker(data.price);
//       final marker = Marker(
//         markerId: MarkerId(data.id),
//         position: data.position,
//         onTap: () => _onMarkerTap(data.id),
//         icon: markerIcon,
//       );

//       setState(() {
//         _markers.add(marker);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GoogleMap(
//       style: MapUtility.instance.mapStyle,
//       myLocationButtonEnabled: false,
//       padding: EdgeInsets.only(bottom: 0.05.sh),
//       myLocationEnabled: true,
//       markers: _markers,
//       mapType: MapType.normal,
//       initialCameraPosition: const CameraPosition(
//         target: LatLng(6.605874, 3.349149),
//         zoom: 18,
//       ),
//     );
//   }
// }

// class MarkerData {
//   final LatLng position;
//   final String price;
//   final String id;

//   MarkerData(this.position, this.price, this.id);
// }
