import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/config/constant.dart';
import 'package:stayvers_agent/core/util/map/map_utility.dart';

class CarMapView extends StatefulWidget {
  final LatLng? latLng;
  final String address;

  const CarMapView({
    super.key,
    this.latLng,
    this.address = 'Apartment Location',
  });

  @override
  State<CarMapView> createState() => _CarMapViewState();
}

class _CarMapViewState extends State<CarMapView> {
  final Set<Marker> _markers = {};
  GoogleMapController? _mapController;

  @override
  void initState() {
    _addApartmentMarker();
    super.initState();
  }

  Future<void> _addApartmentMarker() async {
    final marker = Marker(
      markerId: const MarkerId('apartment_location'),
      position: widget.latLng ?? Constant.defaultLocation,
      icon: MapUtility.instance.apartmentLocationMarkerIcon ??
          BitmapDescriptor.defaultMarker,
      infoWindow: InfoWindow(
        title: widget.address,
        snippet: 'Your apartment location',
      ),
    );
    setState(() {
      _markers.add(marker);
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: widget.latLng ?? Constant.defaultLocation,
          zoom: 18.0,
          tilt: 60.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      style: MapUtility.instance.mapStyle,
      myLocationButtonEnabled: false,
      compassEnabled: true,
      mapToolbarEnabled: false,
      myLocationEnabled: true,
      markers: _markers,
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(
        target: widget.latLng ?? Constant.defaultLocation,
        tilt: 60.0,
        zoom: 18.0,
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}