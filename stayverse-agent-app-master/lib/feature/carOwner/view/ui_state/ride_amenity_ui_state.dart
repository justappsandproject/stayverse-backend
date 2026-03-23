import 'package:stayvers_agent/feature/apartmentOwner/view/ui_state/amenity_ui_state.dart';

abstract class RideAmenitiesRepository {
  List<Amenity> getAmenities();
  void toggleAmenity(String name);
  void resetAmenities();
}

class RideAmenitiesRepositoryImpl implements RideAmenitiesRepository {
  List<Amenity> _rideAmenities = [
    const Amenity(name: 'Bluetooth Conectivity'),
    const Amenity(name: 'Eletric'),
    const Amenity(name: 'Sunroof'),
    const Amenity(name: 'offroad'),
    const Amenity(name: 'Remote'),
    const Amenity(name: 'AWD'),
    const Amenity(name: 'Air conditioning'),
    const Amenity(name: 'Sport'),
  ];

  @override
  List<Amenity> getAmenities() => List.unmodifiable(_rideAmenities);

  @override
  void toggleAmenity(String name) {
    _rideAmenities = _rideAmenities.map((rideAmenity) {
      if (rideAmenity.name == name) {
        return rideAmenity.copyWith(isSelected: !rideAmenity.isSelected);
      }
      return rideAmenity;
    }).toList();
  }

   @override
  void resetAmenities() {
    _rideAmenities = _rideAmenities
        .map((amenity) => amenity.copyWith(isSelected: false))
        .toList();
  }
}

class VehicleTypeState {
  final String? selectedType;

  VehicleTypeState({
    this.selectedType,
  });

  VehicleTypeState copyWith({
    String? selectedType,
  }) {
    return VehicleTypeState(
      selectedType: selectedType ?? this.selectedType,
    );
  }
}
