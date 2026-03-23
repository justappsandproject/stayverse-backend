import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/app_icons.dart';
import '../view/ui_state/preview_amenity_ui_state.dart';

class AmenityNotifier extends StateNotifier<List<AmenityFeature>> {
  AmenityNotifier()
      : super([
          AmenityFeature( name: "Air Conditioning", iconName: AppIcons.air_conditioner),
          AmenityFeature(name: "Parking", iconName: AppIcons.parking),
          AmenityFeature(name: "Wifi", iconName: AppIcons.wifi),
          AmenityFeature(name: "Washer", iconName: AppIcons.washer),
          AmenityFeature(name: "Mountain View", iconName: AppIcons.mountain),
          AmenityFeature(name: "Pets Allowed", iconName: AppIcons.pets_allowed),
          AmenityFeature(name: "Pool", iconName: AppIcons.pool),
          AmenityFeature(name: "Gym", iconName: AppIcons.gym),
          AmenityFeature(name: "Balcony", iconName: AppIcons.balcony),
          AmenityFeature(name: "Garage", iconName: AppIcons.garage),
          AmenityFeature(name: "Security", iconName: AppIcons.security),
          AmenityFeature(name: "Snooker Board", iconName: AppIcons.snooker),
        ]);
}

final amenityProvider =
    StateNotifierProvider<AmenityNotifier, List<AmenityFeature>>((ref) {
  return AmenityNotifier();
});
