class ChefSearchFilter {
  final String? searchTerm;
  final List<String>? culinarySpecialties;
  final double? minPrice;
  final double? maxPrice;
  final double? lat;
  final double? lng;
  final double? radius;
  final int? limit;
  final int? page;

  ChefSearchFilter({
    this.searchTerm,
    this.culinarySpecialties,
    this.minPrice,
    this.maxPrice,
    this.lat,
    this.lng,
    this.radius,
    this.limit,
    this.page,
  });

  ChefSearchFilter copyWith({
    String? searchTerm,
    List<String>? culinarySpecialties,
    double? minPrice,
    double? maxPrice,
    double? lat,
    double? lng,
    double? radius,
    int? limit,
    int? page,
  }) {
    return ChefSearchFilter(
      searchTerm: searchTerm ?? this.searchTerm,
      culinarySpecialties: culinarySpecialties ?? this.culinarySpecialties,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      radius: radius ?? this.radius,
      limit: limit ?? this.limit,
      page: page ?? this.page,
    );
  }

  Map<String, dynamic> toQueryParameters() {
    final Map<String, dynamic> params = {};

    if (limit != null) params['limit'] = limit.toString();
    if (page != null) params['page'] = page.toString();
    if (radius != null) params['radius'] = radius.toString();
    if (lng != null) params['lng'] = lng.toString();
    if (lat != null) params['lat'] = lat.toString();
    if (minPrice != null) params['minPrice'] = minPrice.toString();
    if (maxPrice != null) params['maxPrice'] = maxPrice.toString();
    if (searchTerm != null) params['searchTerm'] = searchTerm;
    if (culinarySpecialties != null && culinarySpecialties!.isNotEmpty) {
      params['culinarySpecialties'] = culinarySpecialties;
    }

    return params;
  }
}
