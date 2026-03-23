import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/core/data/enum/enums.dart';

import '../view/ui_state/amenity_ui_state.dart';
import 'apartment_advert_notifier.dart';

final amenitiesRepositoryProvider = Provider<AmenitiesRepository>((ref) {
  return AmenitiesRepositoryImpl();
});

final createApartmentAmenities =
    StateNotifierProvider<AmenitiesNotifier, List<Amenity>>((ref) {
  final repository = ref.watch(amenitiesRepositoryProvider);
  return AmenitiesNotifier(repository, ref, ProviderMode.create);
});

final editApartmentAmenities =
    StateNotifierProvider<AmenitiesNotifier, List<Amenity>>((ref) {
  final repository = ref.watch(amenitiesRepositoryProvider);
  return AmenitiesNotifier(repository, ref, ProviderMode.edit);
});

final createApartmentSelectionValid = Provider<bool>((ref) {
  final selectedAmenities = ref
      .watch(createApartmentAmenities)
      .where((amenity) => amenity.isSelected)
      .toList();
  final count = selectedAmenities.length;
  return count >= 3 && count <= 7;
});

final editApartmentSelectionValid = Provider<bool>((ref) {
  final selectedAmenities = ref
      .watch(editApartmentAmenities)
      .where((amenity) => amenity.isSelected)
      .toList();
  final count = selectedAmenities.length;
  return count >= 3 && count <= 7;
});

class AmenitiesNotifier extends StateNotifier<List<Amenity>> {
  final AmenitiesRepository _repository;
  final Ref ref;
  final ProviderMode mode;

  static const int minAmenities = 3;
  static const int maxAmenities = 7;

  AmenitiesNotifier(this._repository, this.ref, this.mode)
      : super(_repository.getAmenities());

  void reset() {
    _repository.resetAmenities(); // Add this to your repository
    final updatedAmenities = _repository.getAmenities();
    state = updatedAmenities;

    // Clear the selected features in the advert state
    final apartmentAdvert = mode == ProviderMode.create
        ? createApartmentAdvert
        : editApartmentAdvert;
    ref.read(apartmentAdvert.notifier).updateAmenities([]);
  }

  void toggleAmenity(String name) {
    final currentAmenity = state.firstWhere((amenity) => amenity.name == name);
    final currentSelectedCount =
        state.where((amenity) => amenity.isSelected).length;

    // If trying to select and we're at maximum, don't allow
    if (!currentAmenity.isSelected && currentSelectedCount >= maxAmenities) {
      return;
    }

    final updated = state.map((a) {
      if (a.name == name) {
        return a.copyWith(isSelected: !a.isSelected);
      }
      return a;
    }).toList();

    state = updated;

    final selectedAmenityNames = updated
        .where((amenity) => amenity.isSelected)
        .map((amenity) => amenity.name)
        .toList();

    final apartmentAdvert = mode == ProviderMode.create
        ? createApartmentAdvert
        : editApartmentAdvert;
    ref.read(apartmentAdvert.notifier).updateAmenities(selectedAmenityNames);
  }

  void setSelectedAmenities(List<String> features) {
    // ✅ apply selection on top of existing full list
    final updated = _repository.getAmenities().map((a) {
      return a.copyWith(isSelected: features.contains(a.name));
    }).toList();

    state = updated;

    final apartmentAdvert = mode == ProviderMode.create
        ? createApartmentAdvert
        : editApartmentAdvert;
    ref.read(apartmentAdvert.notifier).updateAmenities(features);
  }

  int get selectedCount => state.where((amenity) => amenity.isSelected).length;
}

class ApartmentTypeNotifier extends StateNotifier<ApartmentTypeState> {
  final ProviderMode mode;
  ApartmentTypeNotifier(this.mode) : super(ApartmentTypeState());

  void selectType(String selectedType) {
    state = state.copyWith(selectedType: selectedType);
  }

  void reset() {
    state = ApartmentTypeState(); // Complete reset to initial state
  }
}

final createApartmentType =
    StateNotifierProvider<ApartmentTypeNotifier, ApartmentTypeState>(
        (ref) => ApartmentTypeNotifier(ProviderMode.create));

final editApartmentType =
    StateNotifierProvider<ApartmentTypeNotifier, ApartmentTypeState>(
        (ref) => ApartmentTypeNotifier(ProviderMode.edit));