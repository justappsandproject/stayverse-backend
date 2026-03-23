import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../apartmentOwner/view/ui_state/preview_amenity_ui_state.dart';

class RideAmenityPostNotifier extends StateNotifier<List<AmenityFeature>> {
  RideAmenityPostNotifier()
      : super([
          AmenityFeature(name: "Air Conditioner"),
          AmenityFeature(name: "Sunroof"),
          AmenityFeature(name: "Remote"),
          AmenityFeature(name: "AWD"),
          AmenityFeature(name: "Bluetooth Conectivity"),
          AmenityFeature(name: "Sport"),
          AmenityFeature(name: "offroad"),
          AmenityFeature(name: "Eletric"),
        ]);

  // bool _showAll = false;

  // bool get showAll => _showAll;

  // void toggleShowAll() {
  //   _showAll = !_showAll;
  //   state = List.from(state);
  // }
}

final rideAmenityProvider = StateNotifierProvider<RideAmenityPostNotifier, List<AmenityFeature>>((ref) {
  return RideAmenityPostNotifier();
});