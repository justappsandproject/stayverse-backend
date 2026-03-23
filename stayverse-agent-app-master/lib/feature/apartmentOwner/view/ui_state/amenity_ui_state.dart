class Amenity {
  final String name;
  final bool isSelected;

  const Amenity({
    required this.name,
    this.isSelected = false,
  });

  Amenity copyWith({
    String? name,
    bool? isSelected,
  }) {
    return Amenity(
      name: name ?? this.name,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

abstract class AmenitiesRepository {
  List<Amenity> getAmenities();
  void toggleAmenity(String name);
  void resetAmenities();
}

class AmenitiesRepositoryImpl implements AmenitiesRepository {
  List<Amenity> _amenities = [
    const Amenity(name: 'Pool'),
    const Amenity(name: 'Balcony'),
    const Amenity(name: 'Snooker Board'),
    const Amenity(name: 'Garage'),
    const Amenity(name: 'Security'),
    const Amenity(name: 'Gym'),
    const Amenity(name: 'Air Conditioning'),
    const Amenity(name: 'Parking'),
    const Amenity(name: 'Wifi'),
    const Amenity(name: 'Washer'),
  ];

  @override
  List<Amenity> getAmenities() => List.unmodifiable(_amenities);

  @override
  void toggleAmenity(String name) {
    _amenities = _amenities.map((amenity) {
      if (amenity.name == name) {
        return amenity.copyWith(isSelected: !amenity.isSelected);
      }
      return amenity;
    }).toList();
  }

   @override
  void resetAmenities() {
    _amenities = _amenities
        .map((amenity) => amenity.copyWith(isSelected: false))
        .toList();
  }
}

class ApartmentTypeState {
  final String? selectedType;

  ApartmentTypeState({
    this.selectedType,
  });

  ApartmentTypeState copyWith({
    String? selectedType,
  }) {
    return ApartmentTypeState(
      selectedType: selectedType ?? this.selectedType,
    );
  }
}