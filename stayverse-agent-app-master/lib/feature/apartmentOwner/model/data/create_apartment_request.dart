import 'package:dio/dio.dart' as dio;

class CreateApartmentRequest {
  final String? apartmentName;
  final String? details;
  final String? address;
  final String? placeId;
  final String? apartmentType;
  final int? numberOfBedrooms;
  final List<String>? amenities;
  final double? pricePerDay;
  final double? cautionFee;
  final String? houseRules;
  final int? maxGuests;
  final String? checkIn;
  final String? checkOut;
  final List<dynamic>? apartmentImages;

  CreateApartmentRequest({
    this.apartmentName,
    this.details,
    this.address,
    this.placeId,
    this.apartmentType,
    this.numberOfBedrooms,
    this.amenities,
    this.pricePerDay,
    this.cautionFee,
    this.houseRules,
    this.maxGuests,
    this.checkIn,
    this.checkOut,
    this.apartmentImages,
  });

  CreateApartmentRequest copyWith({
    String? apartmentName,
    String? details,
    String? address,
    String? placeId,
    String? apartmentType,
    int? numberOfBedrooms,
    List<String>? amenities,
    double? pricePerDay,
    double? cautionFee,
    String? houseRules,
    int? maxGuests,
    String? checkIn,
    String? checkOut,
    List<dynamic>? apartmentImages,
  }) =>
      CreateApartmentRequest(
        apartmentName: apartmentName ?? this.apartmentName,
        details: details ?? this.details,
        address: address ?? this.address,
        placeId: placeId ?? this.placeId,
        apartmentType: apartmentType ?? this.apartmentType,
        numberOfBedrooms: numberOfBedrooms ?? this.numberOfBedrooms,
        amenities: amenities ?? this.amenities,
        pricePerDay: pricePerDay ?? this.pricePerDay,
        cautionFee: cautionFee ?? this.cautionFee,
        houseRules: houseRules ?? this.houseRules,
        maxGuests: maxGuests ?? this.maxGuests,
        checkIn: checkIn ?? this.checkIn,
        checkOut: checkOut ?? this.checkOut,
        apartmentImages: apartmentImages ?? this.apartmentImages,
      );

  factory CreateApartmentRequest.fromJson(Map<String, dynamic> json) =>
      CreateApartmentRequest(
        apartmentName: json["apartmentName"],
        details: json["details"],
        address: json["address"],
        placeId: json["placeId"],
        apartmentType: json["apartmentType"],
        numberOfBedrooms: json["numberOfBedrooms"],
        amenities: json["amenities"] == null
            ? []
            : List<String>.from(json["amenities"].map((x) => x)),
        pricePerDay: json["pricePerDay"]?.toDouble(),
        cautionFee: json["cautionFee"]?.toDouble(),
        houseRules: json["houseRules"],
        maxGuests: json["maxGuests"],
        checkIn: json["checkIn"],
        checkOut: json["checkOut"],
        apartmentImages: json["apartmentImages"] == null
            ? []
            : List<dynamic>.from(json["apartmentImages"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "apartmentName": apartmentName,
        "details": details,
        "address": address,
        "placeId": placeId,
        "apartmentType": apartmentType,
        "numberOfBedrooms": numberOfBedrooms,
        "amenities": amenities == null
            ? []
            : List<dynamic>.from(amenities!.map((x) => x)),
        "pricePerDay": pricePerDay,
        "cautionFee": cautionFee,
        "houseRules": houseRules,
        "maxGuests": maxGuests,
        "checkIn": checkIn,
        "checkOut": checkOut,
        "apartmentImages": apartmentImages == null
            ? []
            : List<dynamic>.from(apartmentImages!.map((x) => x)),
      };
}


dio.FormData buildApartmentFormData(CreateApartmentRequest request) {
  final formData = dio.FormData();
  
  _addTextFields(formData, request);
  _addAmenities(formData, request.amenities);
  _addImageFiles(formData, request.apartmentImages);
 
  return formData;
  
}

void _addTextFields(dio.FormData formData, CreateApartmentRequest request) {
  final fields = <String, dynamic>{
    'apartmentName': request.apartmentName,
    'details': request.details,
    'address': request.address,
    'placeId': request.placeId,
    'apartmentType': request.apartmentType?.toLowerCase(),
    'numberOfBedrooms': request.numberOfBedrooms?.toString(),
    'pricePerDay': request.pricePerDay?.toString(),
    'cautionFee': request.cautionFee?.toString(),
    'houseRules': request.houseRules,
    'maxGuests': request.maxGuests?.toString(),
    'checkIn': request.checkIn,
    'checkOut': request.checkOut,
  };
  
  // Add all non-null fields to form data
  fields.forEach((key, value) {
    if (value != null) {
      formData.fields.add(MapEntry(key, value));
    }
  });
}

void _addAmenities(dio.FormData formData, List<String>? amenities) {
  if (amenities == null || amenities.isEmpty) return;
  
  for (int i = 0; i < amenities.length; i++) {
    formData.fields.add(MapEntry('amenities[$i]', amenities[i]));
  }
}

void _addImageFiles(dio.FormData formData, List<dynamic>? images) {
  if (images == null || images.isEmpty) return;
  
  for (final image in images) {
    if (image is dio.MultipartFile) {
      formData.files.add(MapEntry('apartmentImages', image));
    }
  }
}