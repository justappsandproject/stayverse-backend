class CarSearchFilter {
  final int? limit;
  final int? page;
  final double? radius;
  final double? lng;
  final double? lat;
  final List<String>? features;
  final double? maxPrice;
  final double? minPrice;
  final String? rideType;
  final String? searchTerm;
  final String? description;
  final DateTime? pickupDate;

  CarSearchFilter({
    this.limit,
    this.page,
    this.radius,
    this.lng,
    this.lat,
    this.features,
    this.maxPrice,
    this.minPrice,
    this.rideType,
    this.searchTerm,
    this.description,
    this.pickupDate,
  });

  CarSearchFilter copyWith({
    int? limit,
    int? page,
    double? radius,
    double? lng,
    double? lat,
    List<String>? features,
    double? maxPrice,
    double? minPrice,
    String? rideType,
    String? searchTerm,
    String? description,
    DateTime? pickupDate,
  }) {
    return CarSearchFilter(
      limit: limit ?? this.limit,
      page: page ?? this.page,
      radius: radius ?? this.radius,
      lng: lng ?? this.lng,
      lat: lat ?? this.lat,
      features: features ?? this.features,
      maxPrice: maxPrice ?? this.maxPrice,
      minPrice: minPrice ?? this.minPrice,
      rideType: rideType ?? this.rideType,
      searchTerm: searchTerm ?? this.searchTerm,
      description: description ?? this.description,
      pickupDate: pickupDate ?? this.pickupDate,
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
    if (features != null && features!.isNotEmpty) {
      params['features'] = features;
    }
    if (maxPrice != null) params['priceMax'] = maxPrice.toString();
    if (minPrice != null) params['priceMin'] = minPrice.toString();
    if (rideType != null) params['rideType'] = rideType;
    if (searchTerm != null) params['searchTerm'] = searchTerm;
    if (description != null) params['description'] = description;

    if (pickupDate != null) {
      params['pickupDate'] = pickupDate!.toIso8601String();
    }

    return params;
  }
}