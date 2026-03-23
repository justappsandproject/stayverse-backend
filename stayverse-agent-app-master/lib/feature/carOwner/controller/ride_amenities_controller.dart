import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/core/data/enum/enums.dart';
import 'package:stayvers_agent/feature/apartmentOwner/view/ui_state/amenity_ui_state.dart';

import '../view/ui_state/ride_amenity_ui_state.dart';
import 'ride_advert_controller.dart';

final rideAmenitiesRepositoryProvider =
    Provider<RideAmenitiesRepository>((ref) {
  return RideAmenitiesRepositoryImpl();
});

final createRideAmenitiesProvider =
    StateNotifierProvider<RideAmenitiesNotifier, List<Amenity>>((ref) {
  final repository = ref.watch(rideAmenitiesRepositoryProvider);
  return RideAmenitiesNotifier(repository, ref, ProviderMode.create);
});

final editRideAmenitiesProvider =
    StateNotifierProvider<RideAmenitiesNotifier, List<Amenity>>((ref) {
  final repository = ref.watch(rideAmenitiesRepositoryProvider);
  return RideAmenitiesNotifier(repository, ref, ProviderMode.edit);
});

final createAmenitySelectionValidProvider = Provider<bool>((ref) {
  final selectedAmenities = ref
      .watch(createRideAmenitiesProvider)
      .where((amenity) => amenity.isSelected)
      .toList();
  final count = selectedAmenities.length;
  return count >= 3 && count <= 7;
});

final editAmenitySelectionValidProvider = Provider<bool>((ref) {
  final selectedAmenities = ref
      .watch(editRideAmenitiesProvider)
      .where((amenity) => amenity.isSelected)
      .toList();
  final count = selectedAmenities.length;
  return count >= 3 && count <= 7;
});

class RideAmenitiesNotifier extends StateNotifier<List<Amenity>> {
  final RideAmenitiesRepository _repository;
  final Ref ref;
  final ProviderMode mode;

  static const int minAmenities = 3;
  static const int maxAmenities = 7;

  RideAmenitiesNotifier(this._repository, this.ref, this.mode)
      : super(_repository.getAmenities());

  void reset() {
    _repository.resetAmenities();
    final updatedAmenities = _repository.getAmenities();
    state = updatedAmenities;

    // Clear the selected features in the advert state
    final advertProvider = mode == ProviderMode.create
        ? createRideAdvertProvider
        : editRideAdvertProvider;
    ref.read(advertProvider.notifier).updateFeatures([]);
  }

  void toggleAmenity(String name) {
    final currentAmenity = state.firstWhere((a) => a.name == name);
    final currentSelectedCount = state.where((a) => a.isSelected).length;

    // Prevent going over max
    if (!currentAmenity.isSelected && currentSelectedCount >= maxAmenities) {
      return;
    }

    // ✅ update in-place without wiping other amenities
    final updated = state.map((a) {
      if (a.name == name) {
        return a.copyWith(isSelected: !a.isSelected);
      }
      return a;
    }).toList();

    state = updated;

    final selectedNames =
        updated.where((a) => a.isSelected).map((a) => a.name).toList();

    final advertProvider = mode == ProviderMode.create
        ? createRideAdvertProvider
        : editRideAdvertProvider;
    ref.read(advertProvider.notifier).updateFeatures(selectedNames);
  }

  void setSelectedAmenities(List<String> features) {
    // ✅ apply selection on top of existing full list
    final updated = _repository.getAmenities().map((a) {
      return a.copyWith(isSelected: features.contains(a.name));
    }).toList();

    state = updated;

    final advertProvider = mode == ProviderMode.create
        ? createRideAdvertProvider
        : editRideAdvertProvider;
    ref.read(advertProvider.notifier).updateFeatures(features);
  }

  int get selectedCount => state.where((amenity) => amenity.isSelected).length;
}

class VehicleTypeNotifier extends StateNotifier<VehicleTypeState> {
  final ProviderMode mode;
  VehicleTypeNotifier(this.mode) : super(VehicleTypeState());

  void selectType(String selectedType) {
    state = state.copyWith(selectedType: selectedType);
  }

  void reset() {
    state = VehicleTypeState(); // Complete reset to initial state
  }

  void resetselectedType() {
    state = state.copyWith(
      selectedType: '',
    );
  }
}

final createVehicleType =
    StateNotifierProvider<VehicleTypeNotifier, VehicleTypeState>(
        (ref) => VehicleTypeNotifier(ProviderMode.create));

final editVehicleType =
    StateNotifierProvider<VehicleTypeNotifier, VehicleTypeState>(
        (ref) => VehicleTypeNotifier(ProviderMode.edit));
