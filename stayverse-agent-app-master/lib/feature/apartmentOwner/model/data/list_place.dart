import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stayvers_agent/core/util/image/app_assets.dart';
import 'package:stayvers_agent/feature/apartmentOwner/view/component/full_map_view.dart';

final List<MarkerData> markerDataList = [
  MarkerData(
    const LatLng(6.605474, 3.349549),
    AppAsset.home,
    'home',
  ),
  MarkerData(
    const LatLng(6.606174, 3.348449),
    '₦185K',
    'location10',
  ),
  MarkerData(
    const LatLng(6.605774, 3.349249),
    '₦275K',
    'location11',
  ),
  MarkerData(
    const LatLng(6.606374, 3.348649),
    '₦230K',
    'location12',
  ),
];
