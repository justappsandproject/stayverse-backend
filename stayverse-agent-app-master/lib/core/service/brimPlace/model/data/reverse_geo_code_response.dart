
class ReverseGeoResponse {
    final PlusCode? plusCode;
    final List<Result>? results;
    final String? status;

    ReverseGeoResponse({
        this.plusCode,
        this.results,
        this.status,
    });

    ReverseGeoResponse copyWith({
        PlusCode? plusCode,
        List<Result>? results,
        String? status,
    }) => 
        ReverseGeoResponse(
            plusCode: plusCode ?? this.plusCode,
            results: results ?? this.results,
            status: status ?? this.status,
        );

    factory ReverseGeoResponse.fromJson(Map<String, dynamic> json) => ReverseGeoResponse(
        plusCode: json["plus_code"] == null ? null : PlusCode.fromJson(json["plus_code"]),
        results: json["results"] == null ? [] : List<Result>.from(json["results"]!.map((x) => Result.fromJson(x))),
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "plus_code": plusCode?.toJson(),
        "results": results == null ? [] : List<dynamic>.from(results!.map((x) => x.toJson())),
        "status": status,
    };
}

class PlusCode {
    final String? compoundCode;
    final String? globalCode;

    PlusCode({
        this.compoundCode,
        this.globalCode,
    });

    PlusCode copyWith({
        String? compoundCode,
        String? globalCode,
    }) => 
        PlusCode(
            compoundCode: compoundCode ?? this.compoundCode,
            globalCode: globalCode ?? this.globalCode,
        );

    factory PlusCode.fromJson(Map<String, dynamic> json) => PlusCode(
        compoundCode: json["compound_code"],
        globalCode: json["global_code"],
    );

    Map<String, dynamic> toJson() => {
        "compound_code": compoundCode,
        "global_code": globalCode,
    };
}

class Result {
    final List<AddressComponent>? addressComponents;
    final String? formattedAddress;
    final Geometry? geometry;
    final String? placeId;
    final PlusCode? plusCode;
    final List<String>? types;

    Result({
        this.addressComponents,
        this.formattedAddress,
        this.geometry,
        this.placeId,
        this.plusCode,
        this.types,
    });

    Result copyWith({
        List<AddressComponent>? addressComponents,
        String? formattedAddress,
        Geometry? geometry,
        String? placeId,
        PlusCode? plusCode,
        List<String>? types,
    }) => 
        Result(
            addressComponents: addressComponents ?? this.addressComponents,
            formattedAddress: formattedAddress ?? this.formattedAddress,
            geometry: geometry ?? this.geometry,
            placeId: placeId ?? this.placeId,
            plusCode: plusCode ?? this.plusCode,
            types: types ?? this.types,
        );

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        addressComponents: json["address_components"] == null ? [] : List<AddressComponent>.from(json["address_components"]!.map((x) => AddressComponent.fromJson(x))),
        formattedAddress: json["formatted_address"],
        geometry: json["geometry"] == null ? null : Geometry.fromJson(json["geometry"]),
        placeId: json["place_id"],
        plusCode: json["plus_code"] == null ? null : PlusCode.fromJson(json["plus_code"]),
        types: json["types"] == null ? [] : List<String>.from(json["types"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "address_components": addressComponents == null ? [] : List<dynamic>.from(addressComponents!.map((x) => x.toJson())),
        "formatted_address": formattedAddress,
        "geometry": geometry?.toJson(),
        "place_id": placeId,
        "plus_code": plusCode?.toJson(),
        "types": types == null ? [] : List<dynamic>.from(types!.map((x) => x)),
    };
}

class AddressComponent {
    final String? longName;
    final String? shortName;
    final List<String>? types;

    AddressComponent({
        this.longName,
        this.shortName,
        this.types,
    });

    AddressComponent copyWith({
        String? longName,
        String? shortName,
        List<String>? types,
    }) => 
        AddressComponent(
            longName: longName ?? this.longName,
            shortName: shortName ?? this.shortName,
            types: types ?? this.types,
        );

    factory AddressComponent.fromJson(Map<String, dynamic> json) => AddressComponent(
        longName: json["long_name"],
        shortName: json["short_name"],
        types: json["types"] == null ? [] : List<String>.from(json["types"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "long_name": longName,
        "short_name": shortName,
        "types": types == null ? [] : List<dynamic>.from(types!.map((x) => x)),
    };
}

class Geometry {
    final Location? location;
    final String? locationType;
    final Bounds? viewport;
    final Bounds? bounds;

    Geometry({
        this.location,
        this.locationType,
        this.viewport,
        this.bounds,
    });

    Geometry copyWith({
        Location? location,
        String? locationType,
        Bounds? viewport,
        Bounds? bounds,
    }) => 
        Geometry(
            location: location ?? this.location,
            locationType: locationType ?? this.locationType,
            viewport: viewport ?? this.viewport,
            bounds: bounds ?? this.bounds,
        );

    factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        location: json["location"] == null ? null : Location.fromJson(json["location"]),
        locationType: json["location_type"],
        viewport: json["viewport"] == null ? null : Bounds.fromJson(json["viewport"]),
        bounds: json["bounds"] == null ? null : Bounds.fromJson(json["bounds"]),
    );

    Map<String, dynamic> toJson() => {
        "location": location?.toJson(),
        "location_type": locationType,
        "viewport": viewport?.toJson(),
        "bounds": bounds?.toJson(),
    };
}

class Bounds {
    final Location? northeast;
    final Location? southwest;

    Bounds({
        this.northeast,
        this.southwest,
    });

    Bounds copyWith({
        Location? northeast,
        Location? southwest,
    }) => 
        Bounds(
            northeast: northeast ?? this.northeast,
            southwest: southwest ?? this.southwest,
        );

    factory Bounds.fromJson(Map<String, dynamic> json) => Bounds(
        northeast: json["northeast"] == null ? null : Location.fromJson(json["northeast"]),
        southwest: json["southwest"] == null ? null : Location.fromJson(json["southwest"]),
    );

    Map<String, dynamic> toJson() => {
        "northeast": northeast?.toJson(),
        "southwest": southwest?.toJson(),
    };
}

class Location {
    final double? lat;
    final double? lng;

    Location({
        this.lat,
        this.lng,
    });

    Location copyWith({
        double? lat,
        double? lng,
    }) => 
        Location(
            lat: lat ?? this.lat,
            lng: lng ?? this.lng,
        );

    factory Location.fromJson(Map<String, dynamic> json) => Location(
        lat: json["lat"]?.toDouble(),
        lng: json["lng"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
    };
}
