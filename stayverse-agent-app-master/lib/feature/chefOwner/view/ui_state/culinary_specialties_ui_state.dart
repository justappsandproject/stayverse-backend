class CulinarySpecialty {
  final String name;
  final bool isSelected;
  const CulinarySpecialty({
    required this.name,
    this.isSelected = false,
  });
  CulinarySpecialty copyWith({
    String? name,
    bool? isSelected,
  }) {
    return CulinarySpecialty(
      name: name ?? this.name,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

abstract class CulinarySpecialtiesRepository {
  List<CulinarySpecialty> getSpecialties();
  void toggleSpecialty(String name);
  void resetSpecialties();
  void setSpecialties(List<CulinarySpecialty> newSpecialties);
}

class CulinarySpecialtiesRepositoryImpl
    implements CulinarySpecialtiesRepository {
  List<CulinarySpecialty> specialties = [
    const CulinarySpecialty(name: 'Asian'),
    const CulinarySpecialty(name: 'African'),
    const CulinarySpecialty(name: 'English'),
    const CulinarySpecialty(name: 'Italian'),
    const CulinarySpecialty(name: 'French'),
    const CulinarySpecialty(name: 'Mexican'),
    const CulinarySpecialty(name: 'Mediterranean'),
    const CulinarySpecialty(name: 'Indian'),
    const CulinarySpecialty(name: 'Middle Eastern'),
    const CulinarySpecialty(name: 'Caribbean'),
  ];
  @override
  List<CulinarySpecialty> getSpecialties() => List.unmodifiable(specialties);
  @override
  void toggleSpecialty(String name) {
    specialties = specialties.map((specialty) {
      if (specialty.name == name) {
        return specialty.copyWith(isSelected: !specialty.isSelected);
      }
      return specialty;
    }).toList();
  }

  @override
  void resetSpecialties() {
    specialties = specialties
        .map((specialty) => specialty.copyWith(isSelected: false))
        .toList();
  }

  @override
  void setSpecialties(List<CulinarySpecialty> newSpecialties) {
    specialties = newSpecialties;
  }
}
