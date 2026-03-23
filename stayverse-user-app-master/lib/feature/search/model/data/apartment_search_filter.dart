class ApartmentSearchFilter {
  final int? limit;
  final int? page;
  final double? radius;
  final double? lng;
  final double? lat;
  final List<String>? amenities;
  final int? numberOfBedrooms;
  final double? maxPrice;
  final double? minPrice;
  final String? apartmentType;
  final String? searchTerm;
  final DateTime? moveInDate;

  ApartmentSearchFilter({
    this.limit,
    this.page,
    this.radius,
    this.lng,
    this.lat,
    this.amenities,
    this.numberOfBedrooms,
    this.maxPrice,
    this.minPrice,
    this.apartmentType,
    this.searchTerm,
    this.moveInDate,
  });

  ApartmentSearchFilter copyWith({
    int? limit,
    int? page,
    double? radius,
    double? lng,
    double? lat,
    List<String>? amenities,
    int? numberOfBedrooms,
    double? maxPrice,
    double? minPrice,
    String? apartmentType,
    String? searchTerm,
    DateTime? moveInDate,
  }) {
    return ApartmentSearchFilter(
      limit: limit ?? this.limit,
      page: page ?? this.page,
      radius: radius ?? this.radius,
      lng: lng ?? this.lng,
      lat: lat ?? this.lat,
      amenities: amenities ?? this.amenities,
      numberOfBedrooms: numberOfBedrooms ?? this.numberOfBedrooms,
      maxPrice: maxPrice ?? this.maxPrice,
      minPrice: minPrice ?? this.minPrice,
      apartmentType: apartmentType ?? this.apartmentType,
      searchTerm: searchTerm ?? this.searchTerm,
      moveInDate: moveInDate ?? this.moveInDate,
    );
  }

  // Convert filter to query parameters
  Map<String, dynamic> toQueryParameters() {
    final Map<String, dynamic> params = {};

    if (limit != null) params['limit'] = limit.toString();
    if (page != null) params['page'] = page.toString();
    if (radius != null) params['radius'] = radius.toString();
    if (lng != null) params['lng'] = lng.toString();
    if (lat != null) params['lat'] = lat.toString();
    if (amenities != null && amenities!.isNotEmpty) {
      params['amenities'] = amenities;
    }
    if (numberOfBedrooms != null) {
      params['numberOfBedrooms'] = numberOfBedrooms.toString();
    }
    if (maxPrice != null) params['maxPrice'] = maxPrice.toString();
    if (minPrice != null) params['minPrice'] = minPrice.toString();
    if (apartmentType != null) params['apartmentType'] = apartmentType;
    if (searchTerm != null) params['searchTerm'] = searchTerm;

    if (moveInDate != null) {
      params['moveInDate'] = moveInDate!.toIso8601String();
    }

    return params;
  }
}
